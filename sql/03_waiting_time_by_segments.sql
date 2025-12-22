-- Waiting time analysis
-- Simple checks to understand delays and cancellations


--------------------------------------------------
-- 1. Average waiting time: cancelled vs completed
--------------------------------------------------

SELECT
    'cancelled' AS ride_type,
    AVG(EXTRACT(EPOCH FROM (accept_ts - request_ts)) / 60) AS avg_wait_minutes
FROM ride_requests
WHERE cancel_ts IS NOT NULL
  AND accept_ts IS NOT NULL

UNION ALL

SELECT
    'completed' AS ride_type,
    AVG(EXTRACT(EPOCH FROM (accept_ts - request_ts)) / 60) AS avg_wait_minutes
FROM ride_requests
WHERE dropoff_ts IS NOT NULL
  AND accept_ts IS NOT NULL;


--------------------------------------------------
-- 2. Waiting time by hour
--------------------------------------------------

SELECT
    EXTRACT(HOUR FROM request_ts) AS request_hour,
    AVG(EXTRACT(EPOCH FROM (accept_ts - request_ts)) / 60) AS avg_wait_minutes
FROM ride_requests
WHERE accept_ts IS NOT NULL
GROUP BY request_hour
ORDER BY request_hour;


--------------------------------------------------
-- 3. Waiting time by platform
--------------------------------------------------

SELECT
    d.platform,
    AVG(EXTRACT(EPOCH FROM (r.accept_ts - r.request_ts)) / 60) AS avg_wait_minutes
FROM ride_requests r
JOIN signups s
    ON r.user_id = s.user_id
JOIN app_downloads d
    ON s.session_id = d.app_download_key
WHERE r.accept_ts IS NOT NULL
GROUP BY d.platform;

