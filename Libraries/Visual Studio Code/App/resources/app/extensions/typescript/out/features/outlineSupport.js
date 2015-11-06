/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", 'vscode', '../protocol.const'], function (require, exports, vscode, PConst) {
    var outlineTypeTable = Object.create(null);
    outlineTypeTable[PConst.Kind.module] = 'module';
    outlineTypeTable[PConst.Kind.class] = 'class';
    outlineTypeTable[PConst.Kind.enum] = 'enum';
    outlineTypeTable[PConst.Kind.interface] = 'interface';
    outlineTypeTable[PConst.Kind.memberFunction] = 'method';
    outlineTypeTable[PConst.Kind.memberVariable] = 'property';
    outlineTypeTable[PConst.Kind.memberGetAccessor] = 'property';
    outlineTypeTable[PConst.Kind.memberSetAccessor] = 'property';
    outlineTypeTable[PConst.Kind.variable] = 'variable';
    outlineTypeTable[PConst.Kind.const] = 'variable';
    outlineTypeTable[PConst.Kind.localVariable] = 'variable';
    outlineTypeTable[PConst.Kind.variable] = 'variable';
    outlineTypeTable[PConst.Kind.function] = 'function';
    outlineTypeTable[PConst.Kind.localFunction] = 'function';
    function textSpan2Range(value) {
        return new vscode.Range(value.start.line, value.start.offset, value.end.line, value.end.offset);
    }
    var OutlineSupport = (function () {
        function OutlineSupport(client) {
            this.client = client;
        }
        OutlineSupport.prototype.getOutline = function (resource, token) {
            var args = {
                file: this.client.asAbsolutePath(resource.getUri())
            };
            if (!args.file) {
                return Promise.resolve([]);
            }
            function compare(a, b) {
                if (a.range.start.line < b.range.start.line) {
                    return -1;
                }
                else if (a.range.start.line > b.range.start.line) {
                    return 1;
                }
                else if (a.range.start.character < b.range.start.character) {
                    return -1;
                }
                else if (a.range.start.character > b.range.start.character) {
                    return 1;
                }
                else {
                    return 0;
                }
            }
            function convert(item) {
                var result = {
                    label: item.text,
                    type: outlineTypeTable[item.kind] || 'variable',
                    range: textSpan2Range(item.spans[0])
                };
                if (item.childItems && item.childItems.length > 0) {
                    result.children = item.childItems.map(function (child) { return convert(child); }).sort(compare);
                }
                return result;
            }
            return this.client.execute('navbar', args, token).then(function (response) {
                var items = response.body;
                return items ? items.map(function (item) { return convert(item); }).sort(compare) : [];
            }, function (err) {
                return [];
            });
        };
        return OutlineSupport;
    })();
    return OutlineSupport;
});
//# sourceMappingURL=outlineSupport.js.map