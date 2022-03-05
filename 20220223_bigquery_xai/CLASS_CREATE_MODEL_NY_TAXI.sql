CREATE OR REPLACE MODEL session8.taxi_tip_classification_model
OPTIONS
 (model_type='logistic_reg',
  input_label_cols=['tip_bucket'],
  enable_global_explain=true
) AS
SELECT
  vendor_id,
  passenger_count,
  trip_distance,
  rate_code,
  payment_type,
  total_amount,
  CASE
    WHEN tip_amount > total_amount*0.20 THEN '20% or more'
    WHEN tip_amount > total_amount*0.15 THEN '15% to 20%'
    WHEN tip_amount > total_amount*0.10 THEN '10% to 15%'
  ELSE '10% or less'
  END AS tip_bucket
FROM
  `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2018`
WHERE tip_amount >= 0
LIMIT 1000000