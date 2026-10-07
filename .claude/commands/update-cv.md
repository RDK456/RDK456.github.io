---
description: Update the portfolio from a new resume PDF (details + download) and publish
argument-hint: "[path to resume PDF, default D:\downloads\DhanushResume.pdf]"
---

Update the portfolio site in this folder from a new version of the resume.

PDF: $ARGUMENTS (if empty, use `D:\downloads\DhanushResume.pdf`)

1. Render the PDF to images with `.\tools\pdf-to-png.ps1 -Pdf "<pdf>"` (PowerShell) and Read every page image.
2. Compare the resume with `index.html` and update every place its content appears:
   - hero status line and intro sentence
   - experience: career line segments, tabs and panels (bullets, meter values in `data-w` and labels)
   - projects (only resume projects; keep the GitHub ones unless asked)
   - skills and certifications lists
   - the virtual agent answers in the `intents` array in the script
   - meta description
   Keep the existing design and wording style. Never add the phone number.
3. Copy the PDF over `Dhanush-Kumar-Resume.pdf`.
4. Preview the page, then show the user a short summary of what changed and ask before publishing.
5. On approval: commit with message "Update resume and site details" and push. Confirm https://rdk456.github.io serves the new version.
