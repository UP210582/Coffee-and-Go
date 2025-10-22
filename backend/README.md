# AutoFit Backend

A FastAPI backend for automotive aftermarket parts catalog and fitment, following Clean Architecture principles with clear separation of concerns and dependency injection.

## 📊 Database Schema

The application uses PostgreSQL with a comprehensive schema for managing automotive parts (PIES) and vehicle fitment (ACES) data:

### Key Features
- **Dual Schema Architecture**: 
  - `pies` schema for parts, brands, categories, and product information
  - `aces` schema for vehicle fitment and compatibility data
- **Multi-language Support**: Full-text search in English and Spanish
- **Advanced Search**: Trigram-based fuzzy search with accent insensitivity
- **Hierarchical Categories**: Optional ltree support for category trees
- **Complete Part Information**: Attributes, assets, packaging, interchanges
- **Vehicle Fitment**: Year/make/model/submodel with engine and transmission specs

### Database Setup

```bash
# Connect to PostgreSQL and create database
psql -U postgres -f database/schema.sql

# Load sample data (optional, for development)
cd database/queries
./load_synthetic_data.sh
```

For detailed database documentation, see [database/docs/README.md](database/docs/README.md).

### Quick Database Reference

| Schema | Purpose | Key Tables |
|--------|---------|------------|
| **pies** | Product Information Exchange Standard | `part`, `brand`, `category`, `part_attribute`, `part_asset` |
| **aces** | Aftermarket Catalog Exchange Standard | `vehicle_make`, `vehicle_model`, `fitment_application` |

**Sample Queries:**
```sql
-- Find parts for a vehicle
SELECT p.display_name, b.name as brand
FROM aces.fitment_application fa
JOIN pies.part p ON p.part_id = fa.part_id
JOIN pies.brand b ON b.brand_id = p.brand_id
WHERE fa.make_id = 1 AND fa.model_id = 1 
  AND 2020 BETWEEN fa.year_start AND fa.year_end;

-- Search parts by name (fuzzy, accent-insensitive)
SELECT display_name, mpn FROM pies.part
WHERE name_normalized ILIKE unaccent('%brake%')
ORDER BY similarity(name_normalized, 'brake') DESC;
```

## 🏗️ Architecture Overview

```
src/
├── domain/           # Business entities and rules (no external dependencies)
│   ├── entities/     # Domain models
│   └── exceptions/   # Domain-specific exceptions
├── application/      # Business logic and use cases
│   ├── use_cases/    # Application services
│   └── interfaces/   # Repository interfaces (contracts)
├── infrastructure/   # External concerns and implementations
│   ├── repositories/ # Data persistence implementations
│   └── database/     # Database configuration
├── presentation/     # API layer
│   ├── api/         # REST endpoints
│   └── schemas/     # Request/response models (Pydantic)
└── core/            # Shared configuration
    ├── config/      # Application settings
    └── dependencies/ # Dependency injection
```

## 🚀 Quick Start

```bash
# Clone and setup
git clone <repository-url>
cd autofit-backend
uv sync

# Run development server
uv run poe dev

# Run tests
uv run poe test

# Run full QA
uv run poe qa
```

## 📋 Getting Started

### Prerequisites

- Python 3.12+
- PostgreSQL 17.x (or 15.x+ with optional features)
- uv (package manager)

### Task Runner

This project uses **poethepoet** for task automation. After installation, you can see all available tasks:

```bash
# List all available tasks
uv run poe --help
```

**Available Tasks:**

| Command | Description |
|---------|-------------|
| `poe dev` | Run development server with auto-reload |
| `poe serve` | Run the server |
| `poe test` | Run basic API tests |
| `poe test-full` | Run comprehensive test suite |
| `poe lint` | Run linter on source code |
| `poe format` | Format source code |
| `poe typecheck` | Run type checking |
| `poe fix` | Auto-fix linting issues |
| `poe check` | Run lint + typecheck |
| `poe qa` | Run full QA suite (fix, format, check, test) |
| `poe clean` | Clean Python cache files |
| `poe docs` | Show API documentation URL |

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd autofit-backend

# Install dependencies
uv sync

# Copy environment variables
cp .env.example .env
```

### Running the Application

Using the task runner (recommended):
```bash
# Development server with auto-reload
uv run poe dev

# Or simple server
uv run poe serve
```

Or manually:
```bash
# Development mode with auto-reload
uv run python -m src.main

# Or using uvicorn directly
uv run uvicorn src.main:app --reload --host 0.0.0.0 --port 8000
```

### API Documentation

Once running, access:
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## 📝 Adding New Features - Complete Example

Let's walk through adding a complete feature: **Workout Management**

### Step 1: Create the Domain Entity

**File:** `src/domain/entities/workout.py`

```python
from dataclasses import dataclass
from datetime import datetime
from typing import Optional, List
from uuid import UUID, uuid4
from enum import Enum


class WorkoutType(Enum):
    STRENGTH = "strength"
    CARDIO = "cardio"
    FLEXIBILITY = "flexibility"
    MIXED = "mixed"


@dataclass
class Exercise:
    name: str
    sets: int
    reps: int
    weight_kg: Optional[float] = None
    duration_seconds: Optional[int] = None


@dataclass
class Workout:
    id: UUID
    user_id: UUID
    name: str
    workout_type: WorkoutType
    exercises: List[Exercise]
    duration_minutes: int
    calories_burned: Optional[int] = None
    notes: Optional[str] = None
    completed_at: Optional[datetime] = None
    created_at: Optional[datetime] = None
    
    def __post_init__(self):
        if self.created_at is None:
            self.created_at = datetime.utcnow()
    
    @classmethod
    def create(
        cls,
        user_id: UUID,
        name: str,
        workout_type: WorkoutType,
        exercises: List[Exercise],
        duration_minutes: int,
        calories_burned: Optional[int] = None,
        notes: Optional[str] = None,
    ) -> "Workout":
        return cls(
            id=uuid4(),
            user_id=user_id,
            name=name,
            workout_type=workout_type,
            exercises=exercises,
            duration_minutes=duration_minutes,
            calories_burned=calories_burned,
            notes=notes,
        )
    
    def complete(self):
        """Mark workout as completed"""
        self.completed_at = datetime.utcnow()
```

### Step 2: Define Repository Interface

**File:** `src/application/interfaces/workout_repository.py`

```python
from abc import ABC, abstractmethod
from typing import Optional, List
from uuid import UUID
from datetime import datetime

from src.domain.entities.workout import Workout


class IWorkoutRepository(ABC):
    @abstractmethod
    async def create(self, workout: Workout) -> Workout:
        """Create a new workout"""
        pass
    
    @abstractmethod
    async def get_by_id(self, workout_id: UUID) -> Optional[Workout]:
        """Get workout by ID"""
        pass
    
    @abstractmethod
    async def get_by_user(
        self, 
        user_id: UUID, 
        skip: int = 0, 
        limit: int = 100
    ) -> List[Workout]:
        """Get workouts for a specific user"""
        pass
    
    @abstractmethod
    async def update(self, workout: Workout) -> Workout:
        """Update workout"""
        pass
    
    @abstractmethod
    async def delete(self, workout_id: UUID) -> bool:
        """Delete workout"""
        pass
    
    @abstractmethod
    async def get_by_date_range(
        self,
        user_id: UUID,
        start_date: datetime,
        end_date: datetime
    ) -> List[Workout]:
        """Get workouts within a date range"""
        pass
```

### Step 3: Create Use Cases

**File:** `src/application/use_cases/workout_use_cases.py`

```python
from typing import Optional, List
from uuid import UUID
from datetime import datetime

from src.domain.entities.workout import Workout, WorkoutType, Exercise
from src.domain.exceptions.base import EntityNotFound, ValidationError
from src.application.interfaces.workout_repository import IWorkoutRepository
from src.application.interfaces.repositories import IUserRepository


class WorkoutUseCases:
    def __init__(
        self, 
        workout_repository: IWorkoutRepository,
        user_repository: IUserRepository
    ):
        self.workout_repository = workout_repository
        self.user_repository = user_repository
    
    async def create_workout(
        self,
        user_id: UUID,
        name: str,
        workout_type: WorkoutType,
        exercises: List[Exercise],
        duration_minutes: int,
        calories_burned: Optional[int] = None,
        notes: Optional[str] = None,
    ) -> Workout:
        # Verify user exists
        user = await self.user_repository.get_by_id(user_id)
        if not user:
            raise EntityNotFound("User", str(user_id))
        
        # Validate workout data
        if duration_minutes <= 0:
            raise ValidationError("Duration must be positive")
        
        if not exercises:
            raise ValidationError("Workout must have at least one exercise")
        
        # Create workout
        workout = Workout.create(
            user_id=user_id,
            name=name,
            workout_type=workout_type,
            exercises=exercises,
            duration_minutes=duration_minutes,
            calories_burned=calories_burned,
            notes=notes,
        )
        
        return await self.workout_repository.create(workout)
    
    async def get_workout(self, workout_id: UUID) -> Workout:
        workout = await self.workout_repository.get_by_id(workout_id)
        if not workout:
            raise EntityNotFound("Workout", str(workout_id))
        return workout
    
    async def get_user_workouts(
        self,
        user_id: UUID,
        skip: int = 0,
        limit: int = 100
    ) -> List[Workout]:
        # Verify user exists
        user = await self.user_repository.get_by_id(user_id)
        if not user:
            raise EntityNotFound("User", str(user_id))
        
        return await self.workout_repository.get_by_user(
            user_id, skip, limit
        )
    
    async def complete_workout(self, workout_id: UUID) -> Workout:
        workout = await self.get_workout(workout_id)
        
        if workout.completed_at:
            raise ValidationError("Workout already completed")
        
        workout.complete()
        return await self.workout_repository.update(workout)
    
    async def update_workout(
        self,
        workout_id: UUID,
        name: Optional[str] = None,
        notes: Optional[str] = None,
        calories_burned: Optional[int] = None,
    ) -> Workout:
        workout = await self.get_workout(workout_id)
        
        if workout.completed_at:
            raise ValidationError("Cannot update completed workout")
        
        if name is not None:
            workout.name = name
        if notes is not None:
            workout.notes = notes
        if calories_burned is not None:
            workout.calories_burned = calories_burned
        
        return await self.workout_repository.update(workout)
    
    async def delete_workout(self, workout_id: UUID) -> bool:
        await self.get_workout(workout_id)
        return await self.workout_repository.delete(workout_id)
    
    async def get_workout_stats(
        self,
        user_id: UUID,
        start_date: datetime,
        end_date: datetime
    ) -> dict:
        workouts = await self.workout_repository.get_by_date_range(
            user_id, start_date, end_date
        )
        
        total_workouts = len(workouts)
        total_duration = sum(w.duration_minutes for w in workouts)
        total_calories = sum(
            w.calories_burned for w in workouts 
            if w.calories_burned
        )
        
        return {
            "total_workouts": total_workouts,
            "total_duration_minutes": total_duration,
            "total_calories_burned": total_calories,
            "average_duration_minutes": (
                total_duration / total_workouts if total_workouts else 0
            ),
        }
```

### Step 4: Implement Repository

**File:** `src/infrastructure/repositories/workout_repository.py`

```python
from typing import Optional, List, Dict
from uuid import UUID
from datetime import datetime

from src.domain.entities.workout import Workout
from src.application.interfaces.workout_repository import IWorkoutRepository


class InMemoryWorkoutRepository(IWorkoutRepository):
    def __init__(self):
        self._workouts: Dict[UUID, Workout] = {}
    
    async def create(self, workout: Workout) -> Workout:
        self._workouts[workout.id] = workout
        return workout
    
    async def get_by_id(self, workout_id: UUID) -> Optional[Workout]:
        return self._workouts.get(workout_id)
    
    async def get_by_user(
        self, 
        user_id: UUID, 
        skip: int = 0, 
        limit: int = 100
    ) -> List[Workout]:
        user_workouts = [
            w for w in self._workouts.values() 
            if w.user_id == user_id
        ]
        # Sort by created_at descending
        user_workouts.sort(
            key=lambda x: x.created_at or datetime.min, 
            reverse=True
        )
        return user_workouts[skip:skip + limit]
    
    async def update(self, workout: Workout) -> Workout:
        self._workouts[workout.id] = workout
        return workout
    
    async def delete(self, workout_id: UUID) -> bool:
        if workout_id in self._workouts:
            del self._workouts[workout_id]
            return True
        return False
    
    async def get_by_date_range(
        self,
        user_id: UUID,
        start_date: datetime,
        end_date: datetime
    ) -> List[Workout]:
        return [
            w for w in self._workouts.values()
            if (w.user_id == user_id and 
                w.created_at and 
                start_date <= w.created_at <= end_date)
        ]
```

### Step 5: Create API Schemas

**File:** `src/presentation/schemas/workout_schemas.py`

```python
from pydantic import BaseModel, Field
from datetime import datetime
from typing import Optional, List
from uuid import UUID
from enum import Enum


class WorkoutTypeEnum(str, Enum):
    STRENGTH = "strength"
    CARDIO = "cardio"
    FLEXIBILITY = "flexibility"
    MIXED = "mixed"


class ExerciseSchema(BaseModel):
    name: str
    sets: int = Field(..., gt=0)
    reps: int = Field(..., gt=0)
    weight_kg: Optional[float] = Field(None, gt=0)
    duration_seconds: Optional[int] = Field(None, gt=0)


class WorkoutCreateRequest(BaseModel):
    name: str = Field(..., min_length=1, max_length=200)
    workout_type: WorkoutTypeEnum
    exercises: List[ExerciseSchema] = Field(..., min_items=1)
    duration_minutes: int = Field(..., gt=0)
    calories_burned: Optional[int] = Field(None, gt=0)
    notes: Optional[str] = Field(None, max_length=1000)


class WorkoutUpdateRequest(BaseModel):
    name: Optional[str] = Field(None, min_length=1, max_length=200)
    notes: Optional[str] = Field(None, max_length=1000)
    calories_burned: Optional[int] = Field(None, gt=0)


class WorkoutResponse(BaseModel):
    id: UUID
    user_id: UUID
    name: str
    workout_type: WorkoutTypeEnum
    exercises: List[ExerciseSchema]
    duration_minutes: int
    calories_burned: Optional[int]
    notes: Optional[str]
    completed_at: Optional[datetime]
    created_at: datetime
    
    class Config:
        from_attributes = True


class WorkoutStatsResponse(BaseModel):
    total_workouts: int
    total_duration_minutes: int
    total_calories_burned: int
    average_duration_minutes: float
```

### Step 6: Create API Endpoints

**File:** `src/presentation/api/v1/workouts.py`

```python
from fastapi import APIRouter, Depends, HTTPException, status, Query
from typing import List, Annotated
from uuid import UUID
from datetime import datetime, timedelta

from src.presentation.schemas.workout_schemas import (
    WorkoutCreateRequest,
    WorkoutUpdateRequest,
    WorkoutResponse,
    WorkoutStatsResponse,
    ExerciseSchema,
)
from src.domain.entities.workout import WorkoutType, Exercise
from src.application.use_cases.workout_use_cases import WorkoutUseCases
from src.core.dependencies.injection import get_workout_use_cases
from src.domain.exceptions.base import EntityNotFound, ValidationError


router = APIRouter(prefix="/workouts", tags=["workouts"])


def convert_exercises(schemas: List[ExerciseSchema]) -> List[Exercise]:
    return [
        Exercise(
            name=e.name,
            sets=e.sets,
            reps=e.reps,
            weight_kg=e.weight_kg,
            duration_seconds=e.duration_seconds,
        )
        for e in schemas
    ]


@router.post("/", response_model=WorkoutResponse, status_code=status.HTTP_201_CREATED)
async def create_workout(
    workout_data: WorkoutCreateRequest,
    user_id: UUID = Query(..., description="ID of the user creating the workout"),
    use_cases: Annotated[WorkoutUseCases, Depends(get_workout_use_cases)],
):
    """Create a new workout for a user"""
    try:
        workout = await use_cases.create_workout(
            user_id=user_id,
            name=workout_data.name,
            workout_type=WorkoutType(workout_data.workout_type.value),
            exercises=convert_exercises(workout_data.exercises),
            duration_minutes=workout_data.duration_minutes,
            calories_burned=workout_data.calories_burned,
            notes=workout_data.notes,
        )
        return WorkoutResponse.model_validate(workout)
    except EntityNotFound as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))
    except ValidationError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))


@router.get("/{workout_id}", response_model=WorkoutResponse)
async def get_workout(
    workout_id: UUID,
    use_cases: Annotated[WorkoutUseCases, Depends(get_workout_use_cases)],
):
    """Get a specific workout by ID"""
    try:
        workout = await use_cases.get_workout(workout_id)
        return WorkoutResponse.model_validate(workout)
    except EntityNotFound as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))


@router.get("/user/{user_id}", response_model=List[WorkoutResponse])
async def get_user_workouts(
    user_id: UUID,
    use_cases: Annotated[WorkoutUseCases, Depends(get_workout_use_cases)],
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=1000),
):
    """Get all workouts for a specific user"""
    try:
        workouts = await use_cases.get_user_workouts(user_id, skip, limit)
        return [WorkoutResponse.model_validate(w) for w in workouts]
    except EntityNotFound as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))


@router.post("/{workout_id}/complete", response_model=WorkoutResponse)
async def complete_workout(
    workout_id: UUID,
    use_cases: Annotated[WorkoutUseCases, Depends(get_workout_use_cases)],
):
    """Mark a workout as completed"""
    try:
        workout = await use_cases.complete_workout(workout_id)
        return WorkoutResponse.model_validate(workout)
    except EntityNotFound as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))
    except ValidationError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))


@router.put("/{workout_id}", response_model=WorkoutResponse)
async def update_workout(
    workout_id: UUID,
    workout_data: WorkoutUpdateRequest,
    use_cases: Annotated[WorkoutUseCases, Depends(get_workout_use_cases)],
):
    """Update a workout"""
    try:
        workout = await use_cases.update_workout(
            workout_id=workout_id,
            name=workout_data.name,
            notes=workout_data.notes,
            calories_burned=workout_data.calories_burned,
        )
        return WorkoutResponse.model_validate(workout)
    except EntityNotFound as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))
    except ValidationError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))


@router.delete("/{workout_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_workout(
    workout_id: UUID,
    use_cases: Annotated[WorkoutUseCases, Depends(get_workout_use_cases)],
):
    """Delete a workout"""
    try:
        await use_cases.delete_workout(workout_id)
    except EntityNotFound as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))


@router.get("/user/{user_id}/stats", response_model=WorkoutStatsResponse)
async def get_workout_stats(
    user_id: UUID,
    use_cases: Annotated[WorkoutUseCases, Depends(get_workout_use_cases)],
    days: int = Query(30, ge=1, le=365, description="Number of days to analyze"),
):
    """Get workout statistics for a user"""
    end_date = datetime.utcnow()
    start_date = end_date - timedelta(days=days)
    
    try:
        stats = await use_cases.get_workout_stats(
            user_id, start_date, end_date
        )
        return WorkoutStatsResponse(**stats)
    except EntityNotFound as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))
```

### Step 7: Wire Up Dependencies

**File:** `src/core/dependencies/injection.py` (add to existing file)

```python
from src.infrastructure.repositories.workout_repository import InMemoryWorkoutRepository
from src.application.interfaces.workout_repository import IWorkoutRepository
from src.application.use_cases.workout_use_cases import WorkoutUseCases

# Add to existing repositories
_workout_repository: IWorkoutRepository = InMemoryWorkoutRepository()

def get_workout_repository() -> IWorkoutRepository:
    """Get the workout repository instance"""
    return _workout_repository

def get_workout_use_cases(
    workout_repository: Annotated[IWorkoutRepository, Depends(get_workout_repository)],
    user_repository: Annotated[IUserRepository, Depends(get_user_repository)]
) -> WorkoutUseCases:
    """Get the workout use cases instance"""
    return WorkoutUseCases(workout_repository, user_repository)
```

### Step 8: Register Routes

**File:** `src/presentation/api/v1/__init__.py` (update)

```python
from fastapi import APIRouter

from src.presentation.api.v1 import users, health, workouts

api_router = APIRouter()

api_router.include_router(health.router)
api_router.include_router(users.router)
api_router.include_router(workouts.router)  # Add this line
```

## 🧪 Testing

### Using Task Runner (Recommended)

```bash
# Run basic tests
uv run poe test

# Run comprehensive tests
uv run poe test-full

# Run all code quality checks
uv run poe check

# Run full QA suite (fix, format, check, test)
uv run poe qa

# Individual tasks
uv run poe lint      # Run linter
uv run poe format    # Format code
uv run poe typecheck # Type checking
uv run poe fix       # Auto-fix issues
```

### Manual Commands

```bash
# Run test script
uv run python -m src.tests.test_api

# Or run comprehensive tests
uv run python -m src.tests.test_comprehensive

# Run linting
uv run ruff check src/

# Run type checking
uv run mypy src/

# Format code
uv run ruff format src/
```

### Testing New Endpoints

Create a test file for your new feature:

**File:** `test_workouts.py`

```python
from fastapi.testclient import TestClient
from main import app
from uuid import uuid4

client = TestClient(app)

def test_workout_flow():
    # Create a user first
    user_data = {
        "email": "athlete@example.com",
        "username": "athlete",
        "full_name": "Test Athlete"
    }
    user_response = client.post("/api/v1/users/", json=user_data)
    user = user_response.json()
    user_id = user["id"]
    
    # Create workout
    workout_data = {
        "name": "Morning Strength Training",
        "workout_type": "strength",
        "exercises": [
            {
                "name": "Bench Press",
                "sets": 3,
                "reps": 10,
                "weight_kg": 60
            },
            {
                "name": "Squats",
                "sets": 4,
                "reps": 12,
                "weight_kg": 80
            }
        ],
        "duration_minutes": 45,
        "calories_burned": 300,
        "notes": "Felt strong today!"
    }
    
    response = client.post(
        f"/api/v1/workouts/?user_id={user_id}",
        json=workout_data
    )
    assert response.status_code == 201
    workout = response.json()
    workout_id = workout["id"]
    
    # Complete workout
    response = client.post(f"/api/v1/workouts/{workout_id}/complete")
    assert response.status_code == 200
    assert response.json()["completed_at"] is not None
    
    # Get user workouts
    response = client.get(f"/api/v1/workouts/user/{user_id}")
    assert response.status_code == 200
    assert len(response.json()) > 0
    
    print("✅ All workout tests passed!")

if __name__ == "__main__":
    test_workout_flow()
```

## 🗄️ Database Integration

### Switching from In-Memory to Real Database

To replace the in-memory repository with a real database:

1. **Install database dependencies:**
   ```bash
   uv add sqlalchemy asyncpg  # For PostgreSQL
   # or
   uv add sqlalchemy aiomysql  # For MySQL
   ```

2. **Create database models:**
   ```python
   # src/infrastructure/database/models.py
   from sqlalchemy import Column, String, Integer, DateTime, JSON
   from sqlalchemy.dialects.postgresql import UUID
   from src.infrastructure.database.base import Base
   
   class WorkoutModel(Base):
       __tablename__ = "workouts"
       
       id = Column(UUID(as_uuid=True), primary_key=True)
       user_id = Column(UUID(as_uuid=True), nullable=False)
       name = Column(String(200), nullable=False)
       # ... other columns
   ```

3. **Implement SQLAlchemy repository:**
   ```python
   # src/infrastructure/repositories/sqlalchemy_workout_repository.py
   from sqlalchemy.ext.asyncio import AsyncSession
   
   class SQLAlchemyWorkoutRepository(IWorkoutRepository):
       def __init__(self, session: AsyncSession):
           self.session = session
       
       async def create(self, workout: Workout) -> Workout:
           # Implementation here
           pass
   ```

4. **Update dependency injection to use new repository**

## 🔧 Configuration

### Environment Variables

Create a `.env` file based on `.env.example`:

```env
# Application
APP_NAME="AutoFit API"
APP_VERSION="0.1.0"
DEBUG=true

# Database
DATABASE_URL="postgresql+asyncpg://autofit_app:change-me-app@localhost/autofit_catalog_db"

# Security
SECRET_KEY="your-secret-key-change-in-production"
ALGORITHM="HS256"
ACCESS_TOKEN_EXPIRE_MINUTES=30

# CORS
CORS_ORIGINS='["http://localhost:3000", "http://localhost:8000"]'
```

### Adding New Settings

Update `src/core/config/settings.py`:

```python
class Settings(BaseSettings):
    # Your new settings
    redis_url: str = Field(
        default="redis://localhost:6379",
        description="Redis connection URL"
    )
    max_upload_size: int = Field(
        default=10_485_760,  # 10MB
        description="Maximum file upload size in bytes"
    )
```

## 📚 Additional Resources

- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Dependency Injection in Python](https://python-dependency-injector.ets-labs.org/)

## 🤝 Contributing

1. Follow the clean architecture principles
2. Write tests for new features
3. Ensure all tests pass before committing
4. Use meaningful commit messages
5. Keep the code clean and well-documented

## 📄 License

[Your License Here]