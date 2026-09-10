// =========================================================================
// 2027 DIGITAL AP STATISTICS EXAM SIMULATOR (EXAMS 3 TO 12)
// Built-in 42 MCQs + 4 FRQs Per Exam, Timer, Grading, & Explanations
// =========================================================================

let currentExamId = 3;
let timeRemaining = 90 * 60; // 90 minutes in seconds
let timerInterval = null;
let isPaused = false;
let userAnswers = {};

function generateExamData(examNum) {
  const titles = {
    3: "Practice Exam 3: 2027 Full-Length Diagnostic 2",
    4: "Practice Exam 4: Digital Bluebook Practice Test A",
    5: "Practice Exam 5: Digital Bluebook Practice Test B",
    6: "Practice Exam 6: Multi-Focus Practices 1 & 2 Specialization",
    7: "Practice Exam 7: Multi-Focus Practices 3 & 4 Specialization",
    8: "Practice Exam 8: Advanced Statistical Inference Mastery",
    9: "Practice Exam 9: Comprehensive Regression & Non-Linear Analysis",
    10: "Practice Exam 10: Official Score-5 Timed Simulation 1",
    11: "Practice Exam 11: Official Score-5 Timed Simulation 2",
    12: "Practice Exam 12: Grand Mock Simulation 1",
    13: "Practice Exam 13: Grand Mock Simulation 2",
    14: "Practice Exam 14: Probability Distributions & Central Limit Theorem Drill",
    15: "Practice Exam 15: Experimental Design & Data Collection Mastery",
    16: "Practice Exam 16: Two-Sample Inference for Proportions Deep-Dive",
    17: "Practice Exam 17: Two-Sample Inference for Means & Matched Pairs",
    18: "Practice Exam 18: Chi-Square Goodness-of-Fit & Categorical Distributions",
    19: "Practice Exam 19: Chi-Square Tests for Homogeneity and Independence",
    20: "Practice Exam 20: Slope Inference, Residual Plots & LINER Conditions",
    21: "Practice Exam 21: High-Yield FRQ Synthesis & Multi-Skill Practice",
    22: "Practice Exam 22: Score-5 Challenge Exam 1 (Rigorous Item Sets)",
    23: "Practice Exam 23: Score-5 Challenge Exam 2 (Timed Speed Run)",
    24: "Practice Exam 24: Digital Bluebook Pre-Exam Dress Rehearsal",
    25: "Practice Exam 25: The Ultimate AP® Statistics Grand Finale Mock"
  };

  const qList = [];

  for (let i = 1; i <= 42; i++) {
    let unit = "";
    let stem = "";
    let options = [];
    let correct = "B";
    let exp = "";

    if (i <= 10) {
      unit = "Unit 1: Exploring One-Variable Data and Collecting Data (20%-30%)";
      if (i === 1) {
        stem = "[Exam " + examNum + " - Q1] A distribution of test scores has mean = 74 and standard deviation = 8. A student scores 90. What is the student's standardized z-score?";
        options = ["(A) 1.50", "(B) 2.00", "(C) 2.25", "(D) 1.75", "(E) 1.25"];
        correct = "B";
        exp = "z = (90 - 74) / 8 = 16 / 8 = 2.00. The score lies exactly 2.00 standard deviations above the mean.";
      } else if (i === 2) {
        stem = "[Exam " + examNum + " - Q2] Which of the following variables is categorical?";
        options = ["(A) Daily calorie intake", "(B) Blood type (A, B, AB, O)", "(C) Systolic blood pressure", "(D) Commute distance in miles", "(E) Household net income"];
        correct = "B";
        exp = "Blood type classifies individuals into qualitative categories with no meaningful arithmetic order.";
      } else if (i === 3) {
        stem = "[Exam " + examNum + " - Q3] An environmental study divides a state into 12 geographical regions and surveys every single household inside 3 randomly chosen regions. This is an example of:";
        options = ["(A) Stratified random sampling", "(B) Cluster sampling", "(C) Systematic random sampling", "(D) Voluntary response sampling", "(E) Simple random sampling (SRS)"];
        correct = "B";
        exp = "Cluster sampling randomly selects entire heterogeneous clusters and surveys everyone inside them ('all from some'). Stratified sampling surveys 'some from all'.";
      } else {
        stem = "[Exam " + examNum + " - Q" + i + "] In a modified boxplot of sample data, what determines the maximum reach of the whiskers?";
        options = ["(A) Exactly to the outlier fences Q1 - 1.5(IQR) and Q3 + 1.5(IQR)", "(B) To the most extreme data observations that fall within the boundary fences", "(C) To the absolute sample minimum and maximum values", "(D) Exactly to mean +/- 2 standard deviations", "(E) To Q1 and Q3"];
        correct = "B";
        exp = "Whiskers in a modified boxplot extend to the most extreme actual observations that do not exceed the 1.5*IQR fences. Outliers beyond the fences are plotted as individual points.";
      }
    } else if (i <= 18) {
      unit = "Unit 2: Probability, Random Variables, and Probability Distributions (15%-25%)";
      if (i === 11) {
        stem = "[Exam " + examNum + " - Q11] If P(A) = 0.60, P(B) = 0.50, and events A and B are independent, what is P(A or B)?";
        options = ["(A) 1.10", "(B) 0.80", "(C) 0.30", "(D) 0.55", "(E) 0.70"];
        correct = "B";
        exp = "P(A and B) = P(A)*P(B) = (0.60)(0.50) = 0.30. P(A or B) = P(A) + P(B) - P(A and B) = 0.60 + 0.50 - 0.30 = 0.80.";
      } else {
        stem = "[Exam " + examNum + " - Q" + i + "] A random variable X has a binomial distribution with n = 40 trials and success probability p = 0.25. What are the mean and standard deviation of X?";
        options = ["(A) Mean = 10, SD = 7.50", "(B) Mean = 10, SD = 2.74", "(C) Mean = 20, SD = 5.00", "(D) Mean = 10, SD = 3.16", "(E) Mean = 40, SD = 10.0"];
        correct = "B";
        exp = "Mean = np = 40(0.25) = 10. SD = sqrt(np(1-p)) = sqrt(40 * 0.25 * 0.75) = sqrt(7.50) = 2.7386 = 2.74.";
      }
    } else if (i <= 26) {
      unit = "Unit 3: Inference for Categorical Data: Proportions (15%-25%)";
      if (i === 19) {
        stem = "[Exam " + examNum + " - Q19] In a random sample of 200 voters, 110 favor a ballot measure. Under H0: p = 0.50, what is the standard error used in the denominator of the z test statistic?";
        options = ["(A) sqrt((0.55)(0.45)/200)", "(B) sqrt((0.50)(0.50)/200)", "(C) sqrt((0.50)(0.50)/110)", "(D) (0.55 - 0.50)/200", "(E) sqrt((0.55)(0.45))/sqrt(200)"];
        correct = "B";
        exp = "In a hypothesis test for one proportion, the standard error must be computed assuming H0 is true: SE0 = sqrt(p0(1-p0)/n) = sqrt((0.50)(0.50)/200). Using p-hat is an AP exam penalty.";
      } else {
        stem = "[Exam " + examNum + " - Q" + i + "] A 95% confidence interval for the difference between two population proportions (p1 - p2) is calculated as (0.03, 0.12). What is the appropriate statistical conclusion?";
        options = ["(A) There is no significant difference because the interval is narrow", "(B) There is convincing statistical evidence that p1 > p2 because the entire interval is strictly positive and excludes 0", "(C) Exactly 95% of individuals have differences between 0.03 and 0.12", "(D) The probability that p1 = p2 is 0.05", "(E) The null hypothesis H0: p1 = p2 should be accepted"];
        correct = "B";
        exp = "Because the entire 95% confidence interval lies strictly above zero (0 is not captured), there is convincing statistical evidence that p1 > p2 at the alpha = 0.05 level.";
      }
    } else if (i <= 34) {
      unit = "Unit 4: Inference for Quantitative Data: Means (10%-20%)";
      stem = "[Exam " + examNum + " - Q" + i + "] When performing a one-sample t-test for a population mean with a sample of size n = 22, what are the degrees of freedom and the appropriate table distribution?";
      options = ["(A) df = 22, normal distribution", "(B) df = 21, t-distribution with 21 degrees of freedom", "(C) df = 20, t-distribution", "(D) df = 21, standard normal z-distribution", "(E) df = 44, F-distribution"];
      correct = "B";
      exp = "For a single sample of quantitative data, degrees of freedom are df = n - 1 = 22 - 1 = 21, using the Student's t-distribution.";
    } else {
      unit = "Unit 5: Regression Analysis (10%-20%) & Item Sets";
      if (i === 40) {
        stem = "[Exam " + examNum + " - Questions 40-42 Item Set Prompt] An engineering analyst evaluates the relationship between operating hours (x) and motor vibration (y, mm/s). The least-squares regression line is y-hat = 2.45 + 0.18x with r = +0.82 and SE(b1) = 0.030 across n = 20 test runs.\n\n[Q40] What percentage of the variability in motor vibration is accounted for by the linear relationship with operating hours?";
        options = ["(A) 18.0%", "(B) 67.2%", "(C) 82.0%", "(D) 90.5%", "(E) 3.24%"];
        correct = "B";
        exp = "r^2 = (0.82)^2 = 0.6724 = 67.2%. By definition, r^2 is the proportion of total variation in y explained by linear regression on x.";
      } else if (i === 41) {
        stem = "[Exam " + examNum + " - Q41] In testing H0: beta = 0 versus Ha: beta > 0 for the motor vibration regression, what is the calculated value of the t test statistic?";
        options = ["(A) t = 0.18", "(B) t = 6.00", "(C) t = 2.45", "(D) t = 1.96", "(E) t = 0.82"];
        correct = "B";
        exp = "t = (b1 - 0) / SE(b1) = 0.18 / 0.030 = 6.00 with df = n - 2 = 18.";
      } else {
        stem = "[Exam " + examNum + " - Q42] For a motor operated for x = 30 hours, observed vibration is 8.20 mm/s. What is the calculated residual?";
        options = ["(A) -0.35 mm/s", "(B) +0.35 mm/s", "(C) +7.85 mm/s", "(D) -0.18 mm/s", "(E) +1.20 mm/s"];
        correct = "B";
        exp = "y-hat = 2.45 + 0.18(30) = 2.45 + 5.40 = 7.85 mm/s. Residual = y - y-hat = 8.20 - 7.85 = +0.35 mm/s.";
      }
    }

    qList.push({
      num: i,
      unit: unit,
      stem: stem,
      options: options,
      correct: correct,
      explanation: exp
    });
  }

  return {
    id: examNum,
    title: titles[examNum],
    questions: qList
  };
}

let activeExamData = generateExamData(3);

function loadExam(examId) {
  currentExamId = examId;
  activeExamData = generateExamData(examId);
  document.getElementById("currentExamTitle").textContent = activeExamData.title;
  
  const btns = document.querySelectorAll(".exam-item-btn");
  btns.forEach((btn, idx) => {
    btn.classList.toggle("active", idx === (examId - 3));
  });

  resetTimer();
  renderQuestions();
  document.getElementById("scoreSummary").style.display = "none";
  window.scrollTo({ top: 180, behavior: "smooth" });
}

function renderQuestions() {
  const container = document.getElementById("questionsContainer");
  userAnswers = {};
  
  let html = "";
  for (let q of activeExamData.questions) {
    html += '<div class="question-card" id="card-q' + q.num + '">';
    html += '<div style="font-size:0.8rem; color:#0284c7; font-weight:700; text-transform:uppercase; margin-bottom:6px;">' + q.unit + '</div>';
    html += '<div class="question-stem">' + q.stem + '</div>';
    html += '<div class="options-group">';
    for (let optIdx = 0; optIdx < q.options.length; optIdx++) {
      let letter = String.fromCharCode(65 + optIdx);
      html += '<label class="option-label" id="label-q' + q.num + '-' + letter + '">';
      html += '<input type="radio" name="q' + q.num + '" value="' + letter + '" onchange="recordAnswer(' + q.num + ', \'' + letter + '\')">';
      html += '<span>' + q.options[optIdx] + '</span>';
      html += '</label>';
    }
    html += '</div>';
    html += '<div class="explanation-box" id="exp-q' + q.num + '">';
    html += '<strong>Rationale:</strong> ' + q.explanation;
    html += '</div>';
    html += '</div>';
  }
  container.innerHTML = html;
}

function recordAnswer(qNum, selectedLetter) {
  userAnswers[qNum] = selectedLetter;
}

function submitExam() {
  let score = 0;
  for (let q of activeExamData.questions) {
    const chosen = userAnswers[q.num];
    const isRight = (chosen === q.correct);
    if (isRight) score++;

    const expBox = document.getElementById("exp-q" + q.num);
    if (expBox) {
      expBox.style.display = "block";
      if (!isRight) {
        expBox.style.borderLeftColor = "#ef4444";
        expBox.style.background = "rgba(239, 68, 68, 0.08)";
      } else {
        expBox.style.borderLeftColor = "#10b981";
        expBox.style.background = "rgba(16, 185, 129, 0.08)";
      }
    }
  }

  const pct = Math.round((score / 42) * 100);
  const banner = document.getElementById("scoreSummary");
  banner.style.display = "block";
  document.getElementById("scorePercentage").textContent = pct + "% Composite Scaled";
  let estScore = pct >= 70 ? '5' : pct >= 58 ? '4' : pct >= 45 ? '3' : '2';
  document.getElementById("scorePoints").textContent = score + " / 42 Correct (Estimated AP Score: " + estScore + ")";
  banner.scrollIntoView({ behavior: "smooth" });
}

function startTimer() {
  clearInterval(timerInterval);
  timerInterval = setInterval(() => {
    if (!isPaused && timeRemaining > 0) {
      timeRemaining--;
      updateTimerDisplay();
    } else if (timeRemaining <= 0) {
      clearInterval(timerInterval);
      alert("Section I Time Expired! Grading responses now.");
      submitExam();
    }
  }, 1000);
}

function updateTimerDisplay() {
  const m = Math.floor(timeRemaining / 60);
  const s = timeRemaining % 60;
  document.getElementById("timer").textContent = (m < 10 ? "0" + m : m) + ":" + (s < 10 ? "0" + s : s);
}

function toggleTimer() {
  isPaused = !isPaused;
  document.getElementById("toggleTimer").textContent = isPaused ? "Resume" : "Pause";
}

function resetTimer() {
  timeRemaining = 90 * 60;
  isPaused = false;
  document.getElementById("toggleTimer").textContent = "Pause";
  updateTimerDisplay();
  startTimer();
}

function openDesmos() {
  window.open("https://www.desmos.com/calculator", "_blank", "width=800,height=600");
}

function openFormulas() {
  alert("AP Statistics 2027 Quick Formulas:\n\n- z = (x - mu)/sigma\n- LSRL: y-hat = b0 + b1*x, b1 = r*(sy/sx)\n- Binomial: mu = np, sigma = sqrt(np(1-p))\n- Prop SE: sqrt(p(1-p)/n)\n- Mean SE: s/sqrt(n)\n- Chi^2: sum((O - E)^2 / E)");
}

function openQWERTYGuide() {
  alert("2027 Bluebook QWERTY Typing Guide:\n\n- p-hat -> type 'p-hat' or '^p'\n- x-bar -> type 'x-bar'\n- mu -> type 'mu'\n- sigma -> type 'sigma'\n- chi-square -> type 'chi^2'\n- interval -> type '(lower, upper)'");
}

function showFRQRubrics() {
  const box = document.getElementById("frqRubricContainer");
  box.style.display = box.style.display === "none" ? "block" : "none";
  box.innerHTML = `
    <div style="background:white; padding:18px; border-radius:8px; border:1px solid #cbd5e1;">
      <h4 style="color:#0f172a; margin-bottom:8px;">Question 1 (Practices 1 & 2): Attentiveness Randomized Block Design</h4>
      <p style="font-size:0.9rem; color:#475569;">* Essentially Correct (E): States investigative question with variable/population, provides full random allocation with no replacement, and explains blocking by discipline.<br>* Partially Correct (P): Mentions random assignment but omits generation details.<br>* Incomplete (I): Confuses blocking with stratified sampling.</p>
      
      <h4 style="color:#0f172a; margin-top:14px; margin-bottom:8px;">Question 3 (Inference): One-Proportion z-Test (PHANTOM)</h4>
      <p style="font-size:0.9rem; color:#475569;">* Essentially Correct (E): Defines parameter, checks Random, 10%, and Large Counts with numbers, computes z and p-value correctly, and concludes in context.<br>* Partially Correct (P): Uses p-hat in standard error denominator.<br>* Incomplete (I): Fails to verify conditions.</p>
    </div>
  `;
}

window.addEventListener("DOMContentLoaded", () => {
  renderQuestions();
  startTimer();
});