<%-- 
    Document   : admin-dashboard
    Created on : Oct 4, 2026, 12:45:03 PM
    Author     : ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ taglib prefix="c"
           uri="http://java.sun.com/jsp/jstl/core" %>


<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>Admin Dashboard</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/common.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/admin-dashboard.css">

</head>


<body>


<div class="app-layout">


    <%-- SIDEBAR --%>

    <jsp:include page="/WEB-INF/views/includes/sidebar.jsp"/>


    <main class="main-content">


        <%-- ================================================= --%>
        <%-- HEADER --%>
        <%-- ================================================= --%>

        <header class="admin-header">

            <div>

                <h1>
                    Admin Dashboard
                </h1>

                <p>
                    Overview of users, warehouses, devices and drying operations.
                </p>

            </div>

        </header>



        <%-- ================================================= --%>
        <%-- USER --%>
        <%-- ================================================= --%>

        <section class="dashboard-section">


            <div class="section-title">

                <h2>
                    Users
                </h2>

                <a href="${pageContext.request.contextPath}/users">

                    View User Management →

                </a>

            </div>


            <div class="stat-grid">


                <div class="stat-card">

                    <span>
                        Total Users
                    </span>

                    <strong>
                        ${totalUsers}
                    </strong>

                </div>


                <div class="stat-card stat-success">

                    <span>
                        Active Users
                    </span>

                    <strong>
                        ${activeUsers}
                    </strong>

                </div>


                <div class="stat-card stat-danger">

                    <span>
                        Inactive Users
                    </span>

                    <strong>
                        ${inactiveUsers}
                    </strong>

                </div>


            </div>


        </section>



        <%-- ================================================= --%>
        <%-- WAREHOUSE --%>
        <%-- ================================================= --%>

        <section class="dashboard-section">


            <div class="section-title">

                <h2>
                    Warehouses
                </h2>

                <a href="${pageContext.request.contextPath}/warehouses">

                    View Warehouse Management →

                </a>

            </div>


            <div class="stat-grid">


                <div class="stat-card">

                    <span>
                        Total Warehouses
                    </span>

                    <strong>
                        ${totalWarehouses}
                    </strong>

                </div>


                <div class="stat-card stat-success">

                    <span>
                        Active Warehouses
                    </span>

                    <strong>
                        ${activeWarehouses}
                    </strong>

                </div>


                <div class="stat-card stat-danger">

                    <span>
                        Inactive Warehouses
                    </span>

                    <strong>
                        ${inactiveWarehouses}
                    </strong>

                </div>


            </div>


        </section>



        <%-- ================================================= --%>
        <%-- DEVICE --%>
        <%-- ================================================= --%>

        <section class="dashboard-section">


            <div class="section-title">

                <h2>
                    Devices
                </h2>

            </div>


            <div class="stat-grid">


                <div class="stat-card">

                    <span>
                        Total Devices
                    </span>

                    <strong>
                        ${totalDevices}
                    </strong>

                </div>


                <div class="stat-card stat-success">

                    <span>
                        Online Devices
                    </span>

                    <strong>
                        ${onlineDevices}
                    </strong>

                </div>


                <div class="stat-card stat-danger">

                    <span>
                        Offline Devices
                    </span>

                    <strong>
                        ${offlineDevices}
                    </strong>

                </div>


            </div>


        </section>



        <%-- ================================================= --%>
        <%-- OPERATION --%>
        <%-- ================================================= --%>

        <section class="dashboard-section">


            <div class="section-title">

                <h2>
                    Drying Operations
                </h2>

            </div>


            <div class="stat-grid single-stat">


                <div class="stat-card stat-warning">

                    <span>
                        Active Drying Batches
                    </span>

                    <strong>
                        ${activeBatches}
                    </strong>

                </div>


            </div>


        </section>


    </main>


</div>


</body>

</html>