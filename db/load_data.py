import pandas as pd
from sqlalchemy import create_engine, text
import time
import os

# Wait for PostgreSQL to be ready
time.sleep(10)

# Database connection parameters
DB_PARAMS = {
    'host': os.getenv('POSTGRES_HOST', 'localhost'),
    'database': os.getenv('POSTGRES_DB', 'enterprise_analytics'),
    'user': os.getenv('POSTGRES_USER', 'test_user'),
    'password': os.getenv('POSTGRES_PASSWORD', 'password'),
    'port': 5432
}

def load_csv_to_db(file_name, table_name):
    """Load a CSV file into PostgreSQL"""
    try:
        # Create SQLAlchemy engine
        engine = create_engine(
            f'postgresql://{DB_PARAMS["user"]}:{DB_PARAMS["password"]}@{DB_PARAMS["host"]}:{DB_PARAMS["port"]}/{DB_PARAMS["database"]}'
        )
        
        # Truncate the table first
        with engine.connect() as conn:
            conn.execute(text(f"TRUNCATE TABLE crm_raw.{table_name} CASCADE"))
            conn.commit()
        
        # Read CSV file
        df = pd.read_csv(f'/data/{file_name}', sep=';')
        
        # Convert timestamp columns if they exist
        timestamp_columns = ['created_at', 'happened_at']
        for col in timestamp_columns:
            if col in df.columns:
                df[col] = pd.to_datetime(df[col])
        
        # Load data into PostgreSQL
        df.to_sql(
            table_name,
            engine,
            schema='crm_raw',
            if_exists='append',
            index=False
        )
        
        print(f"Loaded {len(df)} rows into {table_name}")
    except Exception as e:
        print(f"Error loading {file_name} into {table_name}: {e}")

def main():
    # Load each CSV file in order
    csv_files = [
        ('stores.csv', 'stores'),
        ('devices.csv', 'devices'),
        ('transactions.csv', 'transactions')
    ]
    
    for csv_file, table_name in csv_files:
        if os.path.exists(f'/data/{csv_file}'):
            print(f"Loading {csv_file}...")
            load_csv_to_db(csv_file, table_name)
        else:
            print(f"Warning: {csv_file} not found")

if __name__ == "__main__":
    main() 