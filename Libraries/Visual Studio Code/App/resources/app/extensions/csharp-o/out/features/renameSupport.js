/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
define(["require", "exports", './abstractSupport', '../protocol', 'vscode'], function (require, exports, abstractSupport_1, Protocol, vscode_1) {
    var RenameSupport = (function (_super) {
        __extends(RenameSupport, _super);
        function RenameSupport() {
            _super.apply(this, arguments);
        }
        RenameSupport.prototype.rename = function (document, position, newName, token) {
            if (this.isInMemory(document.getUri()) || !this.server().isRunning()) {
                return Promise.resolve(null);
            }
            var range = document.getWordRangeAtPosition(position);
            var word = range && document.getTextInRange(range) || '';
            var request = {
                WantsTextChanges: true,
                Filename: document.getUri().fsPath,
                Line: position.line,
                Column: position.character,
                RenameTo: newName
            };
            return this.server().makeRequest(Protocol.Rename, request, token).then(function (response) {
                if (!response) {
                    return;
                }
                var result = {
                    currentName: word,
                    edits: []
                };
                response.Changes.forEach(function (change) {
                    var resource = vscode_1.Uri.file(change.FileName);
                    change.Changes.forEach(function (change) {
                        result.edits.push(RenameSupport._convert(resource, change));
                    });
                });
                return result;
            });
        };
        RenameSupport._convert = function (resource, change) {
            return {
                resource: resource,
                newText: change.NewText,
                range: new vscode_1.Range(change.StartLine, change.StartColumn, change.EndLine, change.EndColumn)
            };
        };
        return RenameSupport;
    })(abstractSupport_1.default);
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.default = RenameSupport;
});
//# sourceMappingURL=renameSupport.js.map