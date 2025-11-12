import pytest
from app import crud, schemas
from app.models import DifficultyLevel

pytestmark = pytest.mark.unit


class TestMountainCRUD:
    """Юнит-тесты для CRUD операций с горами"""
    
    def test_create_mountain_success(self, db_session):
        """Тест успешного создания горы"""
        mountain_data = schemas.MountainCreate(
            name="Эльбрус",
            height=5642,
            location="Кавказ",
            difficulty=DifficultyLevel.HIGH
        )
        
        mountain = crud.create_mountain(db_session, mountain_data)
        
        assert mountain.id is not None
        assert mountain.name == "Эльбрус"
        assert mountain.height == 5642
        assert mountain.location == "Кавказ"
        assert mountain.difficulty == DifficultyLevel.HIGH
    
    def test_get_mountain_by_id(self, db_session):
        """Тест получения горы по ID"""
        mountain_data = schemas.MountainCreate(
            name="Эверест",
            height=8848,
            location="Гималаи",
            difficulty=DifficultyLevel.EXTREME
        )
        created = crud.create_mountain(db_session, mountain_data)
        
        retrieved = crud.get_mountain(db_session, created.id)
        
        assert retrieved is not None
        assert retrieved.id == created.id
        assert retrieved.name == "Эверест"
    
    def test_get_mountain_not_found(self, db_session):
        """Тест получения несуществующей горы"""
        result = crud.get_mountain(db_session, 99999)
        
        assert result is None
    
    def test_get_mountains_list(self, db_session):
        """Тест получения списка гор"""
        mountains_data = [
            schemas.MountainCreate(
                name="Гора 1",
                height=1000,
                location="Локация 1",
                difficulty=DifficultyLevel.LOW
            ),
            schemas.MountainCreate(
                name="Гора 2",
                height=2000,
                location="Локация 2",
                difficulty=DifficultyLevel.MEDIUM
            )
        ]
        
        for mountain_data in mountains_data:
            crud.create_mountain(db_session, mountain_data)
        
        mountains = crud.get_mountains(db_session)
        
        assert len(mountains) >= 2
        assert any(m.name == "Гора 1" for m in mountains)
        assert any(m.name == "Гора 2" for m in mountains)
    
    def test_update_mountain(self, db_session):
        """Тест обновления горы"""
        mountain_data = schemas.MountainCreate(
            name="Монблан",
            height=4808,
            location="Альпы",
            difficulty=DifficultyLevel.MEDIUM
        )
        created = crud.create_mountain(db_session, mountain_data)
        
        update_data = schemas.MountainUpdate(
            height=4809,
            difficulty=DifficultyLevel.HIGH
        )
        updated = crud.update_mountain(db_session, created.id, update_data)
        
        assert updated is not None
        assert updated.height == 4809
        assert updated.difficulty == DifficultyLevel.HIGH
        assert updated.name == "Монблан"
    
    def test_delete_mountain(self, db_session):
        """Тест удаления горы"""
        mountain_data = schemas.MountainCreate(
            name="Для удаления",
            height=3000,
            location="Где-то",
            difficulty=DifficultyLevel.LOW
        )
        created = crud.create_mountain(db_session, mountain_data)
        
        result = crud.delete_mountain(db_session, created.id)
        
        assert result is True
        
        deleted = crud.get_mountain(db_session, created.id)
        assert deleted is None
    
    def test_delete_nonexistent_mountain(self, db_session):
        """Тест удаления несуществующей горы"""
        result = crud.delete_mountain(db_session, 99999)
        
        assert result is False
