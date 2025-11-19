import pytest

pytestmark = pytest.mark.integration


class TestValidation:
    def test_mountain_height_must_be_positive(self, client):
        """
        Критический тест: высота горы должна быть положительной.
        """
        # Попытка создать гору с отрицательной высотой
        invalid_data = {
            "name": "Invalid Mountain",
            "height": -1000,  
            "location": "Test Location",
            "difficulty": "Низкая"
        }
        
        response = client.post("/mountains/", json=invalid_data)
        
        assert response.status_code == 422, \
            f"ОШИБКА! Сервер принял отрицательную высоту! " \
            f"Получен код {response.status_code} вместо 422. " \
            f"Валидация не работает!"
