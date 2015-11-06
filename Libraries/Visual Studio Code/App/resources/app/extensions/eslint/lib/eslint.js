/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
var vscode_languageworker_1 = require('vscode-languageworker');
var settings = null;
var options = null;
var lib = null;
function makeDiagnostic(problem) {
    return {
        message: problem.message,
        severity: convertSeverity(problem.severity),
        start: {
            line: problem.line,
            character: problem.column
        }
    };
}
function convertSeverity(severity) {
    switch (severity) {
        // Eslint 1 is warning
        case 1:
            return vscode_languageworker_1.Severity.Warning;
        case 2:
            return vscode_languageworker_1.Severity.Error;
        default:
            return vscode_languageworker_1.Severity.Error;
    }
}
var validator = {
    initialize: function (rootFolder) {
        return vscode_languageworker_1.Files.resolveModule(rootFolder, 'eslint').then(function (value) {
            if (!value.CLIEngine) {
                return {
                    success: false,
                    message: 'The eslint library doesn\'t export a CLIEngine. You need at least eslint@1.0.0'
                };
            }
            lib = value;
            return null;
        }, function (error) {
            return Promise.reject({
                success: false,
                message: 'Failed to load eslint library. Please install eslint in your workspace folder using \'npm install eslint\' and then press Retry.',
                retry: true
            });
        });
    },
    onConfigurationChange: function (_settings, requestor) {
        settings = _settings;
        if (settings.eslint) {
            options = settings.eslint.options || {};
        }
        requestor.all();
    },
    validate: function (document) {
        var CLIEngine = lib.CLIEngine;
        try {
            var cli = new CLIEngine(options);
            var content = document.getText();
            var uri = document.uri;
            var report = cli.executeOnText(content, vscode_languageworker_1.Files.uriToFilePath(uri));
            var diagnostics = [];
            if (report && report.results && Array.isArray(report.results) && report.results.length > 0) {
                var docReport = report.results[0];
                if (docReport.messages && Array.isArray(docReport.messages)) {
                    docReport.messages.forEach(function (problem) {
                        if (problem) {
                            diagnostics.push(makeDiagnostic(problem));
                        }
                    });
                }
            }
            return diagnostics;
        }
        catch (err) {
            var message = null;
            if (typeof err.message === 'string' || err.message instanceof String) {
                message = err.message;
                message = message.replace(/\r?\n/g, ' ');
                if (/^CLI: /.test(message)) {
                    message = message.substr(5);
                }
                throw new vscode_languageworker_1.LanguageWorkerError(message, vscode_languageworker_1.MessageKind.Show);
            }
            throw err;
        }
    }
};
vscode_languageworker_1.runSingleFileValidator(process.stdin, process.stdout, validator);
