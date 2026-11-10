# Master Checklist

Last updated: **Nov 10, 2026**. Tick items as they finish. Details for each finished item are in `docs/PROJECT_LOG.md`.

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
| [ ] | **04b TimesFM-3: full California run** (on Prateek's local GPU) | Prateek runs for Max | in progress |
| [x] | 02a seasonal naive baselines (snaive + 4-week weekday average), full CA | Minji | Nov 6 |
| [ ] | 02 winner-style LightGBM (sales-only and +prices/holidays) | owner TBD (Claude writes) | not started |
| [x] | 03 DeepAR: smoke test (100 products, CPU, 3 windows) | James | Nov 6 |
| [ ] | 03 DeepAR: full CA run on GPU (+ 4 backtest windows) | James | next |

## Evaluation and post-processing
- [x] 05 scoring notebook written (MAE, sales-weighted MAE, bias, by category/speed, safety-stock $ + coverage check), Nov 10
- [ ] **Run 05 on the real forecasts** (CPU, few minutes); re-run when TimesFM-3 and DeepAR full runs land
- [ ] Calibration (scale factors + zero cutoff, learned on backtests/validation) | Elena
- [ ] Hybrid residual model (LightGBM learns the foundation models' errors) | Prateek
- [ ] Ensemble (best foundation model + LightGBM) | Elena
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
- Chronos-2 beats "same weekday last week" by 23–28% and the stronger 4-week weekday average by ~12% (test: 1.026 vs 1.172 vs 1.335)
- DeepAR on the 100-product sample: test MAE 1.031, close to Chronos-2 (1.012) on the same sample
- Prices/holidays don't help Chronos-2 (±1%) and make it 6× slower
- TimesFM-3 ≈ Chronos-2 on the 100-product sample (within ~3%)
- Both models' medians under-forecast spiky products and predict flat zero for slow sellers → the case for calibration
- Median product sells nothing on 60% of days
