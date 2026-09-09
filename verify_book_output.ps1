param (
    [int]$BookNumber = 2
)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " AP Statistics Master Review Series - Quality Gate Check " -ForegroundColor Cyan
Write-Host " Checking Book $BookNumber Output Artifacts " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$bookFolders = Get-ChildItem -Directory -Path "d:\Narayana kdp\With 2.o" -Filter "Book_${BookNumber}_*"
if ($bookFolders.Count -eq 0) {
    Write-Host "[ERROR] Could not find folder matching 'Book_${BookNumber}_*'!" -ForegroundColor Red
    exit 1
}

$targetDir = $bookFolders[0].FullName
Write-Host "[INFO] Target Directory: $targetDir" -ForegroundColor Gray

$passed = 0
$warnings = 0
$failed = 0

function Report-Check {
    param (
        [string]$Name,
        [bool]$Condition,
        [string]$Details,
        [bool]$IsWarning = $false
    )
    if ($Condition) {
        Write-Host " [PASS] $Name - $Details" -ForegroundColor Green
        $script:passed++
    } elseif ($IsWarning) {
        Write-Host " [WARN] $Name - $Details" -ForegroundColor Yellow
        $script:warnings++
    } else {
        Write-Host " [FAIL] $Name - $Details" -ForegroundColor Red
        $script:failed++
    }
}

# 1. Manuscript Check
$mainTex = Join-Path $targetDir "Volume_${BookNumber}_All_In_One_Manuscript.tex"
if (Test-Path $mainTex) {
    $allTexFiles = Get-ChildItem -Path $targetDir -Filter "*.tex" -Recurse
    $totalLines = ($allTexFiles | Get-Content -Encoding UTF8 | Measure-Object -Line).Lines
    $totalBytes = ($allTexFiles | Measure-Object -Property Length -Sum).Sum
    $sizeKb = [math]::Round($totalBytes / 1KB, 1)
    $hasMinLines = $totalLines -ge 1200
    $msg = "$totalLines lines, ${sizeKb}KB across $($allTexFiles.Count) TeX files"
    Report-Check -Name "Manuscript Volume_$BookNumber (.tex)" -Condition ($hasMinLines -and ($sizeKb -ge 50)) -Details $msg
} else {
    Report-Check "Manuscript Volume_$BookNumber (.tex)" $false "Main manuscript .tex file missing!"
}

# 2. SEO & Roadmap Check
$pkgFile = Join-Path $targetDir "Book_${BookNumber}_KDP_Publishing_Package.md"
Report-Check "SEO Metadata Package" (Test-Path $pkgFile) "Book_${BookNumber}_KDP_Publishing_Package.md"

$tocFile = Join-Path $targetDir "Book_${BookNumber}_Table_of_Contents_Detailed.md"
Report-Check "Detailed 9-Unit TOC" (Test-Path $tocFile) "Book_${BookNumber}_Table_of_Contents_Detailed.md"

$roadmapFile = Join-Path $targetDir "Book_${BookNumber}_Master_Series_Roadmap_and_Architecture.md"
Report-Check "Series Roadmap File" (Test-Path $roadmapFile) "Book_${BookNumber}_Master_Series_Roadmap_and_Architecture.md"

# 3. Covers Suite Check (25 Files: 5 Kindle, 10 Paperback, 10 Hardcover)
$coverDir = Join-Path $targetDir "Cover_Output_Files"
if (Test-Path $coverDir) {
    $kindleJpgs = Get-ChildItem -Path $coverDir -Filter "Kindle_Cover_Design_*.jpg"
    $allKindleAi = $true
    foreach ($k in $kindleJpgs) {
        if ($k.Length -lt 200KB) { $allKindleAi = $false }
    }
    Report-Check "Kindle AI 3D Covers" ($kindleJpgs.Count -eq 5 -and $allKindleAi) "Found $($kindleJpgs.Count)/5 files (AI size check: $allKindleAi)"

    $pbJpg = (Get-ChildItem -Path $coverDir -Filter "Paperback_Cover_Design_*_FullWrap.jpg").Count
    $pbPdf = (Get-ChildItem -Path $coverDir -Filter "Paperback_Cover_Design_*_FullWrap.pdf").Count
    Report-Check "Paperback Full-Wrap Suite" ($pbJpg -eq 5 -and $pbPdf -eq 5) "5 JPGs ($pbJpg/5) + 5 PDFs ($pbPdf/5)"

    $hcJpg = (Get-ChildItem -Path $coverDir -Filter "Hardcover_Cover_Design_*_CaseLaminate.jpg").Count
    $hcPdf = (Get-ChildItem -Path $coverDir -Filter "Hardcover_Cover_Design_*_CaseLaminate.pdf").Count
    Report-Check "Hardcover Laminate Suite" ($hcJpg -eq 5 -and $hcPdf -eq 5) "5 JPGs ($hcJpg/5) + 5 PDFs ($hcPdf/5)"
} else {
    Report-Check "Cover Output Folder" $false "Missing Cover_Output_Files directory!"
}

# 4. A+ Content Suite Check (6 Modules)
$aplusDir = Join-Path $targetDir "APlus_Content_Assets"
if (Test-Path $aplusDir) {
    $aplusExpected = @(
        "KDP_Module_1_Choose_Standard_Image_Header_with_Text_970x600.jpg",
        "KDP_Module_2_Choose_Standard_Three_Image_and_Text_Card_1_300x300.jpg",
        "KDP_Module_2_Choose_Standard_Three_Image_and_Text_Card_2_300x300.jpg",
        "KDP_Module_2_Choose_Standard_Three_Image_and_Text_Card_3_300x300.jpg",
        "KDP_Module_4_Choose_Standard_Single_Image_and_Sidebar_300x300.jpg",
        "KDP_Alternative_Choose_Standard_Single_Image_and_Highlights_970x300.jpg"
    )

    $existingAplus = 0
    $aiGeneratedAplus = 0

    foreach ($file in $aplusExpected) {
        $p = Join-Path $aplusDir $file
        if (Test-Path $p) {
            $existingAplus++
            $fi = Get-Item $p
            if ($fi.Length -ge 150KB) { $aiGeneratedAplus++ }
        }
    }

    $aplusAllGood = ($existingAplus -eq 6) -and ($aiGeneratedAplus -eq 6)
    $apMsg = "$existingAplus/6 files present, $aiGeneratedAplus/6 photorealistic 3D >= 150KB"
    Report-Check -Name "Amazon A+ 3D Assets" -Condition $aplusAllGood -Details $apMsg -IsWarning ($aiGeneratedAplus -lt 6)
} else {
    Report-Check -Name "A+ Content Folder" -Condition $false -Details "Missing APlus_Content_Assets folder!"
}

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host " SUMMARY: $passed Passed | $warnings Warnings | $failed Failed" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

if ($failed -eq 0 -and $warnings -eq 0) {
    Write-Host "[SUCCESS] Book $BookNumber meets all Gold Standard Quality Gate specifications! Ready for Amazon KDP." -ForegroundColor Green
    exit 0
} elseif ($failed -eq 0) {
    Write-Host "[ATTENTION] Book $BookNumber passed all hard requirements with minor warnings." -ForegroundColor Yellow
    exit 0
} else {
    Write-Host "[ACTION REQUIRED] Quality Gate failed with $failed errors. Please resolve before publishing." -ForegroundColor Red
    exit 1
}
