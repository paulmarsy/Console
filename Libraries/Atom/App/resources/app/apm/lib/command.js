(function() {
  var Command, child_process, config, path, semver, _,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __slice = [].slice;

  child_process = require('child_process');

  path = require('path');

  _ = require('underscore-plus');

  semver = require('npm/node_modules/semver');

  config = require('./apm');

  module.exports = Command = (function() {
    function Command() {
      this.logCommandResults = __bind(this.logCommandResults, this);
    }

    Command.prototype.spawn = function() {
      var args, callback, command, errorChunks, options, outputChunks, remaining, spawned;
      command = arguments[0], args = arguments[1], remaining = 3 <= arguments.length ? __slice.call(arguments, 2) : [];
      if (remaining.length >= 2) {
        options = remaining.shift();
      }
      callback = remaining.shift();
      spawned = child_process.spawn(command, args, options);
      errorChunks = [];
      outputChunks = [];
      spawned.stdout.on('data', function(chunk) {
        if (options != null ? options.streaming : void 0) {
          return process.stdout.write(chunk);
        } else {
          return outputChunks.push(chunk);
        }
      });
      spawned.stderr.on('data', function(chunk) {
        if (options != null ? options.streaming : void 0) {
          return process.stderr.write(chunk);
        } else {
          return errorChunks.push(chunk);
        }
      });
      spawned.on('error', function(error) {
        return callback(error, Buffer.concat(errorChunks).toString(), Buffer.concat(outputChunks).toString());
      });
      return spawned.on('close', function(code) {
        return callback(code, Buffer.concat(errorChunks).toString(), Buffer.concat(outputChunks).toString());
      });
    };

    Command.prototype.fork = function() {
      var args, remaining, script;
      script = arguments[0], args = arguments[1], remaining = 3 <= arguments.length ? __slice.call(arguments, 2) : [];
      args.unshift(script);
      return this.spawn.apply(this, [process.execPath, args].concat(__slice.call(remaining)));
    };

    Command.prototype.packageNamesFromArgv = function(argv) {
      return this.sanitizePackageNames(argv._);
    };

    Command.prototype.sanitizePackageNames = function(packageNames) {
      if (packageNames == null) {
        packageNames = [];
      }
      packageNames = packageNames.map(function(packageName) {
        return packageName.trim();
      });
      return _.compact(_.uniq(packageNames));
    };

    Command.prototype.logSuccess = function() {
      if (process.platform === 'win32') {
        return process.stdout.write('done\n'.green);
      } else {
        return process.stdout.write('\u2713\n'.green);
      }
    };

    Command.prototype.logFailure = function() {
      if (process.platform === 'win32') {
        return process.stdout.write('failed\n'.red);
      } else {
        return process.stdout.write('\u2717\n'.red);
      }
    };

    Command.prototype.logCommandResults = function(callback, code, stderr, stdout) {
      if (stderr == null) {
        stderr = '';
      }
      if (stdout == null) {
        stdout = '';
      }
      if (code === 0) {
        this.logSuccess();
        return callback();
      } else {
        this.logFailure();
        return callback(("" + stdout + "\n" + stderr).trim());
      }
    };

    Command.prototype.normalizeVersion = function(version) {
      if (typeof version === 'string') {
        return version.replace(/-.*$/, '');
      } else {
        return version;
      }
    };

    Command.prototype.loadInstalledAtomMetadata = function(callback) {
      return this.getResourcePath((function(_this) {
        return function(resourcePath) {
          var electronVersion, version, _ref, _ref1, _ref2, _ref3, _ref4;
          try {
            _ref1 = (_ref = require(path.join(resourcePath, 'package.json'))) != null ? _ref : {}, version = _ref1.version, electronVersion = _ref1.electronVersion;
            version = _this.normalizeVersion(version);
            if (semver.valid(version)) {
              _this.installedAtomVersion = version;
            }
          } catch (_error) {}
          _this.electronVersion = (_ref2 = (_ref3 = (_ref4 = process.env.ATOM_ELECTRON_VERSION) != null ? _ref4 : process.env.ATOM_NODE_VERSION) != null ? _ref3 : electronVersion) != null ? _ref2 : '0.22.0';
          return callback();
        };
      })(this));
    };

    Command.prototype.getResourcePath = function(callback) {
      if (this.resourcePath) {
        return process.nextTick((function(_this) {
          return function() {
            return callback(_this.resourcePath);
          };
        })(this));
      } else {
        return config.getResourcePath((function(_this) {
          return function(resourcePath) {
            _this.resourcePath = resourcePath;
            return callback(_this.resourcePath);
          };
        })(this));
      }
    };

    return Command;

  })();

}).call(this);
