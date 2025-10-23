from fastapi import APIRouter

from src.presentation.api.v1 import users, health

api_router = APIRouter()

api_router.include_router(health.router)
api_router.include_router(users.router)
