#standardSQL
CREATE or REPLACE MODEL `<YOUR_DATASET_NAME>.model_titanic`
OPTIONS (
  model_type = 'logistic_reg'
  -- num_trials=20,
  -- max_parallel_trials=2
  ) AS (
SELECT
  Pclass, Title, isAlone, Age, Sex, Embarked, Fare, AgeClass, Survived AS label
FROM
  `<YOUR_DATASET_NAME>.train`
WHERE PassengerId BETWEEN 1 AND 712
)