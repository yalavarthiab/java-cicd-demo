from fastapi import FastAPI
import datetime

app = FastAPI()

@app.get("/api/time")
def read_time():
    return {"service": "python-service", "time": datetime.datetime.utcnow().isoformat() + "Z"}
