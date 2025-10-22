#!/usr/bin/env python
"""Simple test script to verify the API endpoints work correctly"""

from fastapi.testclient import TestClient
from src.main import app

client = TestClient(app)


def test_root():
    response = client.get("/")
    assert response.status_code == 200
    data = response.json()
    assert "message" in data
    assert "version" in data
    print("✓ Root endpoint works")


def test_health():
    response = client.get("/api/v1/health/")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"
    print("✓ Health endpoint works")


def test_user_crud():
    # Create user
    user_data = {
        "email": "test@example.com",
        "username": "testuser",
        "full_name": "Test User",
    }
    response = client.post("/api/v1/users/", json=user_data)
    assert response.status_code == 201
    created_user = response.json()
    assert created_user["email"] == user_data["email"]
    user_id = created_user["id"]
    print("✓ User creation works")

    # Get user
    response = client.get(f"/api/v1/users/{user_id}")
    assert response.status_code == 200
    retrieved_user = response.json()
    assert retrieved_user["id"] == user_id
    print("✓ User retrieval works")

    # List users
    response = client.get("/api/v1/users/")
    assert response.status_code == 200
    users = response.json()
    assert len(users) > 0
    print("✓ User listing works")

    # Update user
    update_data = {"full_name": "Updated Test User"}
    response = client.put(f"/api/v1/users/{user_id}", json=update_data)
    assert response.status_code == 200
    updated_user = response.json()
    assert updated_user["full_name"] == update_data["full_name"]
    print("✓ User update works")

    # Delete user
    response = client.delete(f"/api/v1/users/{user_id}")
    assert response.status_code == 204
    print("✓ User deletion works")

    # Verify deletion
    response = client.get(f"/api/v1/users/{user_id}")
    assert response.status_code == 404
    print("✓ User deletion verification works")


if __name__ == "__main__":
    print("\n🧪 Testing API endpoints...\n")
    test_root()
    test_health()
    test_user_crud()
    print("\n✅ All tests passed!")
