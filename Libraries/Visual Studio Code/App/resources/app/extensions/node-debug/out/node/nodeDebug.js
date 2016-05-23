/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
"use strict";
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var vscode_debugadapter_1 = require('vscode-debugadapter');
var nodeV8Protocol_1 = require('./nodeV8Protocol');
var sourceMaps_1 = require('./sourceMaps');
var terminal_1 = require('./terminal');
var PathUtils = require('./pathUtilities');
var CP = require('child_process');
var Net = require('net');
var Path = require('path');
var FS = require('fs');
var nls = require('vscode-nls');
var localize = nls.config(process.env.VSCODE_NLS_CONFIG)(__filename);
var Expander = (function () {
    function Expander(func) {
        this._expanderFunction = func;
    }
    Expander.prototype.Expand = function (session) {
        return this._expanderFunction();
    };
    return Expander;
}());
exports.Expander = Expander;
var PropertyExpander = (function () {
    function PropertyExpander(obj, ths) {
        this._object = obj;
        this._this = ths;
    }
    PropertyExpander.prototype.Expand = function (session) {
        var _this = this;
        return session._createProperties(this._object, 'all').then(function (variables) {
            if (_this._this) {
                return session._createVariable('this', _this._this).then(function (variable) {
                    variables.push(variable);
                    return variables;
                });
            }
            else {
                return variables;
            }
        });
    };
    return PropertyExpander;
}());
exports.PropertyExpander = PropertyExpander;
/**
 * A SourceSource represents the source contents of an internal module or of a source map with inlined contents.
 */
var SourceSource = (function () {
    function SourceSource(sid, content) {
        this.scriptId = sid;
        this.source = content;
    }
    return SourceSource;
}());
var NodeDebugSession = (function (_super) {
    __extends(NodeDebugSession, _super);
    function NodeDebugSession() {
        var _this = this;
        _super.call(this);
        this._traceAll = false;
        // options
        this._tryToInjectExtension = true;
        this._largeArrays = false; // experimental
        this._chunkSize = 100; // chunk size for large data structures
        this._smartStep = false; // try to automatically step over uninteresting source
        this._nodeProcessId = -1; // pid of the node runtime
        this._functionBreakpoints = new Array(); // node function breakpoint ids
        // session configurations
        this._noDebug = false;
        this._attachMode = false;
        this._restartMode = false;
        // state valid between stop events
        this._variableHandles = new vscode_debugadapter_1.Handles();
        this._frameHandles = new vscode_debugadapter_1.Handles();
        this._sourceHandles = new vscode_debugadapter_1.Handles();
        this._refCache = new Map();
        this._pollForNodeProcess = false;
        this._nodeInjectionAvailable = false;
        this._nodeInjection2Available = false;
        this._smartStepCount = 0;
        // this debugger uses zero-based lines and columns which is the default
        // so the following two calls are not really necessary.
        this.setDebuggerLinesStartAt1(false);
        this.setDebuggerColumnsStartAt1(false);
        this._node = new nodeV8Protocol_1.NodeV8Protocol();
        this._node.on('break', function (event) {
            _this._stopped('break');
            _this._handleNodeBreakEvent(event.body);
        });
        this._node.on('exception', function (event) {
            _this._stopped('exception');
            _this._handleNodeBreakEvent(event.body);
        });
        /*
        this._node.on('beforeCompile', (event: NodeV8Event) => {
            this.outLine(`beforeCompile ${event.body.name}`);
        });
        */
        this._node.on('afterCompile', function (event) {
            _this._handleNodeAfterCompileEvent(event.body);
        });
        this._node.on('close', function (event) {
            _this._terminated('node v8protocol close');
        });
        this._node.on('error', function (event) {
            _this._terminated('node v8protocol error');
        });
        /*
        this._node.on('diagnostic', (event: NodeV8Event) => {
            this.outLine(`diagnostic event ${event.body.reason}`);
        });
        */
    }
    /**
     * Experimental support for SystemJS module loader (https://github.com/systemjs/systemjs)
     *
     * Tries to figure out whether JavaScript code has been dynamically generated
     * and whether it contains a source map reference.
     * If this is the case try to reload breakpoints.
     */
    NodeDebugSession.prototype._handleNodeAfterCompileEvent = function (eventBody) {
        var _this = this;
        if (this._sourceMaps) {
            var path_1 = eventBody.script.name;
            if (path_1 && Path.extname(path_1) === '.js!transpiled' && path_1.indexOf('file://') === 0) {
                path_1 = path_1.substring('file://'.length);
                if (!FS.existsSync(path_1)) {
                    var script_id = eventBody.script.id;
                    this._loadScript(script_id).then(function (content) {
                        var sources = _this._sourceMaps.MapPathToSource(path_1, content);
                        if (sources && sources.length >= 0) {
                            _this.outLine("afterCompile: " + path_1 + " maps to " + sources[0]);
                            // trigger resending breakpoints
                            _this.sendEvent(new vscode_debugadapter_1.InitializedEvent());
                        }
                    }).catch(function (err) {
                        // ignore
                    });
                }
            }
        }
    };
    /**
     * Analyse why node has stopped and sends StoppedEvent if necessary.
     */
    NodeDebugSession.prototype._handleNodeBreakEvent = function (eventBody) {
        /*
        // workaround: load sourcemap for this location to populate cache
        if (this._sourceMaps) {
            let path = body.script.name;
            if (path && PathUtils.isAbsolutePath(path)) {
                path = this._remoteToLocal(path);
                this._sourceMaps.MapToSource(path, null, 0, 0);
            }
        }
        */
        var isEntry = false;
        var reason;
        var exception_text;
        // is exception?
        if (eventBody.exception) {
            this._exception = eventBody.exception;
            exception_text = eventBody.exception.text;
            reason = localize(0, null);
        }
        // is breakpoint?
        if (!reason) {
            var breakpoints = eventBody.breakpoints;
            if (isArray(breakpoints) && breakpoints.length > 0) {
                var id = breakpoints[0];
                if (!this._gotEntryEvent && id === 1) {
                    isEntry = true;
                    this.log('la', '_analyzeBreak: suppressed stop-on-entry event');
                    reason = localize(1, null);
                    this._rememberEntryLocation(eventBody.script.name, eventBody.sourceLine, eventBody.sourceColumn);
                }
                else {
                    reason = localize(2, null);
                }
            }
        }
        // is debugger statement?
        if (!reason) {
            var sourceLine = eventBody.sourceLineText;
            if (sourceLine && sourceLine.indexOf('debugger') >= 0) {
                reason = localize(3, null);
            }
        }
        // no reason yet: must be the result of a 'step'
        if (!reason) {
            // should we continue until we find a better place to stop?
            if (this._smartStep && this._skipGenerated(eventBody)) {
                this._node.command('continue', { stepaction: 'in' });
                this._smartStepCount++;
                return null;
            }
            reason = localize(4, null);
        }
        this._lastStoppedEvent = new vscode_debugadapter_1.StoppedEvent(reason, NodeDebugSession.DUMMY_THREAD_ID, exception_text);
        if (!isEntry) {
            if (this._smartStepCount > 0) {
                this.log('ss', "_handleNodeBreakEvent: " + this._smartStepCount + " steps skipped");
                this._smartStepCount = 0;
            }
            this.sendEvent(this._lastStoppedEvent);
        }
    };
    /**
     * Returns true if a source location should be skipped.
     */
    NodeDebugSession.prototype._skipGenerated = function (event) {
        if (!this._sourceMaps) {
            // proceed as normal
            return false;
        }
        var line = event.sourceLine;
        var column = this._adjustColumn(line, event.sourceColumn);
        var remotePath = event.script.name;
        if (remotePath && PathUtils.isAbsolutePath(remotePath)) {
            // if launch.json defines localRoot and remoteRoot try to convert remote path back to a local path
            var localPath = this._remoteToLocal(remotePath);
            // try to map
            var mapresult = this._sourceMaps.MapToSource(localPath, null, line, column, sourceMaps_1.Bias.LEAST_UPPER_BOUND);
            if (!mapresult) {
                mapresult = this._sourceMaps.MapToSource(localPath, null, line, column, sourceMaps_1.Bias.GREATEST_LOWER_BOUND);
            }
            if (mapresult) {
                return false;
            }
        }
        // skip everything
        return true;
    };
    /**
     * clear everything that is no longer valid after a new stopped event.
     */
    NodeDebugSession.prototype._stopped = function (reason) {
        this.log('la', "_stopped: got " + reason + " event from node");
        this._exception = undefined;
        this._variableHandles.reset();
        this._frameHandles.reset();
        this._refCache = new Map();
    };
    /**
     * The debug session has terminated.
     */
    NodeDebugSession.prototype._terminated = function (reason) {
        this.log('la', "_terminated: " + reason);
        if (this._terminalProcess) {
            // if the debug adapter owns a terminal,
            // we delay the TerminatedEvent so that the user can see the result of the process in the terminal.
            return;
        }
        if (!this._isTerminated) {
            this._isTerminated = true;
            if (this._restartMode && !this._inShutdown) {
                this.sendEvent(new vscode_debugadapter_1.TerminatedEvent(true));
            }
            else {
                this.sendEvent(new vscode_debugadapter_1.TerminatedEvent());
            }
        }
    };
    //---- initialize request -------------------------------------------------------------------------------------------------
    NodeDebugSession.prototype.initializeRequest = function (response, args) {
        this.log('la', "initializeRequest: adapterID: " + args.adapterID);
        this._adapterID = args.adapterID;
        //---- Send back feature and their options
        // This debug adapter supports the configurationDoneRequest.
        response.body.supportsConfigurationDoneRequest = true;
        // This debug adapter supports function breakpoints.
        response.body.supportsFunctionBreakpoints = true;
        // This debug adapter supports conditional breakpoints.
        response.body.supportsConditionalBreakpoints = true;
        // This debug adapter does not support a side effect free evaluate request for data hovers.
        response.body.supportsEvaluateForHovers = false;
        // This debug adapter supports two exception breakpoint filters
        response.body.exceptionBreakpointFilters = [
            {
                label: localize(5, null),
                filter: 'all',
                default: false
            },
            {
                label: localize(6, null),
                filter: 'uncaught',
                default: true
            }
        ];
        this.sendResponse(response);
    };
    //---- launch request -----------------------------------------------------------------------------------------------------
    NodeDebugSession.prototype.launchRequest = function (response, args) {
        var _this = this;
        if (this._processCommonArgs(response, args)) {
            return;
        }
        this._noDebug = (typeof args.noDebug === 'boolean') && args.noDebug;
        this._externalConsole = (typeof args.externalConsole === 'boolean') && args.externalConsole;
        var port = args.port || random(3000, 50000);
        var address = args.address;
        var timeout = args.timeout;
        var runtimeExecutable = args.runtimeExecutable;
        if (runtimeExecutable) {
            if (!Path.isAbsolute(runtimeExecutable)) {
                this.sendRelativePathErrorResponse(response, 'runtimeExecutable', runtimeExecutable);
                return;
            }
            if (!FS.existsSync(runtimeExecutable)) {
                this.sendNotExistErrorResponse(response, 'runtimeExecutable', runtimeExecutable);
                return;
            }
        }
        else {
            if (!terminal_1.Terminal.isOnPath(NodeDebugSession.NODE)) {
                this.sendErrorResponse(response, 2001, localize(7, null, '{_runtime}'), { _runtime: NodeDebugSession.NODE });
                return;
            }
            runtimeExecutable = NodeDebugSession.NODE; // use node from PATH
        }
        var runtimeArgs = args.runtimeArgs || [];
        var programArgs = args.args || [];
        // special code for 'extensionHost' debugging
        if (this._adapterID === 'extensionHost') {
            // we always launch in 'debug-brk' mode, but we only show the break event if 'stopOnEntry' attribute is true.
            var launchArgs_1 = [runtimeExecutable];
            if (!this._noDebug) {
                launchArgs_1.push("--debugBrkPluginHost=" + port);
            }
            launchArgs_1 = launchArgs_1.concat(runtimeArgs, programArgs);
            this._sendLaunchCommandToConsole(launchArgs_1);
            var cmd = CP.spawn(runtimeExecutable, launchArgs_1.slice(1));
            cmd.on('error', function (err) {
                _this._terminated("failed to launch extensionHost (" + err + ")");
            });
            this._captureOutput(cmd);
            // we are done!
            this.sendResponse(response);
            return;
        }
        var programPath = args.program;
        if (programPath) {
            if (!Path.isAbsolute(programPath)) {
                this.sendRelativePathErrorResponse(response, 'program', programPath);
                return;
            }
            if (!FS.existsSync(programPath)) {
                this.sendNotExistErrorResponse(response, 'program', programPath);
                return;
            }
            programPath = Path.normalize(programPath);
            if (PathUtils.normalizeDriveLetter(programPath) !== PathUtils.realPath(programPath)) {
                this.outLine(localize(8, null));
            }
        }
        else {
            this.sendAttributeMissingErrorResponse(response, 'program');
            return;
        }
        if (NodeDebugSession.isJavaScript(programPath)) {
            if (this._sourceMaps) {
                // if programPath is a JavaScript file and sourceMaps are enabled, we don't know whether
                // programPath is the generated file or whether it is the source (and we need source mapping).
                // Typically this happens if a tool like 'babel' or 'uglify' is used (because they both transpile js to js).
                // We use the source maps to find a 'source' file for the given js file.
                var generatedPath = this._sourceMaps.MapPathFromSource(programPath);
                if (generatedPath && generatedPath !== programPath) {
                    // programPath must be source because there seems to be a generated file for it
                    this.log('sm', "launchRequest: program '" + programPath + "' seems to be the source; launch the generated file '" + generatedPath + "' instead");
                    programPath = generatedPath;
                }
                else {
                    this.log('sm', "launchRequest: program '" + programPath + "' seems to be the generated file");
                }
            }
        }
        else {
            // node cannot execute the program directly
            if (!this._sourceMaps) {
                this.sendErrorResponse(response, 2002, localize(9, null, '{path}'), { path: programPath });
                return;
            }
            var generatedPath = this._sourceMaps.MapPathFromSource(programPath);
            if (!generatedPath) {
                this.sendErrorResponse(response, 2003, localize(10, null, '{path}', 'outDir'), { path: programPath });
                return;
            }
            this.log('sm', "launchRequest: program '" + programPath + "' seems to be the source; launch the generated file '" + generatedPath + "' instead");
            programPath = generatedPath;
        }
        var program;
        var workingDirectory = args.cwd;
        if (workingDirectory) {
            if (!Path.isAbsolute(workingDirectory)) {
                this.sendRelativePathErrorResponse(response, 'cwd', workingDirectory);
                return;
            }
            if (!FS.existsSync(workingDirectory)) {
                this.sendNotExistErrorResponse(response, 'cwd', workingDirectory);
                return;
            }
            // if working dir is given and if the executable is within that folder, we make the executable path relative to the working dir
            program = Path.relative(workingDirectory, programPath);
        }
        else {
            // if no working dir given, we use the direct folder of the executable
            workingDirectory = Path.dirname(programPath);
            program = Path.basename(programPath);
        }
        // we always break on entry (but if user did not request this, we will not stop in the UI).
        var launchArgs = [runtimeExecutable];
        if (!this._noDebug) {
            launchArgs.push("--debug-brk=" + port);
        }
        launchArgs = launchArgs.concat(runtimeArgs, [program], programArgs);
        if (this._externalConsole) {
            terminal_1.Terminal.launchInTerminal(workingDirectory, launchArgs, args.env).then(function (term) {
                if (term) {
                    // if we got a terminal process, we will track it
                    _this._terminalProcess = term;
                    term.on('exit', function () {
                        _this._terminalProcess = null;
                        _this._terminated('terminal exited');
                    });
                }
                // since node starts in a terminal, we cannot track it with an 'exit' handler
                // plan for polling after we have gotten the process pid.
                _this._pollForNodeProcess = true;
                if (_this._noDebug) {
                    _this.sendResponse(response);
                }
                else {
                    _this._attach(response, port, address, timeout);
                }
            }).catch(function (error) {
                _this.sendErrorResponseWithInfoLink(response, 2011, localize(11, null, '{_error}'), { _error: error.message }, error.linkId);
                _this._terminated('terminal error: ' + error.message);
            });
        }
        else {
            this._sendLaunchCommandToConsole(launchArgs);
            // merge environment variables into a copy of the process.env
            var env = extendObject(extendObject({}, process.env), args.env);
            var options = {
                cwd: workingDirectory,
                env: env
            };
            var nodeProcess = CP.spawn(runtimeExecutable, launchArgs.slice(1), options);
            nodeProcess.on('error', function (error) {
                _this.sendErrorResponse(response, 2017, localize(12, null, '{_error}'), { _error: error.message }, vscode_debugadapter_1.ErrorDestination.Telemetry | vscode_debugadapter_1.ErrorDestination.User);
                _this._terminated("failed to launch target (" + error + ")");
            });
            nodeProcess.on('exit', function () {
                _this._terminated('target exited');
            });
            nodeProcess.on('close', function (code) {
                _this._terminated('target closed');
            });
            this._nodeProcessId = nodeProcess.pid;
            this._captureOutput(nodeProcess);
            if (this._noDebug) {
                this.sendResponse(response);
            }
            else {
                this._attach(response, port, address, timeout);
            }
        }
    };
    NodeDebugSession.prototype._sendLaunchCommandToConsole = function (args) {
        // print the command to launch the target to the debug console
        var cli = '';
        for (var _i = 0, args_1 = args; _i < args_1.length; _i++) {
            var a = args_1[_i];
            if (a.indexOf(' ') >= 0) {
                cli += '\'' + a + '\'';
            }
            else {
                cli += a;
            }
            cli += ' ';
        }
        this.outLine(cli);
    };
    NodeDebugSession.prototype._captureOutput = function (process) {
        var _this = this;
        process.stdout.on('data', function (data) {
            _this.sendEvent(new vscode_debugadapter_1.OutputEvent(data.toString(), 'stdout'));
        });
        process.stderr.on('data', function (data) {
            _this.sendEvent(new vscode_debugadapter_1.OutputEvent(data.toString(), 'stderr'));
        });
    };
    /**
     * returns true on error.
     */
    NodeDebugSession.prototype._processCommonArgs = function (response, args) {
        if (typeof args.trace === 'string') {
            this._trace = args.trace.split(',');
            this._traceAll = this._trace.indexOf('all') >= 0;
        }
        this._smartStep = (typeof args.smartStep === 'boolean') && args.smartStep;
        this._stopOnEntry = (typeof args.stopOnEntry === 'boolean') && args.stopOnEntry;
        if (!this._sourceMaps) {
            if (typeof args.sourceMaps === 'boolean' && args.sourceMaps) {
                var generatedCodeDirectory = args.outDir;
                if (generatedCodeDirectory) {
                    if (!Path.isAbsolute(generatedCodeDirectory)) {
                        this.sendRelativePathErrorResponse(response, 'outDir', generatedCodeDirectory);
                        return true;
                    }
                    if (!FS.existsSync(generatedCodeDirectory)) {
                        this.sendNotExistErrorResponse(response, 'outDir', generatedCodeDirectory);
                        return true;
                    }
                }
                this._sourceMaps = new sourceMaps_1.SourceMaps(this, generatedCodeDirectory);
            }
        }
        return false;
    };
    //---- attach request -----------------------------------------------------------------------------------------------------
    NodeDebugSession.prototype.attachRequest = function (response, args) {
        if (this._processCommonArgs(response, args)) {
            return;
        }
        if (this._adapterID === 'extensionHost') {
            // in EH mode 'attach' means 'launch' mode
            this._attachMode = false;
        }
        else {
            this._attachMode = true;
        }
        if (typeof args.restart === 'boolean') {
            this._restartMode = args.restart;
        }
        if (args.localRoot) {
            var localRoot = args.localRoot;
            if (!Path.isAbsolute(localRoot)) {
                this.sendRelativePathErrorResponse(response, 'localRoot', localRoot);
                return;
            }
            if (!FS.existsSync(localRoot)) {
                this.sendNotExistErrorResponse(response, 'localRoot', localRoot);
                return;
            }
            this._localRoot = localRoot;
        }
        this._remoteRoot = args.remoteRoot;
        this._attach(response, args.port, args.address, args.timeout);
    };
    /*
     * shared code used in launchRequest and attachRequest
     */
    NodeDebugSession.prototype._attach = function (response, port, address, timeout) {
        var _this = this;
        if (!port) {
            port = 5858;
        }
        if (!address || address === 'localhost') {
            address = '127.0.0.1';
        }
        if (!timeout) {
            timeout = NodeDebugSession.ATTACH_TIMEOUT;
        }
        this.log('la', "_attach: address: " + address + " port: " + port);
        var connected = false;
        var socket = new Net.Socket();
        socket.connect(port, address);
        socket.on('connect', function (err) {
            _this.log('la', '_attach: connected');
            connected = true;
            _this._node.startDispatch(socket, socket);
            _this._initialize(response);
        });
        var endTime = new Date().getTime() + timeout;
        socket.on('error', function (err) {
            if (connected) {
                // since we are connected this error is fatal
                _this._terminated('socket error');
            }
            else {
                // we are not yet connected so retry a few times
                if (err.code === 'ECONNREFUSED' || err.code === 'ECONNRESET') {
                    var now = new Date().getTime();
                    if (now < endTime) {
                        setTimeout(function () {
                            _this.log('la', '_attach: retry socket.connect');
                            socket.connect(port);
                        }, 200); // retry after 200 ms
                    }
                    else {
                        _this.sendErrorResponse(response, 2009, localize(13, null, '{_timeout}'), { _timeout: timeout });
                    }
                }
                else {
                    _this.sendErrorResponse(response, 2010, localize(14, null, '{_error}'), { _error: err.message });
                }
            }
        });
        socket.on('end', function (err) {
            _this._terminated('socket end');
        });
    };
    NodeDebugSession.prototype._initialize = function (response, retryCount) {
        var _this = this;
        if (retryCount === void 0) { retryCount = 0; }
        this._node.command('evaluate', { expression: 'process.pid', global: true }, function (resp) {
            var ok = resp.success;
            if (resp.success) {
                _this._nodeProcessId = parseInt(resp.body.value);
                _this.log('la', "_initialize: got process id " + _this._nodeProcessId + " from node");
            }
            else {
                if (resp.message.indexOf('process is not defined') >= 0) {
                    _this.log('la', '_initialize: process not defined error; got no pid');
                    ok = true; // continue and try to get process.pid later
                }
            }
            if (ok) {
                if (_this._pollForNodeProcess) {
                    _this._pollForNodeTermination();
                }
                _this._injectDebuggerExtensions(function (_) {
                    _this.sendResponse(response);
                    _this._startInitialize(!resp.running);
                });
            }
            else {
                _this.log('la', '_initialize: retrieving process id from node failed');
                if (retryCount < 10) {
                    setTimeout(function () {
                        // recurse
                        _this._initialize(response, retryCount + 1);
                    }, 50);
                    return;
                }
                else {
                    _this._sendNodeResponse(response, resp);
                }
            }
        });
    };
    NodeDebugSession.prototype._pollForNodeTermination = function () {
        var _this = this;
        var id = setInterval(function () {
            try {
                if (_this._nodeProcessId > 0) {
                    process.kill(_this._nodeProcessId, 0); // node.d.ts doesn't like number argumnent
                }
                else {
                    clearInterval(id);
                }
            }
            catch (e) {
                clearInterval(id);
                _this._terminated('node process kill exception');
            }
        }, NodeDebugSession.NODE_TERMINATION_POLL_INTERVAL);
    };
    /*
     * Inject code into node.js to address slowness issues when inspecting large data structures.
     */
    NodeDebugSession.prototype._injectDebuggerExtensions = function (done) {
        var _this = this;
        if (this._tryToInjectExtension) {
            var v = this._node.embeddedHostVersion; // x.y.z version represented as (x*100+y)*100+z
            if ((v >= 1200 && v < 10000) || (v >= 40301 && v < 50000) || (v >= 50600)) {
                try {
                    var use_version_2_1 = v >= 50000;
                    var code = use_version_2_1 ? NodeDebugSession.DEBUG_INJECTION2 : NodeDebugSession.DEBUG_INJECTION;
                    var contents = FS.readFileSync(Path.join(__dirname, code), 'utf8');
                    var args_2 = {
                        expression: contents,
                        disable_break: true
                    };
                    this._repeater(4, done, function (callback) {
                        _this._node.command2('evaluate', args_2).then(function (resp) {
                            _this.log('la', '_injectDebuggerExtensions: code inject: OK');
                            _this._nodeInjectionAvailable = true;
                            _this._nodeInjection2Available = use_version_2_1;
                            callback(false);
                        }).catch(function (resp) {
                            _this.log('la', '_injectDebuggerExtensions: code inject failed, trying again');
                            callback(true);
                        });
                    });
                    return;
                }
                catch (e) {
                }
            }
        }
        done();
    };
    /*
     * start the initialization sequence:
     * 1. wait for 'break-on-entry' (with timeout)
     * 2. send 'inititialized' event in order to trigger setBreakpointEvents request from client
     * 3. prepare for sending 'break-on-entry' or 'continue' later in _finishInitialize()
     */
    NodeDebugSession.prototype._startInitialize = function (stopped, n) {
        var _this = this;
        if (n === void 0) { n = 0; }
        if (n === 0) {
            this.log('la', "_startInitialize: stopped: " + stopped);
        }
        // wait at most 500ms for receiving the break on entry event
        // (since in attach mode we cannot enforce that node is started with --debug-brk, we cannot assume that we receive this event)
        if (!this._gotEntryEvent && n < 10) {
            setTimeout(function () {
                // recurse
                _this._startInitialize(stopped, n + 1);
            }, 50);
            return;
        }
        if (this._gotEntryEvent) {
            this.log('la', "_startInitialize: got break on entry event after " + n + " retries");
            if (this._nodeProcessId <= 0) {
                // if we haven't gotten a process pid so far, we try it again
                this._node.command('evaluate', { expression: 'process.pid', global: true }, function (resp) {
                    if (resp.success) {
                        _this._nodeProcessId = parseInt(resp.body.value);
                        _this.log('la', "_initialize: got process id " + _this._nodeProcessId + " from node (2nd try)");
                    }
                    _this._startInitialize2(stopped);
                });
            }
            else {
                this._startInitialize2(stopped);
            }
        }
        else {
            this.log('la', "_startInitialize: no entry event after " + n + " retries; giving up");
            this._gotEntryEvent = true; // we pretend to got one so that no 'entry' event will show up later...
            this._node.command('frame', null, function (resp) {
                if (resp.success) {
                    _this._cacheRefs(resp);
                    var s = _this._getValueFromCache(resp.body.script);
                    _this._rememberEntryLocation(s.name, resp.body.line, resp.body.column);
                }
                _this._startInitialize2(stopped);
            });
        }
    };
    NodeDebugSession.prototype._startInitialize2 = function (stopped) {
        // request UI to send breakpoints
        this.log('la', '_startInitialize2: fire initialized event');
        this.sendEvent(new vscode_debugadapter_1.InitializedEvent());
        // in attach-mode we don't know whether the debuggee has been launched in 'stop on entry' mode
        // so we use the stopped state of the VM
        if (this._attachMode) {
            this.log('la', "_startInitialize2: in attach mode we guess stopOnEntry flag to be '" + stopped + "''");
            this._stopOnEntry = stopped;
        }
        if (this._stopOnEntry) {
            // user has requested 'stop on entry' so send out a stop-on-entry
            this.log('la', '_startInitialize2: fire stop-on-entry event');
            this.sendEvent(new vscode_debugadapter_1.StoppedEvent(localize(15, null), NodeDebugSession.DUMMY_THREAD_ID));
        }
        else {
            // since we are stopped but UI doesn't know about this, remember that we continue later in finishInitialize()
            this.log('la', "_startInitialize2: remember to do a 'Continue' later");
            this._needContinue = true;
        }
    };
    //---- disconnect request -------------------------------------------------------------------------------------------------
    NodeDebugSession.prototype.disconnectRequest = function (response, args) {
        // special code for 'extensionHost' debugging
        if (this._adapterID === 'extensionHost') {
            // detect whether this disconnect request is part of a restart session
            if (this._nodeProcessId > 0 && args && typeof args.restart === 'boolean' && args.restart) {
                // do not kill extensionHost (since vscode will do this for us in a nicer way without killing the window)
                this._nodeProcessId = 0;
            }
        }
        _super.prototype.disconnectRequest.call(this, response, args);
    };
    /**
     * we rely on the generic implementation from DebugSession but we override 'Protocol.shutdown'
     * to disconnect from node and kill node & subprocesses
     */
    NodeDebugSession.prototype.shutdown = function () {
        var _this = this;
        if (!this._inShutdown) {
            this._inShutdown = true;
            if (this._attachMode) {
                // disconnect only in attach mode since otherwise node continues to run until it is killed
                this._node.command('disconnect'); // we don't wait for reponse
            }
            this._node.stop(); // stop socket connection (otherwise node.js dies with ECONNRESET on Windows)
            if (!this._attachMode) {
                // kill the whole process tree either starting with the terminal or with the node process
                var pid = this._terminalProcess ? this._terminalProcess.pid : this._nodeProcessId;
                if (pid > 0) {
                    this.log('la', 'shutdown: kill debugee and sub-processes');
                    terminal_1.Terminal.killTree(pid).then(function () {
                        _this._terminalProcess = null;
                        _this._nodeProcessId = -1;
                        _super.prototype.shutdown.call(_this);
                    }).catch(function (error) {
                        _this._terminalProcess = null;
                        _this._nodeProcessId = -1;
                        _super.prototype.shutdown.call(_this);
                    });
                    return;
                }
            }
            _super.prototype.shutdown.call(this);
        }
    };
    //--- set breakpoints request ---------------------------------------------------------------------------------------------
    NodeDebugSession.prototype.setBreakPointsRequest = function (response, args) {
        var _this = this;
        this.log('bp', "setBreakPointsRequest: " + JSON.stringify(args.source) + " " + JSON.stringify(args.breakpoints));
        // prefer the new API: array of breakpoints
        var lbs = args.breakpoints;
        if (lbs) {
            for (var _i = 0, lbs_1 = lbs; _i < lbs_1.length; _i++) {
                var b = lbs_1[_i];
                b.line = this.convertClientLineToDebugger(b.line);
                b.column = typeof b.column === 'number' ? this.convertClientColumnToDebugger(b.column) : 0;
            }
        }
        else {
            lbs = new Array();
            // deprecated API: convert line number array
            for (var _a = 0, _b = args.lines; _a < _b.length; _a++) {
                var l = _b[_a];
                lbs.push({
                    line: this.convertClientLineToDebugger(l),
                    column: 0
                });
            }
        }
        var source = args.source;
        if (source.adapterData) {
            if (source.adapterData.inlinePath) {
                // a breakpoint in inlined source: we need to source map
                this._mapSourceAndUpdateBreakpoints(response, source.adapterData.inlinePath, lbs);
                return;
            }
            if (source.adapterData.remotePath) {
                // a breakpoint in a remote file: don't try to source map
                this._updateBreakpoints(response, source.adapterData.remotePath, -1, lbs);
                return;
            }
        }
        if (source.sourceReference > 0) {
            var srcSource = this._sourceHandles.get(source.sourceReference);
            if (srcSource && srcSource.scriptId) {
                this._updateBreakpoints(response, null, srcSource.scriptId, lbs);
                return;
            }
        }
        if (source.path) {
            var path = this.convertClientPathToDebugger(source.path);
            this._mapSourceAndUpdateBreakpoints(response, path, lbs);
            return;
        }
        if (source.name) {
            // a core module
            this._findModule(source.name).then(function (scriptId) {
                if (scriptId >= 0) {
                    _this._updateBreakpoints(response, null, scriptId, lbs);
                }
                else {
                    _this.sendErrorResponse(response, 2019, localize(16, null, '{_module}'), { _module: source.name });
                }
                return;
            });
            return;
        }
        this.sendErrorResponse(response, 2012, 'No valid source specified.', null, vscode_debugadapter_1.ErrorDestination.Telemetry);
    };
    NodeDebugSession.prototype._mapSourceAndUpdateBreakpoints = function (response, path, lbs) {
        var sourcemap = false;
        var generated = null;
        if (this._sourceMaps) {
            generated = this._sourceMaps.MapPathFromSource(path);
            if (generated === path) {
                this.log('bp', "_mapSourceAndUpdateBreakpoints: source and generated are same -> ignore sourcemap");
                generated = null;
            }
        }
        if (generated) {
            sourcemap = true;
            // source map line numbers
            for (var _i = 0, lbs_2 = lbs; _i < lbs_2.length; _i++) {
                var lb = lbs_2[_i];
                var mapresult = this._sourceMaps.MapFromSource(path, lb.line, lb.column);
                if (mapresult) {
                    this.log('sm', "_mapSourceAndUpdateBreakpoints: src: '" + path + "' " + lb.line + ":" + lb.column + " -> gen: '" + mapresult.path + "' " + mapresult.line + ":" + mapresult.column);
                    if (mapresult.path !== generated) {
                        // this source line maps to a different destination file -> this is not supported, ignore breakpoint by setting line to -1
                        lb.line = -1;
                    }
                    else {
                        lb.line = mapresult.line;
                        lb.column = mapresult.column;
                    }
                }
                else {
                    this.log('sm', "_mapSourceAndUpdateBreakpoints: src: '" + path + "' " + lb.line + ":" + lb.column + " -> gen: couldn't be mapped; breakpoint ignored");
                    lb.line = -1;
                }
            }
            path = generated;
        }
        else if (!NodeDebugSession.isJavaScript(path)) {
            // ignore all breakpoints for this source
            for (var _a = 0, lbs_3 = lbs; _a < lbs_3.length; _a++) {
                var lb = lbs_3[_a];
                lb.line = -1;
            }
        }
        // try to convert local path to remote path
        path = this._localToRemote(path);
        this._updateBreakpoints(response, path, -1, lbs, sourcemap);
    };
    /*
     * clear and set all breakpoints of a given source.
     */
    NodeDebugSession.prototype._updateBreakpoints = function (response, path, scriptId, lbs, sourcemap) {
        var _this = this;
        if (sourcemap === void 0) { sourcemap = false; }
        // clear all existing breakpoints for the given path or script ID
        this._node.command2('listbreakpoints').then(function (nodeResponse) {
            var toClear = new Array();
            var path_regexp = _this._pathToRegexp(path);
            // try to match breakpoints
            for (var _i = 0, _a = nodeResponse.body.breakpoints; _i < _a.length; _i++) {
                var breakpoint = _a[_i];
                switch (breakpoint.type) {
                    case 'scriptId':
                        if (scriptId === breakpoint.script_id) {
                            toClear.push(breakpoint.number);
                        }
                        break;
                    case 'scriptRegExp':
                        if (path_regexp === breakpoint.script_regexp) {
                            toClear.push(breakpoint.number);
                        }
                        break;
                }
            }
            return _this._clearBreakpoints(toClear);
        }).then(function () {
            return Promise.all(lbs.map(function (bp) { return _this._setBreakpoint(scriptId, path, bp, sourcemap); }));
        }).then(function (result) {
            response.body = {
                breakpoints: result
            };
            _this.sendResponse(response);
            _this.log('bp', "_updateBreakpoints: result " + JSON.stringify(result));
        }).catch(function (nodeResponse) {
            _this._sendNodeResponse(response, nodeResponse);
        });
    };
    /*
     * Clear breakpoints by their ids.
     */
    NodeDebugSession.prototype._clearBreakpoints = function (ids) {
        var _this = this;
        return Promise.all(ids.map(function (id) { return _this._node.command2('clearbreakpoint', { breakpoint: id }); })).then(function () {
            return;
        }).catch(function (e) {
            return; // ignore errors
        });
    };
    /*
     * register a single breakpoint with node.
     */
    NodeDebugSession.prototype._setBreakpoint = function (scriptId, path, lb, sourcemap) {
        var _this = this;
        if (lb.line < 0) {
            // ignore this breakpoint because it couldn't be source mapped successfully
            var bp = new vscode_debugadapter_1.Breakpoint(false);
            bp.message = localize(17, null);
            return Promise.resolve(bp);
        }
        if (lb.line === 0) {
            lb.column += NodeDebugSession.FIRST_LINE_OFFSET;
        }
        if (scriptId > 0) {
            lb.type = 'scriptId';
            lb.target = scriptId;
        }
        else {
            lb.type = 'scriptRegExp';
            lb.target = this._pathToRegexp(path);
        }
        return this._node.command2('setbreakpoint', lb).then(function (resp) {
            _this.log('bp', "_setBreakpoint: " + JSON.stringify(lb));
            var actualLine = lb.line;
            var actualColumn = lb.column;
            var al = resp.body.actual_locations;
            if (al.length > 0) {
                actualLine = al[0].line;
                actualColumn = _this._adjustColumn(actualLine, al[0].column);
            }
            if (sourcemap) {
                // this source uses a sourcemap so we have to map js locations back to source locations
                var mapresult = _this._sourceMaps.MapToSource(path, null, actualLine, actualColumn);
                if (mapresult) {
                    _this.log('sm', "_setBreakpoint: bp verification gen: '" + path + "' " + actualLine + ":" + actualColumn + " -> src: '" + mapresult.path + "' " + mapresult.line + ":" + mapresult.column);
                    actualLine = mapresult.line;
                    actualColumn = mapresult.column;
                }
            }
            // nasty corner case: since we ignore the break-on-entry event we have to make sure that we
            // stop in the entry point line if the user has an explicit breakpoint there.
            // For this we check here whether a breakpoint is at the same location as the 'break-on-entry' location.
            // If yes, then we plan for hitting the breakpoint instead of 'continue' over it!
            if (!_this._stopOnEntry && _this._entryPath === path) {
                if (_this._entryLine === actualLine && _this._entryColumn === actualColumn) {
                    // we do not have to 'continue' but we have to generate a stopped event instead
                    _this._needContinue = false;
                    _this._needBreakpointEvent = true;
                    _this.log('la', '_setBreakpoint: remember to fire a breakpoint event later');
                }
            }
            return new vscode_debugadapter_1.Breakpoint(true, _this.convertDebuggerLineToClient(actualLine), _this.convertDebuggerColumnToClient(actualColumn));
        }).catch(function (error) {
            return new vscode_debugadapter_1.Breakpoint(false);
        });
    };
    /**
     * converts a path into a regular expression for use in the setbreakpoint request
     */
    NodeDebugSession.prototype._pathToRegexp = function (path) {
        if (!path) {
            return path;
        }
        var escPath = path.replace(/([/\\.?*()^${}|[\]])/g, '\\$1');
        // check for drive letter
        if (/^[a-zA-Z]:\\/.test(path)) {
            var u = escPath.substring(0, 1).toUpperCase();
            var l = u.toLowerCase();
            escPath = '[' + l + u + ']' + escPath.substring(1);
        }
        /*
        // support case-insensitive breakpoint paths
        const escPathUpper = escPath.toUpperCase();
        const escPathLower = escPath.toLowerCase();
        escPath = '';
        for (var i = 0; i < escPathUpper.length; i++) {
            const u = escPathUpper[i];
            const l = escPathLower[i];
            if (u === l) {
                escPath += u;
            } else {
                escPath += '[' + l + u + ']';
            }
        }
        */
        var pathRegex = '^(.*[\\/\\\\])?' + escPath + '$'; // skips drive letters
        return pathRegex;
    };
    //--- set function breakpoints request ------------------------------------------------------------------------------------
    NodeDebugSession.prototype.setFunctionBreakPointsRequest = function (response, args) {
        var _this = this;
        // clear all existing function breakpoints
        this._clearBreakpoints(this._functionBreakpoints).then(function () {
            _this._functionBreakpoints.length = 0; // clear array
            // set new function breakpoints
            return Promise.all(args.breakpoints.map(function (functionBreakpoint) { return _this._setFunctionBreakpoint(functionBreakpoint); }));
        }).then(function (results) {
            response.body = {
                breakpoints: results
            };
            _this.sendResponse(response);
            _this.log('bp', "setFunctionBreakPointsRequest: result " + JSON.stringify(results));
        }).catch(function (nodeResponse) {
            _this._sendNodeResponse(response, nodeResponse);
        });
    };
    /*
     * Register a single function breakpoint with node.
     * Returns verification info about the breakpoint.
     */
    NodeDebugSession.prototype._setFunctionBreakpoint = function (functionBreakpoint) {
        var _this = this;
        var args = {
            type: 'function',
            target: functionBreakpoint.name
        };
        if (functionBreakpoint.condition) {
            args.condition = functionBreakpoint.condition;
        }
        return this._node.command2('setbreakpoint', args).then(function (resp) {
            _this._functionBreakpoints.push(resp.body.breakpoint); // remember function breakpoint ids
            var locations = resp.body.actual_locations;
            if (locations && locations.length > 0) {
                var actualLine = _this.convertDebuggerLineToClient(locations[0].line);
                var actualColumn = _this.convertDebuggerColumnToClient(_this._adjustColumn(actualLine, locations[0].column));
                return new vscode_debugadapter_1.Breakpoint(true, actualLine, actualColumn); // TODO@AW add source
            }
            else {
                return new vscode_debugadapter_1.Breakpoint(true);
            }
        }).catch(function (resp) {
            return {
                verified: false,
                message: resp.message
            };
        });
    };
    //--- set exception request -----------------------------------------------------------------------------------------------
    NodeDebugSession.prototype.setExceptionBreakPointsRequest = function (response, args) {
        var _this = this;
        this.log('bp', "setExceptionBreakPointsRequest: " + JSON.stringify(args.filters));
        var f;
        var filters = args.filters;
        if (filters) {
            if (filters.indexOf('all') >= 0) {
                f = 'all';
            }
            else if (filters.indexOf('uncaught') >= 0) {
                f = 'uncaught';
            }
        }
        // we need to simplify this...
        this._node.command('setexceptionbreak', { type: 'all', enabled: false }, function (nodeResponse1) {
            if (nodeResponse1.success) {
                _this._node.command('setexceptionbreak', { type: 'uncaught', enabled: false }, function (nodeResponse2) {
                    if (nodeResponse2.success) {
                        if (f) {
                            _this._node.command('setexceptionbreak', { type: f, enabled: true }, function (nodeResponse3) {
                                if (nodeResponse3.success) {
                                    _this.sendResponse(response); // send response for setexceptionbreak
                                }
                                else {
                                    _this._sendNodeResponse(response, nodeResponse3);
                                }
                            });
                        }
                        else {
                            _this.sendResponse(response); // send response for setexceptionbreak
                        }
                    }
                    else {
                        _this._sendNodeResponse(response, nodeResponse2);
                    }
                });
            }
            else {
                _this._sendNodeResponse(response, nodeResponse1);
            }
        });
    };
    //--- set exception request -----------------------------------------------------------------------------------------------
    NodeDebugSession.prototype.configurationDoneRequest = function (response, args) {
        // all breakpoints are configured now -> start debugging
        var info = 'nothing to do';
        if (this._needContinue) {
            this._needContinue = false;
            info = 'do a \'Continue\'';
            this._node.command('continue', null, function (nodeResponse) { });
        }
        if (this._needBreakpointEvent) {
            this._needBreakpointEvent = false;
            info = 'fire breakpoint event';
            this.sendEvent(new vscode_debugadapter_1.StoppedEvent(localize(18, null), NodeDebugSession.DUMMY_THREAD_ID));
        }
        this.log('la', "configurationDoneRequest: " + info);
        this.sendResponse(response);
    };
    //--- threads request -----------------------------------------------------------------------------------------------------
    NodeDebugSession.prototype.threadsRequest = function (response) {
        var _this = this;
        this._node.command('threads', null, function (nodeResponse) {
            var threads = new Array();
            if (nodeResponse.success) {
                var ths = nodeResponse.body.threads;
                if (ths) {
                    for (var _i = 0, ths_1 = ths; _i < ths_1.length; _i++) {
                        var thread = ths_1[_i];
                        var id = thread.id;
                        if (id >= 0) {
                            threads.push(new vscode_debugadapter_1.Thread(id, NodeDebugSession.DUMMY_THREAD_NAME));
                        }
                    }
                }
            }
            if (threads.length === 0) {
                threads.push(new vscode_debugadapter_1.Thread(NodeDebugSession.DUMMY_THREAD_ID, NodeDebugSession.DUMMY_THREAD_NAME));
            }
            response.body = {
                threads: threads
            };
            _this.sendResponse(response);
        });
    };
    //--- stacktrace request --------------------------------------------------------------------------------------------------
    NodeDebugSession.prototype.stackTraceRequest = function (response, args) {
        var _this = this;
        var threadReference = args.threadId;
        var startFrame = typeof args.startFrame === 'number' ? args.startFrame : 0;
        var maxLevels = args.levels;
        var totalFrames = 0;
        if (threadReference !== NodeDebugSession.DUMMY_THREAD_ID) {
            this.sendErrorResponse(response, 2014, 'Unexpected thread reference {_thread}.', { _thread: threadReference }, vscode_debugadapter_1.ErrorDestination.Telemetry);
            return;
        }
        var cmd = this._nodeInjection2Available ? 'vscode_backtrace' : 'backtrace';
        this.log('va', "stackTraceRequest: " + cmd + " " + startFrame + " " + maxLevels);
        this._node.command2(cmd, { fromFrame: startFrame, toFrame: startFrame + maxLevels }, NodeDebugSession.STACKTRACE_TIMEOUT).then(function (response) {
            _this._cacheRefs(response);
            var frames = response.body.frames;
            totalFrames = response.body.totalFrames;
            return Promise.all(frames.map(function (frame) { return _this._createStackFrame(frame); }));
        }).then(function (stackframes) {
            response.body = {
                stackFrames: stackframes,
                totalFrames: totalFrames
            };
            _this.sendResponse(response);
        }).catch(function (error) {
            response.body = {
                stackFrames: []
            };
            _this.sendResponse(response);
        });
    };
    /**
     * Create a single stack frame.
     */
    NodeDebugSession.prototype._createStackFrame = function (frame) {
        var _this = this;
        // resolve some refs
        return this._resolveValues([frame.script, frame.func, frame.receiver]).then(function () {
            var line = frame.line;
            var column = _this._adjustColumn(line, frame.column);
            var origin = localize(19, null);
            var script_val = _this._getValueFromCache(frame.script);
            if (script_val) {
                var name_1 = script_val.name;
                // system.js generates script names that are file urls
                if (name_1.indexOf('file://') === 0) {
                    name_1 = name_1.replace('file://', '');
                }
                if (name_1 && PathUtils.isAbsolutePath(name_1)) {
                    var remotePath_1 = name_1; // with remote debugging path might come from a different OS
                    // if launch.json defines localRoot and remoteRoot try to convert remote path back to a local path
                    var localPath_1 = _this._remoteToLocal(remotePath_1);
                    if (localPath_1 !== remotePath_1 && _this._attachMode) {
                        // assume attached to remote node process
                        origin = localize(20, null);
                    }
                    name_1 = Path.basename(localPath_1);
                    // source mapping
                    if (_this._sourceMaps) {
                        if (!FS.existsSync(localPath_1)) {
                            var script_val_1 = _this._getValueFromCache(frame.script);
                            return _this._loadScript(script_val_1.id).then(function (content) {
                                return _this._createStackFrameFromSourceMap(frame, content, name_1, localPath_1, remotePath_1, origin, line, column);
                            });
                        }
                        return _this._createStackFrameFromSourceMap(frame, null, name_1, localPath_1, remotePath_1, origin, line, column);
                    }
                    return _this._createStackFrameFromPath(frame, name_1, localPath_1, remotePath_1, origin, line, column);
                }
                // fall back: source not found locally -> prepare to stream source content from node backend.
                var script_id = script_val.id;
                var sourceHandle = _this._sourceHandles.create(new SourceSource(script_id));
                origin = localize(21, null);
                var src = new vscode_debugadapter_1.Source(name_1, null, sourceHandle, origin);
                return _this._createStackFrameFromSource(frame, src, line, column);
            }
            return _this._createStackFrameFromSource(frame, null, line, column);
        });
    };
    /**
     * Creates a StackFrame when source maps are involved.
     */
    NodeDebugSession.prototype._createStackFrameFromSourceMap = function (frame, content, name, localPath, remotePath, origin, line, column) {
        // try to map
        var mapresult = this._sourceMaps.MapToSource(localPath, content, line, column, sourceMaps_1.Bias.LEAST_UPPER_BOUND);
        if (!mapresult) {
            mapresult = this._sourceMaps.MapToSource(localPath, content, line, column, sourceMaps_1.Bias.GREATEST_LOWER_BOUND);
        }
        if (mapresult) {
            this.log('sm', "_createStackFrame: gen: '" + localPath + "' " + line + ":" + column + " -> src: '" + mapresult.path + "' " + mapresult.line + ":" + mapresult.column);
            // verify that a file exists at path
            if (FS.existsSync(mapresult.path)) {
                // use this mapping
                localPath = mapresult.path;
                name = Path.basename(localPath);
                line = mapresult.line;
                column = mapresult.column;
                var src = new vscode_debugadapter_1.Source(name, this.convertDebuggerPathToClient(localPath));
                return this._createStackFrameFromSource(frame, src, line, column);
            }
            else {
                // file doesn't exist at path
                // if source map has inlined source use it
                var content_1 = mapresult.content;
                if (content_1) {
                    this.log('sm', "_createStackFrame: source '" + mapresult.path + "' doesn't exist -> use inlined source");
                    name = Path.basename(mapresult.path);
                    var sourceHandle = this._sourceHandles.create(new SourceSource(0, content_1));
                    line = mapresult.line;
                    column = mapresult.column;
                    origin = localize(22, null);
                    var src = new vscode_debugadapter_1.Source(name, null, sourceHandle, origin, { inlinePath: mapresult.path });
                    return this._createStackFrameFromSource(frame, src, line, column);
                }
                else {
                    this.log('sm', "_createStackFrame: source doesn't exist and no inlined source -> use generated file");
                    return this._createStackFrameFromPath(frame, name, localPath, remotePath, origin, line, column);
                }
            }
        }
        else {
            this.log('sm', "_createStackFrame: gen: '" + localPath + "' " + line + ":" + column + " -> couldn't be mapped to source -> use generated file");
            return this._createStackFrameFromPath(frame, name, localPath, remotePath, origin, line, column);
        }
    };
    /**
     * Creates a StackFrame from the given local path.
     * The remote path is used if the local path doesn't exist.
     */
    NodeDebugSession.prototype._createStackFrameFromPath = function (frame, name, localPath, remotePath, origin, line, column) {
        var src;
        if (FS.existsSync(localPath)) {
            src = new vscode_debugadapter_1.Source(name, this.convertDebuggerPathToClient(localPath));
        }
        else {
            // fall back: source not found locally -> prepare to stream source content from remote node.
            var script_val = this._getValueFromCache(frame.script);
            var script_id = script_val.id;
            var sourceHandle = this._sourceHandles.create(new SourceSource(script_id));
            src = new vscode_debugadapter_1.Source(name, null, sourceHandle, origin, { remotePath: remotePath }); // assume it is a remote path
        }
        return this._createStackFrameFromSource(frame, src, line, column);
    };
    /**
     * Creates a StackFrame with the given source location information.
     * The name of the frame is extracted from the frame.
     */
    NodeDebugSession.prototype._createStackFrameFromSource = function (frame, src, line, column) {
        var func_name;
        var func_val = this._getValueFromCache(frame.func);
        if (func_val) {
            func_name = func_val.inferredName;
            if (!func_name || func_name.length === 0) {
                func_name = func_val.name;
            }
        }
        if (!func_name || func_name.length === 0) {
            func_name = localize(23, null);
        }
        var frameReference = this._frameHandles.create(frame);
        return new vscode_debugadapter_1.StackFrame(frameReference, func_name, src, this.convertDebuggerLineToClient(line), this.convertDebuggerColumnToClient(column));
    };
    //--- scopes request ------------------------------------------------------------------------------------------------------
    NodeDebugSession.prototype.scopesRequest = function (response, args) {
        var _this = this;
        var frame = this._frameHandles.get(args.frameId);
        if (!frame) {
            this.sendErrorResponse(response, 2020, 'stack frame not valid', null, vscode_debugadapter_1.ErrorDestination.Telemetry);
            return;
        }
        var frameIx = frame.index;
        var frameThis = this._getValueFromCache(frame.receiver);
        this.log('va', "scopesRequest: scope " + frameIx);
        this._node.command2('scopes', { frame_index: frameIx, frameNumber: frameIx }).then(function (response) {
            _this._cacheRefs(response);
            var scopes = response.body.scopes;
            return Promise.all(scopes.map(function (scope) {
                var type = scope.type;
                var extra = type === 1 ? frameThis : null;
                var expensive = type === 0; // global scope is expensive
                var scopeName;
                switch (type) {
                    case 0:
                        scopeName = localize(24, null);
                        break;
                    case 1:
                        scopeName = localize(25, null);
                        break;
                    case 2:
                        scopeName = localize(26, null);
                        break;
                    case 3:
                        scopeName = localize(27, null);
                        break;
                    case 4:
                        scopeName = localize(28, null);
                        break;
                    case 5:
                        scopeName = localize(29, null);
                        break;
                    case 6:
                        scopeName = localize(30, null);
                        break;
                    default:
                        scopeName = localize(31, null, type);
                        break;
                }
                return _this._resolveValues([scope.object]).then(function (resolved) {
                    return new vscode_debugadapter_1.Scope(scopeName, _this._variableHandles.create(new PropertyExpander(resolved[0], extra)), expensive);
                }).catch(function (error) {
                    return new vscode_debugadapter_1.Scope(scopeName, 0);
                });
            }));
        }).then(function (scopes) {
            // exception scope
            if (frameIx === 0 && _this._exception) {
                scopes.unshift(new vscode_debugadapter_1.Scope(localize(32, null), _this._variableHandles.create(new PropertyExpander(_this._exception))));
            }
            response.body = {
                scopes: scopes
            };
            _this.sendResponse(response);
        }).catch(function (error) {
            // in case of error return empty scopes array
            response.body = { scopes: [] };
            _this.sendResponse(response);
        });
    };
    //--- variables request ---------------------------------------------------------------------------------------------------
    NodeDebugSession.prototype.variablesRequest = function (response, args) {
        var _this = this;
        var reference = args.variablesReference;
        var expander = this._variableHandles.get(reference);
        if (expander) {
            expander.Expand(this).then(function (variables) {
                variables.sort(NodeDebugSession.compareVariableNames);
                response.body = {
                    variables: variables
                };
                _this.sendResponse(response);
            }).catch(function (err) {
                // in case of error return empty variables array
                response.body = {
                    variables: []
                };
                _this.sendResponse(response);
            });
        }
        else {
            // in case of error return empty variables array
            response.body = {
                variables: []
            };
            this.sendResponse(response);
        }
    };
    /*
     * Returns indexed or named properties for the given structured object as a variables array.
     * There are three modes:
     * 'all': add all properties (indexed and named)
     * 'range': add 'count' indexed properties starting at 'start'
     * 'named': add only the named properties.
     */
    NodeDebugSession.prototype._createProperties = function (obj, mode, start, count) {
        var _this = this;
        if (start === void 0) { start = 0; }
        if (count === void 0) { count = 0; }
        if (!obj.properties) {
            // if properties are missing, this is an indication that we are running injected code which doesn't return properties eagerly
            if (this._nodeInjectionAvailable) {
                switch (mode) {
                    case 'range':
                    case 'all':
                        // try to use "vscode_size" from injected code
                        var handle = obj.handle;
                        if (typeof obj.vscode_size === 'number' && typeof handle === 'number' && handle !== 0) {
                            if (obj.vscode_size >= 0) {
                                this.log('va', "_createProperties: vscode_slice " + start + " " + count);
                                return this._node.command2('vscode_slice', { handle: handle, start: start, length: count }).then(function (resp) {
                                    var items = resp.body.result;
                                    return Promise.all(items.map(function (item, ix) {
                                        return _this._createVariable("[" + (start + ix) + "]", item);
                                    }));
                                });
                            }
                        }
                        break;
                    case 'named':
                        // can't add named properties because we don't have access to them yet.
                        break;
                }
            }
            // if we end up here, something went wrong...
            return Promise.resolve([]);
        }
        var selectedProperties = new Array();
        var found_proto = false;
        for (var _i = 0, _a = obj.properties; _i < _a.length; _i++) {
            var property = _a[_i];
            if ('name' in property) {
                var name_2 = property.name;
                if (name_2 === NodeDebugSession.PROTO) {
                    found_proto = true;
                }
                switch (mode) {
                    case 'all':
                        selectedProperties.push(property);
                        break;
                    case 'named':
                        if (typeof name_2 === 'string') {
                            selectedProperties.push(property);
                        }
                        break;
                    case 'range':
                        if (typeof name_2 === 'number' && name_2 >= start && name_2 < start + count) {
                            selectedProperties.push(property);
                        }
                        break;
                }
            }
        }
        // do we have to add the protoObject to the list of properties?
        if (!found_proto && (mode === 'all' || mode === 'named')) {
            var h = obj.handle;
            if (h > 0) {
                obj.protoObject.name = NodeDebugSession.PROTO;
                selectedProperties.push(obj.protoObject);
            }
        }
        return this._createPropertyVariables(obj, selectedProperties);
    };
    /**
     * Resolves the given properties and returns them as an array of Variables.
     * If the properties are indexed (opposed to named), a value 'start' is added to the index number.
     * 'noBrackets' controls whether the index is enclosed in brackets.
     * If a value is undefined it probes for a getter.
     */
    NodeDebugSession.prototype._createPropertyVariables = function (obj, properties, start, noBrackets) {
        var _this = this;
        if (typeof start !== 'number') {
            start = 0;
        }
        return this._resolveValues(properties).then(function () {
            return Promise.all(properties.map(function (property) {
                var val = _this._getValueFromCache(property);
                // create 'name'
                var name = property.name;
                if (typeof name === 'number') {
                    name = noBrackets ? "" + (start + name) : "[" + (start + name) + "]";
                }
                // if value 'undefined' trigger a getter
                if (val.type == 'undefined' && !val.value && obj) {
                    var args = {
                        expression: "obj." + name,
                        additional_context: [
                            { name: 'obj', handle: obj.handle }
                        ],
                        disable_break: true,
                        maxStringLength: NodeDebugSession.MAX_STRING_LENGTH
                    };
                    _this.log('va', "_createPropertyVariables: trigger getter");
                    return _this._node.command2('evaluate', args).then(function (response) {
                        _this._cacheRefs(response);
                        return _this._createVariable(name, response.body);
                    }).catch(function (err) {
                        return new vscode_debugadapter_1.Variable(name, 'undefined');
                    });
                }
                else {
                    return _this._createVariable(name, val);
                }
            }));
        });
    };
    /**
     * Create a Variable with the given name and value.
     * For structured values the variable object will have a corresponding expander.
     */
    NodeDebugSession.prototype._createVariable = function (name, val) {
        var _this = this;
        if (!val) {
            return Promise.resolve(null);
        }
        switch (val.type) {
            case 'object':
            case 'function':
            case 'regexp':
            case 'promise':
            case 'generator':
            case 'error':
                // indirect value
                var value_1 = val.className;
                var text = val.text;
                switch (value_1) {
                    case 'Array':
                    case 'Buffer':
                        return this._createArrayVariable(name, val, false);
                    case 'Int8Array':
                    case 'Uint8Array':
                    case 'Uint8ClampedArray':
                    case 'Int16Array':
                    case 'Uint16Array':
                    case 'Int32Array':
                    case 'Uint32Array':
                    case 'Float32Array':
                    case 'Float64Array':
                        return this._createArrayVariable(name, val, true);
                    case 'RegExp':
                        return Promise.resolve(new vscode_debugadapter_1.Variable(name, text, this._variableHandles.create(new PropertyExpander(val))));
                    case 'Generator':
                    case 'Object':
                        return this._resolveValues([val.constructorFunction]).then(function (resolved) {
                            if (resolved[0]) {
                                var constructor_name = resolved[0].name;
                                if (constructor_name) {
                                    value_1 = constructor_name;
                                }
                            }
                            if (val.status) {
                                value_1 += " { " + val.status + " }";
                            }
                            return new vscode_debugadapter_1.Variable(name, value_1, _this._variableHandles.create(new PropertyExpander(val)));
                        });
                    case 'Function':
                    case 'Error':
                    default:
                        if (text) {
                            if (text.indexOf('\n') >= 0) {
                                // replace body of function with '...'
                                var pos = text.indexOf('{');
                                if (pos > 0) {
                                    text = text.substring(0, pos) + '{ … }';
                                }
                            }
                            value_1 = text;
                        }
                        break;
                }
                return Promise.resolve(new vscode_debugadapter_1.Variable(name, value_1, this._variableHandles.create(new PropertyExpander(val))));
            case 'string':
                return this._createStringVariable(name, val);
            case 'boolean':
                return Promise.resolve(new vscode_debugadapter_1.Variable(name, val.value.toString().toLowerCase())); // node returns these boolean values capitalized
            case 'set':
                return this._createSetVariable(name, val);
            case 'map':
                return this._createMapVariable(name, val);
            case 'undefined':
            case 'null':
                return Promise.resolve(new vscode_debugadapter_1.Variable(name, val.type));
            case 'number':
                return Promise.resolve(new vscode_debugadapter_1.Variable(name, '' + val.value));
            case 'frame':
            default:
                return Promise.resolve(new vscode_debugadapter_1.Variable(name, val.value ? val.value.toString() : 'undefined'));
        }
    };
    //--- long array support
    NodeDebugSession.prototype._createArrayVariable = function (name, array, special) {
        var _this = this;
        var args = {
            // initially we need only the length of the array
            expression: "array.length",
            disable_break: true,
            additional_context: [
                { name: 'array', handle: array.handle }
            ]
        };
        this.log('va', "_createArrayVariable: array.length");
        return this._node.command2('evaluate', args).then(function (response) {
            _this._cacheRefs(response);
            var length = +response.body.value;
            var expander;
            if (length > _this._chunkSize) {
                expander = new Expander(function () {
                    // first add named properties then add ranges
                    return _this._createProperties(array, 'named').then(function (variables) {
                        var _loop_1 = function(start) {
                            var end = Math.min(start + _this._chunkSize, length) - 1;
                            var count = end - start + 1;
                            var expandFunc = void 0;
                            if (_this._largeArrays) {
                                expandFunc = function () { return _this._createLargeArrayElements(array, start, count, special); };
                            }
                            else {
                                expandFunc = function () { return _this._createProperties(array, 'range', start, count); };
                            }
                            variables.push(new vscode_debugadapter_1.Variable("[" + start + ".." + end + "]", ' ', _this._variableHandles.create(new Expander(expandFunc))));
                        };
                        for (var start = 0; start < length; start += _this._chunkSize) {
                            _loop_1(start);
                        }
                        return variables;
                    });
                });
            }
            else {
                expander = new PropertyExpander(array);
            }
            return new vscode_debugadapter_1.Variable(name, array.className + "[" + ((length >= 0) ? length.toString() : '') + "]", _this._variableHandles.create(expander));
        });
    };
    NodeDebugSession.prototype._createLargeArrayElements = function (array, start, count, special) {
        var _this = this;
        var args = {
            expression: "array.slice(" + start + ", " + (start + count) + ")",
            disable_break: true,
            additional_context: [
                { name: 'array', handle: array.handle }
            ]
        };
        this.log('va', "_createLargeArrayElements: array.slice");
        return this._node.command2('evaluate', args).then(function (response) {
            _this._cacheRefs(response);
            var properties = response.body.properties;
            var selectedProperties = new Array();
            for (var _i = 0, properties_1 = properties; _i < properties_1.length; _i++) {
                var property = properties_1[_i];
                var name_3 = property.name;
                if (typeof name_3 === 'number' && name_3 >= 0 && name_3 < count) {
                    selectedProperties.push(property);
                }
            }
            return _this._createPropertyVariables(null, selectedProperties);
        });
    };
    //--- ES6 Set support
    NodeDebugSession.prototype._createSetVariable = function (name, set) {
        var _this = this;
        var args = {
            // initially we need only the size of the set
            expression: "set.size",
            disable_break: true,
            additional_context: [
                { name: 'set', handle: set.handle }
            ]
        };
        this.log('va', "_createSetVariable: set.size");
        return this._node.command2('evaluate', args).then(function (response) {
            _this._cacheRefs(response);
            var size = +response.body.value;
            var expandFunc;
            if (size > _this._chunkSize) {
                expandFunc = function () {
                    var variables = [];
                    var _loop_2 = function(start) {
                        var end = Math.min(start + _this._chunkSize, size) - 1;
                        var rangeExpander = new Expander(function () { return _this._createSetElements(set, start, end); });
                        variables.push(new vscode_debugadapter_1.Variable(start + ".." + end, ' ', _this._variableHandles.create(rangeExpander)));
                    };
                    for (var start = 0; start < size; start += _this._chunkSize) {
                        _loop_2(start);
                    }
                    return Promise.resolve(variables);
                };
            }
            else {
                expandFunc = function () { return _this._createSetElements(set, 0, size); };
            }
            return new vscode_debugadapter_1.Variable(name, "Set[" + size + "]", _this._variableHandles.create(new Expander(expandFunc)));
        });
    };
    NodeDebugSession.prototype._createSetElements = function (set, start, end) {
        var _this = this;
        var args = {
            expression: "var r = [], i = 0; set.forEach(v => { if (i >= " + start + " && i <= " + end + ") r.push(v); i++; }); r",
            disable_break: true,
            additional_context: [
                { name: 'set', handle: set.handle }
            ]
        };
        var length = end - start + 1;
        this.log('va', "_createSetElements: set.slice " + start + " " + length);
        return this._node.command2('evaluate', args).then(function (response) {
            _this._cacheRefs(response);
            var properties = response.body.properties;
            var selectedProperties = new Array();
            for (var _i = 0, properties_2 = properties; _i < properties_2.length; _i++) {
                var property = properties_2[_i];
                var name_4 = property.name;
                if (typeof name_4 === 'number' && name_4 >= 0 && name_4 < length) {
                    selectedProperties.push(property);
                }
            }
            return _this._createPropertyVariables(null, selectedProperties, start, true);
        });
    };
    //--- ES6 map support
    NodeDebugSession.prototype._createMapVariable = function (name, map) {
        var _this = this;
        var args = {
            // initially we need only the size of the map
            expression: "map.size",
            disable_break: true,
            additional_context: [
                { name: 'map', handle: map.handle }
            ]
        };
        this.log('va', "_createMapVariable: map.size");
        return this._node.command2('evaluate', args).then(function (response) {
            _this._cacheRefs(response);
            var size = +response.body.value;
            var expandFunc;
            if (size > _this._chunkSize) {
                expandFunc = function () {
                    var variables = [];
                    var _loop_3 = function(start) {
                        var end = Math.min(start + _this._chunkSize, size) - 1;
                        var rangeExpander = new Expander(function () { return _this._createMapElements(map, start, end); });
                        variables.push(new vscode_debugadapter_1.Variable(start + ".." + end, ' ', _this._variableHandles.create(rangeExpander)));
                    };
                    for (var start = 0; start < size; start += _this._chunkSize) {
                        _loop_3(start);
                    }
                    return Promise.resolve(variables);
                };
            }
            else {
                expandFunc = function () { return _this._createMapElements(map, 0, size); };
            }
            return new vscode_debugadapter_1.Variable(name, "Map[" + size + "]", _this._variableHandles.create(new Expander(expandFunc)));
        });
    };
    NodeDebugSession.prototype._createMapElements = function (map, start, end) {
        var _this = this;
        // for each slot of the map we create three slots in a helper array: label, key, value
        var args = {
            expression: "var r=[],i=0; map.forEach((v,k) => { if (i>=" + start + " && i<=" + end + ") { r.push(k+' \u2192 '+v); r.push(k); r.push(v);} i++; }); r",
            disable_break: true,
            additional_context: [
                { name: 'map', handle: map.handle }
            ]
        };
        var count = end - start + 1;
        this.log('va', "_createMapElements: map.slice " + start + " " + count);
        return this._node.command2('evaluate', args).then(function (response) {
            _this._cacheRefs(response);
            var properties = response.body.properties;
            var selectedProperties = new Array();
            for (var _i = 0, properties_3 = properties; _i < properties_3.length; _i++) {
                var property = properties_3[_i];
                var name_5 = property.name;
                if (typeof name_5 === 'number' && name_5 >= 0 && name_5 < count * 3) {
                    selectedProperties.push(property);
                }
            }
            return _this._resolveValues(selectedProperties).then(function () {
                var variables = [];
                var _loop_4 = function(i) {
                    var key = _this._getValueFromCache(selectedProperties[i + 1]);
                    var val = _this._getValueFromCache(selectedProperties[i + 2]);
                    var expander = new Expander(function () {
                        return Promise.all([
                            _this._createVariable('key', key),
                            _this._createVariable('value', val)
                        ]);
                    });
                    variables.push(new vscode_debugadapter_1.Variable((start + (i / 3)).toString(), _this._getValueFromCache(selectedProperties[i]).value, _this._variableHandles.create(expander)));
                };
                for (var i = 0; i < selectedProperties.length; i += 3) {
                    _loop_4(i);
                }
                return variables;
            });
        });
    };
    //--- long string support
    NodeDebugSession.prototype._createStringVariable = function (name, val) {
        var _this = this;
        var str_val = val.value;
        if (NodeDebugSession.LONG_STRING_MATCHER.exec(str_val)) {
            var args = {
                expression: "str",
                disable_break: true,
                maxStringLength: NodeDebugSession.MAX_STRING_LENGTH,
                additional_context: [
                    { name: 'str', handle: val.handle }
                ]
            };
            this.log('va', "_createStringVariable: get full string");
            return this._node.command2('evaluate', args).then(function (response) {
                if (response.success) {
                    _this._cacheRefs(response);
                    str_val = response.body.value;
                }
                return _this._createStringVariable2(name, str_val);
            });
        }
        else {
            return Promise.resolve(this._createStringVariable2(name, str_val));
        }
    };
    NodeDebugSession.prototype._createStringVariable2 = function (name, s) {
        if (s) {
            s = s.replace('\n', '\\n').replace('\r', '\\r');
        }
        return new vscode_debugadapter_1.Variable(name, "\"" + s + "\"");
    };
    //--- pause request -------------------------------------------------------------------------------------------------------
    NodeDebugSession.prototype.pauseRequest = function (response, args) {
        var _this = this;
        this._node.command('suspend', null, function (nodeResponse) {
            if (nodeResponse.success) {
                _this._stopped('pause');
                _this._lastStoppedEvent = new vscode_debugadapter_1.StoppedEvent(localize(33, null), NodeDebugSession.DUMMY_THREAD_ID);
                _this.sendResponse(response);
                _this.sendEvent(_this._lastStoppedEvent);
            }
            else {
                _this._sendNodeResponse(response, nodeResponse);
            }
        });
    };
    //--- continue request ----------------------------------------------------------------------------------------------------
    NodeDebugSession.prototype.continueRequest = function (response, args) {
        var _this = this;
        this._node.command('continue', null, function (nodeResponse) {
            _this._sendNodeResponse(response, nodeResponse);
        });
    };
    //--- step request --------------------------------------------------------------------------------------------------------
    NodeDebugSession.prototype.stepInRequest = function (response, args) {
        var _this = this;
        this._node.command('continue', { stepaction: 'in' }, function (nodeResponse) {
            _this._sendNodeResponse(response, nodeResponse);
        });
    };
    NodeDebugSession.prototype.stepOutRequest = function (response, args) {
        var _this = this;
        this._node.command('continue', { stepaction: 'out' }, function (nodeResponse) {
            _this._sendNodeResponse(response, nodeResponse);
        });
    };
    NodeDebugSession.prototype.nextRequest = function (response, args) {
        var _this = this;
        this._node.command('continue', { stepaction: 'next' }, function (nodeResponse) {
            _this._sendNodeResponse(response, nodeResponse);
        });
    };
    //--- evaluate request ----------------------------------------------------------------------------------------------------
    NodeDebugSession.prototype.evaluateRequest = function (response, args) {
        var _this = this;
        var expression = args.expression;
        var evalArgs = {
            expression: expression,
            disable_break: true,
            maxStringLength: NodeDebugSession.MAX_STRING_LENGTH
        };
        if (args.frameId > 0) {
            var frame = this._frameHandles.get(args.frameId);
            if (!frame) {
                this.sendErrorResponse(response, 2020, 'stack frame not valid', null, vscode_debugadapter_1.ErrorDestination.Telemetry);
                return;
            }
            var frameIx = frame.index;
            evalArgs.frame = frameIx;
        }
        else {
            evalArgs.global = true;
        }
        this._node.command(this._nodeInjectionAvailable ? 'vscode_evaluate' : 'evaluate', evalArgs, function (resp) {
            if (resp.success) {
                _this._createVariable('evaluate', resp.body).then(function (v) {
                    if (v) {
                        response.body = {
                            result: v.value,
                            variablesReference: v.variablesReference
                        };
                    }
                    else {
                        response.success = false;
                        response.message = localize(34, null);
                    }
                    _this.sendResponse(response);
                });
            }
            else {
                response.success = false;
                if (resp.message.indexOf('ReferenceError: ') === 0 || resp.message === 'No frames') {
                    response.message = localize(35, null);
                }
                else if (resp.message.indexOf('SyntaxError: ') === 0) {
                    var m = resp.message.substring('SyntaxError: '.length).toLowerCase();
                    response.message = localize(36, null, m);
                }
                else {
                    response.message = resp.message;
                }
                _this.sendResponse(response);
            }
        });
    };
    //--- source request ------------------------------------------------------------------------------------------------------
    NodeDebugSession.prototype.sourceRequest = function (response, args) {
        var _this = this;
        var sourceHandle = args.sourceReference;
        var srcSource = this._sourceHandles.get(sourceHandle);
        if (srcSource.source) {
            response.body = {
                content: srcSource.source
            };
            this.sendResponse(response);
            return;
        }
        if (srcSource.scriptId) {
            this._node.command('scripts', { types: 1 + 2 + 4, includeSource: true, ids: [srcSource.scriptId] }, function (nodeResponse) {
                if (nodeResponse.success) {
                    srcSource.source = nodeResponse.body[0].source;
                }
                else {
                    srcSource.source = localize(37, null);
                }
                response.body = {
                    content: srcSource.source
                };
                _this.sendResponse(response);
            });
        }
        else {
            this.sendErrorResponse(response, 9999, 'sourceRequest error', null, vscode_debugadapter_1.ErrorDestination.Telemetry);
        }
    };
    NodeDebugSession.prototype._loadScript = function (scriptId) {
        return this._node.command2('scripts', { types: 1 + 2 + 4, includeSource: true, ids: [scriptId] }).then(function (nodeResponse) {
            return nodeResponse.body[0].source;
        });
    };
    //---- private helpers ----------------------------------------------------------------------------------------------------
    NodeDebugSession.prototype.log = function (traceCategory, message) {
        if (this._trace && (this._traceAll || this._trace.indexOf(traceCategory) >= 0)) {
            this.outLine(process.pid + ": " + message);
        }
    };
    /**
     * 'Attribute missing' error
     */
    NodeDebugSession.prototype.sendAttributeMissingErrorResponse = function (response, attribute) {
        this.sendErrorResponse(response, 2005, localize(38, null, attribute));
    };
    /**
     * 'Path does not exist' error
     */
    NodeDebugSession.prototype.sendNotExistErrorResponse = function (response, attribute, path) {
        this.sendErrorResponse(response, 2007, localize(39, null, attribute, '{path}'), { path: path });
    };
    /**
     * 'Path not absolute' error with 'More Information' link.
     */
    NodeDebugSession.prototype.sendRelativePathErrorResponse = function (response, attribute, path) {
        var format = localize(40, null, attribute, '{path}', '${workspaceRoot}/');
        this.sendErrorResponseWithInfoLink(response, 2008, format, { path: path }, 20003);
    };
    /**
     * Send error response with 'More Information' link.
     */
    NodeDebugSession.prototype.sendErrorResponseWithInfoLink = function (response, code, format, variables, infoId) {
        this.sendErrorResponse(response, {
            id: code,
            format: format,
            variables: variables,
            showUser: true,
            url: 'http://go.microsoft.com/fwlink/?linkID=534832#_' + infoId.toString(),
            urlLabel: localize(41, null)
        });
    };
    /**
     * send a line of text to an output channel.
     */
    NodeDebugSession.prototype.outLine = function (message, category) {
        this.sendEvent(new vscode_debugadapter_1.OutputEvent(message + '\n', category ? category : 'console'));
    };
    /**
     * Tries to map a (local) VSCode path to a corresponding path on a remote host (where node is running).
     * The remote host might use a different OS so we have to make sure to create correct file paths.
     */
    NodeDebugSession.prototype._localToRemote = function (localPath) {
        if (this._remoteRoot && this._localRoot) {
            var relPath = PathUtils.makeRelative2(this._localRoot, localPath);
            var remotePath = PathUtils.join(this._remoteRoot, relPath);
            if (/^[a-zA-Z]:[\/\\]/.test(this._remoteRoot)) {
                remotePath = PathUtils.toWindows(remotePath);
            }
            this.log('bp', "_localToRemote: " + localPath + " -> " + remotePath);
            return remotePath;
        }
        else {
            return localPath;
        }
    };
    /**
     * Tries to map a path from the remote host (where node is running) to a corresponding local path.
     * The remote host might use a different OS so we have to make sure to create correct file paths.
     */
    NodeDebugSession.prototype._remoteToLocal = function (remotePath) {
        if (this._remoteRoot && this._localRoot) {
            var relPath = PathUtils.makeRelative2(this._remoteRoot, remotePath);
            var localPath = PathUtils.join(this._localRoot, relPath);
            if (process.platform === 'win32') {
                localPath = PathUtils.toWindows(localPath);
            }
            this.log('bp', "_remoteToLocal: " + remotePath + " -> " + localPath);
            return localPath;
        }
        else {
            return remotePath;
        }
    };
    NodeDebugSession.prototype._sendNodeResponse = function (response, nodeResponse) {
        if (nodeResponse.success) {
            this.sendResponse(response);
        }
        else {
            var errmsg = nodeResponse.message;
            if (errmsg.indexOf('unresponsive') >= 0) {
                this.sendErrorResponse(response, 2015, localize(42, null), { _request: nodeResponse.command });
            }
            else if (errmsg.indexOf('timeout') >= 0) {
                this.sendErrorResponse(response, 2016, localize(43, null), { _request: nodeResponse.command });
            }
            else {
                this.sendErrorResponse(response, 2013, 'Node.js request \'{_request}\' failed (reason: {_error}).', { _request: nodeResponse.command, _error: errmsg }, vscode_debugadapter_1.ErrorDestination.Telemetry);
            }
        }
    };
    NodeDebugSession.prototype._repeater = function (n, done, asyncwork) {
        var _this = this;
        if (n > 0) {
            asyncwork(function (again) {
                if (again) {
                    setTimeout(function () {
                        // recurse
                        _this._repeater(n - 1, done, asyncwork);
                    }, 100); // retry after 100 ms
                }
                else {
                    done(true);
                }
            });
        }
        else {
            done(false);
        }
    };
    NodeDebugSession.prototype._cacheRefs = function (response) {
        var refs = response.refs;
        for (var _i = 0, refs_1 = refs; _i < refs_1.length; _i++) {
            var r = refs_1[_i];
            this._cache(r.handle, r);
        }
    };
    NodeDebugSession.prototype._cache = function (handle, o) {
        this._refCache.set(handle, o);
    };
    NodeDebugSession.prototype._getValueFromCache = function (container) {
        var value = this._refCache.get(container.ref);
        if (value) {
            return value;
        }
        // console.error('ref not found cache');
        return null;
    };
    NodeDebugSession.prototype._resolveValues = function (mirrors) {
        var _this = this;
        var needLookup = new Array();
        for (var _i = 0, mirrors_1 = mirrors; _i < mirrors_1.length; _i++) {
            var mirror = mirrors_1[_i];
            if (!mirror.value && mirror.ref) {
                if (needLookup.indexOf(mirror.ref) < 0) {
                    needLookup.push(mirror.ref);
                }
            }
        }
        if (needLookup.length > 0) {
            return this._resolveToCache(needLookup).then(function () {
                return mirrors.map(function (m) { return _this._refCache.get(m.ref || m.handle); });
            });
        }
        else {
            return Promise.resolve(mirrors);
        }
    };
    NodeDebugSession.prototype._resolveToCache = function (handles) {
        var _this = this;
        var lookup = new Array();
        for (var _i = 0, handles_1 = handles; _i < handles_1.length; _i++) {
            var handle = handles_1[_i];
            var val = this._refCache.get(handle);
            if (!val) {
                if (handle >= 0) {
                    lookup.push(handle);
                }
                else {
                }
            }
        }
        if (lookup.length > 0) {
            var cmd = this._nodeInjectionAvailable ? 'vscode_lookup' : 'lookup';
            this.log('va', "_resolveToCache: " + cmd + " " + lookup.length + " handles");
            return this._node.command2(cmd, { handles: lookup }).then(function (resp) {
                _this._cacheRefs(resp);
                for (var key in resp.body) {
                    var obj = resp.body[key];
                    var handle = obj.handle;
                    _this._cache(handle, obj);
                }
                return handles.map(function (handle) { return _this._refCache.get(handle); });
            }).catch(function (resp) {
                var val;
                if (resp.message.indexOf('timeout') >= 0) {
                    val = { type: 'number', value: '<...>' };
                }
                else {
                    val = { type: 'number', value: "<data error: " + resp.message + ">" };
                }
                // store error value in cache
                for (var i = 0; i < handles.length; i++) {
                    var handle = handles[i];
                    var r = _this._refCache.get(handle);
                    if (!r) {
                        _this._cache(handle, val);
                    }
                }
                return handles.map(function (handle) { return _this._refCache.get(handle); });
            });
        }
        else {
            return Promise.resolve(handles.map(function (handle) { return _this._refCache.get(handle); }));
        }
    };
    NodeDebugSession.prototype._rememberEntryLocation = function (path, line, column) {
        if (path) {
            this._entryPath = path;
            this._entryLine = line;
            this._entryColumn = this._adjustColumn(line, column);
            this._gotEntryEvent = true;
        }
    };
    /**
     * workaround for column being off in the first line (because of a wrapped anonymous function)
     */
    NodeDebugSession.prototype._adjustColumn = function (line, column) {
        if (line === 0) {
            column -= NodeDebugSession.FIRST_LINE_OFFSET;
            if (column < 0) {
                column = 0;
            }
        }
        return column;
    };
    NodeDebugSession.prototype._findModule = function (name) {
        return this._node.command2('scripts', { types: 1 + 2 + 4, filter: name }).then(function (resp) {
            for (var _i = 0, _a = resp.body; _i < _a.length; _i++) {
                var result = _a[_i];
                if (result.name === name) {
                    return result.id;
                }
            }
            return -1; // not found
        }).catch(function (err) {
            return -1; // error
        });
    };
    //---- private static ---------------------------------------------------------------
    NodeDebugSession.isJavaScript = function (path) {
        var name = Path.basename(path).toLowerCase();
        if (endsWith(name, '.js')) {
            return true;
        }
        try {
            var buffer = new Buffer(30);
            var fd = FS.openSync(path, 'r');
            FS.readSync(fd, buffer, 0, buffer.length, 0);
            FS.closeSync(fd);
            var line = buffer.toString();
            if (NodeDebugSession.NODE_SHEBANG_MATCHER.test(line)) {
                return true;
            }
        }
        catch (e) {
        }
        return false;
    };
    NodeDebugSession.compareVariableNames = function (v1, v2) {
        var n1 = v1.name;
        var n2 = v2.name;
        if (n1 === NodeDebugSession.PROTO) {
            return 1;
        }
        if (n2 === NodeDebugSession.PROTO) {
            return -1;
        }
        // convert [n], [n..m] -> n
        n1 = NodeDebugSession.extractNumber(n1);
        n2 = NodeDebugSession.extractNumber(n2);
        var i1 = parseInt(n1);
        var i2 = parseInt(n2);
        var isNum1 = !isNaN(i1);
        var isNum2 = !isNaN(i2);
        if (isNum1 && !isNum2) {
            return 1; // numbers after names
        }
        if (!isNum1 && isNum2) {
            return -1; // names before numbers
        }
        if (isNum1 && isNum2) {
            return i1 - i2;
        }
        return n1.localeCompare(n2);
    };
    NodeDebugSession.extractNumber = function (s) {
        if (s[0] === '[' && s[s.length - 1] === ']') {
            s = s.substring(1, s.length - 1);
            var p = s.indexOf('..');
            if (p >= 0) {
                s = s.substring(0, p);
            }
        }
        return s;
    };
    NodeDebugSession.MAX_STRING_LENGTH = 10000; // max string size to return in 'evaluate' request
    NodeDebugSession.NODE_TERMINATION_POLL_INTERVAL = 3000;
    NodeDebugSession.ATTACH_TIMEOUT = 10000;
    NodeDebugSession.STACKTRACE_TIMEOUT = 10000;
    NodeDebugSession.NODE = 'node';
    NodeDebugSession.DUMMY_THREAD_ID = 1;
    NodeDebugSession.DUMMY_THREAD_NAME = 'Node';
    NodeDebugSession.FIRST_LINE_OFFSET = 62;
    NodeDebugSession.PROTO = '__proto__';
    NodeDebugSession.DEBUG_INJECTION = 'debugInjection.js'; // for node version 0.12.x and >= 4.3.1
    NodeDebugSession.DEBUG_INJECTION2 = 'debugInjection2.js'; // for node version >= 5.6
    NodeDebugSession.NODE_SHEBANG_MATCHER = new RegExp('#! */usr/bin/env +node');
    NodeDebugSession.LONG_STRING_MATCHER = /\.\.\. \(length: [0-9]+\)$/;
    return NodeDebugSession;
}(vscode_debugadapter_1.DebugSession));
exports.NodeDebugSession = NodeDebugSession;
function endsWith(str, suffix) {
    return str.indexOf(suffix, str.length - suffix.length) !== -1;
}
function random(low, high) {
    return Math.floor(Math.random() * (high - low) + low);
}
function isArray(what) {
    return Object.prototype.toString.call(what) === '[object Array]';
}
function extendObject(objectCopy, object) {
    for (var key in object) {
        if (object.hasOwnProperty(key)) {
            objectCopy[key] = object[key];
        }
    }
    return objectCopy;
}
vscode_debugadapter_1.DebugSession.run(NodeDebugSession);

//# sourceMappingURL=../../out/node/nodeDebug.js.map
