-- Waiting time by segments
-- Focus: where waiting time is the highest


--------------------------------------------------
-- 1. Waiting time by hour of day
--------------------------------------------------

SELECT
    EXTRACT(HOUR FROM request_ts) AS request_hour,
    AVG(EXTRACT(EPOCH FROM (accept_ts - request_ts)) / 60) AS avg_wait_minutes
FROM ride_requests
WHERE accept_ts IS NOT NULL
GROUP BY request_hour
ORDER BY request_hour;


--------------------------------------------------
-- 2. Funnel by platform
--------------------------------------------------

-- Download = unique app_download_key (people who downloaded, even without signup)
-- Next steps = unique users

-- 1) Download
SELECT
    platform,
    1 AS step_order,
    'Download' AS funnel_step,
    COUNT(DISTINCT app_download_key) AS users
FROM app_downloads
GROUP BY platform

UNION ALL

-- 2) Signup
SELECT
    d.platform,
    2 AS step_order,
    'Signup' AS funnel_step,
    COUNT(DISTINCT s.user_id) AS users
FROM signups s
JOIN app_downloads d
    ON s.session_id = d.app_download_key
GROUP BY d.platform

UNION ALL

-- 3) Ride Requested
SELECT
    d.platform,
    3 AS step_order,
    'Ride Requested' AS funnel_step,
    COUNT(DISTINCT s.user_id) AS users
FROM ride_requests r
JOIN signups s
    ON r.user_id = s.user_id
JOIN app_downloads d
    ON s.session_id = d.app_download_key
WHERE r.request_ts IS NOT NULL
GROUP BY d.platform

UNION ALL

-- 4) Ride Completed
SELECT
    d.platform,
    4 AS step_order,
    'Ride Completed' AS funnel_step,
    COUNT(DISTINCT s.user_id) AS users
FROM ride_requests r
JOIN signups s
    ON r.user_id = s.user_id
JOIN app_downloads d
    ON s.session_id = d.app_download_key
WHERE r.dropoff_ts IS NOT NULL
GROUP BY d.platform

UNION ALL

-- 5) Review
SELECT
    d.platform,
    5 AS step_order,
    'Review' AS funnel_step,
    COUNT(DISTINCT s.user_id) AS users
FROM reviews rv
JOIN ride_requests r
    ON rv.ride_id = r.ride_id
JOIN signups s
    ON r.user_id = s.user_id
JOIN app_downloads d
    ON s.session_id = d.app_download_key
WHERE r.dropoff_ts IS NOT NULL
GROUP BY d.platform

ORDER BY platform, step_order;
