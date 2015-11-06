/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", '../protocol', 'vscode', 'path', '../launchTargetFinder'], function (require, exports, Protocol, vscode_1, path_1, launchTargetFinder_1) {
    var isWin = /^win/.test(process.platform);
    function registerCommands(server) {
        var d1 = vscode_1.commands.registerCommand('o.restart', function () { return server.restart(); });
        var d2 = vscode_1.commands.registerCommand('o.pickProjectAndStart', function () { return pickProjectAndStart(server); });
        var d3 = vscode_1.commands.registerCommand('o.restore', function () { return dnxRestoreForAll(server); });
        var d4 = vscode_1.commands.registerCommand('o.execute', function () { return dnxExecuteCommand(server); });
        var d5 = vscode_1.commands.registerCommand('o.execute-last-command', function () { return dnxExecuteLastCommand(server); });
        var d6 = vscode_1.commands.registerCommand('o.showOutput', function () { return vscode_1.window.getOutputChannel('OmniSharp Log').reveal(); });
        return vscode_1.Disposable.of(d1, d2, d3, d4, d5, d6);
    }
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.default = registerCommands;
    function pickProjectAndStart(server) {
        return launchTargetFinder_1.default().then(function (targets) {
            var currentPath = server.getSolutionPathOrFolder();
            if (currentPath) {
                for (var _i = 0; _i < targets.length; _i++) {
                    var target = targets[_i];
                    if (target.target.fsPath === currentPath) {
                        target.label = "\u2713 " + target.label;
                    }
                }
            }
            return vscode_1.window.showQuickPick(targets, {
                matchOnDescription: true,
                placeHolder: "Select 1 of " + targets.length + " projects"
            }).then(function (target) {
                if (target) {
                    return server.restart(target.target.fsPath);
                }
            });
        });
    }
    var lastCommand;
    function dnxExecuteLastCommand(server) {
        if (lastCommand) {
            lastCommand.execute();
        }
        else {
            dnxExecuteCommand(server);
        }
    }
    function dnxExecuteCommand(server) {
        if (!server.isRunning()) {
            return Promise.reject('OmniSharp server is not running.');
        }
        return server.makeRequest(Protocol.Projects).then(function (info) {
            var commands = [];
            info.Dnx.Projects.forEach(function (project) {
                Object.keys(project.Commands).forEach(function (key) {
                    commands.push({
                        label: "dnx " + key + " - (" + (project.Name || path_1.basename(project.Path)) + ")",
                        description: path_1.dirname(project.Path),
                        execute: function () {
                            lastCommand = this;
                            var command = path_1.join(info.Dnx.RuntimePath, 'bin/dnx');
                            var args = [key];
                            // dnx-beta[1-6] needs a leading dot, like 'dnx . run'
                            if (/-beta[1-6]/.test(info.Dnx.RuntimePath)) {
                                args.unshift('.');
                            }
                            if (isWin) {
                                command += '.exe';
                            }
                            return vscode_1.window.runInTerminal(command, args, {
                                cwd: path_1.dirname(project.Path),
                                env: {}
                            });
                        }
                    });
                });
            });
            return vscode_1.window.showQuickPick(commands).then(function (command) {
                if (command) {
                    return command.execute();
                }
            });
        });
    }
    function dnxRestoreForAll(server) {
        if (!server.isRunning()) {
            return Promise.reject('OmniSharp server is not running.');
        }
        return server.makeRequest(Protocol.Projects).then(function (info) {
            var commands = [];
            info.Dnx.Projects.forEach(function (project) {
                commands.push({
                    label: "dnu restore - (" + (project.Name || path_1.basename(project.Path)) + ")",
                    description: path_1.dirname(project.Path),
                    execute: function () {
                        var command = path_1.join(info.Dnx.RuntimePath, 'bin/dnu');
                        if (isWin) {
                            command += '.cmd';
                        }
                        return vscode_1.window.runInTerminal(command, ['restore'], {
                            cwd: path_1.dirname(project.Path)
                        });
                    }
                });
            });
            return vscode_1.window.showQuickPick(commands).then(function (command) {
                if (command) {
                    return command.execute();
                }
            });
        });
    }
    exports.dnxRestoreForAll = dnxRestoreForAll;
    function dnxRestoreForProject(server, fileName) {
        return server.makeRequest(Protocol.Projects).then(function (info) {
            for (var _i = 0, _a = info.Dnx.Projects; _i < _a.length; _i++) {
                var project = _a[_i];
                if (project.Path === fileName) {
                    var command = path_1.join(info.Dnx.RuntimePath, 'bin/dnu');
                    if (isWin) {
                        command += '.cmd';
                    }
                    return vscode_1.window.runInTerminal(command, ['restore'], {
                        cwd: path_1.dirname(project.Path)
                    });
                }
            }
            return Promise.reject("Failed to execute restore, try to run 'dnu restore' manually for " + fileName + ".");
        });
    }
    exports.dnxRestoreForProject = dnxRestoreForProject;
});
//# sourceMappingURL=commandsSupport.js.map