\c enterprise_analytics;

-- Create schema in raw database
CREATE SCHEMA IF NOT EXISTS crm_raw;

-- Create tables in raw.crm schema
CREATE TABLE IF NOT EXISTS crm_raw.stores (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100),
    address VARCHAR(200),
    city VARCHAR(100),
    country VARCHAR(100),
    created_at TIMESTAMP,
    typology VARCHAR(50),
    customer_id INTEGER
);

CREATE TABLE IF NOT EXISTS crm_raw.devices (
    id INTEGER PRIMARY KEY,
    type INTEGER,
    store_id INTEGER REFERENCES crm_raw.stores(id)
);

CREATE TABLE IF NOT EXISTS crm_raw.transactions (
    id INTEGER PRIMARY KEY,
    device_id INTEGER REFERENCES crm_raw.devices(id),
    product_name VARCHAR(100),
    product_sku VARCHAR(50),
    category_name VARCHAR(50),
    amount DECIMAL(10,2),
    status VARCHAR(20),
    card_number VARCHAR(50),
    cvv VARCHAR(4),
    created_at TIMESTAMP,
    happened_at TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_store_id_devices ON crm_raw.devices(store_id);
CREATE INDEX IF NOT EXISTS idx_store_typology ON crm_raw.stores(typology);
CREATE INDEX IF NOT EXISTS idx_store_country ON crm_raw.stores(country);
CREATE INDEX IF NOT EXISTS idx_device_id_transactions ON crm_raw.transactions(device_id);
CREATE INDEX IF NOT EXISTS idx_transaction_status ON crm_raw.transactions(status);
CREATE INDEX IF NOT EXISTS idx_transaction_happened_at ON crm_raw.transactions(happened_at);
CREATE INDEX IF NOT EXISTS idx_transaction_product_sku ON crm_raw.transactions(product_sku);

-- Grant permissions on raw database
GRANT ALL PRIVILEGES ON SCHEMA crm_raw TO test_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA crm_raw TO test_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA crm_raw GRANT ALL ON TABLES TO test_user;

-- Create schemas
CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS intermediate;
CREATE SCHEMA IF NOT EXISTS marts;

-- Grant permissions on enterprise_analytics database
GRANT ALL PRIVILEGES ON SCHEMA staging TO test_user;
GRANT ALL PRIVILEGES ON SCHEMA intermediate TO test_user;
GRANT ALL PRIVILEGES ON SCHEMA marts TO test_user;

-- Grant default privileges for future tables
ALTER DEFAULT PRIVILEGES IN SCHEMA staging GRANT ALL ON TABLES TO test_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA intermediate GRANT ALL ON TABLES TO test_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA marts GRANT ALL ON TABLES TO test_user;