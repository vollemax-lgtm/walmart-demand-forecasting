# Master Checklist

Last updated: **Nov 13, 2026**. Tick items as they finish. Details for each finished item are in `docs/PROJECT_LOG.md`.

## Finish plan (agreed order, from Nov 13)

### Phase 1 · Finish the forecasts (by Wed Nov 18)
1. [ ] Upload the 14 `timesfm3_*.parquet` files to Drive `data/forecasts/` (Prateek, today; Max messaged him Nov 13). Notebook + figure already on GitHub
2. [x] Run `05_evaluation` on what exists → first official results table (Max, Nov 13: baselines + Chronos-2)
3. [ ] Name the LightGBM owner; Claude writes `02_lightgbm` (today)
4. [ ] LightGBM smoke test, then full run: sales-only and +prices/holidays, all 7 windows (owner, by Tue Nov 17)
5. [ ] DeepAR full run on GPU, **including the 4 backtest windows** (James, by Tue Nov 17), so DeepAR can join the ensemble

### Phase 2 · Beyond zero-shot (by Fri Nov 20)
6. [x] Claude writes `06_post_processing`: calibration + Chronos-2/TimesFM-3 ensemble (Nov 13). Hybrid model and LightGBM ensemble get added once `02_lightgbm` exists
6b. [ ] **Run `06_post_processing` (CPU, few minutes), then re-run `05_evaluation`** (Elena; needs the TimesFM-3 files in Drive first)
7. [ ] Interpret calibration results for the blog: which groups moved off the median, effect on totals and safety stock (Elena)
8. [ ] Hybrid residual model: LightGBM learns the foundation models' errors (LightGBM owner)
9. [ ] Ensemble: foundation models done in 06. Claude adds a **3-model ensemble (Chronos-2 + TimesFM-3 + DeepAR)** once James's full run lands; LightGBM joins once 02 exists (Elena runs)
10. [ ] Re-run `05_evaluation` with every model → final results table + safety-stock $ (Elena)

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
- [ ] **Sun Nov 8:** full-California runs + first results table
- [ ] **Sun Nov 15:** all final forecasts in Drive, including post-processed versions
- [ ] **Sun Nov 22:** results freeze; blog sections drafted
- [ ] **Week of Nov 23:** slides + timed rehearsal (Thanksgiving Nov 26)
- [ ] **Late Nov / early Dec:** in-class presentation (check Canvas for our date)
- [ ] **Mon Dec 7, midnight:** blog + repo link + reuse/LLM statement on Canvas
- [ ] **Mon Dec 7:** everyone does the peer evaluation on Canvas

## Setup
- [x] Drive folder `AML_Term_Project` created and shared (editors)
- [x] GitHub repo created, teammates invited
- [x] README, TEAM, PROJECT_LOG, REUSE_LOG in the repo
- [ ] Confirm all 4 teammates accepted the GitHub invite and added the Drive shortcut
- [ ] **Confirm roles** (still marked "proposed" in `docs/TEAM.md`); decide who owns LightGBM now that Minji did the baselines
- [ ] Set a standing weekly check-in time
- [ ] Delete the stray `04a_chronos2.ipynb` from the F1-explainer repo (public)

## Data
- [x] 01 data prep: 12,196 CA series, windows, sales-speed groups, EDA charts

## Models
| Done | Notebook | Owner | Status |
|---|---|---|---|
| [x] | 04a Chronos-2: smoke test | Max | Oct 28 |
| [x] | 04a Chronos-2: full California run | Max | Nov 3 |
| [x] | 04b TimesFM-3: smoke test | Max | Nov 3 |
| [x] | 04b TimesFM-3: full California run (Prateek's local RTX 4070, 58 min) | Prateek runs for Max | Nov 10 |
| [x] | 02a seasonal naive baselines (snaive + 4-week weekday average), full CA | Minji | Nov 6 |
| [ ] | 02 winner-style LightGBM (sales-only and +prices/holidays) | owner TBD (Claude writes) | not started |
| [x] | 03 DeepAR: smoke test (100 products, CPU, 3 windows) | James | Nov 6 |
| [ ] | 03 DeepAR: full CA run on GPU (+ 4 backtest windows) | James | next |

## Evaluation and post-processing
- [x] 05 scoring notebook written (MAE, sales-weighted MAE, bias, by category/speed, safety-stock $ + coverage check), Nov 10
- [x] Run 05 on the real forecasts (Max, Nov 13). Re-run when TimesFM-3, 06 outputs and DeepAR full run land
- [x] Calibration written in 06: `calmae` (per-segment percentile + zero cutoff) and `calbias` (per-segment scale so totals match), rolling origin | Claude, Nov 13
- [ ] Run 06 + interpret calibration | Elena
- [ ] Hybrid residual model (LightGBM learns the foundation models' errors) | Prateek
- [x] Foundation-model ensemble written in 06 (`ens_fm`, `ens_fm_calmae`, weight chosen on earlier windows) | Claude, Nov 13
- [ ] Add LightGBM to the ensemble once 02 exists | Elena
- [ ] Safety-stock dollars per model (95% service, 7-day lead time) | Elena
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
- DeepAR on the 100-product sample: test MAE 1.031, close to Chronos-2 (1.012) on the same sample
- Prices/holidays don't help Chronos-2 (±1%) and make it 6× slower
- TimesFM-3 ≈ Chronos-2 on the full CA data: test MAE 1.016 (zero-shot) / 1.014 (covariates) vs Chronos-2 1.026 / 1.028, i.e. 0.2% to 1.4% lower on every window compared (quick check; official numbers from 05)
- Covariates help TimesFM-3 slightly (0.2% to 1.3% lower MAE on all 7 windows); they made no difference for Chronos-2
- TimesFM-3's median under-forecasts total test-window units by ~27% (forecast/actual 0.73), same pattern as Chronos-2; its 10th to 90th percentile range covers 83% to 85% of actual sales (target 80%)
- Both models' medians under-forecast spiky products and predict flat zero for slow sellers → the case for calibration
- Median product sells nothing on 60% of days
