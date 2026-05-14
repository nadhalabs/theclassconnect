from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from pydantic import BaseModel
from passlib.context import CryptContext
from database import get_db
from models import User, OTP
from utils.email import generate_otp, send_otp_email
from typing import List, Optional

router = APIRouter()
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# ─────────────────────────────────────────────
# DEV MODE — set to False when domain is ready
# ─────────────────────────────────────────────
DEV_MODE = True
DEV_OTP  = "123456"

# Admin codes — change these to your secret codes
ADVISOR_CODES = ["ADVISOR2024", "UKFADVISOR"]
SUBJECT_CODES = ["SUBJECT2024", "UKFSUBJECT"]

# ─────────────────────────────────────────────
# SCHEMAS
# ─────────────────────────────────────────────
class RegisterRequest(BaseModel):
    email: str
    password: str

class LoginRequest(BaseModel):
    username: str
    password: str

class VerifyOTPRequest(BaseModel):
    email: str
    otp_code: str

class ProfileRequest(BaseModel):
    email: str
    full_name: str
    username: str
    date_of_birth: str

class StudentOnboardRequest(BaseModel):
    email: str
    college: str
    admission_id: str
    stream: str
    semester: str
    roll_no: str
    year_joined: str

class TeacherOnboardRequest(BaseModel):
    email: str
    teacher_type: str
    code: str
    college: str
    stream: Optional[str] = None
    subjects: Optional[List[str]] = None

# ─────────────────────────────────────────────
# REGISTER
# ─────────────────────────────────────────────
@router.post("/register")
def register(req: RegisterRequest, db: Session = Depends(get_db)):
    existing = db.query(User).filter(User.email == req.email).first()
    if existing:
        raise HTTPException(status_code=400, detail="Email already registered")

    hashed = pwd_context.hash(req.password)
    user = User(email=req.email, password=hashed, is_verified=False)
    db.add(user)
    db.commit()

    otp = generate_otp()
    db.query(OTP).filter(OTP.email == req.email).delete()
    db.commit()
    otp_entry = OTP(email=req.email, otp_code=otp)
    db.add(otp_entry)
    db.commit()

    send_otp_email(req.email, otp)

    if DEV_MODE:
        return {"message": "OTP sent (DEV MODE: use 123456)", "email": req.email}
    return {"message": "OTP sent to email", "email": req.email}

# ─────────────────────────────────────────────
# LOGIN (username + password)
# ─────────────────────────────────────────────
@router.post("/login")
def login(req: LoginRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.username == req.username).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    if not pwd_context.verify(req.password, user.password):
        raise HTTPException(status_code=401, detail="Incorrect password")

    if not user.is_verified:
        otp = generate_otp()
        db.query(OTP).filter(OTP.email == user.email).delete()
        db.commit()
        otp_entry = OTP(email=user.email, otp_code=otp)
        db.add(otp_entry)
        db.commit()
        send_otp_email(user.email, otp)
        raise HTTPException(status_code=403, detail="Email not verified. OTP resent.")

    return {
        "message": "Login successful",
        "email": user.email,
        "username": user.username,
        "full_name": user.full_name,
        "college": user.college,
        "role": user.role,
        "teacher_type": user.teacher_type,
        "stream": user.stream,
        "semester": user.semester,
        "is_approved": user.is_approved,
    }

# ─────────────────────────────────────────────
# VERIFY OTP
# ─────────────────────────────────────────────
@router.post("/verify-otp")
def verify_otp(req: VerifyOTPRequest, db: Session = Depends(get_db)):
    if DEV_MODE and req.otp_code == DEV_OTP:
        user = db.query(User).filter(User.email == req.email).first()
        if user:
            user.is_verified = True
            db.commit()
        return {"message": "OTP verified successfully", "email": req.email}

    otp_entry = db.query(OTP).filter(
        OTP.email == req.email,
        OTP.otp_code == req.otp_code
    ).first()

    if not otp_entry:
        raise HTTPException(status_code=400, detail="Invalid OTP")

    user = db.query(User).filter(User.email == req.email).first()
    if user:
        user.is_verified = True
        db.commit()

    db.delete(otp_entry)
    db.commit()

    return {"message": "OTP verified successfully", "email": req.email}

# ─────────────────────────────────────────────
# RESEND OTP
# ─────────────────────────────────────────────
@router.post("/resend-otp")
def resend_otp(req: RegisterRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == req.email).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    otp = generate_otp()
    db.query(OTP).filter(OTP.email == req.email).delete()
    db.commit()
    otp_entry = OTP(email=req.email, otp_code=otp)
    db.add(otp_entry)
    db.commit()
    send_otp_email(req.email, otp)

    if DEV_MODE:
        return {"message": "OTP resent (DEV MODE: use 123456)"}
    return {"message": "OTP resent successfully"}

# ─────────────────────────────────────────────
# SAVE PROFILE
# ─────────────────────────────────────────────
@router.post("/profile")
def save_profile(req: ProfileRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == req.email).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    existing = db.query(User).filter(User.username == req.username).first()
    if existing and existing.email != req.email:
        raise HTTPException(status_code=400, detail="Username already taken")

    user.full_name     = req.full_name
    user.username      = req.username
    user.date_of_birth = req.date_of_birth
    db.commit()

    return {"message": "Profile saved successfully"}

# ─────────────────────────────────────────────
# STUDENT ONBOARD
# ─────────────────────────────────────────────
@router.post("/student-onboard")
def student_onboard(req: StudentOnboardRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == req.email).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    user.role         = "student"
    user.college      = req.college
    user.admission_id = req.admission_id
    user.stream       = req.stream
    user.semester     = req.semester
    user.roll_no      = req.roll_no
    user.year_joined  = req.year_joined
    user.is_approved  = False
    db.commit()

    return {"message": "Student onboarded. Waiting for advisor approval."}

# ─────────────────────────────────────────────
# TEACHER ONBOARD
# ─────────────────────────────────────────────
@router.post("/teacher-onboard")
def teacher_onboard(req: TeacherOnboardRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == req.email).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    if req.teacher_type == "advisor":
        if req.code not in ADVISOR_CODES:
            raise HTTPException(status_code=403, detail="Invalid advisor code")
        user.role         = "teacher"
        user.teacher_type = "advisor"
        user.college      = req.college
        user.stream       = req.stream
        user.is_approved  = True
    elif req.teacher_type == "subject":
        if req.code not in SUBJECT_CODES:
            raise HTTPException(status_code=403, detail="Invalid subject teacher code")
        user.role         = "teacher"
        user.teacher_type = "subject"
        user.college      = req.college
        user.subjects     = ",".join(req.subjects) if req.subjects else ""
        user.is_approved  = True
    else:
        raise HTTPException(status_code=400, detail="Invalid teacher type")

    db.commit()
    return {"message": "Teacher onboarded successfully"}