import pytest

pytestmark = pytest.mark.integration


class TestClimbersAPI:
    """Интеграционные тесты для Climbers API"""
    
    def test_create_climber_endpoint(self, client):
        """Тест создания альпиниста через API"""
        climber_data = {
            "name": "Алексей Смирнов",
            "experience": "Опытный",
            "nationality": "Россия"
        }
        
        response = client.post("/climbers/", json=climber_data)
        
        assert response.status_code == 201 
        data = response.json()
        assert data["name"] == "Алексей Смирнов"
        assert data["experience"] == "Опытный"
        assert "id" in data
    
    def test_get_climbers_list(self, client):
        """Тест получения списка альпинистов"""
        response = client.get("/climbers/")
        
        assert response.status_code == 200
        assert isinstance(response.json(), list)
    
    def test_full_climber_lifecycle(self, client):
        """Тест полного жизненного цикла альпиниста"""
        create_response = client.post("/climbers/", json={
            "name": "Тест Тестов",
            "experience": "Новичок",
            "nationality": "Россия"
        })
        assert create_response.status_code == 201  
        climber_id = create_response.json()["id"]
        
        get_response = client.get(f"/climbers/{climber_id}")
        assert get_response.status_code == 200
        assert get_response.json()["name"] == "Тест Тестов"
        
        update_response = client.put(
            f"/climbers/{climber_id}",
            json={"experience": "Любитель"}
        )
        assert update_response.status_code == 200
        assert update_response.json()["experience"] == "Любитель"
        
        delete_response = client.delete(f"/climbers/{climber_id}")
        assert delete_response.status_code == 204  
        
        final_get = client.get(f"/climbers/{climber_id}")
        assert final_get.status_code == 404
