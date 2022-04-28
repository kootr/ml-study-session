CREATE OR REPLACE MODEL session10.taxi_tip_classification_model_demo
OPTIONS
 (model_type='logistic_reg',
  input_label_cols=['tip_bucket'],
  -- enable_global_explain=true
  model_registry='vertex_ai',
  vertex_ai_model_id='taxi_tip_classification_model',
  vertex_ai_model_version_aliases=['logistic_reg', 'experimental']
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
  -- AND pickup_datetime >= '2018-10-01' AND dropoff_datetime < '2018-10-02'
  AND pickup_datetime >= '2018-11-02' AND dropoff_datetime < '2018-11-03'
  