/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", './xmlDef', 'vscode'], function (require, exports, languageDef, vscode) {
    function activate(subscriptions) {
        subscriptions.push(vscode.Modes.registerMonarchDefinition('xml', languageDef.language));
        if (typeof process !== 'undefined') {
            var myWorker = vscode.Modes.loadInBackgroundWorker(require.toUrl('./xmlWorker.js'));
            subscriptions.push(myWorker.disposable);
            var format = function (document, range, options) {
                return myWorker.load().then(function (w) {
                    var value = range ? document.getTextInRange(range) : document.getText();
                    if (value.length < 1024 * 1024) {
                        return w.beautify(value, {
                            indent_size: options.insertSpaces ? options.tabSize : 1,
                            indent_char: options.insertSpaces ? ' ' : '\t',
                            wrap_line_length: 256
                        });
                    }
                    else {
                        return null;
                    }
                }).then(function (result) {
                    if (result) {
                        return [{
                                range: new vscode.Range(range.start.line, range.start.character, range.end.line, range.end.character),
                                text: result
                            }];
                    }
                    else {
                        return null;
                    }
                });
            };
            subscriptions.push(vscode.Modes.FormattingSupport.register('xml', {
                formatDocument: function (resource, options) {
                    return format(resource, null, options);
                },
                formatRange: function (resource, range, options) {
                    return format(resource, range, options);
                }
            }));
        }
    }
    exports.activate = activate;
});
//# sourceMappingURL=xmlMain.js.map