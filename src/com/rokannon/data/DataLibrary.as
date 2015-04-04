package com.rokannon.data
{
    import com.rokannon.core.utils.clearDictionary;
    import com.rokannon.core.utils.isDictionaryEmpty;
    import com.rokannon.core.utils.requireProperty;

    import flash.utils.Dictionary;

    public class DataLibrary
    {
        /**
         * For the sake of simplicity data items are
         * accessible publicly. This is valid only for
         * libraries without any cross-dependencies.
         */
        public const dataByName:Dictionary = new Dictionary();

        /**
         * This dictionary is valid only after init
         * and before post init.
         */
        protected const _jsonByName:Dictionary = new Dictionary();

        protected var _dataType:String;

        public function DataLibrary(dataType:String)
        {
            _dataType = dataType;
        }

        public final function get dataType():String
        {
            return _dataType;
        }

        /**
         * Parses provided json object and holds json
         * of each data item in _jsonByName dictionary.
         * Important part of this method is pairing json
         * to some string which becomes data item's name.
         */
        public function initFromJSON(json:Object):void
        {
        }

        /**
         * Completes data creation and clears _jsonByName
         * dictionary.
         */
        public final function postInit():void
        {
            for (var name:String in _jsonByName)
            {
                if (dataByName[name] == null)
                    dataByName[name] = createDataFromJSON(_jsonByName[name]);
            }
            clearDictionary(_jsonByName);
        }

        public final function getNamesByPrefix(prefix:String, resultNames:Vector.<String> = null):Vector.<String>
        {
            if (resultNames == null)
                resultNames = new <String>[];
            var dictionary:Dictionary = isDictionaryEmpty(_jsonByName) ? dataByName : _jsonByName;
            for (var name:String in dictionary)
            {
                if (name.indexOf(prefix) == 0)
                    resultNames.push(name);
            }
            return resultNames;
        }

        /**
         * Performs access to data items. Data items are
         * created lazily from _jsonByName dictionary if
         * proper json-object is found.
         * @param key This can be name or json-object.
         */
        protected final function getDataByKey(key:Object):Object
        {
            if (key is String)
            {
                if (dataByName[key] == null && _jsonByName[key] != null)
                    dataByName[key] = createDataFromJSON(_jsonByName[key]);
                return requireProperty(dataByName, key as String);
            }
            return createDataFromJSON(key);
        }

        /**
         * Creates data item from json-object. Returns
         * specified json by default as simplest data item.
         */
        protected function createDataFromJSON(json:Object):Object
        {
            return json;
        }
    }
}