from fastapi import FastAPI
from .api import users

app = FastAPI(title="FastAPI Microservice")

app.include_router(users.router)

@app.get("/")
def health():
    return {"status": "ok"}
