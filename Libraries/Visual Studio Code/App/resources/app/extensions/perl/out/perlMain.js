/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", 'vscode'], function (require, exports, vscode_1) {
    function activate(subscriptions) {
        var commentsSupport = {
            commentsConfiguration: {
                lineCommentTokens: ['#']
            }
        };
        subscriptions.push(vscode_1.Modes.CommentsSupport.register('perl', commentsSupport));
        subscriptions.push(vscode_1.Modes.CommentsSupport.register('perl6', commentsSupport));
    }
    exports.activate = activate;
});
//# sourceMappingURL=perlMain.js.map