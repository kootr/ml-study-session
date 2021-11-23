#standardSQL
SELECT
 date,
 new_confirmed_count AS history_value,
 NULL AS forecast_value,
 NULL AS prediction_interval_lower_bound,
 NULL AS prediction_interval_upper_bound
FROM  `<YOUR_PROJECT_NAME>.<YOUR_DATASET_NAME>.<YOUR_TABLE_NAME>`
WHERE prefecture = '全国'
UNION ALL
SELECT
 EXTRACT(DATE from forecast_timestamp) AS date,
 NULL AS history_value,
 forecast_value,
 prediction_interval_lower_bound,
 prediction_interval_upper_bound
FROM
 ML.FORECAST(MODEL `<YOUR_PROJECT_NAME>.<YOUR_DATASET_NAME>.<YOUR_MODEL_NAME>`,
  STRUCT(50 AS horizon, 0.8 AS confidence_level) -- 信頼区間80%の上限と下限
)