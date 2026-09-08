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

## 🔄 Standard 4-Step Publishing Workflow
- **STEP 1:** Amazon Real-Time Search Demand Telemetry (Harvest queries via Amazon Completion API).
- **STEP 2:** Series Architecture & Master Roadmap Catalog.
- **STEP 3:** SEO Metadata Package (Title, Subtitle, 7 50-byte safe Keywords, 3 Categories, HTML Description, Detailed 9-Unit TOC).
- **STEP 4:** High-Yield Production Suite (LaTeX Interior Manuscript, 5-Design 3D Zero-Bleed Cover Suite, 3D A+ Content Launch Kit, and GitHub Sync).
