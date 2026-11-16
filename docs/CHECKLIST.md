# Master Checklist

Last updated: **Sun Nov 15, 2026**. Tick items as they finish. Details for each finished item are in `docs/PROJECT_LOG.md`.

## Status at a glance (Nov 15)

**Where we are:** every model except LightGBM has finished its full California run, and all of those forecast files are in Drive. The code for the "beyond zero-shot" step (calibration and ensembles) is written and tested but hasn't been run on the real forecasts yet.

| | What | Who | Notes |
|---|---|---|---|
| ✅ Done | Data prep: 12,196 California products, 7 windows, EDA | Minji | Oct 21 |
| ✅ Done | Baselines (last-week naive, 4-week weekday average) | Minji | Nov 6 |
| ✅ Done | Chronos-2, full run, 7 windows | Max | Nov 3 |
| ✅ Done | TimesFM-3, full run, 7 windows; **files uploaded to Drive** | Prateek (for Max) | run Nov 10, upload Nov 14 |
| ✅ Done | DeepAR, full run, **7 windows including backtests**; notebook on GitHub | James | Nov 13, test MAE 1.085 |
| ✅ Done | Scoring notebook 05, first official results (baselines + Chronos-2) | Claude wrote, Max ran | Nov 13 |
| ✅ Done | Notebook 06: calibration + 2-model ensemble + **3-model ensemble with DeepAR** | Claude | Nov 13, DeepAR added Nov 15 |
| 🔄 Next | **Run 06, then re-run 05** → first results table with every model except LightGBM | Max | CPU runtime, ~15 min total |
| 🔄 In progress | LightGBM (notebook 02): sales-only and +prices/holidays, 7 windows | **Elena** | needed by Tue Nov 17 |
| ⏳ After LightGBM | Hybrid model (LightGBM learns the foundation models' errors) + LightGBM in the ensemble | Elena runs, Claude adds code to 06 | |
| ⏳ After that | Final 05 run → final results + safety-stock $; results freeze | Max | Sun Nov 22 |
| ⏳ Then | Blog sections, slides, rehearsal, submission | everyone | see Phases 3–5 |

**Open question for the team:** who writes the **results and business-impact** part (interpreting calibration, the ensemble and safety-stock dollars)? Elena had it originally, but she now owns LightGBM.

## How the notebooks connect
```
01 data prep ─► 02a baselines ─┐
               02 LightGBM ────┤   (Elena, in progress)
               03 DeepAR ──────┤
               04a Chronos-2 ──┤──► forecast files in Drive data/forecasts/
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
4. [ ] LightGBM: sales-only and +prices/holidays, all 7 windows, saved in the shared file format (Elena, by Tue Nov 17)
5. [x] DeepAR full run **including the 4 backtest windows** (James, Nov 13; ran on CPU, ~10 min per window). Notebook: `notebooks/03_deepar_fullCA_with_backtests.ipynb`

### Phase 2 · Beyond zero-shot (by Fri Nov 20)
6. [x] Claude writes `06_post_processing`: calibration + Chronos-2/TimesFM-3 ensemble (Nov 13)
6a. [x] Claude adds the **3-model ensemble (Chronos-2 + TimesFM-3 + DeepAR)** to 06 and makes it read DeepAR's file names (Nov 15)
6b. [ ] **Run `06_post_processing`, then re-run `05_evaluation`** (Max; CPU runtime; open both fresh from GitHub)
7. [ ] Interpret calibration results for the blog: which groups moved off the median, effect on totals and safety stock (owner to confirm)
8. [ ] Hybrid model: LightGBM learns the foundation models' errors (Elena runs; Claude writes once 02 exists)
9. [ ] Add LightGBM to the ensemble (Claude adds to 06 once 02 exists; Max re-runs 06)
10. [ ] Re-run `05_evaluation` with every model → final results table + safety-stock $ (Max)

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
| [ ] | 02 winner-style LightGBM (sales-only and +prices/holidays), 7 windows | **Elena** | in progress, due Tue Nov 17 |
| [x] | 03 DeepAR: smoke test (100 products, CPU, 3 windows) | James | Nov 6 |
| [x] | 03 DeepAR: full CA run, all 7 windows (CPU, ~70 min) | James | Nov 13 |
| [x] | 04a Chronos-2: smoke test | Max | Oct 28 |
| [x] | 04a Chronos-2: full California run | Max | Nov 3 |
| [x] | 04b TimesFM-3: smoke test | Max | Nov 3 |
| [x] | 04b TimesFM-3: full California run (Prateek's local RTX 4070, 58 min) | Prateek runs for Max | Nov 10; files in Drive Nov 14 |

## Evaluation and post-processing
- [x] 05 scoring notebook written (MAE, sales-weighted MAE, bias, by category/speed, safety-stock $ + coverage check), Nov 10
- [x] Run 05 on the real forecasts (Max, Nov 13: baselines + Chronos-2)
- [x] Calibration written in 06: `calmae` (per-group percentile + zero cutoff) and `calbias` (per-group scale so totals match), rolling origin | Claude, Nov 13
- [x] Foundation-model ensemble in 06 (`ens_fm`, `ens_fm_calmae`) | Claude, Nov 13
- [x] 3-model ensemble in 06 (`ens_3`, `ens_3_calbias`: Chronos-2 + TimesFM-3 + DeepAR) | Claude, Nov 15
- [ ] Run 06, then re-run 05 | Max
- [ ] Interpret calibration + ensemble results | owner to confirm
- [ ] Hybrid model (LightGBM learns the foundation models' errors) | Elena
- [ ] Add LightGBM to the ensemble once 02 exists | Claude writes, Max runs
- [ ] Safety-stock dollars per model, final (95% service, 7-day lead time) | comes out of the final 05 run
- [ ] *Stretch:* fine-tune a foundation model

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
