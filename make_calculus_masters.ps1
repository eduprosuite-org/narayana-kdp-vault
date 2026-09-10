$template = Get-Content -Raw -Path "d:\Narayana kdp\With 2.o\Book_2_AP_Statistics_Prep_Book_2027\Volume_2_All_In_One_Manuscript.tex"

# Book 1
$b1 = $template -replace "AP Statistics Prep Book 2027", "AP Calculus Formula & Theorem Quick Study Guide 2027" `
  -replace "The Complete Study Guide & Textbook for High School Students Featuring Practice Workbooks, TI-84 Playbooks, and 2027 Full-Length Exams", "The High-Yield Score-5 Cram Companion: Rapid Derivative & Integral Rules, Essential Existence Theorems, and FRQ Justification Templates" `
  -replace "AP Statistics Master Review Series --- Book 2", "AP Calculus Master Review Series --- Book 1"
[System.IO.File]::WriteAllText("d:\Narayana kdp\With 2.o\Book_1_AP_Calculus_Formula_Guide\Volume_1_All_In_One_Manuscript.tex", $b1, [System.Text.Encoding]::UTF8)

# Book 2
$b2 = $template -replace "AP Statistics Prep Book 2027", "AP Calculus AB & BC Prep Book 2027" `
  -replace "The Complete Study Guide & Textbook for High School Students Featuring Practice Workbooks, TI-84 Playbooks, and 2027 Full-Length Exams", "The Complete High School Textbook & Study Guide with Practice Workbooks, Drill Sets, and Exam Strategies" `
  -replace "AP Statistics Master Review Series --- Book 2", "AP Calculus Master Review Series --- Book 2"
[System.IO.File]::WriteAllText("d:\Narayana kdp\With 2.o\Book_2_AP_Calculus_Prep_Book_2027\Volume_2_All_In_One_Manuscript.tex", $b2, [System.Text.Encoding]::UTF8)

# Book 3
$b3 = $template -replace "AP Statistics Prep Book 2027", "AP Calculus: 10 Full-Length Practice Exams & FRQ Scoring Playbook 2027" `
  -replace "The Complete Study Guide & Textbook for High School Students Featuring Practice Workbooks, TI-84 Playbooks, and 2027 Full-Length Exams", "The Ultimate Score-5 Simulator: Timed MCQs with Calculator/Non-Calculator Sections, Official Scoring Guidelines, and Model Solutions" `
  -replace "AP Statistics Master Review Series --- Book 2", "AP Calculus Master Review Series --- Book 3"
[System.IO.File]::WriteAllText("d:\Narayana kdp\With 2.o\Book_3_AP_Calculus_Practice_Exams\Volume_3_All_In_One_Manuscript.tex", $b3, [System.Text.Encoding]::UTF8)

Write-Host "Created Master LaTeX files for all 3 books from working template!" -ForegroundColor Green