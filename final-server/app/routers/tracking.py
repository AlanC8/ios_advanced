from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session
from typing import List, Optional
from datetime import date, timedelta

from app.database import get_db
from app.models.user import User
from app.models.habit import Habit
from app.models.tracking import TrackingEntry
from app.schemas.tracking import TrackingEntryCreate, TrackingEntryUpdate, TrackingEntry as TrackingEntrySchema
from app.utils.auth import get_current_user

router = APIRouter(
    prefix="/tracking",
    tags=["tracking"],
    responses={404: {"description": "Not found"}},
)

# Create or update a tracking entry for a habit
@router.post("/habits/{habit_id}/entries", response_model=TrackingEntrySchema)
def create_tracking_entry(
    habit_id: int,
    entry: TrackingEntryCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    # Check if habit exists and belongs to user
    habit = db.query(Habit).filter(Habit.id == habit_id).first()
    
    if not habit:
        raise HTTPException(status_code=404, detail="Habit not found")
    
    if habit.user_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized to access this habit")
    
    # Check if entry for this date already exists
    existing_entry = db.query(TrackingEntry).filter(
        TrackingEntry.habit_id == habit_id,
        TrackingEntry.date == entry.date
    ).first()
    
    if existing_entry:
        # Update existing entry
        existing_entry.completed = entry.completed
        if entry.notes is not None:
            existing_entry.notes = entry.notes
        
        db.commit()
        db.refresh(existing_entry)
        return existing_entry
    
    # Create new entry
    db_entry = TrackingEntry(
        habit_id=habit_id,
        date=entry.date,
        completed=entry.completed,
        notes=entry.notes
    )
    
    db.add(db_entry)
    db.commit()
    db.refresh(db_entry)
    
    return db_entry

# Get tracking entries for a habit
@router.get("/habits/{habit_id}/entries", response_model=List[TrackingEntrySchema])
def get_tracking_entries(
    habit_id: int,
    start_date: Optional[date] = Query(None),
    end_date: Optional[date] = Query(None),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    # Check if habit exists and belongs to user
    habit = db.query(Habit).filter(Habit.id == habit_id).first()
    
    if not habit:
        raise HTTPException(status_code=404, detail="Habit not found")
    
    if habit.user_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized to access this habit")
    
    # Query tracking entries
    query = db.query(TrackingEntry).filter(TrackingEntry.habit_id == habit_id)
    
    # Apply date filters if provided
    if start_date:
        query = query.filter(TrackingEntry.date >= start_date)
    
    if end_date:
        query = query.filter(TrackingEntry.date <= end_date)
    
    # Order by date
    entries = query.order_by(TrackingEntry.date.desc()).all()
    
    return entries

# Get tracking entry by ID
@router.get("/entries/{entry_id}", response_model=TrackingEntrySchema)
def get_tracking_entry(
    entry_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    # Get entry
    entry = db.query(TrackingEntry).filter(TrackingEntry.id == entry_id).first()
    
    if not entry:
        raise HTTPException(status_code=404, detail="Entry not found")
    
    # Check if habit belongs to user
    habit = db.query(Habit).filter(Habit.id == entry.habit_id).first()
    
    if not habit or habit.user_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized to access this entry")
    
    return entry

# Update tracking entry
@router.put("/entries/{entry_id}", response_model=TrackingEntrySchema)
def update_tracking_entry(
    entry_id: int,
    entry_update: TrackingEntryUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    # Get entry
    entry = db.query(TrackingEntry).filter(TrackingEntry.id == entry_id).first()
    
    if not entry:
        raise HTTPException(status_code=404, detail="Entry not found")
    
    # Check if habit belongs to user
    habit = db.query(Habit).filter(Habit.id == entry.habit_id).first()
    
    if not habit or habit.user_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized to update this entry")
    
    # Update fields if provided
    if entry_update.completed is not None:
        entry.completed = entry_update.completed
    
    if entry_update.notes is not None:
        entry.notes = entry_update.notes
    
    # Save changes
    db.commit()
    db.refresh(entry)
    
    return entry

# Delete tracking entry
@router.delete("/entries/{entry_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_tracking_entry(
    entry_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    # Get entry
    entry = db.query(TrackingEntry).filter(TrackingEntry.id == entry_id).first()
    
    if not entry:
        raise HTTPException(status_code=404, detail="Entry not found")
    
    # Check if habit belongs to user
    habit = db.query(Habit).filter(Habit.id == entry.habit_id).first()
    
    if not habit or habit.user_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized to delete this entry")
    
    # Delete entry
    db.delete(entry)
    db.commit()
    
    return None

# Get today's tracking entries for all habits
@router.get("/today", response_model=List[TrackingEntrySchema])
def get_today_entries(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    # Get all active habits for current user
    habits = db.query(Habit).filter(
        Habit.user_id == current_user.id,
        Habit.active == True
    ).all()
    
    today = date.today()
    
    # For each habit, check if there's an entry for today
    entries = []
    for habit in habits:
        entry = db.query(TrackingEntry).filter(
            TrackingEntry.habit_id == habit.id,
            TrackingEntry.date == today
        ).first()
        
        if entry:
            entries.append(entry)
        else:
            # Create an entry for today if it doesn't exist
            new_entry = TrackingEntry(
                habit_id=habit.id,
                date=today,
                completed=False
            )
            
            db.add(new_entry)
            db.commit()
            db.refresh(new_entry)
            
            entries.append(new_entry)
    
    return entries 