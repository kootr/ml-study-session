# tip_amount を予測
CREATE OR REPLACE MODEL session8.taxi_tip_regression_model
OPTIONS (model_type='boosted_tree_regressor',
         input_label_cols=['tip_amount'],
         max_iterations = 50,
         tree_method = 'HIST',
         subsample = 0.85,
         enable_global_explain = TRUE
) AS
SELECT
  vendor_id,
  passenger_count,
  trip_distance,
  rate_code,
  payment_type,
  total_amount,
  tip_amount
FROM
  `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2018`
WHERE tip_amount >= 0
LIMIT 1000000