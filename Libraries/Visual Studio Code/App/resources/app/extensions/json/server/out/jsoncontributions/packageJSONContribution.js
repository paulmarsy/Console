/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
'use strict';
var vscode_languageserver_1 = require('vscode-languageserver');
var Strings = require('../utils/strings');
var nls = require('../utils/nls');
var LIMIT = 40;
var PackageJSONContribution = (function () {
    function PackageJSONContribution(requestService) {
        this.mostDependedOn = ['lodash', 'async', 'underscore', 'request', 'commander', 'express', 'debug', 'chalk', 'colors', 'q', 'coffee-script',
            'mkdirp', 'optimist', 'through2', 'yeoman-generator', 'moment', 'bluebird', 'glob', 'gulp-util', 'minimist', 'cheerio', 'jade', 'redis', 'node-uuid',
            'socket', 'io', 'uglify-js', 'winston', 'through', 'fs-extra', 'handlebars', 'body-parser', 'rimraf', 'mime', 'semver', 'mongodb', 'jquery',
            'grunt', 'connect', 'yosay', 'underscore', 'string', 'xml2js', 'ejs', 'mongoose', 'marked', 'extend', 'mocha', 'superagent', 'js-yaml', 'xtend',
            'shelljs', 'gulp', 'yargs', 'browserify', 'minimatch', 'react', 'less', 'prompt', 'inquirer', 'ws', 'event-stream', 'inherits', 'mysql', 'esprima',
            'jsdom', 'stylus', 'when', 'readable-stream', 'aws-sdk', 'concat-stream', 'chai', 'Thenable', 'wrench'];
        this.requestService = requestService;
    }
    PackageJSONContribution.prototype.isPackageJSONFile = function (resource) {
        return Strings.endsWith(resource, '/package.json');
    };
    PackageJSONContribution.prototype.collectDefaultSuggestions = function (resource, result) {
        if (this.isPackageJSONFile(resource)) {
            var defaultValue = {
                'name': '{{name}}',
                'description': '{{description}}',
                'author': '{{author}}',
                'version': '{{1.0.0}}',
                'main': '{{pathToMain}}',
                'dependencies': {}
            };
            result.add({ kind: vscode_languageserver_1.CompletionItemKind.Module, label: nls.localize('json.package.default', 'Default package.json'), insertText: JSON.stringify(defaultValue, null, '\t'), documentation: '' });
        }
        return null;
    };
    PackageJSONContribution.prototype.collectPropertySuggestions = function (resource, location, currentWord, addValue, isLast, result) {
        if (this.isPackageJSONFile(resource) && (location.matches(['dependencies']) || location.matches(['devDependencies']) || location.matches(['optionalDependencies']) || location.matches(['peerDependencies']))) {
            var queryUrl;
            if (currentWord.length > 0) {
                queryUrl = 'https://skimdb.npmjs.com/registry/_design/app/_view/browseAll?group_level=1&limit=' + LIMIT + '&start_key=%5B%22' + encodeURIComponent(currentWord) + '%22%5D&end_key=%5B%22' + encodeURIComponent(currentWord + 'z') + '%22,%7B%7D%5D';
                return this.requestService({
                    url: queryUrl
                }).then(function (success) {
                    if (success.status === 200) {
                        try {
                            var obj = JSON.parse(success.responseText);
                            if (obj && Array.isArray(obj.rows)) {
                                var results = obj.rows;
                                for (var i = 0; i < results.length; i++) {
                                    var keys = results[i].key;
                                    if (Array.isArray(keys) && keys.length > 0) {
                                        var name_1 = keys[0];
                                        var insertText = JSON.stringify(name_1);
                                        if (addValue) {
                                            insertText += ': "{{*}}"';
                                            if (!isLast) {
                                                insertText += ',';
                                            }
                                        }
                                        result.add({ kind: vscode_languageserver_1.CompletionItemKind.Property, label: name_1, insertText: insertText, documentation: '' });
                                    }
                                }
                                if (results.length === LIMIT) {
                                    result.setAsIncomplete();
                                }
                            }
                        }
                        catch (e) {
                        }
                    }
                    else {
                        result.error(nls.localize('json.npm.error.repoaccess', 'Request to the NPM repository failed: {0}', success.responseText));
                        return 0;
                    }
                }, function (error) {
                    result.error(nls.localize('json.npm.error.repoaccess', 'Request to the NPM repository failed: {0}', error.responseText));
                    return 0;
                });
            }
            else {
                this.mostDependedOn.forEach(function (name) {
                    var insertText = JSON.stringify(name);
                    if (addValue) {
                        insertText += ': "{{*}}"';
                        if (!isLast) {
                            insertText += ',';
                        }
                    }
                    result.add({ kind: vscode_languageserver_1.CompletionItemKind.Property, label: name, insertText: insertText, documentation: '' });
                });
                result.setAsIncomplete();
            }
        }
        return null;
    };
    PackageJSONContribution.prototype.collectValueSuggestions = function (resource, location, currentKey, result) {
        if (this.isPackageJSONFile(resource) && (location.matches(['dependencies']) || location.matches(['devDependencies']) || location.matches(['optionalDependencies']) || location.matches(['peerDependencies']))) {
            var queryUrl = 'http://registry.npmjs.org/' + encodeURIComponent(currentKey) + '/latest';
            return this.requestService({
                url: queryUrl
            }).then(function (success) {
                try {
                    var obj = JSON.parse(success.responseText);
                    if (obj && obj.version) {
                        var version = obj.version;
                        var name_2 = JSON.stringify(version);
                        result.add({ kind: vscode_languageserver_1.CompletionItemKind.Class, label: name_2, insertText: name_2, documentation: nls.localize('json.npm.latestversion', 'The currently latest version of the package') });
                        name_2 = JSON.stringify('^' + version);
                        result.add({ kind: vscode_languageserver_1.CompletionItemKind.Class, label: name_2, insertText: name_2, documentation: nls.localize('json.npm.majorversion', 'Matches the most recent major version (1.x.x)') });
                        name_2 = JSON.stringify('~' + version);
                        result.add({ kind: vscode_languageserver_1.CompletionItemKind.Class, label: name_2, insertText: name_2, documentation: nls.localize('json.npm.minorversion', 'Matches the most recent minor version (1.2.x)') });
                    }
                }
                catch (e) {
                }
                return 0;
            }, function (error) {
                return 0;
            });
        }
        return null;
    };
    PackageJSONContribution.prototype.getInfoContribution = function (resource, location) {
        if (this.isPackageJSONFile(resource) && (location.matches(['dependencies', '*']) || location.matches(['devDependencies', '*']) || location.matches(['optionalDependencies', '*']) || location.matches(['peerDependencies', '*']))) {
            var pack = location.getSegments()[location.getSegments().length - 1];
            var htmlContent = [];
            htmlContent.push(nls.localize('json.npm.package.hover', '{0}', pack));
            var queryUrl = 'http://registry.npmjs.org/' + encodeURIComponent(pack) + '/latest';
            return this.requestService({
                url: queryUrl
            }).then(function (success) {
                try {
                    var obj = JSON.parse(success.responseText);
                    if (obj) {
                        if (obj.description) {
                            htmlContent.push(obj.description);
                        }
                        if (obj.version) {
                            htmlContent.push(nls.localize('json.npm.version.hover', 'Latest version: {0}', obj.version));
                        }
                    }
                }
                catch (e) {
                }
                return htmlContent;
            }, function (error) {
                return htmlContent;
            });
        }
        return null;
    };
    return PackageJSONContribution;
})();
exports.PackageJSONContribution = PackageJSONContribution;
//# sourceMappingURL=packageJSONContribution.js.map