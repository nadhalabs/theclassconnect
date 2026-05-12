from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from pydantic import BaseModel
from passlib.context import CryptContext
from database import get_db
from models import User, OTP
from utils.email import generate_otp, send_otp_email

router = APIRouter()
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# ─────────────────────────────────────────────
# DEV MODE — set to False when domain is ready
# ─────────────────────────────────────────────
DEV_MODE = True
DEV_OTP  = "123456"

# ─────────────────────────────────────────────
# SCHEMAS
# ─────────────────────────────────────────────
class RegisterRequest(BaseModel):
    email: str
    password: str

class LoginRequest(BaseModel):
    email: str
    password: str

class VerifyOTPRequest(BaseModel):
    email: str
    otp_code: str

class ProfileRequest(BaseModel):
    email: str
    full_name: str
    username: str
    date_of_birth: str

class CollegeRequest(BaseModel):
    email: str
    college: str

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
        return {"message": "OTP sent to email (DEV MODE: use 123456)", "email": req.email}

    return {"message": "OTP sent to email", "email": req.email}

# ─────────────────────────────────────────────
# LOGIN
# ─────────────────────────────────────────────
@router.post("/login")
def login(req: LoginRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == req.email).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    if not pwd_context.verify(req.password, user.password):
        raise HTTPException(status_code=401, detail="Incorrect password")

    if not user.is_verified:
        otp = generate_otp()
        db.query(OTP).filter(OTP.email == req.email).delete()
        db.commit()
        otp_entry = OTP(email=req.email, otp_code=otp)
        db.add(otp_entry)
        db.commit()
        send_otp_email(req.email, otp)
        raise HTTPException(status_code=403, detail="Email not verified. OTP resent.")

    return {
        "message": "Login successful",
        "email": user.email,
        "username": user.username,
        "full_name": user.full_name,
        "college": user.college,
    }

# ─────────────────────────────────────────────
# VERIFY OTP
# ─────────────────────────────────────────────
@router.post("/verify-otp")
def verify_otp(req: VerifyOTPRequest, db: Session = Depends(get_db)):
    # DEV MODE: accept master OTP
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
# SAVE COLLEGE
# ─────────────────────────────────────────────
@router.post("/college")
def save_college(req: CollegeRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == req.email).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    user.college = req.college
    db.commit()

    return {"message": "College saved successfully", "college": req.college}