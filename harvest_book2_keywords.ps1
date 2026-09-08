# =========================================================================
# BOOK 2: AP STATISTICS PREP BOOK 2027 - TARGETED KEYWORD HARVESTER
# =========================================================================

$headers = @{
    "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36"
    "Accept" = "application/json, text/javascript, */*"
}

$mid = "ATVPDKIKX0DER"
$outDir = "d:\Narayana kdp\With 2.o\Book_2_AP_Statistics_Prep_Book_2027"
if (!(Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir -Force | Out-Null }

$seeds = [System.Collections.Generic.List[string]]::new()

# Primary Book 2 Target Seeds
$seeds.Add("ap statistics prep book 2027")
$seeds.Add("ap statistics prep book")
$seeds.Add("ap statistics prep")
$seeds.Add("ap statistics textbook for high school")
$seeds.Add("ap statistics textbook")
$seeds.Add("ap statistics study guide")
$seeds.Add("ap statistics workbook")
$seeds.Add("ap statistics practice workbook")
$seeds.Add("ap stats prep book 2027")
$seeds.Add("ap stats textbook")
$seeds.Add("ap statistics for people who hate ap statistics")
$seeds.Add("ap statistics 2027")
$seeds.Add("ap statistics crash course")
$seeds.Add("ap statistics exam strategies")
$seeds.Add("ap statistics practice questions")
$seeds.Add("ap statistics ti 84")

# Alphabetical permutations
$alphabet = [char[]]([int][char]'a'..[int][char]'z')
foreach ($c in $alphabet) {
    $seeds.Add("ap statistics prep $c")
    $seeds.Add("ap statistics textbook $c")
    $seeds.Add("ap statistics study $c")
}

$uniqueKeywords = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
$queryLogSb = [System.Text.StringBuilder]::new()

[void]$queryLogSb.AppendLine("# Book 2: AP Statistics Prep Book 2027 - Amazon Search Auto-Suggestions Query Log")
[void]$queryLogSb.AppendLine("**Target Focus:** AP Statistics Comprehensive Prep Books, High School Textbooks, and Practice Workbooks")
[void]$queryLogSb.AppendLine("**Marketplace:** Amazon US Real-Time Search Autocomplete")
[void]$queryLogSb.AppendLine("**Timestamp:** $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
[void]$queryLogSb.AppendLine("**Total Query Seeds Harvested:** $($seeds.Count)")
[void]$queryLogSb.AppendLine("")
[void]$queryLogSb.AppendLine("---")
[void]$queryLogSb.AppendLine("")

Write-Host "Harvesting Book 2 search telemetry across $($seeds.Count) seeds..." -ForegroundColor Cyan

$i = 0
foreach ($q in $seeds) {
    $i++
    $encoded = [System.Uri]::EscapeDataString($q)
    $url = "https://completion.amazon.com/api/2017/suggestions?limit=20&mid=$mid&prefix=$encoded&suggestion-type=KEYWORD&alias=aps"
    
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

    Start-Sleep -Milliseconds 30
}

# Save Query Log
$logPath = Join-Path $outDir "Book_2_Amazon_Autosuggestion_Full_Query_Log.md"
[System.IO.File]::WriteAllText($logPath, $queryLogSb.ToString(), [System.Text.Encoding]::UTF8)

# Save Categorized Keyword Bank
$sorted = $uniqueKeywords | Sort-Object

$prepBookGroup = $sorted | Where-Object { $_ -match "prep|guide|review|course|edition|2027|2026" }
$textbookGroup = $sorted | Where-Object { $_ -match "textbook|high school|curriculum|starnes" }
$workbookGroup = $sorted | Where-Object { $_ -match "workbook|practice|test|problems|questions|frq|ti 84" }
$otherGroup = $sorted | Where-Object { $prepBookGroup -notcontains $_ -and $textbookGroup -notcontains $_ -and $workbookGroup -notcontains $_ }

$bankSb = [System.Text.StringBuilder]::new()
[void]$bankSb.AppendLine("# Book 2: AP Statistics Prep Book 2027 - Categorized Master Keyword Bank")
[void]$bankSb.AppendLine("**Data Source:** Amazon Live Search Engine Telemetry")
[void]$bankSb.AppendLine("**Total Unique Customer Search Phrases Harvested:** $($uniqueKeywords.Count)")
[void]$bankSb.AppendLine("**Timestamp:** $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
[void]$bankSb.AppendLine("")
[void]$bankSb.AppendLine("---")
[void]$bankSb.AppendLine("")
[void]$bankSb.AppendLine("## Top Primary Search Queries for Book 2 Placement")
[void]$bankSb.AppendLine("- **ap statistics prep book 2027** (Main Title Anchor)")
[void]$bankSb.AppendLine("- **ap statistics textbook for high school** (Subtitle Anchor)")
[void]$bankSb.AppendLine("- **ap statistics prep textbook 2027** (Cross-Niche Hook)")
[void]$bankSb.AppendLine("- **ap statistics workbook with practice tests** (Workbook Hook)")
[void]$bankSb.AppendLine("- **ap stats prep book 2027** (Shortform Query Match)")
[void]$bankSb.AppendLine("- **ap statistics study guide 2026-2027** (Study Guide Search)")
[void]$bankSb.AppendLine("- **ap statistics for people who hate ap statistics** (High-Intent Niche)")
[void]$bankSb.AppendLine("")
[void]$bankSb.AppendLine("---")
[void]$bankSb.AppendLine("")
[void]$bankSb.AppendLine("## Keyword Intelligence Grouping")
[void]$bankSb.AppendLine("")
[void]$bankSb.AppendLine("### 1. Prep Books and Study Guides ($($prepBookGroup.Count) Keywords)")
foreach ($k in $prepBookGroup) { [void]$bankSb.AppendLine("- ``$k``") }

[void]$bankSb.AppendLine("")
[void]$bankSb.AppendLine("### 2. High School Textbooks and Curricula ($($textbookGroup.Count) Keywords)")
foreach ($k in $textbookGroup) { [void]$bankSb.AppendLine("- ``$k``") }

[void]$bankSb.AppendLine("")
[void]$bankSb.AppendLine("### 3. Practice Workbooks, Drills and TI-84 Playbooks ($($workbookGroup.Count) Keywords)")
foreach ($k in $workbookGroup) { [void]$bankSb.AppendLine("- ``$k``") }

[void]$bankSb.AppendLine("")
[void]$bankSb.AppendLine("### 4. Specialized and Long-Tail Search Queries ($($otherGroup.Count) Keywords)")
foreach ($k in $otherGroup) { [void]$bankSb.AppendLine("- ``$k``") }

$bankPath = Join-Path $outDir "Book_2_Amazon_Autosuggestion_Keyword_Bank.md"
[System.IO.File]::WriteAllText($bankPath, $bankSb.ToString(), [System.Text.Encoding]::UTF8)

Write-Host "SUCCESS: Step 1 Complete for Book 2! Harvested $($uniqueKeywords.Count) unique keywords." -ForegroundColor Green
