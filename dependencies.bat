@echo off

echo Checking and installing dependencies...

python --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Python is not installed. Please install Python before proceeding.
    pause
    exit /b
)

set PACKAGES=ultralytics onnx onnxruntime torch torchvision numpy

for %%P in (%PACKAGES%) do (
    python -c "import %%P" >nul 2>&1
    IF %ERRORLEVEL% NEQ 0 (
        echo Installing missing package: %%P
        python -m pip install %%P
    ) ELSE (
        echo Package %%P is already installed.
    )
)

echo Dependency installation completed.
echo Press any key to start the exporting process
pause >nul
cls
