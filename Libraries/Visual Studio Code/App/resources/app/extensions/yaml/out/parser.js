/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports"], function (require, exports) {
    function keyNameFromKeyToken(keyToken) {
        return keyToken.replace(/\:+$/g, '');
    }
    exports.keyNameFromKeyToken = keyNameFromKeyToken;
    function tokenValue(line, token) {
        return line.substring(token.startIndex, token.endIndex);
    }
    exports.tokenValue = tokenValue;
    function tokensAtColumn(tokens, column) {
        var charIndex = column - 1;
        for (var i = 0, len = tokens.length; i < len; i++) {
            var token = tokens[i];
            if (token.endIndex < charIndex) {
                continue;
            }
            if (token.endIndex === charIndex && i + 1 < len) {
                return [i, i + 1];
            }
            return [i];
        }
        // should not happen: no token found? => return the last one
        return [tokens.length - 1];
    }
    exports.tokensAtColumn = tokensAtColumn;
    (function (TokenType) {
        TokenType[TokenType["Whitespace"] = 0] = "Whitespace";
        TokenType[TokenType["Text"] = 1] = "Text";
        TokenType[TokenType["String"] = 2] = "String";
        TokenType[TokenType["Comment"] = 3] = "Comment";
        TokenType[TokenType["Key"] = 4] = "Key";
    })(exports.TokenType || (exports.TokenType = {}));
    var TokenType = exports.TokenType;
    /**
     * A super simplified parser only looking out for strings and comments
     */
    function parseLine(line) {
        var r = [];
        var lastTokenEndIndex = 0, lastPushedToken = null;
        var emit = function (end, type) {
            if (end <= lastTokenEndIndex) {
                return;
            }
            if (lastPushedToken && lastPushedToken.type === type) {
                // merge with last pushed token
                lastPushedToken.endIndex = end;
                lastTokenEndIndex = end;
                return;
            }
            lastPushedToken = {
                startIndex: lastTokenEndIndex,
                endIndex: end,
                type: type
            };
            r.push(lastPushedToken);
            lastTokenEndIndex = end;
        };
        var inString = false;
        for (var i = 0, len = line.length; i < len; i++) {
            var ch = line.charAt(i);
            if (inString) {
                if (ch === '"' && line.charAt(i - 1) !== '\\') {
                    inString = false;
                    emit(i + 1, TokenType.String);
                }
                continue;
            }
            if (ch === '"') {
                emit(i, TokenType.Text);
                inString = true;
                continue;
            }
            if (ch === '#') {
                // Comment the rest of the line
                emit(i, TokenType.Text);
                emit(line.length, TokenType.Comment);
                break;
            }
            if (ch === ':') {
                emit(i + 1, TokenType.Key);
            }
            if (ch === ' ' || ch === '\t') {
                emit(i, TokenType.Text);
                emit(i + 1, TokenType.Whitespace);
            }
        }
        emit(line.length, TokenType.Text);
        return r;
    }
    exports.parseLine = parseLine;
    // https://docs.docker.com/compose/yml/
    exports.RAW_KEY_INFO = {
        'image': ("Tag or partial image ID. Can be local or remote - Compose will attempt to pull if it doesn't exist locally."),
        'build': ("Path to a directory containing a Dockerfile. When the value supplied is a relative path, it is interpreted as relative to the " +
            "location of the yml file itself. This directory is also the build context that is sent to the Docker daemon.\n\n" +
            "Compose will build and tag it with a generated name, and use that image thereafter."),
        'command': ("Override the default command."),
        'links': ("Link to containers in another service. Either specify both the service name and the link alias (`CONTAINER:ALIAS`), or " +
            "just the service name (which will also be used for the alias)."),
        'external_links': ("Link to containers started outside this `docker-compose.yml` or even outside of Compose, especially for containers that " +
            "provide shared or common services. `external_links` follow " +
            "semantics similar to `links` when specifying both the container name and the link alias (`CONTAINER:ALIAS`)."),
        'ports': ("Expose ports. Either specify both ports (`HOST:CONTAINER`), or just the container port (a random host port will be chosen).\n\n" +
            "*Note*: When mapping ports in the `HOST:CONTAINER` format, you may experience erroneous results when using a container port " +
            "lower than 60, because YAML will parse numbers in the format `xx:yy` as sexagesimal (base 60). For this reason, we recommend " +
            "always explicitly specifying your port mappings as strings."),
        'expose': ("Expose ports without publishing them to the host machine - they'll only be accessible to linked services. \n" +
            "Only the internal port can be specified."),
        'volumes': ("Mount paths as volumes, optionally specifying a path on the host machine (`HOST:CONTAINER`), or an access mode (`HOST:CONTAINER:ro`)."),
        'volumes_from': ("Mount all of the volumes from another service or container."),
        'environment': ("Add environment variables. You can use either an array or a dictionary.\n\n" +
            "Environment variables with only a key are resolved to their values on the machine Compose is running on, which can be helpful for secret or host-specific values."),
        'env_file': ("Add environment variables from a file. Can be a single value or a list.\n\n" +
            "If you have specified a Compose file with `docker-compose -f FILE`, paths in `env_file` are relative to the directory that file is in.\n\n" +
            "Environment variables specified in `environment` override these values."),
        'net': ("Networking mode. Use the same values as the docker client `--net` parameter."),
        'pid': ("Sets the PID mode to the host PID mode. This turns on sharing between container and the host operating system the PID address space. " +
            "Containers launched with this flag will be able to access and manipulate other containers in the bare-metal machine's namespace and vise-versa."),
        'dns': ("Custom DNS servers. Can be a single value or a list."),
        'cap_add': ("Add or drop container capabilities. See `man 7 capabilities` for a full list."),
        'cap_drop': ("Add or drop container capabilities. See `man 7 capabilities` for a full list."),
        'dns_search': ("Custom DNS search domains. Can be a single value or a list."),
    };
});
//# sourceMappingURL=parser.js.map