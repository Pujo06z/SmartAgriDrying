<%-- 
    Document   : event-log
    Created on : Oct 9, 2026, 7:17:51 PM
    Author     : ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ taglib prefix="c"
           uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="fmt"
           uri="http://java.sun.com/jsp/jstl/fmt" %>


<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>Event Log</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/common.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/event-log.css">

</head>


<body>


<div class="app-layout">


    <%-- ===================================================== --%>
    <%-- SIDEBAR --%>
    <%-- ===================================================== --%>

    <jsp:include page="/WEB-INF/views/includes/sidebar.jsp"/>


    <%-- ===================================================== --%>
    <%-- MAIN CONTENT --%>
    <%-- ===================================================== --%>

    <main class="main-content">


        <%-- ================================================= --%>
        <%-- HEADER --%>
        <%-- ================================================= --%>

        <header class="event-page-header">

            <div>

                <h1>
                    Event Log
                </h1>

                <p>
                    View system events and operation history.
                </p>

            </div>

        </header>


        <%-- ================================================= --%>
        <%-- ERROR --%>
        <%-- ================================================= --%>

        <c:if test="${not empty error}">

            <div class="alert-error">

                ${error}

            </div>

        </c:if>


        <%-- ================================================= --%>
        <%-- FILTER SECTION --%>
        <%-- ================================================= --%>

        <section class="filter-section">


            <div class="section-title">

                <h2>
                    Search & Filter
                </h2>

                <a href="${pageContext.request.contextPath}/events"
                   class="btn-reset">

                    Reset

                </a>

            </div>


            <form action="${pageContext.request.contextPath}/events"
                  method="get"
                  class="filter-form">


                <%-- ========================================= --%>
                <%-- SEARCH --%>
                <%-- ========================================= --%>

                <div class="filter-group search-group">

                    <label>
                        Search
                    </label>

                    <input type="text"
                           name="keyword"
                           value="${keyword}"
                           placeholder="Event ID, device, batch, actor, description...">

                </div>


                <%-- ========================================= --%>
                <%-- WAREHOUSE FILTER --%>
                <%-- ADMIN / MANAGER ONLY --%>
                <%-- ========================================= --%>

                <c:if test="${sessionScope.LOGIN_USER.role eq 'ADMIN'
                             or sessionScope.LOGIN_USER.role eq 'MANAGER'}">


                    <div class="filter-group">

                        <label>
                            Warehouse
                        </label>


                        <select name="warehouseId">


                            <%-- ADMIN được chọn tất cả warehouse --%>

                            <c:if test="${sessionScope.LOGIN_USER.role eq 'ADMIN'}">


                                <c:choose>


                                    <c:when test="${empty selectedWarehouseId}">

                                        <option value=""
                                                selected>

                                            All Warehouses

                                        </option>

                                    </c:when>


                                    <c:otherwise>

                                        <option value="">

                                            All Warehouses

                                        </option>

                                    </c:otherwise>


                                </c:choose>


                            </c:if>


                            <%-- WAREHOUSE LIST --%>

                            <c:forEach var="warehouse"
                                       items="${warehouseList}">


                                <c:choose>


                                    <c:when test="${warehouse.warehouseId eq selectedWarehouseId}">

                                        <option value="${warehouse.warehouseId}"
                                                selected>

                                            ${warehouse.warehouseId}

                                        </option>

                                    </c:when>


                                    <c:otherwise>

                                        <option value="${warehouse.warehouseId}">

                                            ${warehouse.warehouseId}

                                        </option>

                                    </c:otherwise>


                                </c:choose>


                            </c:forEach>


                        </select>

                    </div>


                </c:if>


                <%-- ========================================= --%>
                <%-- OPERATOR WAREHOUSE DISPLAY --%>
                <%-- ========================================= --%>

                <c:if test="${sessionScope.LOGIN_USER.role eq 'OPERATOR'}">

                    <div class="filter-group">

                        <label>
                            Warehouse
                        </label>

                        <div class="fixed-value">

                            ${selectedWarehouseId}

                        </div>

                    </div>

                </c:if>


                <%-- ========================================= --%>
                <%-- EVENT TYPE --%>
                <%-- ========================================= --%>

                <div class="filter-group">

                    <label>
                        Event Type
                    </label>


                    <select name="eventType">


                        <option value="">
                            All Events
                        </option>


                        <c:choose>

                            <c:when test="${selectedEventType eq 'BATCH_STARTED'}">

                                <option value="BATCH_STARTED"
                                        selected>
                                    BATCH STARTED
                                </option>

                            </c:when>

                            <c:otherwise>

                                <option value="BATCH_STARTED">
                                    BATCH STARTED
                                </option>

                            </c:otherwise>

                        </c:choose>


                        <c:choose>

                            <c:when test="${selectedEventType eq 'BATCH_COMPLETED'}">

                                <option value="BATCH_COMPLETED"
                                        selected>
                                    BATCH COMPLETED
                                </option>

                            </c:when>

                            <c:otherwise>

                                <option value="BATCH_COMPLETED">
                                    BATCH COMPLETED
                                </option>

                            </c:otherwise>

                        </c:choose>


                        <c:choose>

                            <c:when test="${selectedEventType eq 'RAIN_DETECTED'}">

                                <option value="RAIN_DETECTED"
                                        selected>
                                    RAIN DETECTED
                                </option>

                            </c:when>

                            <c:otherwise>

                                <option value="RAIN_DETECTED">
                                    RAIN DETECTED
                                </option>

                            </c:otherwise>

                        </c:choose>


                        <c:choose>

                            <c:when test="${selectedEventType eq 'RAIN_STOPPED'}">

                                <option value="RAIN_STOPPED"
                                        selected>
                                    RAIN STOPPED
                                </option>

                            </c:when>

                            <c:otherwise>

                                <option value="RAIN_STOPPED">
                                    RAIN STOPPED
                                </option>

                            </c:otherwise>

                        </c:choose>


                        <c:choose>

                            <c:when test="${selectedEventType eq 'ROOF_OPENED'}">

                                <option value="ROOF_OPENED"
                                        selected>
                                    ROOF OPENED
                                </option>

                            </c:when>

                            <c:otherwise>

                                <option value="ROOF_OPENED">
                                    ROOF OPENED
                                </option>

                            </c:otherwise>

                        </c:choose>


                        <c:choose>

                            <c:when test="${selectedEventType eq 'ROOF_CLOSED'}">

                                <option value="ROOF_CLOSED"
                                        selected>
                                    ROOF CLOSED
                                </option>

                            </c:when>

                            <c:otherwise>

                                <option value="ROOF_CLOSED">
                                    ROOF CLOSED
                                </option>

                            </c:otherwise>

                        </c:choose>


                        <c:choose>

                            <c:when test="${selectedEventType eq 'MODE_CHANGED'}">

                                <option value="MODE_CHANGED"
                                        selected>
                                    MODE CHANGED
                                </option>

                            </c:when>

                            <c:otherwise>

                                <option value="MODE_CHANGED">
                                    MODE CHANGED
                                </option>

                            </c:otherwise>

                        </c:choose>


                    </select>

                </div>


                <%-- ========================================= --%>
                <%-- SOURCE --%>
                <%-- ========================================= --%>

                <div class="filter-group">

                    <label>
                        Source
                    </label>


                    <select name="source">


                        <c:choose>

                            <c:when test="${empty selectedSource}">

                                <option value=""
                                        selected>

                                    All Sources

                                </option>

                            </c:when>

                            <c:otherwise>

                                <option value="">

                                    All Sources

                                </option>

                            </c:otherwise>

                        </c:choose>


                        <c:choose>

                            <c:when test="${selectedSource eq 'AUTO'}">

                                <option value="AUTO"
                                        selected>

                                    AUTO

                                </option>

                            </c:when>

                            <c:otherwise>

                                <option value="AUTO">

                                    AUTO

                                </option>

                            </c:otherwise>

                        </c:choose>


                        <c:choose>

                            <c:when test="${selectedSource eq 'MANUAL'}">

                                <option value="MANUAL"
                                        selected>

                                    MANUAL

                                </option>

                            </c:when>

                            <c:otherwise>

                                <option value="MANUAL">

                                    MANUAL

                                </option>

                            </c:otherwise>

                        </c:choose>


                        <c:choose>

                            <c:when test="${selectedSource eq 'WEB'}">

                                <option value="WEB"
                                        selected>

                                    WEB

                                </option>

                            </c:when>

                            <c:otherwise>

                                <option value="WEB">

                                    WEB

                                </option>

                            </c:otherwise>

                        </c:choose>


                    </select>

                </div>


                <%-- ========================================= --%>
                <%-- SORT BY --%>
                <%-- ========================================= --%>

                <div class="filter-group">

                    <label>
                        Sort By
                    </label>


                    <select name="sortBy">


                        <c:choose>

                            <c:when test="${sortBy eq 'createdAt'}">

                                <option value="createdAt"
                                        selected>

                                    Created Time

                                </option>

                            </c:when>

                            <c:otherwise>

                                <option value="createdAt">

                                    Created Time

                                </option>

                            </c:otherwise>

                        </c:choose>


                        <c:choose>

                            <c:when test="${sortBy eq 'eventType'}">

                                <option value="eventType"
                                        selected>

                                    Event Type

                                </option>

                            </c:when>

                            <c:otherwise>

                                <option value="eventType">

                                    Event Type

                                </option>

                            </c:otherwise>

                        </c:choose>


                        <c:choose>

                            <c:when test="${sortBy eq 'source'}">

                                <option value="source"
                                        selected>

                                    Source

                                </option>

                            </c:when>

                            <c:otherwise>

                                <option value="source">

                                    Source

                                </option>

                            </c:otherwise>

                        </c:choose>


                    </select>

                </div>


                <%-- ========================================= --%>
                <%-- SORT ORDER --%>
                <%-- ========================================= --%>

                <div class="filter-group">

                    <label>
                        Order
                    </label>


                    <select name="sortOrder">


                        <c:choose>

                            <c:when test="${sortOrder eq 'DESC'}">

                                <option value="DESC"
                                        selected>

                                    Descending

                                </option>

                            </c:when>

                            <c:otherwise>

                                <option value="DESC">

                                    Descending

                                </option>

                            </c:otherwise>

                        </c:choose>


                        <c:choose>

                            <c:when test="${sortOrder eq 'ASC'}">

                                <option value="ASC"
                                        selected>

                                    Ascending

                                </option>

                            </c:when>

                            <c:otherwise>

                                <option value="ASC">

                                    Ascending

                                </option>

                            </c:otherwise>

                        </c:choose>


                    </select>

                </div>


                <%-- Khi filter/search lại thì quay về page 1 --%>

                <input type="hidden"
                       name="page"
                       value="1">


                <div class="filter-action">

                    <button type="submit"
                            class="btn-search">

                        Search

                    </button>

                </div>


            </form>


        </section>


        <%-- ================================================= --%>
        <%-- EVENT TABLE SECTION --%>
        <%-- ================================================= --%>

        <section class="event-section">


            <div class="event-section-header">

                <div>

                    <h2>
                        System Events
                    </h2>

                    <p>
                        ${totalRecords} event(s) found.
                    </p>

                </div>

            </div>


            <div class="table-wrapper">


                <table class="event-table">


                    <thead>

                    <tr>

                        <th>
                            Time
                        </th>

                        <th>
                            Event ID
                        </th>

                        <th>
                            Event Type
                        </th>

                        <th>
                            Source
                        </th>

                        <th>
                            Warehouse
                        </th>

                        <th>
                            Device
                        </th>

                        <th>
                            Batch
                        </th>

                        <th>
                            Actor
                        </th>

                        <th>
                            Description
                        </th>

                    </tr>

                    </thead>


                    <tbody>


                    <c:choose>


                        <%-- ================================= --%>
                        <%-- HAVE EVENTS --%>
                        <%-- ================================= --%>

                        <c:when test="${not empty eventList}">


                            <c:forEach var="event"
                                       items="${eventList}">


                                <tr>


                                    <%-- TIME --%>

                                    <td class="event-time">

                                        <fmt:formatDate
                                                value="${event.createdAt}"
                                                pattern="dd/MM/yyyy HH:mm:ss"/>

                                    </td>


                                    <%-- EVENT ID --%>

                                    <td class="event-id">

                                        ${event.eventId}

                                    </td>


                                    <%-- EVENT TYPE --%>

                                    <td>

                                        <span class="event-type">

                                            ${event.eventType}

                                        </span>

                                    </td>


                                    <%-- SOURCE --%>

                                    <td>


                                        <c:choose>


                                            <c:when test="${event.source eq 'AUTO'}">

                                                <span class="source-auto">

                                                    AUTO

                                                </span>

                                            </c:when>


                                            <c:when test="${event.source eq 'MANUAL'}">

                                                <span class="source-manual">

                                                    MANUAL

                                                </span>

                                            </c:when>


                                            <c:otherwise>

                                                <span class="source-web">

                                                    WEB

                                                </span>

                                            </c:otherwise>


                                        </c:choose>


                                    </td>


                                    <%-- WAREHOUSE --%>

                                    <td>

                                        ${event.warehouseId}

                                    </td>


                                    <%-- DEVICE --%>

                                    <td>


                                        <c:choose>

                                            <c:when test="${not empty event.deviceId}">

                                                ${event.deviceId}

                                            </c:when>

                                            <c:otherwise>

                                                <span class="text-muted">
                                                    -
                                                </span>

                                            </c:otherwise>

                                        </c:choose>


                                    </td>


                                    <%-- BATCH --%>

                                    <td>


                                        <c:choose>

                                            <c:when test="${not empty event.batchId}">

                                                ${event.batchId}

                                            </c:when>

                                            <c:otherwise>

                                                <span class="text-muted">
                                                    -
                                                </span>

                                            </c:otherwise>

                                        </c:choose>


                                    </td>


                                    <%-- ACTOR --%>

                                    <td>


                                        <c:choose>

                                            <c:when test="${not empty event.actorUserId}">

                                                ${event.actorUserId}

                                            </c:when>

                                            <c:otherwise>

                                                <span class="text-muted">

                                                    SYSTEM

                                                </span>

                                            </c:otherwise>

                                        </c:choose>


                                    </td>


                                    <%-- DESCRIPTION --%>

                                    <td class="description-cell">

                                        ${event.description}

                                    </td>


                                </tr>


                            </c:forEach>


                        </c:when>


                        <%-- ================================= --%>
                        <%-- EMPTY --%>
                        <%-- ================================= --%>

                        <c:otherwise>


                            <tr>

                                <td colspan="9"
                                    class="empty-row">

                                    No events found.

                                </td>

                            </tr>


                        </c:otherwise>


                    </c:choose>


                    </tbody>


                </table>


            </div>


            <%-- ================================================= --%>
            <%-- PAGINATION --%>
            <%-- ================================================= --%>

            <div class="pagination-wrapper">


                <div class="pagination-info">

                    Showing

                    <strong>
                        ${startRecord}
                    </strong>

                    -

                    <strong>
                        ${endRecord}
                    </strong>

                    of

                    <strong>
                        ${totalRecords}
                    </strong>

                    events

                </div>


                <div class="pagination">


                    <%-- ========================================= --%>
                    <%-- PREVIOUS --%>
                    <%-- ========================================= --%>

                    <c:choose>


                        <c:when test="${currentPage > 1}">


                            <c:url var="previousUrl"
                                   value="/events">


                                <c:param name="warehouseId"
                                         value="${selectedWarehouseId}"/>

                                <c:param name="keyword"
                                         value="${keyword}"/>

                                <c:param name="eventType"
                                         value="${selectedEventType}"/>

                                <c:param name="source"
                                         value="${selectedSource}"/>

                                <c:param name="sortBy"
                                         value="${sortBy}"/>

                                <c:param name="sortOrder"
                                         value="${sortOrder}"/>

                                <c:param name="page"
                                         value="${currentPage - 1}"/>


                            </c:url>


                            <a href="${previousUrl}"
                               class="page-link">

                                Previous

                            </a>


                        </c:when>


                        <c:otherwise>


                            <span class="page-link disabled">

                                Previous

                            </span>


                        </c:otherwise>


                    </c:choose>


                    <%-- ========================================= --%>
                    <%-- PAGE NUMBERS --%>
                    <%-- ========================================= --%>

                    <c:forEach begin="1"
                               end="${totalPages}"
                               var="pageNumber">


                        <c:choose>


                            <c:when test="${pageNumber eq currentPage}">

                                <span class="page-link active">

                                    ${pageNumber}

                                </span>

                            </c:when>


                            <c:otherwise>


                                <c:url var="pageUrl"
                                       value="/events">


                                    <c:param name="warehouseId"
                                             value="${selectedWarehouseId}"/>

                                    <c:param name="keyword"
                                             value="${keyword}"/>

                                    <c:param name="eventType"
                                             value="${selectedEventType}"/>

                                    <c:param name="source"
                                             value="${selectedSource}"/>

                                    <c:param name="sortBy"
                                             value="${sortBy}"/>

                                    <c:param name="sortOrder"
                                             value="${sortOrder}"/>

                                    <c:param name="page"
                                             value="${pageNumber}"/>


                                </c:url>


                                <a href="${pageUrl}"
                                   class="page-link">

                                    ${pageNumber}

                                </a>


                            </c:otherwise>


                        </c:choose>


                    </c:forEach>


                    <%-- ========================================= --%>
                    <%-- NEXT --%>
                    <%-- ========================================= --%>

                    <c:choose>


                        <c:when test="${currentPage < totalPages}">


                            <c:url var="nextUrl"
                                   value="/events">


                                <c:param name="warehouseId"
                                         value="${selectedWarehouseId}"/>

                                <c:param name="keyword"
                                         value="${keyword}"/>

                                <c:param name="eventType"
                                         value="${selectedEventType}"/>

                                <c:param name="source"
                                         value="${selectedSource}"/>

                                <c:param name="sortBy"
                                         value="${sortBy}"/>

                                <c:param name="sortOrder"
                                         value="${sortOrder}"/>

                                <c:param name="page"
                                         value="${currentPage + 1}"/>


                            </c:url>


                            <a href="${nextUrl}"
                               class="page-link">

                                Next

                            </a>


                        </c:when>


                        <c:otherwise>


                            <span class="page-link disabled">

                                Next

                            </span>


                        </c:otherwise>


                    </c:choose>


                </div>


            </div>


        </section>


    </main>


</div>


</body>

</html>