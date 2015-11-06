/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", 'vscode', './parser', './hubAPI'], function (require, exports, vscode, parser, hub) {
    function isDockerCompose(resource) {
        return /docker\-compose\.yml$/.test(resource.toString());
    }
    var ExtraInfoSupport = (function () {
        function ExtraInfoSupport() {
        }
        ExtraInfoSupport.prototype.computeInfo = function (document, position, token) {
            if (!isDockerCompose(document.getUri())) {
                return Promise.resolve(null);
            }
            var line = document.getTextOnLine(position.line);
            if (line.length === 0) {
                // empty line
                return Promise.resolve(null);
            }
            var tokens = parser.parseLine(line);
            return this._computeInfoForLineWithTokens(line, tokens, position);
        };
        ExtraInfoSupport.prototype._computeInfoForLineWithTokens = function (line, tokens, position) {
            var _this = this;
            var possibleTokens = parser.tokensAtColumn(tokens, position.character);
            return Promise.all(possibleTokens.map(function (tokenIndex) { return _this._computeInfoForToken(line, tokens, tokenIndex); })).then(function (results) {
                return possibleTokens.map(function (tokenIndex, arrayIndex) {
                    return {
                        startIndex: tokens[tokenIndex].startIndex,
                        endIndex: tokens[tokenIndex].endIndex,
                        result: results[arrayIndex]
                    };
                });
            }).then(function (results) {
                var r = results.filter(function (r) { return !!r.result; });
                if (r.length === 0) {
                    return null;
                }
                return {
                    range: new vscode.Range(position.line, r[0].startIndex + 1, position.line, r[0].endIndex + 1),
                    htmlContent: r[0].result
                };
            });
        };
        ExtraInfoSupport.prototype._computeInfoForToken = function (line, tokens, tokenIndex) {
            // -------------
            // Detect hovering on a key
            if (tokens[tokenIndex].type === parser.TokenType.Key) {
                var keyName = parser.keyNameFromKeyToken(parser.tokenValue(line, tokens[tokenIndex]));
                var r = ExtraInfoSupport.getInfoForKey(keyName);
                if (r) {
                    return Promise.resolve(r);
                }
            }
            // -------------
            // Detect <<image: [["something"]]>>
            // Detect <<image: [[something]]>>
            var r2 = this._getImageNameHover(line, tokens, tokenIndex);
            if (r2) {
                return r2;
            }
            return null;
        };
        ExtraInfoSupport.prototype._getImageNameHover = function (line, tokens, tokenIndex) {
            // -------------
            // Detect <<image: [["something"]]>>
            // Detect <<image: [[something]]>>
            var originalValue = parser.tokenValue(line, tokens[tokenIndex]);
            var keyToken = null;
            tokenIndex--;
            while (tokenIndex > 0) {
                var type = tokens[tokenIndex].type;
                if (type === parser.TokenType.String || type === parser.TokenType.Text) {
                    return null;
                }
                if (type === parser.TokenType.Key) {
                    keyToken = parser.tokenValue(line, tokens[tokenIndex]);
                    break;
                }
                tokenIndex--;
            }
            if (!keyToken) {
                return null;
            }
            var keyName = parser.keyNameFromKeyToken(keyToken);
            if (keyName === 'image') {
                var imageName = originalValue.replace(/^"/, '').replace(/"$/, '');
                return Promise.all([searchImageInRegistryHub(imageName)]).then(function (results) {
                    if (results[0] && results[1]) {
                        return [{
                                tagName: 'strong',
                                text: 'DockerHub:'
                            }, {
                                tagName: 'br'
                            }, {
                                tagName: 'div',
                                children: results[0]
                            }, {
                                tagName: 'strong',
                                text: 'DockerRuntime:'
                            }, {
                                tagName: 'br'
                            }, {
                                tagName: 'div',
                                children: results[1]
                            }];
                    }
                    if (results[0]) {
                        return results[0];
                    }
                    return results[1];
                });
            }
        };
        ExtraInfoSupport.getInfoForKey = function (keyName) {
            if (ExtraInfoSupport._KEY_INFO === null) {
                ExtraInfoSupport._KEY_INFO = {};
                Object.keys(parser.RAW_KEY_INFO).forEach(function (keyName) {
                    ExtraInfoSupport._KEY_INFO[keyName] = simpleMarkDownToHTMLContent(parser.RAW_KEY_INFO[keyName]);
                });
            }
            return ExtraInfoSupport._KEY_INFO[keyName] || null;
        };
        ExtraInfoSupport._KEY_INFO = null;
        return ExtraInfoSupport;
    })();
    exports.ExtraInfoSupport = ExtraInfoSupport;
    var TagType;
    (function (TagType) {
        TagType[TagType["pre"] = 0] = "pre";
        TagType[TagType["bold"] = 1] = "bold";
        TagType[TagType["normal"] = 2] = "normal";
    })(TagType || (TagType = {}));
    function simpleMarkDownToHTMLContent(source) {
        var r = [];
        var lastPushedTo;
        var push = function (to, type) {
            if (lastPushedTo >= to) {
                return;
            }
            var text = source.substring(lastPushedTo, to);
            if (type === TagType.pre) {
                r.push({
                    tagName: "span",
                    style: "font-family:monospace",
                    className: "token keyword",
                    text: text
                });
            }
            else if (type === TagType.bold) {
                r.push({
                    tagName: "strong",
                    text: text
                });
            }
            else if (type === TagType.normal) {
                r.push({
                    tagName: "span",
                    text: text
                });
            }
            lastPushedTo = to;
        };
        var currentTagType = function () {
            if (inPre) {
                return TagType.pre;
            }
            if (inBold) {
                return TagType.bold;
            }
            return TagType.normal;
        };
        var inPre = false, inBold = false;
        for (var i = 0, len = source.length; i < len; i++) {
            var ch = source.charAt(i);
            if (ch === '\n') {
                push(i, currentTagType());
                r.push({
                    tagName: 'br'
                });
                lastPushedTo = i + 1;
            }
            else if (ch === '`') {
                push(i, currentTagType());
                lastPushedTo = i + 1;
                inPre = !inPre;
            }
            else if (ch === '*') {
                push(i, currentTagType());
                lastPushedTo = i + 1;
                inBold = !inBold;
            }
        }
        push(source.length, currentTagType());
        return r;
    }
    function searchImageInRegistryHub(imageName) {
        return hub.searchImageInRegistryHub(imageName, true).then(function (result) {
            if (result) {
                var r = [];
                // Name
                r.push({
                    tagName: 'strong',
                    className: 'token keyword',
                    text: result.name
                });
                var tags = hub.tagsForImage(result);
                if (tags.length > 0) {
                    r.push({
                        tagName: 'strong',
                        text: ' ' + tags + ' '
                    });
                }
                if (result.star_count) {
                    var plural = (result.star_count > 1);
                    r.push({
                        tagName: 'strong',
                        text: String(result.star_count)
                    });
                    r.push({
                        tagName: 'span',
                        text: (plural ? ' stars' : ' star')
                    });
                }
                // Description
                r.push({
                    tagName: 'br'
                });
                r.push({
                    tagName: 'span',
                    text: result.description
                });
                return r;
            }
        });
    }
});
//# sourceMappingURL=extraInfoSupport.js.map