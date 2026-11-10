@echo off
REM One-time setup: creates the "tfm" conda environment with GPU PyTorch and TimesFM-3.
setlocal
cd /d "%~dp0"
set "CONDA_ROOT="
for %%D in ("%USERPROFILE%\anaconda3" "%USERPROFILE%\miniconda3" "%LOCALAPPDATA%\anaconda3" "%ProgramData%\anaconda3" "%ProgramData%\miniconda3") do if exist "%%~D\Scripts\activate.bat" if not defined CONDA_ROOT set "CONDA_ROOT=%%~D"
if not defined CONDA_ROOT (
    echo Could not find Anaconda or Miniconda on this PC.
    goto :fail
)
if not exist "%CONDA_ROOT%\envs\tfm\python.exe" (
    echo Creating conda environment "tfm" with Python 3.11 ...
    call "%CONDA_ROOT%\Scripts\conda.exe" create -n tfm python=3.11 -y || goto :fail
) else (
    echo Conda environment "tfm" already exists, reusing it.
)
call :activate_tfm || goto :fail

python -m pip install --upgrade pip
echo Installing PyTorch with CUDA (GPU) support ...
python -m pip install torch --index-url https://download.pytorch.org/whl/cu128 || goto :fail
echo Installing TimesFM-3 and the other packages ...
python -m pip install "timesfm[torch]==3.0.2" pandas pyarrow matplotlib jupyter nbconvert ipykernel || goto :fail

echo.
echo ===== CHECK 1: can PyTorch see the GPU? =====
set KMP_DUPLICATE_LIB_OK=TRUE
python -c "import torch; ok=torch.cuda.is_available(); print('GPU found:', ok, '|', torch.cuda.get_device_name(0) if ok else 'NONE', '| torch', torch.__version__); raise SystemExit(0 if ok else 1)"
if errorlevel 1 (
    echo PROBLEM: PyTorch cannot see the GPU.
    goto :fail
)
echo ===== CHECK 2: does TimesFM-3 import? =====
python -c "from timesfm3 import TimesFM3Forecaster; print('timesfm3 OK')"
if errorlevel 1 (
    echo Import failed, trying again after installing jax ...
    python -m pip install jax
    python -c "from timesfm3 import TimesFM3Forecaster; print('timesfm3 OK')" || goto :fail
)
echo.
echo ===== SETUP DONE. Next: run_test.bat =====
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
echo ===== SETUP FAILED. Copy the error text above and send it to Claude. =====
pause
exit /b 1
