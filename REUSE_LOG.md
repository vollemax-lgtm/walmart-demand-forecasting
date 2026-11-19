# Code Reuse and LLM Use Log

The course requires us to declare reused code, pretrained models, and code written with an LLM.
**Add a row the same week you use something.** This becomes our submission statement on Dec 7.

| Date | Notebook / file | What was reused or generated | Source (link, model, or tool) | What we changed or contributed | Added by |
|---|---|---|---|---|---|
| 2026-10-21 | `01_data_prep.ipynb` | Full notebook code | Claude (Anthropic), from our team's specification | Scope (California), cleaning rules, window design, sales-speed definition; review and run | Max Volle |
| 2026-10-28 | `04a_chronos2.ipynb` | Full notebook code | Claude (Anthropic), from our team's specification; Chronos-2 interface from the `chronos-forecasting` 2.3.2 package | Choice of runs (zero-shot vs. covariates), covariate list, window design, median as point forecast; review and run | Max |
| 2026-10-28 | `04b_timesfm3.ipynb` | Full notebook code | Claude (Anthropic), from our team's specification; TimesFM-3 interface from the `timesfm` 3.0.2 package source | Same run and window design as 04a for a like-for-like comparison; covariate list; review and run | Max |
| | | TimesFM-3 pretrained model | https://huggingface.co/google/timesfm-3.0-pytorch | Used zero-shot and with covariates, no fine-tuning | |
| 2026-11-10 | `05_evaluation.ipynb` | Full notebook code | Claude (Anthropic), from our team's specification | Metric choices (MAE, sales-weighted MAE, bias), fair common-set rule, safety-stock method and coverage check; review, run and interpret | Elena / Max |
| 2026-11-13 | `06_post_processing.ipynb` | Full notebook code | Claude (Anthropic), from our team's specification | Choice of corrections (percentile + zero cutoff for error, segment scaling for totals), rolling-origin design, model pair for the ensemble; review, run and interpret | Elena / Max |
| 2026-11-15 | `06_post_processing.ipynb` (update) | 3-model ensemble (Chronos-2 + TimesFM-3 + DeepAR) and loader for DeepAR's file names | Claude (Anthropic), from our team's specification | Decision to add DeepAR to the ensemble; review, run and interpret | Max |
| 2026-11-18 | `04c_chronos2_finetune.ipynb` | Full notebook code (LoRA fine-tuning via `chronos-forecasting`'s `Chronos2Pipeline.fit`) | Claude (Anthropic), from our team's specification | Decision to test fine-tuning as a timeboxed experiment; run, check and interpret | Max |
| 2026-11-18 | `05_evaluation.ipynb`, `06_post_processing.ipynb` (update) | Bias-adjusted safety stock held to 95% coverage (05); `calbias` scales the average forecast instead of the median (06); chart labels | Claude (Anthropic), from our team's specification | Decision to change the safety-stock method and fix slow sellers; run and interpret | Max |
| 2026-11-19 | `04d_chronos2_fewshot.ipynb`; `05`/`06` updates | Few-shot (in-context, `cross_learning=True`) Chronos-2 notebook; quantile-loss section in 05; 06 switched to zero-shot base models and moves stale outputs aside | Claude (Anthropic), from our team's specification | Decision to add few-shot per the professor's request and to drop the covariate runs from the headline; run and interpret | Max |
| 2026-11-19 | `06_post_processing.ipynb` (update) | LightGBM ensemble (`ens_lgbm`, `ens_lgbm_calbias`) | Claude (Anthropic), from our team's specification | Decision to use the sales-only LightGBM run in the ensemble; run and interpret | Max |
| | | Chronos-2 pretrained model | https://huggingface.co/amazon/chronos-2 | Used zero-shot, no fine-tuning | |
| | | M5 dataset | https://www.kaggle.com/competitions/m5-forecasting-accuracy | Filtered to California | |

## Draft LLM statement (finalize in December)
Code in this repository was written primarily with Claude (Anthropic) from specifications our team designed. Our contributions were the problem framing, the choice of models and experiments, the validation design, the scope and business assumptions, debugging decisions, and all interpretation of results.
