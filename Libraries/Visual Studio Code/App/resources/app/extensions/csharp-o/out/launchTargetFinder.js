/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", 'path', 'vscode'], function (require, exports, paths, vscode_1) {
    function getLaunchTargets() {
        return vscode_1.workspace.findFiles('{**/*.sln,**/*.csproj,**/project.json}', '{**/node_modules/**,**/.git/**,**/bower_components/**}', 100).then(function (resources) {
            return select(resources, vscode_1.Uri.file(vscode_1.workspace.getPath()));
        });
    }
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.default = getLaunchTargets;
    function select(resources, root) {
        if (!Array.isArray(resources)) {
            return [];
        }
        var targets = [], hasCsProjFiles = false, hasProjectJson = false, hasProjectJsonAtRoot = false;
        hasCsProjFiles = resources
            .some(function (resource) { return /\.csproj$/.test(resource.fsPath); });
        resources.forEach(function (resource) {
            // sln files
            if (hasCsProjFiles && /\.sln$/.test(resource.fsPath)) {
                targets.push({
                    label: paths.basename(resource.fsPath),
                    description: vscode_1.workspace.getRelativePath(paths.dirname(resource.fsPath)),
                    resource: resource,
                    target: resource,
                    directory: vscode_1.Uri.file(paths.dirname(resource.fsPath))
                });
            }
            // project.json files
            if (/project.json$/.test(resource.fsPath)) {
                var dirname = paths.dirname(resource.fsPath);
                hasProjectJson = true;
                hasProjectJsonAtRoot = hasProjectJsonAtRoot || dirname === root.fsPath;
                targets.push({
                    label: paths.basename(resource.fsPath),
                    description: vscode_1.workspace.getRelativePath(paths.dirname(resource.fsPath)),
                    resource: resource,
                    target: vscode_1.Uri.file(dirname),
                    directory: vscode_1.Uri.file(dirname)
                });
            }
        });
        if (hasProjectJson && !hasProjectJsonAtRoot) {
            targets.push({
                label: paths.basename(root.fsPath),
                description: '',
                resource: root,
                target: root,
                directory: root
            });
        }
        return targets.sort(function (a, b) { return a.directory.fsPath.localeCompare(b.directory.fsPath); });
    }
});
//# sourceMappingURL=launchTargetFinder.js.map