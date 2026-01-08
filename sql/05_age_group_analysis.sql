
-- signed_users = unique users who signed up in each age group
-- completed_users = unique users who finished at least 1 ride (dropoff_ts is not null)
-- completion_rate = completed_users / signed_users

WITH signed AS (
    SELECT
        age_range,
        COUNT(DISTINCT user_id) AS signed_users
    FROM signups
    GROUP BY age_range
),
completed AS (
    SELECT
        s.age_range,
        COUNT(DISTINCT r.user_id) AS completed_users
    FROM ride_requests r
    JOIN signups s
        ON r.user_id = s.user_id
    WHERE r.dropoff_ts IS NOT NULL
    GROUP BY s.age_range
)

SELECT
    s.age_range AS age_range,
    s.signed_users,
    COALESCE(c.completed_users, 0) AS completed_users,
    ROUND(100.0 * COALESCE(c.completed_users, 0) / NULLIF(s.signed_users, 0), 2) AS completion_rate
FROM signed s
LEFT JOIN completed c
    ON s.age_range = c.age_range
ORDER BY completion_rate DESC;
