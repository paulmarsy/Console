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
    var GotoDeclSupport = (function (_super) {
        __extends(GotoDeclSupport, _super);
        function GotoDeclSupport() {
            _super.apply(this, arguments);
        }
        GotoDeclSupport.prototype.findDeclaration = function (document, position, token) {
            if (this.isInMemory(document.getUri()) || !this.server().isRunning()) {
                return Promise.resolve(null);
            }
            var request = {
                Filename: document.getUri().fsPath,
                Line: position.line,
                Column: position.character
            };
            return this.server().makeRequest(Protocol.GoToDefinition, request, token).then(function (value) {
                if (!value || !value.FileName) {
                    return;
                }
                return {
                    range: new vscode_1.Range(value.Line, value.Column, value.Line, value.Column),
                    resource: vscode_1.Uri.file(value.FileName)
                };
            });
        };
        return GotoDeclSupport;
    })(abstractSupport_1.default);
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.default = GotoDeclSupport;
});
//# sourceMappingURL=declarationSupport.js.map