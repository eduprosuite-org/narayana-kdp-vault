Add-Type -AssemblyName System.Drawing

$outputDir = "d:\Narayana kdp\With 2.o\Book_AP_Calculus_Prep_2027\Cover_Output_Files"
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
    @{ Id="1"; ShortName="SkyBlue"; KindleFile="Kindle_Cover_Design_1_SkyBlue.jpg"; BgColor="#0A2447"; SpineColor="#0284C7"; GoldColor="#F59E0B"; AccentColor="#38BDF8"; BackTextColor="#FFFFFF"; BackTitle="Master AP Calculus AB & BC"; BackBody=@("10-Unit College Board Curriculum","250+ Guided Calculus Workbooks","TI-84 & TI-Nspire Keystrokes","FRQ Justification Sentence Frames","Top 30 Exam Trap Pitfalls","Free Online Companion Web Portal"); BackTagline="AP Calculus Master Review Series | Book 2 of 3" },
    @{ Id="2"; ShortName="RoyalGold"; KindleFile="Kindle_Cover_Design_2_RoyalGold.jpg"; BgColor="#0D1B2A"; SpineColor="#1A3A6B"; GoldColor="#D4AF37"; AccentColor="#F59E0B"; BackTextColor="#FFFFFF"; BackTitle="Conquer AP Calculus 2027"; BackBody=@("Full AB & BC Unit Coverage","250+ Practice Drill Problems","Calculator Keystroke Playbooks","Score-5 FRQ Justification Rules","Existence Theorems (IVT, MVT, FTC)","Free Digital Theorem Cheat Sheets"); BackTagline="AP Calculus Master Review Series | Book 2 of 3" },
    @{ Id="3"; ShortName="TechBlueprint"; KindleFile="Kindle_Cover_Design_3_TechBlueprint.jpg"; BgColor="#050D1A"; SpineColor="#0284C7"; GoldColor="#38BDF8"; AccentColor="#00D4FF"; BackTextColor="#FFFFFF"; BackTitle="Precision Calculus Mastery"; BackBody=@("10-Unit Complete Syllabus","250+ Practice Problems & Keys","Graphing Calculator Shortcuts","MVT and FTC FRQ Frameworks","Solids of Revolution Drills","Interactive Mobile Web Tools"); BackTagline="AP Calculus Master Review Series | Book 2 of 3" },
    @{ Id="4"; ShortName="EmeraldAcademic"; KindleFile="Kindle_Cover_Design_4_EmeraldAcademic.jpg"; BgColor="#052E16"; SpineColor="#15803D"; GoldColor="#F59E0B"; AccentColor="#22C55E"; BackTextColor="#FFFFFF"; BackTitle="The Academic Gold Standard"; BackBody=@("All 10 College Board CED Units","250+ Hands-On Drill Problems","TI-84 Plus Numerical Calculus","FRQ Response Scoring Rubrics","Taylor Series & Polar Curves","Free QR Code Practice Portal"); BackTagline="AP Calculus Master Review Series | Book 2 of 3" },
    @{ Id="5"; ShortName="SapphireMinimalist"; KindleFile="Kindle_Cover_Design_5_SapphireMinimalist.jpg"; BgColor="#03254C"; SpineColor="#0284C7"; GoldColor="#F59E0B"; AccentColor="#38BDF8"; BackTextColor="#FFFFFF"; BackTitle="Clarity. Rigor. Score 5."; BackBody=@("Zero-Bloat Calculus Curriculum","250+ Rigorous Step Drills","TI-84 and TI-Nspire Solvers","Rubric-Perfect FRQ Frames","Differential Equations Playbook","Scan-and-Study Mobile Flashcards"); BackTagline="AP Calculus Master Review Series | Book 2 of 3" }
)

$PB_W_IN=12.9256; $PB_H_IN=9.250; $HC_W_IN=13.8556; $HC_H_IN=10.180; $DPI=300
$PB_W=[int]($PB_W_IN*$DPI); $PB_H=[int]($PB_H_IN*$DPI)
$HC_W=[int]($HC_W_IN*$DPI); $HC_H=[int]($HC_H_IN*$DPI)
$SPINE_W_IN=300*0.002252; $PB_SPINE_PX=[int]($SPINE_W_IN*$DPI)
$PB_BACK_END=[int]((0.125+6.0)*$DPI); $PB_FRONT_START=$PB_BACK_END+$PB_SPINE_PX
$HC_BACK_END=[int]((0.59+0.125+6.0)*$DPI); $HC_FRONT_START=$HC_BACK_END+$PB_SPINE_PX
$PB_BACK_MAX_X=$PB_BACK_END-250; $HC_BACK_MAX_X=$HC_BACK_END-250

function Build-Cover {
    param($D,$TW,$TH,$SS,$SW,$FS,$BMX,$TL,$PW,$PH,$KP)
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
    
    # Spine
    $g.FillRectangle((New-Object System.Drawing.SolidBrush($cSp)),$SS,0,$SW,$TH)
    $sc=$SS+[int]($SW/2)
    $fSp=New-Object System.Drawing.Font("Arial",20,[System.Drawing.FontStyle]::Bold)
    $sfC=New-Object System.Drawing.StringFormat; $sfC.Alignment=[System.Drawing.StringAlignment]::Center; $sfC.LineAlignment=[System.Drawing.StringAlignment]::Center
    $g.TranslateTransform($sc,[int]($TH/2)); $g.RotateTransform(90)
    $g.DrawString("AP CALCULUS AB & BC PREP BOOK 2027",$fSp,(New-Object System.Drawing.SolidBrush($cGo)),0,0,$sfC)
    $g.RotateTransform(-90); $g.TranslateTransform(-$sc,-[int]($TH/2))
    
    # Front face - AI image
    $fR=New-Object System.Drawing.Rectangle($FS,0,($TW-$FS),$TH)
    if(Test-Path $KP){$fi=[System.Drawing.Image]::FromFile($KP);$g.DrawImage($fi,$fR);$fi.Dispose()}
    
    # BACK COVER - strictly within bX=140 to BMX (minimum 250px barrier)
    $bX=140; $bY=110; $bW=$BMX-$bX
    $g.FillRectangle((New-Object System.Drawing.SolidBrush($cAc)),$bX,$bY,$bW,8)
    
    $fBT=New-Object System.Drawing.Font("Arial",28,[System.Drawing.FontStyle]::Bold)
    $sfL=New-Object System.Drawing.StringFormat; $sfL.Alignment=[System.Drawing.StringAlignment]::Near
    $g.DrawString($D.BackTitle,$fBT,(New-Object System.Drawing.SolidBrush($cGo)),(New-Object System.Drawing.RectangleF($bX,($bY+25),$bW,120)),$sfL)
    
    $fBo=New-Object System.Drawing.Font("Arial",19,[System.Drawing.FontStyle]::Regular)
    $bBo=New-Object System.Drawing.SolidBrush($cTx)
    $tY=$bY+165
    foreach($ln in $D.BackBody){
        $g.DrawString("* $ln",$fBo,$bBo,(New-Object System.Drawing.RectangleF($bX,$tY,$bW,58)),$sfL)
        $tY+=60
    }
    
    # Barcode placeholder
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
    Write-Host "  [SAVED] $jpgN + PDF" -ForegroundColor Cyan
}

foreach($d in $designs){
    $kp=Join-Path $outputDir $d.KindleFile
    Write-Host "Processing Design $($d.Id): $($d.ShortName)..." -ForegroundColor Magenta
    Build-Cover $d $PB_W $PB_H $PB_BACK_END $PB_SPINE_PX $PB_FRONT_START $PB_BACK_MAX_X "Paperback" $PB_W_IN $PB_H_IN $kp
    Build-Cover $d $HC_W $HC_H $HC_BACK_END $PB_SPINE_PX $HC_FRONT_START $HC_BACK_MAX_X "Hardcover" $HC_W_IN $HC_H_IN $kp
}

Write-Host "`nAll 20 Full-Wrap Cover files (10 JPG + 10 PDF) generated successfully!" -ForegroundColor Green