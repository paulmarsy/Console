/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", './parser', './hubAPI'], function (require, exports, parser, hub) {
    function isDockerCompose(resource) {
        return /docker\-compose\.yml$/.test(resource.toString());
    }
    var SuggestSupport = (function () {
        function SuggestSupport() {
            this.triggerCharacters = [];
            this.excludeTokens = [];
        }
        SuggestSupport.prototype.suggest = function (document, position) {
            if (!isDockerCompose(document.getUri())) {
                return Promise.resolve(null);
            }
            var line = document.getTextOnLine(position.line);
            if (line.length === 0) {
                // empty line
                return Promise.resolve([this._suggestKeys('')]);
            }
            var range = document.getWordRangeAtPosition(position);
            var word = range && document.getTextInRange(range) || '';
            var textBefore = line.substring(0, position.character - 1);
            if (/^\s*[\w_]*$/.test(textBefore)) {
                // on the first token
                return Promise.resolve([this._suggestKeys(word)]);
            }
            var imageTextWithQuoteMatch = textBefore.match(/^\s*image\s*\:\s*"([^"]*)$/);
            if (imageTextWithQuoteMatch) {
                var imageText = imageTextWithQuoteMatch[1];
                return this._suggestImages(imageText, true);
            }
            var imageTextWithoutQuoteMatch = textBefore.match(/^\s*image\s*\:\s*([\w\:\/]*)/);
            if (imageTextWithoutQuoteMatch) {
                var imageText = imageTextWithoutQuoteMatch[1];
                return this._suggestImages(imageText, false);
            }
            return Promise.resolve([]);
        };
        SuggestSupport.prototype._suggestImages = function (word, hasLeadingQuote) {
            return this._suggestHubImages(word).then(function (results) {
                return [{
                        incomplete: true,
                        currentWord: (hasLeadingQuote ? '"' + word : word),
                        suggestions: results
                    }];
            });
        };
        SuggestSupport.prototype._suggestHubImages = function (word) {
            return hub.searchImagesInRegistryHub(word, true).then(function (results) {
                return results.map(function (image) {
                    var stars = '';
                    if (image.star_count > 0) {
                        stars = ' ' + image.star_count + ' ' + (image.star_count > 1 ? 'stars' : 'star');
                    }
                    return {
                        label: image.name,
                        codeSnippet: '"' + image.name + '"',
                        type: 'value',
                        documentationLabel: image.description,
                        typeLabel: hub.tagsForImage(image) + stars
                    };
                });
            });
        };
        SuggestSupport.prototype._suggestKeys = function (word) {
            return {
                currentWord: word,
                suggestions: Object.keys(parser.RAW_KEY_INFO).map(function (ruleName) {
                    return {
                        label: ruleName,
                        codeSnippet: ruleName + ': ',
                        type: 'property',
                        documentationLabel: parser.RAW_KEY_INFO[ruleName]
                    };
                })
            };
        };
        return SuggestSupport;
    })();
    exports.SuggestSupport = SuggestSupport;
});
//# sourceMappingURL=suggestSupport.js.map