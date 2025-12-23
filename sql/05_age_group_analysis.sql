-- Age group analysis
-- Shows which age groups most often complete their first ride
-- Helps identify the most valuable user segments

SELECT
    s.age_range,
    COUNT(DISTINCT r.user_id) AS completed_users
FROM ride_requests r
JOIN signups s ON r.user_id = s.user_id
WHERE r.dropoff_ts IS NOT NULL
GROUP BY s.age_range
ORDER BY completed_users DESC;

