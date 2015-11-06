/// <reference path="./applicationInsights.d.ts" />
define(["require", "exports", 'applicationinsights', 'vscode'], function (require, exports, ApplicationInsights, vscode_1) {
    var TelemetryReporter = (function () {
        function TelemetryReporter(extensionId, key) {
            var _this = this;
            this.extensionId = extensionId;
            this.appInsightsClient = ApplicationInsights.setup(key)
                .setAutoCollectRequests(false)
                .setAutoCollectPerformance(false)
                .setAutoCollectExceptions(false)
                .setOfflineMode(true)
                .start()
                .client;
            //prevent AI from reporting PII
            this.setupAIClient(this.appInsightsClient);
            //check if it's an Asimov key to change the endpoint
            if (key && key.indexOf('AIF-') === 0) {
                this.appInsightsClient.config.endpointUrl = "https://vortex.data.microsoft.com/collect/v1";
            }
            vscode_1.extensions.getTelemetryInfo().then(function (info) { return _this.loadCommonProperties(info); });
        }
        TelemetryReporter.setupTelemetryReporter = function (extensionId, key) {
            if (TelemetryReporter._reporter) {
                throw new Error('setup was already called');
            }
            TelemetryReporter._reporter = new TelemetryReporter(extensionId, key);
            return TelemetryReporter._reporter;
        };
        TelemetryReporter.getTelemetryReporter = function () {
            if (!TelemetryReporter._reporter) {
                throw new Error('setupTelemetryReporter was not called, setup a reporter before using it');
            }
            return TelemetryReporter._reporter;
        };
        TelemetryReporter.prototype.setupAIClient = function (client) {
            if (client && client.context &&
                client.context.keys && client.context.tags) {
                var machineNameKey = client.context.keys.deviceMachineName;
                client.context.tags[machineNameKey] = '';
            }
        };
        TelemetryReporter.prototype.loadCommonProperties = function (info) {
            this.commonProperties = Object.create(null);
            this.commonProperties['machineId'] = info.machineId;
            this.commonProperties['sessionId'] = info.sessionId;
            this.commonProperties['instanceId'] = info.instanceId;
        };
        TelemetryReporter.prototype.addCommonProperties = function (properties) {
            for (var prop in this.commonProperties) {
                properties['common.' + prop] = this.commonProperties[prop];
            }
            return properties;
        };
        TelemetryReporter.prototype.sendTelemetryEvent = function (eventName, properties, measures) {
            if (eventName) {
                properties = properties || Object.create(null);
                properties = this.addCommonProperties(properties);
                this.appInsightsClient.trackEvent(this.extensionId + '/' + eventName, properties, measures);
            }
        };
        TelemetryReporter._reporter = null;
        return TelemetryReporter;
    })();
    exports.TelemetryReporter = TelemetryReporter;
});
//# sourceMappingURL=telemetryReporter.js.map