$brainDir = "C:\Users\Admin\.gemini\antigravity\brain\82ee0024-f624-4c28-b686-7ae02e330944"
$baseDir = "d:\Narayana kdp\With 2.o"

# Book 1 Assets
$b1Cover = Join-Path $baseDir "Book_1_AP_Calculus_Formula_Guide\Cover_Output_Files"
$b1Aplus = Join-Path $baseDir "Book_1_AP_Calculus_Formula_Guide\APlus_Content_Assets"
$b1Map = @{
    "book1_cover_1_*.jpg" = "Kindle_Cover_Design_1_SkyBlue.jpg"
    "book1_cover_2_*.jpg" = "Kindle_Cover_Design_2_RoyalGold.jpg"
    "book1_cover_3_*.jpg" = "Kindle_Cover_Design_3_TechBlueprint.jpg"
    "book1_cover_4_*.jpg" = "Kindle_Cover_Design_4_EmeraldAcademic.jpg"
    "book1_cover_5_*.jpg" = "Kindle_Cover_Design_5_SapphireMinimalist.jpg"
}
foreach ($p in $b1Map.Keys) {
    $src = Get-ChildItem -Path $brainDir -Filter $p | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($src) { Copy-Item $src.FullName (Join-Path $b1Cover $b1Map[$p]) -Force }
}
$b1Hero = Get-ChildItem -Path $brainDir -Filter "book1_aplus_hero_*.jpg" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if ($b1Hero) { Copy-Item $b1Hero.FullName (Join-Path $b1Aplus "KDP_Module_1_Choose_Standard_Image_Header_with_Text_970x600.jpg") -Force }

# Book 2 Assets (Copy from existing Book_AP_Calculus_Prep_2027)
$b2Cover = Join-Path $baseDir "Book_2_AP_Calculus_Prep_Book_2027\Cover_Output_Files"
$b2Aplus = Join-Path $baseDir "Book_2_AP_Calculus_Prep_Book_2027\APlus_Content_Assets"
Copy-Item "d:\Narayana kdp\With 2.o\Book_AP_Calculus_Prep_2027\Cover_Output_Files\*" $b2Cover -Force
Copy-Item "d:\Narayana kdp\With 2.o\Book_AP_Calculus_Prep_2027\APlus_Content_Assets\*" $b2Aplus -Force

# Book 3 Assets
$b3Cover = Join-Path $baseDir "Book_3_AP_Calculus_Practice_Exams\Cover_Output_Files"
$b3Aplus = Join-Path $baseDir "Book_3_AP_Calculus_Practice_Exams\APlus_Content_Assets"
$b3Map = @{
    "book3_cover_1_*.jpg" = "Kindle_Cover_Design_1_SkyBlue.jpg"
    "book3_cover_2_*.jpg" = "Kindle_Cover_Design_2_RoyalGold.jpg"
    "book3_cover_3_*.jpg" = "Kindle_Cover_Design_3_TechBlueprint.jpg"
    "book3_cover_4_*.jpg" = "Kindle_Cover_Design_4_EmeraldAcademic.jpg"
    "book3_cover_5_*.jpg" = "Kindle_Cover_Design_5_SapphireMinimalist.jpg"
}
foreach ($p in $b3Map.Keys) {
    $src = Get-ChildItem -Path $brainDir -Filter $p | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($src) { Copy-Item $src.FullName (Join-Path $b3Cover $b3Map[$p]) -Force }
}
$b3Hero = Get-ChildItem -Path $brainDir -Filter "book3_aplus_hero_*.jpg" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if ($b3Hero) { Copy-Item $b3Hero.FullName (Join-Path $b3Aplus "KDP_Module_1_Choose_Standard_Image_Header_with_Text_970x600.jpg") -Force }

# Copy standard cards to Book 1 and Book 3 A+ Content directories
$stdCards = @(
    "KDP_Module_2_Choose_Standard_Three_Image_and_Text_Card_1_300x300.jpg",
    "KDP_Module_2_Choose_Standard_Three_Image_and_Text_Card_2_300x300.jpg",
    "KDP_Module_2_Choose_Standard_Three_Image_and_Text_Card_3_300x300.jpg",
    "KDP_Module_4_Choose_Standard_Single_Image_and_Sidebar_300x300.jpg",
    "KDP_Alternative_Choose_Standard_Single_Image_and_Highlights_970x300.jpg"
)
foreach ($c in $stdCards) {
    $cSrc = Join-Path "d:\Narayana kdp\With 2.o\Book_AP_Calculus_Prep_2027\APlus_Content_Assets" $c
    if (Test-Path $cSrc) {
        Copy-Item $cSrc (Join-Path $b1Aplus $c) -Force
        Copy-Item $cSrc (Join-Path $b3Aplus $c) -Force
    }
}

Write-Host "All assets synced across Book 1, Book 2, and Book 3!" -ForegroundColor Green