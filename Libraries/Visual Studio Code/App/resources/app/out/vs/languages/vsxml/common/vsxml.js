"use strict";var __extends=this&&this.__extends||function(t,e){function n(){this.constructor=t}for(var o in e)e.hasOwnProperty(o)&&(t[o]=e[o]);t.prototype=null===e?Object.create(e):(n.prototype=e.prototype,new n)};define("vs/languages/vsxml/common/vsxml",["require","exports","vs/base/common/objects","vs/base/common/errors","vs/editor/common/modes/abstractState"],function(t,e,n,o,a){var s='<>"=/',r="	 ",i=n.createKeywordMatcher(["summary","reference","returns","param","loc"]),p=n.createKeywordMatcher(["type","path","name","locid","filename","format","optional"]),u=n.createKeywordMatcher(s.split("")),c=function(t){function e(e,n,o){t.call(this,e),this.state=n,this.parentState=o}return __extends(e,t),e.prototype.getParentState=function(){return this.parentState},e.prototype.makeClone=function(){return new e(this.getMode(),a.AbstractState.safeClone(this.state),a.AbstractState.safeClone(this.parentState))},e.prototype.equals=function(n){return n instanceof e?t.prototype.equals.call(this,n)&&a.AbstractState.safeEquals(this.state,n.state)&&a.AbstractState.safeEquals(this.parentState,n.parentState):!1},e.prototype.setState=function(t){this.state=t},e.prototype.postTokenize=function(t,e){return t},e.prototype.tokenize=function(t){var e=this.state.tokenize(t);return void 0!==e.nextState&&this.setState(e.nextState),e.nextState=this,this.postTokenize(e,t)},e}(a.AbstractState);e.EmbeddedState=c;var l=function(t){function e(e,n,o){t.call(this,e,n,o)}return __extends(e,t),e.prototype.equals=function(n){return n instanceof e?t.prototype.equals.call(this,n):!1},e.prototype.setState=function(e){t.prototype.setState.call(this,e),this.getParentState().setVSXMLState(e)},e.prototype.postTokenize=function(t,e){return e.eos()&&(t.nextState=this.getParentState()),t},e}(c);e.VSXMLEmbeddedState=l;var h=function(t){function e(e,n,o,a){void 0===a&&(a=""),t.call(this,e),this.name=n,this.parent=o,this.whitespaceTokenType=a}return __extends(e,t),e.prototype.equals=function(n){return n instanceof e?t.prototype.equals.call(this,n)&&this.whitespaceTokenType===n.whitespaceTokenType&&this.name===n.name&&a.AbstractState.safeEquals(this.parent,n.parent):!1},e.prototype.tokenize=function(t){return t.setTokenRules(s,r),t.skipWhitespace().length>0?{type:this.whitespaceTokenType}:this.stateTokenize(t)},e.prototype.stateTokenize=function(t){throw o.notImplemented()},e}(a.AbstractState);e.VSXMLState=h;var f=function(t){function e(e,n){t.call(this,e,"string",n,"attribute.value.vs")}return __extends(e,t),e.prototype.makeClone=function(){return new e(this.getMode(),this.parent?this.parent.clone():null)},e.prototype.equals=function(n){return n instanceof e?t.prototype.equals.call(this,n):!1},e.prototype.stateTokenize=function(t){for(;!t.eos();){var e=t.nextToken();if('"'===e)return{type:"attribute.value.vs",nextState:this.parent}}return{type:"attribute.value.vs",nextState:this.parent}},e}(h);e.VSXMLString=f;var y=function(t){function e(e,n){t.call(this,e,"expression",n,"vs")}return __extends(e,t),e.prototype.makeClone=function(){return new e(this.getMode(),this.parent?this.parent.clone():null)},e.prototype.equals=function(n){return n instanceof e?t.prototype.equals.call(this,n):!1},e.prototype.stateTokenize=function(t){var e=t.nextToken(),n=this.whitespaceTokenType;return">"===e?{type:"delimiter.vs",nextState:this.parent}:'"'===e?{type:"attribute.value.vs",nextState:new f(this.getMode(),this)}:(i(e)?n="tag.vs":p(e)?n="attribute.name.vs":u(e)&&(n="delimiter.vs"),{type:n,nextState:this})},e}(h);e.VSXMLTag=y;var S=function(t){function e(e,n){t.call(this,e,"expression",n,"vs")}return __extends(e,t),e.prototype.makeClone=function(){return new e(this.getMode(),this.parent?this.parent.clone():null)},e.prototype.equals=function(n){return n instanceof e?t.prototype.equals.call(this,n):!1},e.prototype.stateTokenize=function(t){var e=t.nextToken();return"<"===e?{type:"delimiter.vs",nextState:new y(this.getMode(),this)}:{type:this.whitespaceTokenType,nextState:this}},e}(h);e.VSXMLExpression=S});