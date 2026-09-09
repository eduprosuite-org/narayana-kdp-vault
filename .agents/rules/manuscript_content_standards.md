# Manuscript Content Standards — AP Statistics Master Review Series
# Auto-loaded rule file for all sessions and all books.

---

## Rule M1: Page Count Target (MANDATORY)
- Every book manuscript MUST be 300 to 350 pages in Overleaf/PDF output.
- NEVER submit a skeleton/outline-only LaTeX file -- always write FULL content.
- Page count is measured at 12pt font, standard KDP 6x9 trim size.

---

## Rule M2: LaTeX Document Setup (MANDATORY for every book)
Use geometry package: paperwidth=6in, paperheight=9in, top=0.75in, bottom=0.75in, inner=0.875in, outer=0.625in
Use packages: amsmath, amssymb, amsthm, booktabs, longtable, graphicx, xcolor, tcolorbox, enumitem, hyperref, fancyhdr

---

## Rule M3: Mandatory Content Per Unit (9 Units x ~30 pages = 270+ pages)

Each of the 9 AP Statistics units MUST contain ALL sections:

Section A -- Unit Overview (1-2 pages):
- Unit title, AP exam weight percentage
- Key vocabulary list (10-15 terms with definitions)
- "What you will learn" bullet list

Section B -- Core Concept Lessons (10-12 pages):
- MINIMUM 4 full concept explanations per unit
- Each concept: Definition > Formula > Plain-English explanation > Visual description
- All formulas in LaTeX math environments
- Real-world context paragraph for each concept

Section C -- Worked Examples (6-8 pages):
- MINIMUM 4 fully solved examples per unit
- Format: Problem statement > Step-by-step solution > Final answer boxed
- Mix of multiple choice style and free response style

Section D -- TI-84 CE Keystroke Playbook (2-3 pages):
- MINIMUM 3 TI-84 procedures per unit
- Format: [2nd]->[VARS]->normalcdf( style keystroke notation
- Screenshot description of expected calculator output

Section E -- Score-4 FRQ Templates (3-4 pages):
- MINIMUM 2 FRQ template problems per unit
- Grader rubric checklist (what earns each point)
- Fill-in-the-blank answer structure

Section F -- Practice Problem Set (6-8 pages):
- MINIMUM 15 practice problems per unit
- Mix: 10 multiple choice + 5 free response
- All answers with full worked solutions at end of unit

Section G -- Unit Summary and Quick Review (1-2 pages):
- Formula reference box
- Key takeaways bullet list
- "Common mistakes to avoid" box

---

## Rule M4: Book-Level Required Sections (30-50 additional pages)

Front Matter: 5 pages -- Title page, Copyright/AP Disclaimer, Dedication, How to Use, Series Overview
Introduction: 3 pages -- AP Exam format, scoring, 5-point strategy
Practice Exam 1: 8 pages -- 40 MC + 6 FRQ (full AP format)
Practice Exam 2: 8 pages -- 40 MC + 6 FRQ (full AP format)
Answer Keys: 6 pages -- Both exams fully worked solutions
Formula Reference Sheet: 2 pages -- All AP Statistics formulas
TI-84 Master Reference: 3 pages -- All calculator functions
Glossary: 4 pages -- All 100+ vocabulary terms alphabetical
Web Portal QR Page: 1 page -- QR code + URL for free digital companion

---

## Rule M5: Writing Quality Standards
1. Active voice only
2. Student-friendly language (explain as if teaching a 10th grader)
3. No filler content -- every sentence must add value
4. Consistent AP College Board official terminology only
5. Every formula must be in LaTeX math mode -- NEVER plain text
6. Every example must have a real-world context

---

## Rule M6: Manuscript Generation Workflow in Step 4A
1. Write Front Matter first
2. Write Unit 1 through Unit 9 -- ALL sections A through G per unit
3. Write Practice Exam 1 and 2 -- full AP format
4. Write Answer Keys -- fully worked solutions
5. Write Reference sections -- formula sheet, glossary, TI-84 reference
6. Verify page count is 300-350 before GitHub push
7. If under 300 pages -- expand examples and practice problems

---

## Rule M7: NEVER Do This
- NEVER submit only section headings
- NEVER leave TODO placeholders
- NEVER write less than 30 pages per unit
- NEVER skip Practice Exams
- NEVER push without checking page count
