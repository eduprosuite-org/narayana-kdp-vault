Add-Type -AssemblyName System.Drawing

function Convert-JpgToPdf {
    param([string]$JpgPath, [string]$PdfPath, [double]$WidthInches, [double]$HeightInches)
    $wPts = [Math]::Round($WidthInches * 72, 2)
    $hPts = [Math]::Round($HeightInches * 72, 2)
    $jpgBytes = [System.IO.File]::ReadAllBytes($JpgPath)
    $img = [System.Drawing.Image]::FromFile($JpgPath)
    $pxW = $img.Width; $pxH = $img.Height; $img.Dispose()
    $stream = New-Object System.IO.MemoryStream
    $writer = New-Object System.IO.StreamWriter($stream, [System.Text.Encoding]::ASCII)
    $offsets = New-Object System.Collections.Generic.List[long]
    $offsets.Add(0)
    $writer.Write("%PDF-1.4`n"); $writer.Flush()
    $offsets.Add($stream.Position)
    $writer.Write("1 0 obj`n<< /Type /Catalog /Pages 2 0 R >>`nendobj`n"); $writer.Flush()
    $offsets.Add($stream.Position)
    $writer.Write("2 0 obj`n<< /Type /Pages /Kids [3 0 R] /Count 1 >>`nendobj`n"); $writer.Flush()
    $offsets.Add($stream.Position)
    $writer.Write("3 0 obj`n<< /Type /Page /Parent 2 0 R /MediaBox [0 0 $wPts $hPts] /Contents 4 0 R /Resources << /XObject << /Im1 5 0 R >> >> >>`nendobj`n"); $writer.Flush()
    $contentStr = "q`n$wPts 0 0 $hPts 0 0 cm`n/Im1 Do`nQ`n"
    $cLen = $contentStr.Length
    $offsets.Add($stream.Position)
    $writer.Write("4 0 obj`n<< /Length $cLen >>`nstream`n$contentStr`nendstream`nendobj`n"); $writer.Flush()
    $offsets.Add($stream.Position)
    $writer.Write("5 0 obj`n<< /Type /XObject /Subtype /Image /Width $pxW /Height $pxH /ColorSpace /DeviceRGB /BitsPerComponent 8 /Filter /DCTDecode /Length $($jpgBytes.Length) >>`nstream`n"); $writer.Flush()
    $stream.Write($jpgBytes, 0, $jpgBytes.Length)
    $writer.Write("`nendstream`nendobj`n"); $writer.Flush()
    $xrefPos = $stream.Position
    $writer.Write("xref`n0 6`n0000000000 65535 f `n")
    for ($i = 1; $i -le 5; $i++) { $writer.Write(("{0:D10} 00000 n `n" -f $offsets[$i])) }
    $writer.Write("trailer`n<< /Size 6 /Root 1 0 R >>`nstartxref`n$xrefPos`n%%EOF`n"); $writer.Flush()
    [System.IO.File]::WriteAllBytes($PdfPath, $stream.ToArray())
    $writer.Dispose(); $stream.Dispose()
}

function Generate-Book-Covers {
    param(
        [string]$TargetDir,
        [string]$SpineTitle,
        [int]$PageCount,
        [string]$SeriesTagline,
        [string]$BookBackTitle
    )

    $outputDir = Join-Path $TargetDir "Cover_Output_Files"
    if (!(Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir -Force | Out-Null }

    $designs = @(
        @{ Id="1"; ShortName="SkyBlue"; KindleFile="Kindle_Cover_Design_1_SkyBlue.jpg"; BgColor="#0A2447"; SpineColor="#0284C7"; GoldColor="#F59E0B"; AccentColor="#38BDF8"; BackTextColor="#FFFFFF"; BackTitle=$BookBackTitle; BackBody=@("Complete College Board Curriculum","Guided Workbooks with Step Solutions","TI-84 & TI-Nspire Keystrokes","FRQ Justification Sentence Frames","Top Exam Trap Pitfalls","Free Online Companion Web Portal"); BackTagline=$SeriesTagline },
        @{ Id="2"; ShortName="RoyalGold"; KindleFile="Kindle_Cover_Design_2_RoyalGold.jpg"; BgColor="#0D1B2A"; SpineColor="#1A3A6B"; GoldColor="#D4AF37"; AccentColor="#F59E0B"; BackTextColor="#FFFFFF"; BackTitle=$BookBackTitle; BackBody=@("Comprehensive Unit Breakdown","250+ Practice Drill Problems","Calculator Keystroke Playbooks","Score-5 FRQ Justification Rules","Existence Theorems (IVT, MVT, FTC)","Free Digital Theorem Cheat Sheets"); BackTagline=$SeriesTagline },
        @{ Id="3"; ShortName="TechBlueprint"; KindleFile="Kindle_Cover_Design_3_TechBlueprint.jpg"; BgColor="#050D1A"; SpineColor="#0284C7"; GoldColor="#38BDF8"; AccentColor="#00D4FF"; BackTextColor="#FFFFFF"; BackTitle=$BookBackTitle; BackBody=@("Structured Curriculum Topics","250+ Practice Problems & Keys","Graphing Calculator Shortcuts","MVT and FTC FRQ Frameworks","Solids of Revolution Drills","Interactive Mobile Web Tools"); BackTagline=$SeriesTagline },
        @{ Id="4"; ShortName="EmeraldAcademic"; KindleFile="Kindle_Cover_Design_4_EmeraldAcademic.jpg"; BgColor="#052E16"; SpineColor="#15803D"; GoldColor="#F59E0B"; AccentColor="#22C55E"; BackTextColor="#FFFFFF"; BackTitle=$BookBackTitle; BackBody=@("Full College Board CED Alignment","Hands-On Guided Drill Problems","TI-84 Plus Numerical Calculus","FRQ Response Scoring Rubrics","Taylor Series & Polar Curves","Free QR Code Practice Portal"); BackTagline=$SeriesTagline },
        @{ Id="5"; ShortName="SapphireMinimalist"; KindleFile="Kindle_Cover_Design_5_SapphireMinimalist.jpg"; BgColor="#03254C"; SpineColor="#0284C7"; GoldColor="#F59E0B"; AccentColor="#38BDF8"; BackTextColor="#FFFFFF"; BackTitle=$BookBackTitle; BackBody=@("Zero-Bloat Calculus Curriculum","Rigorous Step-by-Step Drills","TI-84 and TI-Nspire Solvers","Rubric-Perfect FRQ Frames","Differential Equations Playbook","Scan-and-Study Mobile Flashcards"); BackTagline=$SeriesTagline }
    )

    $DPI = 300
    $SPINE_W_IN = $PageCount * 0.002252
    $PB_W_IN = 0.125 + 6.0 + $SPINE_W_IN + 6.0 + 0.125
    $PB_H_IN = 9.250
    $HC_W_IN = 0.59 + 0.125 + 6.0 + $SPINE_W_IN + 6.0 + 0.125 + 0.59
    $HC_H_IN = 10.180

    $PB_W = [int]($PB_W_IN * $DPI); $PB_H = [int]($PB_H_IN * $DPI)
    $HC_W = [int]($HC_W_IN * $DPI); $HC_H = [int]($HC_H_IN * $DPI)
    $PB_SPINE_PX = [int]($SPINE_W_IN * $DPI)

    $PB_BACK_END = [int]((0.125 + 6.0) * $DPI); $PB_FRONT_START = $PB_BACK_END + $PB_SPINE_PX
    $HC_BACK_END = [int]((0.59 + 0.125 + 6.0) * $DPI); $HC_FRONT_START = $HC_BACK_END + $PB_SPINE_PX
    $PB_BACK_MAX_X = $PB_BACK_END - 250; $HC_BACK_MAX_X = $HC_BACK_END - 250

    foreach ($d in $designs) {
        $kp = Join-Path $outputDir $d.KindleFile
        if (!(Test-Path $kp)) { continue }

        # Paperback
        $bmp = New-Object System.Drawing.Bitmap($PB_W, $PB_H); $bmp.SetResolution(300, 300)
        $g = [System.Drawing.Graphics]::FromImage($bmp)
        $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
        $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
        $cBg = [System.Drawing.ColorTranslator]::FromHtml($d.BgColor)
        $cSp = [System.Drawing.ColorTranslator]::FromHtml($d.SpineColor)
        $cGo = [System.Drawing.ColorTranslator]::FromHtml($d.GoldColor)
        $cAc = [System.Drawing.ColorTranslator]::FromHtml($d.AccentColor)
        $cTx = [System.Drawing.ColorTranslator]::FromHtml($d.BackTextColor)

        $g.FillRectangle((New-Object System.Drawing.SolidBrush($cBg)), 0, 0, $PB_W, $PB_H)
        $g.FillRectangle((New-Object System.Drawing.SolidBrush($cSp)), $PB_BACK_END, 0, $PB_SPINE_PX, $PB_H)

        $sc = $PB_BACK_END + [int]($PB_SPINE_PX / 2)
        $fSp = New-Object System.Drawing.Font("Arial", 18, [System.Drawing.FontStyle]::Bold)
        $sfC = New-Object System.Drawing.StringFormat; $sfC.Alignment = [System.Drawing.StringAlignment]::Center; $sfC.LineAlignment = [System.Drawing.StringAlignment]::Center
        $g.TranslateTransform($sc, [int]($PB_H / 2)); $g.RotateTransform(90)
        $g.DrawString($SpineTitle, $fSp, (New-Object System.Drawing.SolidBrush($cGo)), 0, 0, $sfC)
        $g.RotateTransform(-90); $g.TranslateTransform(-$sc, -[int]($PB_H / 2))

        # Front Face
        $fi = [System.Drawing.Image]::FromFile($kp)
        $g.DrawImage($fi, (New-Object System.Drawing.Rectangle($PB_FRONT_START, 0, ($PB_W - $PB_FRONT_START), $PB_H)))
        $fi.Dispose()

        # Back Face (Safe Zone bX=140 to BMX)
        $bX = 140; $bY = 110; $bW = $PB_BACK_MAX_X - $bX
        $g.FillRectangle((New-Object System.Drawing.SolidBrush($cAc)), $bX, $bY, $bW, 8)
        $fBT = New-Object System.Drawing.Font("Arial", 26, [System.Drawing.FontStyle]::Bold)
        $sfL = New-Object System.Drawing.StringFormat; $sfL.Alignment = [System.Drawing.StringAlignment]::Near
        $g.DrawString($d.BackTitle, $fBT, (New-Object System.Drawing.SolidBrush($cGo)), (New-Object System.Drawing.RectangleF($bX, ($bY + 25), $bW, 110)), $sfL)

        $fBo = New-Object System.Drawing.Font("Arial", 18, [System.Drawing.FontStyle]::Regular)
        $bBo = New-Object System.Drawing.SolidBrush($cTx)
        $tY = $bY + 155
        foreach ($ln in $d.BackBody) {
            $g.DrawString("* $ln", $fBo, $bBo, (New-Object System.Drawing.RectangleF($bX, $tY, $bW, 55)), $sfL)
            $tY += 58
        }

        # Barcode Box
        $bzY = $PB_H - 330; $bzX = $bX + 40
        $g.FillRectangle((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)), (New-Object System.Drawing.Rectangle($bzX, $bzY, 280, 200)))

        # Tagline & Disclaimer
        $btY = $PB_H - 110
        $g.FillRectangle((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(150, $cAc))), $bX, $btY, $bW, 4)
        $fTg = New-Object System.Drawing.Font("Arial", 16, [System.Drawing.FontStyle]::Italic)
        $g.DrawString($d.BackTagline, $fTg, (New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml("#CBD5E1"))), (New-Object System.Drawing.RectangleF($bX, ($btY + 8), $bW, 45)), $sfL)

        $fDis = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Regular)
        $g.DrawString("*AP(R) is a registered trademark of the College Board, which was not involved in the production of, and does not endorse, this product.", $fDis, (New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml("#64748B"))), (New-Object System.Drawing.RectangleF($bX, ($PB_H - 58), $bW, 52)), $sfL)

        $jpgPath = Join-Path $outputDir "Paperback_Cover_Design_$($d.Id)_$($d.ShortName)_FullWrap.jpg"
        $pdfPath = Join-Path $outputDir "Paperback_Cover_Design_$($d.Id)_$($d.ShortName)_FullWrap.pdf"
        $enc = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }
        $ep = New-Object System.Drawing.Imaging.EncoderParameters(1)
        $ep.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [long]95)
        $bmp.Save($jpgPath, $enc, $ep)
        Convert-JpgToPdf -JpgPath $jpgPath -PdfPath $pdfPath -WidthInches $PB_W_IN -HeightInches $PB_H_IN
        $g.Dispose(); $bmp.Dispose()

        # Hardcover
        $bmpH = New-Object System.Drawing.Bitmap($HC_W, $HC_H); $bmpH.SetResolution(300, 300)
        $gH = [System.Drawing.Graphics]::FromImage($bmpH)
        $gH.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
        $gH.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
        $gH.FillRectangle((New-Object System.Drawing.SolidBrush($cBg)), 0, 0, $HC_W, $HC_H)
        $gH.FillRectangle((New-Object System.Drawing.SolidBrush($cSp)), $HC_BACK_END, 0, $PB_SPINE_PX, $HC_H)

        $scH = $HC_BACK_END + [int]($PB_SPINE_PX / 2)
        $gH.TranslateTransform($scH, [int]($HC_H / 2)); $gH.RotateTransform(90)
        $gH.DrawString($SpineTitle, $fSp, (New-Object System.Drawing.SolidBrush($cGo)), 0, 0, $sfC)
        $gH.RotateTransform(-90); $gH.TranslateTransform(-$scH, -[int]($HC_H / 2))

        $fiH = [System.Drawing.Image]::FromFile($kp)
        $gH.DrawImage($fiH, (New-Object System.Drawing.Rectangle($HC_FRONT_START, 0, ($HC_W - $HC_FRONT_START), $HC_H)))
        $fiH.Dispose()

        $bWH = $HC_BACK_MAX_X - $bX
        $gH.FillRectangle((New-Object System.Drawing.SolidBrush($cAc)), $bX, $bY, $bWH, 8)
        $gH.DrawString($d.BackTitle, $fBT, (New-Object System.Drawing.SolidBrush($cGo)), (New-Object System.Drawing.RectangleF($bX, ($bY + 25), $bWH, 110)), $sfL)

        $tYH = $bY + 155
        foreach ($ln in $d.BackBody) {
            $gH.DrawString("* $ln", $fBo, $bBo, (New-Object System.Drawing.RectangleF($bX, $tYH, $bWH, 55)), $sfL)
            $tYH += 58
        }
        $bzYH = $HC_H - 330
        $gH.FillRectangle((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)), (New-Object System.Drawing.Rectangle($bzX, $bzYH, 280, 200)))
        $btYH = $HC_H - 110
        $gH.FillRectangle((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(150, $cAc))), $bX, $btYH, $bWH, 4)
        $gH.DrawString($d.BackTagline, $fTg, (New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml("#CBD5E1"))), (New-Object System.Drawing.RectangleF($bX, ($btYH + 8), $bWH, 45)), $sfL)
        $gH.DrawString("*AP(R) is a registered trademark of the College Board, which was not involved in the production of, and does not endorse, this product.", $fDis, (New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml("#64748B"))), (New-Object System.Drawing.RectangleF($bX, ($HC_H - 58), $bWH, 52)), $sfL)

        $hJpgPath = Join-Path $outputDir "Hardcover_Cover_Design_$($d.Id)_$($d.ShortName)_CaseLaminate.jpg"
        $hPdfPath = Join-Path $outputDir "Hardcover_Cover_Design_$($d.Id)_$($d.ShortName)_CaseLaminate.pdf"
        $bmpH.Save($hJpgPath, $enc, $ep)
        Convert-JpgToPdf -JpgPath $hJpgPath -PdfPath $hPdfPath -WidthInches $HC_W_IN -HeightInches $HC_H_IN
        $gH.Dispose(); $bmpH.Dispose()
    }
}

Write-Host "Building Book 1 Full-Wrap Covers..." -ForegroundColor Cyan
Generate-Book-Covers -TargetDir "d:\Narayana kdp\With 2.o\Book_1_AP_Calculus_Formula_Guide" -SpineTitle "AP CALCULUS FORMULA & THEOREM QUICK STUDY GUIDE 2027" -PageCount 310 -SeriesTagline "AP Calculus Master Review Series | Book 1 of 3" -BookBackTitle "High-Yield Calculus Formulas & Theorems"

Write-Host "Building Book 3 Full-Wrap Covers..." -ForegroundColor Cyan
Generate-Book-Covers -TargetDir "d:\Narayana kdp\With 2.o\Book_3_AP_Calculus_Practice_Exams" -SpineTitle "AP CALCULUS: 10 FULL-LENGTH PRACTICE EXAMS 2027" -PageCount 350 -SeriesTagline "AP Calculus Master Review Series | Book 3 of 3" -BookBackTitle "10 Full-Length Exams & Scoring Playbook"

Write-Host "All Full-Wrap covers built successfully for Book 1 and Book 3!" -ForegroundColor Green