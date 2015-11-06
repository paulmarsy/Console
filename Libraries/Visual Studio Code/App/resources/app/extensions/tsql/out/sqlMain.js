/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", './sqlDef', 'vscode'], function (require, exports, sqlDef, vscode_1) {
    function activate(subscriptions) {
        subscriptions.push(vscode_1.Modes.registerMonarchDefinition('sql', sqlDef.language));
    }
    exports.activate = activate;
});
//# sourceMappingURL=sqlMain.js.map