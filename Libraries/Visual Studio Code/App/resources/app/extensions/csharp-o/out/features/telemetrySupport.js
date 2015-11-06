/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", '../protocol', 'vscode', '../telemetryReporter'], function (require, exports, Protocol, vscode_1, telemetryReporter_1) {
    function reportTelemetry(server) {
        var d1 = server.onError(function (message) {
            var isMsBuildish = /\.(csproj|sln)$/.test(message.FileName) ? 1 : 0, isAsp5ish = /project\.json$/.test(message.FileName) ? 1 : 0;
            telemetryReporter_1.TelemetryReporter.getTelemetryReporter().sendTelemetryEvent('omnisharp.diagnostics', null, {
                isMsBuildish: isMsBuildish,
                isAsp5ish: isAsp5ish
            });
        });
        var d2 = server.onMsBuildProjectDiagnostics(function (message) {
            telemetryReporter_1.TelemetryReporter.getTelemetryReporter().sendTelemetryEvent('diagnostics.msbuild', null, {
                errors: message.Errors.length,
                warnings: message.Warnings.length,
            });
        });
        var d3 = server.onServerStart(function () {
            server.makeRequest(Protocol.Projects).then(function (info) {
                telemetryReporter_1.TelemetryReporter.getTelemetryReporter().sendTelemetryEvent('omnisharp.stats.projects', null, {
                    msbuild: !info.MSBuild ? 0 : info.MSBuild.Projects.length,
                    dnx: !info.Dnx ? 0 : info.Dnx.Projects.length,
                    scriptcs: !info.ScriptCs ? 0 : 1
                });
            });
        });
        return vscode_1.Disposable.of(d1, d2, d3);
    }
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.default = reportTelemetry;
});
//# sourceMappingURL=telemetrySupport.js.map