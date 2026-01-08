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


