import pytest

pytestmark = pytest.mark.integration


class TestGroupsAPI:
    """Интеграционные тесты для Groups API"""
    
    def test_create_group_with_climbers_flow(self, client):
        """Тест создания группы с альпинистами через API"""

        climber1 = client.post("/climbers/", json={
            "name": "Альпинист 1",
            "experience": "Профессионал",
            "nationality": "Россия"
        }).json()
        
        climber2 = client.post("/climbers/", json={
            "name": "Альпинист 2",
            "experience": "Опытный",
            "nationality": "Казахстан"
        }).json()
        

        group_response = client.post("/groups/", json={
            "name": "Экспедиция",
            "formation_date": "2024-06-01",
            "climber_ids": [climber1["id"], climber2["id"]]
        })
        
        assert group_response.status_code == 201  
        group_data = group_response.json()
        assert group_data["name"] == "Экспедиция"
        assert len(group_data["climbers"]) == 2
    
    def test_get_group_with_details(self, client):
        """Тест получения группы с деталями"""
        create_response = client.post("/groups/", json={
            "name": "Тестовая группа",
            "formation_date": "2024-03-15",
            "climber_ids": []
        })
        group_id = create_response.json()["id"]
        
        response = client.get(f"/groups/{group_id}")
        
        assert response.status_code == 200
        data = response.json()
        assert data["name"] == "Тестовая группа"
        assert "climbers" in data
