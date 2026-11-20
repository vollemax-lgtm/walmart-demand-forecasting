# Running 02 LightGBM (`lgbm_cov`) on a local Windows machine

Used for the Nov 19 `lgbm_cov` run (Ryzen 7 5800H laptop, CPU, 27 minutes). The executed result is `notebooks/02_lightgbm_cov_fullCA.ipynb`.

`02_lightgbm_local.ipynb` is Elena's `notebooks/02_lightgbm.ipynb` with settings changes only (features and model unchanged):
- `RUNS = ["lgbm_cov"]` (Elena ran the sales-only `lgbm` on Colab)
- `SAMPLE` comes from the `LGBM_SAMPLE` environment variable, set by the scripts
- `DRIVE_DIR` is the folder the notebook sits in, so the data goes in a `data/` folder next to it
- optional GPU training: `DEVICE` from `LGBM_DEVICE` (LightGBM's OpenCL GPU mode, falls back to CPU automatically). The team run used `cpu`, to match Elena's `lgbm`
- a file check at the end (section 8)

## Folder layout

```
02_local_windows\
    02_lightgbm_local.ipynb
    setup_lgbm_env.bat  run_lgbm_test.bat  run_lgbm_full.bat  show_results.py
    data\
        ca_sales.parquet  ca_sample100.parquet  ca_static.parquet  windows.json
```
(copy the four data files from Drive `AML_Term_Project/data/`)

## Steps (PowerShell, in this folder; Anaconda or Miniconda installed)

| Step | Command | Time | Expected at the end |
|---|---|---|---|
| 1 | `.\setup_lgbm_env.bat` | about 5 min, once | `LightGBM 4.x`, `SETUP DONE` |
| 2 | `.\run_lgbm_test.bat cpu` | about 1 min | 7 `done` lines, `7 lgbm_cov files found` |
| 3 | `.\run_lgbm_full.bat cpu` | about 30 min on an 8-core CPU | 7 `done` lines, all `rows_ok` True, `missing` 0 |

- Omit `cpu` to try the GPU (OpenCL); it switches to CPU if the GPU can't be used.
- Finished windows are skipped, so if a run stops, run the same script again.
- Memory: about 6 to 8 GB of RAM for the full run.
- Pause OneDrive or Drive syncing during the run if the folder is synced.
- Forecasts are written to `data\forecasts\`; upload them to Drive `data/forecasts/` (choose "Replace" for existing names). They are not stored in GitHub.
