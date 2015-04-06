package com.rokannon.project.ProjectLeo.command.requestDB
{
    public class DBRequestType
    {
        public static const DEPARTMENTS:DBRequestType = new DBRequestType("SELECT Departments.DeptName, Departments.DeptID, COALESCE(T.EmplAmount, 0) as EmplAmount FROM Departments LEFT JOIN (SELECT Employees.DeptID AS DeptID, count(Employees.DeptID) as EmplAmount FROM Employees GROUP BY Employees.DeptID) AS T ON T.DeptID = Departments.DeptID;");
        public static const EMPLOYEES:DBRequestType = new DBRequestType("SELECT *, FirstName || ' ' || LastName AS FullName FROM Employees WHERE {0};");
        public static const ADD_DEPARTMENT:DBRequestType = new DBRequestType("INSERT INTO Departments (DeptName) VALUES ('{0}');");
        public static const REMOVE_DEPARTMENT:DBRequestType = new DBRequestType("DELETE FROM Departments WHERE DeptID = '{0}';");
        public static const REMOVE_EMPLOYEES_BY_DEPARTMENT:DBRequestType = new DBRequestType("DELETE FROM Departments WHERE DeptID = '{0}';");
        public static const HIRE_EMPLOYEE:DBRequestType = new DBRequestType("INSERT INTO Employees (FirstName, LastName, DeptID, Position) VALUES ('{0}', '{1}', '{2}', '{3}');");
        public static const FIRE_EMPLOYEE:DBRequestType = new DBRequestType("DELETE FROM Employees WHERE EmplID = '{0}';");
        public static const GET_DEPARTMENTS:DBRequestType = new DBRequestType("SELECT DeptName, DeptID FROM Departments;");
        public static const UPDATE_EMPLOYEES:DBRequestType = new DBRequestType("UPDATE Employees SET {0} WHERE {1}");
        public static const CREATE_TABLE:DBRequestType = new DBRequestType("CREATE TABLE {0}({1});");

        private var _requestTemplate:String;

        public function DBRequestType(requestTemplate:String)
        {
            _requestTemplate = requestTemplate;
        }

        public function get requestTemplate():String
        {
            return _requestTemplate;
        }
    }
}