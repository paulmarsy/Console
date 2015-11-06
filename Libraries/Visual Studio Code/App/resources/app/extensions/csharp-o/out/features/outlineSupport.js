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
    var OutlineSupport = (function (_super) {
        __extends(OutlineSupport, _super);
        function OutlineSupport() {
            _super.apply(this, arguments);
        }
        OutlineSupport.prototype.getOutline = function (document, token) {
            if (this.isInMemory(document.getUri()) || !this.server().isRunning()) {
                return Promise.resolve([]);
            }
            return this.server().makeRequest(Protocol.CurrentFileMembersAsTree, { Filename: document.getUri().fsPath }, token).then(function (tree) {
                var ret = [];
                tree.TopLevelTypeDefinitions.map(function (node) { return OutlineSupport._toEntry(ret, node); });
                return ret;
            });
        };
        OutlineSupport._toEntry = function (container, node) {
            var ret = {
                type: kinds[node.Kind] || 'property',
                label: node.Location.Text,
                range: new vscode_1.Range(node.Location.Line, node.Location.Column, node.Location.EndLine, node.Location.EndColumn)
            };
            if (node.ChildNodes) {
                ret.children = [];
                node.ChildNodes.forEach(function (value) { return OutlineSupport._toEntry(ret.children, value); });
            }
            container.push(ret);
        };
        return OutlineSupport;
    })(abstractSupport_1.default);
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.default = OutlineSupport;
    var kinds = Object.create(null);
    kinds['VariableDeclaration'] = 'variable';
    kinds['StructDeclaration'] = 'interface';
    kinds['InterfaceDeclaration'] = 'interface';
    kinds['EnumDeclaration'] = 'enum';
    kinds['EnumMemberDeclaration'] = 'property';
    kinds['PropertyDeclaration'] = 'property';
    kinds['ClassDeclaration'] = 'class';
    kinds['FieldDeclaration'] = 'property';
    kinds['EventFieldDeclaration'] = 'property';
    kinds['MethodDeclaration'] = 'method';
});
//# sourceMappingURL=outlineSupport.js.map