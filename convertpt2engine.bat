@echo off

title PT2ENGINE

set HEADER======================= PT2ENGINE Official ====================

setlocal enabledelayedexpansion
cls
call :showHeader

choice /c yn /n /m "Do you want to check and install dependencies? (y/n): "
if %errorlevel%==1 (
    cls
    call :showHeader
    call dependencies.bat
    echo.
) else (
    cls
    call :showHeader
    echo Skipping dependency check...
)

:askModel
cls
call :showHeader
set /p MODEL="Enter the model filename to export (e.g., 'best.pt', ensure this file is in the same directory as this program): "

IF "%MODEL%"=="" (
    cls
    call :showHeader
    echo Model filename cannot be empty. Please try again.
    pause >nul
    goto askModel
)

for /f "tokens=* delims=" %%a in ("%MODEL%") do set MODEL=%%a

if /i not "%MODEL:~-3%"==".pt" (
    cls
    call :showHeader
    color 0C
    echo ERROR: The file name must end with '.pt'. Please try again.
    echo.
    echo Press any key to restart
    pause >nul
    color 07
    goto askModel
)

if exist "%MODEL%" (
    cls
    call :showHeader
    for %%F in ("%MODEL%") do set FULL_PATH=%%~fF
    echo Model file found:
    echo File: %MODEL%
    echo.
    echo This process can take up to 5 minutes.
    echo.
    choice /c yn /n /m "Do you want to proceed with exporting this file? (y/n): "
    if %errorlevel%==2 (
        cls
        call :showHeader
        echo Export cancelled by the user.
        pause
        exit /b
    )
) ELSE (
    cls
    call :showHeader
    echo Model file '%MODEL%' does not exist in the current directory. Please ensure the file is present.
    echo.
    echo Press any key to restart.
    pause >nul
    goto askModel
)

cls
call :showHeader
echo Running YOLO export for:
echo    File: %MODEL%
echo    Path: %FULL_PATH%
yolo export model="%MODEL%" format="engine" 

cls
echo Export process completed.
pause
exit /b

:showHeader
echo %HEADER%
echo.
goto :eof
