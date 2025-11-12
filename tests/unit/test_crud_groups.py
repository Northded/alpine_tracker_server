import pytest
import datetime
from app import crud, schemas
from app.models import ExperienceLevel

pytestmark = pytest.mark.unit


class TestGroupCRUD:
    """Юнит-тесты для CRUD операций с группами"""
    
    def test_create_group_without_climbers(self, db_session):
        """Тест создания пустой группы"""
        group_data = schemas.GroupCreate(
            name="Новая группа",
            formation_date=datetime.date(2024, 1, 1),
            climber_ids=[]
        )
        
        group = crud.create_group(db_session, group_data)
        
        assert group.id is not None
        assert group.name == "Новая группа"
        assert group.formation_date == datetime.date(2024, 1, 1)
        assert len(group.climbers) == 0
    
    def test_create_group_with_climbers(self, db_session):
        """Тест создания группы с альпинистами"""
        climber1 = crud.create_climber(db_session, schemas.ClimberCreate(
            name="Альпинист 1",
            experience=ExperienceLevel.PROFESSIONAL,
            nationality="Россия"
        ))
        climber2 = crud.create_climber(db_session, schemas.ClimberCreate(
            name="Альпинист 2",
            experience=ExperienceLevel.EXPERIENCED,
            nationality="Казахстан"
        ))
        
        group_data = schemas.GroupCreate(
            name="Экспедиция Эверест",
            formation_date=datetime.date(2024, 6, 1),
            climber_ids=[climber1.id, climber2.id]
        )
        group = crud.create_group(db_session, group_data)
        
        assert group.id is not None
        assert len(group.climbers) == 2
        climber_names = [c.name for c in group.climbers]
        assert "Альпинист 1" in climber_names
        assert "Альпинист 2" in climber_names
    
    def test_get_group_with_climbers(self, db_session):
        """Тест получения группы со списком альпинистов"""
        climber = crud.create_climber(db_session, schemas.ClimberCreate(
            name="Тестовый альпинист",
            experience=ExperienceLevel.AMATEUR,
            nationality="Украина"
        ))
        
        group = crud.create_group(db_session, schemas.GroupCreate(
            name="Тестовая группа",
            formation_date=datetime.date(2024, 3, 15),
            climber_ids=[climber.id]
        ))
        
        retrieved = crud.get_group(db_session, group.id)
        
        assert retrieved is not None
        assert len(retrieved.climbers) == 1
        assert retrieved.climbers[0].name == "Тестовый альпинист"
