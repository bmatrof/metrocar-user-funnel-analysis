-- Platform analysis
-- Shows how many users reach a completed ride on each platform
-- Used to understand where marketing budget should be focused


SELECT
    d.platform,
    COUNT(DISTINCT r.user_id) AS users_with_completed_rides
FROM ride_requests r
JOIN signups s ON r.user_id = s.user_id
JOIN app_downloads d ON s.session_id = d.app_download_key
WHERE r.dropoff_ts IS NOT NULL
GROUP BY d.platform
ORDER BY users_with_completed_rides DESC;
