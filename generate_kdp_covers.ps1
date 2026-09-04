# =========================================================================
# UNIVERSAL AMAZON KDP COVER GENERATOR (DIRECT JPG & PRINT-READY PDF)
# =========================================================================

Add-Type -AssemblyName System.Drawing

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

function Render-KdpCoverPackage {
    param(
        [string]$OutputDir,
        [string]$SeriesTitle = "AP STATISTICS MASTER REVIEW SERIES",
        [string]$VolumeText  = "BOOK 1",
        [string]$MainTitle   = "AP STATISTICS",
        [string]$AccentTitle = "FORMULA & INFERENCE",
        [string]$BottomTitle = "DECISION GUIDE",
        [string]$Subtitle    = "The Complete High-Yield Exam Companion: Formula Breakdowns, Mindmaps, Inference Decision Trees, and Rubric Sentence Frames",
        [string]$Author      = "PR",
        [string]$Edition     = "2026-2027 Edition",
        [int]$PageCount      = 160,
        [double]$TrimWidth   = 6.0,
        [double]$TrimHeight  = 9.0,
        [double]$WhitePaperFactor = 0.002252
    )

    if (!(Test-Path $OutputDir)) {
        New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
    }

    # Color Palette
    $cBg      = [System.Drawing.ColorTranslator]::FromHtml("#0F172A")
    $cCard    = [System.Drawing.ColorTranslator]::FromHtml("#1E293B")
    $cGrid    = [System.Drawing.ColorTranslator]::FromHtml("#1E3A5F")
    $cGold    = [System.Drawing.ColorTranslator]::FromHtml("#F59E0B")
    $cCyan    = [System.Drawing.ColorTranslator]::FromHtml("#06B6D4")
    $cWhite   = [System.Drawing.Color]::White
    $cMuted   = [System.Drawing.ColorTranslator]::FromHtml("#94A3B8")

    $bGold    = New-Object System.Drawing.SolidBrush $cGold
    $bCyan    = New-Object System.Drawing.SolidBrush $cCyan
    $bWhite   = New-Object System.Drawing.SolidBrush $cWhite
    $bMuted   = New-Object System.Drawing.SolidBrush $cMuted
    $bCard    = New-Object System.Drawing.SolidBrush $cCard
    $bBlack   = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::Black)

    $bullets = @(
        "[+] Complete 9-Unit Mindmaps and Visual Flowcharts",
        "[+] Master Inference Decision Matrix (Z vs t vs Chi-Square)",
        "[+] 5 Master Mnemonics: SOCS, BINS, LINER, PANIC, PHANTOM",
        "[+] Fill-in-the-Blank Sentence Frames for Full FRQ Credit",
        "[+] Top 25 Grader Deduction Traps and Pitfall Warnings",
        "[+] Digital Bluebook 3-Hour Exam Pacing Blueprint",
        "[+] Free In-Book Interactive Student Companion Portal"
    )

    # =====================================================================
    # 1. KINDLE EBOOK FRONT COVER (1600 x 2560 px, 300 DPI JPG)
    # =====================================================================
    $kW = 1600
    $kH = 2560
    $kBmp = New-Object System.Drawing.Bitmap $kW, $kH
    $kBmp.SetResolution(300, 300)
    $kG = [System.Drawing.Graphics]::FromImage($kBmp)
    $kG.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $kG.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    $kG.Clear($cBg)
    $gridPen = New-Object System.Drawing.Pen $cGrid, 2
    for ($x = 0; $x -lt $kW; $x += 80) { $kG.DrawLine($gridPen, $x, 0, $x, $kH) }
    for ($y = 0; $y -lt $kH; $y += 80) { $kG.DrawLine($gridPen, 0, $y, $kW, $y) }
    $gridPen.Dispose()

    $fSeries = New-Object System.Drawing.Font ("Arial", 30, [System.Drawing.FontStyle]::Bold)
    $fTitle1 = New-Object System.Drawing.Font ("Arial", 76, [System.Drawing.FontStyle]::Bold)
    $fTitle2 = New-Object System.Drawing.Font ("Arial", 70, [System.Drawing.FontStyle]::Bold)
    $fTitle3 = New-Object System.Drawing.Font ("Arial", 64, [System.Drawing.FontStyle]::Bold)
    $fSub    = New-Object System.Drawing.Font ("Arial", 32, [System.Drawing.FontStyle]::Regular)
    $fBadgeH = New-Object System.Drawing.Font ("Arial", 34, [System.Drawing.FontStyle]::Bold)
    $fBadgeB = New-Object System.Drawing.Font ("Arial", 28, [System.Drawing.FontStyle]::Regular)
    $fAuthor = New-Object System.Drawing.Font ("Arial", 34, [System.Drawing.FontStyle]::Bold)

    $kG.DrawString("$SeriesTitle - $VolumeText", $fSeries, $bCyan, 100, 160)
    $kG.DrawString($MainTitle, $fTitle1, $bWhite, 100, 260)
    $kG.DrawString($AccentTitle, $fTitle2, $bGold, 100, 370)
    $kG.DrawString($BottomTitle, $fTitle3, $bWhite, 100, 480)

    $subRect = New-Object System.Drawing.RectangleF 100, 600, 1400, 260
    $kG.DrawString($Subtitle, $fSub, $bMuted, $subRect)

    $cardRect = New-Object System.Drawing.Rectangle 100, 920, 1400, 1150
    $kG.FillRectangle($bCard, $cardRect)
    $cardPen = New-Object System.Drawing.Pen $cCyan, 4
    $kG.DrawRectangle($cardPen, $cardRect)
    $cardPen.Dispose()

    $kG.DrawString("CRACK THE SCORE-5 RUBRIC:", $fBadgeH, $bGold, 140, 970)
    $by = 1080
    foreach ($b in $bullets) {
        $kG.DrawString($b, $fBadgeB, $bWhite, 140, $by)
        $by += 130
    }

    $kG.DrawString("By $Author - $Edition", $fAuthor, $bWhite, 100, 2350)

    $kindleJpgPath = Join-Path $OutputDir "kindle_cover_front_2560x1600.jpg"
    $kBmp.Save($kindleJpgPath, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    $kG.Dispose()
    $kBmp.Dispose()
    Write-Host "Generated Kindle eBook Cover: $kindleJpgPath"

    # =====================================================================
    # 2. PAPERBACK FULL-WRAP COVER (PDF & JPG)
    # =====================================================================
    $bleed = 0.125
    $spineWidth = [Math]::Round($PageCount * $WhitePaperFactor, 4)
    $pWidthIn = $bleed + $TrimWidth + $spineWidth + $TrimWidth + $bleed
    $pHeightIn = $bleed + $TrimHeight + $bleed

    $pW = [int][Math]::Round($pWidthIn * 300)
    $pH = [int][Math]::Round($pHeightIn * 300)

    $pBmp = New-Object System.Drawing.Bitmap $pW, $pH
    $pBmp.SetResolution(300, 300)
    $pG = [System.Drawing.Graphics]::FromImage($pBmp)
    $pG.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $pG.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    $pG.Clear($cBg)
    $gridPen = New-Object System.Drawing.Pen $cGrid, 2
    for ($x = 0; $x -lt $pW; $x += 75) { $pG.DrawLine($gridPen, $x, 0, $x, $pH) }
    for ($y = 0; $y -lt $pH; $y += 75) { $pG.DrawLine($gridPen, 0, $y, $pW, $y) }
    $gridPen.Dispose()

    $spineStartPx = [int][Math]::Round(($bleed + $TrimWidth) * 300)
    $spineWidthPx = [int][Math]::Round($spineWidth * 300)
    $frontStartPx = $spineStartPx + $spineWidthPx

    # Front Side
    $fX = $frontStartPx + 150
    $pG.DrawString("$SeriesTitle - $VolumeText", (New-Object System.Drawing.Font ("Arial", 22, [System.Drawing.FontStyle]::Bold)), $bCyan, $fX, 220)
    $pG.DrawString($MainTitle, (New-Object System.Drawing.Font ("Arial", 52, [System.Drawing.FontStyle]::Bold)), $bWhite, $fX, 300)
    $pG.DrawString($AccentTitle, (New-Object System.Drawing.Font ("Arial", 48, [System.Drawing.FontStyle]::Bold)), $bGold, $fX, 400)
    $pG.DrawString($BottomTitle, (New-Object System.Drawing.Font ("Arial", 44, [System.Drawing.FontStyle]::Bold)), $bWhite, $fX, 490)

    $subRectP = New-Object System.Drawing.RectangleF $fX, 600, 1500, 240
    $pG.DrawString($Subtitle, (New-Object System.Drawing.Font ("Arial", 24, [System.Drawing.FontStyle]::Regular)), $bMuted, $subRectP)

    $cardRectP = New-Object System.Drawing.Rectangle $fX, 880, 1450, 1200
    $pG.FillRectangle($bCard, $cardRectP)
    $cardPen = New-Object System.Drawing.Pen $cCyan, 3
    $pG.DrawRectangle($cardPen, $cardRectP)
    $cardPen.Dispose()

    $pG.DrawString("CRACK THE OFFICIAL RUBRIC:", (New-Object System.Drawing.Font ("Arial", 28, [System.Drawing.FontStyle]::Bold)), $bGold, ($fX + 40), 930)
    $pby = 1040
    foreach ($b in $bullets) {
        $pG.DrawString($b, (New-Object System.Drawing.Font ("Arial", 22, [System.Drawing.FontStyle]::Regular)), $bWhite, ($fX + 40), $pby)
        $pby += 135
    }
    $pG.DrawString("By $Author - $Edition", (New-Object System.Drawing.Font ("Arial", 26, [System.Drawing.FontStyle]::Bold)), $bWhite, $fX, 2450)

    # Spine Side
    $spineMidX = $spineStartPx + ($spineWidthPx / 2)
    $state = $pG.Save()
    $pG.TranslateTransform($spineMidX, ($pH / 2))
    $pG.RotateTransform(90)
    $spineFont = New-Object System.Drawing.Font ("Arial", 20, [System.Drawing.FontStyle]::Bold)
    $spineText = "$MainTitle $AccentTitle $BottomTitle    $VolumeText"
    $spineSize = $pG.MeasureString($spineText, $spineFont)
    $pG.DrawString($spineText, $spineFont, $bWhite, (-$spineSize.Width / 2), (-$spineSize.Height / 2))
    $pG.Restore($state)

    # Back Side
    $bX = 150
    $pG.DrawString("Stop Memorizing. Master the Blueprint.", (New-Object System.Drawing.Font ("Arial", 36, [System.Drawing.FontStyle]::Bold)), $bGold, $bX, 220)
    $backDesc = "You do not need another dense 600-page prep book. Designed for high-yield clarity, this companion cuts through textbook bloat to give you the exact formulas, visual mindmaps, inference decision trees, and rubric sentence frames required to master the AP Statistics Exam."
    $descRect = New-Object System.Drawing.RectangleF $bX, 350, 1450, 320
    $pG.DrawString($backDesc, (New-Object System.Drawing.Font ("Arial", 23, [System.Drawing.FontStyle]::Regular)), $bWhite, $descRect)

    $pG.DrawString("Inside This Master Review Companion:", (New-Object System.Drawing.Font ("Arial", 28, [System.Drawing.FontStyle]::Bold)), $bCyan, $bX, 720)
    $backBullets = @(
        "* Plain-English Formulas: Every parameter decoded without proofs.",
        "* Unit Mindmaps: Visual 1-page concept roadmaps for all 9 units.",
        "* Master Mnemonics: Zero-guesswork checklists (PANIC, PHANTOM, BINS).",
        "* FRQ Sentence Frames: Standardized phrases for p-values and intervals.",
        "* Top 25 Traps: Never confuse 'failing to reject' with 'accepting'.",
        "* Exam Pacing Strategy: Pacing blueprints for the 3-hour digital exam.",
        "* Free Digital Companion: Instant interactive mobile practice drills."
    )
    $bby = 820
    foreach ($bb in $backBullets) {
        $pG.DrawString($bb, (New-Object System.Drawing.Font ("Arial", 22, [System.Drawing.FontStyle]::Regular)), $bWhite, $bX, $bby)
        $bby += 130
    }

    # Barcode
    $barcodeX = $spineStartPx - 700
    $barcodeY = $pH - 460
    $pG.FillRectangle($bWhite, $barcodeX, $barcodeY, 600, 360)
    $pG.DrawString("[ KDP BARCODE EXCLUSION ZONE ]", (New-Object System.Drawing.Font ("Arial", 16, [System.Drawing.FontStyle]::Bold)), $bBlack, ($barcodeX + 100), ($barcodeY + 160))

    $paperbackJpgPath = Join-Path $OutputDir "paperback_cover_fullwrap_6x9.jpg"
    $paperbackPdfPath = Join-Path $OutputDir "paperback_cover_fullwrap_6x9.pdf"
    $pBmp.Save($paperbackJpgPath, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    $pG.Dispose()
    $pBmp.Dispose()

    Convert-JpgToPdf -JpgPath $paperbackJpgPath -PdfPath $paperbackPdfPath -WidthInches $pWidthIn -HeightInches $pHeightIn
    Write-Host "Generated Paperback Full-Wrap PDF: $paperbackPdfPath ($pWidthIn x $pHeightIn in)"

    # =====================================================================
    # 3. HARDCOVER CASE-LAMINATE COVER (PDF & JPG)
    # =====================================================================
    $hWrap = 0.59
    $hWidthIn = $hWrap + $TrimWidth + $spineWidth + $TrimWidth + $hWrap
    $hHeightIn = $hWrap + $TrimHeight + $hWrap

    $hW = [int][Math]::Round($hWidthIn * 300)
    $hH = [int][Math]::Round($hHeightIn * 300)

    $hBmp = New-Object System.Drawing.Bitmap $hW, $hH
    $hBmp.SetResolution(300, 300)
    $hG = [System.Drawing.Graphics]::FromImage($hBmp)
    $hG.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $hG.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    $hG.Clear($cBg)
    $gridPen = New-Object System.Drawing.Pen $cGrid, 2
    for ($x = 0; $x -lt $hW; $x += 75) { $hG.DrawLine($gridPen, $x, 0, $x, $hH) }
    for ($y = 0; $y -lt $hH; $y += 75) { $hG.DrawLine($gridPen, 0, $y, $hW, $y) }
    $gridPen.Dispose()

    $hSpineStartPx = [int][Math]::Round(($hWrap + $TrimWidth) * 300)
    $hFrontStartPx = $hSpineStartPx + $spineWidthPx

    $hfX = $hFrontStartPx + 150
    $hG.DrawString("$SeriesTitle - $VolumeText", (New-Object System.Drawing.Font ("Arial", 22, [System.Drawing.FontStyle]::Bold)), $bCyan, $hfX, 320)
    $hG.DrawString($MainTitle, (New-Object System.Drawing.Font ("Arial", 52, [System.Drawing.FontStyle]::Bold)), $bWhite, $hfX, 400)
    $hG.DrawString($AccentTitle, (New-Object System.Drawing.Font ("Arial", 48, [System.Drawing.FontStyle]::Bold)), $bGold, $hfX, 500)
    $hG.DrawString($BottomTitle, (New-Object System.Drawing.Font ("Arial", 44, [System.Drawing.FontStyle]::Bold)), $bWhite, $hfX, 590)

    $hSubRect = New-Object System.Drawing.RectangleF $hfX, 700, 1500, 240
    $hG.DrawString($Subtitle, (New-Object System.Drawing.Font ("Arial", 24, [System.Drawing.FontStyle]::Regular)), $bMuted, $hSubRect)

    $hCardRect = New-Object System.Drawing.Rectangle $hfX, 980, 1450, 1200
    $hG.FillRectangle($bCard, $hCardRect)
    $cardPen = New-Object System.Drawing.Pen $cCyan, 3
    $hG.DrawRectangle($cardPen, $hCardRect)
    $cardPen.Dispose()

    $hG.DrawString("COLLECTOR HARDCOVER EDITION:", (New-Object System.Drawing.Font ("Arial", 28, [System.Drawing.FontStyle]::Bold)), $bGold, ($hfX + 40), 1030)
    $hpby = 1140
    foreach ($b in $bullets) {
        $hG.DrawString($b, (New-Object System.Drawing.Font ("Arial", 22, [System.Drawing.FontStyle]::Regular)), $bWhite, ($hfX + 40), $hpby)
        $hpby += 135
    }
    $hG.DrawString("By $Author - Hardcover Edition", (New-Object System.Drawing.Font ("Arial", 26, [System.Drawing.FontStyle]::Bold)), $bWhite, $hfX, 2550)

    # Hardcover Spine
    $hSpineMidX = $hSpineStartPx + ($spineWidthPx / 2)
    $stateH = $hG.Save()
    $hG.TranslateTransform($hSpineMidX, ($hH / 2))
    $hG.RotateTransform(90)
    $hG.DrawString($spineText, $spineFont, $bWhite, (-$spineSize.Width / 2), (-$spineSize.Height / 2))
    $hG.Restore($stateH)

    # Hardcover Back
    $hbX = 250
    $hG.DrawString("Stop Memorizing. Master the Blueprint.", (New-Object System.Drawing.Font ("Arial", 36, [System.Drawing.FontStyle]::Bold)), $bGold, $hbX, 320)
    $hDescRect = New-Object System.Drawing.RectangleF $hbX, 450, 1450, 320
    $hG.DrawString($backDesc, (New-Object System.Drawing.Font ("Arial", 23, [System.Drawing.FontStyle]::Regular)), $bWhite, $hDescRect)

    $hG.DrawString("Inside This Hardcover Edition:", (New-Object System.Drawing.Font ("Arial", 28, [System.Drawing.FontStyle]::Bold)), $bCyan, $hbX, 820)
    $hbby = 920
    foreach ($bb in $backBullets) {
        $hG.DrawString($bb, (New-Object System.Drawing.Font ("Arial", 22, [System.Drawing.FontStyle]::Regular)), $bWhite, $hbX, $hbby)
        $hbby += 130
    }

    $hBarcodeX = $hSpineStartPx - 700
    $hBarcodeY = $hH - 580
    $hG.FillRectangle($bWhite, $hBarcodeX, $hBarcodeY, 600, 360)
    $hG.DrawString("[ KDP BARCODE EXCLUSION ZONE ]", (New-Object System.Drawing.Font ("Arial", 16, [System.Drawing.FontStyle]::Bold)), $bBlack, ($hBarcodeX + 100), ($hBarcodeY + 160))

    $hardcoverJpgPath = Join-Path $OutputDir "hardcover_cover_caselaminate_6x9.jpg"
    $hardcoverPdfPath = Join-Path $OutputDir "hardcover_cover_caselaminate_6x9.pdf"
    $hBmp.Save($hardcoverJpgPath, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    $hG.Dispose()
    $hBmp.Dispose()

    Convert-JpgToPdf -JpgPath $hardcoverJpgPath -PdfPath $hardcoverPdfPath -WidthInches $hWidthIn -HeightInches $hHeightIn
    Write-Host "Generated Hardcover Case-Laminate PDF: $hardcoverPdfPath ($hWidthIn x $hHeightIn in)"
}

# Render Direct Files for Book 1
Render-KdpCoverPackage -OutputDir "d:\Narayana kdp\With 2.o\Book_1_AP_Statistics_Formula_and_Inference_Guide\Cover_Output_Files"
