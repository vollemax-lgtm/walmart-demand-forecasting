@echo off
REM One-time setup for LightGBM only: creates a small "lgbm" conda environment (no PyTorch needed).
setlocal
cd /d "%~dp0"
set "CONDA_ROOT="
for %%D in ("%USERPROFILE%\anaconda3" "%USERPROFILE%\miniconda3" "%LOCALAPPDATA%\anaconda3" "%ProgramData%\anaconda3" "%ProgramData%\miniconda3") do if exist "%%~D\Scripts\activate.bat" if not defined CONDA_ROOT set "CONDA_ROOT=%%~D"
if not defined CONDA_ROOT (
    echo Could not find Anaconda or Miniconda on this PC.
    goto :fail
)
if not exist "%CONDA_ROOT%\envs\lgbm\python.exe" (
    echo Creating conda environment "lgbm" with Python 3.11 ...
    call "%CONDA_ROOT%\Scripts\conda.exe" create -n lgbm python=3.11 -y || goto :fail
) else (
    echo Conda environment "lgbm" already exists, reusing it.
)
call "%CONDA_ROOT%\Scripts\activate.bat" lgbm
python -c "import sys; p=sys.executable.lower(); print('Using Python:', sys.executable); raise SystemExit(0 if ('envs' in p and 'lgbm' in p) else 1)"
if errorlevel 1 (
    echo PROBLEM: the "lgbm" environment did not activate.
    goto :fail
)
python -m pip install --upgrade pip
python -m pip install lightgbm pandas pyarrow matplotlib jupyter nbconvert ipykernel || goto :fail
echo.
echo ===== CHECK =====
python -c "import lightgbm, pandas, pyarrow, os; print('LightGBM', lightgbm.__version__, '| pandas', pandas.__version__, '| CPU threads', os.cpu_count())" || goto :fail
echo.
echo ===== SETUP DONE. Next: .\run_lgbm_test.bat cpu =====
pause
exit /b 0

:fail
echo.
echo ===== SETUP FAILED. Copy the error text above and send it to Claude. =====
pause
exit /b 1
