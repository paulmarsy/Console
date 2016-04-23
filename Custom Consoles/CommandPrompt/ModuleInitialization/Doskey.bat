DOSKEY /REINSTALL

DOSKEY ls=DIR $*
DOSKEY cat=TYPE $*
DOSKEY mv=RENAME $*
DOSKEY e=START "%CommandPromptConsoleCodeExecutable%" "$*"
DOSKEY Reload-CommandPromptConsole=CALL "%CustomConsolesInstallPath%Custom Consoles\CommandPrompt\Initialize.bat"
