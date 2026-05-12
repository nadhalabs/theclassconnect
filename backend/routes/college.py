from fastapi import APIRouter

router = APIRouter()

COLLEGES = [
    "MIT — Massachusetts Institute of Technology",
    "Stanford University",
    "Harvard University",
    "IIT Bombay",
    "IIT Delhi",
    "IIT Madras",
    "University of Oxford",
    "University of Cambridge",
    "National University of Singapore",
    "UC Berkeley",
    "Caltech",
    "ETH Zurich",
    "University of Toronto",
    "University of Melbourne",
    "Delhi University",
    "Amrita Vishwa Vidyapeetham",
    "BITS Pilani",
    "VIT University",
    "Anna University",
    "Cochin University of Science and Technology",
]

@router.get("/list")
def get_colleges():
    return {"colleges": COLLEGES}