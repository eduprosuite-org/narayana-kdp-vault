# =========================================================================
# BOOK 3 COVER ENGINE v2.0 -- 720 PAGES ZERO-BLEED SAFE ZONE COMPOSITE
# Title: AP Statistics Practice Companion 2027
# Subtitle: An Unofficial Companion to The Practice of Statistics for the AP Course
# Page Count: 720 (White Paper) | Spine = 720 * 0.002252 = 1.6214 in
# Rule: Back cover text strictly within safe zone (clears 250px barrier)
# =========================================================================

Add-Type -AssemblyName System.Drawing

$outputDir = "d:\Narayana kdp\With 2.o\Book_3_AP_Statistics_Practice_Companion_2027\Cover_Output_Files"
if (!(Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir -Force | Out-Null }

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

$designs = @(
    @{ Id="1"; ShortName="SkyBlue_White"; KindleFile="Kindle_Cover_Design_1_SkyBlue_White.jpg"; BgColor="#0A2447"; SpineColor="#0284C7"; GoldColor="#F59E0B"; AccentColor="#38BDF8"; BackTextColor="#FFFFFF"; BackTitle="The Master AP Statistics Companion"; BackBody=@("* 9-Unit Curriculum: Fully Aligned", "* 600+ Graded Practice Problems", "* Step-by-Step TI-84 CE Playbooks", "* Score-4 FRQ 4-Step Blueprints", "* 2 Full-Length 2027 Model Exams", "* Complete Detailed Answer Keys"); BackTagline="AP Statistics Master Review Series | Book 3" },
    @{ Id="2"; ShortName="RoyalBlue_Gold"; KindleFile="Kindle_Cover_Design_2_RoyalBlue_Gold.jpg"; BgColor="#0D1B2A"; SpineColor="#1A3A6B"; GoldColor="#D4AF37"; AccentColor="#F59E0B"; BackTextColor="#FFFFFF"; BackTitle="Master Practice of Statistics"; BackBody=@("* Full 9-Unit College Board Scope", "* 600+ Practice MCQs and FRQs", "* Comprehensive TI-84 Keystroke Labs", "* Standard 4-Step Inference Protocol", "* 2 Diagnostic Simulation Exams", "* Step-by-Step Scoring Explanations"); BackTagline="AP Statistics Master Review Series | Book 3" },
    @{ Id="3"; ShortName="TechBlueprint"; KindleFile="Kindle_Cover_Design_3_TechBlueprint.jpg"; BgColor="#050D1A"; SpineColor="#0284C7"; GoldColor="#38BDF8"; AccentColor="#00D4FF"; BackTextColor="#FFFFFF"; BackTitle="Data-Driven Statistics Mastery"; BackBody=@("* 9-Unit Course Curriculum Companion", "* 600+ Conceptual & Exam Problems", "* TI-84 Plus CE Exact Command Maps", "* Score-4 FRQ Hypothesis Frameworks", "* 2 Full 2027 Mock Bluebook Tests", "* In-Depth Diagnostic Solutions"); BackTagline="AP Statistics Master Review Series | Book 3" },
    @{ Id="4"; ShortName="EmeraldAcademic"; KindleFile="Kindle_Cover_Design_4_EmeraldAcademic.jpg"; BgColor="#052E16"; SpineColor="#15803D"; GoldColor="#F59E0B"; AccentColor="#22C55E"; BackTextColor="#FFFFFF"; BackTitle="The Academic Practice Standard"; BackBody=@("* 9-Unit Textbook Aligned Topics", "* 600+ Exam-Ready Practice Drills", "* Visual TI-84 Calculator Guides", "* Proven 4-Step Inference Writing", "* 2 Full Diagnostic AP Model Exams", "* Complete Rigorous Explanations"); BackTagline="AP Statistics Master Review Series | Book 3" },
    @{ Id="5"; ShortName="SapphireMinimalist"; KindleFile="Kindle_Cover_Design_5_SapphireMinimalist.jpg"; BgColor="#03254C"; SpineColor="#0284C7"; GoldColor="#F59E0B"; AccentColor="#38BDF8"; BackTextColor="#FFFFFF"; BackTitle="Precision Statistics Companion"; BackBody=@("* Complete 9-Unit Topic Review", "* 600+ Targeted Multi-Tier Problems", "* Step-by-Step TI-84 CE Syntax", "* State-Plan-Do-Conclude Templates", "* 2 Full Mock AP Statistics Exams", "* Step-by-Step Model Solutions"); BackTagline="AP Statistics Master Review Series | Book 3" }
)

# 720 pages: Spine = 720 * 0.002252 = 1.6214 in
$SPINE_W_IN = [Math]::Round(720 * 0.002252, 4) # 1.6214 in
$DPI = 300

# Paperback: Trim 6.0 x 9.0 in, Bleed 0.125 in each side
$PB_W_IN = [Math]::Round(0.125 + 6.0 + $SPINE_W_IN + 6.0 + 0.125, 4) # 13.8714 in
$PB_H_IN = 9.250
$PB_W = [int]($PB_W_IN * $DPI)
$PB_H = [int]($PB_H_IN * $DPI)
$PB_SPINE_PX = [int]($SPINE_W_IN * $DPI)
$PB_BACK_END = [int]((0.125 + 6.0) * $DPI)
$PB_FRONT_START = $PB_BACK_END + $PB_SPINE_PX
$PB_BACK_MAX_X = $PB_BACK_END - 250

# Hardcover: Trim 6.0 x 9.0 in, Wrap 0.59 in, Bleed 0.125 in, Hinge ~0.06 in
$HC_W_IN = [Math]::Round(0.59 + 0.125 + 6.0 + $SPINE_W_IN + 6.0 + 0.125 + 0.59, 4) # 14.8014 in
$HC_H_IN = 10.180
$HC_W = [int]($HC_W_IN * $DPI)
$HC_H = [int]($HC_H_IN * $DPI)
$HC_BACK_END = [int]((0.59 + 0.125 + 6.0) * $DPI)
$HC_FRONT_START = $HC_BACK_END + $PB_SPINE_PX
$HC_BACK_MAX_X = $HC_BACK_END - 250

Write-Host "=== BOOK 3 COVER ENGINE (720 PAGES) ===" -ForegroundColor Cyan
Write-Host "Paperback: ${PB_W}x${PB_H}px | Spine: ${PB_SPINE_PX}px | SpineStart: $PB_BACK_END | BackSafeMax: $PB_BACK_MAX_X" -ForegroundColor Yellow
Write-Host "Hardcover: ${HC_W}x${HC_H}px | Spine: ${PB_SPINE_PX}px | SpineStart: $HC_BACK_END | BackSafeMax: $HC_BACK_MAX_X" -ForegroundColor Yellow

function Build-Cover {
    param([hashtable]$D,[int]$TW,[int]$TH,[int]$SS,[int]$SW,[int]$FS,[int]$BMX,[string]$TL,[double]$PW,[double]$PH,[string]$KP)
    $bmp = New-Object System.Drawing.Bitmap($TW, $TH)
    $bmp.SetResolution(300, 300)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

    $cBg = [System.Drawing.ColorTranslator]::FromHtml($D.BgColor)
    $cSp = [System.Drawing.ColorTranslator]::FromHtml($D.SpineColor)
    $cGo = [System.Drawing.ColorTranslator]::FromHtml($D.GoldColor)
    $cAc = [System.Drawing.ColorTranslator]::FromHtml($D.AccentColor)
    $cTx = [System.Drawing.ColorTranslator]::FromHtml($D.BackTextColor)

    # BG
    $g.FillRectangle((New-Object System.Drawing.SolidBrush($cBg)), 0, 0, $TW, $TH)

    # Back grid
    $pG = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(20, 255, 255, 255), 1)
    for ($x = 0; $x -lt $SS; $x += 80) { $g.DrawLine($pG, $x, 0, $x, $TH) }
    for ($y = 0; $y -lt $TH; $y += 80) { $g.DrawLine($pG, 0, $y, $SS, $y) }

    # Spine
    $g.FillRectangle((New-Object System.Drawing.SolidBrush($cSp)), $SS, 0, $SW, $TH)
    $sc = $SS + [int]($SW / 2)
    $fSp = New-Object System.Drawing.Font("Arial", 26, [System.Drawing.FontStyle]::Bold)
    $sfC = New-Object System.Drawing.StringFormat
    $sfC.Alignment = [System.Drawing.StringAlignment]::Center
    $sfC.LineAlignment = [System.Drawing.StringAlignment]::Center
    $g.TranslateTransform($sc, [int]($TH / 2))
    $g.RotateTransform(90)
    $g.DrawString("AP STATISTICS PRACTICE COMPANION 2027", $fSp, (New-Object System.Drawing.SolidBrush($cGo)), 0, 0, $sfC)
    $g.RotateTransform(-90)
    $g.TranslateTransform(-$sc, -[int]($TH / 2))

    # Front Face - AI JPG
    $fR = New-Object System.Drawing.Rectangle($FS, 0, ($TW - $FS), $TH)
    if (Test-Path $KP) {
        $fi = [System.Drawing.Image]::FromFile($KP)
        $g.DrawImage($fi, $fR)
        $fi.Dispose()
        Write-Host "  [OK] Front Loaded: $(Split-Path $KP -Leaf)" -ForegroundColor Green
    } else {
        $g.FillRectangle((New-Object System.Drawing.SolidBrush($cAc)), $fR)
        Write-Host "  [WARN] Missing Kindle File: $KP" -ForegroundColor Yellow
    }

    # BACK COVER CONTENT
    $bX = 140
    $bY = 160
    $bW = $BMX - $bX

    # Accent Strip
    $g.FillRectangle((New-Object System.Drawing.SolidBrush($cAc)), $bX, $bY, $bW, 8)

    # Title (Max 26px font)
    $fBT = New-Object System.Drawing.Font("Arial", 25, [System.Drawing.FontStyle]::Bold)
    $g.DrawString($D.BackTitle, $fBT, (New-Object System.Drawing.SolidBrush($cGo)), $bX, ($bY + 30))

    # Divider
    $g.FillRectangle((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(80, 255, 255, 255))), $bX, ($bY + 80), $bW, 2)

    # Bullet Points
    $fBB = New-Object System.Drawing.Font("Arial", 18, [System.Drawing.FontStyle]::Regular)
    $curY = $bY + 110
    foreach ($bullet in $D.BackBody) {
        $g.DrawString($bullet, $fBB, (New-Object System.Drawing.SolidBrush($cTx)), $bX, $curY)
        $curY += 60
    }

    # Bottom Tagline
    $g.FillRectangle((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(80, 255, 255, 255))), $bX, ($TH - 240), $bW, 2)
    $fTag = New-Object System.Drawing.Font("Arial", 16, [System.Drawing.FontStyle]::Italic)
    $g.DrawString($D.BackTagline, $fTag, (New-Object System.Drawing.SolidBrush($cAc)), $bX, ($TH - 210))

    # KDP Barcode Zone note (Bottom Left safe zone)
    $fNote = New-Object System.Drawing.Font("Arial", 11, [System.Drawing.FontStyle]::Regular)
    $g.DrawString("*AP is a registered trademark of College Board which does not endorse this work.", $fNote, (New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(180, 255, 255, 255))), $bX, ($TH - 150))

    # Save JPG
    $jpgOut = "$outputDir\${TL}_Cover_Design_$($D.Id)_$($D.ShortName).jpg"
    $bmp.Save($jpgOut, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    $bmp.Dispose(); $g.Dispose()

    # Convert to PDF
    $pdfOut = "$outputDir\${TL}_Cover_Design_$($D.Id)_$($D.ShortName).pdf"
    Convert-JpgToPdf -JpgPath $jpgOut -PdfPath $pdfOut -WidthInches $PW -HeightInches $PH
    Write-Host "  [DONE] ${TL} #$($D.Id) -> $(Split-Path $pdfOut -Leaf)" -ForegroundColor Cyan
}

foreach ($d in $designs) {
    $kp = "$outputDir\$($d.KindleFile)"
    Write-Host "Processing Design $($d.Id): $($d.ShortName)..." -ForegroundColor White
    Build-Cover -D $d -TW $PB_W -TH $PB_H -SS $PB_BACK_END -SW $PB_SPINE_PX -FS $PB_FRONT_START -BMX $PB_BACK_MAX_X -TL "Paperback" -PW $PB_W_IN -PH $PB_H_IN -KP $kp
    Build-Cover -D $d -TW $HC_W -TH $HC_H -SS $HC_BACK_END -SW $PB_SPINE_PX -FS $HC_FRONT_START -BMX $HC_BACK_MAX_X -TL "Hardcover" -PW $HC_W_IN -PH $HC_H_IN -KP $kp
}

Write-Host "=== ALL 20 FULL-WRAP COVERS SUCCESSFULLY COMPILED ===" -ForegroundColor Green
