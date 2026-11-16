# Team Plan

**Status:** roles updated **Nov 15** to match who is actually doing what. For what is done and left, see [`CHECKLIST.md`](CHECKLIST.md).

## Professor's feedback on the outline (3.8/4)
1. Study the top M5 solutions (Kaggle code/discussions/leaderboard), but also propose and test a different solution of our own.
2. Evaluate at least one more time series foundation model, e.g. Google's TimesFM-3, in addition to Chronos-2.
3. Go beyond zero-shot: add post-processing on top of the foundation models' raw forecasts.

## Roles

| Person | Role | Notebook(s) | Status | Blog section | Talk slot |
|---|---|---|---|---|---|
| Minji | Data prep, baselines, M5 top-solutions summary, blog assembly | 01, 02a | ✅ done (01 Oct 21, 02a Nov 6) | Data, exploration, related work | Problem and data quirks |
| Elena | Winner-style LightGBM (sales-only + prices/holidays); runs the hybrid model once Claude adds it | 02 | 🔄 in progress, due Tue Nov 17 | Gradient boosting, features, hybrid model | LightGBM and our hybrid |
| James | DeepAR | 03 | ✅ done (full run, 7 windows, Nov 13) | Deep learning model | DeepAR |
| Prateek | TimesFM-3 full California run on his local GPU | 04b (full run) | ✅ done (run Nov 10, files in Drive Nov 14) | Foundation models (with Max) | Foundation models (with Max) |
| Max | Chronos-2 and TimesFM-3 notebooks, coordination, runs 05 (scoring) and 06 (calibration + ensembles) | 04a, 04b, 05, 06 | ✅ 04a/04b; 🔄 runs 06 then 05 next | Foundation models | Foundation models |

**Still to assign:** the results and business-impact write-up (interpreting calibration, the ensembles and safety-stock dollars). Elena had it before she took LightGBM.

Claude writes the notebook code for every step (see `REUSE_LOG.md`); each owner runs, checks and interprets their part.

## Experiment grid

| Model | Zero-shot | + Prices/holidays | + Calibration | + Residual correction |
|---|---|---|---|---|
| Seasonal naive | ✓ | | | |
| LightGBM (winner-style) | ✓ (sales only) | ✓ | | |
| DeepAR | ✓ | | | |
| Chronos-2 | ✓ | ✓ | ✓ | ✓ |
| TimesFM-3 | ✓ | ✓ | ✓ | ✓ |
| Ensemble: Chronos-2 + TimesFM-3 (`ens_fm`) | | | ✓ | |
| Ensemble: + DeepAR (`ens_3`) | | | ✓ (scaling only) | |
| Ensemble: + LightGBM | | | | ✓ (after 02) |

**Post-processing steps (beyond zero-shot)**
- **Calibration:** using the validation windows, a scale factor per category × sales-speed group, plus a cutoff below which forecasts round to zero.
- **Hybrid residual model (our own solution):** a small LightGBM learns where the foundation model is wrong, using price, holiday and recent-sales features; its prediction is added to the foundation model's forecast.
- **Ensembles:** weighted averages with weights chosen on earlier windows. Built so far: Chronos-2 + TimesFM-3, and Chronos-2 + TimesFM-3 + DeepAR. LightGBM joins once 02 exists.
- *Stretch:* fine-tune a foundation model on California history.

**Metrics:** mean absolute error and sales-weighted error, by category and sales speed; safety-stock dollars (95% service, 7-day lead time).

## Shared conventions
- Data: `ca_sales.parquet` (`unique_id, ds, y` + price/calendar columns), `ca_static.parquet`, `windows.json`
- Windows: val_1 Feb 29 – Mar 27, val_2 Mar 28 – Apr 24, **test Apr 25 – May 22, 2016** (never tune on test)
- Backtest windows (training data for calibration and the hybrid model): the four 28-day blocks right before val_1 —
  bt_4 Nov 9 – Dec 6 2015, bt_3 Dec 7 – Jan 3, bt_2 Jan 4 – Jan 31, bt_1 Feb 1 – Feb 28, 2016.
  Build them in code as `val_1 start − 28×k days` so every notebook matches.
- Forecast files: `data/forecasts/<model>_<window>.parquet` with columns `unique_id, ds, model, window, forecast` (extra columns such as quantiles `q0.1…q0.9` are fine). Smoke-test runs go to `data/forecasts_sample/`.

## Key dates
- ~~Wed Oct 28: clean data in Drive~~ ✅ done Oct 21
- ~~Sun Nov 1: every model runs on the 100-product sample; scoring notebook ready~~ ✅ (LightGBM excepted)
- ~~Sun Nov 8: first full-California runs; first results table~~ ✅ done Nov 13
- **Sun Nov 15:** all final forecast files in Drive, including post-processed versions (all in except LightGBM and the 06 outputs)
- **Sun Nov 22:** results freeze; blog sections drafted
- **Week of Nov 23:** slides + timed rehearsal (Thanksgiving Nov 26)
- **Mon Dec 7:** blog, repo link, reuse and LLM statements submitted; peer evaluations done

## Weekly check-in
20 minutes, same time every week. Each person answers: what I finished, what's next, what's blocking me.
