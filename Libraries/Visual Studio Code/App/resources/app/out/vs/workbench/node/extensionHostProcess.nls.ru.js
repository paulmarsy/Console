/*---------------------------------------------------------------------------------------------
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *---------------------------------------------------------------------------------------------*/
define("vs/workbench/node/extensionHostProcess.nls.ru",{"vs/base/common/errors":["{0}. Код ошибки: {1}","Отказано в разрешении (HTTP {0})","Отказано в разрешении","{0} (HTTP {1}: {2})","{0} (HTTP {1})","Неизвестная ошибка подключения ({0})","Произошла неизвестная ошибка подключения. Утеряно подключение к Интернету, либо сервер, к которому вы подключены, перешел в автономный режим.","{0}: {1}","Произошла неизвестная ошибка. Подробные сведения см. в журнале.","Произошла системная ошибка ({0})","Произошла неизвестная ошибка. Подробные сведения см. в журнале.","{0} (всего ошибок: {1})","Произошла неизвестная ошибка. Подробные сведения см. в журнале.","Не реализовано","Недопустимый аргумент: {0}","Недопустимый аргумент","Недопустимое состояние: {0}","Недопустимое состояние","Сбой загрузки требуемого файла. Утеряно подключение к Интернету, либо сервер, к которому вы подключены, перешел в автономный режим. Обновите содержимое браузера, чтобы повторить попытку.","Не удалось загрузить требуемый файл. Перезапустите приложение, чтобы повторить попытку. Дополнительные сведения: {0}."],"vs/base/common/json":["Недопустимый символ","Недопустимый числовой формат","Требуется имя свойства","Требуется значение","Требуется двоеточие","Требуется значение","Требуется запятая","Требуется значение","Требуется закрывающая фигурная скобка","Требуется значение","Требуется запятая","Требуется значение","Требуется закрывающая скобка","Требуется значение","Требуется конец содержимого"],"vs/base/common/keyCodes":["Windows","Управление","SHIFT","ALT","COMMAND","Windows","CTRL","SHIFT","ALT","COMMAND","Windows"],"vs/base/common/severity":["Ошибка","Предупреждение","Сведения"],"vs/editor/common/config/defaultConfig":["Содержимое редактора"],"vs/editor/common/services/bulkEdit":["Следующие файлы были изменены: {0}"],"vs/platform/extensions/common/abstractExtensionService":['Не удалось активировать расширение "{1}". Причина: неизвестный зависимый компонент "{0}".','Не удалось активировать расширение "{1}". Причина: ошибка активации зависимого компонента "{0}".','Не удалось активировать расширение "{0}". Причина: более 10 уровней зависимостей (скорее всего, цикл зависимостей).','Ошибка активации расширения "{0}": {1}.'],"vs/platform/extensions/common/extensionsRegistry":["Пустое описание расширения",'свойство "{0}" является обязательным и должно иметь тип string','свойство "{0}" является обязательным и должно иметь тип string','свойство "{0}" является обязательным и должно иметь тип string','свойство "{0}" является обязательным и должно быть типа object','свойство "{0}" является обязательным и должно иметь тип string','свойство "{0}" может быть опущено или должно быть типа "string []"','свойство "{0}" может быть опущено или должно быть типа "string []"','оба свойства, "{0}" и "{1}", должны быть либо указаны, либо опущены','свойство "{0}" может быть опущено или должно иметь тип string',"Ожидается, что функция main ({0}) будет включена в папку расширения ({1}). Из-за этого расширение может стать непереносимым.",'оба свойства, "{0}" и "{1}", должны быть либо указаны, либо опущены',"Отображаемое имя расширения, используемого в коллекции VS Code.","Категории, используемые коллекцией VS Code для классификации расширения.","Баннер, используемый в магазине VS Code.","Цвет баннера в заголовке страницы магазина VS Code.","Цветовая тема для шрифта, используемого в баннере.","Издатель расширения VS Code.","События активации для расширения кода VS Code.","Зависимости от других расширений. Идентификатор расширения — всегда ${publisher}.${name}. Например, vscode.csharp.","Скрипт, выполняемый перед публикацией пакета в качестве расширения VS Code.","Все публикации расширения VS Code, представленные этим пакетом."],"vs/platform/extensions/node/extensionValidator":["Не удалось проанализировать значение engines.vscode {0}. Используйте, например, ^0.10.0, ^1.2.3, ^0.11.0, ^0.10.x и т. д.","Версия, указанная в engines.vscode ({0}), недостаточно конкретная. Для версий vscode до 1.0.0 укажите по крайней мере основной и дополнительный номер версии. Например, 0.10.0, 0.10.x, 0.11.0 и т. д.","Версия, указанная в engines.vscode ({0}), недостаточно конкретная. Для версий vscode после 1.0.0 укажите по крайней мере основной номер версии. Например, 1.10.0, 1.10.x, 1.x.x, 2.x.x и т. д.",'Расширение несовместимо с кодом "{0}". Расширению требуется: {1}.',"Версия расширения несовместима с semver."],"vs/platform/jsonschemas/common/jsonContributionRegistry":["Описывает JSON-файл с использованием схемы. Дополнительные сведения см. на веб-сайте json-schema.org.","Уникальный идентификатор схемы.","Схема, с использованием которой будет проверяться этот документ ","Описательное название элемента.","Длинное описание элемента. Используется в меню наведения и предложениях.","Значение по умолчанию. Используется предложениями.","Число, на которое должно делиться текущее значение без остатка.","Максимальное числовое значение, включенное по умолчанию.","Делает максимальное свойство эксклюзивным.","Минимальное числовое значение, по умолчанию — включительно.","Делает минимальное свойство эксклюзивным.","Максимальная длина строки.","Минимальная длина строки.","Регулярное выражение, с которым сопоставляется строка. Оно не является неявно прикрепленным.","Для массивов, только когда элементы заданы в виде массива. Если это схема, она проверяет элементы после тех, которые заданы массивом элементов. Если значение false, наличие дополнительных элементов вызывает сбой проверки.","Для массивов. Может являться схемой, относительно которой проверяется каждый элемент, или массивом схем, относительно которого проверяется каждый элемент по порядку (первая схема проверяет первый элемент, вторая схема проверяет второй элемент и так далее).","Максимальное число элементов, которые могут находиться внутри массива. Включительно.","Минимальное число элементов, которые могут находиться внутри массива. Включительно.","Если все элементы массива должны быть уникальными. По умолчанию имеет значение false.","Максимальное число свойств, которыми может обладать объект. Включительно.","Минимальное число свойств, которыми может обладать объект. Включительно.","Массив строк, содержащий имена всех свойств, необходимых в этом объекте.","Схема или логическое значение. Если это схема, она используется для проверки всех свойств, не совпадающих с параметром properties или patternProperties. Если значение false, любые свойства, не совпадающие ни с одним из этих параметров, вызывают сбой схемы.","Не используется для проверки. Поместите сюда вложенные схемы, на которые требуется создавать встроенные ссылки с помощью $ref.","Сопоставление имен свойств схемам для каждого свойства.","Сопоставление регулярных выражений в именах свойств схемам для соответствующих свойств.","Сопоставление имен свойств массиву имен свойств или схеме. Массив имен свойств в объекте используется для проверки допустимости свойства, именованного в ключе. Если значение — схема, эта схема применима к объекту только в том случае, если свойство, указанное в ключе, существует в объекте.","Набор допустимых значений литерала.","Строка одного из базовых типов схем (число, целое число, значение null, массив, объект, логическое значение, строка) или массив строк, задающий подмножество этих типов.","Описывает формат, требуемый для значения.","Массив схем, все из которых должны соответствовать.","Массив схем, хотя бы одна из которых должна соответствовать.","Массив схем, из которых должна соответствовать только одна.","Схема, которая не должна соответствовать."],"vs/platform/message/common/message":["Закрыть","Отмена"],"vs/workbench/api/node/extHostMessageService":["Закрыть"],"vs/workbench/node/extensionHostMain":["Идет перезапись расширения {0} на {1}.","Идет загрузка расширения разработки в {0}","Идет перезапись расширения {0} на {1}.",'Путь "{0}" не указывает на допустимый модуль выполнения тестов расширения.'],"vs/workbench/node/extensionPoints":["Не удалось проанализировать {0}: {1}.","Не удается прочитать файл {0}: {1}.","Не удалось проанализировать {0}: {1}.","Не удается прочитать файл {0}: {1}.","Не удалось найти сообщение для ключа {0}."],"vs/workbench/parts/extensions/common/extensions":["Расширения"]});
//# sourceMappingURL=https://ticino.blob.core.windows.net/sourcemaps/def9e32467ad6e4f48787d38caf190acbfee5880/vs\workbench\node\extensionHostProcess.nls.ru.js.map