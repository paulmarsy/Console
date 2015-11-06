/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", 'vscode'], function (require, exports, vscode) {
    var DeclartionSupport = (function () {
        function DeclartionSupport(client) {
            this.tokens = [];
            this.client = client;
        }
        DeclartionSupport.prototype.findDeclaration = function (document, position, token) {
            var _this = this;
            var args = {
                file: this.client.asAbsolutePath(document.getUri()),
                line: position.line,
                offset: position.character
            };
            if (!args.file) {
                return Promise.resolve(null);
            }
            return this.client.execute('definition', args, token).then(function (response) {
                var locations = response.body;
                if (!locations || locations.length === 0) {
                    return null;
                }
                var location = locations[0];
                var resource = _this.client.asUrl(location.file);
                if (resource === null) {
                    return null;
                }
                else {
                    return {
                        resource: resource,
                        range: new vscode.Range(location.start.line, location.start.offset, location.end.line, location.end.offset)
                    };
                }
            }, function () {
                return null;
            });
        };
        return DeclartionSupport;
    })();
    return DeclartionSupport;
});
//# sourceMappingURL=declarationSupport.js.map