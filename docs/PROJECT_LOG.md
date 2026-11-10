# Project Log

A running record of what was done, by whom, and why. **Newest entries at the top.** Add an entry whenever you finish a step, make a decision, or hit a problem the team should know about.

Format: date · who · what was done · decisions · outputs · next step.

---

## 2026-11-10 · Max (with Claude) · Team progress since Nov 6; TimesFM-3 hand-off
**Minji, `02a_seasonal_naive.ipynb` (Nov 6):** two honest baselines for all 12,196 products × 7 windows: `snaive` (same weekday last week) and `smean4` (average of the last 4 same weekdays). Test MAE: snaive 1.335, smean4 **1.172**, Chronos-2 1.026. Chronos-2 is ~23% better than snaive but only **~12% better than smean4**, the stronger baseline to quote.
**Correction (caught by Minji):** the "lag-7" baseline in the quick checks of 04a/04b used actual sales from inside the forecast window from day 8 on. It made the baseline look slightly better than an honest one, so the earlier "23%" figures were, if anything, conservative vs. snaive. Official comparisons should use 02a's baselines.
**James, `03_deepar.ipynb` (Nov 6):** DeepAR (neuralforecast, StudentT loss, 84-day input) smoke test on the 100-product sample, CPU, windows val_1/val_2/test. Test MAE 1.031 vs. Chronos-2's 1.012 on the same sample. Full run on GPU and the 4 backtest windows still to do.
**Hand-off:** Prateek is running the 04b TimesFM-3 full run on his local GPU instead of Colab. He must point `DRIVE_DIR` at his local Google Drive folder and confirm `Device: cuda`. Max still owns interpreting and presenting TimesFM-3.
**Open:** 05 scoring notebook (overdue, Claude writing next); 02 LightGBM owner to be confirmed.

## 2026-11-03 · Max (with Claude) · Chronos-2 full California run complete
**What:** Ran `04a_chronos2.ipynb` with `SAMPLE = False` on a free Colab T4. All 14 forecasts (2 runs × 7 windows) finished and saved to Drive `data/forecasts/` before Colab disconnected for inactivity.
**Coverage:** 12,196 products per window (12,175–12,190 in the earliest backtests, because a few products hadn't launched yet).
**Timing:** zero-shot ~2 min per window (~15 min total); with covariates ~12 min per window (~83 min total). About 1 h 40 min end to end.
**Results (quick check vs. "same weekday last week", not the official evaluation):**
| Window | Naive MAE | Chronos-2 zero-shot | Chronos-2 + covariates |
|---|---|---|---|
| val_1 | 1.275 | 0.986 (−23%) | 0.987 (−23%) |
| val_2 | 1.291 | 0.995 (−23%) | 0.993 (−23%) |
| test | 1.325 | 1.026 (−23%) | 1.028 (−22%) |
- Chronos-2 beats the naive baseline by a **steady 22–25% on every window**, the same as the sample run suggested.
- **Covariates still don't help** on the full data: within ±1% everywhere, slightly worse on most windows, and 6× slower. Now a solid finding rather than a sample fluke.
- Plot (`figures/10_chronos2_examples.png`): for the slow seller the median is **flat at zero** for all 28 days, even though the product sold on several of them. For the faster seller it tracks the weekly pattern well. This is the intermittency problem in one picture and the case for calibration.
**Next:** TimesFM-3 full run in its own session (~2.5–3 h). Notebook 05 (scoring) to produce the official comparison.

## 2026-11-03 · Max (with Claude) · Notebook 04b smoke test: TimesFM-3 works on the T4
**What:** Ran `04b_timesfm3.ipynb` with `SAMPLE = True` (100 products) on a free Colab T4 GPU. The real TimesFM-3 model downloaded (1.32 GB) and ran all 14 forecasts (2 runs × 7 windows) with no errors.
**Timing:** zero-shot ~2.3 s per window, with covariates ~9 s per window for 100 products. Estimate for all 12,196 products: ~35 min (zero-shot) + ~2.1 h (covariates) ≈ **2.5–3 hours of T4 time**, slower than Chronos-2.
**Early results (sample only, not the official evaluation):**
- TimesFM-3 beats "same weekday last week" by **21–30%** on every window, about the same as Chronos-2.
- TimesFM-3 vs. Chronos-2 is **close to a tie**: the two are within roughly ±3% of each other on every window. TimesFM-3 is slightly ahead on the test window (0.981 vs. 1.012 MAE, zero-shot).
- Adding prices and holidays again made **almost no difference** for either model.
- TimesFM-3's medians sit a bit higher than Chronos-2's for slow and medium sellers, but it shows the **same under-forecasting of spiky fast sellers** (median ~2–3 units/day against spikes of 10–40).
**Next:** full California run of 04a tonight (~1.5 h), then 04b full run in a separate session (~2.5–3 h).

## 2026-10-28 · Max (with Claude) · Notebook 04b: TimesFM-3 written
**What:** Wrote `notebooks/04b_timesfm3.ipynb`: Google's TimesFM-3 with the same two runs (zero-shot, with covariates) and the same 7 windows as 04a, so the two foundation models compare like for like.
**How the models get into the project:** neither model is built by us. Both are pretrained by their companies, downloaded from Hugging Face at run time, and used as-is. Our code handles the data, windows, inputs, saving and checks. Both are listed in `REUSE_LOG.md` and the README.
**Decisions:**
- Pinned `timesfm==3.0.2` (import `timesfm3.TimesFM3Forecaster`). Interface checked against the package source.
- Unlike Chronos-2, TimesFM-3 takes one array per product, and its covariates are single arrays covering history + the 28 future days. It returns a median and 9 percentiles but no mean, so its files have no `mean` column.
- `make_positive=True` so forecasts can't go below zero sales.
- Section 6 compares TimesFM-3 directly against Chronos-2 on the same products and days when both have run.
**Testing:** Logic tested with a stand-in model that enforces the real package's input rules. The real model has **not** run yet.
**Next:** Max runs 04b with `SAMPLE = True` on a T4, after (or alongside) the full Chronos-2 run.

## 2026-10-28 · Max (with Claude) · Notebook 04a smoke test: Chronos-2 works on the T4
**What:** Ran `04a_chronos2.ipynb` with `SAMPLE = True` (100 products) on a free Colab T4 GPU. The real Chronos-2 model downloaded (478 MB) and ran all 14 forecasts (2 runs × 7 windows) with no errors.
**Timing:** zero-shot ~1 s per window, with covariates ~5.7 s per window for 100 products. Estimate for all 12,196 products: ~15 min (zero-shot) + ~80 min (covariates) ≈ 1.5 hours of T4 time.
**Early results (sample only, not the official evaluation):**
- Chronos-2 beats "same weekday last week" by **21–29%** in mean absolute error on every window.
- Adding prices and holidays made **almost no difference** (within ±1–2 percentage points). Worth re-checking on the full data before drawing conclusions.
- The median forecast sits **well below average demand** for intermittent products (e.g. a fast seller forecast at ~2 units/day while its actual sales regularly hit 10–40). The median is the right point forecast for absolute error, but it under-forecasts totals, which matters for inventory. This is exactly what the calibration step and the quantile-based safety stock should address.
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
