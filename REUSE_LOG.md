# Code Reuse and LLM Use Log

The course requires us to declare reused code, pretrained models, and code written with an LLM.
**Add a row the same week you use something.** This becomes our submission statement on Dec 7.

| Date | Notebook / file | What was reused or generated | Source (link, model, or tool) | What we changed or contributed | Added by |
|---|---|---|---|---|---|
| 2026-10-21 | `01_data_prep.ipynb` | Full notebook code | Claude (Anthropic), from our team's specification | Scope (California), cleaning rules, window design, sales-speed definition; review and run | Max Volle |
| 2026-10-28 | `04a_chronos2.ipynb` | Full notebook code | Claude (Anthropic), from our team's specification; Chronos-2 interface from the `chronos-forecasting` 2.3.2 package | Choice of runs (zero-shot vs. covariates), covariate list, window design, median as point forecast; review and run | Max |
| 2026-10-28 | `04b_timesfm3.ipynb` | Full notebook code | Claude (Anthropic), from our team's specification; TimesFM-3 interface from the `timesfm` 3.0.2 package source | Same run and window design as 04a for a like-for-like comparison; covariate list; review and run | Max |
| | | TimesFM-3 pretrained model | https://huggingface.co/google/timesfm-3.0-pytorch | Used zero-shot and with covariates, no fine-tuning | |
| | | Chronos-2 pretrained model | https://huggingface.co/amazon/chronos-2 | Used zero-shot, no fine-tuning | |
| | | M5 dataset | https://www.kaggle.com/competitions/m5-forecasting-accuracy | Filtered to California | |

## Draft LLM statement (finalize in December)
Code in this repository was written primarily with Claude (Anthropic) from specifications our team designed. Our contributions were the problem framing, the choice of models and experiments, the validation design, the scope and business assumptions, debugging decisions, and all interpretation of results.
