/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", 'vscode', './features/commandsSupport'], function (require, exports, vscode, commandsSupport_1) {
    function reportStatus(server) {
        var d0 = server.onServerError(function (err) {
            appendLine('[ERROR] ' + err);
        });
        var d1 = server.onError(function (message) {
            if (message.FileName) {
                appendLine(message.FileName + "(" + message.Line + "," + message.Column + ")");
            }
            appendLine(message.Text);
            appendLine();
            showMessageSoon();
        });
        var d2 = server.onMsBuildProjectDiagnostics(function (message) {
            function asErrorMessage(message) {
                var value = message.FileName + "(" + message.StartLine + "," + message.StartColumn + "): Error: " + message.Text;
                appendLine(value);
            }
            function asWarningMessage(message) {
                var value = message.FileName + "(" + message.StartLine + "," + message.StartColumn + "): Warning: " + message.Text;
                appendLine(value);
            }
            if (message.Errors.length > 0 || message.Warnings.length > 0) {
                appendLine(message.FileName);
                message.Errors.forEach(function (error) { return asErrorMessage; });
                message.Warnings.forEach(function (warning) { return asWarningMessage; });
                appendLine();
                showMessageSoon();
            }
        });
        var d3 = server.onUnresolvedDependencies(function (message) {
            var command = {
                title: 'Restore',
                command: function () {
                    return commandsSupport_1.dnxRestoreForProject(server, message.FileName).catch(function (err) {
                        vscode.window.showErrorMessage(err);
                    });
                }
            };
            vscode.window.showInformationMessage("There are unresolved dependencies from '" + vscode.workspace.getRelativePath(message.FileName) + "'. Please execute the restore command to continue.", command);
        });
        return vscode.Disposable.of(d0, d1, d2, d3);
    }
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.default = reportStatus;
    // show user message
    var _messageHandle;
    function showMessageSoon() {
        clearTimeout(_messageHandle);
        _messageHandle = setTimeout(function () {
            // // ignore errors/warnings
            // actions.push(new _actions.Action('cancel', nls.localize('cancel', "Cancel"), null, true,() => {
            // 	hide();
            // 	return null;
            // }));
            var message = "Some projects have trouble loading. Please review the output for more details.";
            vscode.window.showWarningMessage(message, { title: "Show Output", command: 'o.showOutput' });
        }, 1500);
    }
    // log data
    var _channel = vscode.window.getOutputChannel('OmniSharp Log');
    function appendLine(value) {
        if (value === void 0) { value = ''; }
        _channel.appendLine(value);
    }
});
//# sourceMappingURL=omnisharpStatus.js.map