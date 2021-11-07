--  prefecture_code in .covid19_public_forecasts.japan_prefecture_28d` means ID of prefecture JP-26
-- location_key in covid19_open_data.covid19_open_data means ID of prefecture JP_26
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
    AND date > CURRENT_DATE() - 30
    AND date <= CURRENT_DATE()
  GROUP BY
    ROLLUP(date,
      location_key)
  ORDER BY
    date DESC ),
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
  prefecture,
  prefecture_code,
  new_confirmed_count,
  new_deceased_count
FROM
  daily_japan_cases_with_name
WHERE
  new_confirmed_count IS NOT NULL
  AND new_deceased_count IS NOT NULL
ORDER BY
  date DESC;