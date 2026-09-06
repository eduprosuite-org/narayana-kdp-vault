# =========================================================================
# AMAZON AUTO-SUGGESTION FULL QUERY-BY-QUERY HARVESTER & MD GENERATOR
# =========================================================================

$headers = @{
    "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36"
    "Accept" = "application/json, text/javascript, */*"
}

$mid = "ATVPDKIKX0DER"

# Define ordered search seed list
$queries = [System.Collections.Generic.List[string]]::new()

# Root queries
$queries.Add("ap statistics")
$queries.Add("ap stats")
$queries.Add("ap stat")
$queries.Add("ap statistics prep")
$queries.Add("ap statistics textbook")
$queries.Add("ap statistics flashcards")
$queries.Add("ap statistics formula")
$queries.Add("ap statistics cheat sheet")
$queries.Add("ap statistics workbook")
$queries.Add("ap statistics 2027")
$queries.Add("ap stats 2027")

# Alphabetical: ap statistics [a-z]
$alphabet = [char[]]([int][char]'a'..[int][char]'z')
foreach ($char in $alphabet) {
    $queries.Add("ap statistics $char")
}

# Alphabetical: ap stats [a-z]
foreach ($char in $alphabet) {
    $queries.Add("ap stats $char")
}

# Numbers: ap statistics [0-9]
$digits = [char[]]([int][char]'0'..[int][char]'9')
foreach ($digit in $digits) {
    $queries.Add("ap statistics $digit")
}

# Numbers: ap stats [0-9]
foreach ($digit in $digits) {
    $queries.Add("ap stats $digit")
}

$sb = [System.Text.StringBuilder]::new()
[void]$sb.AppendLine("# Amazon Auto-Suggestions: Full Query-by-Query Search Log")
[void]$sb.AppendLine("**Target Market:** Amazon US Search Autocomplete Engine")
[void]$sb.AppendLine("**Harvest Timestamp:** $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
[void]$sb.AppendLine("**Total Search Seeds Processed:** $($queries.Count)")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("---")
[void]$sb.AppendLine("")

Write-Host "Executing query-by-query capture for $($queries.Count) seeds..." -ForegroundColor Cyan

$i = 0
foreach ($q in $queries) {
    $i++
    $encoded = [System.Uri]::EscapeDataString($q)
    $url = "https://completion.amazon.com/api/2017/suggestions?limit=20&mid=$mid&prefix=$encoded&suggestion-type=KEYWORD&alias=aps"
    
    $suggestions = @()
    try {
        $res = Invoke-RestMethod -Uri $url -Headers $headers -TimeoutSec 4 -ErrorAction SilentlyContinue
        if ($res -and $res.suggestions) {
            foreach ($s in $res.suggestions) {
                if ($s.value) {
                    $suggestions += $s.value.Trim()
                }
            }
        }
    } catch {}

    [void]$sb.AppendLine("### Search Prefix: ``$q``")
    if ($suggestions.Count -gt 0) {
        [void]$sb.AppendLine("**Auto-Suggestions Returned ($($suggestions.Count)):**")
        foreach ($sug in $suggestions) {
            [void]$sb.AppendLine("- ``$sug``")
        }
    } else {
        [void]$sb.AppendLine("*No direct autocomplete suggestions returned.*")
    }
    [void]$sb.AppendLine("")

    Start-Sleep -Milliseconds 30
}

$outPath = "d:\Narayana kdp\With 2.o\AP_Statistics_Amazon_Autosuggestion_Full_Query_Log.md"
[System.IO.File]::WriteAllText($outPath, $sb.ToString(), [System.Text.Encoding]::UTF8)

# Also copy to Book 1 subfolder
$book1Path = "d:\Narayana kdp\With 2.o\Book_1_AP_Statistics_Formula_and_Inference_Guide\AP_Statistics_Amazon_Autosuggestion_Full_Query_Log.md"
[System.IO.File]::WriteAllText($book1Path, $sb.ToString(), [System.Text.Encoding]::UTF8)

Write-Host "SUCCESS: Generated Full Query-by-Query Log at $outPath" -ForegroundColor Green
