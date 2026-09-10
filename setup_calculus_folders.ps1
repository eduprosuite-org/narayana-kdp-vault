$books = @("Book_1_AP_Calculus_Formula_Guide", "Book_2_AP_Calculus_Prep_Book_2027", "Book_3_AP_Calculus_Practice_Exams")
foreach ($b in $books) {
    $p = Join-Path "d:\Narayana kdp\With 2.o" $b
    $cov = Join-Path $p "Cover_Output_Files"
    $apl = Join-Path $p "APlus_Content_Assets"
    $uni = Join-Path $p "units"
    if (!(Test-Path $cov)) { New-Item -ItemType Directory -Path $cov -Force | Out-Null }
    if (!(Test-Path $apl)) { New-Item -ItemType Directory -Path $apl -Force | Out-Null }
    if (!(Test-Path $uni)) { New-Item -ItemType Directory -Path $uni -Force | Out-Null }
}
Write-Host "Directory structures created for all 3 books!" -ForegroundColor Green