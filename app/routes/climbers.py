from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app import crud, schemas
from app.database import get_db

router = APIRouter(prefix="/climbers", tags=["climbers"])


@router.get("/", response_model=List[schemas.ClimberResponse])
def read_climbers(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    """Получить список всех альпинистов"""
    climbers = crud.get_climbers(db, skip=skip, limit=limit)
    return climbers


@router.get("/{climber_id}", response_model=schemas.ClimberResponse)
def read_climber(climber_id: int, db: Session = Depends(get_db)):
    """Получить информацию о конкретном альпинисте"""
    climber = crud.get_climber(db, climber_id=climber_id)
    if climber is None:
        raise HTTPException(status_code=404, detail="Альпинист не найден")
    return climber


@router.post("/", response_model=schemas.ClimberResponse, status_code=201)
def create_climber(climber: schemas.ClimberCreate, db: Session = Depends(get_db)):
    """Создать нового альпиниста"""
    return crud.create_climber(db=db, climber=climber)


@router.put("/{climber_id}", response_model=schemas.ClimberResponse)
def update_climber(climber_id: int, climber: schemas.ClimberUpdate, db: Session = Depends(get_db)):
    """Обновить информацию об альпинисте"""
    updated_climber = crud.update_climber(db=db, climber_id=climber_id, climber=climber)
    if updated_climber is None:
        raise HTTPException(status_code=404, detail="Альпинист не найден")
    return updated_climber


@router.delete("/{climber_id}", status_code=204)
def delete_climber(climber_id: int, db: Session = Depends(get_db)):
    """Удалить альпиниста"""
    success = crud.delete_climber(db=db, climber_id=climber_id)
    if not success:
        raise HTTPException(status_code=404, detail="Альпинист не найден")
