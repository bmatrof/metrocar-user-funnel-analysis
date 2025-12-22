-- Drop-off analysis
-- Completed vs cancelled rides

SELECT
    COUNT(*) FILTER (WHERE dropoff_ts IS NOT NULL) AS completed_rides,
    COUNT(*) FILTER (WHERE cancel_ts IS NOT NULL) AS cancelled_rides
FROM ride_requests;

-- Check waiting time for rides
-- Average waiting time (minutes)

SELECT
  AVG(EXTRACT(EPOCH FROM (accept_ts - request_ts)) / 60)
    FILTER (WHERE cancel_ts IS NOT NULL) AS avg_wait_cancelled,
  AVG(EXTRACT(EPOCH FROM (accept_ts - request_ts)) / 60)
    FILTER (WHERE dropoff_ts IS NOT NULL) AS avg_wait_completed
FROM ride_requests
WHERE accept_ts IS NOT NULL;
