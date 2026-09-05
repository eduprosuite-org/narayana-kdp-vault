// AP Statistics Score-5 Interactive Portal Engine

const formulasData = [
  {
    unit: "Unit 1",
    title: "Standardized Score (z-score)",
    formula: "z = (x - μ) / σ  or  z = (x - x̄) / s",
    notes: "Measures the number of standard deviations an observation falls above or below the mean.",
    trap: "Always specify the direction (above vs below mean) and include context."
  },
  {
    unit: "Unit 1",
    title: "1.5 × IQR Outlier Rule",
    formula: "Lower = Q1 - 1.5(IQR), Upper = Q3 + 1.5(IQR)",
    notes: "Use for skewed distributions or when summary data uses median/IQR.",
    trap: "Points exactly on the boundary are NOT outliers."
  },
  {
    unit: "Unit 2",
    title: "Slope of Least-Squares Regression Line (b)",
    formula: "b = r * (sy / sx)",
    notes: "Rate of change in predicted y per 1-unit increase in x.",
    trap: "Never omit the word 'predicted' or the hat (ŷ) on exam FRQs."
  },
  {
    unit: "Unit 2",
    title: "Coefficient of Determination (r²)",
    formula: "r² = (Correlation r)²",
    notes: "Proportion of variation in response y explained by the linear model with x.",
    trap: "A high r² alone does NOT prove the relationship is linear. Check residual plot!"
  },
  {
    unit: "Unit 4",
    title: "General Addition Rule",
    formula: "P(A ∪ B) = P(A) + P(B) - P(A ∩ B)",
    notes: "If mutually exclusive (disjoint), P(A ∩ B) = 0.",
    trap: "Mutually exclusive events are NEVER independent (if P > 0)."
  },
  {
    unit: "Unit 4",
    title: "Binomial Distribution Probability",
    formula: "P(X = k) = (n choose k) * p^k * (1-p)^(n-k)",
    notes: "Mean: μ = np, Standard Deviation: σ = √(np(1-p))",
    trap: "Verify BINS conditions (Binary, Independent, Number fixed, Same p)."
  },
  {
    unit: "Unit 5",
    title: "Sampling Distribution of Sample Mean (x̄)",
    formula: "μ_x̄ = μ,  σ_x̄ = σ / √n",
    notes: "Central Limit Theorem guarantees approximate normality of x̄ if n ≥ 30.",
    trap: "CLT applies to the SAMPLING DISTRIBUTION, not the population or sample data."
  },
  {
    unit: "Unit 6",
    title: "1-Proportion z-Interval",
    formula: "p̂ ± z* * √[ p̂(1 - p̂) / n ]",
    notes: "Conditions: Random sample, 10% condition (n ≤ 0.10N), Large counts (np̂ ≥ 10, n(1-p̂) ≥ 10).",
    trap: "Use p̂ for confidence intervals; use hypothesized p0 for hypothesis tests."
  },
  {
    unit: "Unit 6",
    title: "2-Proportion z-Test (Pooled)",
    formula: "z = (p̂1 - p̂2) / √[ p̂c(1-p̂c)(1/n1 + 1/n2) ]",
    notes: "Pooled proportion: p̂c = (x1 + x2) / (n1 + n2)",
    trap: "ONLY pool for 2-proportion tests of equal proportions. Never pool for intervals."
  },
  {
    unit: "Unit 7",
    title: "1-Sample t-Interval for Mean",
    formula: "x̄ ± t* * (s / √n)   [df = n - 1]",
    notes: "Conditions: Random sample, 10% condition, Normal pop or n ≥ 30 (or no skew/outliers).",
    trap: "Always record degrees of freedom (df) explicitly on your FRQ paper."
  },
  {
    unit: "Unit 7",
    title: "2-Sample t-Test (Independent Means)",
    formula: "t = [(x̄1 - x̄2) - 0] / √[ s1²/n1 + s2²/n2 ]",
    notes: "Use conservative df = min(n1-1, n2-1) or calculator Satterthwaite df.",
    trap: "Always select 'Pooled: NO' on TI-84."
  },
  {
    unit: "Unit 8",
    title: "Chi-Square Test Statistic",
    formula: "χ² = Σ [ (Observed - Expected)² / Expected ]",
    notes: "Expected Count = (Row Total * Col Total) / Table Total",
    trap: "ALL Expected counts must be ≥ 5. Never verify observed counts!"
  },
  {
    unit: "Unit 9",
    title: "Linear Regression Slope t-Test",
    formula: "t = (b - 0) / SE_b   [df = n - 2]",
    notes: "Check LINER conditions: Linear, Independent, Normal residuals, Equal SD, Random.",
    trap: "Read slope row (second row) from computer output table."
  }
];

const quizQuestions = [
  {
    question: "1. A researcher conducts a test and obtains a p-value of 0.034 at α = 0.05. What is the proper conclusion?",
    options: [
      "We accept the null hypothesis because the evidence is conclusive.",
      "We prove the alternative hypothesis is true.",
      "Because p < 0.05, we reject the null hypothesis and have convincing statistical evidence for the alternative.",
      "Because p < 0.05, we fail to reject the null hypothesis."
    ],
    answer: 2,
    explanation: "Correct! We never 'accept' or 'prove' hypotheses. Because p < α, we reject H0 and find convincing statistical evidence for Ha."
  },
  {
    question: "2. When checking conditions for a 2-way Chi-Square Test of Independence, which rule is required?",
    options: [
      "All observed counts must be at least 5.",
      "All expected counts must be at least 5.",
      "Sample size must be greater than 30 by CLT.",
      "The population must follow a normal distribution."
    ],
    answer: 1,
    explanation: "Correct! Chi-Square test validity strictly requires all EXPECTED counts to be ≥ 5."
  },
  {
    question: "3. What does the Central Limit Theorem (CLT) specifically state?",
    options: [
      "The population becomes Normal as sample size increases.",
      "The sample data distribution becomes Normal for n ≥ 30.",
      "The sampling distribution of the sample mean becomes approximately Normal for sufficiently large n (n ≥ 30).",
      "The sample proportion equals the population proportion."
    ],
    answer: 2,
    explanation: "Correct! The CLT applies exclusively to the SAMPLING DISTRIBUTION of x̄, not the population or raw sample data."
  },
  {
    question: "4. Which of the following summary statistics is resistant to extreme outliers?",
    options: [
      "Mean",
      "Standard Deviation",
      "Median and IQR",
      "Range"
    ],
    answer: 2,
    explanation: "Correct! Median and IQR depend only on relative position / middle 50% and are unaffected by extreme tail values."
  },
  {
    question: "5. In a linear regression equation ŷ = 12 + 3.5x, what is the proper interpretation of 3.5?",
    options: [
      "For every 1 unit increase in x, y increases by 3.5.",
      "For every 1 unit increase in x, the predicted value of y increases by 3.5.",
      "35% of the variation in y is explained by x.",
      "The correlation between x and y is 3.5."
    ],
    answer: 1,
    explanation: "Correct! You must specify that it is the PREDICTED value of y that changes by the slope value."
  }
];

// Initialize on DOM Load
document.addEventListener("DOMContentLoaded", () => {
  initTabs();
  initThemeToggle();
  renderFormulas(formulasData);
  initSearch();
  initWizard();
  initTemplateGenerator();
  renderQuiz();
});

// Tabs
function initTabs() {
  const buttons = document.querySelectorAll(".tab-btn");
  const panes = document.querySelectorAll(".tab-pane");

  buttons.forEach(btn => {
    btn.addEventListener("click", () => {
      buttons.forEach(b => b.classList.remove("active"));
      panes.forEach(p => p.classList.remove("active"));

      btn.classList.add("active");
      const target = document.getElementById(btn.dataset.tab);
      if (target) target.classList.add("active");
    });
  });
}

// Theme Toggle
function initThemeToggle() {
  const toggleBtn = document.getElementById("themeToggle");
  if (!toggleBtn) return;
  toggleBtn.addEventListener("click", () => {
    const current = document.documentElement.getAttribute("data-theme");
    const next = current === "dark" ? "light" : "dark";
    document.documentElement.setAttribute("data-theme", next);
    toggleBtn.textContent = next === "dark" ? "☀️ Light Mode" : "🌙 Dark Mode";
  });
}

// Render Formulas
function renderFormulas(items) {
  const container = document.getElementById("formulaGrid");
  if (!container) return;

  if (items.length === 0) {
    container.innerHTML = `<p style="color: var(--text-muted);">No matching formulas found.</p>`;
    return;
  }

  container.innerHTML = items.map(item => `
    <div class="formula-card">
      <h3>${item.title} <span class="unit-tag">${item.unit}</span></h3>
      <div class="math-display">${item.formula}</div>
      <p style="font-size: 0.95rem;">${item.notes}</p>
      <div class="trap-callout"><strong>⚠️ AP Alert:</strong> ${item.trap}</div>
    </div>
  `).join("");
}

// Search Filter
function initSearch() {
  const searchInput = document.getElementById("formulaSearch");
  if (!searchInput) return;

  searchInput.addEventListener("input", (e) => {
    const query = e.target.value.toLowerCase();
    const filtered = formulasData.filter(item => 
      item.title.toLowerCase().includes(query) ||
      item.unit.toLowerCase().includes(query) ||
      item.formula.toLowerCase().includes(query) ||
      item.notes.toLowerCase().includes(query)
    );
    renderFormulas(filtered);
  });
}

// Inference Wizard
let wizardState = { data: null, groups: null, goal: null };

function initWizard() {
  window.setWizardData = (type) => {
    wizardState.data = type;
    document.getElementById("step1").style.display = "none";
    document.getElementById("step2").style.display = "block";
  };

  window.setWizardGroups = (groups) => {
    wizardState.groups = groups;
    document.getElementById("step2").style.display = "none";
    document.getElementById("step3").style.display = "block";
  };

  window.setWizardGoal = (goal) => {
    wizardState.goal = goal;
    document.getElementById("step3").style.display = "none";
    showWizardResult();
  };

  window.resetWizard = () => {
    wizardState = { data: null, groups: null, goal: null };
    document.getElementById("step1").style.display = "block";
    document.getElementById("step2").style.display = "none";
    document.getElementById("step3").style.display = "none";
    document.getElementById("wizardResult").style.display = "none";
  };
}

function showWizardResult() {
  const res = document.getElementById("wizardResult");
  const text = document.getElementById("wizardResultText");
  res.style.display = "block";

  let testName = "";
  let ti84 = "";
  let conditions = "";

  const { data, groups, goal } = wizardState;

  if (data === "categorical") {
    if (groups === "1") {
      if (goal === "interval") {
        testName = "1-Proportion z-Interval";
        ti84 = "STAT → TESTS → A: 1-PropZInt";
        conditions = "Random, 10% (n ≤ 0.10N), Large Counts (np̂ ≥ 10, n(1-p̂) ≥ 10)";
      } else {
        testName = "1-Proportion z-Test";
        ti84 = "STAT → TESTS → 5: 1-PropZTest";
        conditions = "Random, 10% (n ≤ 0.10N), Large Counts with p0 (np0 ≥ 10, n(1-p0) ≥ 10)";
      }
    } else if (groups === "2") {
      if (goal === "interval") {
        testName = "2-Proportion z-Interval";
        ti84 = "STAT → TESTS → B: 2-PropZInt";
        conditions = "2 Independent Random Samples, 10% rule, Large Counts for both samples";
      } else {
        testName = "2-Proportion z-Test (Pooled)";
        ti84 = "STAT → TESTS → 6: 2-PropZTest";
        conditions = "2 Independent Random Samples, 10% rule, Pooled large counts";
      }
    } else {
      testName = "Chi-Square Test (Homogeneity / Independence / GOF)";
      ti84 = "STAT → TESTS → C: χ²-Test or D: χ²GOF-Test";
      conditions = "Random sample(s), 10% rule, ALL Expected Counts ≥ 5";
    }
  } else {
    // Quantitative
    if (groups === "1") {
      if (goal === "interval") {
        testName = "1-Sample t-Interval for Mean";
        ti84 = "STAT → TESTS → 8: TInterval";
        conditions = "Random, 10% rule, Normal population or n ≥ 30 (CLT)";
      } else {
        testName = "1-Sample t-Test for Mean";
        ti84 = "STAT → TESTS → 2: T-Test";
        conditions = "Random, 10% rule, Normal population or n ≥ 30 (CLT)";
      }
    } else if (groups === "matched") {
      testName = "Paired t-Test / Interval (Differences)";
      ti84 = "Enter L1 - L2 into L3 → STAT → TESTS → 2: T-Test / 8: TInterval on L3";
      conditions = "Random sample of pairs, 10% rule, Normal differences or n_diff ≥ 30";
    } else if (groups === "2") {
      if (goal === "interval") {
        testName = "2-Sample t-Interval for Independent Means";
        ti84 = "STAT → TESTS → 0: 2-SampTInt (Pooled: NO)";
        conditions = "2 Independent Random Samples, 10% rule, Both n1,n2 ≥ 30 or normal pops";
      } else {
        testName = "2-Sample t-Test for Independent Means";
        ti84 = "STAT → TESTS → 4: 2-SampTTest (Pooled: NO)";
        conditions = "2 Independent Random Samples, 10% rule, Both n1,n2 ≥ 30 or normal pops";
      }
    } else {
      testName = "Linear Regression Slope t-Test / Interval";
      ti84 = "STAT → TESTS → F: LinRegTTest / G: LinRegTInt";
      conditions = "LINER (Linear, Independent, Normal residuals, Equal SD, Random)";
    }
  }

  text.innerHTML = `
    <h3>Recommended Procedure: <strong>${testName}</strong></h3>
    <p style="margin: 10px 0;"><strong>TI-84 Path:</strong> <code>${ti84}</code></p>
    <p><strong>Required Conditions:</strong> ${conditions}</p>
  `;
}

// Template Generator
function initTemplateGenerator() {
  const typeSelect = document.getElementById("templateType");
  const ctxInput = document.getElementById("templateContext");
  const val1Input = document.getElementById("templateVal1");
  const val2Input = document.getElementById("templateVal2");
  const outputBox = document.getElementById("templateResult");

  function updateTemplate() {
    const type = typeSelect.value;
    const ctx = ctxInput.value || "[context of problem]";
    const v1 = val1Input.value || "[value 1]";
    const v2 = val2Input.value || "[value 2]";

    let sentence = "";
    if (type === "ci") {
      sentence = `We are ${v1}% confident that the interval from ${v2} captures the true ${ctx}.`;
    } else if (type === "pvalue") {
      sentence = `Assuming that the null hypothesis is true (${ctx}), there is a ${v1} probability of obtaining a sample statistic as extreme as or more extreme than observed purely by chance.`;
    } else if (type === "slope") {
      sentence = `For each additional 1 unit increase in ${v1}, the predicted ${ctx} increases by approximately ${v2}.`;
    } else if (type === "r2") {
      sentence = `Approximately ${v1}% of the variation in ${ctx} is accounted for by the linear relationship with ${v2}.`;
    }

    outputBox.innerHTML = `<strong>Generated Sentence:</strong><br>"${sentence}"`;
  }

  if (typeSelect) {
    typeSelect.addEventListener("change", updateTemplate);
    ctxInput.addEventListener("input", updateTemplate);
    val1Input.addEventListener("input", updateTemplate);
    val2Input.addEventListener("input", updateTemplate);
    updateTemplate();
  }
}

// Quiz
function renderQuiz() {
  const container = document.getElementById("quizContainer");
  if (!container) return;

  container.innerHTML = quizQuestions.map((q, idx) => `
    <div class="quiz-question" data-idx="${idx}">
      <p style="font-weight: 700; margin-bottom: 12px;">${q.question}</p>
      <div class="quiz-options">
        ${q.options.map((opt, oIdx) => `
          <label>
            <input type="radio" name="q${idx}" value="${oIdx}" onchange="checkAnswer(${idx}, ${oIdx})">
            ${opt}
          </label>
        `).join("")}
      </div>
      <div id="feedback-${idx}" class="quiz-feedback"></div>
    </div>
  `).join("");
}

window.checkAnswer = (qIdx, selectedOpt) => {
  const q = quizQuestions[qIdx];
  const fb = document.getElementById(`feedback-${qIdx}`);
  fb.style.display = "block";

  if (selectedOpt === q.answer) {
    fb.style.background = "#ecfdf5";
    fb.style.color = "#065f46";
    fb.style.border = "1px solid #a7f3d0";
    fb.innerHTML = `✅ ${q.explanation}`;
  } else {
    fb.style.background = "#fef2f2";
    fb.style.color = "#991b1b";
    fb.style.border = "1px solid #fecaca";
    fb.innerHTML = `❌ Incorrect. Please review the rules above!`;
  }
};

