/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", './goDef', 'vscode'], function (require, exports, languageDef, vscode_1) {
    function activate(subscriptions) {
        subscriptions.push(vscode_1.Modes.registerMonarchDefinition('go', languageDef.language));
    }
    exports.activate = activate;
});
//# sourceMappingURL=goMain.js.map