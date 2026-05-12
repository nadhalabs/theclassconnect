from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routes import auth, college
from database import engine, Base

# Create all tables
Base.metadata.create_all(bind=engine)

app = FastAPI(title="ClassConnect API")

# Allow Flutter app to connect
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Routes
app.include_router(auth.router, prefix="/auth", tags=["Auth"])
app.include_router(college.router, prefix="/college", tags=["College"])

@app.get("/")
def root():
    return {"message": "ClassConnect API is running"}