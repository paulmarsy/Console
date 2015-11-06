/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", 'vscode'], function (require, exports, vscode_1) {
    var AbstractSupport = (function () {
        function AbstractSupport(server) {
            this._server = server;
        }
        AbstractSupport.prototype.server = function () {
            return this._server;
        };
        AbstractSupport.prototype.buffer = function (resource) {
            return AbstractSupport.buffer(vscode_1.workspace.getTextDocument(resource));
        };
        AbstractSupport.prototype.isInMemory = function (resource) {
            return vscode_1.workspace.getTextDocument(resource).isUntitled();
        };
        AbstractSupport.buffer = function (document) {
            return document.getText();
        };
        return AbstractSupport;
    })();
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.default = AbstractSupport;
});
//# sourceMappingURL=abstractSupport.js.map