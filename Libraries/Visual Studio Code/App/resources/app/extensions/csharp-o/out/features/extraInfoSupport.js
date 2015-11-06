/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
define(["require", "exports", '../documentation', './abstractSupport', '../protocol', 'vscode'], function (require, exports, documentation_1, abstractSupport_1, Protocol, vscode_1) {
    var ExtraInfoSupport = (function (_super) {
        __extends(ExtraInfoSupport, _super);
        function ExtraInfoSupport() {
            _super.apply(this, arguments);
        }
        ExtraInfoSupport.prototype.computeInfo = function (document, position, token) {
            if (this.isInMemory(document.getUri()) || !this.server().isRunning()) {
                return Promise.resolve(null);
            }
            var request = {
                Filename: document.getUri().fsPath,
                Line: position.line,
                Column: position.character,
                IncludeDocumentation: true
            };
            return this.server().makeRequest(Protocol.TypeLookup, request, token).then(function (value) {
                if (!value || !value.Type) {
                    return null;
                }
                var range = document.getWordRangeAtPosition(position);
                if (!range) {
                    range = new vscode_1.Range(position, position);
                }
                return {
                    value: '',
                    range: range,
                    className: 'typeInfo',
                    htmlContent: [
                        { className: 'type', text: value.Type },
                        documentation_1.formatted(value.Documentation)
                    ]
                };
            });
        };
        return ExtraInfoSupport;
    })(abstractSupport_1.default);
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.default = ExtraInfoSupport;
});
//# sourceMappingURL=extraInfoSupport.js.map