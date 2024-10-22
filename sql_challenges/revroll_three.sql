/*
Question #1: 
Identify installers who have participated in at least one installer competition by name.

Expected column names: name
*/

-- q1 solution:

SELECT DISTINCT
  installers.name
FROM
  (
    SELECT
      install_derby.installer_one_id AS participant_id
    FROM
      install_derby
    UNION
    SELECT
      install_derby.installer_two_id
    FROM
      install_derby
  ) AS unique_installers
  INNER JOIN installers ON installers.installer_id = unique_installers.participant_id


/*
Question #2: 
Write a solution to find the third transaction of every customer, where the spending on the preceding two transactions is lower than the spending on the third
transaction. Only consider transactions that include an installation, and return the result table by customer_id in ascending order.

Expected column names: customer_id, third_transaction_spend, third_transaction_date

*/

-- q2 solution:

WITH
  install_order_rank AS (
    SELECT
      customer_id,
      price,
      install_date,
      ROW_NUMBER() OVER (
        PARTITION BY
          customer_id
        ORDER BY
          install_date ASC
      ) as install_sequence
    FROM
      orders
      LEFT JOIN parts ON orders.part_id = parts.part_id
      LEFT JOIN installs ON orders.order_id = installs.order_id
  )
SELECT
  a.customer_id,
  a.price AS third_transaction_spend,
  a.install_date AS third_transaction_date
FROM
  install_order_rank a
WHERE
  a.install_sequence = 3
  AND price > (
    SELECT
      MAX(b.price)
    FROM
      install_order_rank b
    WHERE
      b.customer_id = a.customer_id
      AND b.install_sequence IN (1, 2)
  )

/*
Question #3: 
Write a solution to report the most expensive part in each order. In case of a tie, report all parts with the maximum price. 
Order by order_id and limit the output to 5 rows.

Expected column names: order_id, part_id

*/

-- q3 solution:

WITH
  PriceRanks AS (
    SELECT
      o.order_id,
      p.part_id,
      p.price,
      RANK() OVER (
        PARTITION BY
          o.order_id
        ORDER BY
          p.price DESC
      ) AS price_rank
    FROM
      orders o
      INNER JOIN installs i ON o.order_id = i.order_id
      INNER JOIN parts p ON o.part_id = p.part_id
  )
SELECT
  order_id,
  part_id
FROM
  PriceRanks
WHERE
  price_rank = 1
ORDER BY
  order_id,
  part_id
LIMIT
  5

/*
Question #4: 
Write a query to find the installers who have completed installations for at least four consecutive days. 
Include the installer_id, start date of the consecutive installations period and the end date of the consecutive installations period. 


Return the result table ordered by installer_id in ascending order.


Expected column names: installer_id, consecutive_start, consecutive_end
*/

-- q4 solution:

WITH
  ranked_installations AS (
    SELECT
      installer_id,
      install_date,
      (
        EXTRACT(
          DOY
          FROM
            install_date
        ) - ROW_NUMBER() OVER (
          PARTITION BY
            installer_id
          ORDER BY
            install_date
        )
      ) AS group_identifier
    FROM
      installs
  )
SELECT
  installer_id,
  MIN(install_date) AS consecutive_days_start,
  MAX(install_date) AS consecutive_days_end
FROM
  ranked_installations
GROUP BY
  installer_id,
  group_identifier
HAVING
  COUNT(*) >= 4

