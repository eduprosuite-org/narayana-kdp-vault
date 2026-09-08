# =========================================================================
# BOOK 2: AP STATISTICS PREP BOOK 2027 - 3D A+ CONTENT GRAPHICS GENERATOR
# High-End 3D Visual Rendering Engine with Isometric Depth & Realistic Shadows
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

# Helper: Draw Realistic 3D Angled Book Mockup
function Draw-3DBookMockup {
    param($g, $x, $y, $w, $h, $title, $editionText)
    
    # Drop Shadow
    $bShadow = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(70, 0, 0, 0))
    $ptsShadow = @(
        (New-Object System.Drawing.PointF ($x + 15), ($y + $h)),
        (New-Object System.Drawing.PointF ($x + $w + 25), ($y + $h - 20)),
        (New-Object System.Drawing.PointF ($x + $w + 60), ($y + $h + 15)),
        (New-Object System.Drawing.PointF ($x + 30), ($y + $h + 35))
    )
    $g.FillPolygon($bShadow, $ptsShadow)

    # 3D Book Pages (Side Thickness)
    $rectPages = New-Object System.Drawing.Rectangle ($x + $w - 5), ($y + 15), 30, ($h - 30)
    $brushPages = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rectPages, [System.Drawing.ColorTranslator]::FromHtml('#E2E8F0'), [System.Drawing.ColorTranslator]::FromHtml('#94A3B8'), 0.0)
    $ptsPages = @(
        (New-Object System.Drawing.PointF ($x + $w), ($y + 12)),
        (New-Object System.Drawing.PointF ($x + $w + 24), ($y + 2)),
        (New-Object System.Drawing.PointF ($x + $w + 24), ($y + $h - 18)),
        (New-Object System.Drawing.PointF ($x + $w), ($y + $h))
    )
    $g.FillPolygon($brushPages, $ptsPages)
    $pPageLine = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml('#64748B'), 1)
    for ($i = 4; $i -lt 22; $i += 4) {
        $g.DrawLine($pPageLine, ($x + $w + $i), ($y + 12 - [int]($i*0.4)), ($x + $w + $i), ($y + $h - [int]($i*0.7)))
    }

    # 3D Spine (Left side curve)
    $rectSpine = New-Object System.Drawing.Rectangle ($x - 18), ($y + 10), 20, ($h - 5)
    $brushSpine = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rectSpine, [System.Drawing.ColorTranslator]::FromHtml('#0B1528'), [System.Drawing.ColorTranslator]::FromHtml('#0284C7'), 0.0)
    $ptsSpine = @(
        (New-Object System.Drawing.PointF ($x - 18), ($y + 16)),
        (New-Object System.Drawing.PointF $x, $y),
        (New-Object System.Drawing.PointF $x, ($y + $h)),
        (New-Object System.Drawing.PointF ($x - 18), ($y + $h + 12))
    )
    $g.FillPolygon($brushSpine, $ptsSpine)

    # 3D Front Cover Face
    $rectCover = New-Object System.Drawing.Rectangle $x, $y, $w, $h
    $brushCover = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rectCover, [System.Drawing.ColorTranslator]::FromHtml('#0F172A'), [System.Drawing.ColorTranslator]::FromHtml('#0369A1'), 65.0)
    $g.FillRectangle($brushCover, $rectCover)

    $pCover = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml('#38BDF8'), 2)
    $g.DrawRectangle($pCover, $x, $y, $w, $h)

    # Inner Gold & Cyan Design on Book
    $bGold = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#F59E0B'))
    $bDark = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#0F172A'))
    $bWhite = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $bCyan = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#38BDF8'))

    $g.FillRectangle($bGold, ($x + 18), ($y + 24), ($w - 36), 24)
    $fMiniB = New-Object System.Drawing.Font('Arial', 8.5, [System.Drawing.FontStyle]::Bold)
    $g.DrawString('★ 2027 EXAM READY EDITION', $fMiniB, $bDark, ($x + 28), ($y + 28))

    $fBookT1 = New-Object System.Drawing.Font('Arial', 14, [System.Drawing.FontStyle]::Bold)
    $fBookT2 = New-Object System.Drawing.Font('Arial', 12, [System.Drawing.FontStyle]::Bold)
    $g.DrawString('AP(R) STATISTICS', $fBookT1, $bWhite, ($x + 18), ($y + 65))
    $g.DrawString('PREP BOOK 2027', $fBookT2, $bGold, ($x + 18), ($y + 90))

    $fSub = New-Object System.Drawing.Font('Arial', 8, [System.Drawing.FontStyle]::Regular)
    $g.DrawString('The Complete 9-Unit Textbook &`nPractice Workbook Suite', $fSub, $bCyan, ($x + 18), ($y + 120))

    # Normal Curve on Book Cover
    $pC = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml('#F59E0B'), 2)
    $pts = New-Object System.Collections.Generic.List[System.Drawing.PointF]
    for ($px = ($x + 20); $px -le ($x + $w - 20); $px += 6) {
        $normX = ($px - ($x + $w/2)) / 30.0
        $normY = [Math]::Exp(-0.5 * $normX * $normX)
        $py = ($y + 210) - ($normY * 45)
        $pts.Add((New-Object System.Drawing.PointF ($px, $py)))
    }
    $g.DrawCurve($pC, $pts.ToArray())

    # Bottom Author Bar
    $fAuthor = New-Object System.Drawing.Font('Arial', 9, [System.Drawing.FontStyle]::Bold)
    $g.DrawString('PR', $fAuthor, $bWhite, ($x + 18), ($y + $h - 35))
    $g.DrawString('Book 2', $fAuthor, $bGold, ($x + $w - 60), ($y + $h - 35))
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

# -------------------------------------------------------------------------
# 1. MODULE 1: 3D HERO BANNER (970 x 600 px)
# -------------------------------------------------------------------------
$fMiniB = New-Object System.Drawing.Font('Arial', 8.5, [System.Drawing.FontStyle]::Bold)
Write-Host 'Creating 3D Module 1 Hero Banner (970x600)...'
$hero = New-Object System.Drawing.Bitmap 970, 600
$g = [System.Drawing.Graphics]::FromImage($hero)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

$rectH = New-Object System.Drawing.Rectangle 0, 0, 970, 600
$brushBgH = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rectH, [System.Drawing.ColorTranslator]::FromHtml('#0A0F1D'), [System.Drawing.ColorTranslator]::FromHtml('#0F2852'), 45.0)
$g.FillRectangle($brushBgH, $rectH)

$penGrid = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(25, 56, 189, 248), 1)
for ($x = 0; $x -lt 970; $x += 35) { $g.DrawLine($penGrid, $x, 0, $x, 600) }
for ($y = 0; $y -lt 600; $y += 35) { $g.DrawLine($penGrid, 0, $y, 970, $y) }

# Top Gold Badge: 2027 EXAM READY
$bGold = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#F59E0B'))
$g.FillRectangle($bGold, 45, 35, 230, 34)
$fBadge = New-Object System.Drawing.Font('Arial', 11.5, [System.Drawing.FontStyle]::Bold)
$bDark = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#0F172A'))
$g.DrawString('★ 2027 EXAM READY', $fBadge, $bDark, 58, 42)

$fSeries = New-Object System.Drawing.Font('Arial', 12, [System.Drawing.FontStyle]::Bold)
$bCyan = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#38BDF8'))
$g.DrawString('AP(R) STATISTICS MASTER REVIEW SERIES: BOOK 2', $fSeries, $bCyan, 290, 42)

# Main Title
$fH1 = New-Object System.Drawing.Font('Arial', 27, [System.Drawing.FontStyle]::Bold)
$bWhite = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$g.DrawString('AP(R) STATISTICS PREP BOOK 2027', $fH1, $bWhite, 45, 85)

$fH2 = New-Object System.Drawing.Font('Arial', 20, [System.Drawing.FontStyle]::Bold)
$g.DrawString('THE COMPLETE STUDY GUIDE & TEXTBOOK', $fH2, $bGold, 45, 130)

$fHSub = New-Object System.Drawing.Font('Arial', 11.5, [System.Drawing.FontStyle]::Regular)
$bMuted = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#CBD5E1'))
$g.DrawString('Full 9-Unit Curriculum Coverage, 200+ Practice Workbooks with Model Rubrics,`nTI-84 Plus CE Calculator Playbooks, and 2 Full-Length 2027 Practice Exams.', $fHSub, $bMuted, 45, 178)

# Left Feature Cards
function Draw-FeaturePill {
    param($gx, $x, $y, $title, $desc, $accentHex)
    $bBox = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(230, 15, 23, 42))
    $pBox = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml($accentHex), 2)
    $gx.FillRectangle($bBox, $x, $y, 520, 80)
    $gx.DrawRectangle($pBox, $x, $y, 520, 80)
    
    $fT = New-Object System.Drawing.Font('Arial', 12, [System.Drawing.FontStyle]::Bold)
    $bT = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml($accentHex))
    $gx.DrawString($title, $fT, $bT, ($x + 16), ($y + 12))
    
    $fD = New-Object System.Drawing.Font('Arial', 9.5, [System.Drawing.FontStyle]::Regular)
    $bD = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#E2E8F0'))
    $gx.DrawString($desc, $fD, $bD, ($x + 16), ($y + 40))
}

Draw-FeaturePill $g 45 250 '✔ Complete 9-Unit High School Textbook' 'Comprehensive lessons covering all College Board units with zero academic bloat.' '#38BDF8'
Draw-FeaturePill $g 45 345 '✔ 200+ Practice Workbooks & Model Rubrics' 'Unit drills, fill-in-the-blank FRQ templates, and scorer-annotated solutions.' '#10B981'
Draw-FeaturePill $g 45 440 '✔ Complete TI-84 Plus CE Calculator Playbooks' 'Step-by-step keystroke shortcuts to solve tests and distributions 2x faster.' '#F59E0B'

# Right: 3D Book Mockup & 3D QR Card
Draw-3DBookMockup $g 600 240 180 270 'AP STATS 2027' 'Book 2'

# Floating 3D QR Card
$bQRCard = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(240, 15, 23, 42))
$pQRCard = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml('#38BDF8'), 2)
$g.FillRectangle($bQRCard, 800, 240, 140, 270)
$g.DrawRectangle($pQRCard, 800, 240, 140, 270)

$g.FillRectangle($bGold, 800, 240, 140, 30)
$fQRT = New-Object System.Drawing.Font('Arial', 8.5, [System.Drawing.FontStyle]::Bold)
$g.DrawString('FREE WEB APP', $fQRT, $bDark, 818, 248)

Draw-QRCode $g 815 285 110 '#0F172A' '#FFFFFF'

$fQRFoot = New-Object System.Drawing.Font('Arial', 8, [System.Drawing.FontStyle]::Bold)
$g.DrawString('SCAN IN BOOK', $fQRFoot, $bGold, 818, 410)
$fQRSub = New-Object System.Drawing.Font('Arial', 7.5, [System.Drawing.FontStyle]::Regular)
$g.DrawString('Unit Quizzes`nTI-84 Simulator`nFree Mobile App', $fQRSub, $bWhite, 818, 435)

# Bottom Trust Bar
$bTrust = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#0284C7'))
$g.FillRectangle($bTrust, 45, 540, 895, 30)
$fTrust = New-Object System.Drawing.Font('Arial', 9.5, [System.Drawing.FontStyle]::Bold)
$g.DrawString('100% ALIGNED WITH 2026-2027 COLLEGE BOARD COURSE & EXAM DESCRIPTION (CED)', $fTrust, $bWhite, 120, 547)

$g.Dispose()
Save-HighQualityJpg $hero (Join-Path $outputDir 'KDP_Module_1_Choose_Standard_Image_Header_with_Text_970x600.jpg')

# -------------------------------------------------------------------------
# 2. MODULE 2: 3D CARD 1 - 9-Unit Textbook (300 x 300 px)
# -------------------------------------------------------------------------
Write-Host 'Creating 3D Module 2 Card 1 (300x300)...'
$card1 = New-Object System.Drawing.Bitmap 300, 300
$g1 = [System.Drawing.Graphics]::FromImage($card1)
$g1.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g1.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

$r1 = New-Object System.Drawing.Rectangle 0, 0, 300, 300
$br1 = New-Object System.Drawing.Drawing2D.LinearGradientBrush($r1, [System.Drawing.ColorTranslator]::FromHtml('#0F172A'), [System.Drawing.ColorTranslator]::FromHtml('#0369A1'), 90.0)
$g1.FillRectangle($br1, $r1)
$pen1 = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml('#38BDF8'), 3)
$g1.DrawRectangle($pen1, 2, 2, 296, 296)

$g1.FillRectangle($bGold, 18, 16, 140, 22)
$g1.DrawString('9-UNIT CURRICULUM', $fMiniB, $bDark, 26, 21)

Draw-3DBookMockup $g1 170 50 100 120 'AP STATS' '9 Units'

$fTitleC = New-Object System.Drawing.Font('Arial', 12.5, [System.Drawing.FontStyle]::Bold)
$g1.DrawString('Complete Course Textbook', $fTitleC, $bWhite, 18, 180)

$fBodyC = New-Object System.Drawing.Font('Arial', 8.8, [System.Drawing.FontStyle]::Regular)
$rectB1 = New-Object System.Drawing.RectangleF(18, 205, 264, 85)
$desc1 = 'Comprehensive lessons deconstructing all 9 College Board units with visual diagrams, essential definitions, and zero academic bloat.'
$g1.DrawString($desc1, $fBodyC, $bMuted, $rectB1)

$g1.Dispose()
Save-HighQualityJpg $card1 (Join-Path $outputDir 'KDP_Module_2_Choose_Standard_Three_Image_and_Text_Card_1_300x300.jpg')

# -------------------------------------------------------------------------
# 3. MODULE 2: 3D CARD 2 - TI-84 Plus CE Playbooks (300 x 300 px)
# -------------------------------------------------------------------------
Write-Host 'Creating 3D Module 2 Card 2 (300x300)...'
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

# 3D Calculator Device Representation
$bCalc = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#1E293B'))
$pCalc = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml('#34D399'), 2)
$g2.FillRectangle($bCalc, 160, 50, 110, 120)
$g2.DrawRectangle($pCalc, 160, 50, 110, 120)

$bScreen = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#0F172A'))
$g2.FillRectangle($bScreen, 168, 58, 94, 45)
$fCalcText = New-Object System.Drawing.Font('Arial', 7, [System.Drawing.FontStyle]::Bold)
$bGreenLight = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#34D399'))
$g2.DrawString('LinRegTTest', $fCalcText, $bGreenLight, 172, 62)
$g2.DrawString('t = 4.28, p=0.001', $fCalcText, $bWhite, 172, 75)

$g2.DrawString('TI-84 Plus CE Playbooks', $fTitleC, $bWhite, 18, 180)
$rectB2 = New-Object System.Drawing.RectangleF(18, 205, 264, 85)
$desc2 = 'Step-by-step keystroke guides for every probability distribution, regression model, and inference hypothesis test on the AP exam.'
$g2.DrawString($desc2, $fBodyC, $bMuted, $rectB2)

$g2.Dispose()
Save-HighQualityJpg $card2 (Join-Path $outputDir 'KDP_Module_2_Choose_Standard_Three_Image_and_Text_Card_2_300x300.jpg')

# -------------------------------------------------------------------------
# 4. MODULE 2: 3D CARD 3 - 200+ Practice Workbooks (300 x 300 px)
# -------------------------------------------------------------------------
Write-Host 'Creating 3D Module 2 Card 3 (300x300)...'
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

# 3D Workbook Score-4 Badge
$bFRQBadge = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(230, 15, 23, 42))
$pFRQBadge = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml('#F59E0B'), 2)
$g3.FillRectangle($bFRQBadge, 160, 50, 110, 120)
$g3.DrawRectangle($pFRQBadge, 160, 50, 110, 120)

$fBadgeFRQ = New-Object System.Drawing.Font('Arial', 11, [System.Drawing.FontStyle]::Bold)
$g3.DrawString('SCORE 4', $fBadgeFRQ, $bGold, 175, 65)
$fScoreSub = New-Object System.Drawing.Font('Arial', 7.5, [System.Drawing.FontStyle]::Regular)
$g3.DrawString('✔ 200+ Drills`n✔ Rubric Keys`n✔ 2 Full Exams', $fScoreSub, $bWhite, 170, 95)

$g3.DrawString('Unit Workbooks & Rubrics', $fTitleC, $bWhite, 18, 180)
$rectB3 = New-Object System.Drawing.RectangleF(18, 205, 264, 85)
$desc3 = 'Hands-on practice problems with step-by-step grader-annotated keys, deduction trap warnings, and fill-in-the-blank FRQ templates.'
$g3.DrawString($desc3, $fBodyC, $bMuted, $rectB3)

$g3.Dispose()
Save-HighQualityJpg $card3 (Join-Path $outputDir 'KDP_Module_2_Choose_Standard_Three_Image_and_Text_Card_3_300x300.jpg')

# -------------------------------------------------------------------------
# 5. MODULE 4: 3D SIDEBAR - Digital Companion & QR (300 x 300 px)
# -------------------------------------------------------------------------
Write-Host 'Creating 3D Module 4 Sidebar (300x300)...'
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

Draw-QRCode $g4 22 50 100 '#0F172A' '#FFFFFF'

$fQRTit = New-Object System.Drawing.Font('Arial', 11, [System.Drawing.FontStyle]::Bold)
$g4.DrawString('FREE WEB APP', $fQRTit, $bGold, 138, 55)
$fQRSubT = New-Object System.Drawing.Font('Arial', 8.5, [System.Drawing.FontStyle]::Regular)
$g4.DrawString('Unit Drills`nTI-84 Simulator`nInstant Access', $fQRSubT, $bWhite, 138, 80)

$g4.DrawString('Interactive Digital Portal', $fTitleC, $bWhite, 18, 175)
$rectB4 = New-Object System.Drawing.RectangleF(18, 202, 264, 85)
$desc4 = 'Scan the QR code inside the book for instant digital access to unit diagnostic quizzes, formula cheat sheets, and online practice tools.'
$g4.DrawString($desc4, $fBodyC, $bMuted, $rectB4)

$g4.Dispose()
Save-HighQualityJpg $card4 (Join-Path $outputDir 'KDP_Module_4_Choose_Standard_Single_Image_and_Sidebar_300x300.jpg')

# -------------------------------------------------------------------------
# 6. WIDE COMPANION BANNER (970 x 300 px)
# -------------------------------------------------------------------------
Write-Host 'Creating 3D Wide Companion Banner (970x300)...'
$wide = New-Object System.Drawing.Bitmap 970, 300
$gw = [System.Drawing.Graphics]::FromImage($wide)
$gw.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$gw.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

$rW = New-Object System.Drawing.Rectangle 0, 0, 970, 300
$brW = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rW, [System.Drawing.ColorTranslator]::FromHtml('#0F172A'), [System.Drawing.ColorTranslator]::FromHtml('#0284C7'), 45.0)
$gw.FillRectangle($brW, $rW)

for ($x = 0; $x -lt 970; $x += 35) { $gw.DrawLine($penGrid, $x, 0, $x, 300) }

Draw-3DBookMockup $gw 45 30 110 220 'AP STATS' '2027'
Draw-QRCode $gw 185 45 130 '#0F172A' '#FFFFFF'

$gw.FillRectangle($bGold, 340, 35, 240, 26)
$gw.DrawString('★ EXCLUSIVE DIGITAL ECOSYSTEM', $fMiniB, $bDark, 350, 41)

$fW1 = New-Object System.Drawing.Font('Arial', 21, [System.Drawing.FontStyle]::Bold)
$gw.DrawString('SCAN THE QR CODE INSIDE FOR', $fW1, $bWhite, 340, 70)
$gw.DrawString('INTERACTIVE PRACTICE WORKBOOKS', $fW1, $bGold, 340, 102)

$fWSub = New-Object System.Drawing.Font('Arial', 10.5, [System.Drawing.FontStyle]::Regular)
$gw.DrawString('Access unit diagnostic quizzes, searchable formula sheets, and interactive TI-84 keystrokes`non your phone, tablet, or laptop with zero app downloads.', $fWSub, $bMuted, 340, 145)

$fTrustW = New-Object System.Drawing.Font('Arial', 10, [System.Drawing.FontStyle]::Bold)
$gw.DrawString('100% Free Companion Portal  |  No App Download Required  |  Instant Mobile Access', $fTrustW, $bCyan, 340, 215)

$gw.Dispose()
Save-HighQualityJpg $wide (Join-Path $outputDir 'KDP_Alternative_Choose_Standard_Single_Image_and_Highlights_970x300.jpg')

Write-Host 'SUCCESS: All Book 2 3D-Enhanced A+ Graphics Generated!' -ForegroundColor Green
