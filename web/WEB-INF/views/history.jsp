<%-- 
    Document   : history.jsp (Redesigned for Smart Agricultural Drying System)
    Description: Modern, responsive History console for Sensor readings and Completed Drying Batches,
                 supporting Laptop & Smartphone viewports while 100% preserving JSTL EL expressions and parameters.
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <title>Historical Records & Telemetry Logs - Smart Agricultural Drying System</title>
        <!-- Modern Typography -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600;700&display=swap" rel="stylesheet">
        <!-- Common & Page Stylesheets -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/history.css">
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
                    <%-- HEADER CARD & CONTEXT TILES                       --%>
                    <%-- ================================================= --%>
                    <header class="history-header-card">
                        <div class="header-meta">
                            <div class="header-badge-row">
                                <span class="role-pill">Archive & Analytics</span>
                                <span class="system-pill">
                                    <span class="pulse-dot"></span>
                                    Telemetry Database Active
                                </span>
                            </div>
                            <h1>Historical Records</h1>
                            <p class="header-subtitle">
                                Inspect longitudinal environmental sensor telemetry and archived agricultural drying batch lifecycle logs.
                            </p>
                        </div>

                        <div class="history-header-controls">
                            <%-- MANAGER: WAREHOUSE SELECTOR --%>
                            <c:if test="${sessionScope.LOGIN_USER.role eq 'MANAGER'}">
                                <div class="warehouse-select-card">
                                    <label for="warehouseSelect" class="selector-label">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                                        <polyline points="9 22 9 12 15 12 15 22"></polyline>
                                        </svg>
                                        Assigned Facility
                                    </label>
                                    <form action="${pageContext.request.contextPath}/history" method="get">
                                        <input type="hidden" name="tab" value="${tab}">
                                        <div class="select-box-wrap">
                                            <select id="warehouseSelect" name="warehouseId" onchange="this.form.submit()">
                                                <c:forEach var="w" items="${warehouseList}">
                                                    <c:choose>
                                                        <c:when test="${w.warehouseId eq warehouse.warehouseId}">
                                                            <option value="${w.warehouseId}" selected>
                                                                ${w.warehouseCode} - ${w.warehouseName}
                                                            </option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${w.warehouseId}">
                                                                ${w.warehouseCode} - ${w.warehouseName}
                                                            </option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                            <span class="select-arrow">▾</span>
                                        </div>
                                    </form>
                                </div>
                            </c:if>

                            <%-- CURRENT CONTEXT TILES --%>
                            <div class="context-pill-cluster">
                                <div class="context-pill-item">
                                    <div class="context-icon-wrap icon-wh">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                                        <polyline points="9 22 9 12 15 12 15 22"></polyline>
                                        </svg>
                                    </div>
                                    <div class="context-meta-text">
                                        <span class="context-label">Facility</span>
                                        <strong class="context-val" title="${warehouse.warehouseCode} - ${warehouse.warehouseName}">
                                            <c:choose>
                                                <c:when test="${warehouse ne null}">
                                                    ${warehouse.warehouseCode} - ${warehouse.warehouseName}
                                                </c:when>
                                                <c:otherwise>No Warehouse</c:otherwise>
                                            </c:choose>
                                        </strong>
                                    </div>
                                </div>

                                <div class="context-pill-item">
                                    <div class="context-icon-wrap icon-dev">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect x="4" y="4" width="16" height="16" rx="2" ry="2"></rect>
                                        <rect x="9" y="9" width="6" height="6"></rect>
                                        <line x1="9" y1="1" x2="9" y2="4"></line>
                                        <line x1="15" y1="1" x2="15" y2="4"></line>
                                        <line x1="9" y1="20" x2="9" y2="23"></line>
                                        <line x1="15" y1="20" x2="15" y2="23"></line>
                                        </svg>
                                    </div>
                                    <div class="context-meta-text">
                                        <span class="context-label">IoT Gateway</span>
                                        <strong class="context-val">
                                            <c:choose>
                                                <c:when test="${device ne null}">${device.deviceCode}</c:when>
                                                <c:otherwise>No Device</c:otherwise>
                                            </c:choose>
                                        </strong>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </header>

                    <%-- ================================================= --%>
                    <%-- ERROR ALERT (IF ANY)                              --%>
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
                    <%-- NAVIGATION TABS (SENSOR HISTORY vs BATCH HISTORY) --%>
                    <%-- ================================================= --%>
                    <div class="tab-switcher-card">
                        <nav class="history-tab-group" aria-label="History categories">
                            <a href="${pageContext.request.contextPath}/history?tab=sensor&warehouseId=${warehouse.warehouseId}"
                               class="tab-link-btn ${tab eq 'sensor' ? 'active' : ''}">
                                <div class="tab-icon-box">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M5 12.55a11 11 0 0 1 14.08 0"></path>
                                    <path d="M1.42 9a16 16 0 0 1 21.16 0"></path>
                                    <path d="M8.53 16.11a6 6 0 0 1 6.95 0"></path>
                                    <line x1="12" y1="20" x2="12.01" y2="20"></line>
                                    </svg>
                                </div>
                                <div class="tab-meta-copy">
                                    <span class="tab-main-label">Sensor Telemetry</span>
                                    <span class="tab-sub-label">Environmental timeseries</span>
                                </div>
                                <c:if test="${tab eq 'sensor'}"><span class="tab-active-indicator"></span></c:if>
                                </a>

                                <a href="${pageContext.request.contextPath}/history?tab=batch&warehouseId=${warehouse.warehouseId}"
                               class="tab-link-btn ${tab eq 'batch' ? 'active' : ''}">
                                <div class="tab-icon-box">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="12" cy="12" r="5"></circle>
                                    <line x1="12" y1="1" x2="12" y2="3"></line>
                                    <line x1="12" y1="21" x2="12" y2="23"></line>
                                    <line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line>
                                    <line x1="18.36" y1="18.36" x2="19.78" y2="19.78"></line>
                                    <line x1="1" y1="12" x2="3" y2="12"></line>
                                    <line x1="21" y1="12" x2="23" y2="12"></line>
                                    <line x1="4.22" y1="19.78" x2="5.64" y2="18.36"></line>
                                    <line x1="18.36" y1="5.64" x2="19.78" y2="4.22"></line>
                                    </svg>
                                </div>
                                <div class="tab-meta-copy">
                                    <span class="tab-main-label">Completed Batches</span>
                                    <span class="tab-sub-label">Finished drying runs</span>
                                </div>
                                <c:if test="${tab eq 'batch'}"><span class="tab-active-indicator"></span></c:if>
                                </a>
                            </nav>
                        </div>

                    <%-- ================================================= --%>
                    <%-- TAB 1: SENSOR TELEMETRY HISTORY                   --%>
                    <%-- ================================================= --%>
                    <c:if test="${tab eq 'sensor'}">
                        <section id="sensorHistorySection"
                                 class="history-content-card">
                            <div class="card-top-strip">
                                <div class="strip-header-cluster">
                                    <div class="strip-icon-box icon-sensor-strip">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline>
                                        </svg>
                                    </div>
                                    <div>
                                        <h2>Sensor Telemetry History</h2>
                                        <p>Historical environmental readings transmitted from facility sensors</p>
                                    </div>
                                </div>
                            </div>

                            <%-- SENSOR FILTER TOOLBAR --%>
                            <form action="${pageContext.request.contextPath}/history" method="get" class="filter-form-modern">
                                <input type="hidden" name="tab" value="sensor">
                                <input type="hidden" name="warehouseId" value="${warehouse.warehouseId}">
                                <input type="hidden" name="sensorPage" value="1">

                                <div class="filter-grid-layout-sensor">
                                    <div class="form-field search-field">
                                        <label for="sensorKeywordInput">Search Sensor ID</label>
                                        <div class="input-with-icon-wrap">
                                            <span class="input-icon-prefix">🔍</span>
                                            <input type="text" id="sensorKeywordInput" name="sensorKeyword" value="${sensorKeyword}" placeholder="Search sensor ID...">
                                        </div>
                                    </div>

                                    <div class="form-field">
                                        <label for="rainStatusSelect">Rain Status</label>
                                        <div class="select-wrapper">
                                            <select id="rainStatusSelect" name="rainStatus">
                                                <option value="">All Rain Status</option>
                                                <option value="NO_RAIN" ${selectedRainStatus eq 'NO_RAIN' ? 'selected' : ''}>No Rain</option>
                                                <option value="RAINING" ${selectedRainStatus eq 'RAINING' ? 'selected' : ''}>Raining</option>
                                            </select>
                                            <span class="select-arrow">▾</span>
                                        </div>
                                    </div>

                                    <div class="form-field">
                                        <label for="lightStatusSelect">Light Level</label>
                                        <div class="select-wrapper">
                                            <select id="lightStatusSelect" name="lightStatus">
                                                <option value="">All Light Levels</option>
                                                <option value="BRIGHT" ${selectedLightStatus eq 'BRIGHT' ? 'selected' : ''}>Bright</option>
                                                <option value="DARK" ${selectedLightStatus eq 'DARK' ? 'selected' : ''}>Dark</option>
                                            </select>
                                            <span class="select-arrow">▾</span>
                                        </div>
                                    </div>

                                    <div class="filter-button-cluster">
                                        <button type="submit" class="btn-filter-apply">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <circle cx="11" cy="11" r="8"></circle>
                                            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                            </svg>
                                            <span>Apply</span>
                                        </button>
                                        <a href="${pageContext.request.contextPath}/history?tab=sensor&warehouseId=${warehouse.warehouseId}" class="btn-filter-reset" title="Reset filter">
                                            Reset
                                        </a>
                                    </div>
                                </div>
                            </form>

                            <%-- DESKTOP SENSOR DATA TABLE --%>
                            <div class="table-responsive-wrapper desktop-only">
                                <table class="smart-history-table">
                                    <thead>
                                        <tr>
                                            <th>Recorded Time</th>
                                            <th>Temperature</th>
                                            <th>Humidity</th>
                                            <th>Rain Sensor</th>
                                            <th>Sunlight / Lux</th>
                                            <th>Roof Mechanism</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty sensors}">
                                                <c:forEach var="sensor" items="${sensors}">
                                                    <tr class="history-row">
                                                        <td class="time-cell">
                                                            <fmt:formatDate value="${sensor.recordedAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                                        </td>
                                                        <td class="metric-cell">
                                                            <span class="sensor-value-tag temp-tag">
                                                                🌡️ <strong><fmt:formatNumber value="${sensor.temperature}" maxFractionDigits="1"/></strong> °C
                                                            </span>
                                                        </td>
                                                        <td class="metric-cell">
                                                            <span class="sensor-value-tag hum-tag">
                                                                💧 <strong><fmt:formatNumber value="${sensor.humidity}" maxFractionDigits="1"/></strong> %
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${sensor.rainStatus eq 'RAINING'}">
                                                                    <span class="status-pill-sub pill-rain-active">🌧️ RAINING</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="status-pill-sub pill-rain-none">☀️ NO RAIN</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${sensor.lightStatus eq 'BRIGHT'}">
                                                                    <span class="status-pill-sub pill-light-bright">✨ BRIGHT</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="status-pill-sub pill-light-dark">🌙 DARK</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${sensor.roofStatus eq 'OPEN'}">
                                                                    <span class="status-pill-sub pill-roof-open">
                                                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M18 15l-6-6-6 6"/></svg>
                                                                        OPEN
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="status-pill-sub pill-roof-closed">
                                                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M6 9l6 6 6-6"/></svg>
                                                                        CLOSED
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="6" class="empty-state-cell">
                                                        <div class="empty-state-box">
                                                            <div class="empty-icon">📊</div>
                                                            <h4>No Sensor Records Found</h4>
                                                            <p>No historical telemetry entries match your current search filters.</p>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>

                            <%-- MOBILE CARDS VIEW (SMARTPHONES) --%>
                            <div class="mobile-sensor-card-list mobile-only">
                                <c:choose>
                                    <c:when test="${not empty sensors}">
                                        <c:forEach var="sensor" items="${sensors}">
                                            <article class="mobile-telemetry-card">
                                                <div class="m-card-top-row">
                                                    <span class="m-time-text">
                                                        <fmt:formatDate value="${sensor.recordedAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                                    </span>
                                                    <c:choose>
                                                        <c:when test="${sensor.roofStatus eq 'OPEN'}">
                                                            <span class="status-pill-sub pill-roof-open">OPEN</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-pill-sub pill-roof-closed">CLOSED</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <div class="m-telemetry-readings-grid">
                                                    <div class="m-reading-tile">
                                                        <span class="m-label">Temperature</span>
                                                        <strong class="m-val text-temp"><fmt:formatNumber value="${sensor.temperature}" maxFractionDigits="1"/> °C</strong>
                                                    </div>
                                                    <div class="m-reading-tile">
                                                        <span class="m-label">Humidity</span>
                                                        <strong class="m-val text-humidity"><fmt:formatNumber value="${sensor.humidity}" maxFractionDigits="1"/> %</strong>
                                                    </div>
                                                    <div class="m-reading-tile">
                                                        <span class="m-label">Rain Status</span>
                                                        <span class="m-val-badge">${sensor.rainStatus}</span>
                                                    </div>
                                                    <div class="m-reading-tile">
                                                        <span class="m-label">Light Level</span>
                                                        <span class="m-val-badge">${sensor.lightStatus}</span>
                                                    </div>
                                                </div>
                                            </article>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="empty-state-box">
                                            <div class="empty-icon">📊</div>
                                            <h4>No Sensor Records</h4>
                                            <p>No telemetry found for this filter criteria.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <%-- SENSOR PAGINATION --%>
                            <c:if test="${sensorTotalPages > 1}">
                                <div class="pagination-wrapper">

                                    <div class="pagination-info">
                                        Page
                                        <strong>${sensorCurrentPage}</strong>
                                        of
                                        <strong>${sensorTotalPages}</strong>
                                    </div>

                                    <div class="pagination-controls">

                                        <%-- PREVIOUS --%>
                                        <c:choose>
                                            <c:when test="${sensorCurrentPage > 1}">
                                                <c:url var="sensorPrevUrl" value="/history">
                                                    <c:param name="tab" value="sensor"/>
                                                    <c:param name="warehouseId" value="${warehouse.warehouseId}"/>
                                                    <c:param name="sensorKeyword" value="${sensorKeyword}"/>
                                                    <c:param name="rainStatus" value="${selectedRainStatus}"/>
                                                    <c:param name="lightStatus" value="${selectedLightStatus}"/>
                                                    <c:param name="sensorPage" value="${sensorCurrentPage - 1}"/>
                                                </c:url>

                                                <a href="${sensorPrevUrl}"
                                                   class="page-link-btn">
                                                    ‹ Prev
                                                </a>
                                            </c:when>

                                            <c:otherwise>
                                                <span class="page-link-btn disabled">
                                                    ‹ Prev
                                                </span>
                                            </c:otherwise>
                                        </c:choose>


                                        <%-- FIRST PAGE --%>
                                        <c:url var="sensorFirstUrl" value="/history">
                                            <c:param name="tab" value="sensor"/>
                                            <c:param name="warehouseId" value="${warehouse.warehouseId}"/>
                                            <c:param name="sensorKeyword" value="${sensorKeyword}"/>
                                            <c:param name="rainStatus" value="${selectedRainStatus}"/>
                                            <c:param name="lightStatus" value="${selectedLightStatus}"/>
                                            <c:param name="sensorPage" value="1"/>
                                        </c:url>

                                        <c:choose>
                                            <c:when test="${sensorCurrentPage == 1}">
                                                <span class="page-link-btn active">1</span>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${sensorFirstUrl}"
                                                   class="page-link-btn">
                                                    1
                                                </a>
                                            </c:otherwise>
                                        </c:choose>


                                        <%-- LEFT ELLIPSIS --%>
                                        <c:if test="${sensorCurrentPage > 4}">
                                            <span class="page-ellipsis">...</span>
                                        </c:if>


                                        <%-- MIDDLE PAGE WINDOW --%>
                                        <c:forEach begin="2"
                                                   end="${sensorTotalPages - 1}"
                                                   var="i">

                                            <c:if test="${
                                                  i >= sensorCurrentPage - 2
                                                      and i <= sensorCurrentPage + 2
                                                  }">

                                                <c:url var="sensorPageUrl" value="/history">
                                                    <c:param name="tab" value="sensor"/>
                                                    <c:param name="warehouseId" value="${warehouse.warehouseId}"/>
                                                    <c:param name="sensorKeyword" value="${sensorKeyword}"/>
                                                    <c:param name="rainStatus" value="${selectedRainStatus}"/>
                                                    <c:param name="lightStatus" value="${selectedLightStatus}"/>
                                                    <c:param name="sensorPage" value="${i}"/>
                                                </c:url>

                                                <c:choose>
                                                    <c:when test="${i == sensorCurrentPage}">
                                                        <span class="page-link-btn active">
                                                            ${i}
                                                        </span>
                                                    </c:when>

                                                    <c:otherwise>
                                                        <a href="${sensorPageUrl}"
                                                           class="page-link-btn">
                                                            ${i}
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>

                                            </c:if>
                                        </c:forEach>


                                        <%-- RIGHT ELLIPSIS --%>
                                        <c:if test="${sensorCurrentPage < sensorTotalPages - 3}">
                                            <span class="page-ellipsis">...</span>
                                        </c:if>


                                        <%-- LAST PAGE --%>
                                        <c:if test="${sensorTotalPages > 1}">

                                            <c:url var="sensorLastUrl" value="/history">
                                                <c:param name="tab" value="sensor"/>
                                                <c:param name="warehouseId" value="${warehouse.warehouseId}"/>
                                                <c:param name="sensorKeyword" value="${sensorKeyword}"/>
                                                <c:param name="rainStatus" value="${selectedRainStatus}"/>
                                                <c:param name="lightStatus" value="${selectedLightStatus}"/>
                                                <c:param name="sensorPage" value="${sensorTotalPages}"/>
                                            </c:url>

                                            <c:choose>
                                                <c:when test="${sensorCurrentPage == sensorTotalPages}">
                                                    <span class="page-link-btn active">
                                                        ${sensorTotalPages}
                                                    </span>
                                                </c:when>

                                                <c:otherwise>
                                                    <a href="${sensorLastUrl}"
                                                       class="page-link-btn">
                                                        ${sensorTotalPages}
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>

                                        </c:if>


                                        <%-- NEXT --%>
                                        <c:choose>
                                            <c:when test="${sensorCurrentPage < sensorTotalPages}">

                                                <c:url var="sensorNextUrl" value="/history">
                                                    <c:param name="tab" value="sensor"/>
                                                    <c:param name="warehouseId" value="${warehouse.warehouseId}"/>
                                                    <c:param name="sensorKeyword" value="${sensorKeyword}"/>
                                                    <c:param name="rainStatus" value="${selectedRainStatus}"/>
                                                    <c:param name="lightStatus" value="${selectedLightStatus}"/>
                                                    <c:param name="sensorPage" value="${sensorCurrentPage + 1}"/>
                                                </c:url>

                                                <a href="${sensorNextUrl}"
                                                   class="page-link-btn">
                                                    Next ›
                                                </a>

                                            </c:when>

                                            <c:otherwise>
                                                <span class="page-link-btn disabled">
                                                    Next ›
                                                </span>
                                            </c:otherwise>
                                        </c:choose>

                                    </div>
                                </div>
                            </c:if>
                        </section>
                    </c:if>

                    <%-- ================================================= --%>
                    <%-- TAB 2: COMPLETED DRYING BATCHES                   --%>
                    <%-- ================================================= --%>
                    <c:if test="${tab eq 'batch'}">
                        <section class="history-content-card">
                            <div class="card-top-strip">
                                <div class="strip-header-cluster">
                                    <div class="strip-icon-box icon-batch-strip">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                        <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                        </svg>
                                    </div>
                                    <div>
                                        <h2>Completed Drying Batches</h2>
                                        <p>Archived lifecycle records of finished produce dried in this warehouse</p>
                                    </div>
                                </div>
                            </div>

                            <%-- BATCH FILTER TOOLBAR --%>
                            <form action="${pageContext.request.contextPath}/history" method="get" class="filter-form-modern">
                                <input type="hidden" name="tab" value="batch">
                                <input type="hidden" name="warehouseId" value="${warehouse.warehouseId}">
                                <input type="hidden" name="batchPage" value="1">

                                <div class="filter-grid-layout-batch">
                                    <div class="form-field search-field">
                                        <label for="batchKeywordInput">Search Keyword</label>
                                        <div class="input-with-icon-wrap">
                                            <span class="input-icon-prefix">🔍</span>
                                            <input type="text" id="batchKeywordInput" name="batchKeyword" value="${batchKeyword}" placeholder="Batch ID, product name, operator...">
                                        </div>
                                    </div>

                                    <div class="form-field">
                                        <label for="fromDateInput">From Date</label>
                                        <input type="date" id="fromDateInput" name="fromDate" value="${fromDate}" class="date-picker-input">
                                    </div>

                                    <div class="form-field">
                                        <label for="toDateInput">To Date</label>
                                        <input type="date" id="toDateInput" name="toDate" value="${toDate}" class="date-picker-input">
                                    </div>

                                    <div class="filter-button-cluster">
                                        <button type="submit" class="btn-filter-apply">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <circle cx="11" cy="11" r="8"></circle>
                                            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                            </svg>
                                            <span>Filter</span>
                                        </button>
                                        <a href="${pageContext.request.contextPath}/history?tab=batch&warehouseId=${warehouse.warehouseId}" class="btn-filter-reset" title="Reset filter">
                                            Reset
                                        </a>
                                    </div>
                                </div>
                            </form>

                            <%-- DESKTOP COMPLETED BATCHES TABLE --%>
                            <div class="table-responsive-wrapper desktop-only">
                                <table class="smart-history-table">
                                    <thead>
                                        <tr>
                                            <th>Batch ID</th>
                                            <th>Product Name</th>
                                            <th>Operator</th>
                                            <th>Weight</th>
                                            <th>Start Time</th>
                                            <th>End Time</th>
                                            <th>Status</th>
                                            <th>Condition Notes</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty batches}">
                                                <c:forEach var="batch" items="${batches}">
                                                    <tr class="history-row">
                                                        <td class="batch-id-cell">
                                                            <span class="id-pill">#${batch.batchId}</span>
                                                        </td>
                                                        <td class="product-cell">
                                                            <div class="product-item">
                                                                <span class="product-icon">🌾</span>
                                                                <strong>${batch.productName}</strong>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <span class="operator-pill">${batch.operatorName}</span>
                                                        </td>
                                                        <td class="weight-cell">
                                                            <strong class="weight-val">
                                                                <fmt:formatNumber value="${batch.weightKg}" maxFractionDigits="2"/>
                                                            </strong>
                                                            <span class="weight-unit">kg</span>
                                                        </td>
                                                        <td class="time-cell">
                                                            <fmt:formatDate value="${batch.startTime}" pattern="dd/MM/yyyy HH:mm"/>
                                                        </td>
                                                        <td class="time-cell">
                                                            <c:choose>
                                                                <c:when test="${batch.endTime ne null}">
                                                                    <fmt:formatDate value="${batch.endTime}" pattern="dd/MM/yyyy HH:mm"/>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">—</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <span class="history-status-completed">
                                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                                                COMPLETED
                                                            </span>
                                                        </td>
                                                        <td class="notes-cell">
                                                            <c:choose>
                                                                <c:when test="${not empty batch.notes}">
                                                                    <span class="note-text-snippet" title="${batch.notes}">${batch.notes}</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">—</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="8" class="empty-state-cell">
                                                        <div class="empty-state-box">
                                                            <div class="empty-icon">🌾</div>
                                                            <h4>No Completed Batches Found</h4>
                                                            <p>No agricultural produce runs match the selected timeframe and search criteria.</p>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>

                            <%-- MOBILE COMPLETED BATCHES CARDS VIEW --%>
                            <div class="mobile-batch-card-list mobile-only">
                                <c:choose>
                                    <c:when test="${not empty batches}">
                                        <c:forEach var="batch" items="${batches}">
                                            <article class="mobile-batch-history-card">
                                                <div class="m-card-top-row">
                                                    <span class="id-pill">#B${batch.batchId}</span>
                                                    <span class="history-status-completed">
                                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                                        COMPLETED
                                                    </span>
                                                </div>

                                                <div class="m-batch-title-row">
                                                    <span class="product-icon">🌾</span>
                                                    <h3 class="m-product-title">${batch.productName}</h3>
                                                </div>

                                                <div class="m-batch-meta-grid">
                                                    <div class="m-meta-tile">
                                                        <span class="m-label">Loaded Weight</span>
                                                        <strong class="m-val highlight"><fmt:formatNumber value="${batch.weightKg}" maxFractionDigits="2"/> kg</strong>
                                                    </div>
                                                    <div class="m-meta-tile">
                                                        <span class="m-label">Field Operator</span>
                                                        <strong class="m-val">${batch.operatorName}</strong>
                                                    </div>
                                                    <div class="m-meta-tile">
                                                        <span class="m-label">Commenced</span>
                                                        <span class="m-time-text"><fmt:formatDate value="${batch.startTime}" pattern="dd/MM/yyyy HH:mm"/></span>
                                                    </div>
                                                    <div class="m-meta-tile">
                                                        <span class="m-label">Completed</span>
                                                        <span class="m-time-text">
                                                            <c:choose>
                                                                <c:when test="${batch.endTime ne null}">
                                                                    <fmt:formatDate value="${batch.endTime}" pattern="dd/MM/yyyy HH:mm"/>
                                                                </c:when>
                                                                <c:otherwise>—</c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </div>
                                                    <c:if test="${not empty batch.notes}">
                                                        <div class="m-meta-tile full-span notes-container">
                                                            <span class="m-label">Condition Notes</span>
                                                            <p class="m-notes-text">${batch.notes}</p>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </article>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="empty-state-box">
                                            <div class="empty-icon">🌾</div>
                                            <h4>No Batches Found</h4>
                                            <p>No finished batches found for this filter.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <%-- BATCH PAGINATION --%>
                            <c:if test="${batchTotalPages > 1}">
                                <div class="pagination-wrapper">

                                    <div class="pagination-info">
                                        Page
                                        <strong>${batchCurrentPage}</strong>
                                        of
                                        <strong>${batchTotalPages}</strong>
                                    </div>

                                    <div class="pagination-controls">

                                        <%-- PREVIOUS --%>
                                        <c:choose>
                                            <c:when test="${batchCurrentPage > 1}">

                                                <c:url var="batchPrevUrl" value="/history">
                                                    <c:param name="tab" value="batch"/>
                                                    <c:param name="warehouseId" value="${warehouse.warehouseId}"/>
                                                    <c:param name="batchKeyword" value="${batchKeyword}"/>
                                                    <c:param name="fromDate" value="${fromDate}"/>
                                                    <c:param name="toDate" value="${toDate}"/>
                                                    <c:param name="batchPage" value="${batchCurrentPage - 1}"/>
                                                </c:url>

                                                <a href="${batchPrevUrl}"
                                                   class="page-link-btn">
                                                    ‹ Prev
                                                </a>

                                            </c:when>

                                            <c:otherwise>
                                                <span class="page-link-btn disabled">
                                                    ‹ Prev
                                                </span>
                                            </c:otherwise>
                                        </c:choose>


                                        <%-- FIRST PAGE --%>
                                        <c:url var="batchFirstUrl" value="/history">
                                            <c:param name="tab" value="batch"/>
                                            <c:param name="warehouseId" value="${warehouse.warehouseId}"/>
                                            <c:param name="batchKeyword" value="${batchKeyword}"/>
                                            <c:param name="fromDate" value="${fromDate}"/>
                                            <c:param name="toDate" value="${toDate}"/>
                                            <c:param name="batchPage" value="1"/>
                                        </c:url>

                                        <c:choose>
                                            <c:when test="${batchCurrentPage == 1}">
                                                <span class="page-link-btn active">1</span>
                                            </c:when>

                                            <c:otherwise>
                                                <a href="${batchFirstUrl}"
                                                   class="page-link-btn">
                                                    1
                                                </a>
                                            </c:otherwise>
                                        </c:choose>


                                        <%-- LEFT ELLIPSIS --%>
                                        <c:if test="${batchCurrentPage > 4}">
                                            <span class="page-ellipsis">...</span>
                                        </c:if>


                                        <%-- MIDDLE PAGE WINDOW --%>
                                        <c:forEach begin="2"
                                                   end="${batchTotalPages - 1}"
                                                   var="i">

                                            <c:if test="${
                                                  i >= batchCurrentPage - 2
                                                      and i <= batchCurrentPage + 2
                                                  }">

                                                <c:url var="batchPageUrl" value="/history">
                                                    <c:param name="tab" value="batch"/>
                                                    <c:param name="warehouseId" value="${warehouse.warehouseId}"/>
                                                    <c:param name="batchKeyword" value="${batchKeyword}"/>
                                                    <c:param name="fromDate" value="${fromDate}"/>
                                                    <c:param name="toDate" value="${toDate}"/>
                                                    <c:param name="batchPage" value="${i}"/>
                                                </c:url>

                                                <c:choose>
                                                    <c:when test="${i == batchCurrentPage}">
                                                        <span class="page-link-btn active">
                                                            ${i}
                                                        </span>
                                                    </c:when>

                                                    <c:otherwise>
                                                        <a href="${batchPageUrl}"
                                                           class="page-link-btn">
                                                            ${i}
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>

                                            </c:if>
                                        </c:forEach>


                                        <%-- RIGHT ELLIPSIS --%>
                                        <c:if test="${batchCurrentPage < batchTotalPages - 3}">
                                            <span class="page-ellipsis">...</span>
                                        </c:if>


                                        <%-- LAST PAGE --%>
                                        <c:url var="batchLastUrl" value="/history">
                                            <c:param name="tab" value="batch"/>
                                            <c:param name="warehouseId" value="${warehouse.warehouseId}"/>
                                            <c:param name="batchKeyword" value="${batchKeyword}"/>
                                            <c:param name="fromDate" value="${fromDate}"/>
                                            <c:param name="toDate" value="${toDate}"/>
                                            <c:param name="batchPage" value="${batchTotalPages}"/>
                                        </c:url>

                                        <c:choose>
                                            <c:when test="${batchCurrentPage == batchTotalPages}">
                                                <span class="page-link-btn active">
                                                    ${batchTotalPages}
                                                </span>
                                            </c:when>

                                            <c:otherwise>
                                                <a href="${batchLastUrl}"
                                                   class="page-link-btn">
                                                    ${batchTotalPages}
                                                </a>
                                            </c:otherwise>
                                        </c:choose>


                                        <%-- NEXT --%>
                                        <c:choose>
                                            <c:when test="${batchCurrentPage < batchTotalPages}">

                                                <c:url var="batchNextUrl" value="/history">
                                                    <c:param name="tab" value="batch"/>
                                                    <c:param name="warehouseId" value="${warehouse.warehouseId}"/>
                                                    <c:param name="batchKeyword" value="${batchKeyword}"/>
                                                    <c:param name="fromDate" value="${fromDate}"/>
                                                    <c:param name="toDate" value="${toDate}"/>
                                                    <c:param name="batchPage" value="${batchCurrentPage + 1}"/>
                                                </c:url>

                                                <a href="${batchNextUrl}"
                                                   class="page-link-btn">
                                                    Next ›
                                                </a>

                                            </c:when>

                                            <c:otherwise>
                                                <span class="page-link-btn disabled">
                                                    Next ›
                                                </span>
                                            </c:otherwise>
                                        </c:choose>

                                    </div>
                                </div>
                            </c:if>
                        </section>
                    </c:if>

                    <%-- ================================================= --%>
                    <%-- FOOTER STATUS STRIP                               --%>
                    <%-- ================================================= --%>
                    <footer class="dashboard-footer">
                        <div class="footer-system-status">
                            <span class="pulse-dot"></span>
                            <span>Smart Agricultural Drying Telemetry & Batch Records Engine</span>
                        </div>
                        <div class="footer-version">
                            Archive Subsystem v2.4.0 · Connected
                        </div>
                    </footer>

                </div>
            </main>
        </div>
        <script>
// =====================================
// Refresh sensor history automatically
// =====================================

            function refreshSensorHistory() {

                var currentSection
                        = document.getElementById(
                                "sensorHistorySection"
                                );

// Do nothing when the Batch History tab is open
                if (!currentSection) {
                    return;
                }

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

                            var newSection
                                    = newDocument.getElementById(
                                            "sensorHistorySection"
                                            );

                            if (currentSection
                                    && newSection) {

                                currentSection.innerHTML
                                        = newSection.innerHTML;
                            }
                        })
                        .catch(function (error) {

                            console.error(
                                    "Failed to refresh sensor history:",
                                    error
                                    );
                        });
            }

// =====================================
// Refresh every 30 seconds
// =====================================

            setInterval(
                    refreshSensorHistory,
                    30000
                    );
        </script>
    </body>
</html>
