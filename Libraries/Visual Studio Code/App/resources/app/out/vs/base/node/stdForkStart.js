/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
var net=require("net"),fs=require("fs"),stream=require("stream"),util=require("util"),ENABLE_LOGGING=!1,log=function(){if(!ENABLE_LOGGING)return function(){};var e=!0,r="C:\\stdFork.log";return function(n){return e?(e=!1,void fs.writeFileSync(r,n+"\n")):void fs.appendFileSync(r,n+"\n")}}(),stdInPipeName=process.env.STDIN_PIPE_NAME,stdOutPipeName=process.env.STDOUT_PIPE_NAME;log("STDIN_PIPE_NAME: "+stdInPipeName),log("STDOUT_PIPE_NAME: "+stdOutPipeName),log("ATOM_SHELL_INTERNAL_RUN_AS_NODE: "+process.env.ATOM_SHELL_INTERNAL_RUN_AS_NODE),function(){log("Beginning stdout redirection...");var e=net.connect(stdOutPipeName);e.unref(),process.__defineGetter__("stdout",function(){return e}),process.__defineGetter__("stderr",function(){return e});var r=function(e,r,t,s){var o=new Buffer(r,s||"utf8");return n(e,o,0,o.length)},n=function(r,n,t,s,o){t=Math.abs(0|t),s=Math.abs(0|s);var i=n.length;if(t>i)throw new Error("offset out of bounds");if(s>i)throw new Error("length out of bounds");if(t>(t+s|0))throw new Error("off + len overflow");if(s>i-t)throw new Error("off + len > buffer.length");var u=n;return(0!==t||s!==i)&&(u=n.slice(t,t+s)),e.write(u),u.length},t=fs.writeSync;fs.writeSync=function(e,s,o,i){return 1!==e?t.apply(fs,arguments):s instanceof Buffer?n.apply(null,arguments):("string"!=typeof s&&(s+=""),r.apply(null,arguments))},log("Finished defining process.stdout, process.stderr and fs.writeSync")}(),function(){var e=net.createServer(function(r){e.close(),log("Parent process has connected to my stdin. All should be good now."),process.__defineGetter__("stdin",function(){return r}),process.argv.splice(1,1);var n=process.argv[1];log("Loading program: "+n),delete process.env.STDIN_PIPE_NAME,delete process.env.STDOUT_PIPE_NAME,delete process.env.ATOM_SHELL_INTERNAL_RUN_AS_NODE,require(n),log("Finished loading program.");var t=!0,s=setInterval(function(){var e=r.listeners("data").length+r.listeners("end").length+r.listeners("close").length+r.listeners("error").length;1>=e?t&&(t=!1,r.unref()):t||(t=!0,r.ref())},1e3);s.unref()});e.listen(stdInPipeName,function(){process.stdout.write("ready")})}();