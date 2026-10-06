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

    <title>Operator Dashboard</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/common.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/operator-dashboard.css">
</head>

<body>

<div class="app-layout">

    <jsp:include page="/WEB-INF/views/includes/sidebar.jsp"/>

    <main class="main-content">

        <!-- HEADER -->
        <header class="dashboard-header">

            <div class="dashboard-title">
                <h1>Operator Dashboard</h1>

                <p>
                    Welcome,
                    <strong>
                        ${sessionScope.LOGIN_USER.fullName}
                    </strong>
                </p>
            </div>


            <div class="dashboard-context">

                <div class="context-item">
                    <span class="context-label">
                        Warehouse
                    </span>

                    <span class="context-value">
                        ${warehouse.warehouseCode}
                        -
                        ${warehouse.warehouseName}
                    </span>
                </div>


                <div class="context-item">
                    <span class="context-label">
                        Device
                    </span>

                    <span class="context-value">

                        <c:choose>

                            <c:when test="${device != null}">
                                ${device.deviceCode}
                            </c:when>

                            <c:otherwise>
                                No Device
                            </c:otherwise>

                        </c:choose>

                    </span>
                </div>

            </div>

        </header>


        <!-- ERROR -->
        <c:if test="${not empty error}">

            <div class="alert alert-error">
                ${error}
            </div>

        </c:if>


        <!-- SYSTEM STATUS -->
        <section class="dashboard-section">

            <div class="section-header">
                <h2>Current System Status</h2>
            </div>


            <div class="status-grid">

                <!-- ESP -->
                <article class="status-card">

                    <span class="status-label">
                        ESP Status
                    </span>

                    <c:choose>

                        <c:when test="${dashboard.connectionStatus == 'ONLINE'}">

                            <span class="status-value status-online">
                                ONLINE
                            </span>

                        </c:when>

                        <c:otherwise>

                            <span class="status-value status-offline">
                                OFFLINE
                            </span>

                        </c:otherwise>

                    </c:choose>

                </article>


                <!-- TEMPERATURE -->
                <article class="status-card">

                    <span class="status-label">
                        Temperature
                    </span>

                    <span class="status-value">

                        <fmt:formatNumber
                            value="${dashboard.temperature}"
                            maxFractionDigits="1"/>

                        °C

                    </span>

                </article>


                <!-- HUMIDITY -->
                <article class="status-card">

                    <span class="status-label">
                        Humidity
                    </span>

                    <span class="status-value">

                        <fmt:formatNumber
                            value="${dashboard.humidity}"
                            maxFractionDigits="1"/>

                        %

                    </span>

                </article>


                <!-- RAIN -->
                <article class="status-card">

                    <span class="status-label">
                        Rain
                    </span>

                    <span class="status-value">
                        ${dashboard.rainStatus}
                    </span>

                </article>


                <!-- LIGHT -->
                <article class="status-card">

                    <span class="status-label">
                        Light
                    </span>

                    <span class="status-value">
                        ${dashboard.lightStatus}
                    </span>

                </article>


                <!-- ROOF -->
                <article class="status-card">

                    <span class="status-label">
                        Roof
                    </span>

                    <span class="status-value">
                        ${dashboard.roofStatus}
                    </span>

                </article>


                <!-- MODE -->
                <article class="status-card">

                    <span class="status-label">
                        Mode
                    </span>

                    <span class="status-value">
                        ${dashboard.mode}
                    </span>

                </article>


                <!-- WARNING -->
                <article class="status-card">

                    <span class="status-label">
                        Warning
                    </span>

                    <span class="status-value">
                        ${dashboard.warning}
                    </span>

                </article>

            </div>

        </section>


        <!-- ACTIVE BATCH -->
        <section class="dashboard-section">

            <div class="section-header">

                <h2>Active Drying Batch</h2>

                <a class="section-link"
                   href="${pageContext.request.contextPath}/batch">
                    View All
                </a>

            </div>


            <div class="batch-card">

                <c:choose>

                    <c:when test="${activeBatch != null}">

                        <div class="batch-info-grid">

                            <div class="batch-info-item">

                                <span class="info-label">
                                    Batch ID
                                </span>

                                <strong>
                                    ${activeBatch.batchId}
                                </strong>

                            </div>


                            <div class="batch-info-item">

                                <span class="info-label">
                                    Product
                                </span>

                                <strong>
                                    ${activeBatch.productName}
                                </strong>

                            </div>


                            <div class="batch-info-item">

                                <span class="info-label">
                                    Operator
                                </span>

                                <strong>
                                    ${activeBatch.operatorName}
                                </strong>

                            </div>


                            <div class="batch-info-item">

                                <span class="info-label">
                                    Weight
                                </span>

                                <strong>

                                    <fmt:formatNumber
                                        value="${activeBatch.weightKg}"
                                        maxFractionDigits="2"/>

                                    kg

                                </strong>

                            </div>


                            <div class="batch-info-item">

                                <span class="info-label">
                                    Start Time
                                </span>

                                <strong>

                                    <fmt:formatDate
                                        value="${activeBatch.startTime}"
                                        pattern="dd/MM/yyyy HH:mm"/>

                                </strong>

                            </div>


                            <div class="batch-info-item">

                                <span class="info-label">
                                    Status
                                </span>

                                <strong class="batch-status">
                                    ${activeBatch.status}
                                </strong>

                            </div>

                        </div>

                    </c:when>


                    <c:otherwise>

                        <div class="empty-state">

                            <p>
                                No active drying batch.
                            </p>

                            <a class="primary-link"
                               href="${pageContext.request.contextPath}/batch">

                                Start New Batch

                            </a>

                        </div>

                    </c:otherwise>

                </c:choose>

            </div>

        </section>


        <!-- CONTROL PANEL -->
        <section class="dashboard-section">

            <div class="section-header">
                <h2>Control Panel</h2>
            </div>


            <form class="control-panel"
                  action="${pageContext.request.contextPath}/control"
                  method="post">


                <!-- MODE -->
                <div class="control-group">

                    <span class="control-title">
                        Operating Mode
                    </span>

                    <div class="control-actions">


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

                    </div>

                </div>


                <!-- ROOF CONTROL -->
                <div class="control-group">

                    <span class="control-title">
                        Roof Control
                    </span>


                    <div class="control-actions">

                        <c:choose>

                            <c:when test="${dashboard.mode == 'MANUAL'}">

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

                            </c:when>


                            <c:otherwise>

                                <button type="button"
                                        class="control-button"
                                        disabled>

                                    OPEN ROOF

                                </button>


                                <button type="button"
                                        class="control-button"
                                        disabled>

                                    CLOSE ROOF

                                </button>

                            </c:otherwise>

                        </c:choose>

                    </div>


                    <c:if test="${dashboard.mode == 'AUTO'}">

                        <small class="control-note">

                            Manual roof control is disabled
                            in AUTO mode.

                        </small>

                    </c:if>

                </div>

            </form>

        </section>


        <!-- RECENT SENSOR -->
        <section class="dashboard-section">

            <div class="section-header">

                <h2>Recent Sensor Readings</h2>

                <a class="section-link"
                   href="${pageContext.request.contextPath}/history">

                    View History

                </a>

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
