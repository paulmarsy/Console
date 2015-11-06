/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
var Handles = (function () {
    function Handles() {
        this.START_HANDLE = 1000;
        this._handleMap = new Map();
        this._nextHandle = this.START_HANDLE;
    }
    Handles.prototype.reset = function () {
        this._nextHandle = this.START_HANDLE;
        this._handleMap = new Map();
    };
    Handles.prototype.create = function (value) {
        var handle = this._nextHandle++;
        this._handleMap[handle] = value;
        return handle;
    };
    Handles.prototype.get = function (handle, dflt) {
        return this._handleMap[handle] || dflt;
    };
    return Handles;
})();
exports.Handles = Handles;
//# sourceMappingURL=handles.js.map