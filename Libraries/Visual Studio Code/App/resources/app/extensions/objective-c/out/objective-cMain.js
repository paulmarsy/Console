/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", './objective-cDef', 'vscode'], function (require, exports, objectiveCDef, vscode_1) {
    function activate(subscriptions) {
        subscriptions.push(vscode_1.Modes.registerMonarchDefinition('objective-c', objectiveCDef.language));
    }
    exports.activate = activate;
});
//# sourceMappingURL=objective-cMain.js.map