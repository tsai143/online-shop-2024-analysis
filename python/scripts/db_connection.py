# db_connection.py
# Centralized MySQL connection logic
# Used by notebooks and scripts

from sqlalchemy import create_engine


def get_mysql_engine():
    """
    Creates and returns a SQLAlchemy engine for MySQL connection.
    """
    username = "root"
    password = "1433"
    host = "localhost"
    port = 3306
    database = "online_shop_2024"

    connection_string = (
        f"mysql+pymysql://{username}:{password}@{host}:{port}/{database}"
    )

    engine = create_engine(connection_string)
    return engine
