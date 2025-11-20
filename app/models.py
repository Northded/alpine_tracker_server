<<<<<<< HEAD
from datetime import datetime
from sqlalchemy import Column, DateTime, Integer, String, Float, Date, ForeignKey, Table, Enum as SQLEnum
=======
from sqlalchemy import DateTime, Column, Integer, String, Float, Date, ForeignKey, Table, Enum as SQLEnum
>>>>>>> cedeae0 (WIP: незакоммиченные изменения перед rebase)
from sqlalchemy.orm import relationship
from app.database import Base
import enum
from datetime import datetime

class DifficultyLevel(str, enum.Enum):
    LOW = "Низкая"
    MEDIUM = "Средняя"
    HIGH = "Высокая"
    EXTREME = "Экстремальная"


class ExperienceLevel(str, enum.Enum):
    BEGINNER = "Новичок"
    AMATEUR = "Любитель"
    EXPERIENCED = "Опытный"
    PROFESSIONAL = "Профессионал"


class AscentStatus(str, enum.Enum):
    PLANNED = "Запланировано"
    IN_PROGRESS = "В процессе"
    COMPLETED = "Завершено"
    CANCELLED = "Отменено"


# Ассоциативная таблица для связи многие-ко-многим между группами и альпинистами
group_climbers = Table(
    'group_climbers',
    Base.metadata,
    Column('group_id', Integer, ForeignKey('groups.id', ondelete='CASCADE')),
    Column('climber_id', Integer, ForeignKey('climbers.id', ondelete='CASCADE'))
)


class Mountain(Base):
    __tablename__ = 'mountains'

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False, unique=True)
    height = Column(Integer, nullable=False)
    location = Column(String, nullable=False)
    difficulty = Column(SQLEnum(DifficultyLevel), nullable=False)

    created_at = Column(DateTime, default=datetime.utcnow, nullable=True)

    ascents = relationship("Ascent", back_populates="mountain", cascade="all, delete-orphan")


class Climber(Base):
    __tablename__ = 'climbers'

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    experience = Column(SQLEnum(ExperienceLevel), nullable=False)
    nationality = Column(String, nullable=False)

    groups = relationship("Group", secondary=group_climbers, back_populates="climbers")


class Group(Base):
    __tablename__ = 'groups'

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False, unique=True)
    formation_date = Column(Date, nullable=False)

    climbers = relationship("Climber", secondary=group_climbers, back_populates="groups")
    ascents = relationship("Ascent", back_populates="group", cascade="all, delete-orphan")


class Ascent(Base):
    __tablename__ = 'ascents'

    id = Column(Integer, primary_key=True, index=True)
    mountain_id = Column(Integer, ForeignKey('mountains.id', ondelete='CASCADE'), nullable=False)
    group_id = Column(Integer, ForeignKey('groups.id', ondelete='CASCADE'), nullable=False)
    date = Column(Date, nullable=False)
    status = Column(SQLEnum(AscentStatus), nullable=False)
    notes = Column(String, nullable=True)

    mountain = relationship("Mountain", back_populates="ascents")
    group = relationship("Group", back_populates="ascents")

class Equipment(Base):
    __tablename__ = 'equipment'

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    equipment_type = Column(String, nullable=False)
    condition = Column(String, nullable=True)
    purchase_date = Column(Date, nullable=True)
