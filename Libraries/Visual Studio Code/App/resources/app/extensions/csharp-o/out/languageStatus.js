/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", 'vscode', './protocol', 'path'], function (require, exports, vscode_1, protocol_1, path_1) {
    var ManagedDisposable = (function () {
        function ManagedDisposable() {
        }
        Object.defineProperty(ManagedDisposable.prototype, "value", {
            set: function (value) {
                this.dispose();
                this._previous = value;
            },
            enumerable: true,
            configurable: true
        });
        ManagedDisposable.prototype.dispose = function () {
            if (this._previous) {
                this._previous.dispose();
            }
        };
        return ManagedDisposable;
    })();
    var defaultSelector = ['csharp', { pattern: '**/project.json' }, { pattern: '**/*.sln' }, { pattern: '**/*.csproj' }];
    function reportLanguageStatus(server) {
        var disposable = new ManagedDisposable();
        var disposables = [];
        disposables.push(server.onServerError(function (err) {
            disposable.value = vscode_1.languages.addErrorLanguageStatus(defaultSelector, {
                message: 'Error starting OmniSharp',
                octicon: 'flame'
            }, 'o.showOutput');
        }));
        disposables.push(server.onMultipleLaunchTargets(function (targets) {
            disposable.value = vscode_1.languages.addWarningLanguageStatus(defaultSelector, {
                message: 'Select project',
                octicon: 'flame'
            }, 'o.pickProjectAndStart');
        }));
        disposables.push(server.onBeforeServerStart(function (path) {
            disposable.value = vscode_1.languages.addInformationLanguageStatus(defaultSelector, {
                message: 'Starting...',
                octicon: 'flame'
            }, 'o.pickProjectAndStart');
        }));
        disposables.push(server.onServerStart(function (path) {
            disposable.value = vscode_1.languages.addInformationLanguageStatus(defaultSelector, {
                message: 'Running',
                octicon: 'flame'
            }, 'o.pickProjectAndStart');
            function updateProjectInfo() {
                server.makeRequest(protocol_1.Projects).then(function (info) {
                    var resources = [];
                    var message;
                    // show sln-file if applicable
                    if (info.MSBuild.SolutionPath) {
                        message = path_1.basename(info.MSBuild.SolutionPath); //workspace.getRelativePath(info.MSBuild.SolutionPath);
                        resources.push(vscode_1.Uri.file(info.MSBuild.SolutionPath));
                        for (var _i = 0, _a = info.MSBuild.Projects; _i < _a.length; _i++) {
                            var project = _a[_i];
                            resources.push(vscode_1.Uri.file(project.Path));
                            for (var _b = 0, _c = project.SourceFiles; _b < _c.length; _b++) {
                                var sourceFile = _c[_b];
                                resources.push(vscode_1.Uri.file(sourceFile));
                            }
                        }
                    }
                    // show dnx projects if applicable
                    var count = 0;
                    for (var _d = 0, _e = info.Dnx.Projects; _d < _e.length; _d++) {
                        var project = _e[_d];
                        count += 1;
                        resources.push(vscode_1.Uri.file(project.Path));
                        for (var _f = 0, _g = project.SourceFiles; _f < _g.length; _f++) {
                            var sourceFile = _g[_f];
                            resources.push(vscode_1.Uri.file(sourceFile));
                        }
                    }
                    if (message) {
                    }
                    else if (count === 1) {
                        message = path_1.basename(info.Dnx.Projects[0].Path); //workspace.getRelativePath(info.Dnx.Projects[0].Path);
                    }
                    else {
                        message = count + " projects";
                    }
                    // show a precise message for active resources and a generic
                    // message for other resources
                    var d1 = vscode_1.languages.addInformationLanguageStatus(resources, {
                        message: message,
                        octicon: 'flame'
                    }, 'o.pickProjectAndStart');
                    var d2 = vscode_1.languages.addInformationLanguageStatus(defaultSelector, {
                        message: 'Switch project',
                        octicon: 'flame'
                    }, 'o.pickProjectAndStart');
                    disposable.value = vscode_1.Disposable.of(d1, d2);
                });
            }
            disposables.push(server.onProjectAdded(updateProjectInfo));
            disposables.push(server.onProjectChange(updateProjectInfo));
            disposables.push(server.onProjectRemoved(updateProjectInfo));
        }));
        return new vscode_1.Disposable(function () {
            disposable.dispose();
            vscode_1.Disposable.of.apply(vscode_1.Disposable, disposables).dispose();
        });
    }
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.default = reportLanguageStatus;
});
//# sourceMappingURL=languageStatus.js.map