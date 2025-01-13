# Enterprise Merchants Analytics Pipeline

A production-ready data pipeline that processes merchant transactions and store data using dbt Core, Apache Airflow, and PostgreSQL.

## Architecture

The pipeline consists of several key components:

1. **Analytics Database**
   - Currently uses PostgreSQL for demonstration
   - In production, a cloud data warehouse like Snowflake would be recommended for better scalability and performance

2. **Apache Airflow**
   - Runs in a Docker container
   - Uses PostgreSQL as its metadata database
   - Handles workflow orchestration and scheduling

3. **Cosmos**
   - Integrates dbt projects directly into Airflow DAGs
   - Provides better visibility and control over dbt transformations
   - Enables task-level monitoring and logging

4. **dbt Core**
   - Handles data transformations
   - Organized in layers: staging, intermediate, and marts
   - Manages data model dependencies

## Project Structure

enterprise_merchants_analytics/
├── .env.example                  # Example environment configuration
├── docker-compose.yml            # Container orchestration
├── Dockerfile                    # Airflow container config
├── requirements.txt              # Python dependencies
├── dbt-requirements.txt         # dbt specific dependencies
├── data/                        # Sample data directory
│   ├── transactions.csv
│   ├── stores.csv
│   └── devices.csv
├── db/                          #Anaytics Warehouse initialization
│   ├── Dockerfile
│   ├── init.sql
│   ├── load_data.py
│   └── requirements.txt
├── dbt/
│   ├── dbt_project.yml          # dbt configuration
│   ├── macros/                  # Reusable SQL logic
│   │   ├── get_custom_schema.sql
│   │   └── custom_tests.sql
│   └── models/
│       ├── staging/            # Raw data cleaning
│       ├── intermediate/       # Business logic
│       └── marts/              # Aggregated models
├── dags/                       # Airflow DAG definitions
│   └── dbt_daily_run.py       # Daily dbt pipeline

## Data Models

### Staging Layer
- `stg_devices`: Cleaned device data with standardized fields
- `stg_stores`: Cleaned store data with standardized fields
- `stg_transactions`: Cleaned transaction data with standardized fields

### Intermediate Layer
- `int_daily_transactions`: Daily transaction aggregations and metrics

### Marts Layer
- `fct_transactions`: Core transaction facts enriched with store and device dimensions

Each layer has its own `schema.yml` file that defines the model configurations, tests, and documentation.

## Design Decisions

### Why This Architecture?

1. **Modularity**
   - Separate staging, intermediate, and marts layers
   - Easy to maintain and extend
   - Clear data lineage

2. **Containerization**
   - Consistent environments
   - Easy deployment
   - Scalable infrastructure

3. **dbt Core vs dbt Cloud**
   - Complete control over infrastructure
   - Cost-effective for smaller teams
   - Better for learning and development

### Alternative: dbt Cloud
While this project uses dbt Core, [dbt Cloud](https://github.com/dbt-labs/airflow-dbt-cloud) is a viable alternative that offers:
- Managed infrastructure
- Web-based IDE
- Built-in scheduling
- Job monitoring
- Hosted documentation

Consider dbt Cloud when:
- You need enterprise features (SSO, access control)
- Team collaboration is a priority
- Infrastructure management overhead should be minimized
- Budget allows for managed service

## Setup Instructions

1. Clone the repository:
```
git clone <repository-url>
cd enterprise_merchants_analytics
```

2. Create and configure environment variables:
```bash
cp .env.example .env
# Edit .env with your credentials:
# POSTGRES_USER=airflow
# POSTGRES_PASSWORD=airflow
# POSTGRES_DB=airflow
```

3. Start the services:
```bash
docker-compose up -d
```

4. Access the services:
- Airflow UI: http://localhost:8080 (username: admin, password: admin)
- PostgreSQL: localhost:5433

## Usage

### Running the Pipeline

The pipeline runs automatically daily at 5 AM through Airflow, but you can also trigger it manually from the Airflow UI.

### Monitoring

1. **Airflow Dashboard**
   - View DAG runs and logs
   - Monitor task status
   - Trigger manual runs

2. **dbt Documentation**
   - Generate docs: `dbt docs generate`
   - Serve locally: `dbt docs serve`
  
## Data Ingestion

### Note on Data Source
For demonstration purposes, this project loads sample CSV data into a PostgreSQL analytics warehouse. In a production environment with large-scale data volumes (millions to billions of records), data would typically:

- Reside in operational databases (e.g., OLTP systems)
- Come from CRM platforms or other enterprise systems
- Be streamed through real-time data pipelines
- Be incrementally loaded using appropriate ETL/ELT tools (e.g., Fivetran, AWS Glue, etc.)

The current approach allows for easy project setup and testing, while the underlying data models and transformations remain applicable for production-scale implementations.

### Raw Data Storage
Sample data files are located in:
```
enterprise_merchants_analytics/
└── data/                   # Raw CSV files location
    ├── stores.csv         # Store master data
    ├── devices.csv        # Device information
    └── transactions.csv   # Transaction records
```

### Loading Process
Data is loaded into the PostgreSQL analytics warehouse through the following process:

1. **Initial Data Load**:
   - Raw CSV files are stored in the `data/` directory
   - The `db/load_data.py` script handles the data ingestion
   - Data is loaded into raw tables in the analytics warehouse
   - Database initialization is managed through `db/init.sql`

2. **dbt Transformations**:
   - Once raw data is loaded, dbt models transform it through staging, intermediate, and marts layers
   - Transformations are executed as part of the Airflow DAG
   - Models are configured in `dbt_project.yml` and organized by layer