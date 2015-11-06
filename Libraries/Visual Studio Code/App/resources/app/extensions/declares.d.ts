/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
/// <reference path="../src/vs/vscode.d.ts" />
/// <reference path="../src/typings/mocha.d.ts" />
/// <reference path="./node.d.ts" />

declare var define: {
	(moduleName: string, dependencies: string[], callback: (...args: any[]) => any): any;
	(moduleName: string, dependencies: string[], definition: any): any;
	(moduleName: string, callback: (...args: any[]) => any): any;
	(moduleName: string, definition: any): any;
	(dependencies: string[], callback: (...args: any[]) => any): any;
	(dependencies: string[], definition: any): any;
};

declare var require: {
	toUrl(path: string): string;
	(moduleName: string): any;
	(dependencies: string[], callback: (...args: any[]) => any, errorback?: (err: any) => void): any;
	config(data: any): any;
	onError: Function;
	__$__nodeRequire<T>(moduleName: string): T;
};

// Declaring the following because the code gets compiled with es5, which lack definitions for console and timers.
declare var console: {
    info(message?: any, ...optionalParams: any[]): void;
    profile(reportName?: string): void;
    assert(test?: boolean, message?: string, ...optionalParams: any[]): void;
    clear(): void;
    dir(value?: any, ...optionalParams: any[]): void;
    warn(message?: any, ...optionalParams: any[]): void;
    error(message?: any, ...optionalParams: any[]): void;
    log(message?: any, ...optionalParams: any[]): void;
    profileEnd(): void;
};

declare function clearTimeout(handle: number): void;
declare function setTimeout(handler: any, timeout?: any, ...args: any[]): number;
declare function clearInterval(handle: number): void;
declare function setInterval(handler: any, timeout?: any, ...args: any[]): number;

declare module 'vs/base/common/async' {

	import vscode = require('vscode');

	export interface ITask<T> {
		(): T;
	}

	export class Delayer<T> {

		public defaultDelay: number;

		constructor(defaultDelay: number);

		public trigger(task: ITask<T>, delay?: number): Thenable<T>;

		public isTriggered():boolean;

		public cancel(): void;
	}

	export class RunOnceScheduler {
		constructor(runner:()=>void, timeout:number);
		public dispose(): void;
		public cancel(): void;
		public schedule(): void;
	}
}

declare module 'vs/base/node/mono' {
	import vscode = require('vscode');
	export function hasMono(range?: string): Thenable<boolean>;
}

declare module 'vs/base/node/stdFork' {
	import cp = require('child_process');
	export interface IForkOpts {
		cwd?: string;
		env?: any;
		encoding?: string;
		execArgv?: string[];
	}
	export function fork(modulePath: string, args: string[], options: IForkOpts, callback:(error:any, cp:cp.ChildProcess)=>void): void;
}

declare module 'vs/nls' {
	export interface ILocalizeInfo {
		key:string;
		comment:string[];
	}

	export function localize(info:ILocalizeInfo, message:string, ...args:any[]):string;
	export function localize(key:string, message:string, ...args:any[]):string;
}


// Needed by TypeScript plugin to avoid code duplication
declare module 'vs/languages/lib/common/wireProtocol' {
	import stream = require('stream');
	export interface ICallback<T> {
		(data:T):void;
	}
	export enum ReaderType {
		Length = 0,
		Line = 1
	}
	export class Reader<T> {
		constructor(readable: stream.Readable, callback: ICallback<T>, type?: ReaderType);
	}
}

// Needed by the XML plugin to avoid code duplication
declare module 'vs/languages/lib/common/beautify-html' {
	export interface IBeautifyHTMLOptions {
	    indent_inner_html?: boolean; // indent <head> and <body> sections,
	    indent_size?: number; // indentation size,
	    indent_char?: string; // character to indent with,
	    wrap_line_length?: number; // (default 250) maximum amount of characters per line (0 = disable)
	    brace_style?: string; // (default "collapse") - "collapse" | "expand" | "end-expand" | "none"
	            			 // put braces on the same line as control statements (default), or put braces on own line (Allman / ANSI style), or just put end braces on own line, or attempt to keep them where they are.
	    unformatted?: string[]; // (defaults to inline tags) - list of tags, that shouldn't be reformatted
	    indent_scripts?: string; //  (default normal)  - "keep"|"separate"|"normal"
	    preserve_newlines?: boolean; // (default true) - whether existing line breaks before elements should be preserved. Only works before elements, not inside tags or for text.
	    max_preserve_newlines?: number; // (default unlimited) - maximum number of line breaks to be preserved in one chunk
	    indent_handlebars?: boolean; // (default false) - format and indent {{#foo}} and {{/foo}}
	    end_with_newline?: boolean; // (false)          - end with a newline
	    extra_liners?: string[]; // (default [head,body,/html]) -List of tags that should have an extra newline before them.
	}

	export interface IBeautifyHTML {
		(value:string, options:IBeautifyHTMLOptions): string;
	}

	export var html_beautify: IBeautifyHTML;
}

