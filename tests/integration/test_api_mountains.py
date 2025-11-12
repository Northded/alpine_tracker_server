import pytest

pytestmark = pytest.mark.integration


class TestMountainsAPI:
    """Интеграционные тесты для Mountains API"""
    
    def test_create_mountain_endpoint(self, client):
        """Тест создания горы через API"""
        mountain_data = {
            "name": "Казбек",
            "height": 5033,
            "location": "Кавказ",
            "difficulty": "Высокая"
        }
        
        response = client.post("/mountains/", json=mountain_data)
        
        assert response.status_code == 201 
        data = response.json()
        assert data["name"] == "Казбек"
        assert data["height"] == 5033
        assert data["location"] == "Кавказ"
        assert "id" in data
    
    def test_get_mountains_endpoint(self, client):
        """Тест получения списка гор через API"""
        response = client.get("/mountains/")
        
        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)
    
    def test_get_single_mountain_endpoint(self, client):
        """Тест получения одной горы через API"""
        create_response = client.post("/mountains/", json={
            "name": "Эльбрус",
            "height": 5642,
            "location": "Кавказ",
            "difficulty": "Высокая"
        })
        mountain_id = create_response.json()["id"]
        
        response = client.get(f"/mountains/{mountain_id}")
        
        assert response.status_code == 200
        data = response.json()
        assert data["name"] == "Эльбрус"
        assert data["id"] == mountain_id
    
    def test_update_mountain_endpoint(self, client):
        """Тест обновления горы через API"""
        create_response = client.post("/mountains/", json={
            "name": "Монблан",
            "height": 4808,
            "location": "Альпы",
            "difficulty": "Средняя"
        })
        mountain_id = create_response.json()["id"]
        
        update_response = client.put(
            f"/mountains/{mountain_id}",
            json={"height": 4809}
        )
        
        assert update_response.status_code == 200
        data = update_response.json()
        assert data["height"] == 4809
        assert data["name"] == "Монблан"
    
    def test_delete_mountain_endpoint(self, client):
        """Тест удаления горы через API"""
        create_response = client.post("/mountains/", json={
            "name": "Для удаления",
            "height": 3000,
            "location": "Где-то",
            "difficulty": "Низкая"
        })
        mountain_id = create_response.json()["id"]

        delete_response = client.delete(f"/mountains/{mountain_id}")
        
        assert delete_response.status_code == 204  
        
        get_response = client.get(f"/mountains/{mountain_id}")
        assert get_response.status_code == 404
