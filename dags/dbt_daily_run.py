import os
from cosmos import DbtDag, ProjectConfig, ProfileConfig, ExecutionConfig
from cosmos.profiles import PostgresUserPasswordProfileMapping
from datetime import datetime

# Define project directory and dbt executable path
project_dir = "/usr/local/airflow/dbt"
dbt_executable = "/home/airflow/dbt_venv/bin/dbt"

# Configure profile settings
profile_config = ProfileConfig(
    profile_name="default",
    target_name="prod",
    profile_mapping=PostgresUserPasswordProfileMapping(
        conn_id="analytics_db",
        profile_args={
            "schema": "marts",
            "database": "enterprise_analytics"
        },
    ),
)

# Create the DAG
dbt_dag = DbtDag(
    project_config=ProjectConfig(project_dir),
    profile_config=profile_config,
    execution_config=ExecutionConfig(
        dbt_executable_path=dbt_executable,
    ),
    schedule_interval="@daily",
    start_date=datetime(2023, 1, 1),
    catchup=False,
    dag_id="dbt_daily_run",
    default_args={
        "retries": 0,
        "owner": "airflow"
    },
) 