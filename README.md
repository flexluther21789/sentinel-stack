# M4 Pro Sentinel Security Stack

A hardened security toolkit for macOS, version-controlled and immutable.

## 🛠 Features
- **Sentinel V2:** Core security monitoring logic.
- **Super Audit:** AI-integrated system forensics.
- **Tripwire:** Real-time file integrity monitoring.
- **Sanitizer:** Environment cleanup and session wiping.

## 🔐 Integrity Check
To verify the scripts haven't been tampered with:
\`\`\`bash
shasum -a 256 -c manifest.sha256
\`\`\`

## 🔄 Deployment
1. \`git clone git@github.com:flexluther21789/sentinel-stack.git\`
2. \`chmod +x *.sh\`
3. \`chflags uchg *.sh\`
