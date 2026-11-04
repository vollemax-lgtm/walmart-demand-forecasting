# Master Checklist

Last updated: **Nov 3, 2026**. Tick items as they finish. Details for each finished item are in `docs/PROJECT_LOG.md`.

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
- [ ] **Confirm roles at the next check-in** (still marked "proposed" in `docs/TEAM.md`)
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
| [ ] | **04b TimesFM-3: full California run** (~2.5–3 h on T4) | Max | next |
| [ ] | 02 seasonal naive + winner-style LightGBM (sales-only and +prices/holidays) | Prateek (Claude writes) | not started |
| [ ] | 03 DeepAR | James (Claude writes) | not started |

## Evaluation and post-processing
- [ ] **05 scoring notebook**: MAE, sales-weighted error, by category and sales speed (Claude writes next)
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
- Chronos-2 beats "same weekday last week" by 22–25% on every window (full CA data)
- Prices/holidays don't help Chronos-2 (±1%) and make it 6× slower
- TimesFM-3 ≈ Chronos-2 on the 100-product sample (within ~3%)
- Both models' medians under-forecast spiky products and predict flat zero for slow sellers → the case for calibration
- Median product sells nothing on 60% of days
