from pydantic_settings import BaseSettings
from pydantic import Field


class Settings(BaseSettings):
    # Application settings
    app_name: str = Field(default="AutoFit API")
    app_version: str = Field(default="0.1.0")
    debug: bool = Field(default=False)

    # API settings
    api_v1_prefix: str = Field(default="/api/v1")

    # Database settings
    database_url: str = Field(
        default="sqlite:///./autofit.db", description="Database connection URL"
    )

    # CORS settings
    cors_origins: list[str] = Field(
        default=["http://localhost:3000", "http://localhost:8000"],
        description="Allowed CORS origins",
    )

    # JWT settings
    secret_key: str = Field(
        default="your-secret-key-here-change-in-production",
        description="Secret key for JWT encoding",
    )
    algorithm: str = Field(default="HS256")
    access_token_expire_minutes: int = Field(default=30)

    class Config:
        env_file = ".env"
        case_sensitive = False


settings = Settings()
