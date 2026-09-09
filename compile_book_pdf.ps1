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

# Compile using jobname to avoid file locks if user has PDF open
$jobName = "Volume_${BookNumber}_Interior_300Page_Master"

Write-Host "[1/2] Running Pass 1..." -ForegroundColor Yellow
& $pdflatex -interaction=nonstopmode -jobname="$jobName" "Volume_${BookNumber}_All_In_One_Manuscript.tex" | Out-Null

Write-Host "[2/2] Running Pass 2 (Table of Contents & Pagination)..." -ForegroundColor Yellow
$logOutput = & $pdflatex -interaction=nonstopmode -jobname="$jobName" "Volume_${BookNumber}_All_In_One_Manuscript.tex"

$sw.Stop()

# Parse page count from output
$pageLine = $logOutput | Select-String "Output written on .* \((\d+) pages"
$pages = if ($pageLine) { $pageLine.Matches[0].Groups[1].Value } else { "Unknown" }

$genPdf = Join-Path $dir "${jobName}.pdf"
$mainPdf = Join-Path $dir "Volume_${BookNumber}_All_In_One_Manuscript.pdf"

# Also try to copy to main PDF if unlocked
try {
    Copy-Item $genPdf $mainPdf -Force -ErrorAction SilentlyContinue
} catch {}

if (Test-Path $genPdf) {
    $pdf = Get-Item $genPdf
    $sizeKb = [math]::Round($pdf.Length / 1KB, 1)
    $elapsedSec = [math]::Round($sw.Elapsed.TotalSeconds, 1)
    Write-Host "`n==========================================================" -ForegroundColor Green
    Write-Host " [SUCCESS] PDF Generated Successfully in $elapsedSec seconds!" -ForegroundColor Green
    Write-Host " Page Count: $pages Pages" -ForegroundColor Green
    Write-Host " Location: $genPdf" -ForegroundColor Green
    Write-Host " File Size: ${sizeKb} KB" -ForegroundColor Green
    Write-Host "==========================================================" -ForegroundColor Green
} else {
    Write-Host "[ERROR] PDF generation failed! Check log file." -ForegroundColor Red
}
