import os

# Generate Vector Diagram 1: Process / Workflow Diagram
svg_workflow = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 250" width="100%" height="100%">
  <rect width="800" height="250" fill="#0f172a" rx="12"/>
  
  <!-- Step 1 -->
  <rect x="40" y="65" width="200" height="120" fill="#1e293b" stroke="#3b82f6" stroke-width="3" rx="8"/>
  <text x="140" y="105" fill="#60a5fa" font-family="Arial, sans-serif" font-size="16" font-weight="bold" text-anchor="middle">STEP 1: REVISE</text>
  <text x="140" y="135" fill="#ffffff" font-family="Arial, sans-serif" font-size="13" text-anchor="middle">Formula Cheat Sheets</text>
  <text x="140" y="155" fill="#ffffff" font-family="Arial, sans-serif" font-size="13" text-anchor="middle">&amp; Core Rules</text>

  <!-- Arrow 1 -->
  <path d="M 250 125 L 280 125" stroke="#f59e0b" stroke-width="4" marker-end="url(#arrow)"/>

  <!-- Step 2 -->
  <rect x="295" y="65" width="200" height="120" fill="#1e293b" stroke="#10b981" stroke-width="3" rx="8"/>
  <text x="395" y="105" fill="#34d399" font-family="Arial, sans-serif" font-size="16" font-weight="bold" text-anchor="middle">STEP 2: DRILL</text>
  <text x="395" y="135" fill="#ffffff" font-family="Arial, sans-serif" font-size="13" text-anchor="middle">Step-by-Step Shortcuts</text>
  <text x="395" y="155" fill="#ffffff" font-family="Arial, sans-serif" font-size="13" text-anchor="middle">&amp; Workflows</text>

  <!-- Arrow 2 -->
  <path d="M 505 125 L 535 125" stroke="#f59e0b" stroke-width="4"/>

  <!-- Step 3 -->
  <rect x="550" y="65" width="200" height="120" fill="#1e293b" stroke="#f59e0b" stroke-width="3" rx="8"/>
  <text x="650" y="105" fill="#fbbf24" font-family="Arial, sans-serif" font-size="16" font-weight="bold" text-anchor="middle">STEP 3: MASTER</text>
  <text x="650" y="135" fill="#ffffff" font-family="Arial, sans-serif" font-size="13" text-anchor="middle">Rubric Templates</text>
  <text x="650" y="155" fill="#ffffff" font-family="Arial, sans-serif" font-size="13" text-anchor="middle">&amp; Online Practice</text>
</svg>'''

with open("workflow_diagram.svg", "w", encoding="utf-8") as f:
    f.write(svg_workflow)

print("All master assets generated successfully!")
