/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
'use strict';
var vscode_1 = require('vscode');
var Configuration;
(function (Configuration) {
    Configuration.insertSpaceAfterCommaDelimiter = 'insertSpaceAfterCommaDelimiter';
    Configuration.insertSpaceAfterSemicolonInForStatements = 'insertSpaceAfterSemicolonInForStatements';
    Configuration.insertSpaceBeforeAndAfterBinaryOperators = 'insertSpaceBeforeAndAfterBinaryOperators';
    Configuration.insertSpaceAfterKeywordsInControlFlowStatements = 'insertSpaceAfterKeywordsInControlFlowStatements';
    Configuration.insertSpaceAfterFunctionKeywordForAnonymousFunctions = 'insertSpaceAfterFunctionKeywordForAnonymousFunctions';
    Configuration.insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = 'insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis';
    Configuration.insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = 'insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets';
    Configuration.placeOpenBraceOnNewLineForFunctions = 'placeOpenBraceOnNewLineForFunctions';
    Configuration.placeOpenBraceOnNewLineForControlBlocks = 'placeOpenBraceOnNewLineForControlBlocks';
    function equals(a, b) {
        var keys = Object.keys(a);
        for (var i = 0; i < keys.length; i++) {
            var key = keys[i];
            if (a[key] !== b[key]) {
                return false;
            }
        }
        return true;
    }
    Configuration.equals = equals;
    function def() {
        var result = Object.create(null);
        result.insertSpaceAfterCommaDelimiter = true;
        result.insertSpaceAfterSemicolonInForStatements = true;
        result.insertSpaceBeforeAndAfterBinaryOperators = true;
        result.insertSpaceAfterKeywordsInControlFlowStatements = true;
        result.insertSpaceAfterFunctionKeywordForAnonymousFunctions = false;
        result.insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = false;
        result.insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = false;
        result.placeOpenBraceOnNewLineForFunctions = false;
        result.placeOpenBraceOnNewLineForControlBlocks = false;
        return result;
    }
    Configuration.def = def;
})(Configuration || (Configuration = {}));
var TypeScriptFormattingProvider = (function () {
    function TypeScriptFormattingProvider(client) {
        this.client = client;
        this.config = Configuration.def();
        this.formatOptions = Object.create(null);
    }
    TypeScriptFormattingProvider.prototype.updateConfiguration = function (config) {
        var newConfig = config.get('format', Configuration.def());
        if (!Configuration.equals(this.config, newConfig)) {
            this.config = newConfig;
            this.formatOptions = Object.create(null);
        }
    };
    TypeScriptFormattingProvider.prototype.ensureFormatOptions = function (document, options, token) {
        var _this = this;
        var key = document.uri.toString();
        var currentOptions = this.formatOptions[key];
        if (currentOptions && currentOptions.tabSize === options.tabSize && currentOptions.indentSize === options.tabSize && currentOptions.convertTabsToSpaces === options.insertSpaces) {
            return Promise.resolve(currentOptions);
        }
        else {
            var args_1 = {
                file: this.client.asAbsolutePath(document.uri),
                formatOptions: this.getFormatOptions(options)
            };
            return this.client.execute('configure', args_1, token).then(function (response) {
                _this.formatOptions[key] = args_1.formatOptions;
                return args_1.formatOptions;
            });
        }
    };
    TypeScriptFormattingProvider.prototype.doFormat = function (document, options, args, token) {
        var _this = this;
        return this.ensureFormatOptions(document, options, token).then(function () {
            return _this.client.execute('format', args, token).then(function (response) {
                return response.body.map(_this.codeEdit2SingleEditOperation);
            }, function (err) {
                return [];
            });
        });
    };
    TypeScriptFormattingProvider.prototype.provideDocumentRangeFormattingEdits = function (document, range, options, token) {
        var args = {
            file: this.client.asAbsolutePath(document.uri),
            line: range.start.line + 1,
            offset: range.start.character + 1,
            endLine: range.end.line + 1,
            endOffset: range.end.character + 1
        };
        return this.doFormat(document, options, args, token);
    };
    TypeScriptFormattingProvider.prototype.provideOnTypeFormattingEdits = function (document, position, ch, options, token) {
        var _this = this;
        var args = {
            file: this.client.asAbsolutePath(document.uri),
            line: position.line + 1,
            offset: position.character + 1,
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
    TypeScriptFormattingProvider.prototype.codeEdit2SingleEditOperation = function (edit) {
        return new vscode_1.TextEdit(new vscode_1.Range(edit.start.line - 1, edit.start.offset - 1, edit.end.line - 1, edit.end.offset - 1), edit.newText);
    };
    TypeScriptFormattingProvider.prototype.getFormatOptions = function (options) {
        return {
            tabSize: options.tabSize,
            indentSize: options.tabSize,
            convertTabsToSpaces: options.insertSpaces,
            // We can use \n here since the editor normalizes later on to its line endings.
            newLineCharacter: '\n',
            insertSpaceAfterCommaDelimiter: this.config.insertSpaceAfterCommaDelimiter,
            insertSpaceAfterSemicolonInForStatements: this.config.insertSpaceAfterSemicolonInForStatements,
            insertSpaceBeforeAndAfterBinaryOperators: this.config.insertSpaceBeforeAndAfterBinaryOperators,
            insertSpaceAfterKeywordsInControlFlowStatements: this.config.insertSpaceAfterKeywordsInControlFlowStatements,
            insertSpaceAfterFunctionKeywordForAnonymousFunctions: this.config.insertSpaceAfterFunctionKeywordForAnonymousFunctions,
            insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis: this.config.insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis,
            insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets: this.config.insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets,
            placeOpenBraceOnNewLineForFunctions: this.config.placeOpenBraceOnNewLineForFunctions,
            placeOpenBraceOnNewLineForControlBlocks: this.config.placeOpenBraceOnNewLineForControlBlocks
        };
    };
    return TypeScriptFormattingProvider;
}());
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = TypeScriptFormattingProvider;
//# sourceMappingURL=formattingProvider.js.map