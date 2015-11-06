/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
define(["require", "exports", '../omnisharp', './abstractSupport', '../protocol', 'vscode'], function (require, exports, omnisharp_1, abstractSupport_1, Protocol, vscode_1) {
    var Advisor = (function () {
        function Advisor(server) {
            this._packageRestoreCounter = 0;
            this._projectSourceFileCounts = Object.create(null);
            this._server = server;
            var d1 = server.onProjectChange(this._onProjectChange, this);
            var d2 = server.onBeforePackageRestore(this._onBeforePackageRestore, this);
            var d3 = server.onPackageRestore(this._onPackageRestore, this);
            this._disposable = vscode_1.Disposable.of(d1, d2, d3);
        }
        Advisor.prototype.dispose = function () {
            this._disposable.dispose();
        };
        Advisor.prototype.shouldValidateFiles = function () {
            return this._isServerStarted()
                && !this._isRestoringPackages();
        };
        Advisor.prototype.shouldValidateProject = function () {
            return this._isServerStarted()
                && !this._isRestoringPackages()
                && !this._isHugeProject();
        };
        Advisor.prototype._onProjectChange = function (info) {
            if (info.DnxProject && info.DnxProject.SourceFiles) {
                this._projectSourceFileCounts[info.DnxProject.Path] = info.DnxProject.SourceFiles.length;
            }
            if (info.MsBuildProject && info.MsBuildProject.SourceFiles) {
                this._projectSourceFileCounts[info.MsBuildProject.Path] = info.MsBuildProject.SourceFiles.length;
            }
        };
        Advisor.prototype._onBeforePackageRestore = function () {
            this._packageRestoreCounter += 1;
        };
        Advisor.prototype._onPackageRestore = function () {
            this._packageRestoreCounter -= 1;
        };
        Advisor.prototype._isServerStarted = function () {
            return this._server.isRunning();
        };
        Advisor.prototype._isRestoringPackages = function () {
            return this._packageRestoreCounter > 0;
        };
        Advisor.prototype._isHugeProject = function () {
            var sourceFileCount = 0;
            for (var key in this._projectSourceFileCounts) {
                sourceFileCount += this._projectSourceFileCounts[key];
                if (sourceFileCount > 1000) {
                    return true;
                }
            }
            return false;
        };
        return Advisor;
    })();
    exports.Advisor = Advisor;
    var DiagnosticsSupport = (function (_super) {
        __extends(DiagnosticsSupport, _super);
        function DiagnosticsSupport(server, validationAdvisor) {
            _super.call(this, server);
            this._documentValidations = Object.create(null);
            this._documentDiagnostics = Object.create(null);
            this._validationAdvisor = validationAdvisor;
            var d1 = this.server().onPackageRestore(this._validateProject, this);
            var d2 = this.server().onProjectChange(this._validateProject, this);
            var d4 = vscode_1.workspace.onDidOpenTextDocument(this._onDocumentAddOrChange, this);
            var d3 = vscode_1.workspace.onDidChangeTextDocument(this._onDocumentAddOrChange, this);
            var d5 = vscode_1.workspace.onDidCloseTextDocument(this._onDocumentRemove, this);
            this._disposable = vscode_1.Disposable.of(d1, d2, d3, d4, d5);
        }
        DiagnosticsSupport.prototype.dispose = function () {
            this._disposable.dispose();
            this._projectValidation.dispose();
            this._projectDiagnostics.dispose();
            for (var key in this._documentValidations) {
                this._documentValidations[key].dispose();
            }
            for (var key in this._documentDiagnostics) {
                this._documentDiagnostics[key].dispose();
            }
        };
        DiagnosticsSupport.prototype._onDocumentAddOrChange = function (event) {
            var document;
            if (event instanceof vscode_1.TextDocument) {
                document = event;
            }
            else {
                document = event.document;
            }
            if (document.getLanguageId() === 'csharp' && !this.isInMemory(document.getUri())) {
                this._validateDocument(document);
                this._validateProject();
            }
        };
        DiagnosticsSupport.prototype._onDocumentRemove = function (document) {
            var key = document.getUri().toString();
            var didChange = false;
            if (this._documentDiagnostics[key]) {
                didChange = true;
                this._documentDiagnostics[key].dispose();
                delete this._documentDiagnostics[key];
            }
            if (this._documentValidations[key]) {
                didChange = true;
                this._documentValidations[key].cancel();
                delete this._documentValidations[key];
            }
            if (didChange) {
                this._validateProject();
            }
        };
        DiagnosticsSupport.prototype._validateDocument = function (document) {
            var _this = this;
            if (!this._validationAdvisor.shouldValidateFiles()) {
                return;
            }
            var key = document.getUri().toString();
            if (this._documentValidations[key]) {
                this._documentValidations[key].cancel();
            }
            var source = new vscode_1.CancellationTokenSource();
            var handle = setTimeout(function () {
                var request = { Filename: document.getUri().fsPath };
                _this.server().makeRequest(Protocol.CodeCheck, request, source.token).then(function (value) {
                    // remove old diagnostics if they exist
                    if (_this._documentDiagnostics[key]) {
                        _this._documentDiagnostics[key].dispose();
                    }
                    // add new diagnostics and store disposable
                    var diagnostics = value.QuickFixes.map(DiagnosticsSupport._asDiagnostic);
                    _this._documentDiagnostics[key] = vscode_1.languages.addDiagnostics(diagnostics);
                });
            }, 750);
            source.token.onCancellationRequested(function () { return clearTimeout(handle); });
            this._documentValidations[key] = source;
        };
        DiagnosticsSupport.prototype._validateProject = function () {
            var _this = this;
            if (!this._validationAdvisor.shouldValidateProject()) {
                return;
            }
            if (this._projectValidation) {
                this._projectValidation.cancel();
            }
            this._projectValidation = new vscode_1.CancellationTokenSource();
            var handle = setTimeout(function () {
                _this.server().makeRequest(Protocol.CodeCheck, {}, _this._projectValidation.token).then(function (value) {
                    var diagnostics = value.QuickFixes
                        .map(DiagnosticsSupport._asDiagnostic)
                        .filter(function (diag) { return !_this._documentValidations[diag.location.uri.toString()]; });
                    if (_this._projectDiagnostics) {
                        _this._projectDiagnostics.dispose();
                    }
                    _this._projectDiagnostics = vscode_1.languages.addDiagnostics(diagnostics);
                });
            }, 3000);
            // clear timeout on cancellation
            this._projectValidation.token.onCancellationRequested(function () {
                clearTimeout(handle);
            });
        };
        // --- data converter
        DiagnosticsSupport._asDiagnostic = function (quickFix) {
            var location = new vscode_1.Location(vscode_1.Uri.file(quickFix.FileName), new vscode_1.Range(quickFix.Line, quickFix.Column, quickFix.EndLine, quickFix.EndColumn));
            var message = quickFix.Text + " [" + quickFix.Projects.map(function (n) { return omnisharp_1.asProjectLabel(n); }).join(', ') + "]";
            var severity = DiagnosticsSupport._asDiagnosticSeverity(quickFix.LogLevel);
            return new vscode_1.Diagnostic(severity, location, message);
        };
        DiagnosticsSupport._asDiagnosticSeverity = function (logLevel) {
            switch (logLevel.toLowerCase()) {
                case 'hidden':
                case 'warning':
                case 'warn':
                    return vscode_1.DiagnosticSeverity.Warning;
                default:
                    return vscode_1.DiagnosticSeverity.Error;
            }
        };
        return DiagnosticsSupport;
    })(abstractSupport_1.default);
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.default = DiagnosticsSupport;
});
//# sourceMappingURL=diagnosticsSupport.js.map