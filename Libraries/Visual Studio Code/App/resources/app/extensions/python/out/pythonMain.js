/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", './pythonDef', 'vscode'], function (require, exports, pythonDef, vscode_1) {
    function activate(subscriptions) {
        subscriptions.push(vscode_1.Modes.registerMonarchDefinition('python', pythonDef.language));
        subscriptions.push(vscode_1.Modes.InplaceReplaceSupport.register('python', {
            sets: [
                ['true', 'false']
            ]
        }));
    }
    exports.activate = activate;
});
//# sourceMappingURL=pythonMain.js.map