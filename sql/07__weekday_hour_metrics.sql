-- Weekday x Hour heatmap dataset
-- I group by request time (request_ts), because it is the start of the ride request.

SELECT
    EXTRACT(ISODOW FROM r.request_ts)::int AS weekday_num,
    CASE EXTRACT(ISODOW FROM r.request_ts)::int
        WHEN 1 THEN 'Mon'
        WHEN 2 THEN 'Tue'
        WHEN 3 THEN 'Wed'
        WHEN 4 THEN 'Thu'
        WHEN 5 THEN 'Fri'
        WHEN 6 THEN 'Sat'
        WHEN 7 THEN 'Sun'
    END AS weekday,
    EXTRACT(HOUR FROM r.request_ts)::int AS hour,

    -- how many ride requests happened in this weekday+hour
    COUNT(*) AS total_requests,

    -- average time from request to accept (minutes)
    ROUND(
        AVG(
            CASE
                WHEN r.accept_ts IS NOT NULL
                THEN EXTRACT(EPOCH FROM (r.accept_ts - r.request_ts)) / 60.0
            END
        ),
        2
    ) AS avg_accept_wait_minute,

    -- average time from accept to pickup (minutes)
    ROUND(
        AVG(
            CASE
                WHEN r.accept_ts IS NOT NULL AND r.pickup_ts IS NOT NULL
                THEN EXTRACT(EPOCH FROM (r.pickup_ts - r.accept_ts)) / 60.0
            END
        ),
        2
    ) AS avg_pickup_wait_minute,

    -- how many requests were cancelled
    SUM(CASE WHEN r.cancel_ts IS NOT NULL THEN 1 ELSE 0 END) AS cancelled_requests,

    -- cancelled / total (in %)
    ROUND(
        100.0 * SUM(CASE WHEN r.cancel_ts IS NOT NULL THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0),
        2
    ) AS cancellation_rate_pct

FROM ride_requests r
WHERE r.request_ts IS NOT NULL
GROUP BY 1, 2, 3
ORDER BY weekday_num, hour;
