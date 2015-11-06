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
    function getType(symbolInfo) {
        switch (symbolInfo.Kind) {
            case 'Method': return 'method';
            case 'Field':
            case 'Property':
                return 'property';
        }
        return 'class';
    }
    function getName(symbolInfo) {
        var name = symbolInfo.Text;
        for (var i = 0; i < name.length; i++) {
            var ch = name.charAt(i);
            if (ch === '<' || ch === '(') {
                return name.substr(0, i);
            }
        }
        return name;
    }
    var NavigateTypesSupport = (function (_super) {
        __extends(NavigateTypesSupport, _super);
        function NavigateTypesSupport() {
            _super.apply(this, arguments);
        }
        NavigateTypesSupport.prototype.getNavigateToItems = function (search, token) {
            if (!this.server().isRunning()) {
                return;
            }
            return this.server().makeRequest(Protocol.FindSymbols, {
                Filter: search,
                Filename: ''
            }, token).then(function (res) {
                return !res || !Array.isArray(res.QuickFixes)
                    ? []
                    : res.QuickFixes.map(NavigateTypesSupport.asTypeBearing);
            });
        };
        NavigateTypesSupport.asTypeBearing = function (symbolInfo) {
            var uri = vscode_1.Uri.file(symbolInfo.FileName);
            var name = getName(symbolInfo);
            return {
                containerName: '',
                name: name,
                parameters: symbolInfo.Text.substr(name.length),
                type: getType(symbolInfo),
                resourceUri: uri,
                range: new vscode_1.Range(symbolInfo.Line, symbolInfo.Column, symbolInfo.EndLine, symbolInfo.EndColumn)
            };
        };
        return NavigateTypesSupport;
    })(abstractSupport_1.default);
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.default = NavigateTypesSupport;
});
//# sourceMappingURL=navigateTypesSupport.js.map