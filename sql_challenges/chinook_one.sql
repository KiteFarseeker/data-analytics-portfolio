/*
Question #1: 
Write a solution to find the employee_id of managers with at least 2 direct reports.

Expected column names: employee_id
*/

-- q1 solution:

SELECT 
	reports_to AS employee_id
FROM 
	employee
WHERE 
	reports_to IS NOT NULL
GROUP BY 
	reports_to
HAVING 
	COUNT(*) >= 2


/*
Question #2: 
Calculate total revenue for MPEG-4 video files purchased in 2024.

Expected column names: total_revenue
*/

-- q2 solution:

SELECT
  SUM(i.unit_price) AS total_revenue
FROM
	invoice_line i
JOIN
	track t ON i.track_id = t.track_id
JOIN
	invoice iv ON i.invoice_id = iv.invoice_id
WHERE
	t.media_type_id = 3 AND
  EXTRACT(YEAR FROM iv.invoice_date) = 2024

/*
Question #3: 
For composers appearing in classical playlists, count the number of distinct playlists they appear on and create a comma separated list of the corresponding 
(distinct) playlist names.

Expected column names: composer, distinct_playlists, list_of_playlists
*/

-- q3 solution:

SELECT 
    t.composer,
    COUNT(DISTINCT p.playlist_id) AS distinct_playlists,
    STRING_AGG(DISTINCT p.name, ', ' ORDER BY p.name) AS list_of_playlists
FROM 
    playlist p
JOIN 
    playlist_track pt ON p.playlist_id = pt.playlist_id
JOIN 
    track t ON pt.track_id = t.track_id
WHERE 
    p.name ILIKE '%Classical%'
    AND t.composer IS NOT NULL
GROUP BY 
    t.composer
ORDER BY 
    t.composer

/*
Question #4: 
Find customers whose yearly total spending is strictly increasing*.

*read the hints!

Expected column names: customer_id
*/

-- q4 solution:

WITH yearly_spending AS (
    SELECT
        c.customer_id,
        SUM(i.total) AS total_by_year,
        EXTRACT(YEAR FROM i.invoice_date) AS invoice_year
    FROM
        customer c
    JOIN
        invoice i ON c.customer_id = i.customer_id
    WHERE 
        EXTRACT(YEAR FROM i.invoice_date) != 2025
    GROUP BY
        c.customer_id, EXTRACT(YEAR FROM i.invoice_date)
),
comparison AS (
    SELECT
        customer_id,
        invoice_year,
        total_by_year,
        LAG(total_by_year) OVER (PARTITION BY customer_id ORDER BY invoice_year) AS previous_year_total
    FROM
        yearly_spending
)

SELECT DISTINCT
    customer_id
FROM
    comparison
GROUP BY
    customer_id
HAVING
    COUNT(CASE WHEN total_by_year > previous_year_total THEN 1 END) = COUNT(*) - 1

