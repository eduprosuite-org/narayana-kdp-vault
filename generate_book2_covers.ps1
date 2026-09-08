# =========================================================================
# BOOK 2: UNIVERSAL AMAZON KDP COVER ENGINE (ZERO-BLEED SAFE ZONE PROTOCOL)
# Title: AP Statistics Prep Book 2027: Complete Study Guide and Textbook
# Spine: 300 Pages (White Paper: 300 * 0.002252 = 0.6756 in)
# =========================================================================

Add-Type -AssemblyName System.Drawing

$outputDir = "d:\Narayana kdp\With 2.o\Book_2_AP_Statistics_Prep_Book_2027\Cover_Output_Files"
if (!(Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir -Force | Out-Null }

function Convert-JpgToPdf {
    param([string]$JpgPath, [string]$PdfPath, [double]$WidthInches, [double]$HeightInches)
    $wPts = [Math]::Round($WidthInches * 72, 2)
    $hPts = [Math]::Round($HeightInches * 72, 2)
    
    $jpgBytes = [System.IO.File]::ReadAllBytes($JpgPath)
    $img = [System.Drawing.Image]::FromFile($JpgPath)
    $pxW = $img.Width
    $pxH = $img.Height
    $img.Dispose()

    $stream = New-Object System.IO.MemoryStream
    $writer = New-Object System.IO.StreamWriter($stream, [System.Text.Encoding]::ASCII)
    $offsets = New-Object System.Collections.Generic.List[long]
    $offsets.Add(0)

    $writer.Write("%PDF-1.4`n")
    $writer.Flush()

    $offsets.Add($stream.Position)
    $writer.Write("1 0 obj`n<< /Type /Catalog /Pages 2 0 R >>`nendobj`n")
    $writer.Flush()

    $offsets.Add($stream.Position)
    $writer.Write("2 0 obj`n<< /Type /Pages /Kids [3 0 R] /Count 1 >>`nendobj`n")
    $writer.Flush()

    $offsets.Add($stream.Position)
    $writer.Write("3 0 obj`n<< /Type /Page /Parent 2 0 R /MediaBox [0 0 $wPts $hPts] /Contents 4 0 R /Resources << /XObject << /Im1 5 0 R >> >> >>`nendobj`n")
    $writer.Flush()

    $contentStr = "q`n$wPts 0 0 $hPts 0 0 cm`n/Im1 Do`nQ`n"
    $cLen = $contentStr.Length
    $offsets.Add($stream.Position)
    $writer.Write("4 0 obj`n<< /Length $cLen >>`nstream`n$contentStr`nendstream`nendobj`n")
    $writer.Flush()

    $offsets.Add($stream.Position)
    $writer.Write("5 0 obj`n<< /Type /XObject /Subtype /Image /Width $pxW /Height $pxH /ColorSpace /DeviceRGB /BitsPerComponent 8 /Filter /DCTDecode /Length $($jpgBytes.Length) >>`nstream`n")
    $writer.Flush()
    $stream.Write($jpgBytes, 0, $jpgBytes.Length)
    $writer.Write("`nendstream`nendobj`n")
    $writer.Flush()

    $xrefPos = $stream.Position
    $writer.Write("xref`n0 6`n0000000000 65535 f `n")
    for ($i = 1; $i -le 5; $i++) {
        $writer.Write(("{0:D10} 00000 n `n" -f $offsets[$i]))
    }
    $writer.Write("trailer`n<< /Size 6 /Root 1 0 R >>`nstartxref`n$xrefPos`n%%EOF`n")
    $writer.Flush()

    [System.IO.File]::WriteAllBytes($PdfPath, $stream.ToArray())
    $writer.Dispose()
    $stream.Dispose()
}

function Generate-KindleFrontCover {
    param([hashtable]$Theme, [string]$OutputDir)
    $id = $Theme.Id
    $name = $Theme.Name
    $filePath = Join-Path $OutputDir "Kindle_Cover_Design_${id}_${name}.jpg"

    $w = 1800
    $h = 2700
    $bmp = New-Object System.Drawing.Bitmap $w, $h
    $bmp.SetResolution(300, 300)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    $cBg1 = [System.Drawing.ColorTranslator]::FromHtml($Theme.BgColor)
    $cBg2 = [System.Drawing.ColorTranslator]::FromHtml($Theme.BgGradient)
    $rect = New-Object System.Drawing.Rectangle 0, 0, $w, $h
    $brushBg = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, $cBg1, $cBg2, 45.0)
    $g.FillRectangle($brushBg, $rect)

    # Grid
    $pGrid = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml($Theme.GridColor), 2)
    for ($x = 0; $x -lt $w; $x += 90) { $g.DrawLine($pGrid, $x, 0, $x, $h) }
    for ($y = 0; $y -lt $h; $y += 90) { $g.DrawLine($pGrid, 0, $y, $w, $y) }

    # Top Gold Badge
    $bGold = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml($Theme.GoldColor))
    $bDark = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#0F172A'))
    $bWhite = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $bAccent = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml($Theme.AccentColor))

    $g.FillRectangle($bGold, 120, 140, 520, 75)
    $fBadge = New-Object System.Drawing.Font('Arial', 24, [System.Drawing.FontStyle]::Bold)
    $g.DrawString('2027 EXAM READY', $fBadge, $bDark, 160, 158)

    # Series Title
    $fSeries = New-Object System.Drawing.Font('Arial', 26, [System.Drawing.FontStyle]::Bold)
    $g.DrawString('AP(R) STATISTICS MASTER REVIEW SERIES: BOOK 2', $fSeries, $bAccent, 120, 260)

    # Main Title Header
    $fMain = New-Object System.Drawing.Font('Arial', 68, [System.Drawing.FontStyle]::Bold)
    $g.DrawString('AP(R) STATISTICS', $fMain, $bWhite, 115, 330)

    # Large Accent Title
    $fAccent = New-Object System.Drawing.Font('Arial', 54, [System.Drawing.FontStyle]::Bold)
    $g.DrawString('PREP BOOK 2027', $fAccent, $bGold, 115, 430)

    # Subtitle Block
    $fSubT = New-Object System.Drawing.Font('Arial', 32, [System.Drawing.FontStyle]::Bold)
    $g.DrawString('THE COMPLETE STUDY GUIDE & TEXTBOOK', $fSubT, $bAccent, 120, 520)

    $fSubDesc = New-Object System.Drawing.Font('Arial', 24, [System.Drawing.FontStyle]::Regular)
    $rectSub = New-Object System.Drawing.RectangleF(120, 590, 1560, 160)
    $g.DrawString('Complete 9-Unit Curriculum, 200+ Practice Workbooks, TI-84 Plus CE Calculator Playbooks, and Full-Length Practice Exams.', $fSubDesc, $bWhite, $rectSub)

    # Central Visual Feature Box
    $bBox = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(210, 15, 23, 42))
    $pBox = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml($Theme.AccentColor), 3)
    $g.FillRectangle($bBox, 120, 780, 1560, 1100)
    $g.DrawRectangle($pBox, 120, 780, 1560, 1100)

    # Feature List
    $features = @(
        "[+] COMPLETE 9-UNIT CURRICULUM TEXTBOOK: One-Variable to Inference & Chi-Square",
        "[+] 200+ GUIDED PRACTICE WORKBOOKS: Grader-Annotated Drills with Solutions",
        "[+] TI-84 PLUS CE CALCULATOR PLAYBOOKS: Step-by-Step Keystroke Shortcuts",
        "[+] SCORE-4 FRQ TEMPLATES: Grader-Approved Interpretation Sentence Frames",
        "[+] 2 FULL-LENGTH PRACTICE EXAMS: Realistic 2027 Multiple Choice & FRQs",
        "[+] TOP 25 COMMON STUDENT TRAPS: Eliminate Costly Exam Pitfalls"
    )

    $fy = 830
    $fFeat = New-Object System.Drawing.Font('Arial', 23, [System.Drawing.FontStyle]::Bold)
    foreach ($feat in $features) {
        $g.DrawString($feat, $fFeat, $bWhite, 150, $fy)
        $fy += 95
    }

    # Central Normal Curve Illustration
    $pCurve = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml($Theme.GoldColor), 5)
    $curvePoints = New-Object System.Collections.Generic.List[System.Drawing.PointF]
    for ($px = 250; $px -le 1550; $px += 20) {
        $normX = ($px - 900) / 220.0
        $normY = [Math]::Exp(-0.5 * $normX * $normX)
        $py = 1680 - ($normY * 200)
        $curvePoints.Add((New-Object System.Drawing.PointF($px, $py)))
    }
    $g.DrawCurve($pCurve, $curvePoints.ToArray())

    # Stat Formula Overlays
    $fFormula = New-Object System.Drawing.Font('Arial', 24, [System.Drawing.FontStyle]::Bold)
    $g.DrawString('z = (x_bar - mu) / (sigma / sqrt(n))', $fFormula, $bAccent, 260, 1720)
    $g.DrawString('t = (b1 - 0) / SE(b1)', $fFormula, $bGold, 760, 1720)
    $g.DrawString('Chi2 = Sum (O - E)^2 / E', $fFormula, $bAccent, 1240, 1720)

    # QR Companion Box at bottom
    $bQRBox = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#0284C7'))
    $g.FillRectangle($bQRBox, 120, 1930, 1560, 200)
    $fQRH = New-Object System.Drawing.Font('Arial', 28, [System.Drawing.FontStyle]::Bold)
    $fQRS = New-Object System.Drawing.Font('Arial', 22, [System.Drawing.FontStyle]::Regular)
    $g.DrawString('FREE INTERACTIVE DIGITAL WEB COMPANION INCLUDED', $fQRH, $bGold, 160, 1960)
    $g.DrawString('Scan In-Book QR Code for Unit Quizzes, TI-84 Simulators, and Mobile Practice.', $fQRS, $bWhite, 160, 2030)

    # Author & Bottom Bar
    $fAuth = New-Object System.Drawing.Font('Arial', 32, [System.Drawing.FontStyle]::Bold)
    $g.DrawString('PR', $fAuth, $bWhite, 120, 2220)
    
    $fPub = New-Object System.Drawing.Font('Arial', 22, [System.Drawing.FontStyle]::Regular)
    $bMuted = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#94A3B8'))
    $g.DrawString('AP(R) Statistics Master Review Series  |  2027 Edition', $fPub, $bMuted, 120, 2275)

    # Trademark Nominative Disclaimer at bottom
    $fDisc = New-Object System.Drawing.Font('Arial', 14, [System.Drawing.FontStyle]::Regular)
    $discText = '*AP(R) and Advanced Placement(R) are registered trademarks of the College Board, which was not involved in the production of, and does not endorse, this product.'
    $g.DrawString($discText, $fDisc, $bMuted, 120, 2580)

    $g.Dispose()
    $encoder = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.FormatID -eq [System.Drawing.Imaging.ImageFormat]::Jpeg.Guid }
    $encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
    $encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [long]98)
    $bmp.Save($filePath, $encoder, $encoderParams)
    $bmp.Dispose()

    Write-Host "  -> Generated Kindle Front Cover: $filePath"
    return $filePath
}

function Build-ZeroBleedFullCover {
    param(
        [string]$FrontJpgPath,
        [hashtable]$Theme,
        [string]$OutputDir,
        [string]$SeriesTitle = 'AP(R) STATISTICS MASTER REVIEW SERIES',
        [string]$VolumeText  = 'BOOK 2',
        [string]$MainTitle   = 'AP(R) STATISTICS PREP BOOK 2027',
        [string]$Author      = 'PR',
        [int]$PageCount      = 300,
        [double]$TrimWidth   = 6.0,
        [double]$TrimHeight  = 9.0,
        [double]$WhitePaperFactor = 0.002252
    )

    $id   = $Theme.Id
    $name = $Theme.Name

    $cBg      = [System.Drawing.ColorTranslator]::FromHtml($Theme.BgColor)
    $cGrid    = [System.Drawing.ColorTranslator]::FromHtml($Theme.GridColor)
    $cGold    = [System.Drawing.ColorTranslator]::FromHtml($Theme.GoldColor)
    $cCyan    = [System.Drawing.ColorTranslator]::FromHtml($Theme.AccentColor)
    $cText    = [System.Drawing.ColorTranslator]::FromHtml($Theme.TextColor)

    $bGold    = New-Object System.Drawing.SolidBrush $cGold
    $bCyan    = New-Object System.Drawing.SolidBrush $cCyan
    $bText    = New-Object System.Drawing.SolidBrush $cText
    $bWhite   = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
    $bBlack   = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::Black)

    $spineWidth = [Math]::Round($PageCount * $WhitePaperFactor, 4) # 0.6756 in

    # ---------------------------------------------------------------------
    # 1. PAPERBACK FULL-WRAP (12.9256" x 9.250" @ 300 DPI)
    # ---------------------------------------------------------------------
    $bleed = 0.125
    $pWidthIn = $bleed + $TrimWidth + $spineWidth + $TrimWidth + $bleed
    $pHeightIn = $bleed + $TrimHeight + $bleed
    $pW = [int][Math]::Round($pWidthIn * 300)
    $pH = [int][Math]::Round($pHeightIn * 300)

    $pBmp = New-Object System.Drawing.Bitmap $pW, $pH
    $pBmp.SetResolution(300, 300)
    $pG = [System.Drawing.Graphics]::FromImage($pBmp)
    $pG.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $pG.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $pG.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    $pG.Clear($cBg)

    $gridPen = New-Object System.Drawing.Pen $cGrid, 2
    $spineStartPx = [int][Math]::Round(($bleed + $TrimWidth) * 300)
    $spineWidthPx = [int][Math]::Round($spineWidth * 300)
    $frontStartPx = $spineStartPx + $spineWidthPx
    $frontWidthPx = [int][Math]::Round(($TrimWidth + $bleed) * 300)

    for ($x = 0; $x -lt $spineStartPx; $x += 80) { $pG.DrawLine($gridPen, $x, 0, $x, $pH) }
    for ($y = 0; $y -lt $pH; $y += 80) { $pG.DrawLine($gridPen, 0, $y, $spineStartPx, $y) }
    $gridPen.Dispose()

    if (Test-Path $FrontJpgPath) {
        $frontImg = [System.Drawing.Image]::FromFile($FrontJpgPath)
        $pG.DrawImage($frontImg, $frontStartPx, 0, $frontWidthPx, $pH)
        $frontImg.Dispose()
    }

    # Back Cover Text
    $safeBackWidth = $spineStartPx - 250
    $bX = 140

    $titleRect = New-Object System.Drawing.RectangleF $bX, 180, $safeBackWidth, 120
    $pG.DrawString('The Ultimate All-In-One AP(R) Stats Prep Textbook.', (New-Object System.Drawing.Font ('Arial', 28, [System.Drawing.FontStyle]::Bold)), $bGold, $titleRect)
    
    $backDesc = 'Mastering AP(R) Statistics does not require juggling five disjointed books and confusing school handouts. This all-in-one prep textbook combines crystal-clear conceptual lessons across all 9 units with 200+ guided workbook drills, step-by-step TI-84 Plus CE calculator playbooks, and 2 full-length 2027 practice exams.'
    $descRect = New-Object System.Drawing.RectangleF $bX, 320, $safeBackWidth, 340
    $pG.DrawString($backDesc, (New-Object System.Drawing.Font ('Arial', 20, [System.Drawing.FontStyle]::Regular)), $bText, $descRect)

    $headerRect = New-Object System.Drawing.RectangleF $bX, 680, $safeBackWidth, 70
    $pG.DrawString('What Makes This Textbook Unbeatable:', (New-Object System.Drawing.Font ('Arial', 24, [System.Drawing.FontStyle]::Bold)), $bCyan, $headerRect)
    
    $backBullets = @(
        '* Complete 9-Unit Curriculum: Zero academic bloat, 100% aligned with the latest CED.',
        '* 200+ Guided Practice Workbooks: Step-by-step drills with detailed model keys.',
        '* TI-84 Plus CE Playbooks: Exact calculator keystrokes for every test and distribution.',
        '* Score-4 FRQ Templates: Grader-approved sentence frames for maximum points.',
        '* 2 Full-Length 2027 Practice Exams: Diagnostic scoring rubrics and full solutions.',
        '* Free Digital Web Companion: Scan in-book QR codes for instant mobile drills.'
    )
    $bby = 770
    foreach ($bb in $backBullets) {
        $bulletRect = New-Object System.Drawing.RectangleF $bX, $bby, $safeBackWidth, 90
        $pG.DrawString($bb, (New-Object System.Drawing.Font ('Arial', 18.5, [System.Drawing.FontStyle]::Regular)), $bText, $bulletRect)
        $bby += 115
    }

    # Barcode Safe Area
    $barcodeX = $spineStartPx - 680
    $barcodeY = $pH - 450
    $pG.FillRectangle($bWhite, $barcodeX, $barcodeY, 580, 340)
    $pG.DrawString('[ KDP BARCODE ZONE ]', (New-Object System.Drawing.Font ('Arial', 15, [System.Drawing.FontStyle]::Bold)), $bBlack, ($barcodeX + 90), ($barcodeY + 150))

    # Spine
    $spineMidX = $spineStartPx + ($spineWidthPx / 2)
    $state = $pG.Save()
    $pG.TranslateTransform($spineMidX, ($pH / 2))
    $pG.RotateTransform(90)
    $spineFont = New-Object System.Drawing.Font ('Arial', 19, [System.Drawing.FontStyle]::Bold)
    $spineText = "AP STATISTICS PREP BOOK 2027: COMPLETE STUDY GUIDE & TEXTBOOK    $VolumeText    $Author"
    $spineSize = $pG.MeasureString($spineText, $spineFont)
    $pG.DrawString($spineText, $spineFont, $bText, (-$spineSize.Width / 2), (-$spineSize.Height / 2))
    $pG.Restore($state)

    $paperbackJpgPath = Join-Path $OutputDir "Paperback_Cover_Design_${id}_${name}_FullWrap.jpg"
    $paperbackPdfPath = Join-Path $OutputDir "Paperback_Cover_Design_${id}_${name}_FullWrap.pdf"
    $pBmp.Save($paperbackJpgPath, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    $pG.Dispose()
    $pBmp.Dispose()

    Convert-JpgToPdf -JpgPath $paperbackJpgPath -PdfPath $paperbackPdfPath -WidthInches $pWidthIn -HeightInches $pHeightIn
    Write-Host "  -> Generated Zero-Bleed Paperback PDF: $paperbackPdfPath"

    # ---------------------------------------------------------------------
    # 2. HARDCOVER CASE-LAMINATE (13.8556" x 10.180" @ 300 DPI)
    # ---------------------------------------------------------------------
    $hWrap = 0.59
    $hWidthIn = $hWrap + $TrimWidth + $spineWidth + $TrimWidth + $hWrap
    $hHeightIn = $hWrap + $TrimHeight + $hWrap
    $hW = [int][Math]::Round($hWidthIn * 300)
    $hH = [int][Math]::Round($hHeightIn * 300)

    $hBmp = New-Object System.Drawing.Bitmap $hW, $hH
    $hBmp.SetResolution(300, 300)
    $hG = [System.Drawing.Graphics]::FromImage($hBmp)
    $hG.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $hG.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $hG.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    $hG.Clear($cBg)
    $hSpineStartPx = [int][Math]::Round(($hWrap + $TrimWidth) * 300)
    $hFrontStartPx = $hSpineStartPx + $spineWidthPx
    $hFrontWidthPx = [int][Math]::Round(($TrimWidth + $hWrap) * 300)

    $hGridPen = New-Object System.Drawing.Pen $cGrid, 2
    for ($x = 0; $x -lt $hSpineStartPx; $x += 80) { $hG.DrawLine($hGridPen, $x, 0, $x, $hH) }
    for ($y = 0; $y -lt $hH; $y += 80) { $hG.DrawLine($hGridPen, 0, $y, $hSpineStartPx, $y) }
    $hGridPen.Dispose()

    if (Test-Path $FrontJpgPath) {
        $frontImgH = [System.Drawing.Image]::FromFile($FrontJpgPath)
        $hG.DrawImage($frontImgH, $hFrontStartPx, 0, $hFrontWidthPx, $hH)
        $frontImgH.Dispose()
    }

    # Hardcover Back Text
    $hSafeBackWidth = $hSpineStartPx - 320
    $hbX = 240

    $hTitleRect = New-Object System.Drawing.RectangleF $hbX, 260, $hSafeBackWidth, 120
    $hG.DrawString('The Ultimate All-In-One AP(R) Stats Prep Textbook.', (New-Object System.Drawing.Font ('Arial', 28, [System.Drawing.FontStyle]::Bold)), $bGold, $hTitleRect)
    
    $hDescRect = New-Object System.Drawing.RectangleF $hbX, 400, $hSafeBackWidth, 340
    $hG.DrawString($backDesc, (New-Object System.Drawing.Font ('Arial', 20, [System.Drawing.FontStyle]::Regular)), $bText, $hDescRect)

    $hHeaderRect = New-Object System.Drawing.RectangleF $hbX, 760, $hSafeBackWidth, 70
    $hG.DrawString('Inside This Deluxe Hardcover Edition:', (New-Object System.Drawing.Font ('Arial', 24, [System.Drawing.FontStyle]::Bold)), $bCyan, $hHeaderRect)
    
    $hbby = 850
    foreach ($bb in $backBullets) {
        $hBulletRect = New-Object System.Drawing.RectangleF $hbX, $hbby, $hSafeBackWidth, 90
        $hG.DrawString($bb, (New-Object System.Drawing.Font ('Arial', 18.5, [System.Drawing.FontStyle]::Regular)), $bText, $hBulletRect)
        $hbby += 115
    }

    $hBarcodeX = $hSpineStartPx - 680
    $hBarcodeY = $hH - 560
    $hG.FillRectangle($bWhite, $hBarcodeX, $hBarcodeY, 580, 340)
    $hG.DrawString('[ KDP BARCODE ZONE ]', (New-Object System.Drawing.Font ('Arial', 15, [System.Drawing.FontStyle]::Bold)), $bBlack, ($hBarcodeX + 90), ($hBarcodeY + 150))

    # Hardcover Spine
    $hSpineMidX = $hSpineStartPx + ($spineWidthPx / 2)
    $stateH = $hG.Save()
    $hG.TranslateTransform($hSpineMidX, ($hH / 2))
    $hG.RotateTransform(90)
    $hG.DrawString($spineText, $spineFont, $bText, (-$spineSize.Width / 2), (-$spineSize.Height / 2))
    $hG.Restore($stateH)

    $hardcoverJpgPath = Join-Path $OutputDir "Hardcover_Cover_Design_${id}_${name}_CaseLaminate.jpg"
    $hardcoverPdfPath = Join-Path $OutputDir "Hardcover_Cover_Design_${id}_${name}_CaseLaminate.pdf"
    $hBmp.Save($hardcoverJpgPath, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    $hG.Dispose()
    $hBmp.Dispose()

    Convert-JpgToPdf -JpgPath $hardcoverJpgPath -PdfPath $hardcoverPdfPath -WidthInches $hWidthIn -HeightInches $hHeightIn
    Write-Host "  -> Generated Zero-Bleed Hardcover PDF: $hardcoverPdfPath"
}

function Run-AllBook2CoverGenerations {
    $outDir = "d:\Narayana kdp\With 2.o\Book_2_AP_Statistics_Prep_Book_2027\Cover_Output_Files"
    
    $suites = @(
        @{
            Id          = "1"
            Name        = "SkyBlue_White_2027_Ready"
            BgColor     = "#0284C7"
            BgGradient  = "#0369A1"
            GridColor   = "#38BDF8"
            AccentColor = "#FFFFFF"
            GoldColor   = "#FEF08A"
            TextColor   = "#FFFFFF"
        },
        @{
            Id          = "2"
            Name        = "RoyalBlue_Gold_2027_Ready"
            BgColor     = "#0F172A"
            BgGradient  = "#1E293B"
            GridColor   = "#1E3A5F"
            AccentColor = "#38BDF8"
            GoldColor   = "#F59E0B"
            TextColor   = "#FFFFFF"
        },
        @{
            Id          = "3"
            Name        = "TechBlueprint"
            BgColor     = "#0B1528"
            BgGradient  = "#0F172A"
            GridColor   = "#1E3A5F"
            AccentColor = "#06B6D4"
            GoldColor   = "#F59E0B"
            TextColor   = "#FFFFFF"
        },
        @{
            Id          = "4"
            Name        = "EmeraldAcademic"
            BgColor     = "#062C24"
            BgGradient  = "#064E3B"
            GridColor   = "#134E4A"
            AccentColor = "#10B981"
            GoldColor   = "#FBBF24"
            TextColor   = "#FFFFFF"
        },
        @{
            Id          = "5"
            Name        = "SapphireMinimalist"
            BgColor     = "#0C1838"
            BgGradient  = "#1E3A8A"
            GridColor   = "#1E3A8A"
            AccentColor = "#38BDF8"
            GoldColor   = "#E2E8F0"
            TextColor   = "#FFFFFF"
        }
    )

    Write-Host "========================================================================="
    Write-Host "GENERATING 5 BOOK 2 KINDLE COVERS + ZERO-BLEED PAPERBACK & HARDCOVER PDFS"
    Write-Host "========================================================================="

    foreach ($s in $suites) {
        Write-Host "Building Suite $($s.Id): $($s.Name)..."
        $frontImgPath = Generate-KindleFrontCover -Theme $s -OutputDir $outDir
        Build-ZeroBleedFullCover -FrontJpgPath $frontImgPath -Theme $s -OutputDir $outDir
    }

    Write-Host "========================================================================="
    Write-Host "ALL 5 BOOK 2 COVER SUITES COMPLETED WITH ZERO-BLEED INTEGRITY!"
    Write-Host "========================================================================="
}

Run-AllBook2CoverGenerations
