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
    var CodeLensSupport = (function (_super) {
        __extends(CodeLensSupport, _super);
        function CodeLensSupport() {
            _super.apply(this, arguments);
        }
        CodeLensSupport.prototype.enableCodeLens = function () {
            return true;
        };
        CodeLensSupport.prototype.findCodeLensSymbols = function (document, token) {
            if (this.isInMemory(document.getUri()) || !this.server().isRunning()) {
                return Promise.resolve([]);
            }
            return this.server().makeRequest(Protocol.CurrentFileMembersAsTree, {
                Filename: document.getUri().fsPath
            }, token).then(function (tree) {
                var ret = [];
                tree.TopLevelTypeDefinitions.forEach(function (node) { return CodeLensSupport._toCodeLensSymbol(ret, node); });
                return ret;
            });
        };
        CodeLensSupport._toCodeLensSymbol = function (container, node) {
            if (node.Kind === 'MethodDeclaration' && CodeLensSupport.filteredSymbolNames[node.Location.Text]) {
                return;
            }
            var ret = {
                range: new vscode_1.Range(node.Location.Line, node.Location.Column, node.Location.EndLine, node.Location.EndColumn)
            };
            if (node.ChildNodes) {
                node.ChildNodes.forEach(function (value) { return CodeLensSupport._toCodeLensSymbol(container, value); });
            }
            container.push(ret);
        };
        CodeLensSupport.prototype.findCodeLensReferences = function (document, requests, token) {
            var _this = this;
            if (this.isInMemory(document.getUri()) || !this.server().isRunning()) {
                return Promise.resolve(null);
            }
            var resultPromises = requests.map(function (request) {
                return _this.server().makeRequest(Protocol.FindUsages, {
                    Filename: document.getUri().fsPath,
                    Line: request.position.line,
                    Column: request.position.character,
                    OnlyThisFile: false,
                    ExcludeDefinition: true
                }, token).then(function (res) {
                    if (!res || !Array.isArray(res.QuickFixes)) {
                        return [];
                    }
                    return res.QuickFixes.map(CodeLensSupport._asReference).filter(function (r) {
                        return !r.range.contains(request.position);
                    });
                });
            });
            return Promise.all(resultPromises).then(function (references) {
                return {
                    references: references
                };
            });
        };
        CodeLensSupport._asReference = function (quickFix) {
            return {
                resource: vscode_1.Uri.file(quickFix.FileName),
                range: new vscode_1.Range(quickFix.Line, quickFix.Column, quickFix.EndLine, quickFix.EndColumn)
            };
        };
        CodeLensSupport.filteredSymbolNames = {
            'Equals': true,
            'Finalize': true,
            'GetHashCode': true,
            'ToString': true
        };
        return CodeLensSupport;
    })(abstractSupport_1.default);
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.default = CodeLensSupport;
});
//# sourceMappingURL=codeLensSupport.js.map