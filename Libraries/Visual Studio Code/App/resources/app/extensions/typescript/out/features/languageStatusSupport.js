/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", 'vscode', 'path'], function (require, exports, vscode_1, path_1) {
    function reportLanguageStatus(language, client) {
        languageStatusForEditor(language, client, vscode_1.window.getActiveTextEditor());
        return vscode_1.window.onDidChangeActiveTextEditor(function (editor) { return languageStatusForEditor(language, client, editor); });
    }
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.default = reportLanguageStatus;
    var lastStatus;
    function languageStatusForEditor(language, client, editor) {
        if (lastStatus) {
            lastStatus.dispose();
        }
        if (!editor || editor.getTextDocument().getLanguageId() !== language) {
            return;
        }
        var uri = editor.getTextDocument().getUri();
        var args = {
            file: uri.fsPath,
            needFileNameList: false
        };
        client.execute('projectInfo', args).then(function (value) {
            var projectInfo = value.body;
            if (projectInfo.configFileName) {
                var message = path_1.basename(projectInfo.configFileName);
                lastStatus = vscode_1.languages.addInformationLanguageStatus(uri, message, undefined);
            }
        });
    }
});
//# sourceMappingURL=languageStatusSupport.js.map