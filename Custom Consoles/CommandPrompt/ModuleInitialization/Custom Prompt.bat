"%CommandPromptConsoleLibraries%\Binaries\IsAdmin.exe" -q
IF %ERRORLEVEL% == 1 (
  SET PROMPTCOLOR=31
) ELSE (
  SET PROMPTCOLOR=32
)

REM $E[X;Y;Zm - X - Text attribute (0 - None, 1 - Bold, 4 - Underscore)
REM				Y - Foreground color (30 - Black, 31 - Red, 32 - Green, 33 - Yellow, 34 - Blue, 35 - Magenta, 36 - Cyan, 37 - White)
REM				Z - Background color (40 - Black, 41 - Red, 42 - Green, 43 - Yellow, 44 - Blue, 45 - Magenta, 46 - Cyan, 47 - White)
REM $P - Current Drive and Path
REM	$C - (
REM $+ - Number of '+' characters for each directorys pushed onto the stack
REM $F - )
REM $$ - $
REM $S - Space

REM        [                    ][][][         ][][]
SET PROMPT=$E[1;%PROMPTCOLOR%;40m$P$+$E[0;37;40m$$$S