-- Funnel overview
-- Shows how users move through main funnel steps
-- From app download to completed ride
WITH funnel_steps AS (
    SELECT
        funnel_step,
        funnel_name,
        SUM(number_of_users) AS users
    FROM funnel_analysis
    GROUP BY funnel_step, funnel_name
),
start_step AS (
    SELECT users AS start_users
    FROM funnel_steps
    WHERE funnel_step = 1
)
SELECT
    f.funnel_step,
    f.funnel_name,
    f.users,
    f.users * 1.0 / s.start_users AS conversion_from_start
FROM funnel_steps f
CROSS JOIN start_step s
ORDER BY f.funnel_step;

-- Funnel after ride completion
-- Completed ride → payment → review

SELECT 'completed_rides' AS step, COUNT(*) AS total
FROM ride_requests
WHERE dropoff_ts IS NOT NULL
UNION ALL
SELECT 'payments_completed', COUNT(*)
FROM transactions
UNION ALL
SELECT 'reviews_submitted', COUNT(*)
FROM reviews;


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


