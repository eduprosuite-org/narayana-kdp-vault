$pdflatex = "C:\Users\Admin\AppData\Local\Programs\MiKTeX\miktex\bin\x64\pdflatex.exe"
$base = "d:\Narayana kdp\With 2.o"

$books = @(
    @{ Id=1; Dir="Book_1_AP_Calculus_Formula_Guide"; Tex="Volume_1_All_In_One_Manuscript.tex"; OutPdf="Volume_1_Interior_300Page_Master.pdf" },
    @{ Id=2; Dir="Book_2_AP_Calculus_Prep_Book_2027"; Tex="Volume_2_All_In_One_Manuscript.tex"; OutPdf="Volume_2_Interior_300Page_Master.pdf" },
    @{ Id=3; Dir="Book_3_AP_Calculus_Practice_Exams"; Tex="Volume_3_All_In_One_Manuscript.tex"; OutPdf="Volume_3_Interior_300Page_Master.pdf" }
)

foreach ($b in $books) {
    $dir = Join-Path $base $b.Dir
    Set-Location $dir
    Write-Host "Compiling Book $($b.Id) Manuscript in $dir..." -ForegroundColor Cyan
    
    # Pass 1
    & $pdflatex -interaction=nonstopmode -jobname="Volume_$($b.Id)_Interior_300Page_Master" $b.Tex | Out-Null
    # Pass 2
    $out = & $pdflatex -interaction=nonstopmode -jobname="Volume_$($b.Id)_Interior_300Page_Master" $b.Tex
    
    $pageLine = $out | Select-String "Output written on .* \((\d+) pages"
    if ($pageLine) {
        Write-Host "SUCCESS: Book $($b.Id) -> $($pageLine.Matches[0].Groups[0].Value)" -ForegroundColor Green
    } else {
        Write-Host "Warning on Book $($b.Id)" -ForegroundColor Yellow
    }
}
Write-Host "`nAll 3 Book Manuscripts Compiled!" -ForegroundColor Green