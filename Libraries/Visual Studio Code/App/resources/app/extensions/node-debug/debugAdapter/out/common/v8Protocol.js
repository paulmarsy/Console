/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var EE = require('events');
var Message = (function () {
    function Message(type) {
        this.seq = 0;
        this.type = type;
    }
    return Message;
})();
exports.Message = Message;
var Response = (function (_super) {
    __extends(Response, _super);
    function Response(request, message) {
        _super.call(this, 'response');
        this.request_seq = request.seq;
        this.command = request.command;
        if (message) {
            this.success = false;
            this.message = message;
        }
        else {
            this.success = true;
        }
    }
    return Response;
})(Message);
exports.Response = Response;
var Event = (function (_super) {
    __extends(Event, _super);
    function Event(event, body) {
        _super.call(this, 'event');
        this.event = event;
        if (body) {
            this.body = body;
        }
    }
    return Event;
})(Message);
exports.Event = Event;
var V8Protocol = (function (_super) {
    __extends(V8Protocol, _super);
    function V8Protocol() {
        _super.apply(this, arguments);
        this._pendingRequests = new Map();
        this.embeddedHostVersion = -1;
    }
    V8Protocol.prototype.startDispatch = function (inStream, outStream) {
        var _this = this;
        this._sequence = 1;
        this._writableStream = outStream;
        this._newRes(null);
        inStream.setEncoding('utf8');
        inStream.on('data', function (data) { return _this.execute(data); });
        inStream.on('close', function () {
            _this.emitEvent(new Event('close'));
        });
        inStream.on('error', function (error) {
            _this.emitEvent(new Event('error'));
        });
        outStream.on('error', function (error) {
            _this.emitEvent(new Event('error'));
        });
        inStream.resume();
    };
    V8Protocol.prototype.stop = function () {
        if (this._writableStream) {
            this._writableStream.end();
        }
    };
    V8Protocol.prototype.command = function (command, args, cb) {
        var _this = this;
        var timeout = V8Protocol.TIMEOUT;
        var request = {
            command: command
        };
        if (args && Object.keys(args).length > 0) {
            request.arguments = args;
        }
        if (this._unresponsiveMode) {
            if (cb) {
                cb(new Response(request, 'cancelled because node is unresponsive'));
            }
            return;
        }
        this.send('request', request);
        if (cb) {
            this._pendingRequests[request.seq] = cb;
            var timer = setTimeout(function () {
                clearTimeout(timer);
                var clb = _this._pendingRequests[request.seq];
                if (clb) {
                    delete _this._pendingRequests[request.seq];
                    clb(new Response(request, 'timeout after ' + timeout + 'ms'));
                    _this._unresponsiveMode = true;
                    _this.emitEvent(new Event('diagnostic', { reason: 'unresponsive ' + command }));
                }
            }, timeout);
        }
    };
    V8Protocol.prototype.command2 = function (command, args, timeout) {
        var _this = this;
        if (timeout === void 0) { timeout = V8Protocol.TIMEOUT; }
        return new Promise(function (completeDispatch, errorDispatch) {
            _this.command(command, args, function (result) {
                if (result.success) {
                    completeDispatch(result);
                }
                else {
                    errorDispatch(result);
                }
            });
        });
    };
    V8Protocol.prototype.sendEvent = function (event) {
        this.send('event', event);
    };
    V8Protocol.prototype.sendResponse = function (response) {
        if (response.seq > 0) {
            console.error('attempt to send more than one response for command {0}', response.command);
        }
        else {
            this.send('response', response);
        }
    };
    // ---- protected ----------------------------------------------------------
    V8Protocol.prototype.dispatchRequest = function (request) {
    };
    // ---- private ------------------------------------------------------------
    V8Protocol.prototype.emitEvent = function (event) {
        this.emit(event.event, event);
    };
    V8Protocol.prototype.send = function (typ, message) {
        message.type = typ;
        message.seq = this._sequence++;
        var json = JSON.stringify(message);
        var data = 'Content-Length: ' + Buffer.byteLength(json, 'utf8') + '\r\n\r\n' + json;
        if (this._writableStream) {
            this._writableStream.write(data);
        }
    };
    V8Protocol.prototype._newRes = function (raw) {
        this._res = {
            raw: raw || '',
            headers: {}
        };
        this._state = 'headers';
        this.execute('');
    };
    V8Protocol.prototype.internalDispatch = function (message) {
        switch (message.type) {
            case 'event':
                var e = message;
                this.emitEvent(e);
                break;
            case 'response':
                if (this._unresponsiveMode) {
                    this._unresponsiveMode = false;
                    this.emitEvent(new Event('diagnostic', { reason: 'responsive' }));
                }
                var response = message;
                var clb = this._pendingRequests[response.request_seq];
                if (clb) {
                    delete this._pendingRequests[response.request_seq];
                    clb(response);
                }
                break;
            case 'request':
                this.dispatchRequest(message);
                break;
            default:
                break;
        }
    };
    V8Protocol.prototype.execute = function (d) {
        var res = this._res;
        res.raw += d;
        switch (this._state) {
            case 'headers':
                var endHeaderIndex = res.raw.indexOf('\r\n\r\n');
                if (endHeaderIndex < 0)
                    break;
                var rawHeader = res.raw.slice(0, endHeaderIndex);
                var endHeaderByteIndex = Buffer.byteLength(rawHeader, 'utf8');
                var lines = rawHeader.split('\r\n');
                for (var i = 0; i < lines.length; i++) {
                    var kv = lines[i].split(/: +/);
                    res.headers[kv[0]] = kv[1];
                    if (kv[0] === 'Embedding-Host') {
                        var match = kv[1].match(/node\sv(\d+)\.\d+\.\d+/);
                        if (match.length === 2) {
                            this.embeddedHostVersion = parseInt(match[1]);
                        }
                    }
                }
                this._contentLength = +res.headers['Content-Length'];
                this._bodyStartByteIndex = endHeaderByteIndex + 4;
                this._state = 'body';
                var len = Buffer.byteLength(res.raw, 'utf8');
                if (len - this._bodyStartByteIndex < this._contentLength) {
                    break;
                }
            // pass thru
            case 'body':
                var resRawByteLength = Buffer.byteLength(res.raw, 'utf8');
                if (resRawByteLength - this._bodyStartByteIndex >= this._contentLength) {
                    var buf = new Buffer(resRawByteLength);
                    buf.write(res.raw, 0, resRawByteLength, 'utf8');
                    res.body = buf.slice(this._bodyStartByteIndex, this._bodyStartByteIndex + this._contentLength).toString('utf8');
                    res.body = res.body.length ? JSON.parse(res.body) : {};
                    this.internalDispatch(res.body);
                    this._newRes(buf.slice(this._bodyStartByteIndex + this._contentLength).toString('utf8'));
                }
                break;
            default:
                throw new Error('Unknown state');
                break;
        }
    };
    V8Protocol.TIMEOUT = 3000;
    return V8Protocol;
})(EE.EventEmitter);
exports.V8Protocol = V8Protocol;
//# sourceMappingURL=v8Protocol.js.map