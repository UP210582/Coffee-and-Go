from pydantic import BaseModel, EmailStr
from datetime import datetime

class UserBase(BaseModel):
    email: EmailStr
    name: str

class UserCreate(UserBase):
    pass

class UserOut(UserBase):
    id: int
    createdAt: datetime

    class Config:
        orm_mode = True
