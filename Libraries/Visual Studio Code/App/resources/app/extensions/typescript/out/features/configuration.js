/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", 'vscode'], function (require, exports, vscode) {
    exports.defaultConfiguration = {
        useCodeSnippetsOnMethodSuggest: false
    };
    function load(myPluginId) {
        var configuration = vscode.extensions.getConfigurationMemento(myPluginId);
        return configuration.getValues(exports.defaultConfiguration);
    }
    exports.load = load;
});
//# sourceMappingURL=configuration.js.map