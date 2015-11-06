/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", './rubyDef', 'vscode'], function (require, exports, rubyDef, vscode_1) {
    function activate(subscriptions) {
        subscriptions.push(vscode_1.Modes.registerMonarchDefinition('ruby', rubyDef.language));
        subscriptions.push(vscode_1.Modes.InplaceReplaceSupport.register('ruby', {
            sets: [
                ['true', 'false']
            ]
        }));
    }
    exports.activate = activate;
});
//# sourceMappingURL=rubyMain.js.map