-- Count users after a completed ride:
-- 1) users who submitted at least one review
-- 2) users who did not submit any review

WITH completed_users AS (
    -- users who have at least one completed ride
    SELECT DISTINCT user_id
    FROM ride_requests
    WHERE dropoff_ts IS NOT NULL
),
review_users AS (
    -- users who have at least one review
    SELECT DISTINCT user_id
    FROM reviews
)

SELECT
    CASE
        WHEN ru.user_id IS NOT NULL THEN 'Review submitted'
        ELSE 'No review'
    END AS post_ride_action,
    COUNT(DISTINCT cu.user_id) AS users_cnt
FROM completed_users cu
LEFT JOIN review_users ru
    ON cu.user_id = ru.user_id
GROUP BY 1
ORDER BY users_cnt DESC;









Extended thinking


