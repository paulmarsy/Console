/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", 'vscode'], function (require, exports, vscode_1) {
    function activate(subscriptions) {
        subscriptions.push(vscode_1.Modes.CommentsSupport.register('shellscript', {
            commentsConfiguration: {
                lineCommentTokens: ['#']
            }
        }));
    }
    exports.activate = activate;
});
//# sourceMappingURL=shellscriptMain.js.map