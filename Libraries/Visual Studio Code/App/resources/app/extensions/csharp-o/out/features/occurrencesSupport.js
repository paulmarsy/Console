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
    var OccurrencesSupport = (function (_super) {
        __extends(OccurrencesSupport, _super);
        function OccurrencesSupport() {
            _super.apply(this, arguments);
        }
        OccurrencesSupport.prototype.findOccurrences = function (resource, position, token) {
            if (this.isInMemory(resource.getUri()) || !this.server().isRunning()) {
                return Promise.resolve([]);
            }
            return this.server().makeRequest(Protocol.FindUsages, {
                Filename: resource.getUri().fsPath,
                Line: position.line,
                Column: position.character,
                OnlyThisFile: true,
                ExcludeDefinition: false
            }).then(function (res) {
                return !res || !Array.isArray(res.QuickFixes)
                    ? []
                    : res.QuickFixes.map(OccurrencesSupport.asOccurrence);
            });
        };
        OccurrencesSupport.asOccurrence = function (quickFix) {
            return {
                range: new vscode_1.Range(quickFix.Line, quickFix.Column, quickFix.EndLine, quickFix.EndColumn)
            };
        };
        return OccurrencesSupport;
    })(abstractSupport_1.default);
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.default = OccurrencesSupport;
});
//# sourceMappingURL=occurrencesSupport.js.map