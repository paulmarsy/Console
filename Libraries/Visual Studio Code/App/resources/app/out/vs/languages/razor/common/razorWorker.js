/*!--------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
var __extends=this&&this.__extends||function(o,t){function r(){this.constructor=o}for(var a in t)t.hasOwnProperty(a)&&(o[a]=t[a]);o.prototype=null===t?Object.create(t):(r.prototype=t.prototype,new r)};define("vs/languages/razor/common/razorWorker",["require","exports","vs/languages/html/common/htmlWorker"],function(o,t,r){"use strict";function a(){var o={a:["asp-action","asp-controller","asp-fragment","asp-host","asp-protocol","asp-route"],div:["asp-validation-summary"],form:["asp-action","asp-controller","asp-anti-forgery"],input:["asp-for","asp-format"],label:["asp-for"],select:["asp-for","asp-items"],span:["asp-validation-for"]};return{collectTags:function(o){},collectAttributes:function(t,r){if(t){var a=o[t];a&&a.forEach(function(o){return r(o,null)})}},collectValues:function(o,t,r){}}}t.getRazorTagProvider=a;var n=function(o){function t(){o.apply(this,arguments)}return __extends(t,o),t.prototype.addCustomTagProviders=function(o){o.push(a())},t}(r.HTMLWorker);t.RAZORWorker=n});
//# sourceMappingURL=https://ticino.blob.core.windows.net/sourcemaps/def9e32467ad6e4f48787d38caf190acbfee5880/vs\languages\razor\common\razorWorker.js.map
