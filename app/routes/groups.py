from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app import crud, schemas
from app.database import get_db

router = APIRouter(prefix="/groups", tags=["groups"])


@router.get("/", response_model=List[schemas.GroupResponse])
def read_groups(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    """Получить список всех групп"""
    groups = crud.get_groups(db, skip=skip, limit=limit)
    return groups


@router.get("/{group_id}", response_model=schemas.GroupResponse)
def read_group(group_id: int, db: Session = Depends(get_db)):
    """Получить информацию о конкретной группе"""
    group = crud.get_group(db, group_id=group_id)
    if group is None:
        raise HTTPException(status_code=404, detail="Группа не найдена")
    return group


@router.post("/", response_model=schemas.GroupResponse, status_code=201)
def create_group(group: schemas.GroupCreate, db: Session = Depends(get_db)):
    """Создать новую группу"""
    return crud.create_group(db=db, group=group)


@router.put("/{group_id}", response_model=schemas.GroupResponse)
def update_group(group_id: int, group: schemas.GroupUpdate, db: Session = Depends(get_db)):
    """Обновить информацию о группе"""
    updated_group = crud.update_group(db=db, group_id=group_id, group=group)
    if updated_group is None:
        raise HTTPException(status_code=404, detail="Группа не найдена")
    return updated_group


@router.delete("/{group_id}", status_code=204)
def delete_group(group_id: int, db: Session = Depends(get_db)):
    """Удалить группу"""
    success = crud.delete_group(db=db, group_id=group_id)
    if not success:
        raise HTTPException(status_code=404, detail="Группа не найдена")
