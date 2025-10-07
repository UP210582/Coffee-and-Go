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

Currently using in-memory repository. When adding database support:
1. Keep the repository interfaces unchanged
2. Create new implementations in `src/infrastructure/repositories/`
3. Update dependency injection in `src/core/dependencies/injection.py`

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
