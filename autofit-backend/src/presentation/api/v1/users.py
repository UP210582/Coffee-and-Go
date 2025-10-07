from fastapi import APIRouter, Depends, HTTPException, status
from typing import List, Annotated
from uuid import UUID

from src.presentation.schemas.user_schemas import (
    UserCreateRequest,
    UserUpdateRequest,
    UserResponse,
)
from src.application.use_cases.user_use_cases import UserUseCases
from src.core.dependencies.injection import get_user_use_cases
from src.domain.exceptions.base import EntityNotFound, ConflictError


router = APIRouter(prefix="/users", tags=["users"])


@router.post("/", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
async def create_user(
    user_data: UserCreateRequest,
    use_cases: Annotated[UserUseCases, Depends(get_user_use_cases)],
):
    """Create a new user"""
    try:
        user = await use_cases.create_user(
            email=user_data.email,
            username=user_data.username,
            full_name=user_data.full_name,
        )
        return UserResponse.model_validate(user)
    except ConflictError as e:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail=str(e))


@router.get("/{user_id}", response_model=UserResponse)
async def get_user(
    user_id: UUID,
    use_cases: Annotated[UserUseCases, Depends(get_user_use_cases)],
):
    """Get a user by ID"""
    try:
        user = await use_cases.get_user(user_id)
        return UserResponse.model_validate(user)
    except EntityNotFound as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))


@router.get("/", response_model=List[UserResponse])
async def list_users(
    use_cases: Annotated[UserUseCases, Depends(get_user_use_cases)],
    skip: int = 0,
    limit: int = 100,
):
    """List all users with pagination"""
    users = await use_cases.list_users(skip=skip, limit=limit)
    return [UserResponse.model_validate(user) for user in users]


@router.put("/{user_id}", response_model=UserResponse)
async def update_user(
    user_id: UUID,
    user_data: UserUpdateRequest,
    use_cases: Annotated[UserUseCases, Depends(get_user_use_cases)],
):
    """Update a user"""
    try:
        user = await use_cases.update_user(
            user_id=user_id,
            full_name=user_data.full_name,
        )
        return UserResponse.model_validate(user)
    except EntityNotFound as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))


@router.delete("/{user_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_user(
    user_id: UUID,
    use_cases: Annotated[UserUseCases, Depends(get_user_use_cases)],
):
    """Delete a user"""
    try:
        await use_cases.delete_user(user_id)
    except EntityNotFound as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))
