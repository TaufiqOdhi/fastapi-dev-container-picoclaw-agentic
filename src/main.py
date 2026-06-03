from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {
        "message": "Welcome to FastAPI Development with PicoClaw AI Assistant!",
        "status": "success"
    }

@app.get("/health")
def health_check():
    return {"status": "ok"}
