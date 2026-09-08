# =========================================================================
# BOOK 2: AP STATISTICS PREP BOOK 2027 - A+ CONTENT GRAPHICS GENERATOR
# High-Resolution 300 DPI - Single Source of Truth Design Tokens
# =========================================================================

Add-Type -AssemblyName System.Drawing

$outputDir = "d:\Narayana kdp\With 2.o\Book_2_AP_Statistics_Prep_Book_2027\APlus_Content_Assets"
if (!(Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir -Force | Out-Null }

function Save-HighQualityJpg {
    param($bitmap, $filePath)
    $encoder = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.FormatID -eq [System.Drawing.Imaging.ImageFormat]::Jpeg.Guid }
    $encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
    $encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [long]98)
    $bitmap.Save($filePath, $encoder, $encoderParams)
    $bitmap.Dispose()
}

# Helper: Draw Realistic QR Code
function Draw-QRCode {
    param($g, $x, $y, $size, $fgHex, $bgHex)
    $bBg = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml($bgHex))
    $bFg = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml($fgHex))
    $g.FillRectangle($bBg, $x, $y, $size, $size)
    $pB = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml($fgHex), 2)
    $g.DrawRectangle($pB, $x, $y, $size, $size)
    
    $cornerSize = [int]($size * 0.28)
    $pad = [int]($size * 0.04)
    
    # Corners
    $g.FillRectangle($bFg, ($x + $pad), ($y + $pad), $cornerSize, $cornerSize)
    $g.FillRectangle($bBg, ($x + $pad + 4), ($y + $pad + 4), ($cornerSize - 8), ($cornerSize - 8))
    $g.FillRectangle($bFg, ($x + $pad + 8), ($y + $pad + 8), ($cornerSize - 16), ($cornerSize - 16))
    
    $g.FillRectangle($bFg, ($x + $size - $cornerSize - $pad), ($y + $pad), $cornerSize, $cornerSize)
    $g.FillRectangle($bBg, ($x + $size - $cornerSize - $pad + 4), ($y + $pad + 4), ($cornerSize - 8), ($cornerSize - 8))
    $g.FillRectangle($bFg, ($x + $size - $cornerSize - $pad + 8), ($y + $pad + 8), ($cornerSize - 16), ($cornerSize - 16))
    
    $g.FillRectangle($bFg, ($x + $pad), ($y + $size - $cornerSize - $pad), $cornerSize, $cornerSize)
    $g.FillRectangle($bBg, ($x + $pad + 4), ($y + $size - $cornerSize - $pad + 4), ($cornerSize - 8), ($cornerSize - 8))
    $g.FillRectangle($bFg, ($x + $pad + 8), ($y + $size - $cornerSize - $pad + 8), ($cornerSize - 16), ($cornerSize - 16))
    
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
    
    $bNotch = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#1E293B'))
    $g.FillRectangle($bNotch, ($x + ($w / 2) - 25), ($y + 8), 50, 10)
    
    $rectScreen = New-Object System.Drawing.Rectangle ($x + 10), ($y + 26), ($w - 20), ($h - 40)
    $brushScreen = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rectScreen, [System.Drawing.ColorTranslator]::FromHtml('#0F172A'), [System.Drawing.ColorTranslator]::FromHtml('#0284C7'), 90.0)
    $g.FillRectangle($brushScreen, $rectScreen)
    
    $fMini = New-Object System.Drawing.Font('Arial', 8, [System.Drawing.FontStyle]::Bold)
    $bWhite = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $bGold = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#F59E0B'))
    $g.DrawString('AP(R) STATS PORTAL', $fMini, $bGold, ($x + 16), ($y + 35))
    
    $bSubCard = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(180, 15, 23, 42))
    $g.FillRectangle($bSubCard, ($x + 16), ($y + 55), ($w - 32), 34)
    $fMicro = New-Object System.Drawing.Font('Arial', 7, [System.Drawing.FontStyle]::Regular)
    $g.DrawString('Unit 1-9 Diagnostic Drills', $fMicro, $bWhite, ($x + 22), ($y + 65))
    
    $g.FillRectangle($bSubCard, ($x + 16), ($y + 95), ($w - 32), 34)
    $bCyan = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#38BDF8'))
    $g.DrawString('TI-84 Keystroke Simulator', $fMicro, $bCyan, ($x + 22), ($y + 105))
    
    $g.FillRectangle($bSubCard, ($x + 16), ($y + 135), ($w - 32), 34)
    $bGreen = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#34D399'))
    $g.DrawString('Digital Practice Workbooks', $fMicro, $bGreen, ($x + 22), ($y + 145))
}

# -------------------------------------------------------------------------
# 1. MODULE 1: HERO BANNER (970 x 600 px)
# -------------------------------------------------------------------------
Write-Host 'Creating Module 1 Hero Banner (970x600)...'
$hero = New-Object System.Drawing.Bitmap 970, 600
$g = [System.Drawing.Graphics]::FromImage($hero)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

$rectH = New-Object System.Drawing.Rectangle 0, 0, 970, 600
$brushBgH = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rectH, [System.Drawing.ColorTranslator]::FromHtml('#0A0F1D'), [System.Drawing.ColorTranslator]::FromHtml('#0F2852'), 45.0)
$g.FillRectangle($brushBgH, $rectH)

$penGrid = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(20, 56, 189, 248), 1)
for ($x = 0; $x -lt 970; $x += 35) { $g.DrawLine($penGrid, $x, 0, $x, 600) }
for ($y = 0; $y -lt 600; $y += 35) { $g.DrawLine($penGrid, 0, $y, 970, $y) }

# Top Gold Pill: 2027 EXAM READY
$bGold = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#F59E0B'))
$g.FillRectangle($bGold, 45, 38, 220, 32)
$fBadge = New-Object System.Drawing.Font('Arial', 11, [System.Drawing.FontStyle]::Bold)
$bDark = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#0F172A'))
$g.DrawString('★ 2027 EXAM READY', $fBadge, $bDark, 58, 45)

$fSeries = New-Object System.Drawing.Font('Arial', 12, [System.Drawing.FontStyle]::Bold)
$bCyan = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#38BDF8'))
$g.DrawString('AP(R) STATISTICS MASTER REVIEW SERIES: BOOK 2', $fSeries, $bCyan, 280, 45)

# Main Title
$fH1 = New-Object System.Drawing.Font('Arial', 27, [System.Drawing.FontStyle]::Bold)
$bWhite = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$g.DrawString('AP(R) STATISTICS PREP BOOK 2027', $fH1, $bWhite, 45, 90)

$fH2 = New-Object System.Drawing.Font('Arial', 20, [System.Drawing.FontStyle]::Bold)
$g.DrawString('THE COMPLETE STUDY GUIDE & TEXTBOOK', $fH2, $bGold, 45, 138)

$fHSub = New-Object System.Drawing.Font('Arial', 12, [System.Drawing.FontStyle]::Regular)
$bMuted = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#CBD5E1'))
$g.DrawString('Full 9-Unit Curriculum Coverage, 200+ Step-by-Step Practice Workbooks,`nTI-84 Plus CE Calculator Playbooks, and 2 Full-Length Practice Exams.', $fHSub, $bMuted, 45, 195)

# 3 Feature Pills
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

Draw-FeaturePill $g 45 260 '✔ Comprehensive 9-Unit High School Textbook' 'Master One-Variable Data, Probability, Inference for Means & Proportions, and Chi-Square.' '#38BDF8'
Draw-FeaturePill $g 45 350 '✔ 200+ Practice Workbooks with Model Solutions' 'Unit-specific drills and rubric-annotated free-response scoring keys to build test mastery.' '#10B981'
Draw-FeaturePill $g 45 440 '✔ Complete TI-84 Plus CE Calculator Playbooks' 'Step-by-step keystroke shortcuts to solve distributions and hypothesis tests twice as fast.' '#F59E0B'

# Right: QR & Companion Portal Card
$bQRCard = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(240, 15, 23, 42))
$pQRCard = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml('#38BDF8'), 3)
$g.FillRectangle($bQRCard, 620, 240, 310, 320)
$g.DrawRectangle($pQRCard, 620, 240, 310, 320)

$g.FillRectangle($bGold, 620, 240, 310, 36)
$fQRT = New-Object System.Drawing.Font('Arial', 11, [System.Drawing.FontStyle]::Bold)
$g.DrawString('FREE DIGITAL WEB COMPANION', $fQRT, $bDark, 642, 250)

Draw-QRCode $g 640 295 125 '#0F172A' '#FFFFFF'
Draw-PhoneMockup $g 780 290 135 220

$fQRFoot = New-Object System.Drawing.Font('Arial', 9.5, [System.Drawing.FontStyle]::Bold)
$g.DrawString('SCAN QR CODE IN BOOK', $fQRFoot, $bGold, 640, 435)

$fQRSub = New-Object System.Drawing.Font('Arial', 8, [System.Drawing.FontStyle]::Regular)
$g.DrawString('Unit Diagnostic Drills`nTI-84 Keystrokes Simulator`n100% Free Live Access', $fQRSub, $bWhite, 640, 460)

$bTrust = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#0284C7'))
$g.FillRectangle($bTrust, 45, 535, 540, 28)
$fTrust = New-Object System.Drawing.Font('Arial', 9, [System.Drawing.FontStyle]::Bold)
$g.DrawString('100% ALIGNED WITH 2026-2027 COLLEGE BOARD COURSE & EXAM DESCRIPTION (CED)', $fTrust, $bWhite, 55, 542)

$g.Dispose()
Save-HighQualityJpg $hero (Join-Path $outputDir 'KDP_Module_1_Choose_Standard_Image_Header_with_Text_970x600.jpg')

# -------------------------------------------------------------------------
# 2. MODULE 2: CARD 1 - 9-Unit Textbook Coverage (300 x 300 px)
# -------------------------------------------------------------------------
Write-Host 'Creating Module 2 Card 1 (300x300)...'
$card1 = New-Object System.Drawing.Bitmap 300, 300
$g1 = [System.Drawing.Graphics]::FromImage($card1)
$g1.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g1.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

$r1 = New-Object System.Drawing.Rectangle 0, 0, 300, 300
$br1 = New-Object System.Drawing.Drawing2D.LinearGradientBrush($r1, [System.Drawing.ColorTranslator]::FromHtml('#0F172A'), [System.Drawing.ColorTranslator]::FromHtml('#0369A1'), 90.0)
$g1.FillRectangle($br1, $r1)
$pen1 = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml('#38BDF8'), 3)
$g1.DrawRectangle($pen1, 2, 2, 296, 296)

$fMiniB = New-Object System.Drawing.Font('Arial', 8, [System.Drawing.FontStyle]::Bold)
$g1.FillRectangle($bGold, 18, 16, 140, 22)
$g1.DrawString('9-UNIT CURRICULUM', $fMiniB, $bDark, 26, 21)

$bMathBox = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(200, 15, 23, 42))
$g1.FillRectangle($bMathBox, 18, 48, 264, 52)
$pMath = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml('#38BDF8'), 1)
$g1.DrawRectangle($pMath, 18, 48, 264, 52)

$fMath = New-Object System.Drawing.Font('Arial', 12, [System.Drawing.FontStyle]::Bold)
$g1.DrawString('Units 1-9 Full CED Breakdown', $fMath, $bCyan, 25, 62)

$fTitleC = New-Object System.Drawing.Font('Arial', 12.5, [System.Drawing.FontStyle]::Bold)
$g1.DrawString('Complete Course Textbook', $fTitleC, $bWhite, 18, 115)

$fBodyC = New-Object System.Drawing.Font('Arial', 8.8, [System.Drawing.FontStyle]::Regular)
$rectB1 = New-Object System.Drawing.RectangleF(18, 145, 264, 135)
$desc1 = 'Comprehensive lessons deconstructing all 9 College Board units with visual diagrams, essential definitions, and zero academic bloat.'
$g1.DrawString($desc1, $fBodyC, $bMuted, $rectB1)

$g1.Dispose()
Save-HighQualityJpg $card1 (Join-Path $outputDir 'KDP_Module_2_Choose_Standard_Three_Image_and_Text_Card_1_300x300.jpg')

# -------------------------------------------------------------------------
# 3. MODULE 2: CARD 2 - TI-84 Plus CE Playbooks (300 x 300 px)
# -------------------------------------------------------------------------
Write-Host 'Creating Module 2 Card 2 (300x300)...'
$card2 = New-Object System.Drawing.Bitmap 300, 300
$g2 = [System.Drawing.Graphics]::FromImage($card2)
$g2.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g2.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

$r2 = New-Object System.Drawing.Rectangle 0, 0, 300, 300
$br2 = New-Object System.Drawing.Drawing2D.LinearGradientBrush($r2, [System.Drawing.ColorTranslator]::FromHtml('#0F172A'), [System.Drawing.ColorTranslator]::FromHtml('#065F46'), 90.0)
$g2.FillRectangle($br2, $r2)
$pen2 = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml('#10B981'), 3)
$g2.DrawRectangle($pen2, 2, 2, 296, 296)

$g2.FillRectangle($bGold, 18, 16, 150, 22)
$g2.DrawString('CALCULATOR MASTERY', $fMiniB, $bDark, 25, 21)

$g2.FillRectangle($bMathBox, 18, 48, 264, 52)
$pFlow = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml('#10B981'), 1)
$g2.DrawRectangle($pFlow, 18, 48, 264, 52)

$bGreenLight = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#34D399'))
$fFlow = New-Object System.Drawing.Font('Arial', 11, [System.Drawing.FontStyle]::Bold)
$g2.DrawString('TI-84 Keystrokes & Shortcuts', $fFlow, $bGreenLight, 25, 55)
$g2.DrawString('LinRegTTest | 2-SampTInt', $fFlow, $bWhite, 25, 75)

$g2.DrawString('TI-84 Plus CE Playbooks', $fTitleC, $bWhite, 18, 115)

$rectB2 = New-Object System.Drawing.RectangleF(18, 145, 264, 135)
$desc2 = 'Step-by-step keystroke guides for every probability distribution, regression model, and inference hypothesis test on the AP exam.'
$g2.DrawString($desc2, $fBodyC, $bMuted, $rectB2)

$g2.Dispose()
Save-HighQualityJpg $card2 (Join-Path $outputDir 'KDP_Module_2_Choose_Standard_Three_Image_and_Text_Card_2_300x300.jpg')

# -------------------------------------------------------------------------
# 4. MODULE 2: CARD 3 - Practice Workbooks & FRQs (300 x 300 px)
# -------------------------------------------------------------------------
Write-Host 'Creating Module 2 Card 3 (300x300)...'
$card3 = New-Object System.Drawing.Bitmap 300, 300
$g3 = [System.Drawing.Graphics]::FromImage($card3)
$g3.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g3.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

$r3 = New-Object System.Drawing.Rectangle 0, 0, 300, 300
$br3 = New-Object System.Drawing.Drawing2D.LinearGradientBrush($r3, [System.Drawing.ColorTranslator]::FromHtml('#0F172A'), [System.Drawing.ColorTranslator]::FromHtml('#78350F'), 90.0)
$g3.FillRectangle($br3, $r3)
$pen3 = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml('#F59E0B'), 3)
$g3.DrawRectangle($pen3, 2, 2, 296, 296)

$g3.FillRectangle($bGold, 18, 16, 160, 22)
$g3.DrawString('PRACTICE WORKBOOKS', $fMiniB, $bDark, 25, 21)

$g3.FillRectangle($bMathBox, 18, 48, 264, 52)
$pFRQ = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml('#F59E0B'), 1)
$g3.DrawRectangle($pFRQ, 18, 48, 264, 52)

$fFRQ = New-Object System.Drawing.Font('Arial', 10.5, [System.Drawing.FontStyle]::Bold)
$bYellow = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#FDE047'))
$g3.DrawString('200+ Drills & Model Rubrics', $fFRQ, $bYellow, 25, 55)
$g3.DrawString('Score-4 FRQ Template Frames', $fFRQ, $bWhite, 25, 75)

$g3.DrawString('Unit Workbooks & Rubrics', $fTitleC, $bWhite, 18, 115)

$rectB3 = New-Object System.Drawing.RectangleF(18, 145, 264, 135)
$desc3 = 'Hands-on practice problems with step-by-step grader-annotated keys, deduction trap warnings, and fill-in-the-blank FRQ templates.'
$g3.DrawString($desc3, $fBodyC, $bMuted, $rectB3)

$g3.Dispose()
Save-HighQualityJpg $card3 (Join-Path $outputDir 'KDP_Module_2_Choose_Standard_Three_Image_and_Text_Card_3_300x300.jpg')

# -------------------------------------------------------------------------
# 5. MODULE 4: SIDEBAR - Web Companion & QR Access (300 x 300 px)
# -------------------------------------------------------------------------
Write-Host 'Creating Module 4 Sidebar (300x300)...'
$card4 = New-Object System.Drawing.Bitmap 300, 300
$g4 = [System.Drawing.Graphics]::FromImage($card4)
$g4.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g4.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

$r4 = New-Object System.Drawing.Rectangle 0, 0, 300, 300
$br4 = New-Object System.Drawing.Drawing2D.LinearGradientBrush($r4, [System.Drawing.ColorTranslator]::FromHtml('#0B1120'), [System.Drawing.ColorTranslator]::FromHtml('#1E3A8A'), 90.0)
$g4.FillRectangle($br4, $r4)
$pen4 = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml('#60A5FA'), 3)
$g4.DrawRectangle($pen4, 2, 2, 296, 296)

$g4.FillRectangle($bGold, 18, 16, 150, 22)
$g4.DrawString('SCAN QR IN BOOK', $fMiniB, $bDark, 28, 21)

Draw-QRCode $g4 18 48 68 '#0F172A' '#FFFFFF'

$fQRTit = New-Object System.Drawing.Font('Arial', 11, [System.Drawing.FontStyle]::Bold)
$g4.DrawString('FREE WEB APP', $fQRTit, $bGold, 96, 52)
$fQRSubT = New-Object System.Drawing.Font('Arial', 8.5, [System.Drawing.FontStyle]::Regular)
$g4.DrawString('Unit Drills`nTI-84 Simulator`nInstant Access', $fQRSubT, $bWhite, 96, 70)

$g4.DrawString('Interactive Digital Portal', $fTitleC, $bWhite, 18, 128)

$rectB4 = New-Object System.Drawing.RectangleF(18, 155, 264, 130)
$desc4 = 'Scan the QR code inside the book for instant digital access to unit diagnostic quizzes, formula cheat sheets, and online practice tools.'
$g4.DrawString($desc4, $fBodyC, $bMuted, $rectB4)

$g4.Dispose()
Save-HighQualityJpg $card4 (Join-Path $outputDir 'KDP_Module_4_Choose_Standard_Single_Image_and_Sidebar_300x300.jpg')

# -------------------------------------------------------------------------
# 6. WIDE COMPANION BANNER (970 x 300 px)
# -------------------------------------------------------------------------
Write-Host 'Creating Wide Companion Banner (970x300)...'
$wide = New-Object System.Drawing.Bitmap 970, 300
$gw = [System.Drawing.Graphics]::FromImage($wide)
$gw.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$gw.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

$rW = New-Object System.Drawing.Rectangle 0, 0, 970, 300
$brW = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rW, [System.Drawing.ColorTranslator]::FromHtml('#0F172A'), [System.Drawing.ColorTranslator]::FromHtml('#0284C7'), 45.0)
$gw.FillRectangle($brW, $rW)

for ($x = 0; $x -lt 970; $x += 35) { $gw.DrawLine($penGrid, $x, 0, $x, 300) }

Draw-QRCode $gw 45 45 130 '#0F172A' '#FFFFFF'
Draw-PhoneMockup $gw 195 40 120 220

$gw.FillRectangle($bGold, 340, 40, 240, 26)
$gw.DrawString('★ EXCLUSIVE DIGITAL ECOSYSTEM', $fMiniB, $bDark, 350, 46)

$fW1 = New-Object System.Drawing.Font('Arial', 22, [System.Drawing.FontStyle]::Bold)
$gw.DrawString('SCAN THE QR CODE INSIDE FOR', $fW1, $bWhite, 340, 75)
$gw.DrawString('INTERACTIVE PRACTICE WORKBOOKS', $fW1, $bGold, 340, 110)

$fWSub = New-Object System.Drawing.Font('Arial', 11, [System.Drawing.FontStyle]::Regular)
$gw.DrawString('Access unit diagnostic quizzes, searchable formula sheets, and interactive TI-84 keystrokes`non your phone, tablet, or laptop with zero app downloads.', $fWSub, $bMuted, 340, 155)

$fTrustW = New-Object System.Drawing.Font('Arial', 10, [System.Drawing.FontStyle]::Bold)
$gw.DrawString('100% Free Companion Portal  |  No App Download Required  |  Instant Mobile Access', $fTrustW, $bCyan, 340, 225)

$gw.Dispose()
Save-HighQualityJpg $wide (Join-Path $outputDir 'KDP_Alternative_Choose_Standard_Single_Image_and_Highlights_970x300.jpg')

Write-Host 'SUCCESS: All Book 2 A+ Content Graphics Generated in high resolution!' -ForegroundColor Green
