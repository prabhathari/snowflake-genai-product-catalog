import os
from dotenv import load_dotenv
from snowflake.snowpark import Session

load_dotenv()

def get_snowflake_session():
    """Create and return a Snowflake session"""
    connection_parameters = {
        "account": os.getenv("SNOWFLAKE_ACCOUNT"),
        "user": os.getenv("SNOWFLAKE_USER"),
        "password": os.getenv("SNOWFLAKE_PASSWORD"),
        "warehouse": os.getenv("SNOWFLAKE_WAREHOUSE"),
        "database": os.getenv("SNOWFLAKE_DATABASE"),
        "schema": os.getenv("SNOWFLAKE_SCHEMA")
    }
    return Session.builder.configs(connection_parameters).create()

# Test connection
if __name__ == "__main__":
    session = get_snowflake_session()
    result = session.sql("SELECT CURRENT_VERSION()").collect()
    print(f"✅ Connected to Snowflake version: {result[0][0]}")
    session.close()