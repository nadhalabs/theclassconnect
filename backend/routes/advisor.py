from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from pydantic import BaseModel
from database import get_db
from models import User

router = APIRouter()

class ApproveRequest(BaseModel):
    advisor_email: str
    student_email: str

# ─────────────────────────────────────────────
# GET PENDING REQUESTS
# ─────────────────────────────────────────────
@router.get("/pending")
def get_pending(email: str, db: Session = Depends(get_db)):
    advisor = db.query(User).filter(User.email == email).first()
    if not advisor or advisor.role != "teacher" or advisor.teacher_type != "advisor":
        raise HTTPException(status_code=403, detail="Not an advisor")

    pending = db.query(User).filter(
        User.role == "student",
        User.stream == advisor.stream,
        User.college == advisor.college,
        User.is_approved == False
    ).all()

    return {
        "requests": [
            {
                "email": s.email,
                "full_name": s.full_name,
                "username": s.username,
                "stream": s.stream,
                "semester": s.semester,
                "admission_id": s.admission_id,
            }
            for s in pending
        ]
    }

# ─────────────────────────────────────────────
# APPROVE STUDENT
# ─────────────────────────────────────────────
@router.post("/approve")
def approve_student(req: ApproveRequest, db: Session = Depends(get_db)):
    student = db.query(User).filter(User.email == req.student_email).first()
    if not student:
        raise HTTPException(status_code=404, detail="Student not found")

    student.is_approved = True
    db.commit()

    return {"message": "Student approved successfully"}

# ─────────────────────────────────────────────
# REJECT STUDENT
# ─────────────────────────────────────────────
@router.post("/reject")
def reject_student(req: ApproveRequest, db: Session = Depends(get_db)):
    student = db.query(User).filter(User.email == req.student_email).first()
    if not student:
        raise HTTPException(status_code=404, detail="Student not found")

    db.delete(student)
    db.commit()

    return {"message": "Student rejected"}