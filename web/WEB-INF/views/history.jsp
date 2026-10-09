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


                    <div class="history-header-right">


                        <%-- MANAGER: CHỌN WAREHOUSE --%>

                        <c:if test="${sessionScope.LOGIN_USER.role eq 'MANAGER'}">

                            <div class="history-warehouse-select">

                                <label for="warehouseSelect">
                                    Warehouse
                                </label>

                                <form action="${pageContext.request.contextPath}/history"
                                      method="get">

                                    <input type="hidden"
                                           name="tab"
                                           value="${tab}">

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

                        </c:if>


                        <%-- CURRENT CONTEXT --%>

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

                        <form action="${pageContext.request.contextPath}/history"
                              method="get"
                              class="history-filter-form">

                            <%-- Giữ đúng tab Sensor --%>
                            <input type="hidden"
                                   name="tab"
                                   value="sensor">

                            <%-- Giữ warehouse hiện tại --%>
                            <input type="hidden"
                                   name="warehouseId"
                                   value="${warehouse.warehouseId}">


                            <%-- SEARCH SENSOR ID --%>
                            <input type="text"
                                   name="sensorKeyword"
                                   value="${sensorKeyword}"
                                   placeholder="Search Sensor ID...">


                            <%-- FILTER RAIN --%>
                            <select name="rainStatus">

                                <option value="">
                                    All Rain Status
                                </option>

                                <option value="NO_RAIN"
                                        ${selectedRainStatus eq 'NO_RAIN'
                                          ? 'selected' : ''}>
                                    No Rain
                                </option>

                                <option value="RAINING"
                                        ${selectedRainStatus eq 'RAINING'
                                          ? 'selected' : ''}>
                                    Raining
                                </option>

                            </select>


                            <%-- FILTER LIGHT --%>
                            <select name="lightStatus">

                                <option value="">
                                    All Light Status
                                </option>

                                <option value="BRIGHT"
                                        ${selectedLightStatus eq 'BRIGHT'
                                          ? 'selected' : ''}>
                                    Bright
                                </option>

                                <option value="DARK"
                                        ${selectedLightStatus eq 'DARK'
                                          ? 'selected' : ''}>
                                    Dark
                                </option>

                            </select>


                            <%-- Khi search thì quay lại page 1 --%>
                            <input type="hidden"
                                   name="sensorPage"
                                   value="1">


                            <button type="submit"
                                    class="primary-button">
                                Apply
                            </button>


                            <a href="${pageContext.request.contextPath}/history?tab=sensor&warehouseId=${warehouse.warehouseId}"
                               class="filter-reset">
                                Reset
                            </a>

                        </form>

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
                        <c:if test="${sensorTotalPages > 1}">

                            <div class="pagination">


                                <%-- PREVIOUS --%>

                                <c:if test="${sensorCurrentPage > 1}">

                                    <c:url var="sensorPrevUrl"
                                           value="/history">

                                        <c:param name="tab"
                                                 value="sensor"/>

                                        <c:param name="warehouseId"
                                                 value="${warehouse.warehouseId}"/>

                                        <c:param name="sensorKeyword"
                                                 value="${sensorKeyword}"/>

                                        <c:param name="rainStatus"
                                                 value="${selectedRainStatus}"/>

                                        <c:param name="lightStatus"
                                                 value="${selectedLightStatus}"/>

                                        <c:param name="sensorPage"
                                                 value="${sensorCurrentPage - 1}"/>

                                    </c:url>


                                    <a href="${sensorPrevUrl}">
                                        Previous
                                    </a>

                                </c:if>


                                <%-- PAGE NUMBER --%>

                                <c:forEach begin="1"
                                           end="${sensorTotalPages}"
                                           var="i">

                                    <c:url var="sensorPageUrl"
                                           value="/history">

                                        <c:param name="tab"
                                                 value="sensor"/>

                                        <c:param name="warehouseId"
                                                 value="${warehouse.warehouseId}"/>

                                        <c:param name="sensorKeyword"
                                                 value="${sensorKeyword}"/>

                                        <c:param name="rainStatus"
                                                 value="${selectedRainStatus}"/>

                                        <c:param name="lightStatus"
                                                 value="${selectedLightStatus}"/>

                                        <c:param name="sensorPage"
                                                 value="${i}"/>

                                    </c:url>


                                    <a href="${sensorPageUrl}"
                                       class="${i eq sensorCurrentPage
                                                ? 'active' : ''}">
                                           ${i}
                                       </a>

                                    </c:forEach>


                                    <%-- NEXT --%>

                                    <c:if test="${sensorCurrentPage < sensorTotalPages}">

                                        <c:url var="sensorNextUrl"
                                               value="/history">

                                            <c:param name="tab"
                                                     value="sensor"/>

                                            <c:param name="warehouseId"
                                                     value="${warehouse.warehouseId}"/>

                                            <c:param name="sensorKeyword"
                                                     value="${sensorKeyword}"/>

                                            <c:param name="rainStatus"
                                                     value="${selectedRainStatus}"/>

                                            <c:param name="lightStatus"
                                                     value="${selectedLightStatus}"/>

                                            <c:param name="sensorPage"
                                                     value="${sensorCurrentPage + 1}"/>

                                        </c:url>


                                        <a href="${sensorNextUrl}">
                                            Next
                                        </a>

                                    </c:if>

                                </div>

                            </c:if>

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

                            <form action="${pageContext.request.contextPath}/history"
                                  method="get"
                                  class="history-filter-form">

                                <%-- Giữ Batch tab --%>
                                <input type="hidden"
                                       name="tab"
                                       value="batch">

                                <%-- Giữ warehouse --%>
                                <input type="hidden"
                                       name="warehouseId"
                                       value="${warehouse.warehouseId}">


                                <%-- SEARCH --%>
                                <input type="text"
                                       name="batchKeyword"
                                       value="${batchKeyword}"
                                       placeholder="Search batch, product, operator...">


                                <%-- FROM DATE --%>
                                <div class="history-date-field">

                                    <label>
                                        From
                                    </label>

                                    <input type="date"
                                           name="fromDate"
                                           value="${fromDate}">

                                </div>


                                <%-- TO DATE --%>
                                <div class="history-date-field">

                                    <label>
                                        To
                                    </label>

                                    <input type="date"
                                           name="toDate"
                                           value="${toDate}">

                                </div>


                                <input type="hidden"
                                       name="batchPage"
                                       value="1">


                                <button type="submit"
                                        class="primary-button">
                                    Apply
                                </button>


                                <a href="${pageContext.request.contextPath}/history?tab=batch&warehouseId=${warehouse.warehouseId}"
                                   class="filter-reset">
                                    Reset
                                </a>

                            </form>

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

                            <c:if test="${batchTotalPages > 1}">

                                <div class="pagination">


                                    <%-- PREVIOUS --%>

                                    <c:if test="${batchCurrentPage > 1}">

                                        <c:url var="batchPrevUrl"
                                               value="/history">

                                            <c:param name="tab"
                                                     value="batch"/>

                                            <c:param name="warehouseId"
                                                     value="${warehouse.warehouseId}"/>

                                            <c:param name="batchKeyword"
                                                     value="${batchKeyword}"/>

                                            <c:param name="fromDate"
                                                     value="${fromDate}"/>

                                            <c:param name="toDate"
                                                     value="${toDate}"/>

                                            <c:param name="batchPage"
                                                     value="${batchCurrentPage - 1}"/>

                                        </c:url>


                                        <a href="${batchPrevUrl}">
                                            Previous
                                        </a>

                                    </c:if>


                                    <%-- PAGE NUMBER --%>

                                    <c:forEach begin="1"
                                               end="${batchTotalPages}"
                                               var="i">

                                        <c:url var="batchPageUrl"
                                               value="/history">

                                            <c:param name="tab"
                                                     value="batch"/>

                                            <c:param name="warehouseId"
                                                     value="${warehouse.warehouseId}"/>

                                            <c:param name="batchKeyword"
                                                     value="${batchKeyword}"/>

                                            <c:param name="fromDate"
                                                     value="${fromDate}"/>

                                            <c:param name="toDate"
                                                     value="${toDate}"/>

                                            <c:param name="batchPage"
                                                     value="${i}"/>

                                        </c:url>


                                        <a href="${batchPageUrl}"
                                           class="${i eq batchCurrentPage
                                                    ? 'active' : ''}">
                                               ${i}
                                           </a>

                                        </c:forEach>


                                        <%-- NEXT --%>

                                        <c:if test="${batchCurrentPage < batchTotalPages}">

                                            <c:url var="batchNextUrl"
                                                   value="/history">

                                                <c:param name="tab"
                                                         value="batch"/>

                                                <c:param name="warehouseId"
                                                         value="${warehouse.warehouseId}"/>

                                                <c:param name="batchKeyword"
                                                         value="${batchKeyword}"/>

                                                <c:param name="fromDate"
                                                         value="${fromDate}"/>

                                                <c:param name="toDate"
                                                         value="${toDate}"/>

                                                <c:param name="batchPage"
                                                         value="${batchCurrentPage + 1}"/>

                                            </c:url>


                                            <a href="${batchNextUrl}">
                                                Next
                                            </a>

                                        </c:if>

                                    </div>

                                </c:if>
                            </section>


                        </c:if>





                    </main>


                </div>


            </body>

        </html>