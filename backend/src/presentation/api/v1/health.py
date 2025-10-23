from fastapi import APIRouter, status
from pydantic import BaseModel
from datetime import datetime

from src.core.config.settings import settings


router = APIRouter(prefix="/health", tags=["health"])


class HealthResponse(BaseModel):
    status: str
    timestamp: datetime
    service: str
    version: str


@router.get("/", response_model=HealthResponse, status_code=status.HTTP_200_OK)
async def health_check():
    """Check the health status of the API"""
    return HealthResponse(
        status="healthy",
        timestamp=datetime.utcnow(),
        service=settings.app_name,
        version=settings.app_version,
    )
