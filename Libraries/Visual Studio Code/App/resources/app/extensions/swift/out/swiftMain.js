/*---------------------------------------------------------
 * Copyright (C) David Owens II, owensd.io. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", './swiftDef', 'vscode'], function (require, exports, swiftDef, vscode_1) {
    function activate(subscriptions) {
        subscriptions.push(vscode_1.Modes.registerMonarchDefinition('swift', swiftDef.language));
    }
    exports.activate = activate;
});
//# sourceMappingURL=swiftMain.js.map