/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", 'vscode'], function (require, exports, vscode_1) {
    var ExtraInfoSupport = (function () {
        function ExtraInfoSupport() {
        }
        ExtraInfoSupport.prototype.computeInfo = function (document, position) {
            var lineEndColumn = document.getLineMaxColumn(position.line);
            var line = document.getTextInRange(new vscode_1.Range(position.line, 1, position.line, lineEndColumn));
            if (line.length === 0) {
                return Promise.resolve(null);
            }
            var token = this._scanForInstruction(line);
            if (token === null) {
                return Promise.resolve(null);
            }
            var info = INSTRUCTION_INFO[token.instruction];
            if (!info) {
                return Promise.resolve(null);
            }
            var result = {
                range: new vscode_1.Range(position.line, token.startIndex, position.line, lineEndColumn),
                htmlContent: simpleMarkDownToHTMLContent(info)
            };
            return Promise.resolve(result);
        };
        ExtraInfoSupport.prototype._scanForInstruction = function (line) {
            for (var i = 0, len = line.length; i < len; i++) {
                var ch = line.charAt(i);
                if (!(ch === ' ' || ch === '\t')) {
                    break;
                }
            }
            if (i === line.length) {
                return null;
            }
            if (line.charAt(i) === '#') {
                return null;
            }
            var startIndex = i;
            for (var j = i, len = line.length; j < len; j++) {
                var ch = line.charAt(j);
                if (ch === ' ' || ch === '\t') {
                    break;
                }
            }
            var endIndex = j - 1;
            var firstWord = line.substr(startIndex, endIndex + 1 - i);
            return {
                startIndex: startIndex,
                endIndex: endIndex,
                instruction: firstWord,
            };
        };
        return ExtraInfoSupport;
    })();
    exports.ExtraInfoSupport = ExtraInfoSupport;
    // Copied from yaml
    var TagType;
    (function (TagType) {
        TagType[TagType["pre"] = 0] = "pre";
        TagType[TagType["bold"] = 1] = "bold";
        TagType[TagType["normal"] = 2] = "normal";
    })(TagType || (TagType = {}));
    function simpleMarkDownToHTMLContent(source) {
        var r = [];
        var lastPushedTo;
        var push = function (to, type) {
            if (lastPushedTo >= to) {
                return;
            }
            var text = source.substring(lastPushedTo, to);
            if (type === TagType.pre) {
                r.push({
                    tagName: "span",
                    style: "font-family:monospace",
                    className: "token keyword",
                    text: text
                });
            }
            else if (type === TagType.bold) {
                r.push({
                    tagName: "strong",
                    text: text
                });
            }
            else if (type === TagType.normal) {
                r.push({
                    tagName: "span",
                    text: text
                });
            }
            lastPushedTo = to;
        };
        var currentTagType = function () {
            if (inPre) {
                return TagType.pre;
            }
            if (inBold) {
                return TagType.bold;
            }
            return TagType.normal;
        };
        var inPre = false, inBold = false;
        for (var i = 0, len = source.length; i < len; i++) {
            var ch = source.charAt(i);
            if (ch === '\n') {
                push(i, currentTagType());
                r.push({
                    tagName: 'br'
                });
                lastPushedTo = i + 1;
            }
            else if (ch === '`') {
                push(i, currentTagType());
                lastPushedTo = i + 1;
                inPre = !inPre;
            }
            else if (ch === '*') {
                push(i, currentTagType());
                lastPushedTo = i + 1;
                inBold = !inBold;
            }
        }
        push(source.length, currentTagType());
        return r;
    }
    // https://docs.docker.com/reference/builder/
    var INSTRUCTION_INFO = {
        'FROM': ("Sets the *Base Image* for subsequent instructions."),
        'MAINTAINER': ("Set the *Author* field of the generated images."),
        'RUN': ("Executes any commands in a new layer on top of the current image and commits the results."),
        'CMD': ("Provides defaults for an executing container."),
        'LABEL': ("Adds metadata to an image. A *LABEL* is a key-value pair."),
        'EXPOSE': ("Informs Docker that the container will listen on the specified network ports at runtime."),
        'ENV': ("Sets the environment variable `key` to the value `value`."),
        'ADD': ("The *ADD* instruction copies new files, directories or remote file URLs from `src` and adds them " +
            "to the filesystem of the container at the path `dest`."),
        'COPY': ("Copies new files or directories from `src` and adds them to the filesystem of the container at the path `dest`."),
        'ENTRYPOINT': ("Configures a container that will run as an executable."),
        'VOLUME': ("Creates a mount point with the specified name and marks it as holding externally mounted volumes " +
            "from native host or other containers."),
        'USER': ("Sets the user name or UID to use when running the image and for any `RUN`, `CMD` and `ENTRYPOINT` " +
            "instructions that follow it in the Dockerfile."),
        'WORKDIR': ("Sets the working directory for any `RUN`, `CMD`, `ENTRYPOINT`, `COPY` and `ADD` instructions that follow it in the Dockerfile."),
        'ONBUILD': ("Adds to the image a trigger instruction to be executed at a later time, when the image is used as the " +
            "base for another build.")
    };
});
//# sourceMappingURL=extraInfoSupport.js.map