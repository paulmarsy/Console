/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", './previewer'], function (require, exports, Previewer) {
    var ParameterHintsSupport = (function () {
        function ParameterHintsSupport(client) {
            this.triggerCharacters = ['(', ','];
            this.excludeTokens = ['string'];
            this.client = client;
        }
        ParameterHintsSupport.prototype.getParameterHints = function (document, position, token) {
            var args = {
                file: this.client.asAbsolutePath(document.getUri()),
                line: position.line,
                offset: position.character
            };
            if (!args.file) {
                return Promise.resolve(null);
            }
            return this.client.execute('signatureHelp', args, token).then(function (response) {
                var info = response.body;
                if (!info) {
                    return null;
                }
                var result = {
                    currentSignature: info.selectedItemIndex,
                    currentParameter: info.argumentIndex,
                    signatures: []
                };
                info.items.forEach(function (item) {
                    var signature = {
                        label: '',
                        documentation: null,
                        parameters: []
                    };
                    signature.label += Previewer.plain(item.prefixDisplayParts);
                    item.parameters.forEach(function (p, i, a) {
                        var label = Previewer.plain(p.displayParts);
                        var parameter = {
                            label: label,
                            documentation: Previewer.plain(p.documentation),
                            signatureLabelOffset: signature.label.length,
                            signatureLabelEnd: signature.label.length + label.length
                        };
                        signature.label += label;
                        signature.parameters.push(parameter);
                        if (i < a.length - 1) {
                            signature.label += Previewer.plain(item.separatorDisplayParts);
                        }
                    });
                    signature.label += Previewer.plain(item.suffixDisplayParts);
                    result.signatures.push(signature);
                });
                return result;
            }, function (err) {
                return null;
            });
        };
        return ParameterHintsSupport;
    })();
    return ParameterHintsSupport;
});
//# sourceMappingURL=parameterHintsSupport.js.map