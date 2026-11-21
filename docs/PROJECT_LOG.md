# Project Log

A running record of what was done, by whom, and why. **Newest entries at the top.** Add an entry whenever you finish a step, make a decision, or hit a problem the team should know about.

Format: date · who · what was done · decisions · outputs · next step.

---

## 2026-11-21 · Max (with Claude) · Final 06 run
**06 re-run with the Chronos-2 `calbias` fix (final version).** The fix worked: Chronos-2's per-group scales are now 1.05–1.68 (were capped at 3.0 for slow sellers), and `chronos2_zs_calbias` improved from MAE 1.122 to 1.089 with totals at 0.97 of actual. TimesFM-3 unchanged (scales 1.04–1.21; `calbias` MAE 1.086, totals 0.97).
Ensemble weights unchanged: Chronos-2 0.4 / TimesFM-3 0.6; DeepAR 0.0; LightGBM 0.0. 30 files saved (10 models × val_1, val_2, test). Figure `22_calibration_before_after.png` updated.
**Next:** 05 (running), then 04d/04c if they finish today, then 05 once more.

## 2026-11-20 · Claude · 05 made memory-light
**Why:** 05 crashed on Colab after using all its RAM: it loaded every window (including backtests) of ~25 models as text product IDs, plus all 5 years of sales.
**Fix:** 05 now reads only the scored windows (skips backtest files), stores product IDs as integer codes, uses 32-bit numbers, and loads only the sales dates it needs (28 days before val_1 through the test window). Same scores and logic; tested on fake data (pandas 2.2 and 3).

## 2026-11-20 · Max (with Claude) · Final 06 run, first pass; Chronos-2 calbias bug fixed
**06 ran on every model** (Chronos-2, TimesFM-3 zero-shot, DeepAR, LightGBM; 7 windows each). Older `timesfm3_cov_cal*` outputs moved to `forecasts/old_06_outputs/`.
- **Ensemble weights (all three target windows):** Chronos-2 0.4 / TimesFM-3 0.6 (was 0.2/0.8 with the covariate TimesFM run). **DeepAR 0.0 and LightGBM 0.0.** Weights are chosen on daily accuracy (MAE), where LightGBM loses (test 1.114 vs TimesFM-3 1.016); its strength is totals (forecast ÷ actual 0.92 vs 0.73), which MAE doesn't reward. So `ens_3` = `ens_lgbm` = `ens_fm`.
- **TimesFM-3 `calbias` now works for slow sellers:** scales 1.04–1.21 in every group, totals 0.97 of actual, test MAE 1.086.
- **Bug (Claude):** Chronos-2's saved `mean` column is the median (the library says so in `chronos2/pipeline.py`), so its `calbias` still hit the 3.0 cap for slow sellers. Fixed: `calbias` always scales the average of the 10th–90th percentiles. Max re-runs 06 then 05 for the final numbers.
- 06's quick check, test MAE: TimesFM-3 + calmae 1.014, ens_fm + calmae 1.015, TimesFM-3 1.016, ens_fm 1.017, Chronos-2 1.026, DeepAR 1.084, TimesFM-3 + calbias 1.086, lgbm 1.114.

## 2026-11-19 (night) · Prateek (with Claude) · `lgbm_cov` done: LightGBM forecasts slow sellers
**What:** Ran Elena's `02_lightgbm.ipynb` for `lgbm_cov` (with prices/holidays), all 7 windows, locally on a laptop CPU (Ryzen 7 5800H, 8 cores): **27 min total**, ~3.5 min per window (free Colab: ~20 min per window). Replaced Elena's 2 Colab windows (`bt_3`, `bt_4`) in Drive so all 7 come from one run. CPU on purpose, matching Elena's `lgbm` run, so the two LightGBM runs differ only by covariates. Executed notebook with run notes: `notebooks/02_lightgbm_cov_fullCA.ipynb`; local scripts in `scripts/02_local_windows/`. Model code and settings unchanged.
**Test window (quick check; official numbers from 05):** MAE **1.104**, 6% better than `smean4` (1.172) but behind TimesFM-3 zero-shot (1.016), Chronos-2 zero-shot (1.026) and DeepAR (1.084).
**Main finding: total demand, especially slow sellers.** Compared with actual sales and with TimesFM-3 zero-shot on the test window:
| Sales speed | MAE lgbm_cov | MAE TimesFM-3 | Units forecast ÷ sold, lgbm_cov | Units forecast ÷ sold, TimesFM-3 |
|---|---|---|---|---|
| Slow | 0.434 | 0.331 | **84%** | 17% |
| Medium | 0.843 | 0.788 | **90%** | 56% |
| Fast | 2.035 | 1.928 | **95%** | 83% |
| All | 1.104 | 1.016 | **93%** | 73% |
LightGBM (Tweedie loss) forecasts small realistic amounts for slow sellers instead of ~0, so it loses on MAE but is much closer on totals. Supports routing slow sellers to LightGBM in 06, judged on bias, coverage and safety stock as well as MAE.
**Feature importance** (`figures/12_lgbm_feature_importance.png`): 112- and 56-day sales averages ~70% of gain, `item_id` ~10%; the top price feature ~1%, Christmas less. Covariates add almost nothing, consistent with Chronos-2 and TimesFM-3.
**Next:** Max's final 06 → 05 now has every LightGBM file.

## 2026-11-19 (evening) · Elena, Max (with Claude) · LightGBM in; added to the ensemble
**`notebooks/02_lightgbm.ipynb` (Elena, pushed 4 PM).** One global LightGBM per window, trained on the 2 years before it; every sales feature at least 28 days old, so one model forecasts all 28 days with no peeking; Tweedie loss (standard for M5's zero-heavy counts). Price features use past prices only (`price_ratio_28` = price ÷ average of the previous 28 days), so no look-ahead. **Status:** `lgbm` (sales only) done for all 7 windows and in Drive (~20 min per window on free Colab); `lgbm_cov` (with prices/holidays) handed to Prateek to finish locally. Claude reviewed the notebook read-only: file names, columns and windows match the shared format, so 05 scores it with no changes.
**06 (Claude):** new `ens_lgbm` = Chronos-2 + TimesFM-3 + LightGBM, weights chosen on earlier windows, plus `ens_lgbm_calbias`. Uses the sales-only `lgbm`, matching the zero-shot foundation models (sales history only). Tested on fake data (pandas 2.2 and 3). Labels added in 05.
**Next:** Max runs 04c/04d tonight; final 06 → 05 once `lgbm_cov` lands (or without it, then re-run).

## 2026-11-19 · Max (with Claude) · Few-shot notebook, leak fix, range score
**Why:** Dr. Ghosh asked for few-shot with the time-series models; a review of 01 found a small look-ahead in a price feature; and average miss (MAE) can't show what inventory needs.
1. **New `notebooks/04d_chronos2_fewshot.ipynb`.** Few-shot = in-context learning: Chronos-2 forecasts 100 related products together (`cross_learning=True`), no training. Products are sorted by ID, so each batch is the same item in the 4 stores plus nearby items in the same department. Output `chronos2_fs_<window>.parquet` (val_1, val_2, test); section 6 compares it with zero-shot overall, by sales speed, and for products with under a year of history. Gives the slides a ladder: zero-shot (04a) → few-shot (04d) → fine-tuned (04c). TimesFM-3 is left out: we couldn't confirm the public 3.0 package supports few-shot.
2. **Look-ahead in `price_ratio` (01).** It divides each day's price by the product's mean price over the full dataset, test window included. It affects only the covariate runs (`chronos2_cov`, `timesfm3_cov`). Since covariates gained just ~0.2%, 06 now builds on the zero-shot runs (`chronos2_zs`, `timesfm3_zs`), and the headline model is TimesFM-3 zero-shot. 06 moves older outputs it no longer makes (e.g. `timesfm3_cov_calmae`) into `forecasts/old_06_outputs/` so 05 doesn't score them; nothing is deleted. **Elena:** compute any price ratio in LightGBM against past prices only (e.g. trailing 28-day average).
3. **05 section 8b: quantile loss.** Grades the 10th–90th percentile range for models that save percentiles, plus an 80%-range hit rate. Turns the "best accuracy ≠ best for stocking" lesson into a number.
Tested end to end on fake data (pandas 2.2 and 3); 04d with a stand-in for the model.

## 2026-11-18 (night) · Claude (for Max) · Safety-stock method fixed (05); slow-seller fix (06)
**Why:** the Nov 18 run showed the foundation models' buffers ~$27k cheaper than the baseline's but covering only 65–71% of weeks (baseline 88%), so the dollar comparison wasn't fair; and `calbias` couldn't lift slow sellers off zero.
**05, section 8 (approved by Max):** buffers are now sized in weeks, on val_1 + val_2. Per product and model: safety stock = average weekly shortfall (the bias) + *k* × spread of weekly shortfalls, floored at 0. *k* is chosen per model so every model covers 95% of validation product-weeks; the test window then checks whether that holds on unseen weeks. Dollars are compared at equal service. The old method (1.65 × daily spread × √7) stays as a reference table to explain the change. Chart labels added for the 06 models; the speed chart shows raw models only.
**06, `calbias`:** now scales the model's average forecast (Chronos-2's `mean` column; for TimesFM-3 the average of its 10th–90th percentiles) instead of the median. DeepAR-only mixes (`ens_3_calbias`) still use the median, since DeepAR has no percentiles.
**Testing:** both notebooks run end to end on fake M5-shaped data on pandas 2.2 and 3. On fake data, every model lands at 95% coverage on validation and 90–93% on test, so the method behaves as intended. Real numbers come from the final run.
**04c fix:** Colab's preinstalled `torchao` 0.10 made `peft` refuse to load; the install cell now removes it.
**Next:** Max's final run after Elena's LightGBM lands (06, then 05).

## 2026-11-18 (later) · Max (with Claude) · Official results: 05 re-run with 15 models
**What:** 05 on everything in Drive except LightGBM and the fine-tuned model: baselines, Chronos-2 ×2, TimesFM-3 ×2, DeepAR, and the 8 calibrated/ensemble versions from 06. The fairness rule dropped 0.1% of rows (products DeepAR skips), so every model is scored on the same 12,190 test products.
**Test window, official:**
| Model | MAE | Sales-weighted MAE | Bias | vs 4-wk avg | Safety stock $ | Weeks covered |
|---|---|---|---|---|---|---|
| TimesFM-3 + `calmae` | **1.013** | **2.096** | −0.457 | +14% | $254,061 | 67.3% |
| TimesFM-3 + covariates | 1.014 | 2.097 | −0.429 | +13% | $253,650 | 69.7% |
| Ensemble FM (`ens_fm`, = `ens_3`) | 1.014 | 2.102 | −0.436 | +13% | $253,641 | 69.4% |
| TimesFM-3 zero-shot | 1.016 | 2.104 | −0.410 | +13% | $254,747 | 71.2% |
| Chronos-2 zero-shot | 1.026 | 2.157 | −0.468 | +12% | $255,406 | 67.9% |
| DeepAR | 1.084 | 2.368 | −0.589 | +8% | $261,033 | 65.3% |
| TimesFM-3 + `calbias` | 1.094 | 2.399 | −0.082 | +7% | $258,196 | 75.7% |
| Naive, 4-week average | 1.172 | 2.419 | −0.050 | 0% | $280,523 | 88.0% |
| Naive, last week | 1.335 | 2.725 | −0.067 | −14% | $341,179 | 89.6% |
- TimesFM-3 wins every category and sales-speed group; the foundation models beat the 4-week baseline by 12–14%, DeepAR by 8%.
- **Safety stock is the weak spot:** the models' buffers are ~$27k cheaper than the baseline's but cover only 65–71% of weeks vs. 88%. `calbias` lifts coverage to ~76%, still short. The buffer method (1.65 × daily error spread × √7) ignores the models' low bias and assumes independent daily errors, so the dollar comparison isn't apples to apples. Proposed fix: size each buffer from the 95th percentile of weekly shortfalls on val_1/val_2 (includes bias), then compare dollars at equal coverage.
- Chart labels for the new 06 models show raw names (`ens_fm`, `timesfm3_cov_calmae`); to tidy before the final run.
**Figures:** `20_test_mae_by_model.png`, `21_test_mae_by_speed.png` updated.

## 2026-11-18 · Max (with Claude) · 06 run on real data; fine-tuning experiment written
**06 results (its own quick summary; official scores come from 05), test window:**
| Model | MAE | Forecast ÷ actual units |
|---|---|---|
| TimesFM-3 + covariates | 1.014 | 0.72 |
| TimesFM-3 + `calmae` | 1.013 | 0.70 |
| Ensemble Chronos-2 + TimesFM-3 (`ens_fm`) | 1.014 | 0.71 |
| 3-model ensemble with DeepAR (`ens_3`) | 1.014 | 0.71 |
| Chronos-2 zero-shot | 1.026 | 0.69 |
| DeepAR | 1.084 | 0.61 |
| TimesFM-3 + `calbias` | 1.094 | 0.95 |
- Ensemble weights: 0.8 TimesFM-3 / 0.2 Chronos-2 in every window; **DeepAR got 0.0 weight** in every window, so `ens_3` = `ens_fm`.
- `calmae` barely moves anything: the median was already the best percentile in almost every group; only the zero cutoff changed.
- `calbias` fixes totals (72% → 95% of actual) at ~8% higher daily error. For slow sellers the scale hit its 3.0 cap in every category, because their median is ~0 and scaling zero does nothing (figure `22_calibration_before_after.png`, top panel). Proposed fix: scale the mean forecast instead.
**New: `notebooks/04c_chronos2_finetune.ipynb` (Claude).** LoRA fine-tuning of Chronos-2 with the library's own `Chronos2Pipeline.fit`, retrained per window on history before that window only (val_1, val_2, test). Output `chronos2_ft_<window>.parquet`, scored by 05 automatically; section 6 compares it with zero-shot on the same products. Tested on fake data with stub modules (the model can't be downloaded in Claude's workspace), so the first real test is Max's 100-product smoke run. Timeboxed: if it isn't done by Sat Nov 21 it becomes future work.
**Still pending:** the new 05 run (not yet in Project Code); Elena's LightGBM (Thu Nov 19).

## 2026-11-15 · Max (with Claude) · Status update: TimesFM-3 and DeepAR in Drive, 3-model ensemble added, LightGBM owner named
**Why this entry:** a catch-up for anyone who lost track. Short version: every model except LightGBM is finished and in Drive; the next step is for Max to run 06 then 05.

**1. TimesFM-3 files uploaded (Prateek, Nov 14).** The 14 `timesfm3_{zs,cov}_<window>.parquet` files from his Nov 10 run are now in Drive `data/forecasts/`. Until now, 05 and 06 couldn't use them.

**2. DeepAR full run finished (James, Nov 13).** Notebook `notebooks/03_deepar_fullCA_with_backtests.ipynb` (on GitHub). All 7 windows, including the 4 backtests, so DeepAR can join the ensemble. Ran on CPU, about 10 minutes per window (~70 min total). Sales history only (no prices or holidays), 84-day input, 2-layer LSTM, Student-t loss.

| Window | bt_4 | bt_3 | bt_2 | bt_1 | val_1 | val_2 | test |
|---|---|---|---|---|---|---|---|
| DeepAR MAE (James's scoring) | 0.982 | 0.961 | 1.016 | 1.030 | 1.035 | 1.053 | **1.085** |
| Products | 12,122 | 12,141 | 12,158 | 12,175 | 12,177 | 12,185 | 12,190 |

- On the test window, DeepAR beats both baselines (1.172 and 1.335) but trails Chronos-2 (1.026) and TimesFM-3 (1.014) by 6–7%. Official comparison comes from 05.
- It skips a few late-launch products that don't have 84 days of history (6 on the test window). 05's fairness rule then scores **every** model on the same products, so official numbers for the other models may move by a hair compared with Nov 13.
- File names differ from the convention (`deepar_bt1`, `deepar_val1` rather than `deepar_bt_1`, `deepar_val_1`). 05 reads them fine because it uses the `window` column inside each file; 06 now handles the names too (below). No change needed from James.

**3. Notebook 06 updated (Claude, Nov 15).** Adds a **3-model ensemble**: Chronos-2 + TimesFM-3 + DeepAR.
- `ens_3`: weighted average of the three medians. Weights (0 to 1 in steps of 0.1, summing to 1) are chosen on earlier windows, the same no-peeking rule as the rest of 06.
- `ens_3_calbias`: `ens_3` scaled per group so totals match actual sales.
- No `calmae` version, because DeepAR doesn't produce percentiles.
- Why add DeepAR: the two foundation models are both pretrained transformers and make similar mistakes; DeepAR is trained only on our data, so its errors should overlap less, which is what makes averaging pay off. 06 prints the chosen weights, so we'll see how much DeepAR actually contributes.
- Also: 06 now reads DeepAR's file names and sets any negative forecast to 0.
- Tested end to end on fake M5-shaped data (pandas 2.2 and 3); 05 then scored all 15 models with no changes. Commit `f9ed4df`.

**4. LightGBM owner: Elena.** She's writing and running `02_lightgbm` (sales-only and +prices/holidays, all 7 windows, shared file format), due Tue Nov 17. Once it exists, Claude adds the hybrid model and the LightGBM ensemble to 06.

**5. Roles updated** in `docs/TEAM.md` to match who is actually doing what. Open question: who writes the results and business-impact section, which Elena had before taking LightGBM.

**Next:**
1. Max: open `06_post_processing.ipynb` fresh from GitHub in Colab (CPU runtime, `SAMPLE = False`), run all; then the same for `05_evaluation.ipynb`. Download both into Project Code so they get committed.
2. Elena: LightGBM by Nov 17.
3. Team: pick an owner for the results/business-impact write-up.

## 2026-11-13 · Max (with Claude) · First official results (05_evaluation)
**What:** Ran `05_evaluation.ipynb` on Colab (CPU) with the forecasts in Drive so far: `snaive`, `smean4` (Minji) and `chronos2_zs`, `chronos2_cov` (Max). All 12,196 products, no rows dropped by the fairness rule. TimesFM-3 not yet included (files not yet in Drive).
**Results, test window (Apr 25 – May 22, 2016):**
| Model | MAE | Sales-weighted MAE | Bias (units/day) |
|---|---|---|---|
| Chronos-2 zero-shot | **1.026** | **2.156** | −0.468 |
| Chronos-2 + covariates | 1.028 | 2.156 | −0.459 |
| Naive, 4-week average | 1.172 | 2.418 | −0.050 |
| Naive, last week | 1.335 | 2.724 | −0.067 |
- Chronos-2 is **12% better than the 4-week-average baseline** (23% vs. last-week naive) in MAE, and ~11% better in sales-weighted MAE.
- It wins in **every category** (Foods 1.32 vs 1.48, Hobbies 0.75 vs 0.89, Household 0.77 vs 0.90) and **every sales-speed group**. Biggest relative gain on slow sellers (0.33 vs 0.44, ~25%); ~10–11% on fast and medium.
- **Bias:** Chronos-2 runs low by ~0.47 units per product per day; the baselines are nearly unbiased.
- **Safety stock:** Chronos-2's buffer is **$25k cheaper** than the 4-week-average baseline ($256k vs $281k), **but it covered only 68% of test weeks** vs. 88% for the baseline. The buffer is sized from the error spread and doesn't correct the low bias, so the cheaper number is misleading on its own. This is the clearest case for the `calbias` calibration in 06. Even the baselines fall short of the 95% target (88–90%), suggesting errors are not independent day to day; worth noting as a limitation.
**Fix:** the error-by-speed chart drew both baselines in the same grey; the notebook now uses two greys (takes effect on the next run). Chart `figures/20_test_mae_by_model.png` added.
**Next:** TimesFM-3 files into Drive → run 06 → re-run 05.

## 2026-11-13 · Claude (for Elena/Max) · Notebook 06: calibration and foundation-model ensemble written
**Why:** the "beyond zero-shot" step. Both foundation models' medians run ~27% low in total and predict flat zero for slow sellers.
**What:** `notebooks/06_post_processing.ipynb` creates six new models from `chronos2_zs` and `timesfm3_cov` (the best run of each):
- `<model>_calmae`: for each of 9 groups (category × sales speed), picks the percentile (10th–90th) and a zero cutoff (0, 0.25, 0.5) with the lowest MAE on earlier windows. Goal: lower error.
- `<model>_calbias`: for each group, scales the median so total forecast units match total actual units on earlier windows (scale capped at 0.5–3.0). Goal: unbiased totals for inventory.
- `ens_fm`: weighted average of Chronos-2 and TimesFM-3 (median and every percentile), weight chosen on earlier windows from 0.0–1.0 in steps of 0.1. `ens_fm_calmae`: the ensemble plus the `calmae` correction.
**No peeking:** rolling origin. Corrections for val_1 are learned from the 4 backtests, val_2 adds val_1, test adds val_2. Christmas Day is excluded from every fit. The notebook prints the chosen percentiles, cutoffs, scales and ensemble weights so they can be quoted in the blog.
**Outputs:** new files in the shared format in `data/forecasts/` (val_1, val_2, test), so 05 scores them automatically; figure `22_calibration_before_after.png`.
**Testing:** run end to end on the fake M5-shaped data on pandas 2.2 and 3; 05 then scored all 13 models with no changes. Not yet run on real forecasts.
**Waiting on:** TimesFM-3 files in Drive (without them, 06 calibrates Chronos-2 only and skips the ensemble). LightGBM hybrid and LightGBM ensemble get added after `02_lightgbm`.
**Next:** Elena runs 06 then re-runs 05.

## 2026-11-10 · Prateek (with Claude) · TimesFM-3 full California run complete (local GPU)
**What:** Ran `04b_timesfm3.ipynb` with `SAMPLE = False` on a local Windows PC with an RTX 4070 (12 GB) instead of Colab. All 14 forecasts (2 runs × 7 windows) finished with no errors. Executed notebook with outputs and run notes: `notebooks/04b_timesfm3_fullCA.ipynb`.
**Coverage:** 12,196 products per window (12,175 to 12,190 in the earliest backtests, the same products Chronos-2 skipped).
**Timing:** zero-shot ~2.2 min per window (15.5 min), with covariates ~5.8 min per window (41 min). **58 minutes total**, vs. ~2.6 h estimated for a T4. Batch size 32 throughout, no out-of-memory retries.
**Local setup (model code unchanged):** conda env with Python 3.11, PyTorch 2.11 (CUDA 12.8), `timesfm` 3.0.2. `DRIVE_DIR` points at a local copy of the Drive `data/` folder; `SAMPLE`/`BATCH_SIZE` are switched by environment variables from two run scripts; `KMP_DUPLICATE_LIB_OK=TRUE` avoids a Windows OpenMP crash at the plotting step. Scripts and the clean local notebook are in `scripts/04b_local_windows/`. The 100-product test on the 4070 reproduced Max's Colab MAE values exactly (3 decimals, all 14 windows), so local and Colab results are comparable.
**Results (quick check, not the official evaluation; section 6's lag-7 naive leaks as noted above, so only the model columns are quoted):**
| Window | Chronos-2 zero-shot | TimesFM-3 zero-shot | Chronos-2 + cov | TimesFM-3 + cov |
|---|---|---|---|---|
| val_1 | 0.986 | 0.984 | 0.987 | 0.974 |
| val_2 | 0.995 | 0.991 | 0.993 | 0.981 |
| test | 1.026 | 1.016 | 1.028 | 1.014 |
- TimesFM-3 is **0.2% to 1.4% better** than Chronos-2 on every window compared: effectively a tie.
- **Covariates help TimesFM-3 slightly** (0.2% to 1.3% lower MAE on all 7 windows), unlike Chronos-2.
- Extra checks on the test window: total forecast units are **73% of actual** (72% with covariates), so the median under-forecasts by ~27%, like Chronos-2. The 10th to 90th percentile range contains **83% to 85%** of actual sales (target 80%): the quantiles are well calibrated, useful for safety stock.
- Plot (`figures/11_timesfm3_examples.png`): flat-zero median for the slow seller (it sold on 5 of 28 days); weekly pattern captured for the fast seller but peaks too low (~3 vs 4 to 6 units).
**Outputs (Drive `data/forecasts/`):** `timesfm3_{zs,cov}_{bt_4,bt_3,bt_2,bt_1,val_1,val_2,test}.parquet`, `run_log.csv`.
**Next:** re-run `05_evaluation.ipynb` so TimesFM-3 is in the official scores and safety-stock dollars.

## 2026-11-10 · Claude (for Elena/Max) · Notebook 05: official scoring written
**What:** Wrote `notebooks/05_evaluation.ipynb`, which scores every forecast file in `data/forecasts/` the same way.
**Reports:** MAE, sales-weighted MAE (M5-style: weight = a product's dollar sales in the 28 days before the window), bias, improvement vs. both baselines (`smean4` is the one to quote), breakdowns by category and sales speed on the test window, and safety-stock dollars.
**Decisions:**
- **Fair comparison:** within each window, every model is scored only on the product-days that all models forecast.
- **Safety stock** is sized from each model's errors on val_1 + val_2 (never the test window): 1.65 × std of daily error × √7, times the product's average test-window price. A **coverage check** then tests whether actual weekly demand ≤ weekly forecast + buffer on the 4 test weeks (target ≈ 95%).
- Reads DeepAR's file format (extra `actual` column, label "DeepAR") without changes to 03.
- Finds the Drive folder automatically (works whether the shortcut is in My Drive or inside another folder, as for Minji). Writes CSVs to `data/results/` and charts to `data/figures/`.
**Testing:** Logic tested on the fake M5-shaped dataset with all 7 model types, including files shaped like 02a's and 03's; runs without errors on pandas 2.2 and 3. Not yet run on real forecasts.
**Next:** run with `SAMPLE = False` on CPU. It will score whatever exists now (snaive, smean4, Chronos-2 ×2) and should be re-run once TimesFM-3 (Prateek) and DeepAR full (James) land.

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
