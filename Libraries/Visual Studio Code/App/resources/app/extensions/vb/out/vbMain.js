/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", './vbDef', 'vscode'], function (require, exports, languageDef, vscode_1) {
    function activate(subscriptions) {
        subscriptions.push(vscode_1.Modes.registerMonarchDefinition('vb', languageDef.language));
        subscriptions.push(vscode_1.Modes.InplaceReplaceSupport.register('vb', {
            sets: [
                ['Private', 'Public', 'Friend', 'ReadOnly', 'Partial', 'Protected', 'WriteOnly'],
                ['True', 'False']
            ]
        }));
    }
    exports.activate = activate;
});
//# sourceMappingURL=vbMain.js.map