!function(){"use strict";window.TestObject=Microsoft.Plugin.Utilities.JSONMarshaler.attachToPublishedObject("TestObject",{roundtripObject:function(t){return this._call("roundtripObject",t)},roundtripInt:function(t){return this._call("roundtripInt",t)},roundtripDouble:function(t){return this._call("roundtripDouble",t)},roundtripString:function(t){return this._call("roundtripString",t)},roundtripDate:function(t){return this._call("roundtripDate",t)},roundtripDictionary:function(t){return this._call("roundtripDictionary",t)},raiseTestEvent:function(t){return this._call("raiseTestEvent",t)},postTestEvent:function(t){return this._post("postTestEvent",t)},causeException:function(){return this._call("causeException")},roundtripObjectAsync:function(t){return this._call("roundtripObjectAsync",t)},causeExceptionAsync:function(t){return this._call("causeExceptionAsync",t)}},!0)}();