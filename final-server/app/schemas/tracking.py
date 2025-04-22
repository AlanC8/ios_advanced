from typing import Optional, List
from pydantic import BaseModel
from datetime import datetime, date

# Base tracking entry schema
class TrackingEntryBase(BaseModel):
    date: date
    completed: bool = False
    notes: Optional[str] = None

# Schema for creating a tracking entry
class TrackingEntryCreate(TrackingEntryBase):
    pass

# Schema for updating a tracking entry
class TrackingEntryUpdate(BaseModel):
    completed: Optional[bool] = None
    notes: Optional[str] = None

# Schema for tracking entry response
class TrackingEntry(TrackingEntryBase):
    id: int
    habit_id: int
    created_at: datetime
    updated_at: Optional[datetime] = None
    
    class Config:
        orm_mode = True 