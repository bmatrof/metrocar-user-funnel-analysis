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
