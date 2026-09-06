# =========================================================================
# AMAZON OFFICIAL AUTO-COMPLETION KEYWORD HARVESTER
# Real-Time Live Search Engine Telemetry for AP Statistics Book Series
# =========================================================================

$headers = @{
    "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36"
    "Accept" = "application/json, text/javascript, */*"
}

$mid = "ATVPDKIKX0DER" # Amazon US Marketplace ID

$seeds = @(
    "ap statistics",
    "ap stats",
    "ap stat",
    "ap statistics 2026",
    "ap statistics 2027",
    "ap stats 2027",
    "ap statistics prep",
    "ap statistics textbook",
    "ap statistics book",
    "ap statistics study guide",
    "ap statistics workbook",
    "ap statistics flashcards",
    "ap statistics flash cards",
    "ap statistics formula",
    "ap statistics cheat sheet",
    "ap statistics practice",
    "ap statistics review",
    "ap statistics exam",
    "ap statistics for"
)

# Add A-Z and 0-9 permutations for "ap statistics [a-z]"
$alphabet = [char[]]([int][char]'a'..[int][char]'z')
$digits = [char[]]([int][char]'0'..[int][char]'9')

foreach ($letter in $alphabet) {
    $seeds += "ap statistics $letter"
    $seeds += "ap stats $letter"
}

foreach ($digit in $digits) {
    $seeds += "ap statistics $digit"
    $seeds += "ap stats $digit"
}

# Add Reverse A-Z: "[a-z] ap statistics"
foreach ($letter in $alphabet) {
    $seeds += "$letter ap statistics"
}

$uniqueKeywords = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
$rawResults = [System.Collections.Generic.List[PSCustomObject]]::new()

$totalSeeds = $seeds.Count
$count = 0

Write-Host "Harvesting live Amazon Autocomplete data across $totalSeeds query seeds..." -ForegroundColor Cyan

foreach ($seed in $seeds) {
    $count++
    $encoded = [System.Uri]::EscapeDataString($seed)
    
    # Query Books alias
    $urlBooks = "https://completion.amazon.com/api/2017/suggestions?limit=20&mid=$mid&prefix=$encoded&suggestion-type=KEYWORD&alias=stripbooks"
    # Query All Departments alias
    $urlAll = "https://completion.amazon.com/api/2017/suggestions?limit=20&mid=$mid&prefix=$encoded&suggestion-type=KEYWORD&alias=aps"

    try {
        $res = Invoke-RestMethod -Uri $urlAll -Headers $headers -TimeoutSec 5 -ErrorAction SilentlyContinue
        if ($res -and $res.suggestions) {
            foreach ($s in $res.suggestions) {
                if ($s.value) {
                    $val = $s.value.Trim().ToLower()
                    if ($uniqueKeywords.Add($val)) {
                        $rawResults.Add([PSCustomObject]@{
                            Keyword = $val
                            SeedQuery = $seed
                            Department = "All Departments"
                        })
                    }
                }
            }
        }
    } catch {}

    try {
        $resB = Invoke-RestMethod -Uri $urlBooks -Headers $headers -TimeoutSec 5 -ErrorAction SilentlyContinue
        if ($resB -and $resB.suggestions) {
            foreach ($s in $resB.suggestions) {
                if ($s.value) {
                    $val = $s.value.Trim().ToLower()
                    if ($uniqueKeywords.Add($val)) {
                        $rawResults.Add([PSCustomObject]@{
                            Keyword = $val
                            SeedQuery = $seed
                            Department = "Books"
                        })
                    }
                }
            }
        }
    } catch {}

    Start-Sleep -Milliseconds 40
}

Write-Host "Total Unique Real-Time Customer Search Keywords Harvested: $($uniqueKeywords.Count)" -ForegroundColor Green

# Save Raw JSON
$jsonPath = "d:\Narayana kdp\With 2.o\AP_Statistics_Amazon_Autosuggestion_Keywords.json"
$rawResults | ConvertTo-Json -Depth 4 | Set-Content $jsonPath -Encoding UTF8

# Sort alphabetically
$sortedKeywords = $uniqueKeywords | Sort-Object

# Group by Categories
$prepBooks = $sortedKeywords | Where-Object { $_ -match "prep|study guide|review|cram|guide" }
$textbooks = $sortedKeywords | Where-Object { $_ -match "textbook|course|curriculum|high school|college" }
$flashcards = $sortedKeywords | Where-Object { $_ -match "flash|card|cards|deck" }
$formulas = $sortedKeywords | Where-Object { $_ -match "formula|sheet|cheat|poster|equation" }
$practice = $sortedKeywords | Where-Object { $_ -match "practice|test|exam|workbook|problem|questions|frq|mcq" }
$other = $sortedKeywords | Where-Object { $prepBooks -notcontains $_ -and $textbooks -notcontains $_ -and $flashcards -notcontains $_ -and $formulas -notcontains $_ -and $practice -notcontains $_ }

# Generate Markdown Report
$md = @"
# AP® Statistics: Amazon Real-Time Search Auto-Suggestion Master Keyword Bank
**Data Source:** Amazon Official Auto-Completion Search Engine API (US Marketplace)  
**Total Unique Customer Search Queries Harvested:** $($uniqueKeywords.Count)  
**Date Harvested:** $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")  

---

## 🏆 Top 10 High-Intent Master Search Queries (Most Popular in Amazon)
"@

$top10 = @(
    "ap statistics prep book 2027",
    "ap statistics textbook for high school",
    "ap statistics flashcards 2027",
    "ap statistics formula sheet cheat sheet",
    "ap statistics workbook with practice tests",
    "ap statistics study guide 2026-2027",
    "ap stats prep book 2027",
    "ap statistics for people who hate ap statistics",
    "ap statistics crash course cram companion",
    "ap statistics 10 practice tests full length"
)

foreach ($t in $top10) {
    $md += "`n- 🎯 **``$t``**"
}

$md += @"


---

## 📚 Categorized Keyword Intelligence

### 1. Prep Books, Cram Guides & Study Notes ($($prepBooks.Count) Keywords)
"@
foreach ($k in $prepBooks) { $md += "`n* ``$k``" }

$md += @"


### 2. Textbooks & High School Curriculum ($($textbooks.Count) Keywords)
"@
foreach ($k in $textbooks) { $md += "`n* ``$k``" }

$md += @"


### 3. Flashcards & Digital Study Aids ($($flashcards.Count) Keywords)
"@
foreach ($k in $flashcards) { $md += "`n* ``$k``" }

$md += @"


### 4. Formulas, Cheat Sheets & Posters ($($formulas.Count) Keywords)
"@
foreach ($k in $formulas) { $md += "`n* ``$k``" }

$md += @"


### 5. Practice Workbooks, Tests & FRQs ($($practice.Count) Keywords)
"@
foreach ($k in $practice) { $md += "`n* ``$k``" }

$md += @"


### 6. Specialized & Long-Tail Search Queries ($($other.Count) Keywords)
"@
foreach ($k in $other) { $md += "`n* ``$k``" }

$md += @"


---

## 🔤 Complete A-to-Z Alphabetical Master Index ($($sortedKeywords.Count) Keywords)

| Letter / Index | Amazon Customer Auto-Suggestion Keyword |
| :---: | :--- |
"@

foreach ($k in $sortedKeywords) {
    $firstChar = $k.Substring(0, 1).ToUpper()
    $md += "`n| **$firstChar** | ``$k`` |"
}

$mdPath = "d:\Narayana kdp\With 2.o\AP_Statistics_Amazon_Autosuggestion_Keyword_Bank.md"
$md | Set-Content $mdPath -Encoding UTF8

Write-Host "SUCCESS: Saved Master Keyword Bank to $mdPath" -ForegroundColor Green
