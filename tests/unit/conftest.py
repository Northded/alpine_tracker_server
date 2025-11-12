import pytest
from sqlalchemy.orm import sessionmaker, Session

@pytest.fixture(scope="function")
def db_session(test_engine) -> Session:
    """
    Создание изолированной сессии БД для каждого юнит-теста.
    Все изменения откатываются после теста.
    """
    connection = test_engine.connect()
    transaction = connection.begin()
    
    SessionLocal = sessionmaker(bind=connection)
    session = SessionLocal()
    
    yield session
    
    session.close()
    transaction.rollback()
    connection.close()
