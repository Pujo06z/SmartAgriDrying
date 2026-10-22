<%-- 
    Document   : event-log.jsp (Redesigned for Smart Agricultural Drying System)
    Description: Modern, responsive Event Log console for Laptop & Mobile viewports,
                 fully preserving 100% of JSTL EL expressions, variables, and include paths.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Event Log - Smart Agricultural Drying System</title>
    <!-- Modern Typography -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600;700&display=swap" rel="stylesheet">
    <!-- Common & Page Stylesheets -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/event-log.css">
</head>
<body>
<div class="app-layout">
    <%-- ===================================================== --%>
    <%-- PERSISTENT SIDEBAR INCLUSION                          --%>
    <%-- ===================================================== --%>
    <jsp:include page="/WEB-INF/views/includes/sidebar.jsp"/>

    <%-- ===================================================== --%>
    <%-- MAIN CONTENT AREA                                     --%>
    <%-- ===================================================== --%>
    <main class="main-content">
        <div class="content-container">

            <%-- ================================================= --%>
            <%-- HEADER CARD & TELEMETRY BADGE                     --%>
            <%-- ================================================= --%>
            <header class="event-header-card">
                <div class="header-meta">
                    <div class="header-badge-row">
                        <span class="role-pill">Audit & Diagnostics</span>
                        <span class="system-pill">
                            <span class="pulse-dot"></span>
                            Telemetry Live
                        </span>
                    </div>
                    <h1>Event Log</h1>
                    <p class="header-subtitle">
                        Real-time audit trails, automated IoT actuations, and field operational logs across drying facilities.
                    </p>
                </div>

                <div class="header-total-badge">
                    <div class="total-icon-box">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                            <polyline points="14 2 14 8 20 8"></polyline>
                            <line x1="16" y1="13" x2="8" y2="13"></line>
                            <line x1="16" y1="17" x2="8" y2="17"></line>
                            <polyline points="10 9 9 9 8 9"></polyline>
                        </svg>
                    </div>
                    <div class="total-meta">
                        <span class="total-label">Total Events</span>
                        <strong class="total-val">${totalRecords}</strong>
                    </div>
                </div>
            </header>

            <%-- ================================================= --%>
            <%-- ERROR BANNER (IF ANY)                             --%>
            <%-- ================================================= --%>
            <c:if test="${not empty error}">
                <div class="alert-banner alert-error" role="alert">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="12" y1="8" x2="12" y2="12"></line>
                        <line x1="12" y1="16" x2="12.01" y2="16"></line>
                    </svg>
                    <span>${error}</span>
                </div>
            </c:if>

            <%-- ================================================= --%>
            <%-- FILTER & SEARCH SECTION                           --%>
            <%-- ================================================= --%>
            <section class="filter-card">
                <div class="filter-card-header">
                    <div class="filter-heading-cluster">
                        <div class="filter-icon-box">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="11" cy="11" r="8"></circle>
                                <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                            </svg>
                        </div>
                        <div>
                            <h2>Search & Telemetry Filters</h2>
                            <p>Refine sequential records by keyword, warehouse, event trigger, or source</p>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/events" class="btn-reset-link" title="Reset all filters">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="1 4 1 10 7 10"></polyline>
                            <path d="M3.51 15a9 9 0 1 0 2.13-9.36L1 10"></path>
                        </svg>
                        <span>Reset Filters</span>
                    </a>
                </div>

                <form action="${pageContext.request.contextPath}/events" method="get" class="filter-form-modern">
                    <div class="filter-grid-layout">
                        <%-- KEYWORD SEARCH --%>
                        <div class="form-field search-field">
                            <label for="keywordInput">Keyword Search</label>
                            <div class="input-with-icon-wrap">
                                <span class="input-icon-prefix">🔍</span>
                                <input type="text" id="keywordInput" name="keyword" value="${keyword}" placeholder="Event ID, device, batch, actor, description...">
                            </div>
                        </div>

                        <%-- WAREHOUSE SELECT (ADMIN / MANAGER) --%>
                        <c:if test="${sessionScope.LOGIN_USER.role eq 'ADMIN' or sessionScope.LOGIN_USER.role eq 'MANAGER'}">
                            <div class="form-field">
                                <label for="warehouseSelect">Warehouse</label>
                                <div class="select-wrapper">
                                    <select id="warehouseSelect" name="warehouseId">
                                        <c:if test="${sessionScope.LOGIN_USER.role eq 'ADMIN'}">
                                            <c:choose>
                                                <c:when test="${empty selectedWarehouseId}">
                                                    <option value="" selected>All Warehouses</option>
                                                </c:when>
                                                <c:otherwise>
                                                    <option value="">All Warehouses</option>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:if>
                                        <c:forEach var="warehouse" items="${warehouseList}">
                                            <c:choose>
                                                <c:when test="${warehouse.warehouseId eq selectedWarehouseId}">
                                                    <option value="${warehouse.warehouseId}" selected>
                                                        ${warehouse.warehouseId} - ${warehouse.warehouseCode}
                                                    </option>
                                                </c:when>
                                                <c:otherwise>
                                                    <option value="${warehouse.warehouseId}">
                                                        ${warehouse.warehouseId} - ${warehouse.warehouseCode}
                                                    </option>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                    </select>
                                    <span class="select-arrow">▾</span>
                                </div>
                            </div>
                        </c:if>

                        <%-- OPERATOR WAREHOUSE FIXED DISPLAY --%>
                        <c:if test="${sessionScope.LOGIN_USER.role eq 'OPERATOR'}">
                            <div class="form-field">
                                <label>Assigned Warehouse</label>
                                <div class="fixed-value-box">
                                    WH: ${selectedWarehouseId}
                                </div>
                            </div>
                        </c:if>

                        <%-- EVENT TYPE --%>
                        <div class="form-field">
                            <label for="eventTypeSelect">Event Type</label>
                            <div class="select-wrapper">
                                <select id="eventTypeSelect" name="eventType">
                                    <option value="">All Events</option>
                                    <option value="BATCH_STARTED" ${selectedEventType eq 'BATCH_STARTED' ? 'selected' : ''}>BATCH STARTED</option>
                                    <option value="BATCH_COMPLETED" ${selectedEventType eq 'BATCH_COMPLETED' ? 'selected' : ''}>BATCH COMPLETED</option>
                                    <option value="RAIN_DETECTED" ${selectedEventType eq 'RAIN_DETECTED' ? 'selected' : ''}>RAIN DETECTED</option>
                                    <option value="RAIN_STOPPED" ${selectedEventType eq 'RAIN_STOPPED' ? 'selected' : ''}>RAIN STOPPED</option>
                                    <option value="ROOF_OPENED" ${selectedEventType eq 'ROOF_OPENED' ? 'selected' : ''}>ROOF OPENED</option>
                                    <option value="ROOF_CLOSED" ${selectedEventType eq 'ROOF_CLOSED' ? 'selected' : ''}>ROOF CLOSED</option>
                                    <option value="MODE_CHANGED" ${selectedEventType eq 'MODE_CHANGED' ? 'selected' : ''}>MODE CHANGED</option>
                                </select>
                                <span class="select-arrow">▾</span>
                            </div>
                        </div>

                        <%-- SOURCE --%>
                        <div class="form-field">
                            <label for="sourceSelect">Source</label>
                            <div class="select-wrapper">
                                <select id="sourceSelect" name="source">
                                    <option value="" ${empty selectedSource ? 'selected' : ''}>All Sources</option>
                                    <option value="AUTO" ${selectedSource eq 'AUTO' ? 'selected' : ''}>AUTO (Telemetry)</option>
                                    <option value="MANUAL" ${selectedSource eq 'MANUAL' ? 'selected' : ''}>MANUAL (Field)</option>
                                    <option value="WEB" ${selectedSource eq 'WEB' ? 'selected' : ''}>WEB (Console)</option>
                                </select>
                                <span class="select-arrow">▾</span>
                            </div>
                        </div>

                        <%-- SORT BY --%>
                        <div class="form-field">
                            <label for="sortBySelect">Sort By</label>
                            <div class="select-wrapper">
                                <select id="sortBySelect" name="sortBy">
                                    <option value="createdAt" ${sortBy eq 'createdAt' ? 'selected' : ''}>Created Time</option>
                                    <option value="eventType" ${sortBy eq 'eventType' ? 'selected' : ''}>Event Type</option>
                                    <option value="source" ${sortBy eq 'source' ? 'selected' : ''}>Source Origin</option>
                                </select>
                                <span class="select-arrow">▾</span>
                            </div>
                        </div>

                        <%-- SORT ORDER --%>
                        <div class="form-field">
                            <label for="sortOrderSelect">Order</label>
                            <div class="select-wrapper">
                                <select id="sortOrderSelect" name="sortOrder">
                                    <option value="DESC" ${sortOrder eq 'DESC' ? 'selected' : ''}>Descending (Newest)</option>
                                    <option value="ASC" ${sortOrder eq 'ASC' ? 'selected' : ''}>Ascending (Oldest)</option>
                                </select>
                                <span class="select-arrow">▾</span>
                            </div>
                        </div>

                        <%-- SUBMIT ACTION --%>
                        <input type="hidden" name="page" value="1">
                        <div class="filter-action-wrap">
                            <button type="submit" class="btn-filter-submit">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                    <circle cx="11" cy="11" r="8"></circle>
                                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                </svg>
                                <span>Filter Logs</span>
                            </button>
                        </div>
                    </div>
                </form>
            </section>

            <%-- ================================================= --%>
            <%-- EVENT TABLE SECTION                               --%>
            <%-- ================================================= --%>
            <section class="event-table-card">
                <div class="table-header-strip">
                    <div class="strip-title-wrap">
                        <div class="strip-icon-box">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline>
                            </svg>
                        </div>
                        <div>
                            <h2>System Events & Telemetry Registry</h2>
                            <p>Chronological audit log stream from microcontrollers, actuations and operators</p>
                        </div>
                    </div>
                    <div class="records-badge">
                        Showing <strong>${totalRecords}</strong> sequential events
                    </div>
                </div>

                <%-- DESKTOP DATA TABLE --%>
                <div class="table-responsive-wrapper desktop-only">
                    <table class="smart-event-table">
                        <thead>
                        <tr>
                            <th>Time</th>
                            <th>Event ID</th>
                            <th>Event Type</th>
                            <th>Source</th>
                            <th>Warehouse</th>
                            <th>Device</th>
                            <th>Batch</th>
                            <th>Actor</th>
                            <th>Description</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty eventList}">
                                <c:forEach var="event" items="${eventList}">
                                    <tr class="event-row">
                                        <%-- TIME --%>
                                        <td class="time-cell">
                                            <fmt:formatDate value="${event.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                        </td>

                                        <%-- EVENT ID --%>
                                        <td class="event-id-cell">
                                            <span class="id-pill">#${event.eventId}</span>
                                        </td>

                                        <%-- EVENT TYPE --%>
                                        <td>
                                            <c:choose>
                                                <c:when test="${event.eventType eq 'BATCH_STARTED'}">
                                                    <span class="event-type-badge ev-batch-start">🌾 BATCH_STARTED</span>
                                                </c:when>
                                                <c:when test="${event.eventType eq 'BATCH_COMPLETED'}">
                                                    <span class="event-type-badge ev-batch-done">✅ BATCH_COMPLETED</span>
                                                </c:when>
                                                <c:when test="${event.eventType eq 'RAIN_DETECTED'}">
                                                    <span class="event-type-badge ev-rain-start">🌧️ RAIN_DETECTED</span>
                                                </c:when>
                                                <c:when test="${event.eventType eq 'RAIN_STOPPED'}">
                                                    <span class="event-type-badge ev-rain-stop">🌤️ RAIN_STOPPED</span>
                                                </c:when>
                                                <c:when test="${event.eventType eq 'ROOF_OPENED'}">
                                                    <span class="event-type-badge ev-roof-open">☀️ ROOF_OPENED</span>
                                                </c:when>
                                                <c:when test="${event.eventType eq 'ROOF_CLOSED'}">
                                                    <span class="event-type-badge ev-roof-close">🛡️ ROOF_CLOSED</span>
                                                </c:when>
                                                <c:when test="${event.eventType eq 'MODE_CHANGED'}">
                                                    <span class="event-type-badge ev-mode-change">⚙️ MODE_CHANGED</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="event-type-badge ev-generic">${event.eventType}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <%-- SOURCE --%>
                                        <td>
                                            <c:choose>
                                                <c:when test="${event.source eq 'AUTO'}">
                                                    <span class="source-pill source-auto">● AUTO</span>
                                                </c:when>
                                                <c:when test="${event.source eq 'MANUAL'}">
                                                    <span class="source-pill source-manual">● MANUAL</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="source-pill source-web">● WEB</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <%-- WAREHOUSE --%>
                                        <td>
                                            <span class="wh-badge" title="Warehouse ID: ${event.warehouseId}">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13">
                                                    <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                                                </svg>
                                                ${event.warehouseId}
                                            </span>
                                        </td>

                                        <%-- DEVICE --%>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty event.deviceId}">
                                                    <span class="dev-badge">DEV-${event.deviceId}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">—</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <%-- BATCH --%>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty event.batchId}">
                                                    <span class="batch-badge">#B${event.batchId}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">—</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <%-- ACTOR --%>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty event.actorUserId}">
                                                    <span class="actor-pill">
                                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="12" height="12">
                                                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                                            <circle cx="12" cy="7" r="4"></circle>
                                                        </svg>
                                                        ${event.actorUserId}
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="actor-system">SYSTEM</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <%-- DESCRIPTION --%>
                                        <td class="desc-text" title="${event.description}">
                                            ${event.description}
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="9" class="empty-state-cell">
                                        <div class="empty-state-box">
                                            <div class="empty-icon">📜</div>
                                            <h4>No Events Found</h4>
                                            <p>No telemetry records matched your filter criteria. Try resetting search parameters.</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>

                <%-- MOBILE CARDS VIEW (SMARTPHONE OPTIMIZATION) --%>
                <div class="mobile-event-card-list mobile-only">
                    <c:choose>
                        <c:when test="${not empty eventList}">
                            <c:forEach var="event" items="${eventList}">
                                <article class="mobile-event-card">
                                    <div class="mobile-card-top">
                                        <div class="m-badge-group">
                                            <span class="id-pill">#${event.eventId}</span>
                                            <c:choose>
                                                <c:when test="${event.eventType eq 'BATCH_STARTED'}">
                                                    <span class="event-type-badge ev-batch-start">🌾 BATCH_STARTED</span>
                                                </c:when>
                                                <c:when test="${event.eventType eq 'BATCH_COMPLETED'}">
                                                    <span class="event-type-badge ev-batch-done">✅ BATCH_COMPLETED</span>
                                                </c:when>
                                                <c:when test="${event.eventType eq 'RAIN_DETECTED'}">
                                                    <span class="event-type-badge ev-rain-start">🌧️ RAIN_DETECTED</span>
                                                </c:when>
                                                <c:when test="${event.eventType eq 'RAIN_STOPPED'}">
                                                    <span class="event-type-badge ev-rain-stop">🌤️ RAIN_STOPPED</span>
                                                </c:when>
                                                <c:when test="${event.eventType eq 'ROOF_OPENED'}">
                                                    <span class="event-type-badge ev-roof-open">☀️ ROOF_OPENED</span>
                                                </c:when>
                                                <c:when test="${event.eventType eq 'ROOF_CLOSED'}">
                                                    <span class="event-type-badge ev-roof-close">🛡️ ROOF_CLOSED</span>
                                                </c:when>
                                                <c:when test="${event.eventType eq 'MODE_CHANGED'}">
                                                    <span class="event-type-badge ev-mode-change">⚙️ MODE_CHANGED</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="event-type-badge ev-generic">${event.eventType}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <span class="m-time-text">
                                            <fmt:formatDate value="${event.createdAt}" pattern="dd/MM HH:mm:ss"/>
                                        </span>
                                    </div>

                                    <div class="m-meta-grid">
                                        <div class="m-meta-item">
                                            <span class="m-meta-label">Origin Source</span>
                                            <span class="m-meta-val">${event.source}</span>
                                        </div>
                                        <div class="m-meta-item">
                                            <span class="m-meta-label">Warehouse</span>
                                            <strong class="m-meta-val">WH: ${event.warehouseId}</strong>
                                        </div>
                                        <div class="m-meta-item">
                                            <span class="m-meta-label">Device</span>
                                            <span class="m-meta-val">${not empty event.deviceId ? event.deviceId : '—'}</span>
                                        </div>
                                        <div class="m-meta-item">
                                            <span class="m-meta-label">Batch ID</span>
                                            <span class="m-meta-val">${not empty event.batchId ? event.batchId : '—'}</span>
                                        </div>
                                        <div class="m-meta-item full-span">
                                            <span class="m-meta-label">Actor</span>
                                            <span class="m-meta-val">${not empty event.actorUserId ? event.actorUserId : 'SYSTEM'}</span>
                                        </div>
                                    </div>

                                    <div class="m-desc-box">
                                        ${event.description}
                                    </div>
                                </article>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state-box">
                                <div class="empty-icon">📜</div>
                                <h4>No Events Found</h4>
                                <p>No logs match the current search filters.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <%-- PAGINATION --%>
                <div class="pagination-wrapper">
                    <div class="pagination-info">
                        Showing <strong>${startRecord}</strong> - <strong>${endRecord}</strong> of <strong>${totalRecords}</strong> events
                    </div>

                    <div class="pagination-controls">
                        <%-- PREVIOUS --%>
                        <c:choose>
                            <c:when test="${currentPage > 1}">
                                <c:url var="previousUrl" value="/events">
                                    <c:param name="warehouseId" value="${selectedWarehouseId}"/>
                                    <c:param name="keyword" value="${keyword}"/>
                                    <c:param name="eventType" value="${selectedEventType}"/>
                                    <c:param name="source" value="${selectedSource}"/>
                                    <c:param name="sortBy" value="${sortBy}"/>
                                    <c:param name="sortOrder" value="${sortOrder}"/>
                                    <c:param name="page" value="${currentPage - 1}"/>
                                </c:url>
                                <a href="${previousUrl}" class="page-link-btn" aria-label="Previous page">‹ Prev</a>
                            </c:when>
                            <c:otherwise>
                                <span class="page-link-btn disabled">‹ Prev</span>
                            </c:otherwise>
                        </c:choose>

                        <%-- NUMBERS --%>
                        <c:forEach begin="1" end="${totalPages}" var="pageNumber">
                            <c:choose>
                                <c:when test="${pageNumber eq currentPage}">
                                    <span class="page-link-btn active">${pageNumber}</span>
                                </c:when>
                                <c:otherwise>
                                    <c:url var="pageUrl" value="/events">
                                        <c:param name="warehouseId" value="${selectedWarehouseId}"/>
                                        <c:param name="keyword" value="${keyword}"/>
                                        <c:param name="eventType" value="${selectedEventType}"/>
                                        <c:param name="source" value="${selectedSource}"/>
                                        <c:param name="sortBy" value="${sortBy}"/>
                                        <c:param name="sortOrder" value="${sortOrder}"/>
                                        <c:param name="page" value="${pageNumber}"/>
                                    </c:url>
                                    <a href="${pageUrl}" class="page-link-btn">${pageNumber}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>

                        <%-- NEXT --%>
                        <c:choose>
                            <c:when test="${currentPage < totalPages}">
                                <c:url var="nextUrl" value="/events">
                                    <c:param name="warehouseId" value="${selectedWarehouseId}"/>
                                    <c:param name="keyword" value="${keyword}"/>
                                    <c:param name="eventType" value="${selectedEventType}"/>
                                    <c:param name="source" value="${selectedSource}"/>
                                    <c:param name="sortBy" value="${sortBy}"/>
                                    <c:param name="sortOrder" value="${sortOrder}"/>
                                    <c:param name="page" value="${currentPage + 1}"/>
                                </c:url>
                                <a href="${nextUrl}" class="page-link-btn" aria-label="Next page">Next ›</a>
                            </c:when>
                            <c:otherwise>
                                <span class="page-link-btn disabled">Next ›</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </section>

            <%-- ================================================= --%>
            <%-- FOOTER STATUS STRIP                               --%>
            <%-- ================================================= --%>
            <footer class="dashboard-footer">
                <div class="footer-system-status">
                    <span class="pulse-dot"></span>
                    <span>Smart Agricultural Drying IoT Audit & Diagnostics Stream</span>
                </div>
                <div class="footer-version">
                    Audit Engine v2.4.0 · Connected
                </div>
            </footer>

        </div>
    </main>
</div>
            <script>
    // =====================================
    // Refresh event log automatically
    // =====================================

    function refreshEventLog() {

        fetch(window.location.href)
                .then(function (response) {

                    if (!response.ok) {
                        throw new Error(
                                "HTTP error: "
                                + response.status
                                );
                    }

                    return response.text();
                })
                .then(function (html) {

                    var parser
                            = new DOMParser();

                    var newDocument
                            = parser.parseFromString(
                                    html,
                                    "text/html"
                                    );

                    // =====================================
                    // Update event table
                    // =====================================

                    var currentTable
                            = document.querySelector(
                                    ".event-table-card"
                                    );

                    var newTable
                            = newDocument.querySelector(
                                    ".event-table-card"
                                    );

                    if (currentTable && newTable) {

                        currentTable.innerHTML
                                = newTable.innerHTML;
                    }

                    // =====================================
                    // Update total event counter
                    // =====================================

                    var currentTotal
                            = document.querySelector(
                                    ".header-total-badge"
                                    );

                    var newTotal
                            = newDocument.querySelector(
                                    ".header-total-badge"
                                    );

                    if (currentTotal && newTotal) {

                        currentTotal.innerHTML
                                = newTotal.innerHTML;
                    }
                })
                .catch(function (error) {

                    console.error(
                            "Failed to refresh event log:",
                            error
                            );
                });
    }

    // =====================================
    // Refresh every 10 seconds
    // =====================================

    setInterval(
            refreshEventLog,
            10000
            );
</script>
</body>
</html>
