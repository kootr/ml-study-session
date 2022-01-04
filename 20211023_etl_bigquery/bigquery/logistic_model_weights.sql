#standardSQL
SELECT
  processed_input,
  weight
FROM
  ML.WEIGHTS(MODEL `<YOUR_DATASET_NAME>.model_titanic`)
ORDER BY ABS(weight) DESC