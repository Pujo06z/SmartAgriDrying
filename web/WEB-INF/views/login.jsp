<%-- 
    Document   : login
    Created on : Oct 4, 2026, 3:03:20 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login</title>
    </head>
    <body>
         <h2>Smart Agricultural Drying System</h2>

    <form action="${pageContext.request.contextPath}/login" method="post">

        <label>Username</label>
        <input type="text" name="username" required>

        <br><br>

        <label>Password</label>
        <input type="password" name="password" required>

        <br><br>

        <button type="submit">Login</button>

    </form>

    <p style="color:red;">
        ${error}
    </p>

    </body>
</html>
