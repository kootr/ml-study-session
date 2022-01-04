import os
import pandas as pd
from google.cloud import bigquery

from preprocess import process


def load_data(data, context):
    # check content-type
    if data["contentType"] != "text/csv":
        print("Not supported file type: {}".format(data["contentType"]))
        return
    bucket_name = data["bucket"]
    file_name = data["name"]
    uri = "gs://{}/{}".format(bucket_name, file_name)

    # NOTE: Please change the variables with your project
    project_id = "your_project_id"
    dataset_id = (
        project_id + "." + "your_dataset_id"
    )  # Please create a dataset with the same name in BigQuery in advance.
    table_id = dataset_id + "." + os.path.splitext(file_name)[0]  # Remove .csv

    df = pd.read_csv(uri)
    df = process(df)

    bq = bigquery.Client()

    job_config = bigquery.LoadJobConfig(
        autodetect=True, write_disposition="WRITE_TRUNCATE",
    )

    job = bq.load_table_from_dataframe(df, table_id, job_config=job_config)
    job.result()

    table = bq.get_table(table_id)
    print(
        "Loaded {} rows and {} columns to {}".format(
            table.num_rows, len(table.schema), table_id
        )
    )
