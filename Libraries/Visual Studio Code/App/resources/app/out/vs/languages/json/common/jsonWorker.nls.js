define("vs/languages/json/common/jsonWorker.nls",{"vs/languages/json/common/contributions/bowerJSONContribution":["Default bower.json","Request to the bower repository failed: {0}","Request to the bower repository failed: {0}","{0}"],"vs/languages/json/common/contributions/globPatternContribution":["Files by Extension","Match all files of a specific file extension.","Files with Multiple Extensions","Match all files with any of the file extensions.","Files with Siblings by Name","Match files that have siblings with the same name but a different extension.","Folder by Name (Top Level)","Match a top level folder with a specific name.","Folders with Multiple Names (Top Level)","Match multiple top level folders.","Folder by Name (Any Location)","Match a folder with a specific name in any location.","True","Enable the pattern.","False","Disable the pattern.","Files with Siblings by Name","Match files that have siblings with the same name but a different extension."],"vs/languages/json/common/contributions/packageJSONContribution":["Default package.json","Request to the NPM repository failed: {0}","Request to the NPM repository failed: {0}","The currently latest version of the package","Matches the most recent major version (1.x.x)","Matches the most recent minor version (1.2.x)","{0}","Latest version: {0}"],"vs/languages/json/common/contributions/projectJSONContribution":["Default project.json","Request to the nuget repository failed: {0}","Request to the nuget repository failed: {0}","The currently latest version of the package","{0}","Latest version: {0}"],"vs/languages/json/common/jsonIntellisense":["Default value"],"vs/languages/json/common/jsonSchemaService":["Unable to load schema from '{0}': No content.","Unable to parse content from '{0}': {1}.","Unable to load schema from '{0}': {1}.","$ref '{0}' in {1} can not be resolved.","Problems loading reference '{0}': {1}.","Describes a JSON file using a schema. See json-schema.org for more info.","A unique identifier for the schema.","The schema to verify this document against ","A descriptive title of the element","A long description of the element. Used in hover menus and suggestions.","A default value. Used by suggestions.","A number that should cleanly divide the current value (i.e. have no remainder)","The maximum numerical value, inclusive by default.","Makes the maximum property exclusive.","The minimum numerical value, inclusive by default.","Makes the minimum property exclusive.","The maximum length of a string.","The minimum length of a string.","A regular expression to match the string against. It is not implicitly anchored.","For arrays, only when items is set as an array. If it is a schema, then this schema validates items after the ones specified by the items array. If it is false, then additional items will cause validation to fail.","For arrays. Can either be a schema to validate every element against or an array of schemas to validate each item against in order (the first schema will validate the first element, the second schema will validate the second element, and so on.","The maximum number of items that can be inside an array. Inclusive.","The minimum number of items that can be inside an array. Inclusive.","If all of the items in the array must be unique. Defaults to false.","The maximum number of properties an object can have. Inclusive.","The minimum number of properties an object can have. Inclusive.","An array of strings that lists the names of all properties required on this object.","Either a schema or a boolean. If a schema, then used to validate all properties not matched by 'properties' or 'patternProperties'. If false, then any properties not matched by either will cause this schema to fail.","Not used for validation. Place subschemas here that you wish to reference inline with $ref","A map of property names to schemas for each property.","A map of regular expressions on property names to schemas for matching properties.","A map of property names to either an array of property names or a schema. An array of property names means the property named in the key depends on the properties in the array being present in the object in order to be valid. If the value is a schema, then the schema is only applied to the object if the property in the key exists on the object.","The set of literal values that are valid","Either a string of one of the basic schema types (number, integer, null, array, object, boolean, string) or an array of strings specifying a subset of those types.","An array of schemas, all of which must match.","An array of schemas, where at least one must match.","An array of schemas, exactly one of which must match.","A schema which must not match.","JSON schema for ASP.NET project.json files","Compilation options that are passed through to Roslyn","The version of the dependency.","The type of the dependency. 'build' dependencies only exist at build time","The dependencies of the application. Each entry specifes the name and the version of a Nuget package.","A command line script or scripts.\r\rAvailable variables:\r%project:Directory% - The project directory\r%project:Name% - The project name\r%project:Version% - The project version","The author of the application","List of files to exclude from publish output (kpm bundle).","Glob pattern to specify all the code files that needs to be compiled. (data type: string or array with glob pattern(s)). Example: [ 'Folder1\\*.cs', 'Folder2\\*.cs' ]","Commands that are available for this application","Configurations are named groups of compilation settings. There are 2 defaults built into the runtime namely 'Debug' and 'Release'.","The description of the application","Glob pattern to indicate all the code files to be excluded from compilation. (data type: string or array with glob pattern(s)).","Target frameworks that will be built, and dependencies that are specific to the configuration.","Glob pattern to indicate all the code files to be preprocessed. (data type: string with glob pattern).","Glob pattern to indicate all the files that need to be compiled as resources.","Scripts to execute during the various stages.","Glob pattern to specify the code files to share with dependent projects. Example: [ 'Folder1\\*.cs', 'Folder2\\*.cs' ]","The version of the application. Example: 1.2.0.0","Specifying the webroot property in the project.json file specifies the web server root (aka public folder). In visual studio, this folder will be used to root IIS. Static files should be put in here.","JSON schema for Bower configuration files","Any property starting with _ is valid.","The name of your package.","Help users identify and search for your package with a brief description.","A semantic version number.","The primary acting files necessary to use your package.","SPDX license identifier or path/url to a license.","A list of files for Bower to ignore when installing your package.","Used for search by keyword. Helps make your package easier to discover without people needing to know its name.","A list of people that authored the contents of the package.","URL to learn more about the package. Falls back to GitHub project if not specified and it's a GitHub endpoint.","The repository in which the source code can be found.","Dependencies are specified with a simple hash of package name to a semver compatible identifier or URL.","Dependencies that are only needed for development of the package, e.g., test framework or building documentation.","Dependency versions to automatically resolve with if conflicts occur between packages.","If you set it to  true  it will refuse to publish it. This is a way to prevent accidental publication of private repositories.","Used by grunt-bower-task to specify custom install locations.","The types of modules this package exposes","NPM configuration for this package.","A person who has been involved in creating or maintaining this package","Dependencies are specified with a simple hash of package name to version range. The version range is a string which has one or more space-separated descriptors. Dependencies can also be identified with a tarball or git URL.","Any property starting with _ is valid.","The name of the package.","Version must be parseable by node-semver, which is bundled with npm as a dependency.","This helps people discover your package, as it's listed in 'npm search'.","This helps people discover your package as it's listed in 'npm search'.","The url to the project homepage.","The url to your project's issue tracker and / or the email address to which issues should be reported. These are helpful for people who encounter issues with your package.","The url to your project's issue tracker.","The email address to which issues should be reported.","You should specify a license for your package so that people know how they are permitted to use it, and any restrictions you're placing on it.","You should specify a license for your package so that people know how they are permitted to use it, and any restrictions you're placing on it.","A list of people who contributed to this package.","A list of people who maintains this package.","The 'files' field is an array of files to include in your project. If you name a folder in the array, then it will also include the files inside that folder.","The main field is a module ID that is the primary entry point to your program.","Specify either a single file or an array of filenames to put in place for the man program to find.","If you specify a 'bin' directory, then all the files in that folder will be used as the 'bin' hash.","Put markdown files in here. Eventually, these will be displayed nicely, maybe, someday.","Put example scripts in here. Someday, it might be exposed in some clever way.","Tell people where the bulk of your library is. Nothing special is done with the lib folder in any way, but it's useful meta info.","A folder that is full of man pages. Sugar to generate a 'man' array by walking the folder.","Specify the place where your code lives. This is helpful for people who want to contribute.","The 'scripts' member is an object hash of script commands that are run at various times in the lifecycle of your package. The key is the lifecycle event, and the value is the command to run at that point.","A 'config' hash can be used to set configuration parameters used in package scripts that persist across upgrades.","Array of package names that will be bundled when publishing the package.","Array of package names that will be bundled when publishing the package.","If your package is primarily a command-line application that should be installed globally, then set this value to true to provide a warning if it is installed locally.","If set to true, then npm will refuse to publish it.","JSON schema for the ASP.NET global configuration files","A list of project folders relative to this file.","A list of source folders relative to this file.","The runtime to use.","The runtime version to use.","The runtime to use, e.g. coreclr","The runtime architecture to use, e.g. x64.","JSON schema for the TypeScript compiler's configuration file","Instructs the TypeScript compiler how to compile .ts files","The character set of the input files","Generates corresponding d.ts files.","Show diagnostic information.","Emit a UTF-8 Byte Order Mark (BOM) in the beginning of output files.","Emit a single file with source maps instead of having a separate file.","Emit the source alongside the sourcemaps within a single file; requires --inlineSourceMap to be set.","Print names of files part of the compilation.","The locale to use to show error messages, e.g. en-us.","Specifies the location where debugger should locate map files instead of generated locations","Specify module code generation: 'CommonJS', 'Amd', 'System', or 'UMD'.","Specifies the end of line sequence to be used when emitting files: 'CRLF' (dos) or 'LF' (unix).)","Do not emit output.","Do not emit outputs if any type checking errors were reported.","Do not generate custom helper functions like __extends in compiled output.","Warn on expressions and declarations with an implied 'any' type.","Do not include the default library file (lib.d.ts).","Do not add triple-slash references or module import targets to the list of compiled files.","Concatenate and emit output to single file.","Redirect output structure to the directory.","Do not erase const enum declarations in generated code.","Do not emit comments to output.","Specifies the root directory of input files. Use to control the output directory structure with --outDir.","Generates corresponding '.map' file.","Specifies the location where debugger should locate TypeScript files instead of source locations.","Suppress noImplicitAny errors for indexing objects lacking index signatures.","Specify ECMAScript target version:  'ES3' (default), 'ES5', or 'ES6' (experimental).","Watch input files.","Enable the JSX option (requires TypeScript 1.6):  'preserve', 'react'.","Emits meta data.for ES7 decorators.","Supports transpiling single TS files into JS files.","Enables experimental support for ES7 decorators.","Enables experimental support for async functions (requires TypeScript 1.6).","If no 'files' property is present in a tsconfig.json, the compiler defaults to including all files the containing directory and subdirectories. When a 'files' property is specified, only those files are included.","JSON schema for the JavaScript configuration file","Instructs the JavaScript language service how to validate .js files","The character set of the input files","Show diagnostic information.","The locale to use to show error messages, e.g. en-us.","Specifies the location where debugger should locate map files instead of generated locations","Module code generation to resolve against: 'commonjs', 'amd', 'system', or 'umd'.","Do not include the default library file (lib.d.ts).","Specify ECMAScript target version:  'ES3' (default), 'ES5', or 'ES6' (experimental).","Enables experimental support for ES7 decorators.","If no 'files' property is present in a jsconfig.json, the language service defaults to including all files the containing directory and subdirectories. When a 'files' property is specified, only those files are included.","List files and folders that should not be included. This property is not honored when the 'files' property is present."],"vs/languages/json/common/parser/jsonParser":["Incorrect type. Expected one of {0}",'Incorrect type. Expected "{0}"',"Matches a schema that is not allowed.","Matches multiple schemas when only one must validate.","Value is not an accepted value. Valid values: {0}","Array has too many items according to schema. Expected {0} or fewer","Array has too few items. Expected {0} or more","Array has too many items. Expected {0} or fewer","Array has duplicate items","Value is not divisible by {0}","Value is below the exclusive minimum of {0}","Value is below the minimum of {0}","Value is above the exclusive maximum of {0}","Value is above the maximum of {0}","String is shorter than the minimum length of ","String is shorter than the maximum length of ",'String does not match the pattern of "{0}"','Missing property "{0}"',"Property {0} is not allowed","Object has more properties than limit of {0}","Object has fewer properties than the required number of {0}","Object is missing property {0} required by property {1}","Invalid unicode sequence in string","Invalid escape character in string","Unexpected end of number","Unexpected end of comment","Unexpected end of string","Value expected","Expected comma or closing bracket","Property keys must be doublequoted","Duplicate object key","Colon expected","Value expected","Property expected","Expected comma or closing brace","Invalid number format","Invalid number format","Expected a JSON object, array or literal","End of file expected"]});