package com.rokannon.project.ProjectLeo.command.requestDB
{
    import com.rokannon.core.utils.string.stringFormat;

    public class DBRequest
    {
        private var _requestType:DBRequestType;
        private var _requestText:String;

        public function DBRequest(requestType:DBRequestType, ...args)
        {
            _requestType = requestType;
            args.unshift(requestType.requestTemplate);
            _requestText = stringFormat.apply(null, args);
        }

        public function get requestType():DBRequestType
        {
            return _requestType;
        }

        public function get requestText():String
        {
            return _requestText;
        }
    }
}