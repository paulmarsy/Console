/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports"], function (require, exports) {
    var CommentsSupport = (function () {
        function CommentsSupport() {
            this.commentsConfiguration = {
                lineCommentTokens: ['//'],
                blockCommentStartToken: '/*',
                blockCommentEndToken: '*/'
            };
        }
        return CommentsSupport;
    })();
    return CommentsSupport;
});
//# sourceMappingURL=commentsSupport.js.map