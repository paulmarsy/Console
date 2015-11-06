/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
var vscode_languageworker_1 = require('vscode-languageworker');
var fs = require('fs');
var path = require('path');
var workspaceRoot = null;
var settings = null;
var jshintSettings = null;
var lib = null;
var JSHINTRC = '.jshintrc';
var optionsCache = Object.create(null);
var validator = {
    initialize: function (rootFolder) {
        workspaceRoot = rootFolder;
        return vscode_languageworker_1.Files.resolveModule(rootFolder, 'jshint').then(function (value) {
            if (!value.JSHINT) {
                return { success: false, message: 'The jshint library doesn\'t export a JSHINT property.' };
            }
            lib = value;
            return null;
        }, function (error) {
            return Promise.reject({
                success: false,
                message: 'Failed to load jshint library. Please install jshint in your workspace folder using \'npm install jshint\' and then press Retry.',
                retry: true
            });
        });
    },
    onFileEvents: function (changes, requestor) {
        optionsCache = Object.create(null);
        requestor.all();
    },
    onConfigurationChange: function (_settings, requestor) {
        settings = _settings;
        if (settings.jshint) {
            jshintSettings = settings.jshint.options || {};
        }
        optionsCache = Object.create(null);
        requestor.all();
    },
    validate: function (document) {
        var content = document.getText();
        var JSHINT = lib.JSHINT;
        var fsPath = vscode_languageworker_1.Files.uriToFilePath(document.uri);
        if (!fsPath) {
            fsPath = workspaceRoot;
        }
        var options = null;
        if (fsPath) {
            options = optionsCache[fsPath];
            if (!options) {
                options = readOptions(fsPath);
                optionsCache[fsPath] = options;
            }
        }
        else {
            options = optionsCache[''];
            if (!options) {
                options = readOptions(fsPath);
                optionsCache[''] = options;
            }
        }
        options = options || {};
        JSHINT(content, options, options.globals || {});
        var diagnostics = [];
        var errors = JSHINT.errors;
        if (errors) {
            errors.forEach(function (error) {
                // For some reason the errors array contains null.
                if (error) {
                    diagnostics.push(makeDiagnostic(error));
                }
            });
        }
        return diagnostics;
    }
};
function makeDiagnostic(problem) {
    return {
        message: problem.reason,
        severity: getSeverity(problem),
        code: problem.code,
        start: {
            line: problem.line,
            character: problem.character
        }
    };
}
function getSeverity(problem) {
    if (problem.id === '(error)') {
        return vscode_languageworker_1.Severity.Error;
    }
    return vscode_languageworker_1.Severity.Warning;
}
function isWindows() {
    return process.platform === 'win32';
}
function readOptions(fsPath) {
    if (fsPath === void 0) { fsPath = null; }
    function locateFile(directory, fileName) {
        var parent = directory;
        do {
            directory = parent;
            var location_1 = path.join(directory, fileName);
            if (fs.existsSync(location_1)) {
                return location_1;
            }
            parent = path.dirname(directory);
        } while (parent !== directory);
        return undefined;
    }
    ;
    function stripComments(content) {
        /**
         * First capturing group mathes double quoted string
         * Second matches singler quotes string
         * Thrid matches block comments
         * Fourth matches line comments
         */
        var regexp = /("(?:[^\\\"]*(?:\\.)?)*")|('(?:[^\\\']*(?:\\.)?)*')|(\/\*(?:\r?\n|.)*?\*\/)|(\/{2,}.*?(?:(?:\r?\n)|$))/g;
        var result = content.replace(regexp, function (match, m1, m2, m3, m4) {
            // Only one of m1, m2, m3, m4 matches
            if (m3) {
                // A block comment. Replace with nothing
                return "";
            }
            else if (m4) {
                // A line comment. If it ends in \r?\n then keep it.
                var length_1 = m4.length;
                if (length_1 > 2 && m4[length_1 - 1] === '\n') {
                    return m4[length_1 - 2] === '\r' ? '\r\n' : '\n';
                }
                else {
                    return "";
                }
            }
            else {
                // We match a string
                return match;
            }
        });
        return result;
    }
    ;
    function readJsonFile(file) {
        try {
            return JSON.parse(stripComments(fs.readFileSync(file).toString()));
        }
        catch (err) {
            throw new vscode_languageworker_1.LanguageWorkerError("Can't load JSHint configuration from file " + file + ". Please check the file for syntax errors.", vscode_languageworker_1.MessageKind.Show);
        }
    }
    function getUserHome() {
        return process.env[isWindows() ? 'USERPROFILE' : 'HOME'];
    }
    if (jshintSettings.config && fs.existsSync(jshintSettings.config)) {
        return readJsonFile(jshintSettings.config);
    }
    if (fsPath) {
        var packageFile = locateFile(fsPath, 'package.json');
        if (packageFile) {
            var content = readJsonFile(packageFile);
            if (content.jshintConfig) {
                return content.jshintConfig;
            }
        }
        var configFile = locateFile(fsPath, JSHINTRC);
        if (configFile) {
            return readJsonFile(configFile);
        }
    }
    var home = getUserHome();
    if (home) {
        var file = path.join(home, JSHINTRC);
        if (fs.existsSync(file)) {
            return readJsonFile(file);
        }
    }
    return jshintSettings;
}
;
vscode_languageworker_1.runSingleFileValidator(process.stdin, process.stdout, validator);
