# Project Log

A running record of what was done, by whom, and why. **Newest entries at the top.** Add an entry whenever you finish a step, make a decision, or hit a problem the team should know about.

Format: date · who · what was done · decisions · outputs · next step.

---

## 2026-10-28 · Max (with Claude) · Notebook 04a smoke test: Chronos-2 works on the T4
**What:** Ran `04a_chronos2.ipynb` with `SAMPLE = True` (100 products) on a free Colab T4 GPU. The real Chronos-2 model downloaded (478 MB) and ran all 14 forecasts (2 runs × 7 windows) with no errors.
**Timing:** zero-shot ~1 s per window, with covariates ~5.7 s per window for 100 products. Estimate for all 12,196 products: ~15 min (zero-shot) + ~80 min (covariates) ≈ 1.5 hours of T4 time.
**Early results (sample only, not the official evaluation):**
- Chronos-2 beats "same weekday last week" by **21–29%** in mean absolute error on every window.
- Adding prices and holidays made **almost no difference** (within ±1–2 percentage points). Worth re-checking on the full data before drawing conclusions.
- The median forecast sits **well below average demand** for intermittent products (e.g. ~2 units/day for a product averaging ~7 with big spikes). The median is the right point forecast for absolute error, but it under-forecasts totals, which matters for inventory. This is exactly what the calibration step and the quantile-based safety stock should address.
**Process note:** Colab's "Save a copy in GitHub" first saved to the wrong repo (F1-explainer). New routine: download the notebook into *Project Code*; Claude commits it to this repo.
**Next:** run with `SAMPLE = False` for all of California (~1.5 h on T4).

## 2026-10-28 · Max (with Claude) · Notebook 04a: Chronos-2 written
**What:** Wrote `notebooks/04a_chronos2.ipynb`, which forecasts every California series with Amazon's Chronos-2 in two modes: zero-shot (sales history only) and with known-future covariates (price, discount ratio, SNAP, events, Christmas).
**Decisions:**
- Pinned `chronos-forecasting==2.3.2`. Interface checked against the package source (`Chronos2Pipeline.predict_df`).
- Point forecast = the model's **median** (the 0.5 quantile), since we score with absolute error. Mean and all 9 quantiles are also saved for safety-stock work.
- Forecast **7 windows**: 4 backtests + val_1 + val_2 + test. Backtests give Prateek's hybrid residual model training data; validation windows feed Elena's calibration and ensemble.
- Backtest windows are the four 28-day blocks right before val_1 (see `docs/TEAM.md`). Every notebook derives them the same way from `windows.json`.
- Series that launched after a window starts are skipped for that window (no history to forecast from).
- Results save one file per run per window, and the notebook skips files that already exist, so a Colab disconnect doesn't lose finished work.
**Testing:** Logic tested on a fake M5-shaped dataset with a stand-in model (Hugging Face is blocked from Claude's workspace, so the real weights couldn't be downloaded). The real model has **not** run yet.
**Next:** Max runs the notebook on the 100-product sample (`SAMPLE = True`) on a T4 GPU, then on all of California.

## 2026-10-28 · Max (with Claude) · Plan updated after outline feedback
**What:** Outline scored 3.8/4. Updated `docs/TEAM.md` and `README.md` with the professor's three requests: study the top M5 solutions but add our own idea, evaluate TimesFM-3 alongside Chronos-2, and go beyond zero-shot.
**Decisions:** Added TimesFM-3; added post-processing (calibration, hybrid residual model, ensemble); proposed new role split (Minji takes repo/blog assembly + M5 summary since data prep is done; Max takes both foundation models). Roles to be confirmed at the next check-in.
**Access:** Drive folder and GitHub repo shared with all teammates.

## 2026-10-23 · Team · Outline submitted
Submitted the 2-page outline. Feedback received Oct 25 (see `docs/TEAM.md`).

## 2026-10-21 · Max (with Claude) · Data prep complete, repo created
**What:** Ran `notebooks/01_data_prep.ipynb` on the real Kaggle data in Colab (CPU).
**Results:** 12,196 California series; 18.6M rows after dropping 5.1M pre-launch rows (22%); dates 2011-01-29 → 2016-05-22; no missing sales or prices. Median product sells nothing on 60% of days.
**Decisions:** Windows: val_1 Feb 29 – Mar 27, val_2 Mar 28 – Apr 24, test Apr 25 – May 22, 2016. Sales-speed groups = thirds of average daily sales before val_1. Added a sales-weighted error to the evaluation plan because of all the zeros.
**Outputs (Drive `AML_Term_Project/data/`):** `ca_sales.parquet`, `ca_static.parquet`, `ca_sample100.parquet`, `windows.json`, `figures/`.
**Setup:** Created Drive folder `AML_Term_Project` and GitHub repo `vollemax-lgtm/walmart-demand-forecasting`.
