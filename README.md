# Forecasting Walmart Demand: Gradient Boosting, Deep Learning, and Foundation Models

Term project for Advanced Deep Learning + ML (Prof. Ghosh), UT Austin McCombs, Fall 2026.

**Team:** Max Volle, James Rainey, Elena Reyes, Minji Kim, Prateek Bolandanda

## Question
Can pretrained time series foundation models (Amazon's Chronos-2 and Google's TimesFM-3) forecast Walmart demand as well as the gradient boosting approach that won the M5 competition, and a deep learning model we train ourselves (DeepAR)? Can post-processing beyond zero-shot (calibration, a hybrid residual model, ensembling) close the gap? What is the difference worth in safety-stock dollars?

See [`docs/TEAM.md`](docs/TEAM.md) for roles, the experiment grid and deadlines.

## Data
[M5 Forecasting – Accuracy](https://www.kaggle.com/competitions/m5-forecasting-accuracy/data) (Walmart, via Kaggle). We use California's 4 stores, about 12,000 product-store series, January 2011 to May 2016.
The data is **not** stored in this repo (size limits and Kaggle's terms). Download the three CSVs from Kaggle and place them in the team Drive folder `AML_Term_Project/raw/`.

## How to reproduce
Run the notebooks in order in Google Colab. Each one reads from and writes to the shared Drive folder.

| # | Notebook | What it does | Runtime |
|---|---|---|---|
| 01 | `notebooks/01_data_prep.ipynb` | Clean California data, windows, sales-speed groups, EDA charts | CPU, ~10 min |
| 02 | `notebooks/02_baseline_lightgbm.ipynb` | Seasonal naive + winner-style LightGBM (two runs) + hybrid residual model | CPU |
| 03 | `notebooks/03_deepar.ipynb` | DeepAR | GPU |
| 04 | `notebooks/04_foundation_models.ipynb` | Chronos-2 and TimesFM-3, zero-shot and with covariates | GPU |
| 05 | `notebooks/05_evaluation.ipynb` | Scoring, calibration, hybrid + ensemble, safety-stock dollars | CPU |

Library versions are pinned in `requirements.txt`. Random seeds are fixed at 42.

## Shared conventions
- **Data:** `unique_id, ds, y` (+ price/calendar columns), from `ca_sales.parquet`
- **Windows:** read dates from `windows.json`; never tune on the `test` window
- **Forecast files:** `forecasts/<model>_<window>.parquet` with columns `unique_id, ds, model, window, forecast`

## Results
_To be added._

## Code reuse and LLM use
See [`REUSE_LOG.md`](REUSE_LOG.md).
