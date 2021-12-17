#standardSQL
WITH predict_table AS (
SELECT
 date,
 new_confirmed_count AS history_value,
 NULL AS forecast_value,
 NULL AS prediction_interval_lower_bound,
 NULL AS prediction_interval_upper_bound
FROM  `<YOUR_PROJECT_NAME>.<YOUR_DATASET_NAME>.<YOUR_TABLE_NAME_OF_COVID_TABLE>`
WHERE prefecture = '全国'
UNION ALL
SELECT
 EXTRACT(DATE from forecast_timestamp) AS date,
 NULL AS history_value,
 forecast_value,
 prediction_interval_lower_bound,
 prediction_interval_upper_bound
FROM
 ML.FORECAST(MODEL `<YOUR_PROJECT_NAME>.<YOUR_DATASET_NAME>.<YOUR_MODEL_NAME_OF_ARIMA>`,
  STRUCT(30 AS horizon, 0.8 AS confidence_level) -- 信頼区間80%の上限と下限
  )
),
actual_value AS ( --  2021-11-01 ~ 2021-12-11 の実際の値を取得
WITH
  name AS (
  SELECT
    DISTINCT(prefecture_code) AS prefecture_code,
    prefecture_name_kanji
  FROM
    `bigquery-public-data.covid19_public_forecasts.japan_prefecture_28d` ),
  daily_japan_cases AS (
  SELECT
    date,
    location_key,
    SUM(new_confirmed) AS new_confirmed_count,
    SUM(new_deceased) AS new_deceased_count
  FROM
    `bigquery-public-data.covid19_open_data.covid19_open_data`
  WHERE
    country_code = "JP"
    AND location_key != "JP"
    AND date > CURRENT_DATE() - 120
    AND date <= CURRENT_DATE()
  GROUP BY
    ROLLUP(date,
      location_key)
  ORDER BY
    date DESC),
  daily_japan_cases_with_name AS (
  SELECT
    date,
    COALESCE(name.prefecture_code,
      "JP-ALL") AS prefecture_code,
    daily_japan_cases.new_confirmed_count,
    daily_japan_cases.new_deceased_count,
    COALESCE(name.prefecture_name_kanji,
      "全国") AS prefecture,
  FROM
    daily_japan_cases
  LEFT JOIN
    name
  ON
    REPLACE(daily_japan_cases.location_key, '_', '-') = name.prefecture_code )
SELECT
  date,
  new_confirmed_count,
FROM
  daily_japan_cases_with_name
WHERE
  new_confirmed_count IS NOT NULL
  AND new_deceased_count IS NOT NULL
  AND prefecture = '全国'
  AND date >= '2021-11-01'
  AND date < '2021-12-12' -- 実行時点で12/12のデータが最新だったので
-- ORDER BY
--   date DESC
)
SELECT
  actual_value.date,
--   predict_table.history_value,
  predict_table.forecast_value,
  actual_value.new_confirmed_count AS actual_value,
--   predict_table.prediction_interval_lower_bound,
--   predict_table.prediction_interval_upper_bound
  FROM predict_table RIGHT JOIN actual_value ON predict_table.date = actual_value.date
  ORDER BY date DESC
