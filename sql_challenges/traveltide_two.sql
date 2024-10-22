/*
Question #1:
return users who have booked and completed at least 10 flights, ordered by user_id.

Expected column names: `user_id`
*/

-- q1 solution:

SELECT
  s.user_id
FROM
  flights f
  INNER JOIN sessions s ON f.trip_id = s.trip_id
WHERE
  s.flight_booked = true AND 
  s.cancellation IS NOT true AND 
  f.departure_time IS NOT null
GROUP BY
  user_id
HAVING
  COUNT(s.user_id) > 9


/*

Question #2: 
Write a solution to report the trip_id of sessions where:

1. session resulted in a booked flight
2. booking occurred in May, 2022
3. booking has the maximum flight discount on that respective day.

If in one day there are multiple such transactions, return all of them.

Expected column names: `trip_id`

*/

-- q2 solution:

WITH
  ranked_discounts AS (
    SELECT
      s.trip_id,
      s.session_start,
      s.flight_discount,
      s.flight_discount_amount,
      RANK() OVER (PARTITION BY CAST(s.session_start AS DATE)
        ORDER BY s.flight_discount_amount DESC
      ) AS discount_ranking
    FROM
      sessions s
    WHERE
      EXTRACT(MONTH FROM s.session_start) = 5 AND 
    	EXTRACT(YEAR FROM s.session_start) = 2022 AND 
    	s.flight_discount = true AND 
    	s.cancellation IS NOT true AND 
    	s.trip_id IS NOT null
  )
SELECT
  r.trip_id
FROM
  ranked_discounts r
WHERE
  r.discount_ranking = 1

/*
Question #3: 
Write a solution that will, for each user_id of users with greater than 10 flights, 
find out the largest window of days between 
the departure time of a flight and the departure time 
of the next departing flight taken by the user.

Expected column names: `user_id`, `biggest_window`

*/

-- q3 solution:

WITH flight_count AS (
  SELECT
  	s.user_id,
  	COUNT(*) AS total_flights
  FROM
   flights f
  JOIN sessions s ON f.trip_id = s.trip_id
  GROUP BY 
  	s.user_id
  HAVING
  	COUNT(*) >10
),
	date_differences AS (
  SELECT
		s.user_id,
  	f.departure_time::DATE AS departure_date,
  	f.departure_time::DATE - LAG(f.departure_time::DATE) 
  		OVER(PARTITION BY s.user_id ORDER BY f.departure_time ASC) AS flight_date_difference
	FROM
		flights f
	JOIN sessions s ON f.trip_id = s.trip_id
	WHERE s.user_id IN (SELECT user_id FROM flight_count)
)
SELECT 
	d.user_id,
  MAX(flight_date_difference) AS biggest_window
FROM
	date_differences d
GROUP BY
	d.user_id

/*
Question #4: 
Find the user_id’s of people whose origin airport is Boston (BOS) 
and whose first and last flight were to the same destination. 
Only include people who have flown out of Boston at least twice.

Expected column names: user_id
*/

-- q4 solution:

WITH user_list AS (
  SELECT
  	s.user_id,
		f.departure_time,
  	f.destination_airport,
  	FIRST_VALUE(f.destination_airport) OVER(PARTITION BY s.user_id ORDER BY f.departure_time ASC
                                            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS first_destination,
    LAST_VALUE(f.destination_airport) OVER(PARTITION BY s.user_id ORDER BY f.departure_time ASC
                                           ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_destination
	FROM
		sessions s
	JOIN flights f ON s.trip_id = f.trip_id
	WHERE
		f.origin_airport = 'BOS' AND
  	s.cancellation = false
)

SELECT
	user_id
FROM
  user_list 
GROUP BY
  user_id, first_destination, last_destination
HAVING
  COUNT(*) >=2 AND
  first_destination = last_destination

