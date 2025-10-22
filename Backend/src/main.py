import uvicorn
from src.core.config.app import create_app
from src.core.config.settings import settings
from src.presentation.api.v1 import api_router

# Create FastAPI application
app = create_app()

# Include API routes
app.include_router(api_router, prefix=settings.api_v1_prefix)


@app.get("/")
async def root():
    """Root endpoint"""
    return {
        "message": f"Welcome to {settings.app_name}",
        "version": settings.app_version,
        "docs": "/docs" if settings.debug else "Documentation is disabled",
    }


if __name__ == "__main__":
    uvicorn.run(
        "src.main:app",
        host="127.0.0.1",
        port=8000,
        reload=True,
    )
