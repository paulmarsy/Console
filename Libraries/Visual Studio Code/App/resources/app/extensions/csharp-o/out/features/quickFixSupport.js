/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
define(["require", "exports", './abstractSupport', '../protocol', 'vscode'], function (require, exports, abstractSupport_1, protocol_1, vscode_1) {
    var QuickFixSupport = (function (_super) {
        __extends(QuickFixSupport, _super);
        function QuickFixSupport(server) {
            var _this = this;
            _super.call(this, server);
            vscode_1.extensions.getConfigurationMemento('csharp').getValue('disableCodeActions', false).then(function (value) {
                _this._disabled = value;
            });
        }
        QuickFixSupport.prototype.getQuickFixes = function (document, range, token) {
            if (this._disabled || this.isInMemory(document.getUri()) || !this.server().isRunning()) {
                return Promise.resolve(null);
            }
            var req = {
                Filename: document.getUri().fsPath,
                Selection: QuickFixSupport._asRange(range)
            };
            return this.server().makeRequest(protocol_1.V2.GetCodeActions, req, token).then(function (response) {
                return response.CodeActions.map(function (ca, index, arr) {
                    return { label: ca.Name, id: ca.Identifier, score: index };
                });
            }, function (error) {
                return Promise.reject('Problem invoking \'GetCodeActions\' on OmniSharp server: ' + error);
            });
        };
        QuickFixSupport.prototype.runQuickFixAction = function (resource, range, id, token) {
            if (this.isInMemory(resource.getUri()) || !this.server().isRunning()) {
                return Promise.resolve(null);
            }
            var req = {
                Filename: resource.getUri().fsPath,
                Selection: QuickFixSupport._asRange(range),
                Identifier: id,
                WantsTextChanges: true
            };
            return this.server().makeRequest(protocol_1.V2.RunCodeAction, req, token).then(function (response) {
                var edits = [];
                for (var _i = 0, _a = response.Changes; _i < _a.length; _i++) {
                    var modifiedFile = _a[_i];
                    var resource_1 = vscode_1.Uri.file(modifiedFile.FileName);
                    for (var _b = 0, _c = modifiedFile.Changes; _b < _c.length; _b++) {
                        var change = _c[_b];
                        edits.push(QuickFixSupport._convert(resource_1, change));
                    }
                }
                return { edits: edits };
            }, function (error) {
                return Promise.reject('Problem invoking \'RunCodeAction\' on OmniSharp server: ' + error);
            });
        };
        QuickFixSupport._asRange = function (range) {
            var start = range.start, end = range.end;
            return {
                Start: { Line: start.line, Column: start.character },
                End: { Line: end.line, Column: end.character }
            };
        };
        QuickFixSupport._convert = function (resource, change) {
            return {
                resource: resource,
                newText: change.NewText,
                range: new vscode_1.Range(change.StartLine, change.StartColumn, change.EndLine, change.EndColumn)
            };
        };
        return QuickFixSupport;
    })(abstractSupport_1.default);
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.default = QuickFixSupport;
});
//# sourceMappingURL=quickFixSupport.js.map