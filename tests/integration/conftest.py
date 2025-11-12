import pytest
import os
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool
from app.database import Base, get_db

os.environ["TESTING"] = "1"

from app.main import app

@pytest.fixture(scope="function")
def test_db():
    """Создание in-memory тестовой БД для интеграционных тестов"""
    database_url = "sqlite:///:memory:"
    
    engine = create_engine(
        database_url,
        connect_args={"check_same_thread": False},
        poolclass=StaticPool, 
    )
    
    Base.metadata.create_all(bind=engine)
    
    TestingSessionLocal = sessionmaker(
        autocommit=False, 
        autoflush=False, 
        bind=engine
    )
    
    def override_get_db():
        db = TestingSessionLocal()
        try:
            yield db
        finally:
            db.close()
    
    app.dependency_overrides[get_db] = override_get_db
    
    yield engine
    
    Base.metadata.drop_all(bind=engine)
    engine.dispose()
    app.dependency_overrides.clear()

@pytest.fixture(scope="function")
def client(test_db):
    """Тестовый клиент FastAPI для интеграционных тестов"""
    with TestClient(app) as test_client:
        yield test_client
