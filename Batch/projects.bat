@echo off 

if "%1" == "" goto help
if "%2" == "" goto help

:variables
set perl_root=c:\perl64
set project_root=E:\FW\
set project_src=%project_root%\src
set project_bld=%project_root%\bld
set project_scts=%project_root%\projects.ini
set project_get=0
set project_refresh=0
set project_build=0
set project_rebuild=0
set error_msg="!GENERIC ERROR OCCURED!"
set project=%1
set project_name=%project%
set major=""
set minor=""

:arguments

if not errorlevel 0 (
  set error_msg="!ERROR WITH ARGUMENT PARSING!"
  goto error
)
if "%2" == "" goto main
if "%2" == "-g" (
  set project_get=1
  SHIFT /2
  goto arguments
)
if "%2" == "-r" (
  set project_refresh=1
  SHIFT /2
  goto arguments
)
if "%2" == "-b" (
  set project_build=1
  SHIFT /2
  goto arguments
)
if "%2" == "-rb" (
  set project_rebuild=1
  SHIFT /2
  goto arguments
)
set major=%2
set minor=%3
set project_name=%project%_%major%%minor%
if not errorlevel 0 (
  set error_msg="!ERROR WITH ARGUMENT PARSING!"
  goto error
)
SHIFT /2
SHIFT /2
goto arguments

:main
if %project_get% == 1 goto do_get
if %project_refresh% == 1 goto do_refresh
if %project_build% == 1 (
  if %project_rebuild% == 0 (
    goto do_build ))
if %project_rebuild% == 1 goto do_rebuild
if not errorlevel 0 goto error
goto done

:do_get
call %perl_root%\bin\perl.exe %perl_root%\bin\GetProject.pl --config %project_scts% %project_name%
if not errorlevel 0 (
  set error_msg="!ERROR WITH GETTING PROJECT!"
  goto error
)
set project_get=0
goto main

:do_refresh
call %perl_root%\bin\perl.exe %perl_root%\bin\RefreshTree.pl --config %project_scts% %project_name%
if not errorlevel 0 (
  set error_msg="!ERROR WITH REFRESHING PROJECT!"
  goto error
)
set project_refresh=0
goto main

:do_build
cd /d %project_bld%\%project_name% 
call BuildImg.bat %project% timed tailf
if not errorlevel 0 (
  set error_msg="!ERROR WITH BUILDING PROJECT!"
  goto error
)
set project_build=0
goto main

:do_rebuild
cd /d %project_bld%\%project_name%
call BuildImg.bat %project% all timed tailf
if not errorlevel 0 (
  set error_msg="!ERROR WITH REBUILDING PROJECT!"
  goto error
)
set project_rebuild=0
goto main

:help
echo projects.bat project [major] [minor] -g -r -b -rb
echo ex: projects.bat L01 00 15 -g -r -b
echo -g = get project
echo -r = refresh project build tree
echo -b = build project
echo -rb = rebuild project
goto done

:error
echo %error_msg%
echo %project_name%
:done