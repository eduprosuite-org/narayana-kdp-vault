# AP Statistics Score-5 Blueprint Series: GitHub Pages & KDP Companion

This repository contains the **Value-Added Interactive Student Companion Portal** and the complete **LaTeX & KDP Publishing Assets** for the *AP Statistics Score-5 Blueprint Series*.

---

## 📁 Repository Structure

```
.
├── index.html                   # Main Interactive Web Portal
├── styles.css                   # Responsive Modern UI & Dark Mode Styling
├── app.js                       # Formula Search, Inference Wizard, FRQ Builder, Quiz Engine
├── Volume_1_All_In_One_Manuscript.tex # Single-file Overleaf LaTeX ready to compile
├── Volume_1_KDP_Publishing_Package.md # Amazon HTML description, 7 backend keywords, A+ content
└── Volume_1_Formula_and_Cheat_Sheet/  # Modular LaTeX files
    ├── main.tex
    ├── metadata.tex
    ├── preamble.tex
    ├── frontmatter/
    └── chapters/
```

---

## 🚀 How to Deploy to GitHub Pages (1-Click Hosting)

1. Create a new GitHub repository named `ap-stats-score5-blueprint` (or any name you prefer).
2. Push all files from this folder to the repository:
   ```bash
   git init
   git add .
   git commit -m "Initial commit for AP Stats Companion Portal"
   git branch -M main
   git remote add origin https://github.com/<your-username>/ap-stats-score5-blueprint.git
   git push -u origin main
   ```
3. In your GitHub repository:
   - Go to **Settings** > **Pages** (left sidebar).
   - Under **Build and deployment > Source**, select **Deploy from a branch**.
   - Under **Branch**, select `main` and `/ (root)`, then click **Save**.
4. Your site will be live instantly at:
   `https://eduprosuite-org.github.io/ap-stats-score5-blueprint/`

---

## 🖨️ How to Compile the Manuscript in Overleaf

1. Go to [Overleaf.com](https://www.overleaf.com/) and create a **Blank Project**.
2. **Option A (Instant 1-file method):**  
   Copy the contents of `Volume_1_All_In_One_Manuscript.tex` and paste it into `main.tex` in Overleaf, then click **Recompile**.
3. **Option B (Modular folder method):**  
   Upload the entire `Volume_1_Formula_and_Cheat_Sheet` folder into your Overleaf project and set `main.tex` as the main document.
4. Download the compiled PDF and upload it to **Amazon KDP** as your 6x9 Print Paperback interior.

---

## 📈 Publishing on Amazon KDP

Open `Volume_1_KDP_Publishing_Package.md` to find:
- Pre-formatted Amazon HTML Book Description (Copy-paste ready).
- Exactly 7 Backend Search Keywords.
- Amazon Category Placements to target #1 Bestseller Rank.
- Full Amazon A+ Content graphics and text modules.

