/*---------------------------------------------------------------------------------------------
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *---------------------------------------------------------------------------------------------*/
define("vs/workbench/electron-main/sharedProcessMain.nls.de",{"vs/base/common/errors":["{0}. Fehlercode: {1}","Berechtigung verweigert (HTTP {0})","Berechtigung verweigert","{0} (HTTP {1}: {2})","{0} (HTTP {1})","Unbekannter Verbindungsfehler ({0})","Es ist ein unbekannter Verbindungsfehler aufgetreten. Entweder besteht keine Internetverbindung mehr, oder der verbundene Server ist offline.","{0}: {1}","Ein unbekannter Fehler ist aufgetreten. Weitere Details dazu finden Sie im Protokoll.","Systemfehler ({0})","Ein unbekannter Fehler ist aufgetreten. Weitere Details dazu finden Sie im Protokoll.","{0} ({1} Fehler gesamt)","Ein unbekannter Fehler ist aufgetreten. Weitere Details dazu finden Sie im Protokoll.","Nicht implementiert","ungültiges Argument: {0}","ungültiges Argument","ungültiger Status: {0}","ungültiger Status","Eine erforderliche Datei konnte nicht geladen werden. Entweder sind Sie nicht mehr mit dem Internet verbunden oder der verbundene Server ist offline. Aktualisieren Sie den Browser, und wiederholen Sie den Vorgang.","Fehler beim Laden einer erforderlichen Datei. Bitte starten Sie die Anwendung neu, und versuchen Sie es dann erneut. Details: {0}"],"vs/base/common/json":["Ungültiges Symbol","Ungültiges Zahlenformat","Eigenschaftsname erwartet","Wert erwartet","Doppelpunkt erwartet","Wert erwartet","Komma erwartet","Wert erwartet","Schließende geschweifte Klammer erwartet","Wert erwartet","Komma erwartet","Wert erwartet","Schließende Klammer erwartet","Wert erwartet","Inhaltsende erwartet"],"vs/base/common/severity":["Fehler","Warnung","Info"],"vs/base/node/zip":["{0} wurde im ZIP nicht gefunden."],"vs/platform/configuration/common/configurationRegistry":["Trägt Konfigurationseigenschaften bei.","Eine Zusammenfassung der Einstellungen. Diese Bezeichnung wird in der Einstellungsdatei als trennender Kommentar verwendet.","Die Beschreibung der Konfigurationseigenschaften.",'Wenn eine Festlegung erfolgt, muss "configuration.type" auf "object" festgelegt werden.',"configuration.title muss eine Zeichenfolge sein.",'"configuration.properties" muss ein Objekt sein.'],"vs/platform/extensions/common/extensionsRegistry":["Es wurde eine leere Extensionbeschreibung abgerufen.",'Die Eigenschaft "{0}" ist erforderlich. Sie muss vom Typ "string" sein.','Die Eigenschaft "{0}" ist erforderlich. Sie muss vom Typ "string" sein.','Die Eigenschaft "{0}" ist erforderlich. Sie muss vom Typ "string" sein.','Die Eigenschaft "{0}" ist erforderlich und muss vom Typ "object" sein.','Die Eigenschaft "{0}" ist erforderlich. Sie muss vom Typ "string" sein.','Die Eigenschaft "{0}" kann ausgelassen werden oder muss vom Typ "string[]" sein.','Die Eigenschaft "{0}" kann ausgelassen werden oder muss vom Typ "string[]" sein.','Die Eigenschaften "{0}" und "{1}" müssen beide angegeben oder beide ausgelassen werden.','Die Eigenschaft "{0}" kann ausgelassen werden oder muss vom Typ "string" sein.','Es wurde erwartet, dass "main" ({0}) im Ordner ({1}) der Extension enthalten ist. Dies führt ggf. dazu, dass die Extension nicht portierbar ist.','Die Eigenschaften "{0}" und "{1}" müssen beide angegeben oder beide ausgelassen werden.',"Der Anzeigename für die Extension, der im VS Code-Katalog verwendet wird.","Die vom VS Code-Katalog zum Kategorisieren der Extension verwendeten Kategorien.","Das in VS Code Marketplace verwendete Banner.","Die Bannerfarbe für die Kopfzeile der VS Code Marketplace-Seite.","Das Farbdesign für die Schriftart, die im Banner verwendet wird.","Der Herausgeber der VS Code-Extension.","Aktivierungsereignisse für die VS Code-Extension.","Abhängigkeiten von anderen Extensions. Die ID einer Extension ist immer ${publisher}.${name}, beispielsweise: vscode.csharp.","Ein Skript, das ausgeführt wird, bevor das Paket als VS Code-Extension veröffentlicht wird.","Alle Beiträge der VS Code-Extension, die durch dieses Paket dargestellt werden."],"vs/platform/extensions/node/extensionValidator":["Der engines.vscode-Wert {0} konnte nicht analysiert werden. Verwenden Sie z. B. ^0.10.0, ^1.2.3, ^0.11.0, ^0.10.x usw.",'Die in "engines.vscode" ({0}) angegebene Version ist nicht spezifisch genug. Definieren Sie für VS Code-Versionen vor Version 1.0.0 bitte mindestens die gewünschte Haupt- und Nebenversion, z. B. ^0.10.0, 0.10.x, 0.11.0 usw.','Die in "engines.vscode" ({0}) angegebene Version ist nicht spezifisch genug. Definieren Sie für VS Code-Versionen nach Version 1.0.0 bitte mindestens die gewünschte Hauptversion, z. B. ^1.10.0, 1.10.x, 1.x.x, 2.x.x usw.',"Die Extension ist nicht mit dem Code {0} kompatibel. Die Extension erfordert {1}.",'Die Extensionversion ist nicht mit "semver" kompatibel.'],"vs/platform/jsonschemas/common/jsonContributionRegistry":['Beschreibt eine JSON-Datei mithilfe eines Schemas. Weitere Informationen finden Sie unter "json-schema.org".',"Ein eindeutiger Bezeichner für das Schema.","Das Schema, anhand dessen das Dokument überprüft wird. ","Ein beschreibender Titel des Elements.","Eine lange Beschreibung des Elements. Wird in Hovermenüs verwendet sowie in Vorschlägen.","Ein Standardwert. Wird von Vorschlägen verwendet.","Eine Zahl, die den aktuellen Wert glatt teilen sollte (d. h. ohne Rest)","Der maximale numerische Wert, standardmäßig inklusiv.","Definiert die maximum-Eigenschaft als exklusiv.","Der minimale numerische Wert, standardmäßig inklusiv.","Definiert die minimum-Eigenschaft als exklusiv.","Die maximale Länge einer Zeichenfolge.","Die minimale Länge einer Zeichenfolge.","Ein regulärer Ausdruck, mit dem die Zeichenfolge verglichen wird. Er ist nicht implizit verankert.",'Für Arrays. Gilt nur, wenn "items" als Array festgelegt ist. Wenn es sich um ein Schema handelt, überprüft dieses Schema Elemente nach den vom Elementarray angegebenen Elementen. Wenn der Wert "false" ist, führen zusätzliche Elemente zu Validierungsfehlern.',"Für Arrays. Kann ein Schema sein, anhand dessen jedes Element überprüft wird, oder ein Array von Schemas, anhand dessen jedes Element in der Reihenfolge überprüft wird (das erste Schema überprüft das erste Element, das zweite Schema überprüft das zweite Element usw.).","Die maximale Anzahl von Elementen, die sich innerhalb eines Arrays befinden können. Inklusiv.","Die minimale Anzahl von Elementen, die sich in einem Array befinden können. Inklusiv.",'Gibt an, dass alle Elemente im Array eindeutig sein müssen. Der Standardwert ist "false".',"Die maximale Anzahl von Eigenschaften, die ein Objekt haben kann. Inklusiv.","Die minimale Anzahl von Eigenschaften, die ein Objekt haben kann. Inklusiv.","Ein Array von Zeichenfolgen, das die Namen aller für dieses Objekt erforderlichen Eigenschaften auflistet.",'Ein Schema oder ein boolescher Wert. Wenn es sich um ein Schema handelt, werden alle Eigenschaften überprüft, die nicht mit "Properties" oder "PatternProperties" übereinstimmen. Wenn "false", bewirken alle Eigenschaften, die mit keiner dieser Angaben übereinstimmen, einen Schemafehler.',"Nicht für Überprüfungen verwendet. Platzieren Sie hier Teilschemas, auf die Sie inline mit $ref verweisen möchten.","Eine Zuordnung von Eigenschaftennamen zu Schemas für jede Eigenschaft.","Eine Zuordnung von regulären Ausdrücken für Eigenschaftennamen zu Schemas zum Vergleichen von Eigenschaften.","Eine Zuordnung von Eigenschaftennamen zu einem Array von Eigenschaftennamen oder zu einem Schema. Ein Array von Eigenschaftennamen bedeutet, dass die Gültigkeit der im Schlüssel benannten Eigenschaft davon abhängt, ob die Eigenschaften im Array des Objekts vorhanden sind. Wenn der Wert ein Schema ist, wird dieses Schema nur dann auf das Objekt angewendet, wenn die Eigenschaft im Schlüssel für das Objekt vorhanden ist.","Die Sammlung der gültigen Literalwerte.",'Eine Zeichenfolge eines der grundlegenden Schematypen ("number", "integer", "null", "array", "object", "boolean", "string") oder ein Array aus Zeichenfolgen, das eine Teilmenge dieser Typen angibt.',"Beschreibt das Format, das für den Wert erwartet wird.","Ein Array von Schemas, die alle übereinstimmen müssen.","Ein Array von Schemas, von denen mindestens ein Schema übereinstimmen muss.","Ein Array von Schemas, von denen genau ein Schema übereinstimmen muss.","Ein Schema, das nicht übereinstimmen darf."],"vs/workbench/parts/extensions/common/extensions":["Extensions"],"vs/workbench/parts/extensions/node/extensionsService":['Die Extension ist ungültig: "package.json" ist keine JSON-Datei.',"Die Extension ist ungültig: Manifestnamenkonflikt.","Die Extension ist ungültig: Manifestherausgeberkonflikt.","Die Extension ist ungültig: Manifestversionskonflikt.","Bitte starten Sie Code vor der Neuinstallation von {0} neu.","Kataloginformationen fehlen.","Eine kompatible Version von {0} mit dieser Version des Codes wurde nicht gefunden.","Die Extension wurde nicht gefunden."],"vs/workbench/services/request/node/requestService":["Die Datei wurde nicht gefunden.","HTTP-Konfiguration",'Die zu verwendende Proxyeinstellung. Wenn diese Option nicht festgelegt wird, wird der Wert aus den Umgebungsvariablen "http_proxy" und "https_proxy" übernommen.',"Gibt an, ob das Proxyserverzertifikat anhand der Liste der bereitgestellten Zertifizierungsstellen überprüft werden soll."]});
//# sourceMappingURL=https://ticino.blob.core.windows.net/sourcemaps/fa6d0f03813dfb9df4589c30121e9fcffa8a8ec8/vs\workbench\electron-main\sharedProcessMain.nls.de.js.map
