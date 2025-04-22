from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from datetime import date

from app.database import get_db
from app.models.user import User
from app.models.habit import Habit
from app.schemas.habit import HabitCreate, HabitUpdate, Habit as HabitSchema, HabitWithStats
from app.utils.auth import get_current_user

router = APIRouter(
    prefix="/habits",
    tags=["habits"],
    responses={404: {"description": "Not found"}},
)

# Create a new habit
@router.post("/", response_model=HabitSchema, status_code=status.HTTP_201_CREATED)
def create_habit(
    habit: HabitCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    # Create new habit object
    db_habit = Habit(
        title=habit.title,
        description=habit.description,
        user_id=current_user.id
    )
    
    # Save to database
    db.add(db_habit)
    db.commit()
    db.refresh(db_habit)
    
    return db_habit

# Get all habits for current user
@router.get("/", response_model=List[HabitWithStats])
def read_habits(
    skip: int = 0,
    limit: int = 100,
    include_inactive: bool = False,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    # Get habits for current user
    query = db.query(Habit).filter(Habit.user_id == current_user.id)
    
    # Filter out inactive habits if requested
    if not include_inactive:
        query = query.filter(Habit.active == True)
    
    # Apply pagination
    habits = query.offset(skip).limit(limit).all()
    
    # Calculate stats for each habit
    result = []
    for habit in habits:
        habit_dict = HabitSchema.from_orm(habit).dict()
        habit_dict["streak"] = habit.calculate_streak()
        habit_dict["completion_rate"] = habit.calculate_completion_rate()
        result.append(HabitWithStats(**habit_dict))
    
    return result

# Get a specific habit
@router.get("/{habit_id}", response_model=HabitWithStats)
def read_habit(
    habit_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    # Get habit and check it belongs to current user
    habit = db.query(Habit).filter(Habit.id == habit_id).first()
    
    if not habit:
        raise HTTPException(status_code=404, detail="Habit not found")
    
    if habit.user_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized to access this habit")
    
    # Calculate stats
    habit_dict = HabitSchema.from_orm(habit).dict()
    habit_dict["streak"] = habit.calculate_streak()
    habit_dict["completion_rate"] = habit.calculate_completion_rate()
    
    return HabitWithStats(**habit_dict)

# Update a habit
@router.put("/{habit_id}", response_model=HabitSchema)
def update_habit(
    habit_id: int,
    habit_update: HabitUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    # Get habit and check it belongs to current user
    habit = db.query(Habit).filter(Habit.id == habit_id).first()
    
    if not habit:
        raise HTTPException(status_code=404, detail="Habit not found")
    
    if habit.user_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized to update this habit")
    
    # Update fields if provided
    if habit_update.title is not None:
        habit.title = habit_update.title
    
    if habit_update.description is not None:
        habit.description = habit_update.description
        
    if habit_update.active is not None:
        habit.active = habit_update.active
    
    # Save changes
    db.commit()
    db.refresh(habit)
    
    return habit

# Delete a habit
@router.delete("/{habit_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_habit(
    habit_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    # Get habit and check it belongs to current user
    habit = db.query(Habit).filter(Habit.id == habit_id).first()
    
    if not habit:
        raise HTTPException(status_code=404, detail="Habit not found")
    
    if habit.user_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized to delete this habit")
    
    # Delete habit
    db.delete(habit)
    db.commit()
    
    return None 