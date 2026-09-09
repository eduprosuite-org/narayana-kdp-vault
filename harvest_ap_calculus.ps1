$headers = @{
    "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36"
    "Accept" = "application/json, text/javascript, */*"
}
$mid = "ATVPDKIKX0DER"
$outDir = "d:\Narayana kdp\With 2.o\Book_AP_Calculus_Prep_2027"
if (!(Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir -Force | Out-Null }

$seeds = [System.Collections.Generic.List[string]]::new()
$seeds.Add("ap calculus")
$seeds.Add("ap calculus ab")
$seeds.Add("ap calculus bc")
$seeds.Add("ap calculus prep book 2027")
$seeds.Add("ap calculus ab prep book 2027")
$seeds.Add("ap calculus bc prep book 2027")
$seeds.Add("ap calculus textbook")
$seeds.Add("ap calculus study guide")
$seeds.Add("ap calculus workbook")
$seeds.Add("ap calculus formula sheet")
$seeds.Add("ap calculus cheat sheet")
$seeds.Add("ap calculus practice test")
$seeds.Add("ap calculus flash cards")
$seeds.Add("ap calculus ab prep book")
$seeds.Add("ap calculus bc prep book")
$seeds.Add("ap calculus crash course")
$seeds.Add("ap calculus frq")

$alphabet = [char[]]([int][char]'a'..[int][char]'z')
foreach ($c in $alphabet) {
    $seeds.Add("ap calculus $c")
    $seeds.Add("ap calculus ab $c")
    $seeds.Add("ap calculus bc $c")
}

$uniqueKeywords = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
$queryLogSb = [System.Text.StringBuilder]::new()
[void]$queryLogSb.AppendLine("# AP Calculus - Amazon Search Auto-Suggestions Query Log")
[void]$queryLogSb.AppendLine("**Marketplace:** Amazon US Real-Time Search Autocomplete")
[void]$queryLogSb.AppendLine("**Timestamp:** $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
[void]$queryLogSb.AppendLine("**Total Seeds:** $($seeds.Count)")
[void]$queryLogSb.AppendLine("")

Write-Host "Harvesting $($seeds.Count) seeds..." -ForegroundColor Cyan

$i = 0
foreach ($q in $seeds) {
    $i++
    $encoded = [System.Uri]::EscapeDataString($q)
    $url = "https://completion.amazon.com/api/2017/suggestions?limit=20`&mid=$mid`&prefix=$encoded`&suggestion-type=KEYWORD`&alias=aps"
    $suggestions = @()
    try {
        $res = Invoke-RestMethod -Uri $url -Headers $headers -TimeoutSec 4 -ErrorAction SilentlyContinue
        if ($res -and $res.suggestions) {
            foreach ($s in $res.suggestions) {
                if ($s.value) {
                    $val = $s.value.Trim().ToLower()
                    $suggestions += $val
                    [void]$uniqueKeywords.Add($val)
                }
            }
        }
    } catch {}

    [void]$queryLogSb.AppendLine("### Search Prefix: ``$q``")
    if ($suggestions.Count -gt 0) {
        [void]$queryLogSb.AppendLine("**Auto-Suggestions Returned ($($suggestions.Count)):**")
        foreach ($sug in $suggestions) {
            [void]$queryLogSb.AppendLine("- ``$sug``")
        }
    } else {
        [void]$queryLogSb.AppendLine("*No direct autocomplete suggestions returned.*")
    }
    [void]$queryLogSb.AppendLine("")
    Start-Sleep -Milliseconds 25
}

$logPath = Join-Path $outDir "AP_Calculus_Amazon_Autosuggestion_Full_Query_Log.md"
[System.IO.File]::WriteAllText($logPath, $queryLogSb.ToString(), [System.Text.Encoding]::UTF8)

$bankSb = [System.Text.StringBuilder]::new()
[void]$bankSb.AppendLine("# AP Calculus - Categorized Master Keyword Bank")
[void]$bankSb.AppendLine("**Data Source:** Amazon Live Search Engine Telemetry")
[void]$bankSb.AppendLine("**Total Unique Customer Search Phrases Harvested:** $($uniqueKeywords.Count)")
[void]$bankSb.AppendLine("**Timestamp:** $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
[void]$bankSb.AppendLine("")
[void]$bankSb.AppendLine("---")
[void]$bankSb.AppendLine("")

$sorted = $uniqueKeywords | Sort-Object
$prepGroup = $sorted | Where-Object { $_ -match "prep|guide|review|course|edition|2027|2026" }
$textbookGroup = $sorted | Where-Object { $_ -match "textbook|high school|curriculum|stewart|larson" }
$workbookGroup = $sorted | Where-Object { $_ -match "workbook|practice|test|problems|questions|frq|calculator|ti 84" }
$otherGroup = $sorted | Where-Object { $prepGroup -notcontains $_ -and $textbookGroup -notcontains $_ -and $workbookGroup -notcontains $_ }

[void]$bankSb.AppendLine("### 1. Prep Books and Study Guides ($($prepGroup.Count) Keywords)")
foreach ($k in $prepGroup) { [void]$bankSb.AppendLine("- ``$k``") }

[void]$bankSb.AppendLine("")
[void]$bankSb.AppendLine("### 2. High School Textbooks and Reference ($($textbookGroup.Count) Keywords)")
foreach ($k in $textbookGroup) { [void]$bankSb.AppendLine("- ``$k``") }

[void]$bankSb.AppendLine("")
[void]$bankSb.AppendLine("### 3. Practice Workbooks, Drills, and FRQ Playbooks ($($workbookGroup.Count) Keywords)")
foreach ($k in $workbookGroup) { [void]$bankSb.AppendLine("- ``$k``") }

[void]$bankSb.AppendLine("")
[void]$bankSb.AppendLine("### 4. Specialized and Long-Tail Search Queries ($($otherGroup.Count) Keywords)")
foreach ($k in $otherGroup) { [void]$bankSb.AppendLine("- ``$k``") }

$bankPath = Join-Path $outDir "AP_Calculus_Amazon_Autosuggestion_Keyword_Bank.md"
[System.IO.File]::WriteAllText($bankPath, $bankSb.ToString(), [System.Text.Encoding]::UTF8)

Write-Host "SUCCESS! Step 1 Complete for AP Calculus. Harvested $($uniqueKeywords.Count) unique keywords." -ForegroundColor Green