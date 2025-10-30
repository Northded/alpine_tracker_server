from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app import crud, schemas
from app.database import get_db

router = APIRouter(prefix="/ascents", tags=["ascents"])


@router.get("/", response_model=List[schemas.AscentDetailResponse])
def read_ascents(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    """Получить список всех восхождений"""
    ascents = crud.get_ascents(db, skip=skip, limit=limit)
    return ascents


@router.get("/{ascent_id}", response_model=schemas.AscentDetailResponse)
def read_ascent(ascent_id: int, db: Session = Depends(get_db)):
    """Получить информацию о конкретном восхождении"""
    ascent = crud.get_ascent(db, ascent_id=ascent_id)
    if ascent is None:
        raise HTTPException(status_code=404, detail="Восхождение не найдено")
    return ascent


@router.post("/", response_model=schemas.AscentResponse, status_code=201)
def create_ascent(ascent: schemas.AscentCreate, db: Session = Depends(get_db)):
    """Создать новое восхождение"""
    # Проверяем существование горы и группы
    mountain = crud.get_mountain(db, ascent.mountain_id)
    if not mountain:
        raise HTTPException(status_code=404, detail="Гора не найдена")

    group = crud.get_group(db, ascent.group_id)
    if not group:
        raise HTTPException(status_code=404, detail="Группа не найдена")

    return crud.create_ascent(db=db, ascent=ascent)


@router.put("/{ascent_id}", response_model=schemas.AscentResponse)
def update_ascent(ascent_id: int, ascent: schemas.AscentUpdate, db: Session = Depends(get_db)):
    """Обновить информацию о восхождении"""
    # Проверяем существование связанных сущностей при обновлении
    if ascent.mountain_id:
        mountain = crud.get_mountain(db, ascent.mountain_id)
        if not mountain:
            raise HTTPException(status_code=404, detail="Гора не найдена")

    if ascent.group_id:
        group = crud.get_group(db, ascent.group_id)
        if not group:
            raise HTTPException(status_code=404, detail="Группа не найдена")

    updated_ascent = crud.update_ascent(db=db, ascent_id=ascent_id, ascent=ascent)
    if updated_ascent is None:
        raise HTTPException(status_code=404, detail="Восхождение не найдено")
    return updated_ascent


@router.delete("/{ascent_id}", status_code=204)
def delete_ascent(ascent_id: int, db: Session = Depends(get_db)):
    """Удалить восхождение"""
    success = crud.delete_ascent(db=db, ascent_id=ascent_id)
    if not success:
        raise HTTPException(status_code=404, detail="Восхождение не найдено")
