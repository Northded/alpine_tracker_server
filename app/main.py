from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.database import engine, Base
from app.routes import mountains, climbers, groups, ascents

# Создаем таблицы в БД
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="Alpine Tracker API",
    description="API для учёта восхождений, групп, альпинистов и гор",
    version="1.0.0"
)

# CORS middleware для работы с фронтендом
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Подключаем роутеры
app.include_router(mountains.router)
app.include_router(climbers.router)
app.include_router(groups.router)
app.include_router(ascents.router)


@app.get("/")
def root():
    return {
        "message": "Добро пожаловать в Alpine Tracker API",
        "docs": "/docs",
        "redoc": "/redoc"
    }


@app.get("/health")
def health_check():
    return {"status": "healthy"}
