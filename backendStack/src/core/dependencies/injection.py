from fastapi import Depends
from typing import Annotated

from src.infrastructure.repositories.user_repository import InMemoryUserRepository
from src.application.interfaces.repositories import IUserRepository
from src.application.use_cases.user_use_cases import UserUseCases


# Repository instances (using singleton pattern)
_user_repository: IUserRepository = InMemoryUserRepository()


def get_user_repository() -> IUserRepository:
    """Get the user repository instance"""
    return _user_repository


def get_user_use_cases(
    user_repository: Annotated[IUserRepository, Depends(get_user_repository)],
) -> UserUseCases:
    """Get the user use cases instance"""
    return UserUseCases(user_repository)
