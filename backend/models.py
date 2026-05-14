from sqlalchemy import Column, Integer, String, Boolean, DateTime
from sqlalchemy.sql import func
from database import Base

class User(Base):
    __tablename__ = "users"

    id            = Column(Integer, primary_key=True, index=True)
    email         = Column(String, unique=True, index=True, nullable=False)
    password      = Column(String, nullable=False)
    username      = Column(String, unique=True, index=True, nullable=True)
    full_name     = Column(String, nullable=True)
    date_of_birth = Column(String, nullable=True)
    is_verified   = Column(Boolean, default=False)

    # Role
    role          = Column(String, nullable=True)  # student / teacher / tutor

    # Student fields
    college       = Column(String, nullable=True)
    admission_id  = Column(String, nullable=True)
    stream        = Column(String, nullable=True)
    semester      = Column(String, nullable=True)
    roll_no       = Column(String, nullable=True)
    year_joined   = Column(String, nullable=True)
    is_approved   = Column(Boolean, default=False)

    # Teacher fields
    teacher_type  = Column(String, nullable=True)  # advisor / subject
    subjects      = Column(String, nullable=True)  # comma separated

    created_at    = Column(DateTime(timezone=True), server_default=func.now())


class OTP(Base):
    __tablename__ = "otps"

    id         = Column(Integer, primary_key=True, index=True)
    email      = Column(String, index=True, nullable=False)
    otp_code   = Column(String, nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())