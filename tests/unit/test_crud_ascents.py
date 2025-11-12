import pytest
import datetime
from app import crud, schemas
from app.models import DifficultyLevel, ExperienceLevel, AscentStatus

pytestmark = pytest.mark.unit


class TestAscentCRUD:
    """Юнит-тесты для CRUD операций с восхождениями"""
    
    def test_create_ascent(self, db_session):
        """Тест создания восхождения"""
        mountain = crud.create_mountain(db_session, schemas.MountainCreate(
            name="Тестовая гора",
            height=5000,
            location="Тестовая локация",
            difficulty=DifficultyLevel.MEDIUM
        ))
        
        group = crud.create_group(db_session, schemas.GroupCreate(
            name="Тестовая группа",
            formation_date=datetime.date(2024, 1, 1),
            climber_ids=[]
        ))
        
        ascent_data = schemas.AscentCreate(
            mountain_id=mountain.id,
            group_id=group.id,
            date=datetime.date(2024, 6, 15),
            status=AscentStatus.PLANNED,
            notes="Тестовое восхождение"
        )
        ascent = crud.create_ascent(db_session, ascent_data)
        
        assert ascent.id is not None
        assert ascent.mountain_id == mountain.id
        assert ascent.group_id == group.id
        assert ascent.status == AscentStatus.PLANNED
        assert ascent.notes == "Тестовое восхождение"
    
    def test_update_ascent_status(self, db_session):
        """Тест обновления статуса восхождения"""
        mountain = crud.create_mountain(db_session, schemas.MountainCreate(
            name="Гора для восхождения",
            height=4000,
            location="Горы",
            difficulty=DifficultyLevel.LOW
        ))
        
        group = crud.create_group(db_session, schemas.GroupCreate(
            name="Группа альпинистов",
            formation_date=datetime.date(2024, 2, 1),
            climber_ids=[]
        ))
        
        ascent = crud.create_ascent(db_session, schemas.AscentCreate(
            mountain_id=mountain.id,
            group_id=group.id,
            date=datetime.date(2024, 7, 1),
            status=AscentStatus.PLANNED,
            notes="Планируемое восхождение"
        ))
        
        update_data = schemas.AscentUpdate(status=AscentStatus.COMPLETED)
        updated = crud.update_ascent(db_session, ascent.id, update_data)
        
        assert updated is not None
        assert updated.status == AscentStatus.COMPLETED
