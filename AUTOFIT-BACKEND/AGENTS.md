# Agent Guidelines for AutoFit Backend

## Project Overview

This is a FastAPI backend following Clean Architecture principles. The codebase is organized in distinct layers with clear separation of concerns.

## Architecture Principles

### Layer Responsibilities

1. **Domain Layer** (`src/domain/`)
   - Pure business logic and entities
   - No dependencies on external frameworks
   - Contains entities and domain-specific exceptions

2. **Application Layer** (`src/application/`)
   - Orchestrates business use cases
   - Defines repository interfaces
   - Framework-agnostic business logic

3. **Infrastructure Layer** (`src/infrastructure/`)
   - Implements repository interfaces
   - Database connections and external services
   - Technical implementation details

4. **Presentation Layer** (`src/presentation/`)
   - REST API endpoints
   - Request/response schemas (Pydantic models)
   - HTTP-specific logic

5. **Core Layer** (`src/core/`)
   - Shared configuration
   - Dependency injection setup
   - Application initialization

## Development Guidelines

### Adding New Features

1. **Start with the Domain**
   - Define entities in `src/domain/entities/`
   - Add domain exceptions if needed

2. **Create Use Cases**
   - Add use case classes in `src/application/use_cases/`
   - Define repository interfaces in `src/application/interfaces/`

3. **Implement Infrastructure**
   - Create repository implementations in `src/infrastructure/repositories/`
   - Currently using in-memory storage, can be replaced with actual database

4. **Build API Layer**
   - Add Pydantic schemas in `src/presentation/schemas/`
   - Create API routes in `src/presentation/api/v1/`
   - Include routes in `src/presentation/api/v1/__init__.py`

5. **Wire Dependencies**
   - Update `src/core/dependencies/injection.py` with new dependencies

### Code Conventions

- **Imports**: Use absolute imports from `src` root
- **Naming**: 
  - Use `I` prefix for interfaces (e.g., `IUserRepository`)
  - Use descriptive names for use cases (e.g., `UserUseCases`)
  - Use `Request`/`Response` suffix for Pydantic schemas
- **Async/Await**: All repository methods and API endpoints should be async
- **Error Handling**: Use domain exceptions and handle them in the presentation layer

### Testing

Use the task runner for common operations:
```bash
# Run tests
uv run poe test        # Basic tests
uv run poe test-full   # Comprehensive tests

# Code quality
uv run poe check       # Lint + typecheck
uv run poe qa          # Full QA suite

# Development
uv run poe dev         # Start dev server
```

Or run manually:
```bash
# Run the test script
uv run python -m src.tests.test_api

# Run linting
uv run ruff check src/

# Run type checking
uv run mypy src/
```

### Environment Configuration

- Configuration is managed via `pydantic-settings`
- Settings are in `src/core/config/settings.py`
- Create `.env` file from `.env.example` for local development

### Database Operations

The application uses PostgreSQL with ACES/PIES schemas for automotive parts and fitment data.

#### Database Structure:
- **pies schema**: Parts, brands, categories, attributes, assets, interchanges
- **aces schema**: Vehicles (make/model/submodel), engines, transmissions, fitment applications

#### Working with the Database:
1. Keep the repository interfaces unchanged
2. Create new implementations in `src/infrastructure/repositories/`
3. Update dependency injection in `src/core/dependencies/injection.py`

#### Key Tables to Know:
- `pies.part`: Core parts table with full-text search
- `pies.brand`: Manufacturer/brand information
- `aces.fitment_application`: Vehicle-to-part compatibility
- `aces.vehicle_make/model/submodel`: Vehicle hierarchy

#### Search Features:
- Full-text search in English and Spanish
- Trigram-based fuzzy search for typo tolerance
- Accent-insensitive search using `unaccent()`

See `database/docs/README.md` for complete database documentation.

### API Versioning

- Current API version: v1
- Routes are prefixed with `/api/v1`
- When creating v2, create new directory structure under `src/presentation/api/v2/`

### Common Patterns

**Dependency Injection**:
```python
from fastapi import Depends
from typing import Annotated

async def endpoint(
    use_cases: Annotated[UserUseCases, Depends(get_user_use_cases)]
):
    ...
```

**Error Handling**:
```python
try:
    result = await use_case.method()
except DomainException as e:
    raise HTTPException(status_code=appropriate_code, detail=str(e))
```

**Entity Creation**:
```python
# Use factory methods in entities
user = User.create(email="...", username="...", full_name="...")
```

## Package Management

- Using `uv` as package manager
- Dependencies in `pyproject.toml`
- Install new packages: `uv add package-name`

## Important Notes

- **No Business Logic in Controllers**: Keep API routes thin
- **No Framework Dependencies in Domain**: Domain should be framework-agnostic
- **Use Type Hints**: Everywhere for better IDE support and type checking
- **Follow Single Responsibility**: Each class/function should have one reason to change
- **Test Behavior, Not Implementation**: Focus on use case outcomes

## File Structure Example

When adding a new entity (e.g., Product):
```
src/
├── domain/entities/product.py
├── application/
│   ├── interfaces/product_repository.py
│   └── use_cases/product_use_cases.py
├── infrastructure/repositories/product_repository.py
├── presentation/
│   ├── schemas/product_schemas.py
│   └── api/v1/products.py
└── core/dependencies/injection.py  # Update with new dependencies
```

## Database Integration Example

When implementing a repository for parts from the PIES schema:

```python
# src/domain/entities/part.py
from dataclasses import dataclass
from typing import Optional, List
from uuid import UUID

@dataclass
class Part:
    part_id: int
    brand_id: int
    mpn: str  # Manufacturer Part Number
    display_name: str
    short_desc: Optional[str] = None
    is_active: bool = True
    # ... other fields

# src/infrastructure/repositories/part_repository.py
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, text

class PostgreSQLPartRepository(IPartRepository):
    def __init__(self, session: AsyncSession):
        self.session = session
    
    async def search_parts(self, query: str, lang: str = 'en') -> List[Part]:
        # Use the full-text search view
        sql = text("""
            SELECT p.part_id, p.mpn, p.display_name, p.short_desc
            FROM pies.part_search_view v
            JOIN pies.part p USING (part_id)
            WHERE v.sv_en @@ plainto_tsquery('english', unaccent(:query))
            ORDER BY ts_rank_cd(v.sv_en, plainto_tsquery('english', unaccent(:query))) DESC
            LIMIT 50
        """)
        
        result = await self.session.execute(sql, {"query": query})
        return [Part(**row._asdict()) for row in result]
    
    async def get_parts_for_vehicle(
        self, 
        make: str, 
        model: str, 
        year: int
    ) -> List[Part]:
        sql = text("""
            SELECT DISTINCT p.part_id, p.mpn, p.display_name
            FROM aces.fitment_application fa
            JOIN pies.part p ON p.part_id = fa.part_id
            JOIN aces.vehicle_model vm ON vm.model_id = fa.model_id
            JOIN aces.vehicle_make mk ON mk.make_id = fa.make_id
            WHERE mk.name = :make 
              AND vm.name = :model
              AND :year BETWEEN fa.year_start AND fa.year_end
              AND p.is_active = true
        """)
        
        result = await self.session.execute(
            sql, 
            {"make": make, "model": model, "year": year}
        )
        return [Part(**row._asdict()) for row in result]
```

## Commit Message Convention

- Use present tense ("Add feature" not "Added feature")
- Be descriptive but concise
- Reference issues when applicable

## Questions or Clarifications

When in doubt:
1. Check existing patterns in the codebase
2. Maintain consistency with current architecture
3. Prioritize clean separation of concerns
4. Keep the code testable and maintainable
