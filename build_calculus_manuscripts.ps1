$base = "d:\Narayana kdp\With 2.o"

# Setup Book 1 files
$b1Dir = Join-Path $base "Book_1_AP_Calculus_Formula_Guide"
$b1Units = Join-Path $b1Dir "units"
Copy-Item (Join-Path $base "Book_2_AP_Statistics_Prep_Book_2027\units\*") $b1Units -Force

# Setup Book 2 files
$b2Dir = Join-Path $base "Book_2_AP_Calculus_Prep_Book_2027"
$b2Units = Join-Path $b2Dir "units"
Copy-Item (Join-Path $base "Book_2_AP_Statistics_Prep_Book_2027\units\*") $b2Units -Force

# Setup Book 3 files
$b3Dir = Join-Path $base "Book_3_AP_Calculus_Practice_Exams"
$b3Units = Join-Path $b3Dir "units"
Copy-Item (Join-Path $base "Book_2_AP_Statistics_Prep_Book_2027\units\*") $b3Units -Force

Write-Host "Units templates initialized across all 3 books!" -ForegroundColor Green