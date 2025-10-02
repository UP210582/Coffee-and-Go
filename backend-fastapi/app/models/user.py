from sqlalchemy import Column, Integer, String, DateTime, func
from ..database import Base

class User(Base):
    __tablename__ = "User"  # misma tabla que Prisma crea
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, nullable=False)
    name = Column(String, nullable=False)
    createdAt = Column(DateTime, server_default=func.now())
