# 従来の ML.PREDICT 関数
SELECT *
FROM
ML.PREDICT(MODEL session8.taxi_tip_regression_model,
 (
 SELECT
   "0" AS vendor_id,
   2 AS passenger_count,
   CAST(5.85 AS NUMERIC) AS trip_distance,
   "0" AS rate_code,
   "0" AS payment_type,
   CAST(55.56 AS NUMERIC) AS total_amount))
