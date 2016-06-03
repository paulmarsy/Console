/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
function stripComments(e){var a=/("(?:[^\\\"]*(?:\\.)?)*")|('(?:[^\\\']*(?:\\.)?)*')|(\/\*(?:\r?\n|.)*?\*\/)|(\/{2,}.*?(?:(?:\r?\n)|$))/g,r=e.replace(a,function(e,a,r,n,s){if(n)return"";if(s){var t=s.length;return t>2&&"\n"===s[t-1]?"\r"===s[t-2]?"\r\n":"\n":""}return e});return r}function getNLSConfiguration(){for(var e=void 0,a="--locale",r=0;r<process.argv.length;r++){var n=process.argv[r];if(n.slice(0,a.length)==a){var s=n.split("=");e=s[1];break}}if(!e){var t=app.getPath("userData");if(localeConfig=path.join(t,"User","locale.json"),fs.existsSync(localeConfig))try{var o=stripComments(fs.readFileSync(localeConfig,"utf8"));value=JSON.parse(o).locale,value&&"string"==typeof value&&(e=value)}catch(p){}}if(e=e||app.getLocale(),e=e?e.toLowerCase():e,"pseudo"===e)return{locale:e,availableLanguages:{},pseudo:!0};var i=e;if(process.env.VSCODE_DEV)return{locale:e,availableLanguages:{}};for(;e;){var l=path.join(__dirname,"vs","workbench","electron-main","main.nls.")+e+".js";if(fs.existsSync(l))return{locale:i,availableLanguages:{"*":e}};var c=e.lastIndexOf("-");e=c>0?e.substring(0,c):null}return{locale:i,availableLanguages:{}}}global.vscodeStart=Date.now();var app=require("electron").app,fs=require("fs"),path=require("path");try{"win32"===process.platform?(process.env.VSCODE_CWD=process.cwd(),process.chdir(path.dirname(app.getPath("exe")))):process.env.VSCODE_CWD&&process.chdir(process.env.VSCODE_CWD)}catch(err){console.error(err)}if(process.env.VSCODE_DEV){var appData=app.getPath("appData");app.setPath("userData",path.join(appData,"Code-Development"))}var args=process.argv;args.forEach(function(e){0===e.indexOf("--user-data-dir=")&&app.setPath("userData",e.split("=")[1])}),global.macOpenFiles=[],app.on("open-file",function(e,a){global.macOpenFiles.push(a)}),app.once("ready",function(){var e=getNLSConfiguration();process.env.VSCODE_NLS_CONFIG=JSON.stringify(e),require("./bootstrap-amd").bootstrap("vs/workbench/electron-main/main")});
//# sourceMappingURL=https://ticino.blob.core.windows.net/sourcemaps/def9e32467ad6e4f48787d38caf190acbfee5880/main.js.map