/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
define(["require", "exports", './abstractSupport', '../protocol', 'vscode'], function (require, exports, abstractSupport_1, Protocol, vscode_1) {
    var BufferSyncSupport = (function (_super) {
        __extends(BufferSyncSupport, _super);
        function BufferSyncSupport(server) {
            _super.call(this, server);
            this._disposables = [];
            this._syncedDocuments = Object.create(null);
            vscode_1.workspace.getTextDocuments().forEach(this._onDidAddDocument, this);
            vscode_1.workspace.onDidOpenTextDocument(this._onDidAddDocument, this, this._disposables);
            vscode_1.workspace.onDidCloseTextDocument(this._onDidRemoveDocument, this, this._disposables);
            vscode_1.workspace.onDidChangeTextDocument(this._onDidChangeDocument, this, this._disposables);
        }
        BufferSyncSupport.prototype.dispose = function () {
            vscode_1.Disposable.of.apply(vscode_1.Disposable, this._disposables).dispose();
        };
        BufferSyncSupport.prototype._onDidRemoveDocument = function (document) {
            var key = document.getUri().toString();
            if (!this._syncedDocuments[key]) {
                return;
            }
            this._syncedDocuments[key].dispose();
            delete this._syncedDocuments[key];
        };
        BufferSyncSupport.prototype._onDidAddDocument = function (document) {
            var _this = this;
            if (document.getLanguageId() !== 'csharp' || this.isInMemory(document.getUri())) {
                return;
            }
            var key = document.getUri().toString();
            this._syncedDocuments[key] = new SyncedDocument(document, document.getUri().fsPath, function () { return _this.server(); });
        };
        BufferSyncSupport.prototype._onDidChangeDocument = function (e) {
            var key = e.document.getUri().toString();
            if (!this._syncedDocuments[key]) {
                return;
            }
            this._syncedDocuments[key]._onContentChanged(e.contentChanges);
        };
        return BufferSyncSupport;
    })(abstractSupport_1.default);
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.default = BufferSyncSupport;
    var SyncedDocument = (function () {
        function SyncedDocument(model, filename, server) {
            this._document = model;
            this._filename = filename;
            this._server = server;
        }
        SyncedDocument.prototype.dispose = function () {
        };
        SyncedDocument.prototype._onContentChanged = function (events) {
            //		https://github.com/OmniSharp/omnisharp-roslyn/issues/112
            //		this._changeBuffer(events);
            this._updateBuffer();
        };
        // private _changeBuffer(events: Models.IContentChangedEvent[]): void {
        // 	for (var i = 0, len = events.length; i < len; i++) {
        // 		var event = events[i];
        // 		var req: Protocol.ChangeBufferRequest = {
        // 			FileName: this._filename,
        // 			StartLine: event.range.startLineNumber,
        // 			StartColumn: event.range.startColumn,
        // 			EndLine: event.range.endLineNumber,
        // 			EndColumn: event.range.endColumn,
        // 			NewText: event.text
        // 		};
        // 		this._server().makeRequest<boolean>(Protocol.ChangeBuffer, req).then(null, err => {
        //             return this._updateBuffer();
        // 		});
        // 	}
        // }
        SyncedDocument.prototype._updateBuffer = function () {
            if (!this._server().isRunning()) {
                return;
            }
            this._server().makeRequest(Protocol.UpdateBuffer, {
                Buffer: abstractSupport_1.default.buffer(this._document),
                Filename: this._filename
            }).catch(function (err) {
                console.error(err);
                return err;
            });
        };
        return SyncedDocument;
    })();
});
//# sourceMappingURL=bufferSyncSupport.js.map