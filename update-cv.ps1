# Swaps in a new resume PDF and publishes it. The site's "Updated" date refreshes on its own.
# Usage: .\update-cv.ps1                      (uses D:\downloads\DhanushResume.pdf)
#        .\update-cv.ps1 -Pdf C:\path\cv.pdf
# To also refresh the experience/skills text on the site, run /update-cv in Claude Code instead.
param([string]$Pdf = 'D:\downloads\DhanushResume.pdf')

if (-not (Test-Path $Pdf)) { throw "Resume not found: $Pdf" }
Copy-Item $Pdf "$PSScriptRoot\Dhanush-Kumar-Resume.pdf" -Force
git -C $PSScriptRoot add Dhanush-Kumar-Resume.pdf index.html
git -C $PSScriptRoot commit -m "Update resume"
if ($LASTEXITCODE -eq 0) { git -C $PSScriptRoot push; "Published. Live at https://rdk456.github.io in about a minute." }
