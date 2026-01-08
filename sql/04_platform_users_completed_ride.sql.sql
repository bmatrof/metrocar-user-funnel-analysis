
-- I want to see how many unique users completed at least one ride on each platform (android / ios / web).
-- I treat a ride as "completed" when dropoff_ts is NOT NULL.

SELECT
    d.platform,
    COUNT(DISTINCT r.user_id) AS users_with_completed_rides
FROM ride_requests r
-- ride_requests has the ride events (request, pickup, dropoff, cancel)
JOIN signups s
    ON r.user_id = s.user_id
-- signups links user_id to session_id
JOIN app_downloads d
    ON s.session_id = d.app_download_key
-- app_downloads gives me the platform for each session (android/ios/web)
WHERE r.dropoff_ts IS NOT NULL
-- if dropoff_ts exists, the ride was completed
GROUP BY d.platform
ORDER BY users_with_completed_rides DESC;
