from typing import Optional, List
from uuid import UUID

from src.domain.entities.user import User
from src.domain.exceptions.base import EntityNotFound, ConflictError
from src.application.interfaces.repositories import IUserRepository


class UserUseCases:
    def __init__(self, user_repository: IUserRepository):
        self.user_repository = user_repository

    async def create_user(
        self,
        email: str,
        username: str,
        full_name: str,
    ) -> User:
        # Check if user already exists
        existing_user = await self.user_repository.get_by_email(email)
        if existing_user:
            raise ConflictError(f"User with email {email} already exists")

        existing_user = await self.user_repository.get_by_username(username)
        if existing_user:
            raise ConflictError(f"User with username {username} already exists")

        # Create new user
        user = User.create(
            email=email,
            username=username,
            full_name=full_name,
        )

        return await self.user_repository.create(user)

    async def get_user(self, user_id: UUID) -> User:
        user = await self.user_repository.get_by_id(user_id)
        if not user:
            raise EntityNotFound("User", str(user_id))
        return user

    async def get_user_by_email(self, email: str) -> User:
        user = await self.user_repository.get_by_email(email)
        if not user:
            raise EntityNotFound("User", email)
        return user

    async def update_user(
        self,
        user_id: UUID,
        full_name: Optional[str] = None,
    ) -> User:
        user = await self.get_user(user_id)

        if full_name is not None:
            user.full_name = full_name

        return await self.user_repository.update(user)

    async def delete_user(self, user_id: UUID) -> bool:
        user = await self.get_user(user_id)
        return await self.user_repository.delete(user.id)

    async def list_users(self, skip: int = 0, limit: int = 100) -> List[User]:
        return await self.user_repository.list(skip=skip, limit=limit)
