// AP Calculus Score-5 Portal Engine

const calcFormulasData = [
  { unit: "Unit 1", title: "Definition of Continuity", formula: "f(c) is defined, lim(x->c) f(x) exists, and lim(x->c) f(x) = f(c)", trap: "All 3 conditions must be shown explicitly on FRQs." },
  { unit: "Unit 1", title: "Intermediate Value Theorem (IVT)", formula: "If f continuous on [a,b], f takes every value between f(a) and f(b)", trap: "Must state f is continuous on the CLOSED interval [a,b]." },
  { unit: "Unit 2", title: "Power Rule", formula: "d/dx [x^n] = n * x^(n-1)", trap: "Does not apply when the variable is in the exponent (use logarithmic diff)." },
  { unit: "Unit 2", title: "Product Rule", formula: "d/dx [u * v] = u' * v + u * v'", trap: "Do not simply multiply derivatives!" },
  { unit: "Unit 2", title: "Quotient Rule", formula: "d/dx [u / v] = (u' * v - u * v') / (v^2)", trap: "Remember low d-high minus high d-low over the square of what's below." },
  { unit: "Unit 3", title: "Chain Rule", formula: "d/dx [f(g(x))] = f'(g(x)) * g'(x)", trap: "Never forget to multiply by the derivative of the inside function." },
  { unit: "Unit 5", title: "Mean Value Theorem (MVT)", formula: "f'(c) = (f(b) - f(a)) / (b - a)", trap: "Must state: f is continuous on [a,b] AND differentiable on (a,b)." },
  { unit: "Unit 6", title: "Fundamental Theorem of Calculus (Part 1)", formula: "d/dx [ ∫_a^x f(t) dt ] = f(x)", trap: "Use chain rule if upper limit is a composite function g(x)." },
  { unit: "Unit 6", title: "Fundamental Theorem of Calculus (Part 2)", formula: "∫_a^b f'(t) dt = f(b) - f(a)", trap: "Net change = Initial value + Definite integral of rate." },
  { unit: "Unit 8", title: "Average Value of a Function", formula: "f_avg = (1 / (b - a)) * ∫_a^b f(x) dx", trap: "Do not confuse average rate of change with average value of f." },
  { unit: "Unit 10 (BC)", title: "Taylor Series Expansion", formula: "P_n(x) = Σ [ f^(k)(c) / k! ] * (x - c)^k", trap: "Factorials grow rapidly; always check ratio test for radius of convergence." }
];

function renderCalcFormulas(data) {
  const grid = document.getElementById("calcFormulaGrid");
  if (!grid) return;
  grid.innerHTML = "";
  data.forEach(item => {
    const card = document.createElement("div");
    card.className = "formula-card";
    card.innerHTML = `
      <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px;">
        <h3>${item.title}</h3>
        <span class="calc-tag">${item.unit}</span>
      </div>
      <p style="font-family:monospace; background:rgba(0,0,0,0.05); padding:6px 10px; border-radius:4px; font-weight:bold;">${item.formula}</p>
      <p style="color:#DC2626; font-size:0.85rem; margin-top:8px;"><strong>⚠️ Exam Trap:</strong> ${item.trap}</p>
    `;
    grid.appendChild(card);
  });
}

function generateCalcFrq() {
  const type = document.getElementById("calcFrqType").value;
  const interval = document.getElementById("calcFrqInterval").value;
  const out = document.getElementById("calcFrqResult");

  let html = "";
  if (type === "mvt") {
    html = `<strong>College Board MVT Template:</strong><br>
    "Because $f(x)$ is given to be continuous on the closed interval ${interval} and differentiable on the open interval ${interval.replace('[','(').replace(']',')')}, by the <strong>Mean Value Theorem</strong>, there exists at least one value $c \\in ${interval.replace('[','(').replace(']',')')}$ such that $f'(c) = \\frac{f(b) - f(a)}{b - a}$."`;
  } else if (type === "ivt") {
    html = `<strong>College Board IVT Template:</strong><br>
    "Since $f(x)$ is continuous on the closed interval ${interval}, and $f(a) < k < f(b)$, by the <strong>Intermediate Value Theorem</strong> there exists at least one value $c \\in ${interval.replace('[','(').replace(']',')')}$ such that $f(c) = k$."`;
  } else if (type === "concavity") {
    html = `<strong>College Board Inflection Point Template:</strong><br>
    "The graph of $f$ has a point of inflection at $x = c$ because $f''(x)$ (or $f'(x)$ slope) changes sign from positive to negative (or negative to positive) at $x = c$."`;
  } else if (type === "critical") {
    html = `<strong>First Derivative Relative Extremum Template:</strong><br>
    "$f(x)$ has a relative maximum at $x = c$ because $f'(c) = 0$ (or undefined) and $f'(x)$ changes sign from positive to negative at $x = c$."`;
  } else if (type === "speed") {
    html = `<strong>Particle Speed Template:</strong><br>
    "The speed of the particle is increasing at time $t$ because velocity $v(t)$ and acceleration $a(t)$ have the <strong>same sign</strong> (both positive or both negative)."`;
  }
  out.innerHTML = html;
}

document.addEventListener("DOMContentLoaded", () => {
  renderCalcFormulas(calcFormulasData);
  generateCalcFrq();

  const search = document.getElementById("calcFormulaSearch");
  if (search) {
    search.addEventListener("input", e => {
      const q = e.target.value.toLowerCase();
      const filtered = calcFormulasData.filter(d => 
        d.title.toLowerCase().includes(q) || 
        d.formula.toLowerCase().includes(q) || 
        d.unit.toLowerCase().includes(q)
      );
      renderCalcFormulas(filtered);
    });
  }

  // Tabs
  const tabBtns = document.querySelectorAll(".tabs-nav .tab-btn");
  tabBtns.forEach(btn => {
    btn.addEventListener("click", () => {
      tabBtns.forEach(b => b.classList.remove("active"));
      document.querySelectorAll(".tab-pane").forEach(p => p.classList.remove("active"));
      btn.classList.add("active");
      const target = document.getElementById(btn.dataset.tab);
      if (target) target.classList.add("active");
    });
  });

  // Dark mode
  const toggle = document.getElementById("themeToggle");
  if (toggle) {
    toggle.addEventListener("click", () => {
      const html = document.documentElement;
      const isDark = html.getAttribute("data-theme") === "dark";
      html.setAttribute("data-theme", isDark ? "light" : "dark");
      toggle.textContent = isDark ? "🌙 Dark Mode" : "☀️ Light Mode";
    });
  }
});