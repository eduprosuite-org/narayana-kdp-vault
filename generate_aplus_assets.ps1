# =========================================================================
# ULTRA-PREMIUM AMAZON KDP A+ CONTENT ENGINE (BESTSELLER PUBLISHER GRADE)
# Inspired by Barron's AP, Princeton Review and McGraw-Hill Flagship Listings
# =========================================================================

Add-Type -AssemblyName System.Drawing

$outputDir = 'd:\Narayana kdp\With 2.o\Book_1_AP_Statistics_Formula_and_Inference_Guide\APlus_Content_Assets'
if (!(Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

function Save-HighQualityJpg {
    param($bitmap, $filePath)
    $encoder = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.FormatID -eq [System.Drawing.Imaging.ImageFormat]::Jpeg.Guid }
    $encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
    $encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [long]98)
    $bitmap.Save($filePath, $encoder, $encoderParams)
    $bitmap.Dispose()
}

# Helper: Draw Realistic QR Code Graphic
function Draw-QRCode {
    param($g, $x, $y, $size, $fgHex, $bgHex)
    $bBg = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml($bgHex))
    $bFg = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml($fgHex))
    
    $g.FillRectangle($bBg, $x, $y, $size, $size)
    $pB = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml($fgHex), 2)
    $g.DrawRectangle($pB, $x, $y, $size, $size)
    
    # QR Outer Corners
    $cornerSize = [int]($size * 0.28)
    $innerSize = [int]($cornerSize * 0.5)
    $pad = [int]($size * 0.04)
    
    # Top-Left Finder
    $g.FillRectangle($bFg, ($x + $pad), ($y + $pad), $cornerSize, $cornerSize)
    $g.FillRectangle($bBg, ($x + $pad + 4), ($y + $pad + 4), ($cornerSize - 8), ($cornerSize - 8))
    $g.FillRectangle($bFg, ($x + $pad + 8), ($y + $pad + 8), ($cornerSize - 16), ($cornerSize - 16))
    
    # Top-Right Finder
    $g.FillRectangle($bFg, ($x + $size - $cornerSize - $pad), ($y + $pad), $cornerSize, $cornerSize)
    $g.FillRectangle($bBg, ($x + $size - $cornerSize - $pad + 4), ($y + $pad + 4), ($cornerSize - 8), ($cornerSize - 8))
    $g.FillRectangle($bFg, ($x + $size - $cornerSize - $pad + 8), ($y + $pad + 8), ($cornerSize - 16), ($cornerSize - 16))
    
    # Bottom-Left Finder
    $g.FillRectangle($bFg, ($x + $pad), ($y + $size - $cornerSize - $pad), $cornerSize, $cornerSize)
    $g.FillRectangle($bBg, ($x + $pad + 4), ($y + $size - $cornerSize - $pad + 4), ($cornerSize - 8), ($cornerSize - 8))
    $g.FillRectangle($bFg, ($x + $pad + 8), ($y + $size - $cornerSize - $pad + 8), ($cornerSize - 16), ($cornerSize - 16))
    
    # Random Matrix Modules pattern (Deterministic pseudo-QR pattern)
    $modSize = [int]($size / 18)
    for ($r = 0; $r -lt 18; $r++) {
        for ($c = 0; $c -lt 18; $c++) {
            if (($r -lt 6 -and $c -lt 6) -or ($r -lt 6 -and $c -gt 11) -or ($r -gt 11 -and $c -lt 6)) { continue }
            if ((($r * 7 + $c * 13 + 5) % 3) -eq 0 -or (($r + $c) % 4) -eq 0) {
                $g.FillRectangle($bFg, ($x + $c * $modSize + 2), ($y + $r * $modSize + 2), ($modSize - 1), ($modSize - 1))
            }
        }
    }
}

# Helper: Draw Smartphone Mockup
function Draw-PhoneMockup {
    param($g, $x, $y, $w, $h)
    $bPhone = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#020617'))
    $pPhone = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml('#38BDF8'), 2)
    $g.FillRectangle($bPhone, $x, $y, $w, $h)
    $g.DrawRectangle($pPhone, $x, $y, $w, $h)
    
    # Notch / Camera
    $bNotch = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#1E293B'))
    $g.FillRectangle($bNotch, ($x + ($w / 2) - 25), ($y + 8), 50, 10)
    
    # Screen Area
    $rectScreen = New-Object System.Drawing.Rectangle ($x + 10), ($y + 26), ($w - 20), ($h - 40)
    $brushScreen = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rectScreen, [System.Drawing.ColorTranslator]::FromHtml('#0F172A'), [System.Drawing.ColorTranslator]::FromHtml('#0284C7'), 90.0)
    $g.FillRectangle($brushScreen, $rectScreen)
    
    # Screen Header
    $fMini = New-Object System.Drawing.Font('Arial', 8, [System.Drawing.FontStyle]::Bold)
    $bWhite = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $bGold = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#F59E0B'))
    $g.DrawString('AP(R) STATS PORTAL', $fMini, $bGold, ($x + 16), ($y + 35))
    
    # UI Cards inside phone
    $bSubCard = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(180, 15, 23, 42))
    $g.FillRectangle($bSubCard, ($x + 16), ($y + 55), ($w - 32), 34)
    $fMicro = New-Object System.Drawing.Font('Arial', 7, [System.Drawing.FontStyle]::Regular)
    $g.DrawString('z = (x_bar - mu)/(s/sqrt(n))', $fMicro, $bWhite, ($x + 22), ($y + 65))
    
    $g.FillRectangle($bSubCard, ($x + 16), ($y + 95), ($w - 32), 34)
    $bCyan = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#38BDF8'))
    $g.DrawString('Inference Wizard: 2-Samp T', $fMicro, $bCyan, ($x + 22), ($y + 105))
    
    $g.FillRectangle($bSubCard, ($x + 16), ($y + 135), ($w - 32), 34)
    $bGreen = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#34D399'))
    $g.DrawString('FRQ: p-Value < 0.05 Reject Ho', $fMicro, $bGreen, ($x + 22), ($y + 145))
}

# =========================================================================
# 1. FLAGSHIP HERO BANNER (970 x 600 px)
# =========================================================================
Write-Host 'Creating 01_Standard_Hero_Banner_970x600.jpg...'
$hero = New-Object System.Drawing.Bitmap 970, 600
$g = [System.Drawing.Graphics]::FromImage($hero)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

# Deep Navy Gradient Background
$rectH = New-Object System.Drawing.Rectangle 0, 0, 970, 600
$brushBgH = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rectH, [System.Drawing.ColorTranslator]::FromHtml('#0A0F1D'), [System.Drawing.ColorTranslator]::FromHtml('#0F2852'), 45.0)
$g.FillRectangle($brushBgH, $rectH)

# Subtle Blueprint Coordinate Grid
$penGrid = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(20, 56, 189, 248), 1)
for ($x = 0; $x -lt 970; $x += 35) { $g.DrawLine($penGrid, $x, 0, $x, 600) }
for ($y = 0; $y -lt 600; $y += 35) { $g.DrawLine($penGrid, 0, $y, 970, $y) }

# Top Gold Pill: 2027 EXAM READY
$bGold = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#F59E0B'))
$g.FillRectangle($bGold, 45, 38, 220, 32)
$fBadge = New-Object System.Drawing.Font('Arial', 11, [System.Drawing.FontStyle]::Bold)
$bDark = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#0F172A'))
$g.DrawString('★ 2027 EXAM READY', $fBadge, $bDark, 58, 45)

# Series Name
$fSeries = New-Object System.Drawing.Font('Arial', 12, [System.Drawing.FontStyle]::Bold)
$bCyan = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#38BDF8'))
$g.DrawString('AP(R) STATISTICS MASTER REVIEW SERIES', $fSeries, $bCyan, 280, 45)

# Main Hero Title
$fH1 = New-Object System.Drawing.Font('Arial', 27, [System.Drawing.FontStyle]::Bold)
$bWhite = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$g.DrawString('THE ULTIMATE SCORE-5', $fH1, $bWhite, 45, 90)
$g.DrawString('FORMULA & INFERENCE CRAM GUIDE', $fH1, $bGold, 45, 136)

# Subtitle
$fHSub = New-Object System.Drawing.Font('Arial', 12, [System.Drawing.FontStyle]::Regular)
$bMuted = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#CBD5E1'))
$g.DrawString('Engineered to replace dense 600-page textbooks with high-yield visual decision trees,`nplain-English formula translations, and fill-in-the-blank FRQ sentence frames.', $fHSub, $bMuted, 45, 195)

# Left Side: 3 High-Yield Bullet Badges
function Draw-FeaturePill {
    param($gx, $x, $y, $title, $desc, $accentHex)
    $bBox = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(220, 15, 23, 42))
    $pBox = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml($accentHex), 2)
    $gx.FillRectangle($bBox, $x, $y, 540, 76)
    $gx.DrawRectangle($pBox, $x, $y, 540, 76)
    
    $fT = New-Object System.Drawing.Font('Arial', 12, [System.Drawing.FontStyle]::Bold)
    $bT = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml($accentHex))
    $gx.DrawString($title, $fT, $bT, ($x + 18), ($y + 12))
    
    $fD = New-Object System.Drawing.Font('Arial', 9.5, [System.Drawing.FontStyle]::Regular)
    $bD = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#E2E8F0'))
    $gx.DrawString($desc, $fD, $bD, ($x + 18), ($y + 40))
}

Draw-FeaturePill $g 45 260 '✔ 9-Unit Plain-English Formula Translations' 'Every official College Board equation decoded with parameter definitions and TI-84 shortcuts.' '#38BDF8'
Draw-FeaturePill $g 45 350 '✔ 8 Inference Decision Trees (Zero Guesswork)' 'Step-by-step branching flowcharts to pick the exact hypothesis test under timed conditions.' '#10B981'
Draw-FeaturePill $g 45 440 '✔ Rubric-Aligned FRQ Sentence Frame Templates' 'Fill-in-the-blank templates for p-values, CI, slope, and r2 to lock in full partial credit.' '#F59E0B'

# Right Side: Interactive Digital Companion Portal + QR Mockup Box
$bQRCard = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(240, 15, 23, 42))
$pQRCard = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml('#38BDF8'), 3)
$g.FillRectangle($bQRCard, 620, 240, 310, 320)
$g.DrawRectangle($pQRCard, 620, 240, 310, 320)

# QR Header Tag
$g.FillRectangle($bGold, 620, 240, 310, 36)
$fQRT = New-Object System.Drawing.Font('Arial', 11, [System.Drawing.FontStyle]::Bold)
$g.DrawString('FREE DIGITAL WEB COMPANION', $fQRT, $bDark, 642, 250)

# Draw QR Code inside card
Draw-QRCode $g 640 295 125 '#0F172A' '#FFFFFF'

# Phone Mockup beside QR
Draw-PhoneMockup $g 780 290 135 220

# Callout text below QR
$fQRFoot = New-Object System.Drawing.Font('Arial', 9.5, [System.Drawing.FontStyle]::Bold)
$g.DrawString('SCAN QR CODE IN BOOK', $fQRFoot, $bGold, 640, 435)

$fQRSub = New-Object System.Drawing.Font('Arial', 8, [System.Drawing.FontStyle]::Regular)
$g.DrawString('Instant Formula Lookup`nTI-84 Keystroke Wizard`n100% Free - No App Needed', $fQRSub, $bWhite, 640, 460)

# Bottom Trust Bar
$bTrust = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#0284C7'))
$g.FillRectangle($bTrust, 45, 535, 540, 28)
$fTrust = New-Object System.Drawing.Font('Arial', 9, [System.Drawing.FontStyle]::Bold)
$g.DrawString('100% ALIGNED WITH 2026-2027 COLLEGE BOARD COURSE & EXAM DESCRIPTION (CED)', $fTrust, $bWhite, 55, 542)

$g.Dispose()
Save-HighQualityJpg $hero (Join-Path $outputDir '01_Standard_Hero_Banner_970x600.jpg')

# =========================================================================
# 2. FEATURE CARD 1 (300 x 300 px) - Plain-English Formula Translations
# =========================================================================
Write-Host 'Creating 02_Card_1_Plain_English_Formulas_300x300.jpg...'
$card1 = New-Object System.Drawing.Bitmap 300, 300
$g1 = [System.Drawing.Graphics]::FromImage($card1)
$g1.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g1.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

$r1 = New-Object System.Drawing.Rectangle 0, 0, 300, 300
$br1 = New-Object System.Drawing.Drawing2D.LinearGradientBrush($r1, [System.Drawing.ColorTranslator]::FromHtml('#0F172A'), [System.Drawing.ColorTranslator]::FromHtml('#0369A1'), 90.0)
$g1.FillRectangle($br1, $r1)
$pen1 = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml('#38BDF8'), 3)
$g1.DrawRectangle($pen1, 2, 2, 296, 296)

# Badge Top
$fMiniB = New-Object System.Drawing.Font('Arial', 8, [System.Drawing.FontStyle]::Bold)
$g1.FillRectangle($bGold, 18, 16, 120, 22)
$g1.DrawString('INSIDE LOOK', $fMiniB, $bDark, 32, 21)

# Formula math visual box
$bMathBox = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(200, 15, 23, 42))
$g1.FillRectangle($bMathBox, 18, 48, 264, 52)
$pMath = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml('#38BDF8'), 1)
$g1.DrawRectangle($pMath, 18, 48, 264, 52)

$fMath = New-Object System.Drawing.Font('Arial', 13, [System.Drawing.FontStyle]::Bold)
$g1.DrawString('z = (x_bar - mu) / (sigma / sqrt(n))', $fMath, $bCyan, 25, 62)

$fTitleC = New-Object System.Drawing.Font('Arial', 12.5, [System.Drawing.FontStyle]::Bold)
$g1.DrawString('Plain-English Formulas', $fTitleC, $bWhite, 18, 115)

$fBodyC = New-Object System.Drawing.Font('Arial', 8.8, [System.Drawing.FontStyle]::Regular)
$rectB1 = New-Object System.Drawing.RectangleF(18, 145, 264, 135)
$desc1 = 'Every official formula translated into simple step-by-step rules. Parameter traps and TI-84 shortcuts highlighted so you never plug in the wrong variable.'
$g1.DrawString($desc1, $fBodyC, $bMuted, $rectB1)

$g1.Dispose()
Save-HighQualityJpg $card1 (Join-Path $outputDir '02_Card_1_Plain_English_Formulas_300x300.jpg')

# =========================================================================
# 3. FEATURE CARD 2 (300 x 300 px) - Zero-Guesswork Inference Flowcharts
# =========================================================================
Write-Host 'Creating 03_Card_2_Zero_Guesswork_Inference_300x300.jpg...'
$card2 = New-Object System.Drawing.Bitmap 300, 300
$g2 = [System.Drawing.Graphics]::FromImage($card2)
$g2.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g2.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

$r2 = New-Object System.Drawing.Rectangle 0, 0, 300, 300
$br2 = New-Object System.Drawing.Drawing2D.LinearGradientBrush($r2, [System.Drawing.ColorTranslator]::FromHtml('#0F172A'), [System.Drawing.ColorTranslator]::FromHtml('#065F46'), 90.0)
$g2.FillRectangle($br2, $r2)
$pen2 = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml('#10B981'), 3)
$g2.DrawRectangle($pen2, 2, 2, 296, 296)

# Badge Top
$g2.FillRectangle($bGold, 18, 16, 150, 22)
$g2.DrawString('DECISION FLOWCHART', $fMiniB, $bDark, 25, 21)

# Flowchart mini diagram
$g2.FillRectangle($bMathBox, 18, 48, 264, 52)
$pFlow = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml('#10B981'), 1)
$g2.DrawRectangle($pFlow, 18, 48, 264, 52)

$bGreenLight = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#34D399'))
$fFlow = New-Object System.Drawing.Font('Arial', 11, [System.Drawing.FontStyle]::Bold)
$g2.DrawString('Categorical --> 2-Prop Z-Test', $fFlow, $bGreenLight, 25, 55)
$g2.DrawString('Quantitative --> 2-Sample T-Test', $fFlow, $bWhite, 25, 75)

$g2.DrawString('Zero-Guesswork Testing', $fTitleC, $bWhite, 18, 115)

$rectB2 = New-Object System.Drawing.RectangleF(18, 145, 264, 135)
$desc2 = 'Follow visual decision trees to effortlessly identify the right inference test from 1-Prop Z to Chi-Square and Regression without second-guessing under exam pressure.'
$g2.DrawString($desc2, $fBodyC, $bMuted, $rectB2)

$g2.Dispose()
Save-HighQualityJpg $card2 (Join-Path $outputDir '03_Card_2_Zero_Guesswork_Inference_300x300.jpg')

# =========================================================================
# 4. FEATURE CARD 3 (300 x 300 px) - Rubric-Perfect FRQ Templates
# =========================================================================
Write-Host 'Creating 04_Card_3_Rubric_Perfect_FRQ_300x300.jpg...'
$card3 = New-Object System.Drawing.Bitmap 300, 300
$g3 = [System.Drawing.Graphics]::FromImage($card3)
$g3.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g3.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

$r3 = New-Object System.Drawing.Rectangle 0, 0, 300, 300
$br3 = New-Object System.Drawing.Drawing2D.LinearGradientBrush($r3, [System.Drawing.ColorTranslator]::FromHtml('#0F172A'), [System.Drawing.ColorTranslator]::FromHtml('#78350F'), 90.0)
$g3.FillRectangle($br3, $r3)
$pen3 = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml('#F59E0B'), 3)
$g3.DrawRectangle($pen3, 2, 2, 296, 296)

# Badge Top
$g3.FillRectangle($bGold, 18, 16, 140, 22)
$g3.DrawString('FULL RUBRIC CREDIT', $fMiniB, $bDark, 25, 21)

# FRQ Sentence Frame Box
$g3.FillRectangle($bMathBox, 18, 48, 264, 52)
$pFRQ = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml('#F59E0B'), 1)
$g3.DrawRectangle($pFRQ, 18, 48, 264, 52)

$fFRQ = New-Object System.Drawing.Font('Arial', 10.5, [System.Drawing.FontStyle]::Bold)
$bYellow = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#FDE047'))
$g3.DrawString('"We are [C%] confident that..."', $fFRQ, $bYellow, 25, 55)
$g3.DrawString('"Because p-value < alpha, reject Ho"', $fFRQ, $bWhite, 25, 75)

$g3.DrawString('Rubric-Perfect FRQs', $fTitleC, $bWhite, 18, 115)

$rectB3 = New-Object System.Drawing.RectangleF(18, 145, 264, 135)
$desc3 = 'Plug your problem values into pre-formatted, grader-approved sentence frames for interpreting p-values, intervals, and slopes to capture every partial credit point.'
$g3.DrawString($desc3, $fBodyC, $bMuted, $rectB3)

$g3.Dispose()
Save-HighQualityJpg $card3 (Join-Path $outputDir '04_Card_3_Rubric_Perfect_FRQ_300x300.jpg')

# =========================================================================
# 5. FEATURE CARD 4 (300 x 300 px) - Interactive QR Code & Web Companion
# =========================================================================
Write-Host 'Creating 05_Card_4_Web_Companion_300x300.jpg...'
$card4 = New-Object System.Drawing.Bitmap 300, 300
$g4 = [System.Drawing.Graphics]::FromImage($card4)
$g4.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g4.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

$r4 = New-Object System.Drawing.Rectangle 0, 0, 300, 300
$br4 = New-Object System.Drawing.Drawing2D.LinearGradientBrush($r4, [System.Drawing.ColorTranslator]::FromHtml('#0B1120'), [System.Drawing.ColorTranslator]::FromHtml('#1E3A8A'), 90.0)
$g4.FillRectangle($br4, $r4)
$pen4 = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml('#60A5FA'), 3)
$g4.DrawRectangle($pen4, 2, 2, 296, 296)

# Badge Top
$g4.FillRectangle($bGold, 18, 16, 150, 22)
$g4.DrawString('SCAN QR IN BOOK', $fMiniB, $bDark, 28, 21)

# Mini QR Code Graphic
Draw-QRCode $g4 18 48 68 '#0F172A' '#FFFFFF'

# Text beside QR
$fQRTit = New-Object System.Drawing.Font('Arial', 11, [System.Drawing.FontStyle]::Bold)
$g4.DrawString('FREE WEB APP', $fQRTit, $bGold, 96, 52)
$fQRSubT = New-Object System.Drawing.Font('Arial', 8.5, [System.Drawing.FontStyle]::Regular)
$g4.DrawString('Instant Lookups`nTI-84 Keystrokes`nMobile Ready', $fQRSubT, $bWhite, 96, 70)

$g4.DrawString('Interactive Digital Portal', $fTitleC, $bWhite, 18, 128)

$rectB4 = New-Object System.Drawing.RectangleF(18, 155, 264, 130)
$desc4 = 'Scan the QR code inside the book for instant digital access to search formulas, run inference wizards, and practice diagnostic drills on any device with zero setup.'
$g4.DrawString($desc4, $fBodyC, $bMuted, $rectB4)

$g4.Dispose()
Save-HighQualityJpg $card4 (Join-Path $outputDir '05_Card_4_Web_Companion_300x300.jpg')

# =========================================================================
# 6. WIDE COMPANION BANNER (970 x 300 px) - Dual Feature
# =========================================================================
Write-Host 'Creating 06_Wide_Digital_Companion_970x300.jpg...'
$wide = New-Object System.Drawing.Bitmap 970, 300
$gw = [System.Drawing.Graphics]::FromImage($wide)
$gw.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$gw.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

$rW = New-Object System.Drawing.Rectangle 0, 0, 970, 300
$brW = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rW, [System.Drawing.ColorTranslator]::FromHtml('#0F172A'), [System.Drawing.ColorTranslator]::FromHtml('#0284C7'), 45.0)
$gw.FillRectangle($brW, $rW)

# Grid Accent
for ($x = 0; $x -lt 970; $x += 35) { $gw.DrawLine($penGrid, $x, 0, $x, 300) }

# Left: QR Code + Smartphone Mockup
Draw-QRCode $gw 45 45 130 '#0F172A' '#FFFFFF'
Draw-PhoneMockup $gw 195 40 120 220

# Right Text Content
$gw.FillRectangle($bGold, 340, 40, 240, 26)
$gw.DrawString('★ EXCLUSIVE DIGITAL ECOSYSTEM', $fMiniB, $bDark, 350, 46)

$fW1 = New-Object System.Drawing.Font('Arial', 22, [System.Drawing.FontStyle]::Bold)
$gw.DrawString('SCAN THE QR CODE INSIDE FOR', $fW1, $bWhite, 340, 75)
$gw.DrawString('INSTANT INTERACTIVE STUDY TOOLS', $fW1, $bGold, 340, 110)

$fWSub = New-Object System.Drawing.Font('Arial', 11, [System.Drawing.FontStyle]::Regular)
$gw.DrawString('Access searchable formula cheat sheets, 3-click inference wizards, TI-84 keystroke guides,`nand dynamic FRQ sentence frame generators on your phone, tablet, or laptop.', $fWSub, $bMuted, 340, 155)

$fTrustW = New-Object System.Drawing.Font('Arial', 10, [System.Drawing.FontStyle]::Bold)
$gw.DrawString('100% Free Companion Portal  |  No App Download Required  |  Instant Mobile Access', $fTrustW, $bCyan, 340, 225)

$gw.Dispose()
Save-HighQualityJpg $wide (Join-Path $outputDir '06_Wide_Digital_Companion_970x300.jpg')

Write-Host 'ALL 6 BESTSELLER A+ GRAPHICS GENERATED SUCCESSFULLY!'
