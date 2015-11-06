/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", './luaDef', 'vscode'], function (require, exports, languageDef, vscode_1) {
    function activate(subscriptions) {
        subscriptions.push(vscode_1.Modes.registerMonarchDefinition('lua', languageDef.language));
    }
    exports.activate = activate;
});
//# sourceMappingURL=luaMain.js.map