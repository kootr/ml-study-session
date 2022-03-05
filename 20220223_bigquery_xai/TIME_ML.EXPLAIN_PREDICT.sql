SELECT
  *
FROM
  ML.EXPLAIN_FORECAST(MODEL session8.nyc_citibike_arima_model,
                      STRUCT(365 AS horizon, 0.9 AS confidence_level))
WHERE EXTRACT(DATE from time_series_timestamp) > '2016-10-01'