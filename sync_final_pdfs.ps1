$base = "d:\Narayana kdp\With 2.o"

# Book 1
$b1Pdf = Join-Path $base "Book_1_AP_Calculus_Formula_Guide\Volume_1_Interior_300Page_Master.pdf"
$b1Target = Join-Path $base "Book_1_AP_Calculus_Formula_Guide\Volume_1_All_In_One_Manuscript.pdf"
if (Test-Path $b1Pdf) { Copy-Item $b1Pdf $b1Target -Force }

# Book 2
$b2Pdf = Join-Path $base "Book_2_AP_Calculus_Prep_Book_2027\Volume_2_Interior_300Page_Master.pdf"
$b2Target = Join-Path $base "Book_2_AP_Calculus_Prep_Book_2027\Volume_2_All_In_One_Manuscript.pdf"
if (Test-Path $b2Pdf) { Copy-Item $b2Pdf $b2Target -Force }

# Book 3
$b3Pdf = Join-Path $base "Book_3_AP_Calculus_Practice_Exams\Volume_3_Interior_300Page_Master.pdf"
$b3Target = Join-Path $base "Book_3_AP_Calculus_Practice_Exams\Volume_3_All_In_One_Manuscript.pdf"
if (Test-Path $b3Pdf) { Copy-Item $b3Pdf $b3Target -Force }

Write-Host "Interior PDFs synced!" -ForegroundColor Green