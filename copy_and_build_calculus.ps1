$brainDir = "C:\Users\Admin\.gemini\antigravity\brain\82ee0024-f624-4c28-b686-7ae02e330944"
$bookDir = "d:\Narayana kdp\With 2.o\Book_AP_Calculus_Prep_2027"
$coverDir = Join-Path $bookDir "Cover_Output_Files"
$aplusDir = Join-Path $bookDir "APlus_Content_Assets"

if (!(Test-Path $coverDir)) { New-Item -ItemType Directory -Path $coverDir -Force | Out-Null }
if (!(Test-Path $aplusDir)) { New-Item -ItemType Directory -Path $aplusDir -Force | Out-Null }

# Map and copy Kindle covers
$kindleMap = @{
    "kindle_cover_1_*.jpg" = "Kindle_Cover_Design_1_SkyBlue.jpg"
    "kindle_cover_2_*.jpg" = "Kindle_Cover_Design_2_RoyalGold.jpg"
    "kindle_cover_3_*.jpg" = "Kindle_Cover_Design_3_TechBlueprint.jpg"
    "kindle_cover_4_*.jpg" = "Kindle_Cover_Design_4_EmeraldAcademic.jpg"
    "kindle_cover_5_*.jpg" = "Kindle_Cover_Design_5_SapphireMinimalist.jpg"
}

foreach ($pattern in $kindleMap.Keys) {
    $src = Get-ChildItem -Path $brainDir -Filter $pattern | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($src) {
        $dest = Join-Path $coverDir $kindleMap[$pattern]
        Copy-Item -Path $src.FullName -Destination $dest -Force
        Write-Host "Copied $($src.Name) -> $($kindleMap[$pattern])" -ForegroundColor Cyan
    }
}

# Map and copy A+ Content assets
$aplusMap = @{
    "kdp_aplus_module1_hero_*.jpg" = "KDP_Module_1_Choose_Standard_Image_Header_with_Text_970x600.jpg"
    "kdp_aplus_card1_curriculum_*.jpg" = "KDP_Module_2_Choose_Standard_Three_Image_and_Text_Card_1_300x300.jpg"
    "kdp_aplus_card2_workbooks_*.jpg" = "KDP_Module_2_Choose_Standard_Three_Image_and_Text_Card_2_300x300.jpg"
    "kdp_aplus_card3_calculator_*.jpg" = "KDP_Module_2_Choose_Standard_Three_Image_and_Text_Card_3_300x300.jpg"
    "kdp_aplus_module4_sidebar_*.jpg" = "KDP_Module_4_Choose_Standard_Single_Image_and_Sidebar_300x300.jpg"
    "kdp_aplus_module5_highlights_*.jpg" = "KDP_Alternative_Choose_Standard_Single_Image_and_Highlights_970x300.jpg"
}

foreach ($pattern in $aplusMap.Keys) {
    $src = Get-ChildItem -Path $brainDir -Filter $pattern | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($src) {
        $dest = Join-Path $aplusDir $aplusMap[$pattern]
        Copy-Item -Path $src.FullName -Destination $dest -Force
        Write-Host "Copied A+ $($src.Name) -> $($aplusMap[$pattern])" -ForegroundColor Green
    }
}
Write-Host "Assets synced successfully!" -ForegroundColor Green