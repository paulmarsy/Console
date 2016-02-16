(function() {
  var CSON, Command, Disable, List, config, path, yargs, _,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  _ = require('underscore-plus');

  path = require('path');

  CSON = require('season');

  yargs = require('yargs');

  config = require('./apm');

  Command = require('./command');

  List = require('./list');

  module.exports = Disable = (function(_super) {
    __extends(Disable, _super);

    function Disable() {
      return Disable.__super__.constructor.apply(this, arguments);
    }

    Disable.commandNames = ['disable'];

    Disable.prototype.parseOptions = function(argv) {
      var options;
      options = yargs(argv).wrap(100);
      options.usage("\nUsage: apm disable [<package_name>]...\n\nDisables the named package(s).");
      return options.alias('h', 'help').describe('help', 'Print this usage message');
    };

    Disable.prototype.getInstalledPackages = function(callback) {
      var lister, options;
      options = {
        argv: {
          theme: false,
          bare: true
        }
      };
      lister = new List();
      return lister.listBundledPackages(options, function(error, core_packages) {
        return lister.listDevPackages(options, function(error, dev_packages) {
          return lister.listUserPackages(options, function(error, user_packages) {
            return callback(null, core_packages.concat(dev_packages, user_packages));
          });
        });
      });
    };

    Disable.prototype.run = function(options) {
      var callback, configFilePath, error, packageNames, settings;
      callback = options.callback;
      options = this.parseOptions(options.commandArgs);
      packageNames = this.packageNamesFromArgv(options.argv);
      configFilePath = CSON.resolve(path.join(config.getAtomDirectory(), 'config'));
      if (!configFilePath) {
        callback("Could not find config.cson. Run Atom first?");
        return;
      }
      try {
        settings = CSON.readFileSync(configFilePath);
      } catch (_error) {
        error = _error;
        callback("Failed to load `" + configFilePath + "`: " + error.message);
        return;
      }
      return this.getInstalledPackages((function(_this) {
        return function(error, installedPackages) {
          var disabledPackages, installedPackageNames, keyPath, pkg, result, uninstalledPackageNames, _ref;
          if (error) {
            return callback(error);
          }
          installedPackageNames = (function() {
            var _i, _len, _results;
            _results = [];
            for (_i = 0, _len = installedPackages.length; _i < _len; _i++) {
              pkg = installedPackages[_i];
              _results.push(pkg.name);
            }
            return _results;
          })();
          uninstalledPackageNames = _.difference(packageNames, installedPackageNames);
          if (uninstalledPackageNames.length > 0) {
            console.log("Not Installed:\n  " + (uninstalledPackageNames.join('\n  ')));
          }
          packageNames = _.difference(packageNames, uninstalledPackageNames);
          if (packageNames.length === 0) {
            callback("Please specify a package to disable");
            return;
          }
          keyPath = '*.core.disabledPackages';
          disabledPackages = (_ref = _.valueForKeyPath(settings, keyPath)) != null ? _ref : [];
          result = _.union.apply(_, [disabledPackages].concat(__slice.call(packageNames)));
          _.setValueForKeyPath(settings, keyPath, result);
          try {
            CSON.writeFileSync(configFilePath, settings);
          } catch (_error) {
            error = _error;
            callback("Failed to save `" + configFilePath + "`: " + error.message);
            return;
          }
          console.log("Disabled:\n  " + (packageNames.join('\n  ')));
          _this.logSuccess();
          return callback();
        };
      })(this));
    };

    return Disable;

  })(Command);

}).call(this);
