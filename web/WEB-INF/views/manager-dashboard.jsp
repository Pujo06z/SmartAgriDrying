<%-- 
    Document   : manager-dashboard
    Created on : Oct 4, 2026, 12:44:52 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manager-dashboard</title>
    </head>
    <body>

        <h1>MANAGER DASHBOARD</h1>

        <p>
            Welcome ${sessionScope.LOGIN_USER.fullName}
        </p>

        <p>
            Role: ${sessionScope.LOGIN_USER.role}
        </p>
        
        <a href="${pageContext.request.contextPath}/logout">
    Logout
</a>
    </body>
</html>
