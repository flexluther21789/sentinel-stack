
## SOC AUDIT: ATTACK SURFACE (MARCH 2026)
- .70 (GL.iNet): High Risk due to legacy Apache signatures. Action: Check for OpenWrt/Firmware updates.
- .120 (Apple): Medium Risk (LAA MAC 82:...). Action: Match with physical hardware Wi-Fi Address.
- .117 (iPhone): Low Risk. Port 62078 is standard 'usbmuxd' behavior for Wi-Fi Sync.
- Rule: Any established connection from .70 to .201 on port 52302 is an active Data Exfiltration event.
