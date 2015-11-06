/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", './rDef', 'vscode'], function (require, exports, rDef, vscode_1) {
    function activate(subscriptions) {
        subscriptions.push(vscode_1.Modes.registerMonarchDefinition('r', rDef.language));
    }
    exports.activate = activate;
});
//# sourceMappingURL=rMain.js.map