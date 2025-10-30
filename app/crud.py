from sqlalchemy.orm import Session, joinedload
from typing import List, Optional
from app import models, schemas


# Mountain CRUD
def get_mountains(db: Session, skip: int = 0, limit: int = 100) -> List[models.Mountain]:
    return db.query(models.Mountain).offset(skip).limit(limit).all()


def get_mountain(db: Session, mountain_id: int) -> Optional[models.Mountain]:
    return db.query(models.Mountain).filter(models.Mountain.id == mountain_id).first()


def create_mountain(db: Session, mountain: schemas.MountainCreate) -> models.Mountain:
    db_mountain = models.Mountain(**mountain.model_dump())
    db.add(db_mountain)
    db.commit()
    db.refresh(db_mountain)
    return db_mountain


def update_mountain(db: Session, mountain_id: int, mountain: schemas.MountainUpdate) -> Optional[models.Mountain]:
    db_mountain = get_mountain(db, mountain_id)
    if db_mountain:
        update_data = mountain.model_dump(exclude_unset=True)
        for key, value in update_data.items():
            setattr(db_mountain, key, value)
        db.commit()
        db.refresh(db_mountain)
    return db_mountain


def delete_mountain(db: Session, mountain_id: int) -> bool:
    db_mountain = get_mountain(db, mountain_id)
    if db_mountain:
        db.delete(db_mountain)
        db.commit()
        return True
    return False


# Climber CRUD
def get_climbers(db: Session, skip: int = 0, limit: int = 100) -> List[models.Climber]:
    return db.query(models.Climber).offset(skip).limit(limit).all()


def get_climber(db: Session, climber_id: int) -> Optional[models.Climber]:
    return db.query(models.Climber).filter(models.Climber.id == climber_id).first()


def create_climber(db: Session, climber: schemas.ClimberCreate) -> models.Climber:
    db_climber = models.Climber(**climber.model_dump())
    db.add(db_climber)
    db.commit()
    db.refresh(db_climber)
    return db_climber


def update_climber(db: Session, climber_id: int, climber: schemas.ClimberUpdate) -> Optional[models.Climber]:
    db_climber = get_climber(db, climber_id)
    if db_climber:
        update_data = climber.model_dump(exclude_unset=True)
        for key, value in update_data.items():
            setattr(db_climber, key, value)
        db.commit()
        db.refresh(db_climber)
    return db_climber


def delete_climber(db: Session, climber_id: int) -> bool:
    db_climber = get_climber(db, climber_id)
    if db_climber:
        db.delete(db_climber)
        db.commit()
        return True
    return False


# Group CRUD
def get_groups(db: Session, skip: int = 0, limit: int = 100) -> List[models.Group]:
    return db.query(models.Group).options(joinedload(models.Group.climbers)).offset(skip).limit(limit).all()


def get_group(db: Session, group_id: int) -> Optional[models.Group]:
    return db.query(models.Group).options(joinedload(models.Group.climbers)).filter(models.Group.id == group_id).first()


def create_group(db: Session, group: schemas.GroupCreate) -> models.Group:
    db_group = models.Group(
        name=group.name,
        formation_date=group.formation_date
    )

    # Добавляем альпинистов в группу
    if group.climber_ids:
        climbers = db.query(models.Climber).filter(models.Climber.id.in_(group.climber_ids)).all()
        db_group.climbers = climbers

    db.add(db_group)
    db.commit()
    db.refresh(db_group)
    return db_group


def update_group(db: Session, group_id: int, group: schemas.GroupUpdate) -> Optional[models.Group]:
    db_group = get_group(db, group_id)
    if db_group:
        update_data = group.model_dump(exclude_unset=True)
        climber_ids = update_data.pop('climber_ids', None)

        for key, value in update_data.items():
            setattr(db_group, key, value)

        if climber_ids is not None:
            climbers = db.query(models.Climber).filter(models.Climber.id.in_(climber_ids)).all()
            db_group.climbers = climbers

        db.commit()
        db.refresh(db_group)
    return db_group


def delete_group(db: Session, group_id: int) -> bool:
    db_group = get_group(db, group_id)
    if db_group:
        db.delete(db_group)
        db.commit()
        return True
    return False


# Ascent CRUD
def get_ascents(db: Session, skip: int = 0, limit: int = 100) -> List[models.Ascent]:
    return db.query(models.Ascent).options(
        joinedload(models.Ascent.mountain),
        joinedload(models.Ascent.group).joinedload(models.Group.climbers)
    ).offset(skip).limit(limit).all()


def get_ascent(db: Session, ascent_id: int) -> Optional[models.Ascent]:
    return db.query(models.Ascent).options(
        joinedload(models.Ascent.mountain),
        joinedload(models.Ascent.group).joinedload(models.Group.climbers)
    ).filter(models.Ascent.id == ascent_id).first()


def create_ascent(db: Session, ascent: schemas.AscentCreate) -> models.Ascent:
    db_ascent = models.Ascent(**ascent.model_dump())
    db.add(db_ascent)
    db.commit()
    db.refresh(db_ascent)
    return db_ascent


def update_ascent(db: Session, ascent_id: int, ascent: schemas.AscentUpdate) -> Optional[models.Ascent]:
    db_ascent = get_ascent(db, ascent_id)
    if db_ascent:
        update_data = ascent.model_dump(exclude_unset=True)
        for key, value in update_data.items():
            setattr(db_ascent, key, value)
        db.commit()
        db.refresh(db_ascent)
    return db_ascent


def delete_ascent(db: Session, ascent_id: int) -> bool:
    db_ascent = get_ascent(db, ascent_id)
    if db_ascent:
        db.delete(db_ascent)
        db.commit()
        return True
    return False
