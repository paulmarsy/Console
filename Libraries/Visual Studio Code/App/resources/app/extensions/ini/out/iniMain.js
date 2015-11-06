/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", './iniDef', 'vscode'], function (require, exports, languageDef, vscode_1) {
    function activate(subscriptions) {
        subscriptions.push(vscode_1.Modes.registerMonarchDefinition('ini', languageDef.language));
    }
    exports.activate = activate;
});
//# sourceMappingURL=iniMain.js.map