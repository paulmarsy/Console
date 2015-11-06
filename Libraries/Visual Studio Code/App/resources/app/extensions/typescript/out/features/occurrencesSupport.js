/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", 'vscode'], function (require, exports, vscode) {
    var OccurrencesSupport = (function () {
        function OccurrencesSupport(client) {
            this.client = client;
        }
        OccurrencesSupport.prototype.findOccurrences = function (resource, position, token) {
            var args = {
                file: this.client.asAbsolutePath(resource.getUri()),
                line: position.line,
                offset: position.character
            };
            if (!args.file) {
                return Promise.resolve([]);
            }
            return this.client.execute('occurrences', args, token).then(function (response) {
                var data = response.body;
                if (data) {
                    return data.map(function (item) {
                        return {
                            kind: item.isWriteAccess ? 'write' : null,
                            range: new vscode.Range(item.start.line, item.start.offset, item.end.line, item.end.offset)
                        };
                    });
                }
            }, function (err) {
                return [];
            });
        };
        return OccurrencesSupport;
    })();
    return OccurrencesSupport;
});
//# sourceMappingURL=occurrencesSupport.js.map