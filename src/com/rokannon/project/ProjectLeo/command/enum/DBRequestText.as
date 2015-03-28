package com.rokannon.project.ProjectLeo.command.enum
{
    import com.rokannon.core.enum.StaticClassBase;

    public class DBRequestText extends StaticClassBase
    {
        public static const DEPARTMENTS:String = "SELECT *, T.EmplAmount FROM Departments INNER JOIN (SELECT Employees.DeptID AS DeptID, count(Employees.DeptID) as EmplAmount FROM Employees GROUP BY Employees.DeptID) AS T on T.DeptID = Departments.DeptID;";
        public static const EMPLOYEES:String = "SELECT *, FirstName || ' ' || LastName AS FullName FROM Employees WHERE DeptID = '{0}'";
    }
}