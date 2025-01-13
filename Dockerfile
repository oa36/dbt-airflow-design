FROM apache/airflow:2.7.1

USER root

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    ssh-client \
    software-properties-common \
    make \
    build-essential \
    ca-certificates \
    libpq-dev \
    python3-venv

USER airflow

# Create and activate virtual environment for dbt
RUN python -m venv ${HOME}/dbt_venv && \
    ${HOME}/dbt_venv/bin/pip install --no-cache-dir --no-user \
    'dbt-core>=1.8.0,<1.9.0' \
    'dbt-postgres>=1.8.0,<1.9.0'

# Install Python packages
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt 

RUN mkdir -p /opt/airflow/logs && \
    chown -R airflow:root /opt/airflow/logs && \
    chmod -R 777 /opt/airflow/logs 

ENV AIRFLOW__CORE__LOAD_DEFAULT_CONNECTIONS=False 