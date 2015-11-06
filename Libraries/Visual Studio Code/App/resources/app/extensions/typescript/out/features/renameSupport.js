/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", 'vscode'], function (require, exports, vscode) {
    var RenameSupport = (function () {
        function RenameSupport(client) {
            this.tokens = [];
            this.client = client;
        }
        RenameSupport.prototype.rename = function (document, position, newName, token) {
            var _this = this;
            var args = {
                file: this.client.asAbsolutePath(document.getUri()),
                line: position.line,
                offset: position.character,
                findInStrings: false,
                findInComments: false
            };
            if (!args.file) {
                return Promise.resolve(null);
            }
            return this.client.execute('rename', args, token).then(function (response) {
                var renameResponse = response.body;
                var renameInfo = renameResponse.info;
                var result = {
                    currentName: renameInfo.displayName,
                    edits: []
                };
                if (!renameInfo.canRename) {
                    result.rejectReason = renameInfo.localizedErrorMessage;
                    return result;
                }
                renameResponse.locs.forEach(function (spanGroup) {
                    var resource = _this.client.asUrl(spanGroup.file);
                    if (!resource) {
                        return;
                    }
                    spanGroup.locs.forEach(function (textSpan) {
                        result.edits.push({
                            resource: resource,
                            newText: newName,
                            range: new vscode.Range(textSpan.start.line, textSpan.start.offset, textSpan.end.line, textSpan.end.offset)
                        });
                    });
                });
                return result;
            }, function (err) {
                return null;
            });
        };
        return RenameSupport;
    })();
    return RenameSupport;
});
//# sourceMappingURL=renameSupport.js.map