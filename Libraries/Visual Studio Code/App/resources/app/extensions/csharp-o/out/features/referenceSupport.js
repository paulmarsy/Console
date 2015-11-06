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
    var ReferenceSupport = (function (_super) {
        __extends(ReferenceSupport, _super);
        function ReferenceSupport() {
            _super.apply(this, arguments);
            this.tokens = ['identifier.cs'];
        }
        ReferenceSupport.prototype.findReferences = function (document, position, includeDeclaration, token) {
            if (this.isInMemory(document.getUri()) || !this.server().isRunning()) {
                return Promise.resolve([]);
            }
            return this.server().makeRequest(Protocol.FindUsages, {
                Filename: document.getUri().fsPath,
                Line: position.line,
                Column: position.character,
                OnlyThisFile: false,
                ExcludeDefinition: false
            }, token).then(function (res) {
                return !res || !Array.isArray(res.QuickFixes)
                    ? []
                    : res.QuickFixes.map(ReferenceSupport.asReference);
            });
        };
        ReferenceSupport.asReference = function (quickFix) {
            return {
                resource: vscode_1.Uri.file(quickFix.FileName),
                range: new vscode_1.Range(quickFix.Line, quickFix.Column, quickFix.EndLine, quickFix.EndColumn)
            };
        };
        return ReferenceSupport;
    })(abstractSupport_1.default);
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.default = ReferenceSupport;
});
//# sourceMappingURL=referenceSupport.js.map