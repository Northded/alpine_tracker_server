import pytest

pytestmark = pytest.mark.integration


class TestAscentsAPI:
    """Интеграционные тесты для Ascents API"""
    
    def test_create_ascent_full_flow(self, client):
        """Тест полного сценария создания восхождения"""
        mountain = client.post("/mountains/", json={
            "name": "Тестовая гора",
            "height": 5000,
            "location": "Горы",
            "difficulty": "Средняя"
        }).json()
        

        group = client.post("/groups/", json={
            "name": "Группа восхождения",
            "formation_date": "2024-01-01",
            "climber_ids": []
        }).json()
        

        ascent_response = client.post("/ascents/", json={
            "mountain_id": mountain["id"],
            "group_id": group["id"],
            "date": "2024-07-01",
            "status": "Запланировано",
            "notes": "Тестовое восхождение"
        })
        
        assert ascent_response.status_code == 201 
        ascent_data = ascent_response.json()
        assert ascent_data["mountain_id"] == mountain["id"]
        assert ascent_data["group_id"] == group["id"]
        assert ascent_data["status"] == "Запланировано"
    
    def test_update_ascent_status_flow(self, client):
        """Тест обновления статуса восхождения"""

        mountain = client.post("/mountains/", json={
            "name": "Гора",
            "height": 4000,
            "location": "Где-то",
            "difficulty": "Низкая"
        }).json()
        
        group = client.post("/groups/", json={
            "name": "Группа",
            "formation_date": "2024-02-01",
            "climber_ids": []
        }).json()
        
        ascent = client.post("/ascents/", json={
            "mountain_id": mountain["id"],
            "group_id": group["id"],
            "date": "2024-08-01",
            "status": "Запланировано",
            "notes": ""
        }).json()
        

        update_response = client.put(
            f"/ascents/{ascent['id']}",
            json={"status": "Завершено"}
        )
        
        assert update_response.status_code == 200
        assert update_response.json()["status"] == "Завершено"
