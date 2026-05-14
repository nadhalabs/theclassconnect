from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routes import auth, college, advisor
from database import engine, Base

Base.metadata.create_all(bind=engine)

app = FastAPI(title="ClassConnect API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router, prefix="/auth", tags=["Auth"])
app.include_router(college.router, prefix="/college", tags=["College"])
app.include_router(advisor.router, prefix="/advisor", tags=["Advisor"])

@app.get("/")
def root():
    return {"message": "ClassConnect API is running"}