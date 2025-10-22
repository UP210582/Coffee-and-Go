#!/bin/bash

# Manual API Testing Script
# Run the server first: uv run python -m src.main

API_BASE="http://localhost:8000"

echo "🔍 Testing AutoFit API"
echo "====================="

echo -e "\n1. Root endpoint:"
curl -s "$API_BASE/" | python3 -m json.tool

echo -e "\n2. Health check:"
curl -s "$API_BASE/api/v1/health/" | python3 -m json.tool

echo -e "\n3. Create a user:"
USER_RESPONSE=$(curl -s -X POST "$API_BASE/api/v1/users/" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "username": "testuser",
    "full_name": "Test User"
  }')
echo "$USER_RESPONSE" | python3 -m json.tool
USER_ID=$(echo "$USER_RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin)['id'])")

echo -e "\n4. Get user by ID:"
curl -s "$API_BASE/api/v1/users/$USER_ID" | python3 -m json.tool

echo -e "\n5. Update user:"
curl -s -X PUT "$API_BASE/api/v1/users/$USER_ID" \
  -H "Content-Type: application/json" \
  -d '{"full_name": "Updated Test User"}' | python3 -m json.tool

echo -e "\n6. List all users:"
curl -s "$API_BASE/api/v1/users/" | python3 -m json.tool

echo -e "\n7. Delete user:"
curl -s -X DELETE "$API_BASE/api/v1/users/$USER_ID"
echo "User deleted (204 No Content)"

echo -e "\n✅ All manual tests completed!"
