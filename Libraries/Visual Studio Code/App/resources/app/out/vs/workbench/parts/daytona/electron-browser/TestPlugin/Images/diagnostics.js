var Microsoft;!function(r){var n;!function(r){var n;!function(r){"use strict";function n(r,n,i,e,u){return u&&(r=u),t(r,n,i,[],e),o(),!0}function t(r,n,t,o,e){var u,l,a;if(r instanceof Error){u=r.message?r.message.toString():null;var s=o;if(r&&r.number&&"number"==typeof r.number&&(o="Error number: 0x"+(r.number>>>0).toString(16)+"\r\n"),o+="Stack: "+r.stack,s){var g=s.toString();g&&g.length>0&&(o+="\r\n\r\nAdditional Info: "+g)}}else u=r?r.toString():null,o=o?o.toString():null;return n=n?n.toString():null,l=t?t.toString():null,a=e?e.toString():null,i.reportError(u,n,l,o,a)}function o(){i.terminate()}var i=loadModule("plugin.host.diagnostics");r.onerror=n,window.onerror=n,r.reportError=t,r.terminate=o}(n=r.Diagnostics||(r.Diagnostics={}))}(n=r.Plugin||(r.Plugin={}))}(Microsoft||(Microsoft={}));