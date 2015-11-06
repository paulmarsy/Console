/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", './csharpDef', 'vscode'], function (require, exports, csharpDef, vscode_1) {
    function activate(subscriptions) {
        subscriptions.push(vscode_1.Modes.registerMonarchDefinition('csharp', csharpDef.language));
    }
    exports.activate = activate;
});
//# sourceMappingURL=csharpMain.js.map