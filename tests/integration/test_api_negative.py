import pytest

pytestmark = pytest.mark.integration


class TestValidation:
    """Тесты валидации - должны провалиться если валидация сломана"""
    
    def test_mountain_height_must_be_positive(self, client):
        """
        Критический тест: высота горы должна быть положительной.
        Этот тест ПРОВАЛИТСЯ если убрать валидацию gt=0
        """
        # Попытка создать гору с отрицательной высотой
        invalid_data = {
            "name": "Invalid Mountain",
            "height": -1000,  # ОТРИЦАТЕЛЬНАЯ высота!
            "location": "Test Location",
            "difficulty": "Низкая"
        }
        
        response = client.post("/mountains/", json=invalid_data)
        
        # Ожидаем ошибку валидации
        assert response.status_code == 422, \
            f"ОШИБКА! Сервер принял отрицательную высоту! " \
            f"Получен код {response.status_code} вместо 422. " \
            f"Валидация не работает!"
