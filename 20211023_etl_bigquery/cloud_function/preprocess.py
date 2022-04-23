# pre-processing for titanic
# I used the following as a reference
# https://www.kaggle.com/startupsci/titanic-data-science-solutions

import numpy as np


def process(df):
    df = df.drop(["Ticket", "Cabin"], axis=1)
    df = add_title(df)
    df = label_encode(df)
    df = age(df)
    df = is_alone(df)
    df = port(df)
    df = fare(df)
    return df


def add_title(df):
    df["Title"] = df.Name.str.extract(" ([A-Za-z]+)\.", expand=False)
    df["Title"] = df["Title"].replace(
        [
            "Lady",
            "Countess",
            "Capt",
            "Col",
            "Don",
            "Dr",
            "Major",
            "Rev",
            "Sir",
            "Jonkheer",
            "Dona",
        ],
        "Rare",
    )
    df["Title"] = df["Title"].replace("Mlle", "Miss")
    df["Title"] = df["Title"].replace("Ms", "Miss")
    df["Title"] = df["Title"].replace("Mme", "Mrs")

    title_mapping = {"Mr": 1, "Miss": 2, "Mrs": 3, "Master": 4, "Rare": 5}

    df["Title"] = df["Title"].map(title_mapping)
    df["Title"] = df["Title"].fillna(0)
    df = df.drop(["Name"], axis=1)
    return df


def label_encode(df):
    df["Sex"] = df["Sex"].map({"female": 1, "male": 0}).astype(int)
    return df


def age(df):
    guess_ages = np.zeros((2, 3))

    for i in range(0, 2):
        for j in range(0, 3):
            guess_df = df[(df["Sex"] == i) & (df["Pclass"] == j + 1)]["Age"].dropna()

            age_guess = guess_df.median()

            # Convert random age float to nearest .5 age
            guess_ages[i, j] = int(age_guess / 0.5 + 0.5) * 0.5

    for i in range(0, 2):
        for j in range(0, 3):
            df.loc[
                (df.Age.isnull()) & (df.Sex == i) & (df.Pclass == j + 1), "Age"
            ] = guess_ages[i, j]

    df["Age"] = df["Age"].astype(int)
    df.loc[df["Age"] <= 16, "Age"] = 0
    df.loc[(df["Age"] > 16) & (df["Age"] <= 32), "Age"] = 1
    df.loc[(df["Age"] > 32) & (df["Age"] <= 48), "Age"] = 2
    df.loc[(df["Age"] > 48) & (df["Age"] <= 64), "Age"] = 3
    df.loc[df["Age"] > 64, "Age"]
    df["Age_Class"] = df.Age * df.Pclass
    return df


def is_alone(df):
    df["FamilySize"] = df["SibSp"] + df["Parch"] + 1
    df["IsAlone"] = 0
    df.loc[df["FamilySize"] == 1, "IsAlone"] = 1
    df = df.drop(["Parch", "SibSp", "FamilySize"], axis=1)
    return df


def port(df):
    freq_port = df.Embarked.dropna().mode()[0]
    df["Embarked"] = df["Embarked"].fillna(freq_port)
    df["Embarked"] = df["Embarked"].map({"S": 0, "C": 1, "Q": 2}).astype(int)
    return df


def fare(df):
    df["Fare"].fillna(df["Fare"].dropna().median(), inplace=True)
    df.loc[df["Fare"] <= 7.91, "Fare"] = 0
    df.loc[(df["Fare"] > 7.91) & (df["Fare"] <= 14.454), "Fare"] = 1
    df.loc[(df["Fare"] > 14.454) & (df["Fare"] <= 31), "Fare"] = 2
    df.loc[df["Fare"] > 31, "Fare"] = 3
    df["Fare"] = df["Fare"].astype(int)
    return df
