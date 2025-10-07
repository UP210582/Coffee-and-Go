from dataclasses import dataclass
from datetime import datetime
from typing import Optional
from uuid import UUID, uuid4


@dataclass
class User:
    id: UUID
    email: str
    username: str
    full_name: str
    is_active: bool = True
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None

    def __post_init__(self):
        if self.created_at is None:
            self.created_at = datetime.utcnow()

    @classmethod
    def create(
        cls,
        email: str,
        username: str,
        full_name: str,
    ) -> "User":
        return cls(
            id=uuid4(),
            email=email,
            username=username,
            full_name=full_name,
        )
