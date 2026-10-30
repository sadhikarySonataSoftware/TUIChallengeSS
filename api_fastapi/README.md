# Option A — FastAPI

This is the separately provided local API implementation requested by the challenge. It is intentionally independent from the Flutter route calculation.

## Run

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --reload --port 8000
```

Open `http://localhost:8000/docs` for interactive Swagger documentation.

## Test

```bash
pip install pytest httpx
pytest -q
```

The API exposes:

- `GET /connections`
- `GET /cities`
- `GET /assets/cities/<file>.svg`
- `GET /health`

The sample data is deliberately graph-shaped so the Flutter app demonstrates a cheaper multi-leg route versus a direct route.
