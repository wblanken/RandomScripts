@echo off

set PLATDIR="HpTootsiePkg"

pushd .

cd %PLATDIR%

:prep
if "%WPREP%" == "" (
   if "%2" == "dbg" goto prep_dbg   
   if "%2" == "" goto prep_dbg 
   if "%2" == "rel" goto prep_rel       
)

if not %WPREP% == "%2" (
   if "%2" == "" (
      if "%WPREP%" == "dbg" @goto main
      if "%WPREP%" == "rel" (
         goto prep_dbg
      )
   )
   if "%2" == "dbg" goto prep_dbg  
   if "%2" == "rel" goto prep_rel
)

:main
@echo off
if %WPREP% == "dbg" echo "Building Debug BIOS..."
if %WPREP% == "rel" echo "Building Release BIOS..."

if "%1" == "b" (
   call hpbld.bat
)
if "%1" == "rb" (
   call hpcln.bat
   call hpbld.bat
)
if "%1" == "cln" (
   call hpcln.bat
)

goto done

:prep_dbg
echo "Preping for debug build..."
call HpPrep.bat
if %ERRORLEVEL% == 1 goto prep_fail
if %PREP_FAIL% == 1 goto prep_fail
set WPREP="dbg"
goto main

:prep_rel
echo "Preping for release build..."
call HpPrep.bat r
if %ERRORLEVEL% == 1 goto prep_fail
if %PREP_FAIL% == 1 goto prep_fail
set WPREP="rel"
goto main

:prep_fail
echo "Prep failed please run again!"
set WPREP=""
goto done

:done
popd