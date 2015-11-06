/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", 'vscode', './previewer', '../protocol.const', './configuration'], function (require, exports, vscode, Previewer, PConst, Configuration) {
    var SuggestSupport = (function () {
        function SuggestSupport(client) {
            this.triggerCharacters = ['.'];
            this.excludeTokens = ['string', 'comment', 'numeric'];
            this.sortBy = [{ type: 'reference', partSeparator: '/' }];
            this.client = client;
            this.config = Configuration.defaultConfiguration;
        }
        SuggestSupport.prototype.setConfiguration = function (config) {
            this.config = config;
        };
        SuggestSupport.prototype.suggest = function (document, position, token) {
            var _this = this;
            var filepath = this.client.asAbsolutePath(document.getUri());
            var args = {
                file: filepath,
                line: position.line,
                offset: position.character
            };
            if (!args.file) {
                return Promise.resolve([]);
            }
            // Need to capture the word at position before we send the request.
            // The model can move forward while the request is evaluated.
            var wordRange = document.getWordRangeAtPosition(position);
            return this.client.execute('completions', args, token).then(function (msg) {
                // // This info has to come from the tsserver. See https://github.com/Microsoft/TypeScript/issues/2831
                // var isMemberCompletion = false;
                // var requestColumn = position.character;
                // if (wordAtPosition) {
                // 	requestColumn = wordAtPosition.startColumn;
                // }
                // if (requestColumn > 0) {
                // 	var value = model.getValueInRange({
                // 		startLineNumber: position.line,
                // 		startColumn: requestColumn - 1,
                // 		endLineNumber: position.line,
                // 		endColumn: requestColumn
                // 	});
                // 	isMemberCompletion = value === '.';
                // }
                var suggests = [];
                var body = msg.body;
                // sort by CompletionEntry#sortText
                msg.body.sort(SuggestSupport.bySortText);
                for (var i = 0; i < body.length; i++) {
                    var element = body[i];
                    suggests.push({
                        label: element.name,
                        codeSnippet: element.name,
                        type: _this.monacoTypeFromEntryKind(element.kind)
                    });
                }
                var currentWord = '';
                if (wordRange) {
                    currentWord = document.getTextInRange(new vscode.Range(wordRange.start, position));
                }
                return [{
                        currentWord: currentWord,
                        suggestions: suggests
                    }];
            }, function (err) {
                return [];
            });
        };
        SuggestSupport.prototype.getSuggestionDetails = function (document, position, suggestion, token) {
            var _this = this;
            if (suggestion.type === 'snippet') {
                return Promise.resolve(suggestion);
            }
            var args = {
                file: this.client.asAbsolutePath(document.getUri()),
                line: position.line,
                offset: position.character,
                entryNames: [
                    suggestion.label
                ]
            };
            return this.client.execute('completionEntryDetails', args, token).then(function (response) {
                var details = response.body;
                if (details && details.length > 0) {
                    var detail = details[0];
                    suggestion.documentationLabel = Previewer.plain(detail.documentation);
                    suggestion.typeLabel = Previewer.plain(detail.displayParts);
                }
                if (_this.config.useCodeSnippetsOnMethodSuggest && _this.monacoTypeFromEntryKind(detail.kind) === 'function') {
                    var codeSnippet = detail.name, suggestionArgumentNames;
                    suggestionArgumentNames = detail.displayParts
                        .filter(function (part) { return part.kind === 'parameterName'; })
                        .map(function (part) { return ("{{" + part.text + "}}"); });
                    if (suggestionArgumentNames.length > 0) {
                        codeSnippet += '(' + suggestionArgumentNames.join(', ') + '){{}}';
                    }
                    else {
                        codeSnippet += '()';
                    }
                    suggestion.codeSnippet = codeSnippet;
                }
                return suggestion;
            }, function (err) {
                return suggestion;
            });
        };
        SuggestSupport.prototype.monacoTypeFromEntryKind = function (kind) {
            switch (kind) {
                case PConst.Kind.primitiveType:
                case PConst.Kind.keyword:
                    return 'keyword';
                case PConst.Kind.variable:
                case PConst.Kind.localVariable:
                case PConst.Kind.memberVariable:
                case PConst.Kind.memberGetAccessor:
                case PConst.Kind.memberSetAccessor:
                    return 'field';
                case PConst.Kind.function:
                case PConst.Kind.memberFunction:
                case PConst.Kind.constructSignature:
                case PConst.Kind.callSignature:
                    return 'function';
            }
            return kind;
        };
        SuggestSupport.bySortText = function (a, b) {
            return a.sortText.localeCompare(b.sortText);
        };
        return SuggestSupport;
    })();
    return SuggestSupport;
});
//# sourceMappingURL=suggestSupport.js.map