/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", 'vscode', './extraInfoSupport', './suggestSupport'], function (require, exports, vscode_1, _extraInfoSupport, _suggestSupport) {
    function activate(subscriptions) {
        var MODE_ID = 'yaml';
        subscriptions.push(vscode_1.Modes.ExtraInfoSupport.register(MODE_ID, new _extraInfoSupport.ExtraInfoSupport()));
        subscriptions.push(vscode_1.Modes.SuggestSupport.register(MODE_ID, new _suggestSupport.SuggestSupport()));
        subscriptions.push(vscode_1.Modes.CommentsSupport.register(MODE_ID, {
            commentsConfiguration: {
                lineCommentTokens: ['#']
            }
        }));
    }
    exports.activate = activate;
});
//# sourceMappingURL=yamlMain.js.map