from __future__ import annotations

from pathlib import Path
from typing import Any

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse

BASE_DIR = Path(__file__).resolve().parent
ASSETS_DIR = BASE_DIR / "data" / "assets" / "cities"

app = FastAPI(
    title="Trip Planner Connections API",
    description="Local challenge API. The Flutter client performs cheapest-route calculation.",
    version="1.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

CONNECTIONS: list[dict[str, Any]] = [
    {"departure": "Berlin", "destination": "Paris", "price": 120, "departure_latitude": 52.5200, "departure_longitude": 13.4050, "destination_latitude": 48.8566, "destination_longitude": 2.3522},
    {"departure": "Berlin", "destination": "Amsterdam", "price": 80, "departure_latitude": 52.5200, "departure_longitude": 13.4050, "destination_latitude": 52.3676, "destination_longitude": 4.9041},
    {"departure": "Amsterdam", "destination": "Paris", "price": 60, "departure_latitude": 52.3676, "departure_longitude": 4.9041, "destination_latitude": 48.8566, "destination_longitude": 2.3522},
    {"departure": "Paris", "destination": "Madrid", "price": 95, "departure_latitude": 48.8566, "departure_longitude": 2.3522, "destination_latitude": 40.4168, "destination_longitude": -3.7038},
    {"departure": "Amsterdam", "destination": "Rome", "price": 160, "departure_latitude": 52.3676, "departure_longitude": 4.9041, "destination_latitude": 41.9028, "destination_longitude": 12.4964},
    {"departure": "Rome", "destination": "Athens", "price": 90, "departure_latitude": 41.9028, "departure_longitude": 12.4964, "destination_latitude": 37.9838, "destination_longitude": 23.7275},
    {"departure": "Madrid", "destination": "Lisbon", "price": 55, "departure_latitude": 40.4168, "departure_longitude": -3.7038, "destination_latitude": 38.7223, "destination_longitude": -9.1393},
    {"departure": "Paris", "destination": "Lisbon", "price": 150, "departure_latitude": 48.8566, "departure_longitude": 2.3522, "destination_latitude": 38.7223, "destination_longitude": -9.1393},
]

CITIES = [
    {"name": "Amsterdam", "image_url": "/assets/cities/amsterdam.svg"},
    {"name": "Athens", "image_url": "/assets/cities/athens.svg"},
    {"name": "Berlin", "image_url": "/assets/cities/berlin.svg"},
    {"name": "Lisbon", "image_url": "/assets/cities/lisbon.svg"},
    {"name": "Madrid", "image_url": "/assets/cities/madrid.svg"},
    {"name": "Paris", "image_url": "/assets/cities/paris.svg"},
    {"name": "Rome", "image_url": "/assets/cities/rome.svg"},
]

@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}

@app.get("/connections")
def connections() -> list[dict[str, Any]]:
    return CONNECTIONS

@app.get("/cities")
def cities() -> list[dict[str, str]]:
    return CITIES

@app.get("/assets/cities/{file_name}")
def city_asset(file_name: str) -> FileResponse:
    path = ASSETS_DIR / file_name
    if path.parent != ASSETS_DIR or not path.is_file() or path.suffix.lower() != ".svg":
        raise HTTPException(status_code=404, detail="City asset not found")
    return FileResponse(path, media_type="image/svg+xml")
