# =========================================================================
# BOOK 2 COVER ENGINE v2.0 -- ZERO-BLEED SAFE ZONE + AI-GENERATED FRONT COVERS
# Title: AP Statistics Prep Book 2027
# Page Count: 300 (White Paper) | Spine = 300 * 0.002252 = 0.6756 in
# Rule: Back cover text MUST stop at (spineStartPx - 250px) minimum
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
    @{ Id="1"; ShortName="SkyBlue_White_2027_Ready"; KindleFile="Kindle_Cover_Design_1_SkyBlue_White_2027_Ready.jpg"; BgColor="#0A2447"; SpineColor="#0284C7"; GoldColor="#F59E0B"; AccentColor="#38BDF8"; BackTextColor="#FFFFFF"; BackTitle="The Complete AP Statistics Study System"; BackBody=@("Complete 9-Unit High School AP Statistics Curriculum","200+ Guided Practice Workbooks with Step-by-Step Solutions","TI-84 Plus CE Calculator Playbooks for Every Test Type","Score-4 FRQ Templates with Grader-Annotated Model Answers","2 Full-Length 2027 Practice Exams with Diagnostic Analysis","Free Digital Web Companion - Scan In-Book QR Code"); BackTagline="AP Statistics Master Review Series | Book 2 of 9" },
    @{ Id="2"; ShortName="RoyalBlue_Gold_2027_Ready"; KindleFile="Kindle_Cover_Design_2_RoyalBlue_Gold_2027_Ready.jpg"; BgColor="#0D1B2A"; SpineColor="#1A3A6B"; GoldColor="#D4AF37"; AccentColor="#F59E0B"; BackTextColor="#FFFFFF"; BackTitle="Master AP Statistics. Ace the Exam."; BackBody=@("9-Unit Complete Textbook: All College Board Topics Covered","Score-4 FRQ System: Fill-in-the-Blank Sentence Frames","TI-84 CE Playbooks: Exact Keystroke Sequences for Every Test","200+ Practice Problems with Model Rubric-Based Solutions","2 Full Practice Exams: Bluebook Format Simulation","Free Student Web Portal: Unit Quizzes and Formula Cards"); BackTagline="AP Statistics Master Review Series | Book 2 of 9" },
    @{ Id="3"; ShortName="TechBlueprint"; KindleFile="Kindle_Cover_Design_3_TechBlueprint.jpg"; BgColor="#050D1A"; SpineColor="#0284C7"; GoldColor="#38BDF8"; AccentColor="#00D4FF"; BackTextColor="#FFFFFF"; BackTitle="The Data-Driven AP Statistics Prep System"; BackBody=@("9-Unit Structured Curriculum: Aligned to 2026-2027 CED","200+ Workbooks: Unit Drills and Full FRQ Practice Sets","TI-84 CE Keystroke Playbooks: Calculator Confidence Fast","Score-4 FRQ Templates: Grader-Approved Response Structures","2 Full Practice Exams with Detailed Error Diagnostics","Web Portal: Interactive Stats Tools and Formula QR Codes"); BackTagline="AP Statistics Master Review Series | Book 2 of 9" },
    @{ Id="4"; ShortName="EmeraldAcademic"; KindleFile="Kindle_Cover_Design_4_EmeraldAcademic.jpg"; BgColor="#052E16"; SpineColor="#15803D"; GoldColor="#F59E0B"; AccentColor="#22C55E"; BackTextColor="#FFFFFF"; BackTitle="The Academic Standard for AP Statistics 2027"; BackBody=@("Full 9-Unit Course Coverage with Visual Learning Diagrams","200+ Practice Workbooks: Fill-in-the-Blank and FRQ Sets","TI-84 Plus CE Calculator Guides with Exact Key Sequences","Score-4 FRQ Templates for Free Response Mastery","2 Complete 2027 Practice Exams in Bluebook Style","Included Free Digital Study Portal with QR Scan Access"); BackTagline="AP Statistics Master Review Series | Book 2 of 9" },
    @{ Id="5"; ShortName="SapphireMinimalist"; KindleFile="Kindle_Cover_Design_5_SapphireMinimalist.jpg"; BgColor="#03254C"; SpineColor="#0284C7"; GoldColor="#F59E0B"; AccentColor="#38BDF8"; BackTextColor="#FFFFFF"; BackTitle="Precision. Clarity. Results."; BackBody=@("9-Unit AP Statistics Curriculum: Zero Academic Bloat","200+ Targeted Practice Workbooks with Model Solutions","Complete TI-84 Plus CE Calculator Keystroke Playbooks","Score-4 Free Response Templates: Grader-Tested Structures","2 Full-Length 2027 Exams: Bluebook Digital Format Replica","Free Digital Web Companion with QR Code Access"); BackTagline="AP Statistics Master Review Series | Book 2 of 9" }
)

$PB_W_IN=12.9256; $PB_H_IN=9.250; $HC_W_IN=13.8556; $HC_H_IN=10.180; $DPI=300
$PB_W=[int]($PB_W_IN*$DPI); $PB_H=[int]($PB_H_IN*$DPI)
$HC_W=[int]($HC_W_IN*$DPI); $HC_H=[int]($HC_H_IN*$DPI)
$SPINE_W_IN=300*0.002252; $PB_SPINE_PX=[int]($SPINE_W_IN*$DPI)
$PB_BACK_END=[int]((0.125+6.0)*$DPI); $PB_FRONT_START=$PB_BACK_END+$PB_SPINE_PX
$HC_BACK_END=[int]((0.59+0.125+6.0)*$DPI); $HC_FRONT_START=$HC_BACK_END+$PB_SPINE_PX
$PB_BACK_MAX_X=$PB_BACK_END-250; $HC_BACK_MAX_X=$HC_BACK_END-250

Write-Host "=== BOOK 2 COVER ENGINE v2.0 ===" -ForegroundColor Cyan
Write-Host "Paperback: ${PB_W}x${PB_H}px | SpineStart:$PB_BACK_END | FrontStart:$PB_FRONT_START | BackSafeMax:$PB_BACK_MAX_X" -ForegroundColor Yellow

function Build-Cover {
    param([hashtable]$D,[int]$TW,[int]$TH,[int]$SS,[int]$SW,[int]$FS,[int]$BMX,[string]$TL,[double]$PW,[double]$PH,[string]$KP)
    $bmp=New-Object System.Drawing.Bitmap($TW,$TH); $bmp.SetResolution(300,300)
    $g=[System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode=[System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint=[System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
    $g.InterpolationMode=[System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $cBg=[System.Drawing.ColorTranslator]::FromHtml($D.BgColor)
    $cSp=[System.Drawing.ColorTranslator]::FromHtml($D.SpineColor)
    $cGo=[System.Drawing.ColorTranslator]::FromHtml($D.GoldColor)
    $cAc=[System.Drawing.ColorTranslator]::FromHtml($D.AccentColor)
    $cTx=[System.Drawing.ColorTranslator]::FromHtml($D.BackTextColor)
    # BG
    $g.FillRectangle((New-Object System.Drawing.SolidBrush($cBg)),0,0,$TW,$TH)
    # Grid on back
    $pG=New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(18,255,255,255),1)
    for($x=0;$x-lt$SS;$x+=80){$g.DrawLine($pG,$x,0,$x,$TH)}
    for($y=0;$y-lt$TH;$y+=80){$g.DrawLine($pG,0,$y,$SS,$y)}
    # Spine
    $g.FillRectangle((New-Object System.Drawing.SolidBrush($cSp)),$SS,0,$SW,$TH)
    $sc=$SS+[int]($SW/2)
    $fSp=New-Object System.Drawing.Font("Arial",22,[System.Drawing.FontStyle]::Bold)
    $sfC=New-Object System.Drawing.StringFormat; $sfC.Alignment=[System.Drawing.StringAlignment]::Center; $sfC.LineAlignment=[System.Drawing.StringAlignment]::Center
    $g.TranslateTransform($sc,[int]($TH/2)); $g.RotateTransform(90)
    $g.DrawString("AP STATISTICS PREP BOOK 2027",$fSp,(New-Object System.Drawing.SolidBrush($cGo)),0,0,$sfC)
    $g.RotateTransform(-90); $g.TranslateTransform(-$sc,-[int]($TH/2))
    # Front face - AI image
    $fR=New-Object System.Drawing.Rectangle($FS,0,($TW-$FS),$TH)
    if(Test-Path $KP){$fi=[System.Drawing.Image]::FromFile($KP);$g.DrawImage($fi,$fR);$fi.Dispose();Write-Host "  [OK] Front loaded: $(Split-Path $KP -Leaf)" -ForegroundColor Green}
    else{$g.FillRectangle((New-Object System.Drawing.SolidBrush($cAc)),$fR);Write-Host "  [WARN] No Kindle file: $KP" -ForegroundColor Yellow}
    # BACK COVER - strictly within bX=140 to BMX
    $bX=140; $bY=110; $bW=$BMX-$bX
    # Top accent line
    $g.FillRectangle((New-Object System.Drawing.SolidBrush($cAc)),$bX,$bY,$bW,8)
    # Back title
    $fBT=New-Object System.Drawing.Font("Arial",28,[System.Drawing.FontStyle]::Bold)
    $sfL=New-Object System.Drawing.StringFormat; $sfL.Alignment=[System.Drawing.StringAlignment]::Near
    $g.DrawString($D.BackTitle,$fBT,(New-Object System.Drawing.SolidBrush($cGo)),(New-Object System.Drawing.RectangleF($bX,($bY+25),$bW,120)),$sfL)
    # Body lines
    $fBo=New-Object System.Drawing.Font("Arial",19,[System.Drawing.FontStyle]::Regular)
    $bBo=New-Object System.Drawing.SolidBrush($cTx)
    $tY=$bY+165
    foreach($ln in $D.BackBody){
        $g.DrawString("* $ln",$fBo,$bBo,(New-Object System.Drawing.RectangleF($bX,$tY,$bW,58)),$sfL)
        $tY+=60
    }
    # Barcode zone
    $bzY=$TH-330; $bzX=$bX+40
    $barcodeR=New-Object System.Drawing.Rectangle($bzX,$bzY,280,200)
    $g.FillRectangle((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)),$barcodeR)
    $fSm=New-Object System.Drawing.Font("Arial",14,[System.Drawing.FontStyle]::Regular)
    $sfCC=New-Object System.Drawing.StringFormat; $sfCC.Alignment=[System.Drawing.StringAlignment]::Center; $sfCC.LineAlignment=[System.Drawing.StringAlignment]::Center
    $g.DrawString("[ KDP BARCODE ]",$fSm,(New-Object System.Drawing.SolidBrush([System.Drawing.Color]::Black)),$barcodeR,$sfCC)
    # Bottom tagline
    $btY=$TH-110
    $g.FillRectangle((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(150,$cAc))),$bX,$btY,$bW,4)
    $fTg=New-Object System.Drawing.Font("Arial",18,[System.Drawing.FontStyle]::Italic)
    $g.DrawString($D.BackTagline,$fTg,(New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml("#CBD5E1"))),(New-Object System.Drawing.RectangleF($bX,($btY+8),$bW,50)),$sfL)
    # Disclaimer
    $fDis=New-Object System.Drawing.Font("Arial",11,[System.Drawing.FontStyle]::Regular)
    $g.DrawString("*AP(R) and Advanced Placement(R) are registered trademarks of the College Board, which was not involved in the production of, and does not endorse, this product.",$fDis,(New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml("#64748B"))),(New-Object System.Drawing.RectangleF($bX,($TH-58),$bW,52)),$sfL)
    # Save
    $id=$D.Id; $sn=$D.ShortName
    $sfx = if($TL -eq "Paperback"){"FullWrap"}else{"CaseLaminate"}
    $jpgN="${TL}_Cover_Design_${id}_${sn}_${sfx}.jpg"
    $pdfN="${TL}_Cover_Design_${id}_${sn}_${sfx}.pdf"
    $jp=Join-Path $outputDir $jpgN; $pp=Join-Path $outputDir $pdfN
    $enc=[System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders()|Where-Object{$_.MimeType -eq "image/jpeg"}
    $ep=New-Object System.Drawing.Imaging.EncoderParameters(1)
    $ep.Param[0]=New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality,[long]95)
    $bmp.Save($jp,$enc,$ep)
    Convert-JpgToPdf -JpgPath $jp -PdfPath $pp -WidthInches $PW -HeightInches $PH
    $g.Dispose(); $bmp.Dispose()
    Write-Host "  [SAVED] $jpgN" -ForegroundColor Cyan
    Write-Host "  [SAVED] $pdfN" -ForegroundColor Cyan
}

foreach($d in $designs){
    $kp=Join-Path $outputDir $d.KindleFile
    Write-Host "`n--- Design $($d.Id): $($d.ShortName) ---" -ForegroundColor Magenta
    Build-Cover -D $d -TW $PB_W -TH $PB_H -SS $PB_BACK_END -SW $PB_SPINE_PX -FS $PB_FRONT_START -BMX $PB_BACK_MAX_X -TL "Paperback" -PW $PB_W_IN -PH $PB_H_IN -KP $kp
    Build-Cover -D $d -TW $HC_W -TH $HC_H -SS $HC_BACK_END -SW $PB_SPINE_PX -FS $HC_FRONT_START -BMX $HC_BACK_MAX_X -TL "Hardcover" -PW $HC_W_IN -PH $HC_H_IN -KP $kp
}

Write-Host "`n=== ALL COVERS COMPLETE! ===" -ForegroundColor Green
Write-Host "Output: $outputDir" -ForegroundColor Yellow

