/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", 'vscode'], function (require, exports, vscode) {
    var FormattingSupport = (function () {
        function FormattingSupport(client) {
            this.autoFormatTriggerCharacters = [';', '}', '\n'];
            this.client = client;
            this.formatOptions = Object.create(null);
        }
        FormattingSupport.prototype.ensureFormatOptions = function (document, options, token) {
            var _this = this;
            var key = document.getUri().toString();
            var currentOptions = this.formatOptions[key];
            if (currentOptions && currentOptions.tabSize === options.tabSize && currentOptions.indentSize === options.tabSize && currentOptions.convertTabsToSpaces === options.insertSpaces) {
                return Promise.resolve(currentOptions);
            }
            else {
                var args = {
                    file: this.client.asAbsolutePath(document.getUri()),
                    formatOptions: this.getFormatOptions(options)
                };
                return this.client.execute('configure', args, token).then(function (response) {
                    _this.formatOptions[key] = args.formatOptions;
                    return args.formatOptions;
                });
            }
        };
        FormattingSupport.prototype.doFormat = function (document, options, args, token) {
            var _this = this;
            return this.ensureFormatOptions(document, options, token).then(function () {
                return _this.client.execute('format', args, token).then(function (response) {
                    return response.body.map(_this.codeEdit2SingleEditOperation);
                }, function (err) {
                    return [];
                });
            });
        };
        FormattingSupport.prototype.formatDocument = function (document, options, token) {
            var lines = document.getLineCount();
            var args = {
                file: this.client.asAbsolutePath(document.getUri()),
                line: 1,
                offset: 1,
                endLine: lines,
                endOffset: document.getLineMaxColumn(lines)
            };
            return this.doFormat(document, options, args, token);
        };
        FormattingSupport.prototype.formatRange = function (document, range, options, token) {
            var args = {
                file: this.client.asAbsolutePath(document.getUri()),
                line: range.start.line,
                offset: range.start.character,
                endLine: range.end.line,
                endOffset: range.end.character
            };
            return this.doFormat(document, options, args, token);
        };
        FormattingSupport.prototype.formatAfterKeystroke = function (document, position, ch, options, token) {
            var _this = this;
            var args = {
                file: this.client.asAbsolutePath(document.getUri()),
                line: position.line,
                offset: position.character,
                key: ch
            };
            return this.ensureFormatOptions(document, options, token).then(function () {
                return _this.client.execute('formatonkey', args, token).then(function (response) {
                    return response.body.map(_this.codeEdit2SingleEditOperation);
                }, function (err) {
                    return [];
                });
            });
        };
        FormattingSupport.prototype.codeEdit2SingleEditOperation = function (edit) {
            return {
                range: new vscode.Range(edit.start.line, edit.start.offset, edit.end.line, edit.end.offset),
                text: edit.newText
            };
        };
        FormattingSupport.prototype.getFormatOptions = function (options) {
            return {
                tabSize: options.tabSize,
                indentSize: options.tabSize,
                convertTabsToSpaces: options.insertSpaces,
                // We can use \n here since the editor normalizes later on to its line endings.
                newLineCharacter: '\n'
            };
        };
        return FormattingSupport;
    })();
    return FormattingSupport;
});
//# sourceMappingURL=formattingSupport.js.map