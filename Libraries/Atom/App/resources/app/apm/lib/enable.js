(function() {
  var CSON, Command, Enable, config, path, yargs, _,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  _ = require('underscore-plus');

  path = require('path');

  CSON = require('season');

  yargs = require('yargs');

  config = require('./apm');

  Command = require('./command');

  module.exports = Enable = (function(_super) {
    __extends(Enable, _super);

    function Enable() {
      return Enable.__super__.constructor.apply(this, arguments);
    }

    Enable.commandNames = ['enable'];

    Enable.prototype.parseOptions = function(argv) {
      var options;
      options = yargs(argv).wrap(100);
      options.usage("\nUsage: apm enable [<package_name>]...\n\nEnables the named package(s).");
      return options.alias('h', 'help').describe('help', 'Print this usage message');
    };

    Enable.prototype.run = function(options) {
      var callback, configFilePath, disabledPackages, error, errorPackages, keyPath, packageNames, result, settings, _ref;
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
      keyPath = '*.core.disabledPackages';
      disabledPackages = (_ref = _.valueForKeyPath(settings, keyPath)) != null ? _ref : [];
      errorPackages = _.difference(packageNames, disabledPackages);
      if (errorPackages.length > 0) {
        console.log("Not Disabled:\n  " + (errorPackages.join('\n  ')));
      }
      packageNames = _.difference(packageNames, errorPackages);
      if (packageNames.length === 0) {
        callback("Please specify a package to enable");
        return;
      }
      result = _.difference(disabledPackages, packageNames);
      _.setValueForKeyPath(settings, keyPath, result);
      try {
        CSON.writeFileSync(configFilePath, settings);
      } catch (_error) {
        error = _error;
        callback("Failed to save `" + configFilePath + "`: " + error.message);
        return;
      }
      console.log("Enabled:\n  " + (packageNames.join('\n  ')));
      this.logSuccess();
      return callback();
    };

    return Enable;

  })(Command);

}).call(this);
