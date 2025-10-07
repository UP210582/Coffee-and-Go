from typing import Optional, List, Dict
from uuid import UUID

from src.domain.entities.user import User
from src.application.interfaces.repositories import IUserRepository


class InMemoryUserRepository(IUserRepository):
    """In-memory implementation of the user repository for testing"""

    def __init__(self):
        self._users: Dict[UUID, User] = {}

    async def create(self, user: User) -> User:
        self._users[user.id] = user
        return user

    async def get_by_id(self, user_id: UUID) -> Optional[User]:
        return self._users.get(user_id)

    async def get_by_email(self, email: str) -> Optional[User]:
        for user in self._users.values():
            if user.email == email:
                return user
        return None

    async def get_by_username(self, username: str) -> Optional[User]:
        for user in self._users.values():
            if user.username == username:
                return user
        return None

    async def update(self, user: User) -> User:
        self._users[user.id] = user
        return user

    async def delete(self, user_id: UUID) -> bool:
        if user_id in self._users:
            del self._users[user_id]
            return True
        return False

    async def list(self, skip: int = 0, limit: int = 100) -> List[User]:
        users = list(self._users.values())
        return users[skip : skip + limit]
