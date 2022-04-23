#standardSQL
SELECT
 * 
FROM
  ML.PREDICT(MODEL `<YOUR_DATASET_NAME>.model_titanic`, (
  SELECT
    PassengerId, Pclass, Title, Sex, Age, Fare, Embarked, IsAlone, Age_Class
  FROM
    `<YOUR_DATASET_NAME>.test`
  )
)