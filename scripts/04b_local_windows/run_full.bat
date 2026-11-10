@echo off
REM Full California run: 12,196 products x 14 windows. KEEP THIS WINDOW OPEN until it says finished.
REM Optional: give a smaller batch size, e.g.  .\run_full.bat 16
setlocal
cd /d "%~dp0"
call :activate_tfm || goto :fail

REM Two copies of the OpenMP library (conda + PyTorch) can crash the kernel on Windows; this lets them coexist.
set KMP_DUPLICATE_LIB_OK=TRUE
set TFM_SAMPLE=0
set TFM_BATCH=32
if not "%~1"=="" set TFM_BATCH=%~1

echo FULL RUN started %date% %time%  (batch size %TFM_BATCH%)
echo DO NOT close this window. Progress: count the timesfm3_* files in data\forecasts (14 = done).
echo If it stops for any reason, just run this file again: finished windows are skipped.
python -m jupyter nbconvert --to notebook --execute 04b_timesfm3_local.ipynb --output 04b_timesfm3_fullCA.ipynb --ExecutePreprocessor.timeout=-1 --ExecutePreprocessor.kernel_name=python3
if errorlevel 1 goto :fail
echo FULL RUN finished %date% %time%
echo.
python show_results.py 04b_timesfm3_fullCA.ipynb
echo.
echo ===== Done. Tell Claude so it can check the files before you upload them to Drive. =====
pause
exit /b 0

:activate_tfm
set "CONDA_ROOT="
for %%D in ("%USERPROFILE%\anaconda3" "%USERPROFILE%\miniconda3" "%LOCALAPPDATA%\anaconda3" "%ProgramData%\anaconda3" "%ProgramData%\miniconda3") do if exist "%%~D\Scripts\activate.bat" if not defined CONDA_ROOT set "CONDA_ROOT=%%~D"
if not defined CONDA_ROOT (
    echo Could not find Anaconda or Miniconda on this PC.
    exit /b 1
)
if not exist "%CONDA_ROOT%\envs\tfm\python.exe" (
    echo The "tfm" environment does not exist yet. Run setup_env.bat first.
    exit /b 1
)
call "%CONDA_ROOT%\Scripts\activate.bat" tfm
python -c "import sys; p=sys.executable.lower(); print('Using Python:', sys.executable); raise SystemExit(0 if ('envs' in p and 'tfm' in p) else 1)"
if errorlevel 1 (
    echo PROBLEM: the "tfm" environment did not activate.
    exit /b 1
)
exit /b 0

:fail
echo.
echo ===== FULL RUN STOPPED WITH AN ERROR. Send Claude the error above. =====
echo Finished windows are saved; running this file again continues where it stopped.
pause
exit /b 1
