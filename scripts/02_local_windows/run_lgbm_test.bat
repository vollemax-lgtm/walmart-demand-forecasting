@echo off
REM LightGBM test run: 100 products, lgbm_cov, all 7 windows, about 1 minute. Add "cpu" to force CPU.
setlocal
cd /d "%~dp0"
call :activate_lgbm || goto :fail

python -c "import lightgbm" 2>nul
if errorlevel 1 (
    echo Installing LightGBM into the lgbm environment ...
    python -m pip install lightgbm || goto :fail
)
python -c "import lightgbm, pandas, pyarrow; print('LightGBM', lightgbm.__version__, '| pandas', pandas.__version__)" || goto :fail

set KMP_DUPLICATE_LIB_OK=TRUE
set LGBM_DEVICE=gpu
if /i "%~1"=="cpu" set LGBM_DEVICE=cpu
set LGBM_SAMPLE=1

echo LIGHTGBM TEST RUN started %date% %time%  (device %LGBM_DEVICE%)
echo Nothing prints while it runs. Wait for the summary.
python -m jupyter nbconvert --to notebook --execute 02_lightgbm_local.ipynb --output 02_lgbm_test_executed.ipynb --ExecutePreprocessor.timeout=-1 --ExecutePreprocessor.kernel_name=python3
if errorlevel 1 goto :fail
echo LIGHTGBM TEST RUN finished %date% %time%
echo.
python show_results.py 02_lgbm_test_executed.ipynb
echo.
echo ===== If all 7 windows say done and the file check shows 7 files, tell Claude, then run run_lgbm_full.bat =====
pause
exit /b 0
:activate_lgbm
set "CONDA_ROOT="
for %%D in ("%USERPROFILE%\anaconda3" "%USERPROFILE%\miniconda3" "%LOCALAPPDATA%\anaconda3" "%ProgramData%\anaconda3" "%ProgramData%\miniconda3") do if exist "%%~D\Scripts\activate.bat" if not defined CONDA_ROOT set "CONDA_ROOT=%%~D"
if not defined CONDA_ROOT (
    echo Could not find Anaconda or Miniconda on this PC.
    exit /b 1
)
if not exist "%CONDA_ROOT%\envs\lgbm\python.exe" (
    echo The "lgbm" environment does not exist yet. Run setup_lgbm_env.bat first.
    exit /b 1
)
call "%CONDA_ROOT%\Scripts\activate.bat" lgbm
python -c "import sys; p=sys.executable.lower(); print('Using Python:', sys.executable); raise SystemExit(0 if ('envs' in p and 'lgbm' in p) else 1)"
if errorlevel 1 (
    echo PROBLEM: the "lgbm" environment did not activate.
    exit /b 1
)
exit /b 0

:fail
echo.
echo ===== LIGHTGBM TEST RUN STOPPED WITH AN ERROR. Send Claude the error above. =====
pause
exit /b 1
