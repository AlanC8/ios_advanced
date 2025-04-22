from typing import Optional, List
from pydantic import BaseModel, EmailStr
from datetime import datetime

# Base schema with common attributes
class UserBase(BaseModel):
    username: str
    email: EmailStr

# Schema for creating a user
class UserCreate(UserBase):
    password: str
    
# Schema for updating a user
class UserUpdate(BaseModel):
    username: Optional[str] = None
    email: Optional[EmailStr] = None
    password: Optional[str] = None

# Schema for user response (returned to API clients)
class User(UserBase):
    id: int
    created_at: datetime
    
    class Config:
        orm_mode = True

# Token schema
class Token(BaseModel):
    access_token: str
    token_type: str

# Token data schema
class TokenData(BaseModel):
    username: Optional[str] = None 