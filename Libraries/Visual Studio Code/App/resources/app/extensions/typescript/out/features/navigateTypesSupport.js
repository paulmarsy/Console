/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", 'vscode'], function (require, exports, vscode) {
    var NavigateTypeSupport = (function () {
        function NavigateTypeSupport(client, modeId) {
            this.client = client;
            this.modeId = modeId;
        }
        NavigateTypeSupport.prototype.getNavigateToItems = function (search, token) {
            var _this = this;
            // typescript wants to have a resource even when asking
            // general questions so we get the active editor and check
            // wether it's a TypeScript file
            var editor = vscode.window.getActiveTextEditor();
            if (!editor || editor.getTextDocument().getLanguageId() !== this.modeId) {
                return Promise.resolve([]);
            }
            var args = {
                file: this.client.asAbsolutePath(editor.getTextDocument().getUri()),
                searchValue: search
            };
            if (!args.file) {
                return Promise.resolve([]);
            }
            return this.client.execute('navto', args, token).then(function (response) {
                var data = response.body;
                if (data) {
                    return data.map(function (item) {
                        return {
                            containerName: item.containerName,
                            name: item.name,
                            parameters: (item.kind === 'method' || item.kind === 'function') ? '()' : '',
                            type: item.kind,
                            range: new vscode.Range(item.start.line, item.start.offset, item.end.line, item.end.offset),
                            resourceUri: _this.client.asUrl(item.file)
                        };
                    });
                }
                else {
                    return [];
                }
            }, function (err) {
                return [];
            });
        };
        return NavigateTypeSupport;
    })();
    return NavigateTypeSupport;
});
//# sourceMappingURL=navigateTypesSupport.js.map