@del MsPacManTENGENDis.o
@del MsPacManTENGENDis.nes
@echo.
@echo Compiling...
cc65\bin\ca65 MsPacManTENGENDis.asm -g -o MsPacManTENGENDis.o
@IF ERRORLEVEL 1 GOTO failure
@echo.
@echo Linking...
cc65\bin\ld65 -o MsPacManTENGENDis.nes -C LinkerConfiguration.cfg MsPacManTENGENDis.o
@echo.
@echo Success!
@pause
@GOTO endbuild
:failure
@echo.
@echo Build error!
@pause
:endbuild
