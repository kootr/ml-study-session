SELECT *
FROM
ML.PREDICT(MODEL session8.taxi_tip_classification_model,
 (
 SELECT
   "0" AS vendor_id,
   1 AS passenger_count,
   CAST(5.85 AS NUMERIC) AS trip_distance,
   "0" AS rate_code,
   "0" AS payment_type,
   CAST(55.56 AS NUMERIC) AS total_amount))
