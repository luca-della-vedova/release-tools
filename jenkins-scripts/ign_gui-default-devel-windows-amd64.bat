@echo on
set SCRIPT_DIR=%~dp0

set VCS_DIRECTORY=ign-gui
set PLATFORM_TO_BUILD=x86_amd64
set IGN_CLEAN_WORKSPACE=true

:: ogre2 from vcpkg-ports
set DEPEN_PKGS="qt5 qwt protobuf tinyxml2 freeimage ogre ogre2"
:: This needs to be migrated to DSL to get multi-major versions correctly
set COLCON_PACKAGE=ignition-gui
set COLCON_AUTO_MAJOR_VERSION=true

call "%SCRIPT_DIR%\lib\colcon-default-devel-windows.bat"
