from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app import crud, schemas
from app.database import get_db

router = APIRouter(prefix="/mountains", tags=["mountains"])


@router.get("/", response_model=List[schemas.MountainResponse])
def read_mountains(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    """Получить список всех гор"""
    mountains = crud.get_mountains(db, skip=skip, limit=limit)
    return mountains


@router.get("/{mountain_id}", response_model=schemas.MountainResponse)
def read_mountain(mountain_id: int, db: Session = Depends(get_db)):
    """Получить информацию о конкретной горе"""
    mountain = crud.get_mountain(db, mountain_id=mountain_id)
    if mountain is None:
        raise HTTPException(status_code=404, detail="Гора не найдена")
    return mountain


@router.post("/", response_model=schemas.MountainResponse, status_code=201)
def create_mountain(mountain: schemas.MountainCreate, db: Session = Depends(get_db)):
    """Создать новую гору"""
    return crud.create_mountain(db=db, mountain=mountain)


@router.put("/{mountain_id}", response_model=schemas.MountainResponse)
def update_mountain(mountain_id: int, mountain: schemas.MountainUpdate, db: Session = Depends(get_db)):
    """Обновить информацию о горе"""
    updated_mountain = crud.update_mountain(db=db, mountain_id=mountain_id, mountain=mountain)
    if updated_mountain is None:
        raise HTTPException(status_code=404, detail="Гора не найдена")
    return updated_mountain


@router.delete("/{mountain_id}", status_code=204)
def delete_mountain(mountain_id: int, db: Session = Depends(get_db)):
    """Удалить гору"""
    success = crud.delete_mountain(db=db, mountain_id=mountain_id)
    if not success:
        raise HTTPException(status_code=404, detail="Гора не найдена")
