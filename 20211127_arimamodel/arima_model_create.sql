#standardSQL
CREATE OR REPLACE MODEL
<YOUR_DATASET_NAME>.<YOUR_MODEL_NAME>
OPTIONS(model_type = 'ARIMA_PLUS'
   , time_series_timestamp_col = 'date'
   , time_series_data_col = 'new_confirmed_count'
   , auto_arima = TRUE
   , AUTO_ARIMA_MAX_ORDER = 5
   , data_frequency = 'DAILY'
   , decompose_time_series = TRUE) AS
SELECT
  date,
  new_confirmed_count
FROM
  `<YOUR_PROJECT_NAME>.<YOUR_DATASET_NAME>.<YOUR_TABLE_NAME>`
WHERE prefecture = '全国'