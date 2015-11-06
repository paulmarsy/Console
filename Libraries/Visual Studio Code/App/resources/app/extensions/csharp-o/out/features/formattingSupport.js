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
    var FormattingSupport = (function (_super) {
        __extends(FormattingSupport, _super);
        function FormattingSupport() {
            _super.apply(this, arguments);
            this.autoFormatTriggerCharacters = [';', '}' /*, '\n'*/];
        }
        FormattingSupport.prototype.formatDocument = function (document, options, token) {
            if (this.isInMemory(document.getUri()) || !this.server().isRunning()) {
                return Promise.resolve([]);
            }
            var request;
            request = {
                Filename: document.getUri().fsPath,
                ExpandTab: options.insertSpaces
            };
            return this.server().makeRequest(Protocol.CodeFormat, request, token).then(function (res) {
                if (!res.Buffer) {
                    return null;
                }
                var edit = {
                    text: res.Buffer,
                    range: new vscode_1.Range(1, 1, document.getLineCount(), document.getLineMaxColumn(document.getLineCount()))
                };
                return [edit];
            });
        };
        FormattingSupport.prototype.formatRange = function (document, range, options, token) {
            if (this.isInMemory(document.getUri()) || !this.server().isRunning()) {
                return Promise.resolve([]);
            }
            var request;
            request = {
                Filename: document.getUri().fsPath,
                Line: range.start.line,
                Column: range.start.character,
                EndLine: range.end.line,
                EndColumn: range.end.character
            };
            return this.server().makeRequest(Protocol.FormatRange, request, token).then(function (res) {
                if (!res || !Array.isArray(res.Changes)) {
                    return null;
                }
                return res.Changes.map(FormattingSupport.asEditOptionation);
            });
        };
        FormattingSupport.prototype.formatAfterKeystroke = function (document, position, ch, options, token) {
            if (this.isInMemory(document.getUri()) || !this.server().isRunning()) {
                return Promise.resolve([]);
            }
            var request;
            request = {
                Filename: document.getUri().fsPath,
                Line: position.line,
                Column: position.character,
                Character: ch
            };
            return this.server().makeRequest(Protocol.FormatAfterKeystroke, request, token).then(function (res) {
                if (!res || !Array.isArray(res.Changes)) {
                    return null;
                }
                return res.Changes.map(FormattingSupport.asEditOptionation);
            });
        };
        FormattingSupport.asEditOptionation = function (change) {
            return {
                text: change.NewText,
                range: new vscode_1.Range(change.StartLine, change.StartColumn, change.EndLine, change.EndColumn)
            };
        };
        return FormattingSupport;
    })(abstractSupport_1.default);
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.default = FormattingSupport;
});
//# sourceMappingURL=formattingSupport.js.map