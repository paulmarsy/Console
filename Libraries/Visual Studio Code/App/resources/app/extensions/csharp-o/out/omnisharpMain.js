/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", './features/declarationSupport', './features/codeLensSupport', './features/occurrencesSupport', './features/outlineSupport', './features/quickFixSupport', './features/referenceSupport', './features/extraInfoSupport', './features/renameSupport', './features/formattingSupport', './features/suggestSupport', './features/bufferSyncSupport', './features/navigateTypesSupport', './features/diagnosticsSupport', './features/parameterHintsSupport', './features/fileSyncSupport', './features/commandsSupport', './features/telemetrySupport', './omnisharpServer.native', './omnisharpStatus', './languageStatus', './telemetryReporter', 'vscode'], function (require, exports, declarationSupport_1, codeLensSupport_1, occurrencesSupport_1, outlineSupport_1, quickFixSupport_1, referenceSupport_1, extraInfoSupport_1, renameSupport_1, formattingSupport_1, suggestSupport_1, bufferSyncSupport_1, navigateTypesSupport_1, diagnosticsSupport_1, parameterHintsSupport_1, fileSyncSupport_1, commandsSupport_1, telemetrySupport_1, omnisharpServer_native_1, omnisharpStatus_1, languageStatus_1, telemetryReporter_1, vscode_1) {
    function activate(subscriptions) {
        var server = new omnisharpServer_native_1.StdioOmnisharpServer();
        var advisor = new diagnosticsSupport_1.Advisor(server);
        var disposables = [];
        var supports = [];
        // add supports when server started
        disposables.push(server.onServerStart(function () {
            supports.push(vscode_1.Modes.DeclarationSupport.register('csharp', new declarationSupport_1.default(server)));
            supports.push(vscode_1.Modes.CodeLensSupport.register('csharp', new codeLensSupport_1.default(server)));
            supports.push(vscode_1.Modes.OccurrencesSupport.register('csharp', new occurrencesSupport_1.default(server)));
            supports.push(vscode_1.Modes.OutlineSupport.register('csharp', new outlineSupport_1.default(server)));
            supports.push(vscode_1.Modes.ReferenceSupport.register('csharp', new referenceSupport_1.default(server)));
            supports.push(vscode_1.Modes.ExtraInfoSupport.register('csharp', new extraInfoSupport_1.default(server)));
            supports.push(vscode_1.Modes.RenameSupport.register('csharp', new renameSupport_1.default(server)));
            supports.push(vscode_1.Modes.FormattingSupport.register('csharp', new formattingSupport_1.default(server)));
            supports.push(vscode_1.Modes.SuggestSupport.register('csharp', new suggestSupport_1.default(server)));
            supports.push(vscode_1.Modes.NavigateTypesSupport.register('csharp', new navigateTypesSupport_1.default(server)));
            supports.push(vscode_1.Modes.ParameterHintsSupport.register('csharp', new parameterHintsSupport_1.default(server)));
            supports.push(vscode_1.Modes.QuickFixSupport.register('csharp', new quickFixSupport_1.default(server)));
            supports.push(new fileSyncSupport_1.default(server));
            supports.push(new bufferSyncSupport_1.default(server));
            supports.push(new diagnosticsSupport_1.default(server, advisor));
        }));
        // remove previous supports
        disposables.push(server.onServerStop(function () {
            vscode_1.Disposable.of.apply(vscode_1.Disposable, supports).dispose();
        }));
        disposables.push(forwardOutput(server));
        disposables.push(omnisharpStatus_1.default(server));
        disposables.push(languageStatus_1.default(server));
        disposables.push(telemetrySupport_1.default(server));
        disposables.push(commandsSupport_1.default(server));
        var memento = vscode_1.extensions.getStateMemento('omnisharp');
        memento.getValue('lastSolutionPathOrFolder').then(function (path) { return server.autoStart(path); }, function (_) { return server.autoStart(undefined); });
        server.onBeforeServerStart(function (path) { return memento.setValue('lastSolutionPathOrFolder', path); });
        telemetryReporter_1.TelemetryReporter.setupTelemetryReporter('omnisharp', 'AIF-d9b70cd4-b9f9-4d70-929b-a071c400b217');
        return vscode_1.Disposable.of.apply(vscode_1.Disposable, disposables);
    }
    exports.activate = activate;
    function forwardOutput(server) {
        var logChannel = vscode_1.window.getOutputChannel('OmniSharp Log');
        var timing200Pattern = /^\[INFORMATION:OmniSharp.Middleware.LoggingMiddleware\] \/\w+: 200 \d+ms/;
        function forward(message) {
            // strip stuff like: /codecheck: 200 339ms
            if (!timing200Pattern.test(message)) {
                logChannel.append(message);
            }
        }
        return vscode_1.Disposable.of(server.onStdout(forward), server.onStderr(forward));
    }
});
//# sourceMappingURL=omnisharpMain.js.map