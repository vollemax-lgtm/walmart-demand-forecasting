# Team Plan

**Status:** roles below are *proposed* after the professor's outline feedback. Confirm at the next check-in.

## Professor's feedback on the outline (3.8/4)
1. Study the top M5 solutions (Kaggle code/discussions/leaderboard), but also propose and test a different solution of our own.
2. Evaluate at least one more time series foundation model, e.g. Google's TimesFM-3, in addition to Chronos-2.
3. Go beyond zero-shot: add post-processing on top of the foundation models' raw forecasts.

## Roles

| Person | Role | Notebook | Blog section | Talk slot |
|---|---|---|---|---|
| Minji | Data lead (prep done) → repo, README, reuse log, blog assembly, M5 top-solutions summary | 01 ✅ | Data, exploration, related work | Problem and data quirks |
| Prateek | Winner-style LightGBM (sales-only + prices/holidays) and hybrid residual model | 02 | Gradient boosting, features, hybrid model | LightGBM and our hybrid |
| James | DeepAR (2–3 settings max) | 03 | Deep learning model | DeepAR |
| Max | Chronos-2 and TimesFM-3 (zero-shot + with covariates) | 04 | Foundation models | Foundation models |
| Elena | Scoring, calibration, ensemble, safety-stock dollars | 05 | Results, business impact | Results and takeaways |

## Experiment grid

| Model | Zero-shot | + Prices/holidays | + Calibration | + Residual correction |
|---|---|---|---|---|
| Seasonal naive | ✓ | | | |
| LightGBM (winner-style) | ✓ (sales only) | ✓ | | |
| DeepAR | ✓ | | | |
| Chronos-2 | ✓ | ✓ | ✓ | ✓ |
| TimesFM-3 | ✓ | ✓ | ✓ | ✓ |
| Ensemble (best FM + LightGBM) | | | | ✓ |

**Post-processing steps (beyond zero-shot)**
- **Calibration:** using the validation windows, a scale factor per category × sales-speed group, plus a cutoff below which forecasts round to zero.
- **Hybrid residual model (our own solution):** a small LightGBM learns where the foundation model is wrong, using price, holiday and recent-sales features; its prediction is added to the foundation model's forecast.
- **Ensemble:** weighted average of the best foundation model and LightGBM; weights chosen on validation.
- *Stretch:* fine-tune a foundation model on California history.

**Metrics:** mean absolute error and sales-weighted error, by category and sales speed; safety-stock dollars (95% service, 7-day lead time).

## Shared conventions
- Data: `ca_sales.parquet` (`unique_id, ds, y` + price/calendar columns), `ca_static.parquet`, `windows.json`
- Windows: val_1 Feb 29 – Mar 27, val_2 Mar 28 – Apr 24, **test Apr 25 – May 22, 2016** (never tune on test)
- Forecast files: `data/forecasts/<model>_<window>.parquet` with columns `unique_id, ds, model, window, forecast`

## Key dates
- ~~Wed Oct 28: clean data in Drive~~ ✅ done Oct 21
- **Sun Nov 1:** every model runs on the 100-product sample; scoring notebook ready
- **Sun Nov 8:** first full-California runs; first results table
- **Sun Nov 15:** all final forecast files in Drive, including post-processed versions
- **Sun Nov 22:** results freeze; blog sections drafted
- **Week of Nov 23:** slides + timed rehearsal (Thanksgiving Nov 26)
- **Mon Dec 7:** blog, repo link, reuse and LLM statements submitted; peer evaluations done

## Weekly check-in
20 minutes, same time every week. Each person answers: what I finished, what's next, what's blocking me.
