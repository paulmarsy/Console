DOSKEY /REINSTALL

DOSKEY ls=DIR $*
DOSKEY cat=TYPE $*
DOSKEY mv=RENAME $*
DOSKEY e=START "%CommandPromptConsoleAtomExecutable%" "n -f \"$*\"
DOSKEY Reload-CommandPromptConsole=CALL "%CustomConsolesInstallPath%Custom Consoles\CommandPrompt\Initialize.bat"
