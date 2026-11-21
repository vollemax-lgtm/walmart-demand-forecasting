# Master Checklist

Last updated: **Sat Nov 21, 2026**. Tick items as they finish. Details for each finished item are in `docs/PROJECT_LOG.md`.

## Status at a glance (Fri Nov 20)

**Where we are:** every planned model is finished: baselines, Chronos-2, TimesFM-3, DeepAR and both LightGBM runs are all in Drive. The one big step left before the freeze is **Max's final run (06, then 05)**, which turns everything into the official numbers. The two Chronos-2 extras (few-shot, fine-tuned) are optional and stop Saturday if not done.

**Results so far:** TimesFM-3 is the most accurate (13% less error than the 4-week-average baseline), Chronos-2 close behind; DeepAR 8% better than the baseline; LightGBM with prices 6% better (quick check). But LightGBM gets **total units much closer to actual** (93% vs TimesFM-3's 73%; slow sellers 84% vs 17%), which matters for stocking shelves.

| | What | Who | When |
|---|---|---|---|
| ✅ Done | Data prep, baselines | Minji | Oct 21, Nov 6 |
| ✅ Done | Chronos-2 and TimesFM-3 full runs | Max, Prateek | Nov 3, Nov 10 |
| ✅ Done | DeepAR full run, 7 windows | James | Nov 13 |
| ✅ Done | LightGBM sales-only (`lgbm`) and with prices/holidays (`lgbm_cov`), 7 windows each | Elena; Prateek ran `lgbm_cov` | Nov 19 |
| ✅ Done | 06 ready with every ensemble (+ DeepAR, + LightGBM), fair safety-stock comparison, leak fix, range score | Claude | Nov 18–19 |
| ✅ Done | **Final run: 06, then 05** (20 models scored). Headline: TimesFM-3 13% more accurate than baseline; with the totals correction it needs $27k (8.5%) less safety stock at the same service level | Max | Nov 21 |
| ✅ Done | Few-shot Chronos-2 (`04d`) scored: slightly worse than zero-shot (1.036 vs 1.026). Notebook still to save to Project Code | Max | Nov 21 |
| ◐ Optional | Fine-tuned Chronos-2 (`04c`); if done today, re-run 05 only | Max | stop Sat Nov 21 |
| ⏳ Sat | Final results table in plain language, safety-stock $, confidence ranges, charts; docs updated | Claude | Sat Nov 21 |
| ⏳ Sun | **Results freeze**; everyone's blog section drafted | everyone | Sun Nov 22 |
| ⏳ Mon–Tue | Slides (2–3 each) + timed rehearsal (15 min + 3 min Q&A) | everyone | Nov 23–24 |
| ⏳ Later | Blog assembled (Minji, Nov 29); README, pinned versions, LLM statement, repo public; submit + peer evals | team | by Mon Dec 7 |

**Open decisions:**
1. **Who writes the results and business-impact section?** (suggestion: James or Prateek)
2. **Hybrid model:** still wanted, and who builds it? Without it, LightGBM's role is its own score plus the ensemble.
3. ~~Slow sellers → LightGBM?~~ **Settled: no.** LightGBM's better totals don't beat corrected TimesFM-3 on safety stock ($317k vs $292k).
4. Rehearsal time.

## How the notebooks connect
```
01 data prep ─► 02a baselines ─┐
               02 LightGBM ────┤   (lgbm + lgbm_cov)
               03 DeepAR ──────┤
               04a Chronos-2 ──┤   (+ 04c fine-tuned, 04d few-shot)──► forecast files in Drive data/forecasts/
               04b TimesFM-3 ──┘           │
                                           ▼
                    06 post-processing (calibration + ensembles) ──► more forecast files
                                           │
                                           ▼
                    05 evaluation: scores every file ──► results tables, charts, safety-stock $
```
06 must run **before** 05, so 05 scores the calibrated and ensemble forecasts too.

---

## Finish plan (agreed order, from Nov 13; updated Nov 15)

### Phase 1 · Finish the forecasts (by Wed Nov 18)
1. [x] Upload the 14 `timesfm3_*.parquet` files to Drive `data/forecasts/` (Prateek, Nov 14)
2. [x] Run `05_evaluation` on what exists → first official results table (Max, Nov 13: baselines + Chronos-2)
3. [x] Name the LightGBM owner: **Elena** (Nov 15)
4. [x] LightGBM: sales-only ✅ (Nov 19, Elena), +prices/holidays ✅ (Nov 19, Prateek), all 7 windows each, saved in the shared file format
5. [x] DeepAR full run **including the 4 backtest windows** (James, Nov 13; ran on CPU, ~10 min per window). Notebook: `notebooks/03_deepar_fullCA_with_backtests.ipynb`

### Phase 2 · Beyond zero-shot (by Fri Nov 20; final run Fri)
6. [x] Claude writes `06_post_processing`: calibration + Chronos-2/TimesFM-3 ensemble (Nov 13)
6a. [x] Claude adds the **3-model ensemble (Chronos-2 + TimesFM-3 + DeepAR)** to 06 and makes it read DeepAR's file names (Nov 15)
6b. [x] Run `06_post_processing`, then re-run `05_evaluation` on the real forecasts (Max, Nov 18): 15 models scored
6d. [x] Safety-stock method fixed in 05 (bias-adjusted, all models held to 95% coverage) and slow-seller fix for `calbias` in 06 (Claude, Nov 18)
6e. [x] Few-shot Chronos-2 (scored Nov 21: MAE 1.036, slightly worse than zero-shot) (`04d`, in-context, no training): smoke test, full run (Max; timeboxed to Sat Nov 21)
6f. [x] Leak fix: 06 uses zero-shot runs (price_ratio look-ahead in covariate runs); quantile-loss score added to 05 (Claude, Nov 19)
6g. [x] Price ratios from past prices only in LightGBM (`price_ratio_28`, Elena, Nov 19)
6c. [ ] Fine-tune Chronos-2 (`04c`): smoke test, full run, then 05 scores it (Max; timeboxed to Sat Nov 21)
7. [ ] Interpret calibration results for the blog: which groups moved off the median, effect on totals and safety stock (owner to confirm)
8. [ ] Hybrid model: LightGBM learns the foundation models' errors (**open: still wanted? who builds it?**)
9. [x] Add LightGBM to the ensemble (`ens_lgbm`, Claude, Nov 19); runs in Max's final 06
10. [x] Final run: 06, then 05, with every model → final results table + safety-stock $ (Max, Nov 21)

### Phase 3 · Freeze and write (by Sun Nov 22)
11. [ ] Results freeze: no more model changes
12. [ ] Everyone drafts their blog section; Minji adds the M5 top-solutions summary

### Phase 4 · Present (week of Nov 23)
13. [ ] Slides: 2–3 per person + takeaways, limitations, future work
14. [ ] Timed rehearsal before Thanksgiving (Nov 26): 15 min + 3 min Q&A
15. [ ] Presentation (date on Canvas)

### Phase 5 · Submit (by Mon Dec 7)
16. [ ] Blog assembled (Minji); README results filled in; requirements pinned
17. [ ] Reuse/LLM statement from `REUSE_LOG.md`
18. [ ] Repo public (or professor + TA added); submit doc on Canvas
19. [ ] Everyone does the peer evaluation

---

## Deadlines
- [x] Fri Oct 23: outline submitted (3.8/4)
- [x] **Sun Nov 8:** full-California runs + first results table (done late: first table Nov 13)
- [ ] **Sun Nov 15:** all final forecasts in Drive, including post-processed versions. *Status: baselines, Chronos-2, TimesFM-3 and DeepAR are in; 06 outputs need Max's run; LightGBM by Nov 17*
- [ ] **Sun Nov 22:** results freeze; blog sections drafted
- [ ] **Week of Nov 23:** slides + timed rehearsal (Thanksgiving Nov 26)
- [ ] **Late Nov / early Dec:** in-class presentation (check Canvas for our date)
- [ ] **Mon Dec 7, midnight:** blog + repo link + reuse/LLM statement on Canvas
- [ ] **Mon Dec 7:** everyone does the peer evaluation on Canvas

## Setup
- [x] Drive folder `AML_Term_Project` created and shared (editors)
- [x] GitHub repo created, teammates invited
- [x] README, TEAM, PROJECT_LOG, REUSE_LOG in the repo
- [x] Roles updated to who is actually doing what (`docs/TEAM.md`, Nov 15)
- [ ] Confirm all 4 teammates accepted the GitHub invite and added the Drive shortcut
- [ ] Set a standing weekly check-in time
- [ ] Delete the stray `04a_chronos2.ipynb` from the F1-explainer repo (public)

## Data
- [x] 01 data prep: 12,196 CA series, windows, sales-speed groups, EDA charts

## Models
| Done | Notebook | Owner | Status |
|---|---|---|---|
| [x] | 02a seasonal naive baselines (snaive + 4-week weekday average), full CA | Minji | Nov 6 |
| [x] | 02 winner-style LightGBM (sales-only and +prices/holidays), 7 windows | **Elena** (`lgbm_cov` run by Prateek) | Nov 19 |
| [x] | 03 DeepAR: smoke test (100 products, CPU, 3 windows) | James | Nov 6 |
| [x] | 03 DeepAR: full CA run, all 7 windows (CPU, ~70 min) | James | Nov 13 |
| [x] | 04a Chronos-2: smoke test | Max | Oct 28 |
| [x] | 04a Chronos-2: full California run | Max | Nov 3 |
| [x] | 04b TimesFM-3: smoke test | Max | Nov 3 |
| [x] | 04b TimesFM-3: full California run (Prateek's local RTX 4070, 58 min) | Prateek runs for Max | Nov 10; files in Drive Nov 14 |
| [ ] | 04d Chronos-2 few-shot (in-context, 100 related products per batch), val_1/val_2/test. **Timeboxed to Sat Nov 21** | Max (Claude wrote, Nov 19) | ready to run |
| [ ] | 04c Chronos-2 fine-tuned (LoRA), val_1/val_2/test: smoke test, then full run. **Timeboxed: drop to future work if not done by Sat Nov 21** | Max (Claude wrote, Nov 18) | ready to run |

## Evaluation and post-processing
- [x] 05 scoring notebook written (MAE, sales-weighted MAE, bias, by category/speed, safety-stock $ + coverage check), Nov 10
- [x] Run 05 on the real forecasts (Max, Nov 13: baselines + Chronos-2)
- [x] Calibration written in 06: `calmae` (per-group percentile + zero cutoff) and `calbias` (per-group scale so totals match), rolling origin | Claude, Nov 13
- [x] Foundation-model ensemble in 06 (`ens_fm`, `ens_fm_calmae`) | Claude, Nov 13
- [x] 3-model ensemble in 06 (`ens_3`, `ens_3_calbias`: Chronos-2 + TimesFM-3 + DeepAR) | Claude, Nov 15
- [x] Run 06, then re-run 05 on real data (Max, Nov 18: 15 models)
- [x] Fair safety-stock method, slow-seller fix, leak fix, quantile loss | Claude, Nov 18–19
- [x] LightGBM ensemble in 06 (`ens_lgbm`, `ens_lgbm_calbias`) | Claude, Nov 19
- [x] Final run: 06, then 05, with every model | Max, Nov 21
- [ ] Interpret calibration + ensemble results | owner to confirm
- [ ] Hybrid model (LightGBM learns the foundation models' errors) | open: still wanted? who builds it?
- [ ] Optional: route slow sellers to LightGBM in the mix (Prateek's finding) | team decides; Claude ~1 hour
- [ ] Safety-stock dollars per model, final (95% service, 7-day lead time) | comes out of the final 05 run
- [ ] Few-shot (`04d`) and fine-tuned (`04c`) Chronos-2, timeboxed to Sat Nov 21 | Max runs
- [ ] Confidence ranges for the top models (are they statistically tied?) | Claude, Sat Nov 21

## Write-up and presentation
- [ ] M5 top-solutions summary (related work) | Minji
- [ ] Each person drafts their blog section the week their part finishes
- [ ] Blog assembled | Minji
- [ ] Slides: 2–3 per person; takeaways, limitations, future-work slides
- [ ] Timed rehearsal (15 min + 3 min Q&A)
- [ ] Reuse/LLM statement finalized from `REUSE_LOG.md`
- [ ] Repo README "Results" section filled in; requirements pinned

## Findings so far (for the blog and slides)
- **Official (05):** Chronos-2 is 12% better than the 4-week-average baseline and 23% better than last-week naive on the test window (MAE 1.026 vs 1.172 vs 1.335); wins in every category and sales-speed group, biggest gain on slow sellers (~25%)
- **Safety stock (05):** Chronos-2's buffer is $25k cheaper than the baseline but covers only 68% of test weeks (baseline 88%) because its forecasts run low (bias −0.47 units/day) → calibration needed
- **DeepAR full run (James's own scoring, not yet official):** test MAE 1.085: better than both baselines, 6–7% behind Chronos-2 (1.026) and TimesFM-3 (1.014). Errors get worse in later windows (0.96 to 1.08)
- TimesFM-3 ≈ Chronos-2 on the full CA data: test MAE 1.016 (zero-shot) / 1.014 (covariates) vs Chronos-2 1.026 / 1.028, i.e. 0.2% to 1.4% lower on every window compared (quick check; official numbers come from 05)
- Covariates help TimesFM-3 slightly (0.2% to 1.3% lower MAE on all 7 windows); they made no difference for Chronos-2, and made it 6× slower
- TimesFM-3's median under-forecasts total test-window units by ~27% (forecast/actual 0.73), same pattern as Chronos-2; its 10th to 90th percentile range covers 83% to 85% of actual sales (target 80%)
- Both foundation models' medians under-forecast spiky products and predict flat zero for slow sellers → the case for calibration
- Median product sells nothing on 60% of days
