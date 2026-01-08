-- Goal: count how many payments were approved vs declined
-- I normalize charge_status into 2 values: Approved / Declined
-- Then I count transactions for each status

SELECT
    CASE
        WHEN LOWER(TRIM(charge_status)) LIKE 'app%' THEN 'Approved'
        WHEN LOWER(TRIM(charge_status)) LIKE 'dec%' THEN 'Declined'
    END AS charge_status_norm,
    COUNT(*) AS payments_cnt
FROM transactions
WHERE charge_status IS NOT NULL
  AND (
      LOWER(TRIM(charge_status)) LIKE 'app%'
      OR LOWER(TRIM(charge_status)) LIKE 'dec%'
  )
GROUP BY 1
ORDER BY payments_cnt DESC;
