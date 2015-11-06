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
            this._watcher = vscode_1.workspace.createFileSystemWatcher('**/*.*');
            var d1 = this._watcher.onDidCreate(this._onFileSystemEvent, this);
            var d2 = this._watcher.onDidChange(this._onFileSystemEvent, this);
            var d3 = this._watcher.onDidDelete(this._onFileSystemEvent, this);
            this._disposable = vscode_1.Disposable.of(d1, d2, d3);
        }
        BufferSyncSupport.prototype.dispose = function () {
            this._disposable.dispose();
            this._watcher.dispose();
        };
        BufferSyncSupport.prototype._onFileSystemEvent = function (uri) {
            if (!this.server().isRunning()) {
                return;
            }
            var req = { Filename: uri.fsPath };
            this.server().makeRequest(Protocol.FilesChanged, [req]).catch(function (err) {
                console.warn('[o] failed to forward file change event for ' + uri.fsPath, err);
                return err;
            });
        };
        return BufferSyncSupport;
    })(abstractSupport_1.default);
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.default = BufferSyncSupport;
});
//# sourceMappingURL=fileSyncSupport.js.map