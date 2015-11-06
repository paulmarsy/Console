/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
define(["require", "exports", '../documentation', './abstractSupport', '../protocol'], function (require, exports, documentation_1, abstractSupport_1, Protocol) {
    var ParameterHintsSupport = (function (_super) {
        __extends(ParameterHintsSupport, _super);
        function ParameterHintsSupport() {
            _super.apply(this, arguments);
        }
        Object.defineProperty(ParameterHintsSupport.prototype, "triggerCharacters", {
            get: function () {
                return ['(', ','];
            },
            enumerable: true,
            configurable: true
        });
        Object.defineProperty(ParameterHintsSupport.prototype, "excludeTokens", {
            get: function () {
                return ['comment.cs', 'string.cs', 'number.cs'];
            },
            enumerable: true,
            configurable: true
        });
        ParameterHintsSupport.prototype.getParameterHints = function (document, position, token) {
            if (this.isInMemory(document.getUri()) || !this.server().isRunning()) {
                return;
            }
            var req = {
                Filename: document.getUri().fsPath,
                Line: position.line,
                Column: position.character
            };
            return this.server().makeRequest(Protocol.SignatureHelp, req, token).then(function (res) {
                var ret = {
                    currentSignature: res.ActiveSignature,
                    currentParameter: res.ActiveParameter,
                    signatures: []
                };
                res.Signatures.forEach(function (signature) {
                    var _signature = {
                        documentation: documentation_1.plain(signature.Documentation),
                        label: signature.Name + '(',
                        parameters: []
                    };
                    signature.Parameters.forEach(function (parameter, i, a) {
                        var _parameter = {
                            documentation: documentation_1.plain(parameter.Documentation),
                            label: parameter.Label,
                            signatureLabelOffset: _signature.label.length,
                            signatureLabelEnd: _signature.label.length + parameter.Label.length
                        };
                        _signature.parameters.push(_parameter);
                        _signature.label += _parameter.label;
                        if (i < a.length - 1) {
                            _signature.label += ', ';
                        }
                    });
                    _signature.label += ')';
                    ret.signatures.push(_signature);
                });
                return ret;
            });
        };
        return ParameterHintsSupport;
    })(abstractSupport_1.default);
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.default = ParameterHintsSupport;
});
//# sourceMappingURL=parameterHintsSupport.js.map