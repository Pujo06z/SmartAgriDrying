<%-- 
    Document   : history
    Created on : Oct 4, 2026, 12:45:23 PM
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

    <title>History</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/common.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/history.css">

</head>


<body>

<div class="app-layout">


    <jsp:include page="/WEB-INF/views/includes/sidebar.jsp"/>


    <main class="main-content">


        <%-- ===================================== --%>
        <%-- HEADER --%>
        <%-- ===================================== --%>

        <header class="history-page-header">

            <div>

                <h1>
                    History
                </h1>

                <p>
                    View sensor readings and completed drying batches.
                </p>

            </div>


            <div class="history-context">


                <div class="context-box">

                    <span class="context-label">
                        Warehouse
                    </span>

                    <strong>

                        <c:choose>

                            <c:when test="${warehouse ne null}">

                                ${warehouse.warehouseCode}
                                -
                                ${warehouse.warehouseName}

                            </c:when>

                            <c:otherwise>

                                No Warehouse

                            </c:otherwise>

                        </c:choose>

                    </strong>

                </div>


                <div class="context-box">

                    <span class="context-label">
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
        <%-- HISTORY TABS --%>
        <%-- ===================================== --%>

        <div class="history-tabs">


            <c:choose>

                <c:when test="${tab eq 'sensor'}">

                    <a href="${pageContext.request.contextPath}/history?tab=sensor"
                       class="history-tab active">

                        Sensor History

                    </a>

                </c:when>

                <c:otherwise>

                    <a href="${pageContext.request.contextPath}/history?tab=sensor"
                       class="history-tab">

                        Sensor History

                    </a>

                </c:otherwise>

            </c:choose>



            <c:choose>

                <c:when test="${tab eq 'batch'}">

                    <a href="${pageContext.request.contextPath}/history?tab=batch"
                       class="history-tab active">

                        Batch History

                    </a>

                </c:when>

                <c:otherwise>

                    <a href="${pageContext.request.contextPath}/history?tab=batch"
                       class="history-tab">

                        Batch History

                    </a>

                </c:otherwise>

            </c:choose>



            <c:choose>

                <c:when test="${tab eq 'event'}">

                    <a href="${pageContext.request.contextPath}/history?tab=event"
                       class="history-tab active">

                        Event History

                    </a>

                </c:when>

                <c:otherwise>

                    <a href="${pageContext.request.contextPath}/history?tab=event"
                       class="history-tab">

                        Event History

                    </a>

                </c:otherwise>

            </c:choose>


        </div>



        <%-- ===================================== --%>
        <%-- SENSOR HISTORY --%>
        <%-- ===================================== --%>

        <c:if test="${tab eq 'sensor'}">


            <section class="dashboard-section">


                <div class="section-header">

                    <div>

                        <h2>
                            Sensor History
                        </h2>

                        <p class="section-description">

                            Historical environmental readings
                            from the drying area.

                        </p>

                    </div>

                </div>



                <div class="table-wrapper">


                    <table class="data-table sensor-history-table">


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


                            <c:when test="${not empty sensors}">


                                <c:forEach var="sensor"
                                           items="${sensors}">


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

                                        No sensor history available.

                                    </td>

                                </tr>


                            </c:otherwise>


                        </c:choose>


                        </tbody>


                    </table>


                </div>


            </section>


        </c:if>



        <%-- ===================================== --%>
        <%-- BATCH HISTORY --%>
        <%-- ===================================== --%>

        <c:if test="${tab eq 'batch'}">


            <section class="dashboard-section">


                <div class="section-header">

                    <div>

                        <h2>
                            Completed Drying Batches
                        </h2>

                        <p class="section-description">

                            Drying batches completed in this warehouse.

                        </p>

                    </div>

                </div>



                <div class="table-wrapper">


                    <table class="data-table batch-history-table">


                        <thead>

                        <tr>

                            <th>Batch ID</th>

                            <th>Product</th>

                            <th>Operator</th>

                            <th>Weight</th>

                            <th>Start Time</th>

                            <th>End Time</th>

                            <th>Status</th>

                            <th>Notes</th>

                        </tr>

                        </thead>


                        <tbody>


                        <c:choose>


                            <c:when test="${not empty batches}">


                                <c:forEach var="batch"
                                           items="${batches}">


                                    <tr>


                                        <td>

                                            <strong>
                                                ${batch.batchId}
                                            </strong>

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

                                            <c:choose>

                                                <c:when test="${batch.endTime ne null}">

                                                    <fmt:formatDate
                                                        value="${batch.endTime}"
                                                        pattern="dd/MM/yyyy HH:mm"/>

                                                </c:when>

                                                <c:otherwise>

                                                    -

                                                </c:otherwise>

                                            </c:choose>

                                        </td>


                                        <td>

                                            <span class="history-status-completed">

                                                COMPLETED

                                            </span>

                                        </td>


                                        <td>

                                            <c:choose>

                                                <c:when test="${not empty batch.notes}">

                                                    ${batch.notes}

                                                </c:when>

                                                <c:otherwise>

                                                    -

                                                </c:otherwise>

                                            </c:choose>

                                        </td>


                                    </tr>


                                </c:forEach>


                            </c:when>


                            <c:otherwise>


                                <tr>

                                    <td colspan="8"
                                        class="empty-table">

                                        No completed drying batches found.

                                    </td>

                                </tr>


                            </c:otherwise>


                        </c:choose>


                        </tbody>


                    </table>


                </div>


            </section>


        </c:if>



        <%-- ===================================== --%>
        <%-- EVENT HISTORY --%>
        <%-- ===================================== --%>

        <c:if test="${tab eq 'event'}">


            <section class="dashboard-section">


                <div class="section-header">

                    <div>

                        <h2>
                            Event History
                        </h2>

                        <p class="section-description">

                            System and device events will be displayed here.

                        </p>

                    </div>

                </div>


                <div class="history-empty-state">

                    <h3>
                        Event History
                    </h3>

                    <p>
                        Event Log functionality will be implemented later.
                    </p>

                </div>


            </section>


        </c:if>


    </main>


</div>


</body>

</html>