/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", 'vscode', 'vs/base/common/async'], function (require, exports, vscode, async) {
    var SyncedBuffer = (function () {
        function SyncedBuffer(model, filepath, diagnosticRequestor, client) {
            this.document = model;
            this.filepath = filepath;
            this.diagnosticRequestor = diagnosticRequestor;
            this.client = client;
        }
        SyncedBuffer.prototype.open = function () {
            var args = {
                file: this.filepath
            };
            this.client.execute('open', args, false);
        };
        SyncedBuffer.prototype.close = function () {
            var args = {
                file: this.filepath
            };
            this.client.execute('close', args, false);
        };
        SyncedBuffer.prototype.onContentChanged = function (events) {
            var filePath = this.client.asAbsolutePath(this.document.getUri());
            if (!filePath) {
                return;
            }
            for (var i = 0; i < events.length; i++) {
                var event = events[i];
                var range = event.range;
                var text = event.text;
                var args = {
                    file: filePath,
                    line: range.start.line,
                    offset: range.start.character,
                    endLine: range.end.line,
                    endOffset: range.end.character,
                    insertString: text
                };
                this.client.execute('change', args, false);
            }
            this.diagnosticRequestor.requestDiagnostic(filePath);
        };
        return SyncedBuffer;
    })();
    var BufferSyncSupport = (function () {
        function BufferSyncSupport(client, modeId) {
            this.disposables = [];
            this.client = client;
            this.modeId = modeId;
            this.pendingDiagnostics = Object.create(null);
            this.diagnosticDelayer = new async.Delayer(100);
            this.syncedBuffers = Object.create(null);
            vscode.workspace.onDidOpenTextDocument(this.onDidAddDocument, this, this.disposables);
            vscode.workspace.onDidCloseTextDocument(this.onDidRemoveDocument, this, this.disposables);
            vscode.workspace.onDidChangeTextDocument(this.onDidChangeDocument, this, this.disposables);
            vscode.workspace.getTextDocuments().forEach(this.onDidAddDocument, this);
        }
        BufferSyncSupport.prototype.dispose = function () {
            while (this.disposables.length) {
                this.disposables.pop().dispose();
            }
        };
        BufferSyncSupport.prototype.onDidAddDocument = function (document) {
            if (document.getLanguageId() !== this.modeId) {
                return;
            }
            if (document.isUntitled()) {
                return;
            }
            var resource = document.getUri();
            var filepath = this.client.asAbsolutePath(resource);
            if (!filepath) {
                return;
            }
            var syncedBuffer = new SyncedBuffer(document, filepath, this, this.client);
            this.syncedBuffers[filepath] = syncedBuffer;
            syncedBuffer.open();
            this.requestDiagnostic(filepath);
        };
        BufferSyncSupport.prototype.onDidRemoveDocument = function (document) {
            var filepath = this.client.asAbsolutePath(document.getUri());
            if (!filepath) {
                return;
            }
            var syncedBuffer = this.syncedBuffers[filepath];
            if (!syncedBuffer) {
                return;
            }
            delete this.syncedBuffers[filepath];
            syncedBuffer.close();
        };
        BufferSyncSupport.prototype.onDidChangeDocument = function (e) {
            var filepath = this.client.asAbsolutePath(e.document.getUri());
            if (!filepath) {
                return;
            }
            var syncedBuffer = this.syncedBuffers[filepath];
            if (!syncedBuffer) {
                return;
            }
            syncedBuffer.onContentChanged(e.contentChanges);
        };
        BufferSyncSupport.prototype.requestAllDiagnostics = function () {
            var _this = this;
            Object.keys(this.syncedBuffers).forEach(function (filePath) { return _this.pendingDiagnostics[filePath] = Date.now(); });
            this.diagnosticDelayer.trigger(function () {
                _this.sendPendingDiagnostics();
            });
        };
        BufferSyncSupport.prototype.requestDiagnostic = function (file) {
            var _this = this;
            this.pendingDiagnostics[file] = Date.now();
            this.diagnosticDelayer.trigger(function () {
                _this.sendPendingDiagnostics();
            });
        };
        BufferSyncSupport.prototype.sendPendingDiagnostics = function () {
            var _this = this;
            var files = Object.keys(this.pendingDiagnostics).map(function (key) {
                return {
                    file: key,
                    time: _this.pendingDiagnostics[key]
                };
            }).sort(function (a, b) {
                return a.time - b.time;
            }).map(function (value) {
                return value.file;
            });
            // Add all open TS buffers to the geterr request. They might be visible
            Object.keys(this.syncedBuffers).forEach(function (file) {
                if (!_this.pendingDiagnostics[file]) {
                    files.push(file);
                }
            });
            var args = {
                delay: 0,
                files: files
            };
            this.client.execute('geterr', args, false);
            this.pendingDiagnostics = Object.create(null);
        };
        return BufferSyncSupport;
    })();
    return BufferSyncSupport;
});
//# sourceMappingURL=bufferSyncSupport.js.map