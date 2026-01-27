# Check if Git is installed
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "⚠️ Git is not installed on this computer." -ForegroundColor Red
    Write-Host "Please install Git from https://git-scm.com/download/win and try again." -ForegroundColor Yellow
    exit
}

# Prompt user for GitHub Repo URL
Write-Host "🚀 Preparing to upload ART PRINT to GitHub..." -ForegroundColor Cyan
$repoUrl = Read-Host "Please paste your GitHub Repository URL (e.g., https://github.com/username/art-print.git)"

if ([string]::IsNullOrWhiteSpace($repoUrl)) {
    Write-Host "❌ Error: Repository URL cannot be empty." -ForegroundColor Red
    exit
}

# Initialize Git
Write-Host "📂 Initializing Git repository..." -ForegroundColor Green
git init

# Add all files
Write-Host "➕ Adding files..." -ForegroundColor Green
git add .

# Commit files
Write-Host "💾 Committing files..." -ForegroundColor Green
git commit -m "Initial commit - ART PRINT Website with PWA and Feedback System"

# Rename branch to main
git branch -M main

# Add remote origin
Write-Host "🔗 Linking to remote repository..." -ForegroundColor Green
git remote remove origin 2>$null # Remove if exists to avoid errors
git remote add origin $repoUrl

# Push to GitHub
Write-Host "☁️ Pushing code to GitHub..." -ForegroundColor Cyan
git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Upload Complete! Your website source code is now on GitHub." -ForegroundColor Green
}
else {
    Write-Host "⚠️ Upload failed. Please check the following:" -ForegroundColor Yellow
    Write-Host "1. Is the URL correct?"
    Write-Host "2. Do you have permission to write to this repository?"
    Write-Host "3. Is the repository empty? (If not, you might need to pull first)"
}

Pause
