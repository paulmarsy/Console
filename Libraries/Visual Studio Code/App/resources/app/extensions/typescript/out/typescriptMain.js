/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
/* Includes code from typescript-sublime-plugin project, obtained from https://github.com/Microsoft/TypeScript-Sublime-Plugin/blob/master/TypeScript%20Indent.tmPreferences */
'use strict';
define(["require", "exports", 'vscode', './features/extraInfoSupport', './features/commentsSupport', './features/declarationSupport', './features/occurrencesSupport', './features/referenceSupport', './features/outlineSupport', './features/parameterHintsSupport', './features/renameSupport', './features/formattingSupport', './features/bufferSyncSupport', './features/suggestSupport', './features/configuration', './features/navigateTypesSupport', './typescriptServiceClient'], function (require, exports, vscode, ExtraInfoSupport, CommentsSupport, DeclarationSupport, OccurrencesSupport, ReferenceSupport, OutlineSupport, ParameterHintsSupport, RenameSupport, FormattingSupport, BufferSyncSupport, SuggestSupport, Configuration, NavigateTypeSupport, TypeScriptServiceClient) {
    function activate() {
        var MODE_ID_TS = 'typescript';
        var MODE_ID_TSX = 'typescriptreact';
        var MY_PLUGIN_ID = 'vs.language.typescript';
        var clientHost = new TypeScriptServiceClientHost();
        var client = clientHost.serviceClient;
        // Register the supports for both TS and TSX so that we can have separate grammars but share the mode
        registerSupports(MODE_ID_TS, clientHost, client);
        registerSupports(MODE_ID_TSX, clientHost, client);
        // reportLanguageStatus(MODE_ID_TS, client);
    }
    exports.activate = activate;
    function registerSupports(modeID, host, client) {
        vscode.Modes.TokenTypeClassificationSupport.register(modeID, {
            wordDefinition: /(-?\d*\.\d\w*)|([^\`\~\!\@\#\%\^\&\*\(\)\-\=\+\[\{\]\}\\\|\;\:\'\"\,\.\<\>\/\?\s]+)/g
        });
        vscode.Modes.ElectricCharacterSupport.register(modeID, {
            brackets: [
                { tokenType: 'delimiter.curly.ts', open: '{', close: '}', isElectric: true },
                { tokenType: 'delimiter.square.ts', open: '[', close: ']', isElectric: true },
                { tokenType: 'delimiter.paren.ts', open: '(', close: ')', isElectric: true }
            ],
            docComment: { scope: 'comment.documentation', open: '/**', lineStart: ' * ', close: ' */' }
        });
        vscode.Modes.CharacterPairSupport.register(modeID, {
            autoClosingPairs: [
                { open: '{', close: '}' },
                { open: '[', close: ']' },
                { open: '(', close: ')' },
                { open: '"', close: '"', notIn: ['string'] },
                { open: '\'', close: '\'', notIn: ['string', 'comment'] }
            ]
        });
        vscode.Modes.ExtraInfoSupport.register(modeID, new ExtraInfoSupport(client));
        vscode.Modes.CommentsSupport.register(modeID, new CommentsSupport());
        vscode.Modes.DeclarationSupport.register(modeID, new DeclarationSupport(client));
        vscode.Modes.OccurrencesSupport.register(modeID, new OccurrencesSupport(client));
        vscode.Modes.ReferenceSupport.register(modeID, new ReferenceSupport(client));
        vscode.Modes.OutlineSupport.register(modeID, new OutlineSupport(client));
        vscode.Modes.ParameterHintsSupport.register(modeID, new ParameterHintsSupport(client));
        vscode.Modes.RenameSupport.register(modeID, new RenameSupport(client));
        vscode.Modes.FormattingSupport.register(modeID, new FormattingSupport(client));
        vscode.Modes.NavigateTypesSupport.register(modeID, new NavigateTypeSupport(client, modeID));
        vscode.Modes.OnEnterSupport.register(modeID, {
            brackets: [
                { open: '{', close: '}' },
                { open: '[', close: ']' },
                { open: '(', close: ')' },
            ],
            regExpRules: [
                {
                    // e.g. /** | */
                    beforeText: /^\s*\/\*\*(?!\/)([^\*]|\*(?!\/))*$/,
                    afterText: /^\s*\*\/$/,
                    action: { indentAction: vscode.Modes.IndentAction.IndentOutdent, appendText: ' * ' }
                },
                {
                    // e.g. /** ...|
                    beforeText: /^\s*\/\*\*(?!\/)([^\*]|\*(?!\/))*$/,
                    action: { indentAction: vscode.Modes.IndentAction.None, appendText: ' * ' }
                },
                {
                    // e.g.  * ...|
                    beforeText: /^(\t|(\ \ ))*\ \*\ ([^\*]|\*(?!\/))*$/,
                    action: { indentAction: vscode.Modes.IndentAction.None, appendText: '* ' }
                },
                {
                    // e.g.  */|
                    beforeText: /^(\t|(\ \ ))*\ \*\/\s*$/,
                    action: { indentAction: vscode.Modes.IndentAction.None, removeText: 1 }
                }
            ],
            // Source: https://github.com/Microsoft/TypeScript-Sublime-Plugin/blob/master/TypeScript%20Indent.tmPreferences */
            indentationRules: {
                // ^(.*\*/)?\s*\}.*$
                decreaseIndentPattern: /^(.*\*\/)?\s*\}.*$/,
                // ^.*\{[^}"']*$
                increaseIndentPattern: /^.*\{[^}"']*$/
            }
        });
        host.addBufferSyncSupport(new BufferSyncSupport(client, modeID));
        // Register suggest support as soon as possible and load configuration lazily
        // TODO: Eventually support eventing on the configuration service & adopt here
        var suggestSupport = new SuggestSupport(client);
        vscode.Modes.SuggestSupport.register(modeID, suggestSupport);
        Configuration.load(modeID).then(function (config) {
            suggestSupport.setConfiguration(config);
        });
    }
    var TypeScriptServiceClientHost = (function () {
        function TypeScriptServiceClientHost() {
            var _this = this;
            this.bufferSyncSupports = [];
            var handleProjectCreateOrDelete = function () {
                _this.client.execute('reloadProjects', null, false);
                _this.triggerAllDiagnostics();
            };
            var handleProjectChange = function () {
                _this.triggerAllDiagnostics();
            };
            var watcher = vscode.workspace.createFileSystemWatcher('**/tsconfig.json');
            watcher.onDidCreate(handleProjectCreateOrDelete);
            watcher.onDidDelete(handleProjectCreateOrDelete);
            watcher.onDidChange(handleProjectChange);
            this.client = new TypeScriptServiceClient(this);
            this.syntaxDiagnostics = Object.create(null);
            this.currentDiagnostics = Object.create(null);
        }
        Object.defineProperty(TypeScriptServiceClientHost.prototype, "serviceClient", {
            get: function () {
                return this.client;
            },
            enumerable: true,
            configurable: true
        });
        TypeScriptServiceClientHost.prototype.addBufferSyncSupport = function (support) {
            this.bufferSyncSupports.push(support);
        };
        TypeScriptServiceClientHost.prototype.triggerAllDiagnostics = function () {
            this.bufferSyncSupports.forEach(function (support) { return support.requestAllDiagnostics(); });
        };
        /* internal */ TypeScriptServiceClientHost.prototype.syntaxDiagnosticsReceived = function (event) {
            var body = event.body;
            if (body.diagnostics) {
                var markers = this.createMarkerDatas(body.file, body.diagnostics);
                this.syntaxDiagnostics[body.file] = markers;
            }
        };
        /* internal */ TypeScriptServiceClientHost.prototype.semanticDiagnosticsReceived = function (event) {
            var body = event.body;
            if (body.diagnostics) {
                var diagnostics = this.createMarkerDatas(body.file, body.diagnostics);
                var syntaxMarkers = this.syntaxDiagnostics[body.file];
                if (syntaxMarkers) {
                    delete this.syntaxDiagnostics[body.file];
                    diagnostics = syntaxMarkers.concat(diagnostics);
                }
                this.currentDiagnostics[body.file] && this.currentDiagnostics[body.file].dispose();
                this.currentDiagnostics[body.file] = vscode.languages.addDiagnostics(diagnostics);
            }
        };
        TypeScriptServiceClientHost.prototype.createMarkerDatas = function (fileName, diagnostics) {
            var result = [];
            for (var _i = 0; _i < diagnostics.length; _i++) {
                var diagnostic = diagnostics[_i];
                var uri = vscode.Uri.file(fileName);
                var start = diagnostic.start, end = diagnostic.end, text = diagnostic.text;
                var range = new vscode.Range(start.line, start.offset, end.line, end.offset);
                var location = new vscode.Location(uri, range);
                result.push(new vscode.Diagnostic(vscode.DiagnosticSeverity.Error, location, text, 'typescript'));
            }
            return result;
        };
        return TypeScriptServiceClientHost;
    })();
});
//# sourceMappingURL=typescriptMain.js.map