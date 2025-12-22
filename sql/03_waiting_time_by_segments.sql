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
-- 2. Waiting time by platform
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
GROUP BY d.platform
ORDER BY avg_wait_minutes DESC;
