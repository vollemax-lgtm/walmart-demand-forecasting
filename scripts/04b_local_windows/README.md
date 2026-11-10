# Running 04b TimesFM-3 on a local Windows GPU

Used for the Nov 10 full California run (RTX 4070, 58 minutes). The executed result is `notebooks/04b_timesfm3_fullCA.ipynb`.

`04b_timesfm3_local.ipynb` is the same notebook as `notebooks/04b_timesfm3.ipynb`, with these local changes only (the model code is unchanged):
- `DRIVE_DIR` is the folder the notebook sits in, so the data goes in a `data/` folder next to it
- `SAMPLE` and `BATCH_SIZE` come from the environment variables `TFM_SAMPLE` and `TFM_BATCH`, set by the scripts
- the `!pip install` cell is commented out (packages are installed once by `setup_env.bat`)
- an extra runtime estimate cell after section 5 and a file check (section 8) at the end

## Folder layout

Copy this folder anywhere, then copy from Drive `AML_Term_Project/data/` into a `data` folder inside it:

```
04b_local_windows\
    04b_timesfm3_local.ipynb
    setup_env.bat  run_test.bat  run_full.bat  show_results.py
    data\
        ca_sales.parquet  ca_sample100.parquet  ca_static.parquet  windows.json
```

## Steps (PowerShell, in this folder; Anaconda or Miniconda must be installed)

| Step | Command | Time | Expected at the end |
|---|---|---|---|
| 1 | `.\setup_env.bat` | 10 to 20 min, once | `GPU found: True`, `timesfm3 OK`, `SETUP DONE` |
| 2 | `.\run_test.bat` | 1 to 3 min | `Device: cuda`, 14 `done` lines, a full-run time estimate |
| 3 | `.\run_full.bat` | about 1 h on an RTX 4070 | `14 files found`, all `rows_ok` True, `missing` 0 |

Notes:
- Each script activates the `tfm` conda environment itself and stops if it can't (running in the base environment caused the crash below).
- The scripts set `KMP_DUPLICATE_LIB_OK=TRUE`. Without it, two copies of the OpenMP library (one from conda, one from PyTorch) crash the kernel at the plotting step.
- Finished windows are skipped, so if a run stops, run the same script again.
- If the GPU runs out of memory, pass a smaller batch size: `.\run_full.bat 16`.
- Pause OneDrive or Google Drive syncing during the run if the folder is synced; a sync tool can lock a file while it is being saved.
- Forecasts are written to `data\forecasts\` (full run) or `data\forecasts_sample\` (test). Upload them to Drive `AML_Term_Project/data/forecasts/`; they are not stored in GitHub.
