import pytest
from app import crud, schemas
from app.models import ExperienceLevel

pytestmark = pytest.mark.unit


class TestClimberCRUD:
    """Юнит-тесты для CRUD операций с альпинистами"""
    
    def test_create_climber(self, db_session):
        """Тест создания альпиниста"""
        climber_data = schemas.ClimberCreate(
            name="Иван Петров",
            experience=ExperienceLevel.EXPERIENCED,
            nationality="Россия"
        )
        
        climber = crud.create_climber(db_session, climber_data)
        
        assert climber.id is not None
        assert climber.name == "Иван Петров"
        assert climber.experience == ExperienceLevel.EXPERIENCED
        assert climber.nationality == "Россия"
    
    def test_get_climber_by_id(self, db_session):
        """Тест получения альпиниста по ID"""
        climber_data = schemas.ClimberCreate(
            name="Анна Смирнова",
            experience=ExperienceLevel.PROFESSIONAL,
            nationality="Россия"
        )
        created = crud.create_climber(db_session, climber_data)
        
        retrieved = crud.get_climber(db_session, created.id)
        
        assert retrieved is not None
        assert retrieved.id == created.id
        assert retrieved.name == "Анна Смирнова"
    
    def test_update_climber_experience(self, db_session):
        """Тест обновления уровня опыта альпиниста"""
        climber_data = schemas.ClimberCreate(
            name="Новичок",
            experience=ExperienceLevel.BEGINNER,
            nationality="Казахстан"
        )
        created = crud.create_climber(db_session, climber_data)
        
        update_data = schemas.ClimberUpdate(
            experience=ExperienceLevel.AMATEUR
        )
        updated = crud.update_climber(db_session, created.id, update_data)
        
        assert updated is not None
        assert updated.experience == ExperienceLevel.AMATEUR
        assert updated.name == "Новичок"
    
    def test_delete_climber(self, db_session):
        """Тест удаления альпиниста"""
        climber_data = schemas.ClimberCreate(
            name="Для удаления",
            experience=ExperienceLevel.BEGINNER,
            nationality="Беларусь"
        )
        created = crud.create_climber(db_session, climber_data)
        
        result = crud.delete_climber(db_session, created.id)
        
        assert result is True
        assert crud.get_climber(db_session, created.id) is None
