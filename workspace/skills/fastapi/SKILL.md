---
name: fastapi
description: Develop, debug, and optimize FastAPI web applications using Python.
homepage: https://fastapi.tiangolo.com/
metadata: {"nanobot":{"emoji":"⚡","requires":{"bins":["python", "uvicorn"]}}}
---

# FastAPI Development

This skill provides guidelines and commands for building and maintaining FastAPI applications.

## Quick Start & Running

Start the development server with live reload:
```bash
uvicorn src.main:app --host 0.0.0.0 --port 8000 --reload
```
*(Adjust `src.main:app` according to the actual entry point of the application)*

## Project Structure Best Practices

Use a modular structure for scalability:
- `src/main.py`: Application factory and entry point
- `src/api/`: API routers and endpoints (`router = APIRouter()`)
- `src/core/`: Configurations, settings, and security
- `src/models/`: Database models (e.g., SQLAlchemy)
- `src/schemas/`: Pydantic models for data validation (Input/Output)
- `src/services/`: Business logic
- `src/db/`: Database session and migrations

## Pydantic Models (Schemas)

Always use Pydantic models for request and response validation.

```python
from pydantic import BaseModel, Field

class ItemCreate(BaseModel):
    name: str = Field(..., title="The name of the item", max_length=100)
    description: str | None = None
    price: float = Field(..., gt=0)
```

## Dependency Injection

Use dependencies for database sessions, authentication, and reusable logic.

```python
from fastapi import Depends, HTTPException
from sqlalchemy.orm import Session
from src.db.session import get_db

def get_item_by_id(item_id: int, db: Session = Depends(get_db)):
    item = db.query(Item).filter(Item.id == item_id).first()
    if not item:
        raise HTTPException(status_code=404, detail="Item not found")
    return item
```

## Testing

Use `pytest` and `TestClient` for testing endpoints.
```python
from fastapi.testclient import TestClient
from src.main import app

client = TestClient(app)

def test_read_main():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"msg": "Hello World"}
```
Run tests with:
```bash
pytest -v
```

## Troubleshooting
- If changes aren't reloading, ensure you run `uvicorn` with the `--reload` flag and the code is mounted properly.
- For async database calls, ensure you are using an async driver (like `asyncpg`) and `AsyncSession`.
