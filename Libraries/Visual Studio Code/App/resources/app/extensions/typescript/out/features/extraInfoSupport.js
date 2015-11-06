/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", 'vscode'], function (require, exports, vscode) {
    var ExtraInfoSupport = (function () {
        function ExtraInfoSupport(client) {
            this.client = client;
        }
        ExtraInfoSupport.prototype.computeInfo = function (document, position, token) {
            var args = {
                file: this.client.asAbsolutePath(document.getUri()),
                line: position.line,
                offset: position.character
            };
            if (!args.file) {
                return Promise.resolve(null);
            }
            return this.client.execute('quickinfo', args, token).then(function (response) {
                var data = response.body;
                if (data) {
                    return {
                        htmlContent: [
                            { formattedText: data.displayString },
                            { formattedText: data.documentation }
                        ],
                        range: new vscode.Range(data.start.line, data.start.offset, data.end.line, data.end.offset)
                    };
                }
            }, function (err) {
                return null;
            });
        };
        return ExtraInfoSupport;
    })();
    return ExtraInfoSupport;
});
//# sourceMappingURL=extraInfoSupport.js.map