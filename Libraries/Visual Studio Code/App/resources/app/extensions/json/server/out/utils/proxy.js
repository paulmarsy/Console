/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
'use strict';
var url_1 = require('url');
var HttpProxyAgent = require('http-proxy-agent');
var HttpsProxyAgent = require('https-proxy-agent');
function getSystemProxyURI(requestURL) {
    if (requestURL.protocol === 'http:') {
        return process.env.HTTP_PROXY || process.env.http_proxy || null;
    }
    else if (requestURL.protocol === 'https:') {
        return process.env.HTTPS_PROXY || process.env.https_proxy || process.env.HTTP_PROXY || process.env.http_proxy || null;
    }
    return null;
}
function getProxyAgent(rawRequestURL, options) {
    if (options === void 0) { options = {}; }
    var requestURL = url_1.parse(rawRequestURL);
    var proxyURL = options.proxyUrl || getSystemProxyURI(requestURL);
    if (!proxyURL) {
        return null;
    }
    var proxyEndpoint = url_1.parse(proxyURL);
    if (!/^https?:$/.test(proxyEndpoint.protocol)) {
        return null;
    }
    var opts = {
        host: proxyEndpoint.hostname,
        port: Number(proxyEndpoint.port),
        auth: proxyEndpoint.auth,
        rejectUnauthorized: (typeof options.strictSSL === 'boolean') ? options.strictSSL : true
    };
    return requestURL.protocol === 'http:' ? new HttpProxyAgent(opts) : new HttpsProxyAgent(opts);
}
exports.getProxyAgent = getProxyAgent;
//# sourceMappingURL=proxy.js.map