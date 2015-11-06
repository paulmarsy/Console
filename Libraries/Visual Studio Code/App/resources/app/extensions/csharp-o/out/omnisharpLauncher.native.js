/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", 'vs/base/node/mono', 'fs', 'child_process', 'vscode'], function (require, exports, mono_1, fs_1, child_process_1, vscode_1) {
    var omnisharpEnv = 'OMNISHARP';
    var isWindows = /^win/.test(process.platform);
    function launch(cwd, args) {
        return new Promise(function (resolve, reject) {
            try {
                (isWindows ? launchWindows(cwd, args) : launchNix(cwd, args)).then(function (value) {
                    // async error - when target not not ENEOT
                    value.process.on('error', reject);
                    // success after a short freeing event loop
                    setTimeout(function () {
                        resolve(value);
                    }, 0);
                }, function (err) {
                    reject(err);
                });
            }
            catch (err) {
                reject(err);
            }
        });
    }
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.default = launch;
    function launchWindows(cwd, args) {
        return getOmnisharpPath().then(function (command) {
            args = args.slice(0);
            args.unshift(command);
            args = [[
                    '/s',
                    '/c',
                    '"' + args.map(function (arg) { return /^[^"].* .*[^"]/.test(arg) ? "\"" + arg + "\"" : arg; }).join(' ') + '"'
                ].join(' ')];
            var process = child_process_1.spawn('cmd', args, {
                windowsVerbatimArguments: true,
                detached: false,
                // env: details.env,
                cwd: cwd
            });
            return {
                process: process,
                command: command
            };
        });
    }
    function launchNix(cwd, args) {
        return new Promise(function (resolve, reject) {
            mono_1.hasMono('>=4.0.1').then(function (hasIt) {
                if (!hasIt) {
                    reject(new Error('Cannot start Omnisharp because Mono version >=4.0.1 is required. See http://go.microsoft.com/fwlink/?linkID=534832#_20001'));
                }
                else {
                    resolve();
                }
            });
        }).then(function (_) {
            return getOmnisharpPath();
        }).then(function (command) {
            var process = child_process_1.spawn(command, args, {
                detached: false,
                // env: details.env,
                cwd: cwd
            });
            return {
                process: process,
                command: command
            };
        });
    }
    function getOmnisharpPath() {
        return new Promise(function (resolve, reject) {
            vscode_1.extensions.getConfigurationMemento('csharp').getValue('omnisharp').then(function (value) {
                if (value) {
                    return value;
                }
                // form enviroment variable
                if (typeof process.env[omnisharpEnv] === 'string') {
                    console.warn('[deprecated] use workspace or user settings with "csharp.omnisharp":"/path/to/omnisharp"');
                    return process.env[omnisharpEnv];
                }
            }).then(function (value) {
                if (value) {
                    return value;
                }
                // bundled version of Omnisharp
                var local = vscode_1.Uri.parse(require.toUrl('../bin/omnisharp')).fsPath;
                local = isWindows
                    ? local + '.cmd'
                    : local;
                return local;
            }).then(function (value) {
                if (!value) {
                    return reject('Local OmniSharp bin folder not found and OMNISHARP env variable not set');
                }
                fs_1.exists(value, function (localExists) {
                    if (localExists) {
                        resolve(value);
                    }
                    else {
                        reject('OmniSharp does not exist at location: ' + value);
                    }
                });
            }, function (err) {
                console.error(err);
                reject(err);
            });
        });
    }
});
//# sourceMappingURL=omnisharpLauncher.native.js.map