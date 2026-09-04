# =========================================================================
# UNIVERSAL AMAZON KDP COVER ENGINE (ZERO-BLEED SAFE ZONE PROTOCOL)
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

function Build-ZeroBleedFullCover {
    param(
        [string]$FrontJpgPath,
        [hashtable]$Theme,
        [string]$OutputDir,
        [string]$SeriesTitle = "AP® STATISTICS MASTER REVIEW SERIES",
        [string]$VolumeText  = "BOOK 1",
        [string]$MainTitle   = "AP® STATISTICS",
        [string]$AccentTitle = "FORMULA & INFERENCE",
        [string]$BottomTitle = "DECISION GUIDE",
        [string]$Author      = "PR",
        [string]$Edition     = "2027 Exam Ready Edition",
        [int]$PageCount      = 160,
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

    $spineWidth = [Math]::Round($PageCount * $WhitePaperFactor, 4)

    # ---------------------------------------------------------------------
    # 1. PAPERBACK FULL-WRAP (12.6103" x 9.250" @ 300 DPI)
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

    # Grid texture on Back only
    $gridPen = New-Object System.Drawing.Pen $cGrid, 2
    $spineStartPx = [int][Math]::Round(($bleed + $TrimWidth) * 300)
    $spineWidthPx = [int][Math]::Round($spineWidth * 300)
    $frontStartPx = $spineStartPx + $spineWidthPx
    $frontWidthPx = [int][Math]::Round(($TrimWidth + $bleed) * 300)

    for ($x = 0; $x -lt $spineStartPx; $x += 80) { $pG.DrawLine($gridPen, $x, 0, $x, $pH) }
    for ($y = 0; $y -lt $pH; $y += 80) { $pG.DrawLine($gridPen, 0, $y, $spineStartPx, $y) }
    $gridPen.Dispose()

    # Draw Front Image (Strictly from frontStartPx to right edge)
    if (Test-Path $FrontJpgPath) {
        $frontImg = [System.Drawing.Image]::FromFile($FrontJpgPath)
        $pG.DrawImage($frontImg, $frontStartPx, 0, $frontWidthPx, $pH)
        $frontImg.Dispose()
    }

    # Strict Back Cover Text Area (Bounded safely: Left 150px, Right stops 100px before spine!)
    $safeBackWidth = $spineStartPx - 250
    $bX = 140

    $titleRect = New-Object System.Drawing.RectangleF $bX, 200, $safeBackWidth, 120
    $pG.DrawString("Stop Memorizing. Master the Blueprint.", (New-Object System.Drawing.Font ("Arial", 30, [System.Drawing.FontStyle]::Bold)), $bGold, $titleRect)
    
    $backDesc = "You do not need another dense 600-page prep book. Designed for high-yield clarity, this companion cuts through textbook bloat to give you the exact formulas, visual mindmaps, inference decision trees, and rubric sentence frames required to master the AP® Statistics Exam."
    $descRect = New-Object System.Drawing.RectangleF $bX, 340, $safeBackWidth, 320
    $pG.DrawString($backDesc, (New-Object System.Drawing.Font ("Arial", 21, [System.Drawing.FontStyle]::Regular)), $bText, $descRect)

    $headerRect = New-Object System.Drawing.RectangleF $bX, 680, $safeBackWidth, 70
    $pG.DrawString("Inside This 2027 Master Companion:", (New-Object System.Drawing.Font ("Arial", 25, [System.Drawing.FontStyle]::Bold)), $bCyan, $headerRect)
    
    $backBullets = @(
        "* Plain-English Formulas: Every parameter decoded without proofs.",
        "* Unit Mindmaps: Visual 1-page concept roadmaps for all 9 units.",
        "* Master Mnemonics: Zero-guesswork checklists (PANIC, PHANTOM, BINS).",
        "* FRQ Sentence Frames: Standardized phrases for p-values and intervals.",
        "* Top 25 Traps: Never confuse 'failing to reject' with 'accepting'.",
        "* Exam Pacing Strategy: Pacing blueprints for the 3-hour digital exam.",
        "* Free Digital Companion: Instant interactive mobile practice drills."
    )
    $bby = 770
    foreach ($bb in $backBullets) {
        $bulletRect = New-Object System.Drawing.RectangleF $bX, $bby, $safeBackWidth, 90
        $pG.DrawString($bb, (New-Object System.Drawing.Font ("Arial", 19, [System.Drawing.FontStyle]::Regular)), $bText, $bulletRect)
        $bby += 115
    }

    # Barcode (Safely inside back cover, 100px before spine)
    $barcodeX = $spineStartPx - 680
    $barcodeY = $pH - 450
    $pG.FillRectangle($bWhite, $barcodeX, $barcodeY, 580, 340)
    $pG.DrawString("[ KDP BARCODE ZONE ]", (New-Object System.Drawing.Font ("Arial", 15, [System.Drawing.FontStyle]::Bold)), $bBlack, ($barcodeX + 90), ($barcodeY + 150))

    # Spine (Strictly centered inside spine, 0 text bleed!)
    $spineMidX = $spineStartPx + ($spineWidthPx / 2)
    $state = $pG.Save()
    $pG.TranslateTransform($spineMidX, ($pH / 2))
    $pG.RotateTransform(90)
    $spineFont = New-Object System.Drawing.Font ("Arial", 18, [System.Drawing.FontStyle]::Bold)
    $spineText = "AP STATISTICS FORMULA & INFERENCE DECISION GUIDE    $VolumeText"
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
    # 2. HARDCOVER CASE-LAMINATE (13.5403" x 10.180" @ 300 DPI)
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

    # Draw Hardcover Front Image
    if (Test-Path $FrontJpgPath) {
        $frontImgH = [System.Drawing.Image]::FromFile($FrontJpgPath)
        $hG.DrawImage($frontImgH, $hFrontStartPx, 0, $hFrontWidthPx, $hH)
        $frontImgH.Dispose()
    }

    # Hardcover Back Text (Bounded strictly)
    $hSafeBackWidth = $hSpineStartPx - 320
    $hbX = 240

    $hTitleRect = New-Object System.Drawing.RectangleF $hbX, 280, $hSafeBackWidth, 120
    $hG.DrawString("Stop Memorizing. Master the Blueprint.", (New-Object System.Drawing.Font ("Arial", 30, [System.Drawing.FontStyle]::Bold)), $bGold, $hTitleRect)
    
    $hDescRect = New-Object System.Drawing.RectangleF $hbX, 420, $hSafeBackWidth, 320
    $hG.DrawString($backDesc, (New-Object System.Drawing.Font ("Arial", 21, [System.Drawing.FontStyle]::Regular)), $bText, $hDescRect)

    $hHeaderRect = New-Object System.Drawing.RectangleF $hbX, 760, $hSafeBackWidth, 70
    $hG.DrawString("Inside This Hardcover Edition:", (New-Object System.Drawing.Font ("Arial", 25, [System.Drawing.FontStyle]::Bold)), $bCyan, $hHeaderRect)
    
    $hbby = 850
    foreach ($bb in $backBullets) {
        $hBulletRect = New-Object System.Drawing.RectangleF $hbX, $hbby, $hSafeBackWidth, 90
        $hG.DrawString($bb, (New-Object System.Drawing.Font ("Arial", 19, [System.Drawing.FontStyle]::Regular)), $bText, $hBulletRect)
        $hbby += 115
    }

    # Hardcover Barcode
    $hBarcodeX = $hSpineStartPx - 680
    $hBarcodeY = $hH - 560
    $hG.FillRectangle($bWhite, $hBarcodeX, $hBarcodeY, 580, 340)
    $hG.DrawString("[ KDP BARCODE ZONE ]", (New-Object System.Drawing.Font ("Arial", 15, [System.Drawing.FontStyle]::Bold)), $bBlack, ($hBarcodeX + 90), ($hBarcodeY + 150))

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

function Run-AllCoverGenerations {
    $outDir = "d:\Narayana kdp\With 2.o\Book_1_AP_Statistics_Formula_and_Inference_Guide\Cover_Output_Files"
    
    $suites = @(
        @{
            Id          = "1"
            Name        = "SkyBlue_White_2027_Ready"
            FrontImage  = "Kindle_Cover_Design_1_SkyBlue_2027_Ready.jpg"
            BgColor     = "#0284C7" # Sky Blue
            GridColor   = "#38BDF8"
            AccentColor = "#FFFFFF"
            GoldColor   = "#FEF08A"
            TextColor   = "#FFFFFF"
        },
        @{
            Id          = "2"
            Name        = "RoyalBlue_Gold_2027_Ready"
            FrontImage  = "Kindle_Cover_Design_2_RoyalBlue_2027_Ready.jpg"
            BgColor     = "#0F172A" # Deep Slate Navy
            GridColor   = "#1E3A5F"
            AccentColor = "#38BDF8"
            GoldColor   = "#F59E0B"
            TextColor   = "#FFFFFF"
        },
        @{
            Id          = "3"
            Name        = "TechBlueprint"
            FrontImage  = "Kindle_Cover_Design_3_TechBlueprint.jpg"
            BgColor     = "#0F172A"
            GridColor   = "#1E3A5F"
            AccentColor = "#06B6D4"
            GoldColor   = "#F59E0B"
            TextColor   = "#FFFFFF"
        },
        @{
            Id          = "4"
            Name        = "EmeraldAcademic"
            FrontImage  = "Kindle_Cover_Design_4_EmeraldAcademic.jpg"
            BgColor     = "#062C24"
            GridColor   = "#134E4A"
            AccentColor = "#10B981"
            GoldColor   = "#FBBF24"
            TextColor   = "#FFFFFF"
        },
        @{
            Id          = "5"
            Name        = "SapphireMinimalist"
            FrontImage  = "Kindle_Cover_Design_5_SapphireMinimalist.jpg"
            BgColor     = "#0C1838"
            GridColor   = "#1E3A8A"
            AccentColor = "#38BDF8"
            GoldColor   = "#E2E8F0"
            TextColor   = "#FFFFFF"
        }
    )

    Write-Host "========================================================================="
    Write-Host "COMPOSITING 5 ZERO-BLEED PAPERBACK & HARDCOVER PDFS"
    Write-Host "========================================================================="

    foreach ($s in $suites) {
        $frontImgPath = Join-Path $outDir $s.FrontImage
        Write-Host "Building Suite $($s.Id): $($s.Name)..."
        Build-ZeroBleedFullCover -FrontJpgPath $frontImgPath -Theme $s -OutputDir $outDir
    }

    Write-Host "========================================================================="
    Write-Host "ALL 5 COVER SUITES COMPLETED WITH ZERO-BLEED INTEGRITY!"
    Write-Host "========================================================================="
}

Run-AllCoverGenerations
