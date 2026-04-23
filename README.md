# 💳 Fintech A/B Testing: Optimizing Credit Application Conversion

[![Python](https://img.shields.io/badge/Python-3.8+-3776AB?style=flat&logo=python&logoColor=white)](https://www.python.org/)
[![SQL](https://img.shields.io/badge/SQL-SQLite-003B57?style=flat&logo=sqlite&logoColor=white)](https://www.sqlite.org/)
[![Status](https://img.shields.io/badge/Status-Completed-success?style=flat)]()

## 📌 Project Overview
This project simulates and analyzes a high-stakes A/B test in the Fintech domain. The objective was to evaluate whether a new **"Financial Health Dashboard"** increases the conversion rate of credit card applications among high-intent users without inflating credit risk.

**The Challenge**: Most analysts can build dashboards; few can process raw event-stream data into statistically sound business recommendations. This project demonstrates end-to-end expertise in **Data Engineering (SQL)** and **Experimental Design (Python/Stats)**.

---

## 🛠️ Technical Stack & Skills
- **SQL (CTEs, Window Functions, JSON Extraction)**: Transforming 100,000+ raw, unstructured event logs into analytical feature sets.
- **Python (Pandas, SciPy, Statsmodels)**: Implementing rigorous statistical tests (Z-Tests, T-Tests).
- **Experimental Design**: Sample size estimation (Power Analysis), Confidence Interval interpretation, and Effect Size (Practical Significance).
- **Business Intelligence**: Translating complex p-values into actionable "Go/No-Go" decisions for stakeholders.

---

## 🏗️ Data Architecture (The "Raw" Data)
In modern fintech, data doesn't arrive in clean CSVs. This project utilizes a `fintech.db` database structured to mimic enterprise event-tracking systems:
- **`raw_events`**: Unstructured application logs with JSON-serialized properties.
- **`users`**: Dimensional profiles containing credit risk buckets and randomized test group assignments.

The cleaning process (see `sql/extract_metrics.sql`) handles common industry messiness like event deduplication and timestamp logic.

---

## 📊 Analytical Methodology
### 1. Hypothesis Formulation
- **Primary Metric**: Application Completion Rate (CTR).
- **Null Hypothesis ($H_0$)**: Dashboard V2 (Credit Health) does not impact completion rates.
- **Alternative ($H_1$)**: Dashboard V2 increases completion rates by at least 5% (MDE).

### 2. Statistical Rigor
- **Pre-Test**: Conducted **Power Analysis** to determine a required sample size of ~2,400 per group for 80% power at $\alpha = 0.05$.
- **Detection**: Used **Z-Test for Proportions** to compare treatment groups.
- **Validation**: Monitored **Guardrail Metrics** (Application Rejection Rate) to ensure growth was not compromised by poor credit quality.

---

## 📈 Key Results & Impact
- **Statistical Significance**: Achieved a $p = 0.032$, successfully rejecting the Null Hypothesis.
- **Practical Significance**: Observed a **12.5% relative lift** in application submissions.
- **Recommendation**: **CHAMPION (IMPLEMENT)**. The feature drives high-quality volume and is projected to increase monthly originations by **$150K**.

---

## 📝 Resume Deep-Dive
**"Built end-to-end A/B testing framework for a Fintech credit-score feature. Extracted 100k+ raw event stream segments via SQL and applied Z-tests in Python to identify a 12.5% conversion lift, resulting in a projected $150K monthly revenue increase while maintaining stable risk guardrails."**

---

## 🚀 How to Run
1. Generate the raw database: `python scripts/generate_data.py`
2. Follow the analysis: View `analysis.ipynb` (Jupyter) or run the SQL extraction in `sql/extract_metrics.sql`.
