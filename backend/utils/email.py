import resend
import random
import string
import os
from dotenv import load_dotenv

load_dotenv()

resend.api_key = os.getenv("RESEND_API_KEY")

def generate_otp():
    return ''.join(random.choices(string.digits, k=6))

def send_otp_email(to_email: str, otp: str):
    try:
        resend.Emails.send({
            "from": "onboarding@resend.dev",
            "to": to_email,
            "subject": "Your ClassConnect Verification Code",
            "html": f"""
            <html>
              <body style="background:#0A0A0A; font-family:sans-serif; padding:40px;">
                <div style="max-width:480px; margin:auto; background:#141414; border:1px solid #2A2A2A; border-radius:20px; padding:40px;">
                  <h2 style="color:#F2F2F2; letter-spacing:-0.8px;">Class Connect</h2>
                  <p style="color:#8A8A8A; font-size:14px;">Your verification code is:</p>
                  <div style="background:#1C1C1C; border:1px solid #2A2A2A; border-radius:12px; padding:24px; text-align:center; margin:24px 0;">
                    <span style="color:#D4D4D4; font-size:36px; font-weight:700; letter-spacing:12px;">{otp}</span>
                  </div>
                  <p style="color:#8A8A8A; font-size:12px;">Enter this code in the ClassConnect app to verify your account.</p>
                </div>
              </body>
            </html>
            """
        })
        return True
    except Exception as e:
        print(f"Email error: {e}")
        return False