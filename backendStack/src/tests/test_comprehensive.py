#!/usr/bin/env python
"""Comprehensive API test suite"""

from fastapi.testclient import TestClient
from src.main import app
from uuid import uuid4

client = TestClient(app)


def test_api_root():
    """Test root endpoint"""
    print("\n📍 Testing Root Endpoint...")
    response = client.get("/")
    assert response.status_code == 200
    data = response.json()
    assert "message" in data
    assert "AutoFit API" in data["message"]
    print(f"  ✓ Root: {data['message']}")


def test_health_check():
    """Test health check endpoint"""
    print("\n🏥 Testing Health Check...")
    response = client.get("/api/v1/health/")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"
    assert data["service"] == "AutoFit API"
    print(f"  ✓ Status: {data['status']}")
    print(f"  ✓ Service: {data['service']}")
    print(f"  ✓ Version: {data['version']}")


def test_user_crud_operations():
    """Test complete user CRUD operations"""
    print("\n👤 Testing User CRUD Operations...")

    # 1. Create User
    print("  1️⃣ Creating user...")
    user_data = {
        "email": "john.doe@example.com",
        "username": "johndoe",
        "full_name": "John Doe",
    }
    response = client.post("/api/v1/users/", json=user_data)
    assert response.status_code == 201
    created_user = response.json()
    user_id = created_user["id"]
    print(f"     ✓ Created user: {created_user['username']} (ID: {user_id})")

    # 2. Get User by ID
    print("  2️⃣ Retrieving user...")
    response = client.get(f"/api/v1/users/{user_id}")
    assert response.status_code == 200
    retrieved_user = response.json()
    assert retrieved_user["email"] == user_data["email"]
    print(f"     ✓ Retrieved: {retrieved_user['full_name']}")

    # 3. List Users
    print("  3️⃣ Listing users...")
    response = client.get("/api/v1/users/")
    assert response.status_code == 200
    users = response.json()
    assert len(users) > 0
    print(f"     ✓ Found {len(users)} user(s)")

    # 4. Update User
    print("  4️⃣ Updating user...")
    update_data = {"full_name": "John M. Doe"}
    response = client.put(f"/api/v1/users/{user_id}", json=update_data)
    assert response.status_code == 200
    updated_user = response.json()
    assert updated_user["full_name"] == update_data["full_name"]
    print(f"     ✓ Updated name to: {updated_user['full_name']}")

    # 5. Delete User
    print("  5️⃣ Deleting user...")
    response = client.delete(f"/api/v1/users/{user_id}")
    assert response.status_code == 204
    print("     ✓ User deleted")

    # 6. Verify Deletion
    print("  6️⃣ Verifying deletion...")
    response = client.get(f"/api/v1/users/{user_id}")
    assert response.status_code == 404
    print("     ✓ User not found (as expected)")


def test_user_validation_errors():
    """Test validation and error handling"""
    print("\n⚠️ Testing Error Handling...")

    # 1. Test duplicate email
    print("  1️⃣ Testing duplicate email...")
    user_data = {
        "email": "duplicate@example.com",
        "username": "unique1",
        "full_name": "Test User 1",
    }
    response = client.post("/api/v1/users/", json=user_data)
    assert response.status_code == 201
    first_user_id = response.json()["id"]

    # Try to create another user with same email
    user_data["username"] = "unique2"
    response = client.post("/api/v1/users/", json=user_data)
    assert response.status_code == 409
    error = response.json()
    assert "already exists" in error["detail"]
    print(f"     ✓ Duplicate email rejected: {error['detail']}")

    # 2. Test duplicate username
    print("  2️⃣ Testing duplicate username...")
    user_data = {
        "email": "different@example.com",
        "username": "unique1",  # Same as first user
        "full_name": "Test User 2",
    }
    response = client.post("/api/v1/users/", json=user_data)
    assert response.status_code == 409
    error = response.json()
    assert "username" in error["detail"].lower()
    print(f"     ✓ Duplicate username rejected: {error['detail']}")

    # 3. Test invalid UUID
    print("  3️⃣ Testing invalid UUID...")
    response = client.get("/api/v1/users/invalid-uuid")
    assert response.status_code == 422
    print("     ✓ Invalid UUID rejected")

    # 4. Test non-existent user
    print("  4️⃣ Testing non-existent user...")
    fake_uuid = str(uuid4())
    response = client.get(f"/api/v1/users/{fake_uuid}")
    assert response.status_code == 404
    error = response.json()
    assert "not found" in error["detail"].lower()
    print(f"     ✓ Non-existent user: {error['detail']}")

    # Clean up
    client.delete(f"/api/v1/users/{first_user_id}")


def test_pagination():
    """Test pagination functionality"""
    print("\n📄 Testing Pagination...")

    # Create multiple users
    print("  Creating 5 test users...")
    user_ids = []
    for i in range(5):
        user_data = {
            "email": f"user{i}@example.com",
            "username": f"user{i}",
            "full_name": f"Test User {i}",
        }
        response = client.post("/api/v1/users/", json=user_data)
        assert response.status_code == 201
        user_ids.append(response.json()["id"])
    print(f"     ✓ Created {len(user_ids)} users")

    # Test pagination
    print("  Testing pagination parameters...")

    # Get first 2 users
    response = client.get("/api/v1/users/?skip=0&limit=2")
    assert response.status_code == 200
    users = response.json()
    assert len(users) == 2
    print(f"     ✓ Limit=2: Retrieved {len(users)} users")

    # Skip first 2 users
    response = client.get("/api/v1/users/?skip=2&limit=10")
    assert response.status_code == 200
    users = response.json()
    assert len(users) == 3
    print(f"     ✓ Skip=2: Retrieved {len(users)} remaining users")

    # Clean up
    print("  Cleaning up test users...")
    for user_id in user_ids:
        client.delete(f"/api/v1/users/{user_id}")
    print(f"     ✓ Cleaned up {len(user_ids)} users")


def test_api_documentation():
    """Test that API documentation is accessible"""
    print("\n📚 Testing API Documentation...")

    # OpenAPI schema should always be available
    response = client.get("/openapi.json")
    assert response.status_code == 200
    schema = response.json()
    assert "openapi" in schema
    assert "paths" in schema
    print(f"     ✓ OpenAPI schema available (version {schema['openapi']})")
    print(f"     ✓ Found {len(schema['paths'])} API paths")

    # List the available paths
    print("     📋 Available endpoints:")
    for path in sorted(schema["paths"].keys()):
        methods = list(schema["paths"][path].keys())
        print(f"        • {path}: {', '.join(methods).upper()}")


def main():
    """Run all tests"""
    print("=" * 60)
    print("🚀 COMPREHENSIVE API TEST SUITE")
    print("=" * 60)

    try:
        test_api_root()
        test_health_check()
        test_user_crud_operations()
        test_user_validation_errors()
        test_pagination()
        test_api_documentation()

        print("\n" + "=" * 60)
        print("✅ ALL TESTS PASSED SUCCESSFULLY!")
        print("=" * 60)

    except AssertionError as e:
        print(f"\n❌ Test failed: {e}")
        raise
    except Exception as e:
        print(f"\n❌ Unexpected error: {e}")
        raise


if __name__ == "__main__":
    main()
