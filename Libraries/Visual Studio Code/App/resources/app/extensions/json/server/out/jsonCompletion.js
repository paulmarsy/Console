/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
'use strict';
var nls = require('./utils/nls');
var vscode_languageserver_1 = require('vscode-languageserver');
var JSONCompletion = (function () {
    function JSONCompletion(schemaService, contributions) {
        if (contributions === void 0) { contributions = []; }
        this.schemaService = schemaService;
        this.contributions = contributions;
    }
    JSONCompletion.prototype.doSuggest = function (document, textDocumentPosition, doc) {
        var _this = this;
        var offset = document.offsetAt(textDocumentPosition.position);
        var node = doc.getNodeFromOffsetEndInclusive(offset);
        var currentWord = this.getCurrentWord(document, offset);
        var overwriteRange = null;
        var result = {
            items: [],
            isIncomplete: false
        };
        if (node && (node.type === 'string' || node.type === 'number' || node.type === 'boolean' || node.type === 'null')) {
            overwriteRange = vscode_languageserver_1.Range.create(document.positionAt(node.start), document.positionAt(node.end));
        }
        else {
            overwriteRange = vscode_languageserver_1.Range.create(document.positionAt(offset - currentWord.length), textDocumentPosition.position);
        }
        var proposed = {};
        var collector = {
            add: function (suggestion) {
                if (!proposed[suggestion.label]) {
                    proposed[suggestion.label] = true;
                    if (overwriteRange) {
                        suggestion.textEdit = vscode_languageserver_1.TextEdit.replace(overwriteRange, suggestion.insertText);
                    }
                    result.items.push(suggestion);
                }
            },
            setAsIncomplete: function () {
                result.isIncomplete = true;
            },
            error: function (message) {
                console.log(message);
            }
        };
        return this.schemaService.getSchemaForResource(textDocumentPosition.uri, doc).then(function (schema) {
            var collectionPromises = [];
            var addValue = true;
            var currentKey = '';
            var currentProperty = null;
            if (node) {
                if (node.type === 'string') {
                    var stringNode = node;
                    if (stringNode.isKey) {
                        addValue = !(node.parent && (node.parent.value));
                        currentProperty = node.parent ? node.parent : null;
                        currentKey = document.getText().substring(node.start + 1, node.end - 1);
                        if (node.parent) {
                            node = node.parent.parent;
                        }
                    }
                }
            }
            // proposals for properties
            if (node && node.type === 'object') {
                // don't suggest keys when the cursor is just before the opening curly brace
                if (node.start === offset) {
                    return result;
                }
                // don't suggest properties that are already present
                var properties = node.properties;
                properties.forEach(function (p) {
                    if (!currentProperty || currentProperty !== p) {
                        proposed[p.key.value] = true;
                    }
                });
                var isLast = properties.length === 0 || offset >= properties[properties.length - 1].start;
                if (schema) {
                    // property proposals with schema
                    _this.getPropertySuggestions(schema, doc, node, addValue, isLast, collector);
                }
                else {
                    // property proposals without schema
                    _this.getSchemaLessPropertySuggestions(doc, node, currentKey, currentWord, isLast, collector);
                }
                var location_1 = node.getNodeLocation();
                _this.contributions.forEach(function (contribution) {
                    var collectPromise = contribution.collectPropertySuggestions(textDocumentPosition.uri, location_1, currentWord, addValue, isLast, collector);
                    if (collectPromise) {
                        collectionPromises.push(collectPromise);
                    }
                });
            }
            // proposals for values
            if (node && (node.type === 'string' || node.type === 'number' || node.type === 'boolean' || node.type === 'null')) {
                node = node.parent;
            }
            if (schema) {
                // value proposals with schema
                _this.getValueSuggestions(schema, doc, node, offset, collector);
            }
            else {
                // value proposals without schema
                _this.getSchemaLessValueSuggestions(doc, node, offset, document, collector);
            }
            if (!node) {
                _this.contributions.forEach(function (contribution) {
                    var collectPromise = contribution.collectDefaultSuggestions(textDocumentPosition.uri, collector);
                    if (collectPromise) {
                        collectionPromises.push(collectPromise);
                    }
                });
            }
            else {
                if ((node.type === 'property') && offset > node.colonOffset) {
                    var parentKey = node.key.value;
                    var valueNode = node.value;
                    if (!valueNode || offset <= valueNode.end) {
                        var location_2 = node.parent.getNodeLocation();
                        _this.contributions.forEach(function (contribution) {
                            var collectPromise = contribution.collectValueSuggestions(textDocumentPosition.uri, location_2, parentKey, collector);
                            if (collectPromise) {
                                collectionPromises.push(collectPromise);
                            }
                        });
                    }
                }
            }
            return Promise.all(collectionPromises).then(function () { return result; });
        });
    };
    JSONCompletion.prototype.getPropertySuggestions = function (schema, doc, node, addValue, isLast, collector) {
        var _this = this;
        var matchingSchemas = [];
        doc.validate(schema.schema, matchingSchemas, node.start);
        matchingSchemas.forEach(function (s) {
            if (s.node === node && !s.inverted) {
                var schemaProperties = s.schema.properties;
                if (schemaProperties) {
                    Object.keys(schemaProperties).forEach(function (key) {
                        var propertySchema = schemaProperties[key];
                        collector.add({ kind: vscode_languageserver_1.CompletionItemKind.Property, label: key, insertText: _this.getSnippetForProperty(key, propertySchema, addValue, isLast), documentation: propertySchema.description || '' });
                    });
                }
            }
        });
    };
    JSONCompletion.prototype.getSchemaLessPropertySuggestions = function (doc, node, currentKey, currentWord, isLast, collector) {
        var _this = this;
        var collectSuggestionsForSimilarObject = function (obj) {
            obj.properties.forEach(function (p) {
                var key = p.key.value;
                collector.add({ kind: vscode_languageserver_1.CompletionItemKind.Property, label: key, insertText: _this.getSnippetForSimilarProperty(key, p.value), documentation: '' });
            });
        };
        if (node.parent) {
            if (node.parent.type === 'property') {
                // if the object is a property value, check the tree for other objects that hang under a property of the same name
                var parentKey = node.parent.key.value;
                doc.visit(function (n) {
                    if (n.type === 'property' && n.key.value === parentKey && n.value && n.value.type === 'object') {
                        collectSuggestionsForSimilarObject(n.value);
                    }
                    return true;
                });
            }
            else if (node.parent.type === 'array') {
                // if the object is in an array, use all other array elements as similar objects
                node.parent.items.forEach(function (n) {
                    if (n.type === 'object' && n !== node) {
                        collectSuggestionsForSimilarObject(n);
                    }
                });
            }
        }
        if (!currentKey && currentWord.length > 0) {
            collector.add({ kind: vscode_languageserver_1.CompletionItemKind.Property, label: JSON.stringify(currentWord), insertText: this.getSnippetForProperty(currentWord, null, true, isLast), documentation: '' });
        }
    };
    JSONCompletion.prototype.getSchemaLessValueSuggestions = function (doc, node, offset, document, collector) {
        var _this = this;
        var collectSuggestionsForValues = function (value) {
            if (!value.contains(offset)) {
                var content = _this.getMatchingSnippet(value, document);
                collector.add({ kind: _this.getSuggestionKind(value.type), label: content, insertText: content, documentation: '' });
            }
            if (value.type === 'boolean') {
                _this.addBooleanSuggestion(!value.getValue(), collector);
            }
        };
        if (!node) {
            collector.add({ kind: this.getSuggestionKind('object'), label: 'Empty object', insertText: '{\n\t{{}}\n}', documentation: '' });
            collector.add({ kind: this.getSuggestionKind('array'), label: 'Empty array', insertText: '[\n\t{{}}\n]', documentation: '' });
        }
        else {
            if (node.type === 'property' && offset > node.colonOffset) {
                var valueNode = node.value;
                if (valueNode && offset > valueNode.end) {
                    return;
                }
                // suggest values at the same key
                var parentKey = node.key.value;
                doc.visit(function (n) {
                    if (n.type === 'property' && n.key.value === parentKey && n.value) {
                        collectSuggestionsForValues(n.value);
                    }
                    return true;
                });
            }
            if (node.type === 'array') {
                if (node.parent && node.parent.type === 'property') {
                    // suggest items of an array at the same key
                    var parentKey = node.parent.key.value;
                    doc.visit(function (n) {
                        if (n.type === 'property' && n.key.value === parentKey && n.value && n.value.type === 'array') {
                            (n.value.items).forEach(function (n) {
                                collectSuggestionsForValues(n);
                            });
                        }
                        return true;
                    });
                }
                else {
                    // suggest items in the same array
                    node.items.forEach(function (n) {
                        collectSuggestionsForValues(n);
                    });
                }
            }
        }
    };
    JSONCompletion.prototype.getValueSuggestions = function (schema, doc, node, offset, collector) {
        var _this = this;
        if (!node) {
            this.addDefaultSuggestion(schema.schema, collector);
        }
        else {
            var parentKey = null;
            if (node && (node.type === 'property') && offset > node.colonOffset) {
                var valueNode = node.value;
                if (valueNode && offset > valueNode.end) {
                    return; // we are past the value node
                }
                parentKey = node.key.value;
                node = node.parent;
            }
            if (node && (parentKey !== null || node.type === 'array')) {
                var matchingSchemas = [];
                doc.validate(schema.schema, matchingSchemas, node.start);
                matchingSchemas.forEach(function (s) {
                    if (s.node === node && !s.inverted && s.schema) {
                        if (s.schema.items) {
                            _this.addDefaultSuggestion(s.schema.items, collector);
                            _this.addEnumSuggestion(s.schema.items, collector);
                        }
                        if (s.schema.properties) {
                            var propertySchema = s.schema.properties[parentKey];
                            if (propertySchema) {
                                _this.addDefaultSuggestion(propertySchema, collector);
                                _this.addEnumSuggestion(propertySchema, collector);
                            }
                        }
                    }
                });
            }
        }
    };
    JSONCompletion.prototype.addBooleanSuggestion = function (value, collector) {
        collector.add({ kind: this.getSuggestionKind('boolean'), label: value ? 'true' : 'false', insertText: this.getTextForValue(value), documentation: '' });
    };
    JSONCompletion.prototype.addEnumSuggestion = function (schema, collector) {
        var _this = this;
        if (Array.isArray(schema.enum)) {
            schema.enum.forEach(function (enm) { return collector.add({ kind: _this.getSuggestionKind(schema.type), label: _this.getLabelForValue(enm), insertText: _this.getTextForValue(enm), documentation: '' }); });
        }
        else if (schema.type === 'boolean') {
            this.addBooleanSuggestion(true, collector);
            this.addBooleanSuggestion(false, collector);
        }
        if (Array.isArray(schema.allOf)) {
            schema.allOf.forEach(function (s) { return _this.addEnumSuggestion(s, collector); });
        }
        if (Array.isArray(schema.anyOf)) {
            schema.anyOf.forEach(function (s) { return _this.addEnumSuggestion(s, collector); });
        }
        if (Array.isArray(schema.oneOf)) {
            schema.oneOf.forEach(function (s) { return _this.addEnumSuggestion(s, collector); });
        }
    };
    JSONCompletion.prototype.addDefaultSuggestion = function (schema, collector) {
        var _this = this;
        if (schema.default) {
            collector.add({
                kind: this.getSuggestionKind(schema.type),
                label: this.getLabelForValue(schema.default),
                insertText: this.getTextForValue(schema.default),
                detail: nls.localize('json.suggest.default', 'Default value'),
            });
        }
        if (Array.isArray(schema.allOf)) {
            schema.allOf.forEach(function (s) { return _this.addDefaultSuggestion(s, collector); });
        }
        if (Array.isArray(schema.anyOf)) {
            schema.anyOf.forEach(function (s) { return _this.addDefaultSuggestion(s, collector); });
        }
        if (Array.isArray(schema.oneOf)) {
            schema.oneOf.forEach(function (s) { return _this.addDefaultSuggestion(s, collector); });
        }
    };
    JSONCompletion.prototype.getLabelForValue = function (value) {
        var label = JSON.stringify(value);
        label = label.replace('{{', '').replace('}}', '');
        if (label.length > 57) {
            return label.substr(0, 57).trim() + '...';
        }
        return label;
    };
    JSONCompletion.prototype.getTextForValue = function (value) {
        return JSON.stringify(value, null, '\t');
    };
    JSONCompletion.prototype.getSnippetForValue = function (value) {
        var snippet = JSON.stringify(value, null, '\t');
        switch (typeof value) {
            case 'object':
                if (value === null) {
                    return '{{null}}';
                }
                return snippet;
            case 'string':
                return '"{{' + snippet.substr(1, snippet.length - 2) + '}}"';
            case 'number':
            case 'boolean':
                return '{{' + snippet + '}}';
        }
        return snippet;
    };
    JSONCompletion.prototype.getSuggestionKind = function (type) {
        if (Array.isArray(type)) {
            var array = type;
            type = array.length > 0 ? array[0] : null;
        }
        if (!type) {
            return vscode_languageserver_1.CompletionItemKind.Text;
        }
        switch (type) {
            case 'string': return vscode_languageserver_1.CompletionItemKind.Text;
            case 'object': return vscode_languageserver_1.CompletionItemKind.Module;
            case 'property': return vscode_languageserver_1.CompletionItemKind.Property;
            default: return vscode_languageserver_1.CompletionItemKind.Value;
        }
    };
    JSONCompletion.prototype.getMatchingSnippet = function (node, document) {
        switch (node.type) {
            case 'array':
                return '[]';
            case 'object':
                return '{}';
            default:
                var content = document.getText().substr(node.start, node.end - node.start);
                return content;
        }
    };
    JSONCompletion.prototype.getSnippetForProperty = function (key, propertySchema, addValue, isLast) {
        var result = '"' + key + '"';
        if (!addValue) {
            return result;
        }
        result += ': ';
        if (propertySchema) {
            var defaultVal = propertySchema.default;
            if (typeof defaultVal !== 'undefined') {
                result = result + this.getSnippetForValue(defaultVal);
            }
            else if (propertySchema.enum && propertySchema.enum.length > 0) {
                result = result + this.getSnippetForValue(propertySchema.enum[0]);
            }
            else {
                switch (propertySchema.type) {
                    case 'boolean':
                        result += '{{false}}';
                        break;
                    case 'string':
                        result += '"{{}}"';
                        break;
                    case 'object':
                        result += '{\n\t{{}}\n}';
                        break;
                    case 'array':
                        result += '[\n\t{{}}\n]';
                        break;
                    case 'number':
                        result += '{{0}}';
                        break;
                    case 'null':
                        result += '{{null}}';
                        break;
                    default:
                        return result;
                }
            }
        }
        else {
            result += '{{0}}';
        }
        if (!isLast) {
            result += ',';
        }
        return result;
    };
    JSONCompletion.prototype.getSnippetForSimilarProperty = function (key, templateValue) {
        return '"' + key + '"';
    };
    JSONCompletion.prototype.getCurrentWord = function (document, offset) {
        var i = offset - 1;
        var text = document.getText();
        while (i >= 0 && ' \t\n\r\v"'.indexOf(text.charAt(i)) === -1) {
            i--;
        }
        return text.substring(i + 1, offset);
    };
    return JSONCompletion;
})();
exports.JSONCompletion = JSONCompletion;
//# sourceMappingURL=jsonCompletion.js.map