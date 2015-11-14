"use strict";var __extends=this&&this.__extends||function(t,o){function e(){this.constructor=t}for(var r in o)o.hasOwnProperty(r)&&(t[r]=o[r]);t.prototype=null===o?Object.create(o):(e.prototype=o.prototype,new e)};define("vs/workbench/parts/output/browser/outputMode",["require","exports","vs/editor/common/modes/monarch/monarch","vs/editor/common/modes/monarch/monarchCompile","vs/platform/instantiation/common/descriptors"],function(t,o,e,r,n){o.language={displayName:"Log",name:"Log",defaultToken:"",ignoreCase:!0,tokenizer:{root:[[/^\[trace.*?\]|trace:?/,"debug-token.output"],[/^\[http.*?\]|http:?/,"debug-token.output"],[/^\[debug.*?\]|debug:?/,"debug-token.output"],[/^\[verbose.*?\]|verbose:?/,"debug-token.output"],[/^\[information.*?\]|information:?/,"info-token.output"],[/^\[info.*?\]|info:?/,"info-token.output"],[/^\[warning.*?\]|warning:?/,"warn-token.output"],[/^\[warn.*?\]|warn:?/,"warn-token.output"],[/^\[error.*?\]|error:?/,"error-token.output"],[/^\[fatal.*?\]|fatal:?/,"error-token.output"]]}};var u=function(t){function e(e,u,a){t.call(this,e,u,a,r.compile(o.language),n.AsyncDescriptor.create("vs/workbench/parts/output/common/outputWorker","OutputWorker"))}return __extends(e,t),e}(e.MonarchMode);o.OutputMode=u});