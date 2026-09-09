param (
    [string]$FilePath = "d:\Narayana kdp\With 2.o\Book_2_AP_Statistics_Prep_Book_2027\Volume_2_All_In_One_Manuscript.tex"
)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " LaTeX Manuscript Syntax & Integrity Validator " -ForegroundColor Cyan
Write-Host " Target File: $FilePath " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

if (-not (Test-Path $FilePath)) {
    Write-Host "[ERROR] Target file does not exist: $FilePath" -ForegroundColor Red
    exit 1
}

$lines = Get-Content -Path $FilePath -Encoding UTF8
$totalLines = $lines.Count
Write-Host "[INFO] Total Lines Scanned: $totalLines" -ForegroundColor Gray

$errors = 0
$warnings = 0

# 1. Environment Stack Tracker (\begin{env} vs \end{env})
$envStack = New-Object System.Collections.Generic.Stack[PSObject]
$lineNum = 0

foreach ($line in $lines) {
    $lineNum++
    
    # Strip comments (% to end of line, unless escaped \%)
    $cleanLine = [System.Text.RegularExpressions.Regex]::Replace($line, '(?<!\\)%.*$', '')

    # Check \begin{...}
    $beginMatches = [System.Text.RegularExpressions.Regex]::Matches($cleanLine, '\\begin\{([a-zA-Z0-9_\*]+)\}')
    foreach ($m in $beginMatches) {
        $envName = $m.Groups[1].Value
        $envStack.Push([PSCustomObject]@{ Name = $envName; Line = $lineNum })
    }

    # Check \end{...}
    $endMatches = [System.Text.RegularExpressions.Regex]::Matches($cleanLine, '\\end\{([a-zA-Z0-9_\*]+)\}')
    foreach ($m in $endMatches) {
        $envName = $m.Groups[1].Value
        if ($envStack.Count -gt 0) {
            $top = $envStack.Pop()
            if ($top.Name -ne $envName) {
                Write-Host " [ERROR] Line $lineNum : Environment mismatch! Found \end{$envName} but expected \end{$($top.Name)} (opened at line $($top.Line))" -ForegroundColor Red
                $errors++
            }
        } else {
            Write-Host " [ERROR] Line $lineNum : Extra \end{$envName} without matching \begin!" -ForegroundColor Red
            $errors++
        }
    }

    # Check for unescaped percent signs outside comments (e.g., "95%" instead of "95\%")
    if ($cleanLine -match '\d+%(?!\w)') {
        Write-Host " [WARN] Line $lineNum : Possible unescaped '%' sign after digit: '$($matches[0])'. Consider '\%'" -ForegroundColor Yellow
        $warnings++
    }
}

# Check unclosed environments remaining on stack
while ($envStack.Count -gt 0) {
    $unclosed = $envStack.Pop()
    Write-Host " [ERROR] Unclosed environment \begin{$($unclosed.Name)} opened at line $($unclosed.Line)" -ForegroundColor Red
    $errors++
}

# 2. Global Curly Braces Balance Check
$rawText = [System.IO.File]::ReadAllText($FilePath, [System.Text.Encoding]::UTF8)
$noEscapedBraces = $rawText -replace '\\\{', '' -replace '\\\}', ''
$noComments = [System.Text.RegularExpressions.Regex]::Replace($noEscapedBraces, '(?m)(?<!\\)%.*$', '')

$openBraces = ([System.Text.RegularExpressions.Regex]::Matches($noComments, '\{')).Count
$closeBraces = ([System.Text.RegularExpressions.Regex]::Matches($noComments, '\}')).Count

if ($openBraces -ne $closeBraces) {
    Write-Host " [ERROR] Curly brace count mismatch! Open '{' = $openBraces, Close '}' = $closeBraces (Diff: $($openBraces - $closeBraces))" -ForegroundColor Red
    $errors++
} else {
    Write-Host " [PASS] Curly brace integrity verified (Balanced count: $openBraces pairs)" -ForegroundColor Green
}

# 3. Essential Package & Structural Presence Check
$requiredChecks = @(
    @{ Name = "DocumentClass"; Pattern = '\\documentclass' },
    @{ Name = "Geometry Setup"; Pattern = '(?s)\\usepackage\[.*?\]\{geometry\}' },
    @{ Name = "Math Packages"; Pattern = '\\usepackage\{amsmath.*\}' },
    @{ Name = "Begin Document"; Pattern = '\\begin\{document\}' },
    @{ Name = "End Document"; Pattern = '\\end\{document\}' },
    @{ Name = "Nominative Fair Use Disclaimer"; Pattern = 'College Board' }
)

foreach ($chk in $requiredChecks) {
    if ($rawText -match $chk.Pattern) {
        Write-Host " [PASS] Structural requirement '$($chk.Name)' verified." -ForegroundColor Green
    } else {
        Write-Host " [ERROR] Missing required structure or package: $($chk.Name)!" -ForegroundColor Red
        $errors++
    }
}

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host " SUMMARY: $errors Errors | $warnings Warnings" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

if ($errors -eq 0) {
    Write-Host "[SUCCESS] Manuscript syntax is pristine! Ready for Overleaf / KDP compilation." -ForegroundColor Green
    exit 0
} else {
    Write-Host "[ACTION REQUIRED] Found $errors syntax error(s). Please review flagged lines above." -ForegroundColor Red
    exit 1
}
