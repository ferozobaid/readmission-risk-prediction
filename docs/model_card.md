# Model Card: 30-Day Readmission Risk Prediction

## Model Details
- **Model type:** XGBoost (Gradient Boosted Trees)
- **Task:** Binary classification — predict 30-day hospital readmission
- **Dataset:** UCI Diabetes 130-US Hospitals (1999–2008), 99,340 encounters after cleaning
- **Features:** 109 features (demographics, utilization, encounter context, clinical proxies)
- **Target prevalence:** 11.39%

## Performance (Test Set)
- ROC-AUC: 0.6631
- PR-AUC: 0.2152
- Brier Score: 0.0976
- Recall@10%: 0.2218
- Precision@10%: 0.2528
- Lift@10%: 2.22x

## CV Stability
- PR-AUC: 0.2217 ± 0.0116
- ROC-AUC: 0.6669 ± 0.0065

## Intended Use
Score discharged diabetic patients for 30-day readmission risk.
Output: risk probability (0–1), risk tier (Low/Medium/High), top-3 SHAP-based reasons.

## Limitations
- Data is from 1999–2008; clinical practices have changed.
- Uses ICD-9 codes; modern systems use ICD-10.
- Proof-of-Value only; not validated for production deployment.
- ~97% missing weight data (column dropped).

## Fairness
- Race used for auditing only, not as a predictor in recommended deployment.
- Subgroup metrics computed by race; see fairness_audit section in pipeline output.
