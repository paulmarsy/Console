/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
'use strict';
var DefaultSize = 8192;
var ContentLength = 'Content-Length: ';
var ContentLengthSize = Buffer.byteLength(ContentLength, 'utf8');
var Blank = new Buffer(' ', 'utf8')[0];
var BackslashR = new Buffer('\r', 'utf8')[0];
var BackslashN = new Buffer('\n', 'utf8')[0];
var ProtocolBuffer = (function () {
    function ProtocolBuffer() {
        this.index = 0;
        this.buffer = new Buffer(DefaultSize);
    }
    ProtocolBuffer.prototype.append = function (data) {
        var toAppend = null;
        if (Buffer.isBuffer(data)) {
            toAppend = data;
        }
        else {
            toAppend = new Buffer(data, 'utf8');
        }
        if (this.buffer.length - this.index >= toAppend.length) {
            toAppend.copy(this.buffer, this.index, 0, toAppend.length);
        }
        else {
            var newSize = (Math.ceil((this.index + toAppend.length) / DefaultSize) + 1) * DefaultSize;
            if (this.index === 0) {
                this.buffer = new Buffer(newSize);
                toAppend.copy(this.buffer, 0, 0, toAppend.length);
            }
            else {
                this.buffer = Buffer.concat([this.buffer.slice(0, this.index), toAppend], newSize);
            }
        }
        this.index += toAppend.length;
    };
    ProtocolBuffer.prototype.tryReadContentLength = function () {
        var result = -1;
        var current = 0;
        // we are utf8 encoding...
        while (current < this.index && (this.buffer[current] === Blank || this.buffer[current] === BackslashR || this.buffer[current] === BackslashN)) {
            current++;
        }
        if (this.index < current + ContentLengthSize) {
            return result;
        }
        current += ContentLengthSize;
        var start = current;
        while (current < this.index && this.buffer[current] !== BackslashR) {
            current++;
        }
        if (current + 3 >= this.index || this.buffer[current + 1] !== BackslashN || this.buffer[current + 2] !== BackslashR || this.buffer[current + 3] !== BackslashN) {
            return result;
        }
        var data = this.buffer.toString('utf8', start, current);
        result = parseInt(data);
        this.buffer = this.buffer.slice(current + 4);
        this.index = this.index - (current + 4);
        return result;
    };
    ProtocolBuffer.prototype.tryReadContent = function (length) {
        if (this.index < length) {
            return null;
        }
        var result = this.buffer.toString('utf8', 0, length);
        var sourceStart = length;
        while (sourceStart < this.index && (this.buffer[sourceStart] === BackslashR || this.buffer[sourceStart] === BackslashN)) {
            sourceStart++;
        }
        this.buffer.copy(this.buffer, 0, sourceStart);
        this.index = this.index - sourceStart;
        return result;
    };
    ProtocolBuffer.prototype.tryReadLine = function () {
        var end = 0;
        while (end < this.index && this.buffer[end] !== BackslashR && this.buffer[end] !== BackslashN) {
            end++;
        }
        if (end >= this.index) {
            return null;
        }
        var result = this.buffer.toString('utf8', 0, end);
        while (end < this.index && (this.buffer[end] === BackslashR || this.buffer[end] === BackslashN)) {
            end++;
        }
        if (this.index === end) {
            this.index = 0;
        }
        else {
            this.buffer.copy(this.buffer, 0, end);
            this.index = this.index - end;
        }
        return result;
    };
    Object.defineProperty(ProtocolBuffer.prototype, "numberOfBytes", {
        get: function () {
            return this.index;
        },
        enumerable: true,
        configurable: true
    });
    return ProtocolBuffer;
}());
(function (ReaderType) {
    ReaderType[ReaderType["Length"] = 0] = "Length";
    ReaderType[ReaderType["Line"] = 1] = "Line";
})(exports.ReaderType || (exports.ReaderType = {}));
var ReaderType = exports.ReaderType;
var Reader = (function () {
    function Reader(readable, callback, type) {
        var _this = this;
        if (type === void 0) { type = ReaderType.Length; }
        this.readable = readable;
        this.buffer = new ProtocolBuffer();
        this.callback = callback;
        this.nextMessageLength = -1;
        if (type === ReaderType.Length) {
            this.readable.on('data', function (data) {
                _this.onLengthData(data);
            });
        }
        else if (type === ReaderType.Line) {
            this.readable.on('data', function (data) {
                _this.onLineData(data);
            });
        }
    }
    Reader.prototype.onLengthData = function (data) {
        this.buffer.append(data);
        while (true) {
            if (this.nextMessageLength === -1) {
                this.nextMessageLength = this.buffer.tryReadContentLength();
                if (this.nextMessageLength === -1) {
                    return;
                }
            }
            var msg = this.buffer.tryReadContent(this.nextMessageLength);
            if (msg === null) {
                return;
            }
            this.nextMessageLength = -1;
            var json = JSON.parse(msg);
            this.callback(json);
        }
    };
    Reader.prototype.onLineData = function (data) {
        this.buffer.append(data);
        while (true) {
            var msg = this.buffer.tryReadLine();
            if (msg === null) {
                return;
            }
            this.callback(JSON.parse(msg));
        }
    };
    return Reader;
}());
exports.Reader = Reader;
var Writer = (function () {
    function Writer(writable) {
        this.writable = writable;
    }
    Writer.prototype.write = function (msg) {
        var json = JSON.stringify(msg);
        var buffer = [
            ContentLength,
            Buffer.byteLength(json, 'utf8').toString(),
            '\r\n\r\n',
            json,
            '\r\n'
        ];
        this.writable.write(buffer.join(''), 'utf8');
    };
    return Writer;
}());
exports.Writer = Writer;
//# sourceMappingURL=wireProtocol.js.map