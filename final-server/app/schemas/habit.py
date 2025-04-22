from typing import Optional, List
from pydantic import BaseModel
from datetime import datetime, date

# Base habit schema with common attributes
class HabitBase(BaseModel):
    title: str
    description: Optional[str] = None
    
# Schema for creating a habit
class HabitCreate(HabitBase):
    pass

# Schema for updating a habit
class HabitUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    active: Optional[bool] = None

# Schema for habit with tracking stats
class HabitWithStats(HabitBase):
    id: int
    created_at: datetime
    active: bool
    user_id: int
    streak: int
    completion_rate: float
    
    class Config:
        orm_mode = True

# Basic habit schema (without stats)
class Habit(HabitBase):
    id: int
    created_at: datetime
    active: bool
    user_id: int
    
    class Config:
        orm_mode = True 