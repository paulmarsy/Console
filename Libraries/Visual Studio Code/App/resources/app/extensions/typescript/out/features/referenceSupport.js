/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", 'vscode'], function (require, exports, vscode) {
    var ReferenceSupport = (function () {
        function ReferenceSupport(client) {
            this.tokens = [];
            this.client = client;
        }
        ReferenceSupport.prototype.findReferences = function (document, position, includeDeclaration, token) {
            var _this = this;
            var args = {
                file: this.client.asAbsolutePath(document.getUri()),
                line: position.line,
                offset: position.character
            };
            if (!args.file) {
                return Promise.resolve([]);
            }
            return this.client.execute('references', args, token).then(function (msg) {
                var result = [];
                var refs = msg.body.refs;
                for (var i = 0; i < refs.length; i++) {
                    var ref = refs[i];
                    var url = _this.client.asUrl(ref.file);
                    result.push({
                        resource: url,
                        range: new vscode.Range(ref.start.line, ref.start.offset, ref.end.line, ref.end.offset)
                    });
                }
                return result;
            }, function () {
                return [];
            });
        };
        return ReferenceSupport;
    })();
    return ReferenceSupport;
});
//# sourceMappingURL=referenceSupport.js.map