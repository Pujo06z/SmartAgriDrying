<%-- 
    Document   : login
    Created on : Oct 4, 2026, 3:03:20 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Login - Smart Agricultural Drying System</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/login.css">

</head>


<body>


<div class="login-page">


    <div class="login-container">


        <!-- ============================== -->
        <!-- LEFT SIDE -->
        <!-- ============================== -->

        <div class="login-banner">


            <div class="login-logo">
                SA
            </div>


            <h1>
                Smart Agricultural
                Drying System
            </h1>


            <p>
                Monitor environmental conditions,
                manage drying batches and control
                the smart drying roof in one system.
            </p>


            <div class="login-features">


                <div class="login-feature">

                    <span class="feature-dot"></span>

                    <span>
                        Real-time sensor monitoring
                    </span>

                </div>


                <div class="login-feature">

                    <span class="feature-dot"></span>

                    <span>
                        Automatic and manual roof control
                    </span>

                </div>


                <div class="login-feature">

                    <span class="feature-dot"></span>

                    <span>
                        Drying batch management
                    </span>

                </div>


            </div>


        </div>



        <!-- ============================== -->
        <!-- RIGHT SIDE -->
        <!-- ============================== -->

        <div class="login-content">


            <div class="login-form-wrapper">


                <div class="login-header">

                    <h2>
                        Welcome Back
                    </h2>

                    <p>
                        Sign in to access the Smart Drying System.
                    </p>

                </div>



                <!-- ============================== -->
                <!-- ERROR -->
                <!-- ============================== -->

                <%
                    String error = (String) request.getAttribute("error");

                    if (error != null) {
                %>

                <div class="login-error">
                    <%= error %>
                </div>

                <%
                    }
                %>



                <!-- ============================== -->
                <!-- LOGIN FORM -->
                <!-- ============================== -->

                <form action="${pageContext.request.contextPath}/login"
                      method="post">


                    <div class="form-group">

                        <label for="username">
                            Username
                        </label>

                        <input type="text"
                               id="username"
                               name="username"
                               placeholder="Enter your username"
                               autocomplete="username"
                               required>

                    </div>



                    <div class="form-group">

                        <label for="password">
                            Password
                        </label>

                        <input type="password"
                               id="password"
                               name="password"
                               placeholder="Enter your password"
                               autocomplete="current-password"
                               required>

                    </div>



                    <button type="submit"
                            class="login-button">

                        Login

                    </button>


                </form>



                <div class="login-footer">

                    Smart Agricultural Drying System

                </div>


            </div>


        </div>


    </div>


</div>


</body>

</html>