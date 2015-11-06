/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", './dockerfileDef', 'vscode', './extraInfoSupport'], function (require, exports, dockerfileDef, vscode_1, extraInfoSupport_1) {
    function activate(subscriptions) {
        var MODE_ID = 'dockerfile';
        subscriptions.push(vscode_1.Modes.registerMonarchDefinition('dockerfile', dockerfileDef.language));
        if (typeof process !== 'undefined') {
            subscriptions.push(vscode_1.Modes.ExtraInfoSupport.register(MODE_ID, new extraInfoSupport_1.ExtraInfoSupport()));
        }
    }
    exports.activate = activate;
});
//# sourceMappingURL=dockerfileMain.js.map