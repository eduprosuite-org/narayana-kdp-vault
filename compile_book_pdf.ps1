param (
    [int]$BookNumber = 2
)

$pdflatex = "C:\Users\Admin\AppData\Local\Programs\MiKTeX\miktex\bin\x64\pdflatex.exe"
if (-not (Test-Path $pdflatex)) {
    Write-Host "[ERROR] pdflatex.exe not found at $pdflatex!" -ForegroundColor Red
    exit 1
}

$bookFolders = Get-ChildItem -Directory -Path "d:\Narayana kdp\With 2.o" -Filter "Book_${BookNumber}_*"
if ($bookFolders.Count -eq 0) {
    Write-Host "[ERROR] Folder Book_${BookNumber}_* not found!" -ForegroundColor Red
    exit 1
}

$dir = $bookFolders[0].FullName
$texFile = Join-Path $dir "Volume_${BookNumber}_All_In_One_Manuscript.tex"
if (-not (Test-Path $texFile)) {
    Write-Host "[ERROR] LaTeX file not found: $texFile" -ForegroundColor Red
    exit 1
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Compiling Book $BookNumber Manuscript to PDF (Local MiKTeX) " -ForegroundColor Cyan
Write-Host " Source: $texFile " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

Set-Location $dir
$sw = [System.Diagnostics.Stopwatch]::StartNew()

# Run pass 1
Write-Host "[1/2] Running Pass 1..." -ForegroundColor Yellow
& $pdflatex -interaction=nonstopmode "Volume_${BookNumber}_All_In_One_Manuscript.tex" | Out-Null

# Run pass 2 (for TOC, page numbers, and cross-references)
Write-Host "[2/2] Running Pass 2 (Table of Contents & Pagination)..." -ForegroundColor Yellow
$out = & $pdflatex -interaction=nonstopmode "Volume_${BookNumber}_All_In_One_Manuscript.tex"

$sw.Stop()

$pdfPath = Join-Path $dir "Volume_${BookNumber}_All_In_One_Manuscript.pdf"
if (Test-Path $pdfPath) {
    $pdf = Get-Item $pdfPath
    $sizeKb = [math]::Round($pdf.Length / 1KB, 1)
    $elapsedSec = [math]::Round($sw.Elapsed.TotalSeconds, 1)
    Write-Host "`n==========================================================" -ForegroundColor Green
    Write-Host " [SUCCESS] PDF Generated Successfully in $elapsedSec seconds!" -ForegroundColor Green
    Write-Host " Location: $pdfPath" -ForegroundColor Green
    Write-Host " File Size: ${sizeKb} KB" -ForegroundColor Green
    Write-Host "==========================================================" -ForegroundColor Green
} else {
    Write-Host "[ERROR] PDF generation failed! Check log file." -ForegroundColor Red
}
