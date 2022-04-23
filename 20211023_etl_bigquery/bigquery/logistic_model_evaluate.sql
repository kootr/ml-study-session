#standardSQL
SELECT
 * 
FROM
  ML.EVALUATE(MODEL `<YOUR_DATASET_NAME>.model_titanic`, (
  SELECT
    Pclass, Title, Sex, Age, Fare, Embarked, IsAlone, Age_Class, Survived AS label
  FROM
    `<YOUR_DATASET_NAME>.train`
  WHERE PassengerId > 712
  )
)