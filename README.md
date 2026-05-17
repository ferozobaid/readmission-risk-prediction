# Readmission Risk Prediction

**Predicting 30-Day Hospital Readmission for Diabetic Patients**

INSY 674 · Enterprise Data Science · McGill MMA · Group Project · February 2026

---

## Team

Feroz Khan · Matthieu Lafont · Henry Wolcott · Mustafa Yousaf

## Problem

Hospital readmissions within 30 days cost the U.S. healthcare system over $26 billion annually. Care-management resources (transition-of-care nurses, social workers, follow-up scheduling) are limited, so hospitals need a reliable way to prioritize which discharged patients most need intervention.

This project builds an end-to-end proof-of-value (PoV) pipeline that predicts 30-day readmission risk for diabetic patients, producing calibrated risk scores, risk tiers, and per-patient explanations.

## Dataset

**UCI "Diabetes 130-US Hospitals (1999–2008)"**
- 101,766 encounter-level records across 130 U.S. hospitals
- 50 raw features (demographics, utilization, clinical proxies)
- Binary target: 1 = readmitted within 30 days (~11.4%), 0 = otherwise
- Source: [UCI ML Repository](https://archive.ics.uci.edu/dataset/296/diabetes+130-us+hospitals+for+years+1999-2008)

## Results

| Model | PR-AUC | ROC-AUC | Recall@10% | Lift@10% | Brier |
|-------|--------|---------|------------|----------|-------|
| Heuristic (prior visits) | 0.172 | 0.607 | 20.3% | 2.03x | 0.106 |
| Logistic Regression | 0.205 | 0.646 | 21.8% | 2.18x | 0.231 |
| Random Forest | 0.208 | 0.659 | 21.6% | 2.16x | 0.214 |
| **XGBoost (final)** | **0.221** | **0.663** | **22.2%** | **2.21x** | **0.098** |

- **5-Fold CV**: PR-AUC 0.222 ± 0.012, ROC-AUC 0.667 ± 0.007
- **Risk Tiers**: High (22.7% readmit rate), Medium (12.8%), Low (6.8%)
- **Fairness**: No racial subgroup with ROC-AUC gap > 5pp

## Pipeline Phases

1. **Data Loading** — Read 101K encounters from CSV
2. **Data Cleaning & Leakage Prevention** — Remove death/hospice (2,423 rows), handle missing values, drop near-empty columns
3. **Feature Engineering** — ICD-9 grouping (18 categories), ordinal age, medication encoding, 5 derived features → 109 features
4. **Patient-Level Split** — GroupedStratifiedKFold, zero patient overlap between train/test
5. **Baselines** — Heuristic (prior visit ranking) + Logistic Regression
6. **Model Training** — Random Forest + XGBoost with 5-fold grouped CV
7. **Model Comparison** — Multi-criteria selection (PR-AUC primary)
8. **Calibration** — Isotonic regression, Brier from 0.215 → 0.098
9. **Risk Tiers** — Percentile-based Low/Medium/High with operational workflow
10. **SHAP Explanations** — Global feature importance + per-patient waterfall
11. **Fairness Audit** — ROC-AUC, PR-AUC, Recall@10% by race
12. **Visualizations** — 8-panel dashboard + SHAP plots
13. **Scored Output** — CSV with risk_probability, risk_tier, top_3_reasons
14. **Summary & Model Card**

## Repository Structure

```
readmission-risk-prediction/
├── README.md
├── LICENSE
├── requirements.txt
├── notebooks/
│   ├── 01_EDA.ipynb                       # Exploratory data analysis
│   └── Readmission_Risk_Pipeline.ipynb    # Full end-to-end pipeline
├── scripts/
│   └── download_data.sh                   # Fetches dataset from UCI
├── data/
│   ├── IDS_mapping.csv                    # Admission/discharge code mappings
│   └── raw/                               # Populated by download script (gitignored)
├── reports/
│   ├── model_comparison.csv
│   └── scored_outreach_list.csv
├── images/
│   ├── eda_dashboard.png
│   ├── full_dashboard.png
│   └── shap_waterfall_top3.png
└── docs/
    └── model_card.md
```

## Quick Start

```bash
git clone https://github.com/ferozobaid/readmission-risk-prediction.git
cd readmission-risk-prediction
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
bash scripts/download_data.sh
jupyter lab notebooks/Readmission_Risk_Pipeline.ipynb
```

## Key Design Decisions

- **Patient-level split**: All encounters for a given patient stay in the same fold to prevent leakage
- **Leakage removal**: Death/hospice discharge codes (11, 13, 14, 19–21) excluded — these patients cannot be readmitted
- **No oversampling**: Handled imbalance through PR-AUC as primary metric, threshold tuning, and XGBoost's scale_pos_weight
- **ICD-9 grouping**: 500+ raw diagnosis codes → 18 clinical categories to prevent sparse one-hot explosion
- **Isotonic calibration**: Improved Brier from 0.215 to 0.098, making risk tier thresholds meaningful
- **Race for auditing only**: Included in fairness analysis but recommended to exclude from production predictor

## Course Concepts Applied

| Course Module | Application in This Project |
|---|---|
| Enterprise DS Lifecycle | End-to-end pipeline from problem framing to scored output |
| Feature Engineering | ICD-9 grouping, ordinal encoding, derived features, missing indicators |
| Feature Selection | SHAP-based importance, zero-variance column removal |
| SOTA Classification | Logistic Regression, Random Forest, XGBoost comparison |
| Ensemble Learning | XGBoost (gradient boosted ensemble) as final model |
| Model Evaluation | PR-AUC, ROC-AUC, calibration, top-K metrics, fairness audit |
| Dimensionality Reduction | Clinical code grouping to reduce feature space |

## License

Code: MIT — see [LICENSE](LICENSE). Dataset: UCI ML Repository under CC BY 4.0.
Academic project — not for clinical production use without independent validation.
