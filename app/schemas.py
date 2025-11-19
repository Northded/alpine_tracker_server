import datetime
from typing import Optional, List
from pydantic import BaseModel, Field
from app.models import DifficultyLevel, ExperienceLevel, AscentStatus

# Mountain Schemas
class MountainBase(BaseModel):
    name: str = Field(..., description="Название горы")
    height: int = Field(..., description="Высота в метрах", gt=0)
    location: str = Field(..., description="Местоположение")
    difficulty: DifficultyLevel = Field(..., description="Уровень сложности")

class MountainCreate(MountainBase):
    pass

class MountainUpdate(BaseModel):
    name: Optional[str] = None
    height: Optional[int] = Field(None, gt=0)
    location: Optional[str] = None
    difficulty: Optional[DifficultyLevel] = None

class MountainResponse(MountainBase):
    id: int

    class Config:
        from_attributes = True

# Climber Schemas
class ClimberBase(BaseModel):
    name: str = Field(..., description="Имя альпиниста")
    experience: ExperienceLevel = Field(..., description="Уровень опыта")
    nationality: str = Field(..., description="Национальность")

class ClimberCreate(ClimberBase):
    pass

class ClimberUpdate(BaseModel):
    name: Optional[str] = None
    experience: Optional[ExperienceLevel] = None
    nationality: Optional[str] = None

class ClimberResponse(ClimberBase):
    id: int

    class Config:
        from_attributes = True

# Group Schemas
class GroupBase(BaseModel):
    name: str = Field(..., description="Название группы")
    formation_date: datetime.date = Field(..., description="Дата формирования")

class GroupCreate(GroupBase):
    climber_ids: List[int] = Field(default=[], description="ID альпинистов в группе")

class GroupUpdate(BaseModel):
    name: Optional[str] = None
    formation_date: Optional[datetime.date] = None
    climber_ids: Optional[List[int]] = None

class GroupResponse(GroupBase):
    id: int
    climbers: List[ClimberResponse] = []

    class Config:
        from_attributes = True

# Ascent Schemas
class AscentBase(BaseModel):
    mountain_id: int = Field(..., description="ID горы")
    group_id: int = Field(..., description="ID группы")
    date: datetime.date = Field(..., description="Дата восхождения")
    status: AscentStatus = Field(..., description="Статус восхождения")
    notes: Optional[str] = Field(None, description="Примечания")

class AscentCreate(AscentBase):
    pass

class AscentUpdate(BaseModel):
    mountain_id: Optional[int] = None
    group_id: Optional[int] = None
    date: Optional[datetime.date] = None
    status: Optional[AscentStatus] = None
    notes: Optional[str] = None

class AscentResponse(AscentBase):
    id: int

    class Config:
        from_attributes = True

class AscentDetailResponse(BaseModel):
    id: int
    date: datetime.date
    status: AscentStatus
    notes: Optional[str]
    mountain: MountainResponse
    group: GroupResponse

    class Config:
        from_attributes = True
