# AP® Statistics Master Review Series — Global Publishing & Quality Rules (AGENTS.md)

This file contains the **permanent workspace guidelines** that are automatically loaded into Antigravity, Antigravity 2.0, and all 9 sub-agents across all sessions and new machine setups.

---

## 🏛️ Rule 1: Visual Quality & 3D Rendering Protocol (A+ Content & Covers)
1. **No Flat 2D Drawings:** All Amazon A+ Content graphics and Book Covers must use **photorealistic 3D perspectives, glassmorphic UI elements, lighting depth, and high-resolution textures**.
2. **Unified Brand Tokens:**
   - Primary Accent: Modern Sky Blue (`#0284C7` / `#38BDF8`)
   - Foundation Background: Deep Royal Slate Navy (`#0F172A` / `#0A0F1D`)
   - Academic Highlight: Warm Amber Gold (`#F59E0B` / `#FEF08A`)
   - Crisp Text: Academic White (`#FFFFFF`) / Muted Platinum (`#CBD5E1`)
3. **Zero-Confusion A+ Module Naming:**
   - `KDP_Module_1_Choose_Standard_Image_Header_with_Text_970x600.jpg`
   - `KDP_Module_2_Choose_Standard_Three_Image_and_Text_Card_1_300x300.jpg`
   - `KDP_Module_2_Choose_Standard_Three_Image_and_Text_Card_2_300x300.jpg`
   - `KDP_Module_2_Choose_Standard_Three_Image_and_Text_Card_3_300x300.jpg`
   - `KDP_Module_4_Choose_Standard_Single_Image_and_Sidebar_300x300.jpg`
   - `KDP_Alternative_Choose_Standard_Single_Image_and_Highlights_970x300.jpg`

---

## 📐 Rule 2: Zero-Bleed Safe Zone Geometry Protocol (Cover Engine)
1. **Spine Width Exact Formula:**
   $$\text{Spine Width (in)} = \text{Page Count} \times 0.002252\text{ (White Paper)}$$
2. **Strict Back Cover Bounding Box:**
   - Left Margin: Starts at $X = 140\text{ px}$ (clearing outer $0.125"$ bleed).
   - Right Barrier: **Must strictly stop at least $250\text{ px}$ before the spine starts** ($X_{\text{max}} = \text{spineStartPx} - 250\text{ px}$).
   - **Zero Bleed:** Back cover text must NEVER encroach upon the spine or bleed toward the front cover.
3. **Spine Centering:** Spine text must be mathematically centered on $\text{spineStartPx} + (\text{spineWidthPx} / 2)$.
4. **Front Cover Placement:** Front cover starts strictly at $\text{spineStartPx} + \text{spineWidthPx}$.

---

## ⚖️ Rule 3: Trademark & Nominative Fair Use Compliance
1. **Cover & Page 1 Only:** $\text{AP}^\circledR$ is allowed on the book cover and page 1 title block.
2. **Backend Keywords & KDP Title Fields:** Clean plain text only (`AP Statistics`, no special symbols $\circledR$).
3. **Mandatory Nominative Fair Use Disclaimer:**
   > "*AP® and Advanced Placement® are registered trademarks of the College Board, which was not involved in the production of, and does not endorse, this product."

---

## 🗣️ Rule 4: User Communication Language Mandate
- **All conversation responses, analyses, status updates, and instructions must be delivered in TELUGU (తెలుగు).**
- Technical code (LaTeX, HTML, PowerShell, JSON, Prompts) and KDP metadata slots remain in standard English.

---

## 🎨 Rule 5: Kindle Cover Generation — AI-Only Mandate (NEVER PowerShell)
> CRITICAL LESSON LEARNED from Book 2: Kindle front covers generated via PowerShell System.Drawing produced flat 2D gradient images with grid lines — NOT acceptable.

1. **Kindle Cover Tool:** ALWAYS use the `generate_image` tool (AI photorealistic art). NEVER use PowerShell `System.Drawing` to draw Kindle front covers.
2. **Aspect Ratio:** Always `2:3` for Kindle covers (portrait orientation).
3. **Required Prompt Elements for Every Kindle Cover:**
   - "Photorealistic 3D softcover/hardcover book mockup"
   - Book title prominently on cover
   - Statistics visual element (bell curve, scatter plot, histogram, formulas)
   - Brand color theme (Sky Blue / Royal Navy / Gold)
   - "professional KDP book cover quality, 3D perspective showing page thickness"
4. **5 Designs per book** — each must have a distinct color theme:
   - Design 1: Sky Blue + White
   - Design 2: Royal Blue + Gold
   - Design 3: Tech Blueprint (Dark Navy + Cyan Neon)
   - Design 4: Emerald Academic (Forest Green + Gold)
   - Design 5: Sapphire Minimalist (Deep Blue + White)
5. **Save path:** `[Book_Folder]\Cover_Output_Files\Kindle_Cover_Design_[N]_[ThemeName].jpg`

---

## 🖼️ Rule 6: Amazon A+ Content — AI generate_image Only (NEVER PowerShell Scripts)
> CRITICAL LESSON LEARNED from Book 2: A+ assets generated via PowerShell showed plain text boxes, garbled Unicode emoji artifacts, no 3D elements, no book mockup — completely unacceptable.

1. **A+ Tool:** ALWAYS use `generate_image` tool for ALL 6 A+ assets. NEVER use PowerShell `FillRectangle` + `DrawString` to create A+ content.
2. **Module 1 Hero Banner (970x600, aspect 16:9):** Must include:
   - Photorealistic 3D floating book mockup (center)
   - Realistic QR code image (left panel)
   - Smartphone app mockup (right panel)
   - Gold star badge "2027 EXAM READY BESTSELLER"
   - Bottom sky blue strip with alignment text
3. **Module 2 Cards x3 (300x300, aspect 1:1):** Each card = distinct feature:
   - Card 1: 9-Unit Curriculum (3D open textbook with holographic unit labels)
   - Card 2: Practice Workbooks (photorealistic student writing in workbook)
   - Card 3: TI-84 Calculator (photorealistic 3D calculator with glowing screen)
4. **Module 4 Sidebar (300x300, aspect 1:1):** Free web portal + QR code + smartphone mockup.
5. **Alternative Highlights Banner (970x300, aspect 16:9):** 5-column icon feature strip.
6. **Every A+ image must match Book 1 Gold Standard quality** — photorealistic, 3D, premium product photography aesthetic.

---

## 📦 Rule 7: Full-Wrap Paperback/Hardcover — Composite Workflow (NEVER Draw Front Programmatically)
> CRITICAL LESSON LEARNED from Book 2: The original script drew Kindle front cover programmatically inside the full-wrap builder — resulting in 2D flat front face. Back cover content also bled past spine into front cover zone.

1. **Workflow Order (MANDATORY):**
   - FIRST: Generate all 5 Kindle covers using `generate_image` (Rule 5).
   - SECOND: Copy AI-generated Kindle JPGs to `Cover_Output_Files\` folder.
   - THIRD: Build full-wrap covers by LOADING the AI Kindle JPG as front face via `System.Drawing.Image.FromFile()` and compositing onto canvas.
2. **Full-Wrap Canvas = Back Cover + Spine + Front Cover (left to right).**
3. **Front Face:** `DrawImage(kindleImage, frontRect)` — stretch AI JPG into the front cover region. Never draw text/graphics programmatically on the front face.
4. **Back Cover Safe Zone (STRICT):**
   - `$spineStartPx = (bleedInches + backWidthInches) * DPI`
   - `$backMaxX = $spineStartPx - 250` (MINIMUM 250px barrier before spine)
   - `$bX = 140` (left start, clears 0.125" bleed)
   - `$safeWidth = $backMaxX - $bX` (all back text must fit within this)
5. **Back Cover Font Sizes:** Title max 28px, Body max 19px — prevents text truncation within safe zone.
6. **Back Cover Text Content Rules (STRICT — prevents clipping):**
   - **Title line:** MAX 30 characters — short punchy title only (e.g. "Master AP Statistics" NOT "The Complete AP Statistics Study Guide and Textbook")
   - **Bullet points:** MAX 6 bullets per cover. Each bullet MAX 40 characters including "* " prefix.
   - **Bullet format:** `* Feature: Short Value` — e.g. `* 9-Unit Curriculum: All Topics` NOT `* Complete 9-Unit High School AP Statistics Curriculum Fully Aligned`
   - **Bottom tagline:** MAX 45 characters — e.g. `AP Statistics Master Review Series | Book 2`
   - **NEVER use long sentences** on back cover — always short, punchy, scannable bullets only.
   - **Test before saving:** Use `$g.MeasureString(text, font).Width` to confirm text fits within `$safeWidth` before DrawString.
7. **PDF Output:** Use `Convert-JpgToPdf` function after each JPG save.
8. **Output per book:** 5 Kindle JPGs + 5 Paperback JPG+PDF + 5 Hardcover JPG+PDF = 25 files total.

---

## 🔄 Standard 4-Step Publishing Workflow
- **STEP 1:** Amazon Real-Time Search Demand Telemetry (Harvest queries via Amazon Completion API).
- **STEP 2:** Series Architecture & Master Roadmap Catalog.
- **STEP 3:** SEO Metadata Package (Title, Subtitle, 7 50-byte safe Keywords, 3 Categories, HTML Description, Detailed 9-Unit TOC).
- **STEP 4:** High-Yield Production Suite — broken into 4 mandatory sub-steps:
  - **STEP 4A — Full LaTeX Manuscript (MANDATORY 300-350 pages):**
    - Follow ALL rules in `.agents/rules/manuscript_content_standards.md`
    - 9 Units × ~30 pages each + Front Matter + 2 Practice Exams + Answer Keys + Glossary
    - NEVER submit skeleton/outline only — write complete content for every section
    - Verify page count ≥ 300 before proceeding to Step 4B
  - **STEP 4B — 5-Design 3D Cover Suite:** AI `generate_image` only (Rules 5 + 7). Never PowerShell.
  - **STEP 4C — 6 A+ Content Images:** AI `generate_image` only (Rule 6). Never PowerShell.
  - **STEP 4D — GitHub Sync:** Commit and push all files to `narayana-kdp-vault` main branch.

**Quick Prompt to trigger:** `Start Step 1 to 4 for [keyword]` — runs all steps automatically without interruption.
