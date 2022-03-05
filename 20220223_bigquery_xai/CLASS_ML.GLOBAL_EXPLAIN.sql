SELECT
  *
FROM
  ML.GLOBAL_EXPLAIN(MODEL session8.taxi_tip_classification_model)
ORDER BY attribution ASC