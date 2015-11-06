/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
define(["require", "exports", 'vs/languages/lib/common/wireProtocol', 'vs/base/node/stdFork', 'vscode', 'path'], function (require, exports, WireProtocol, stdFork, vscode, path) {
    var isWin = /^win/.test(process.platform);
    var isDarwin = /^darwin/.test(process.platform);
    var isLinux = /^linux/.test(process.platform);
    var arch = process.arch;
    var TypeScriptServiceClient = (function () {
        function TypeScriptServiceClient(host) {
            this.host = host;
            this.pathSeparator = path.sep;
            this.servicePromise = null;
            this.lastError = null;
            this.sequenceNumber = 0;
            this.requestQueue = [];
            this.pendingResponses = 0;
            this.callbacks = Object.create(null);
            this.startService();
        }
        Object.defineProperty(TypeScriptServiceClient.prototype, "trace", {
            get: function () {
                return TypeScriptServiceClient.Trace;
            },
            enumerable: true,
            configurable: true
        });
        TypeScriptServiceClient.prototype.service = function () {
            if (this.servicePromise) {
                return this.servicePromise;
            }
            if (this.lastError) {
                return Promise.reject(this.lastError);
            }
            this.startService();
            return this.servicePromise;
        };
        TypeScriptServiceClient.prototype.startService = function () {
            var _this = this;
            this.servicePromise = new Promise(function (resolve, reject) {
                vscode.extensions.getConfigurationMemento('typescript').getValue('tsdk').then(function (tsserverConfig) {
                    try {
                        var modulePath = tsserverConfig ? path.join(tsserverConfig, 'tsserver.js') : path.join(__dirname, 'lib', 'tsserver.js');
                        var options = {
                            execArgv: []
                        };
                        var value = process.env.TSS_DEBUG;
                        if (value) {
                            var port = parseInt(value);
                            if (!isNaN(port)) {
                                options.execArgv = [("--debug=" + port)];
                            }
                        }
                        stdFork.fork(modulePath, [], options, function (err, childProcess) {
                            childProcess.on('error', function (err) {
                                _this.lastError = err;
                                _this.serviceExited();
                            });
                            childProcess.on('exit', function (err) {
                                _this.serviceExited();
                            });
                            _this.reader = new WireProtocol.Reader(childProcess.stdout, function (msg) {
                                _this.dispatchMessage(msg);
                            });
                            resolve(childProcess);
                        });
                    }
                    catch (error) {
                        reject(error);
                    }
                });
            });
            this.serviceStarted();
        };
        TypeScriptServiceClient.prototype.serviceStarted = function () {
            /*
            this.mode.getOpenBuffers().forEach((file) => {
                this.execute('open', { file: file }, false);
            });
            */
        };
        TypeScriptServiceClient.prototype.serviceExited = function () {
            var _this = this;
            this.servicePromise = null;
            Object.keys(this.callbacks).forEach(function (key) {
                _this.callbacks[parseInt(key)].e(new Error('Service died.'));
            });
        };
        TypeScriptServiceClient.prototype.asAbsolutePath = function (resource) {
            if (resource.scheme !== 'file') {
                return null;
            }
            var result = resource.fsPath;
            // Both \ and / must be escaped in regular expressions
            return result ? result.replace(new RegExp('\\' + this.pathSeparator, 'g'), '/') : null;
        };
        TypeScriptServiceClient.prototype.asUrl = function (filepath) {
            return vscode.Uri.file(filepath);
        };
        TypeScriptServiceClient.prototype.execute = function (command, args, expectsResultOrToken, token) {
            var _this = this;
            var expectsResult = true;
            if (typeof expectsResultOrToken === 'boolean') {
                expectsResult = expectsResultOrToken;
            }
            else {
                token = expectsResultOrToken;
            }
            var request = {
                seq: this.sequenceNumber++,
                type: 'request',
                command: command,
                arguments: args
            };
            var requestInfo = {
                request: request,
                promise: null,
                callbacks: null
            };
            var result = null;
            if (expectsResult) {
                result = new Promise(function (resolve, reject) {
                    requestInfo.callbacks = { c: resolve, e: reject, start: Date.now() };
                    if (token) {
                        token.onCancellationRequested(function () {
                            _this.tryCancelRequest(request.seq);
                            var err = new Error('Canceled');
                            err.message = 'Canceled';
                            reject(err);
                        });
                    }
                });
            }
            requestInfo.promise = result;
            this.requestQueue.push(requestInfo);
            this.sendNextRequests();
            return result;
        };
        TypeScriptServiceClient.prototype.sendNextRequests = function () {
            while (this.pendingResponses === 0 && this.requestQueue.length > 0) {
                this.sendRequest(this.requestQueue.shift());
            }
        };
        TypeScriptServiceClient.prototype.sendRequest = function (requestItem) {
            var _this = this;
            var serverRequest = requestItem.request;
            if (TypeScriptServiceClient.Trace) {
                console.log('TypeScript Service: sending request ' + serverRequest.command + '(' + serverRequest.seq + '). Response expected: ' + (requestItem.callbacks ? 'yes' : 'no') + '. Current queue length: ' + this.requestQueue.length);
            }
            if (requestItem.callbacks) {
                this.callbacks[serverRequest.seq] = requestItem.callbacks;
                this.pendingResponses++;
            }
            this.service().then(function (childProcess) {
                childProcess.stdin.write(JSON.stringify(serverRequest) + '\r\n', 'utf8');
            }).catch(function (err) {
                var callback = _this.callbacks[serverRequest.seq];
                if (callback) {
                    callback.e(err);
                    delete _this.callbacks[serverRequest.seq];
                    _this.pendingResponses--;
                }
            });
        };
        TypeScriptServiceClient.prototype.tryCancelRequest = function (seq) {
            for (var i = 0; i < this.requestQueue.length; i++) {
                if (this.requestQueue[i].request.seq === seq) {
                    this.requestQueue.splice(i, 1);
                    if (TypeScriptServiceClient.Trace) {
                        console.log('TypeScript Service: canceled request with sequence number ' + seq);
                    }
                    return true;
                }
            }
            if (TypeScriptServiceClient.Trace) {
                console.log('TypeScript Service: tried to cancel request with sequence number ' + seq + '. But request got already delivered.');
            }
            return false;
        };
        TypeScriptServiceClient.prototype.dispatchMessage = function (message) {
            try {
                if (message.type === 'response') {
                    var response = message;
                    var p = this.callbacks[response.request_seq];
                    if (p) {
                        if (TypeScriptServiceClient.Trace) {
                            console.log('TypeScript Service: request ' + response.command + '(' + response.request_seq + ') took ' + (Date.now() - p.start) + 'ms. Success: ' + response.success);
                        }
                        delete this.callbacks[response.request_seq];
                        this.pendingResponses--;
                        if (response.success) {
                            p.c(response);
                        }
                        else {
                            p.e(response);
                        }
                    }
                }
                else if (message.type === 'event') {
                    var event = message;
                    if (event.event === 'syntaxDiag') {
                        this.host.syntaxDiagnosticsReceived(event);
                    }
                    if (event.event === 'semanticDiag') {
                        this.host.semanticDiagnosticsReceived(event);
                    }
                }
                else {
                    throw new Error('Unknown message type ' + message.type + ' recevied');
                }
            }
            finally {
                this.sendNextRequests();
            }
        };
        TypeScriptServiceClient.Trace = false;
        return TypeScriptServiceClient;
    })();
    return TypeScriptServiceClient;
});
//# sourceMappingURL=typescriptServiceClient.js.map