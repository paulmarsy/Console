delete process.env['ATOM_SHELL_INTERNAL_RUN_AS_NODE'];
require('child_process').spawn(require('path').resolve(__dirname, '..', 'Code.exe'), process.argv.slice(2), { detached: true, stdio: 'ignore' });
process.exit(0);