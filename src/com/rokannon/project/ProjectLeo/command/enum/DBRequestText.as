package com.rokannon.project.ProjectLeo.command.enum
{
    import com.rokannon.core.enum.StaticClassBase;

    public class DBRequestText extends StaticClassBase
    {
        public static const DEPARTMENTS:String = "SELECT Departments.DeptName, Departments.DeptID, COALESCE(T.EmplAmount, 0) as EmplAmount FROM Departments LEFT JOIN (SELECT Employees.DeptID AS DeptID, count(Employees.DeptID) as EmplAmount FROM Employees GROUP BY Employees.DeptID) AS T ON T.DeptID = Departments.DeptID;";
        public static const EMPLOYEES:String = "SELECT *, FirstName || ' ' || LastName AS FullName FROM Employees WHERE DeptID = '{0}';";
        public static const ADD_DEPARTMENT:String = "INSERT INTO Departments (DeptName) VALUES ('{0}');";
        public static const REMOVE_DEPARTMENT:String = "DELETE FROM Departments WHERE DeptID = '{0}';";
        public static const REMOVE_EMPLOYEES_BY_DEPARTMENT:String = "DELETE FROM Departments WHERE DeptID = '{0}';";
    }
}