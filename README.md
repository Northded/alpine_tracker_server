# Alpine Tracker Backend

Простое REST API приложение для учёта восхождений на горы, управления группами альпинистов и учёта данных о горах.

## Технологии

- **FastAPI** - современный веб-фреймворк для создания API
- **SQLAlchemy** - ORM для работы с базой данных
- **PostgreSQL** - реляционная база данных
- **Docker & Docker Compose** - контейнеризация приложения
- **Alembic** - инструмент для миграций базы данных
- **Pydantic** - валидация данных

## Быстрый старт

### Запуск с Docker Compose

```bash
docker-compose up --build
```

Приложение будет доступно:
- API: http://localhost:8000
- Swagger документация: http://localhost:8000/docs
- ReDoc документация: http://localhost:8000/redoc

### Локальный запуск

```bash
python -m venv venv
source venv/bin/activate  # Linux/Mac
pip install -r requirements.txt
alembic upgrade head
uvicorn app.main:app --reload
```

## API Эндпоинты

### Mountains (Горы)
- `GET /mountains/` - получить список всех гор
- `POST /mountains/` - создать новую гору
- `PUT /mountains/{id}` - обновить гору
- `DELETE /mountains/{id}` - удалить гору

### Climbers (Альпинисты)
- `GET /climbers/` - получить список всех альпинистов
- `POST /climbers/` - создать нового альпиниста
- `PUT /climbers/{id}` - обновить альпиниста
- `DELETE /climbers/{id}` - удалить альпиниста

### Groups (Группы)
- `GET /groups/` - получить список всех групп
- `POST /groups/` - создать новую группу
- `PUT /groups/{id}` - обновить группу
- `DELETE /groups/{id}` - удалить группу

### Ascents (Восхождения)
- `GET /ascents/` - получить список всех восхождений
- `POST /ascents/` - создать новое восхождение
- `PUT /ascents/{id}` - обновить восхождение
- `DELETE /ascents/{id}` - удалить восхождение

## Модели данных

- **Mountain** - гора (название, высота, местоположение, сложность)
- **Climber** - альпинист (имя, опыт, национальность)
- **Group** - группа (название, дата, альпинисты)
- **Ascent** - восхождение (гора, группа, дата, статус)
