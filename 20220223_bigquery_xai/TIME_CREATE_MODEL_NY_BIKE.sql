CREATE OR REPLACE MODEL session8.nyc_citibike_arima_model
OPTIONS
  (model_type = 'ARIMA_PLUS',
   time_series_timestamp_col = 'date',
   time_series_data_col = 'num_trips',
   holiday_region = 'US'
  ) AS
SELECT
   EXTRACT(DATE from starttime) AS date,
   COUNT(*) AS num_trips
FROM
  `bigquery-public-data.new_york.citibike_trips`  -- -- 2013-07-01 ~ 2016-09-30
GROUP BY date
