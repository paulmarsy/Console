/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
define(["require", "exports", '../documentation', './abstractSupport', '../protocol', 'vscode'], function (require, exports, documentation_1, abstractSupport_1, Protocol, vscode_1) {
    var SuggestSupport = (function (_super) {
        __extends(SuggestSupport, _super);
        function SuggestSupport() {
            _super.apply(this, arguments);
            this.triggerCharacters = ['.', '<'];
            this.excludeTokens = ['comment.cs', 'string.cs', 'number.cs'];
        }
        SuggestSupport.prototype.suggest = function (document, position, token) {
            if (this.isInMemory(document.getUri())) {
                return Promise.resolve([]);
            }
            if (!this.server().isRunning()) {
                return Promise.resolve([]);
            }
            var wordToComplete = '';
            var range = document.getWordRangeAtPosition(position);
            if (range) {
                wordToComplete = document.getTextInRange(new vscode_1.Range(range.start, position));
            }
            var request = {
                Filename: document.getUri().fsPath,
                Line: position.line,
                Column: position.character,
                WordToComplete: wordToComplete,
                WantDocumentationForEveryCompletionResult: true,
                WantKind: true
            };
            return this.server().makeRequest(Protocol.AutoComplete, request).then(function (values) {
                var ret = {
                    currentWord: request.WordToComplete,
                    suggestions: []
                };
                if (!values) {
                    return [ret];
                }
                var completions = Object.create(null);
                // transform AutoCompleteResponse to ISuggestion and
                // group by code snippet
                values.forEach(function (value) {
                    var suggestion = {
                        codeSnippet: value.CompletionText.replace(/\(|\)|<|>/g, ''),
                        label: value.CompletionText.replace(/\(|\)|<|>/g, ''),
                        typeLabel: value.DisplayText,
                        documentationLabel: documentation_1.plain(value.Description),
                        highlights: [],
                        type: kinds[value.Kind] || ''
                    };
                    var suggestions = completions[suggestion.codeSnippet];
                    if (!suggestions) {
                        suggestions = completions[suggestion.codeSnippet] = [];
                    }
                    suggestions.push(suggestion);
                });
                // per suggestion group, select on and indicate overloads
                for (var key in completions) {
                    var suggestion = completions[key][0], overloadCount = completions[key].length - 1;
                    if (overloadCount === 0) {
                        // remove non overloaded items
                        delete completions[key];
                    }
                    else {
                        // indicate that there is more
                        suggestion.typeLabel = suggestion.typeLabel + " (+ " + overloadCount + " overload(s))";
                    }
                    ret.suggestions.push(suggestion);
                }
                return [ret];
            });
        };
        return SuggestSupport;
    })(abstractSupport_1.default);
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.default = SuggestSupport;
    var kinds = Object.create(null);
    kinds['Variable'] = 'variable';
    kinds['Struct'] = 'interface';
    kinds['Interface'] = 'interface';
    kinds['Enum'] = 'enum';
    kinds['EnumMember'] = 'property';
    kinds['Property'] = 'property';
    kinds['Class'] = 'class';
    kinds['Field'] = 'property';
    kinds['EventField'] = 'property';
    kinds['Method'] = 'method';
});
//# sourceMappingURL=suggestSupport.js.map