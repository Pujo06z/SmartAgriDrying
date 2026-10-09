<%-- 
    Document   : manager-dashboard
    Created on : Oct 4, 2026, 12:44:52 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib prefix="c"
          uri="http://java.sun.com/jsp/jstl/core"%>

<%@taglib prefix="fmt"
          uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Manager Dashboard</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/common.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/manager-dashboard.css">

</head>


<body>


<div class="app-layout">


    <jsp:include page="/WEB-INF/views/includes/sidebar.jsp"/>


    <main class="main-content">


        <%-- ===================================== --%>
        <%-- HEADER --%>
        <%-- ===================================== --%>

        <header class="dashboard-header">


            <div>

                <h1>
                    Manager Dashboard
                </h1>

                <p>
                    Welcome,
                    ${sessionScope.LOGIN_USER.fullName}
                </p>

            </div>


            <%-- ================================= --%>
            <%-- WAREHOUSE SELECT --%>
            <%-- ================================= --%>

            <div class="manager-warehouse-select">


                <label for="warehouseSelect">
                    Warehouse
                </label>


                <form action="${pageContext.request.contextPath}/dashboard"
                      method="get">


                    <select id="warehouseSelect"
                            name="warehouseId"
                            onchange="this.form.submit()">


                        <c:forEach var="w"
                                   items="${warehouseList}">


                            <c:choose>


                                <c:when test="${w.warehouseId eq warehouse.warehouseId}">

                                    <option value="${w.warehouseId}"
                                            selected>

                                        ${w.warehouseCode}
                                        -
                                        ${w.warehouseName}

                                    </option>

                                </c:when>


                                <c:otherwise>

                                    <option value="${w.warehouseId}">

                                        ${w.warehouseCode}
                                        -
                                        ${w.warehouseName}

                                    </option>

                                </c:otherwise>


                            </c:choose>


                        </c:forEach>


                    </select>


                </form>


            </div>


        </header>



        <%-- ===================================== --%>
        <%-- ERROR --%>
        <%-- ===================================== --%>

        <c:if test="${not empty error}">

            <div class="alert alert-error">

                ${error}

            </div>

        </c:if>



        <%-- ===================================== --%>
        <%-- CURRENT CONTEXT --%>
        <%-- ===================================== --%>

        <div class="dashboard-context">


            <div>

                <span>
                    Warehouse
                </span>

                <strong>

                    ${warehouse.warehouseCode}
                    -
                    ${warehouse.warehouseName}

                </strong>

            </div>


            <div>

                <span>
                    Device
                </span>

                <strong>

                    <c:choose>

                        <c:when test="${device ne null}">

                            ${device.deviceCode}

                        </c:when>

                        <c:otherwise>

                            No Device

                        </c:otherwise>

                    </c:choose>

                </strong>

            </div>


        </div>



        <%-- ===================================== --%>
        <%-- CURRENT SYSTEM STATUS --%>
        <%-- ===================================== --%>

        <section class="dashboard-section">


            <div class="section-header">

                <h2>
                    Current System Status
                </h2>

            </div>


            <div class="status-grid">


                <%-- CONNECTION --%>

                <div class="status-card">

                    <span class="status-label">
                        ESP Status
                    </span>

                    <strong>

                        ${dashboard.connectionStatus}

                    </strong>

                </div>



                <%-- TEMPERATURE --%>

                <div class="status-card">

                    <span class="status-label">
                        Temperature
                    </span>

                    <strong>

                        <fmt:formatNumber
                            value="${dashboard.temperature}"
                            maxFractionDigits="1"/>

                        °C

                    </strong>

                </div>



                <%-- HUMIDITY --%>

                <div class="status-card">

                    <span class="status-label">
                        Humidity
                    </span>

                    <strong>

                        <fmt:formatNumber
                            value="${dashboard.humidity}"
                            maxFractionDigits="1"/>

                        %

                    </strong>

                </div>



                <%-- RAIN --%>

                <div class="status-card">

                    <span class="status-label">
                        Rain
                    </span>

                    <strong>

                        ${dashboard.rainStatus}

                    </strong>

                </div>



                <%-- LIGHT --%>

                <div class="status-card">

                    <span class="status-label">
                        Light
                    </span>

                    <strong>

                        ${dashboard.lightStatus}

                    </strong>

                </div>



                <%-- ROOF --%>

                <div class="status-card">

                    <span class="status-label">
                        Roof
                    </span>

                    <strong>

                        ${dashboard.roofStatus}

                    </strong>

                </div>



                <%-- MODE --%>

                <div class="status-card">

                    <span class="status-label">
                        Mode
                    </span>

                    <strong>

                        ${dashboard.mode}

                    </strong>

                </div>



                <%-- WARNING --%>

                <div class="status-card">

                    <span class="status-label">
                        Warning
                    </span>

                    <strong>

                        ${dashboard.warning}

                    </strong>

                </div>


            </div>


        </section>



        <%-- ===================================== --%>
        <%-- ACTIVE DRYING BATCHES --%>
        <%-- ===================================== --%>

        <section class="dashboard-section">


            <div class="section-header">

                <div>

                    <h2>
                        Active Drying Batches
                    </h2>

                    <p>
                        ${activeBatchCount} active batch(es)
                    </p>

                </div>

            </div>


            <div class="table-wrapper">


                <table class="data-table">


                    <thead>

                    <tr>

                        <th>Batch ID</th>

                        <th>Product</th>

                        <th>Operator</th>

                        <th>Weight</th>

                        <th>Start Time</th>

                        <th>Status</th>

                    </tr>

                    </thead>


                    <tbody>


                    <c:choose>


                        <c:when test="${not empty activeBatches}">


                            <c:forEach var="batch"
                                       items="${activeBatches}">


                                <tr>


                                    <td>

                                        ${batch.batchId}

                                    </td>


                                    <td>

                                        ${batch.productName}

                                    </td>


                                    <td>

                                        ${batch.operatorName}

                                    </td>


                                    <td>

                                        <fmt:formatNumber
                                            value="${batch.weightKg}"
                                            maxFractionDigits="2"/>

                                        kg

                                    </td>


                                    <td>

                                        <fmt:formatDate
                                            value="${batch.startTime}"
                                            pattern="dd/MM/yyyy HH:mm"/>

                                    </td>


                                    <td>

                                        <span class="status-badge status-drying">

                                            DRYING

                                        </span>

                                    </td>


                                </tr>


                            </c:forEach>


                        </c:when>


                        <c:otherwise>


                            <tr>

                                <td colspan="6"
                                    class="empty-table">

                                    No active drying batches.

                                </td>

                            </tr>


                        </c:otherwise>


                    </c:choose>


                    </tbody>


                </table>


            </div>


        </section>



        <%-- ===================================== --%>
        <%-- CONTROL PANEL --%>
        <%-- ===================================== --%>

        <section class="dashboard-section">


            <div class="section-header">

                <h2>
                    Control Panel
                </h2>

            </div>


            <c:choose>


                <c:when test="${device ne null}">


                    <div class="control-panel">


                        <div class="control-group">


                            <span class="control-title">
                                Operating Mode
                            </span>


                            <form action="${pageContext.request.contextPath}/control"
                                  method="post"
                                  class="control-buttons">


                                <input type="hidden"
                                       name="deviceId"
                                       value="${device.deviceId}">


                                <input type="hidden"
                                       name="warehouseId"
                                       value="${warehouse.warehouseId}">


                                <button type="submit"
                                        name="action"
                                        value="AUTO"
                                        class="control-button">

                                    AUTO

                                </button>


                                <button type="submit"
                                        name="action"
                                        value="MANUAL"
                                        class="control-button">

                                    MANUAL

                                </button>


                            </form>


                        </div>



                        <div class="control-group">


                            <span class="control-title">
                                Roof Control
                            </span>


                            <c:choose>


                                <c:when test="${dashboard.mode eq 'MANUAL'}">


                                    <form action="${pageContext.request.contextPath}/control"
                                          method="post"
                                          class="control-buttons">


                                        <input type="hidden"
                                               name="deviceId"
                                               value="${device.deviceId}">


                                        <input type="hidden"
                                               name="warehouseId"
                                               value="${warehouse.warehouseId}">


                                        <button type="submit"
                                                name="action"
                                                value="OPEN"
                                                class="control-button">

                                            OPEN ROOF

                                        </button>


                                        <button type="submit"
                                                name="action"
                                                value="CLOSE"
                                                class="control-button">

                                            CLOSE ROOF

                                        </button>


                                    </form>


                                </c:when>


                                <c:otherwise>


                                    <div class="control-disabled-message">

                                        Switch to MANUAL mode
                                        to control the roof.

                                    </div>


                                </c:otherwise>


                            </c:choose>


                        </div>


                    </div>


                </c:when>


                <c:otherwise>


                    <div class="empty-state">

                        No device available for this warehouse.

                    </div>


                </c:otherwise>


            </c:choose>


        </section>



        <%-- ===================================== --%>
        <%-- RECENT SENSOR READINGS --%>
        <%-- ===================================== --%>

        <section class="dashboard-section">


            <div class="section-header">

                <h2>
                    Recent Sensor Readings
                </h2>

            </div>


            <div class="table-wrapper">


                <table class="data-table">


                    <thead>

                    <tr>

                        <th>Time</th>

                        <th>Temperature</th>

                        <th>Humidity</th>

                        <th>Rain</th>

                        <th>Light</th>

                        <th>Roof</th>

                    </tr>

                    </thead>


                    <tbody>


                    <c:choose>


                        <c:when test="${not empty recentSensors}">


                            <c:forEach var="sensor"
                                       items="${recentSensors}">


                                <tr>


                                    <td>

                                        <fmt:formatDate
                                            value="${sensor.recordedAt}"
                                            pattern="dd/MM/yyyy HH:mm:ss"/>

                                    </td>


                                    <td>

                                        <fmt:formatNumber
                                            value="${sensor.temperature}"
                                            maxFractionDigits="1"/>

                                        °C

                                    </td>


                                    <td>

                                        <fmt:formatNumber
                                            value="${sensor.humidity}"
                                            maxFractionDigits="1"/>

                                        %

                                    </td>


                                    <td>

                                        ${sensor.rainStatus}

                                    </td>


                                    <td>

                                        ${sensor.lightStatus}

                                    </td>


                                    <td>

                                        ${sensor.roofStatus}

                                    </td>


                                </tr>


                            </c:forEach>


                        </c:when>


                        <c:otherwise>


                            <tr>

                                <td colspan="6"
                                    class="empty-table">

                                    No sensor data available.

                                </td>

                            </tr>


                        </c:otherwise>


                    </c:choose>


                    </tbody>


                </table>


            </div>


        </section>


    </main>


</div>


</body>

</html>
