<%-- 
    Document   : manager-dashboard.jsp (Redesigned for Smart Agricultural Drying System)
    Description: Modern, responsive Manager Dashboard for Laptop & Mobile viewports,
                 fully preserving 100% of JSTL EL expressions, variables, and include paths.
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <title>Manager Dashboard - Smart Agricultural Drying System</title>
        <!-- Modern Typography -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600&display=swap" rel="stylesheet">
        <!-- Common & Page Stylesheets -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager-dashboard.css">
    </head>
    <body>
        <div class="app-layout">
            <%-- ================================================= --%>
            <%-- PERSISTENT SIDEBAR INCLUSION                      --%>
            <%-- ================================================= --%>
            <jsp:include page="/WEB-INF/views/includes/sidebar.jsp"/>

            <main class="main-content">
                <div class="content-container">

                    <%-- ================================================= --%>
                    <%-- HEADER & WAREHOUSE SELECTION WIDGET               --%>
                    <%-- ================================================= --%>
                    <header class="manager-header-card">
                        <div class="header-meta">
                            <div class="header-badge-row">
                                <span class="role-pill">Manager</span>
                                <span class="live-pill">
                                    <span class="pulse-dot"></span>
                                    Telemetry Active
                                </span>
                            </div>
                            <h1>Manager Dashboard</h1>
                            <p class="header-subtitle">
                                Welcome back, <strong>${sessionScope.LOGIN_USER.fullName}</strong>. Live supervision of facility drying processes.
                            </p>
                        </div>

                        <%-- WAREHOUSE SELECTION FORM --%>
                        <div class="header-warehouse-widget">
                            <label for="warehouseSelect" class="widget-label">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                                <polyline points="9 22 9 12 15 12 15 22"></polyline>
                                </svg>
                                Select Warehouse
                            </label>
                            <form action="${pageContext.request.contextPath}/dashboard" method="get">
                                <div class="custom-select-box">
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
                    <%-- CURRENT CONTEXT TILES (WAREHOUSE & DEVICE)        --%>
                    <%-- ================================================= --%>
                    <div class="context-strip">
                        <div class="context-tile">
                            <div class="tile-icon-box icon-warehouse">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                                <polyline points="9 22 9 12 15 12 15 22"></polyline>
                                </svg>
                            </div>
                            <div class="tile-info">
                                <span class="tile-tag">Active Facility</span>
                                <strong class="tile-title">
                                    ${warehouse.warehouseCode} - ${warehouse.warehouseName}
                                </strong>
                            </div>
                        </div>

                        <div class="context-tile">
                            <div class="tile-icon-box icon-device">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <rect x="4" y="4" width="16" height="16" rx="2" ry="2"></rect>
                                <rect x="9" y="9" width="6" height="6"></rect>
                                <line x1="9" y1="1" x2="9" y2="4"></line>
                                <line x1="15" y1="1" x2="15" y2="4"></line>
                                <line x1="9" y1="20" x2="9" y2="23"></line>
                                <line x1="15" y1="20" x2="15" y2="23"></line>
                                <line x1="20" y1="9" x2="23" y2="9"></line>
                                <line x1="20" y1="14" x2="23" y2="14"></line>
                                <line x1="1" y1="9" x2="4" y2="9"></line>
                                <line x1="1" y1="14" x2="4" y2="14"></line>
                                </svg>
                            </div>
                            <div class="tile-info">
                                <span class="tile-tag">IoT Controller Gateway</span>
                                <strong class="tile-title">
                                    <c:choose>
                                        <c:when test="${device ne null}">
                                            ${device.deviceCode}
                                        </c:when>
                                        <c:otherwise>
                                            No Device Assigned
                                        </c:otherwise>
                                    </c:choose>
                                </strong>
                            </div>
                        </div>
                    </div>

                    <%-- ================================================= --%>
                    <%-- SECTION 1: CURRENT SYSTEM STATUS (TELEMETRY)      --%>
                    <%-- ================================================= --%>
                    <section class="dashboard-section">
                        <div class="section-header">
                            <div class="section-title-wrap">
                                <div class="section-icon-box icon-telemetry">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M5 12.55a11 11 0 0 1 14.08 0"></path>
                                    <path d="M1.42 9a16 16 0 0 1 21.16 0"></path>
                                    <path d="M8.53 16.11a6 6 0 0 1 6.95 0"></path>
                                    <line x1="12" y1="20" x2="12.01" y2="20"></line>
                                    </svg>
                                </div>
                                <div>
                                    <h2>Current System Status</h2>
                                    <p>Real-time telemetry readings from installed environmental sensors</p>
                                </div>
                            </div>
                        </div>

                        <div class="telemetry-grid">
                            <%-- ESP CONNECTION --%>
                            <div id="espCard"
                                 class="telemetry-card card-esp ${dashboard.connectionStatus eq 'ONLINE' ? 'is-online' : ''}">
                                <div class="telemetry-top">
                                    <span class="telemetry-label">ESP Status</span>
                                    <div class="telemetry-icon">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M5 12.55a11 11 0 0 1 14.08 0"></path>
                                        <line x1="12" y1="20" x2="12.01" y2="20"></line>
                                        </svg>
                                    </div>
                                </div>
                                <strong id="connectionStatus">${dashboard.connectionStatus}</strong>
                            </div>

                            <%-- TEMPERATURE --%>
                            <div class="telemetry-card">
                                <div class="telemetry-top">
                                    <span class="telemetry-label">Temperature</span>
                                    <div class="telemetry-icon">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M14 14.76V3.5a2.5 2.5 0 0 0-5 0v11.26a4.5 4.5 0 1 0 5 0z"></path>
                                        </svg>
                                    </div>
                                </div>
                                <strong id="temperature">
                                    <fmt:formatNumber value="${dashboard.temperature}" maxFractionDigits="1"/> °C
                                </strong>
                            </div>

                            <%-- HUMIDITY --%>
                            <div class="telemetry-card">
                                <div class="telemetry-top">
                                    <span class="telemetry-label">Humidity</span>
                                    <div class="telemetry-icon">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M12 2.69l5.66 5.66a8 8 0 1 1-11.31 0z"></path>
                                        </svg>
                                    </div>
                                </div>
                                <strong  id="humidity">
                                    <fmt:formatNumber value="${dashboard.humidity}" maxFractionDigits="1"/> %
                                </strong>
                            </div>

                            <%-- RAIN --%>
                            <div class="telemetry-card">
                                <div class="telemetry-top">
                                    <span class="telemetry-label">Rain Sensor</span>
                                    <div class="telemetry-icon">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <line x1="16" y1="13" x2="16" y2="21"></line>
                                        <line x1="8" y1="13" x2="8" y2="21"></line>
                                        <line x1="12" y1="15" x2="12" y2="23"></line>
                                        <path d="M20 16.58A5 5 0 0 0 18 7h-1.26A8 8 0 1 0 4 15.25"></path>
                                        </svg>
                                    </div>
                                </div>
                                <strong id="rainStatus">${dashboard.rainStatus}</strong>
                            </div>

                            <%-- LIGHT --%>
                            <div class="telemetry-card">
                                <div class="telemetry-top">
                                    <span class="telemetry-label">Sunlight / Lux</span>
                                    <div class="telemetry-icon">
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
                                </div>
                                <strong id="lightStatus">${dashboard.lightStatus}</strong>
                            </div>

                            <%-- ROOF --%>
                            <div class="telemetry-card">
                                <div class="telemetry-top">
                                    <span class="telemetry-label">Roof Mechanism</span>
                                    <div class="telemetry-icon">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                                        <line x1="3" y1="9" x2="21" y2="9"></line>
                                        </svg>
                                    </div>
                                </div>
                                <strong id="roofStatus">${dashboard.roofStatus}</strong>
                            </div>

                            <%-- MODE --%>
                            <div class="telemetry-card">
                                <div class="telemetry-top">
                                    <span class="telemetry-label">Operating Mode</span>
                                    <div class="telemetry-icon">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <circle cx="12" cy="12" r="3"></circle>
                                        <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
                                        </svg>
                                    </div>
                                </div>
                                <strong  id="mode">${dashboard.mode}</strong>
                            </div>

                            <%-- WARNING --%>
                            <div id="warningCard"
                                 class="telemetry-card ${dashboard.warning ne 'NORMAL' && not empty dashboard.warning ? 'card-warning-alert' : ''}">
                                <div class="telemetry-top">
                                    <span class="telemetry-label">Warning Level</span>
                                    <div class="telemetry-icon">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path>
                                        <line x1="12" y1="9" x2="12" y2="13"></line>
                                        <line x1="12" y1="17" x2="12.01" y2="17"></line>
                                        </svg>
                                    </div>
                                </div>
                                <strong  id="warning">${dashboard.warning}</strong>
                            </div>
                        </div>
                    </section>

                    <%-- ================================================= --%>
                    <%-- SECTION 2: ACTIVE DRYING BATCHES                  --%>
                    <%-- ================================================= --%>
                    <section class="dashboard-section">
                        <div class="section-header">
                            <div class="section-title-wrap">
                                <div class="section-icon-box icon-batches">
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
                                <div>
                                    <h2>Active Drying Batches</h2>
                                    <p>${activeBatchCount} active batch(es) currently drying at this warehouse</p>
                                </div>
                            </div>
                        </div>

                        <%-- DESKTOP TABLE --%>
                        <div class="table-responsive-wrapper desktop-table">
                            <table class="smart-table">
                                <thead>
                                    <tr>
                                        <th>Batch ID</th>
                                        <th>Product Name</th>
                                        <th>Operator</th>
                                        <th>Weight</th>
                                        <th>Start Time</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty activeBatches}">
                                            <c:forEach var="batch" items="${activeBatches}">
                                                <tr>
                                                    <td>
                                                        <span class="id-badge">#${batch.batchId}</span>
                                                    </td>
                                                    <td>
                                                        <div class="product-item">
                                                            <span class="product-icon">🌾</span>
                                                            <span>${batch.productName}</span>
                                                        </div>
                                                    </td>
                                                    <td>${batch.operatorName}</td>
                                                    <td>
                                                        <strong><fmt:formatNumber value="${batch.weightKg}" maxFractionDigits="2"/></strong> kg
                                                    </td>
                                                    <td class="time-stamp">
                                                        <fmt:formatDate value="${batch.startTime}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </td>
                                                    <td>
                                                        <span class="status-badge status-drying">
                                                            <span class="status-dot-amber"></span>
                                                            DRYING
                                                        </span>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="6" class="empty-state-cell">
                                                    <div class="empty-state-box">
                                                        <div class="empty-icon">☀️</div>
                                                        <h4>No Active Drying Batches</h4>
                                                        <p>All agricultural produce has completed drying or no batch has started.</p>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>

                        <%-- MOBILE CARDS VIEW --%>
                        <div class="mobile-card-list">
                            <c:choose>
                                <c:when test="${not empty activeBatches}">
                                    <c:forEach var="batch" items="${activeBatches}">
                                        <div class="mobile-batch-tile">
                                            <div class="mobile-batch-head">
                                                <span class="id-badge">#${batch.batchId}</span>
                                                <span class="status-badge status-drying">
                                                    <span class="status-dot-amber"></span> DRYING
                                                </span>
                                            </div>
                                            <div class="product-item">
                                                <span class="product-icon">🌾</span>
                                                <span>${batch.productName}</span>
                                            </div>
                                            <div class="mobile-grid-meta">
                                                <div class="mobile-meta-item">
                                                    <span class="m-label">Weight</span>
                                                    <strong class="m-val"><fmt:formatNumber value="${batch.weightKg}" maxFractionDigits="2"/> kg</strong>
                                                </div>
                                                <div class="mobile-meta-item">
                                                    <span class="m-label">Operator</span>
                                                    <span class="m-val">${batch.operatorName}</span>
                                                </div>
                                                <div class="mobile-meta-item full-span">
                                                    <span class="m-label">Start Time</span>
                                                    <span class="time-stamp"><fmt:formatDate value="${batch.startTime}" pattern="dd/MM/yyyy HH:mm"/></span>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state-box">
                                        <div class="empty-icon">☀️</div>
                                        <h4>No Active Batches</h4>
                                        <p>No batches are currently drying at this warehouse.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </section>

                    <%-- ================================================= --%>
                    <%-- SECTION 3: CONTROL PANEL                          --%>
                    <%-- ================================================= --%>
                    <section class="dashboard-section">
                        <div class="section-header">
                            <div class="section-title-wrap">
                                <div class="section-icon-box icon-controls">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="12" cy="12" r="3"></circle>
                                    <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
                                    </svg>
                                </div>
                                <div>
                                    <h2>Control Panel</h2>
                                    <p>Manual override and automated facility roof management</p>
                                </div>
                            </div>
                        </div>

                        <c:choose>
                            <c:when test="${device ne null}">
                                <div class="control-grid">
                                    <%-- OPERATING MODE GROUP --%>
                                    <div class="control-card">
                                        <div class="control-header-bar">
                                            <div class="control-icon">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <polyline points="23 4 23 10 17 10"></polyline>
                                                <polyline points="1 20 1 14 7 14"></polyline>
                                                <path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"></path>
                                                </svg>
                                            </div>
                                            <div>
                                                <h3>Operating Mode</h3>
                                                <span class="control-desc">Current: <strong id="controlMode">${dashboard.mode}</strong></span>
                                            </div>
                                        </div>
                                        <form action="${pageContext.request.contextPath}/control"
                                              method="post"
                                              class="control-button-cluster">

                                            <input type="hidden"
                                                   name="deviceId"
                                                   value="${device.deviceId}">

                                            <input type="hidden"
                                                   name="warehouseId"
                                                   value="${warehouse.warehouseId}">

                                            <button id="autoModeBtn"
                                                    type="submit"
                                                    name="action"
                                                    value="AUTO"
                                                    class="btn-ctrl btn-mode-auto ${dashboard.mode == 'AUTO' ? 'active-mode' : ''}">

                                                <svg viewBox="0 0 24 24"
                                                     fill="none"
                                                     stroke="currentColor"
                                                     stroke-width="2">

                                                <polyline points="20 6 9 17 4 12"></polyline>
                                                </svg>

                                                Switch to AUTO
                                            </button>

                                            <button id="manualModeBtn"
                                                    type="submit"
                                                    name="action"
                                                    value="MANUAL"
                                                    class="btn-ctrl btn-mode-manual ${dashboard.mode == 'MANUAL' ? 'active-mode' : ''}">

                                                <svg viewBox="0 0 24 24"
                                                     fill="none"
                                                     stroke="currentColor"
                                                     stroke-width="2">

                                                <circle cx="12" cy="12" r="10"></circle>

                                                <polyline points="12 6 12 12 14 14"></polyline>
                                                </svg>

                                                Switch to MANUAL
                                            </button>

                                        </form>
                                    </div>

                                    <%-- ROOF CONTROL GROUP --%>
                                    <div class="control-card">
                                        <div class="control-header-bar">
                                            <div class="control-icon">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                                                </svg>
                                            </div>
                                            <div>
                                                <h3>Roof Actuation</h3>
                                                <span class="control-desc">Status: <strong id="controlRoofStatus">${dashboard.roofStatus}</strong></span>
                                            </div>
                                        </div>

                                        <form action="${pageContext.request.contextPath}/control"
                                              method="post"
                                              class="control-button-cluster">

                                            <input type="hidden"
                                                   name="deviceId"
                                                   value="${device.deviceId}">

                                            <input type="hidden"
                                                   name="warehouseId"
                                                   value="${warehouse.warehouseId}">

                                            <button id="openRoofBtn"
                                                    type="submit"
                                                    name="action"
                                                    value="OPEN"
                                                    class="btn-ctrl btn-roof-open"
                                                    ${dashboard.mode != 'MANUAL' ? 'disabled' : ''}>

                                                <svg viewBox="0 0 24 24"
                                                     fill="none"
                                                     stroke="currentColor"
                                                     stroke-width="2">

                                                <path d="M18 15l-6-6-6 6"/>
                                                </svg>

                                                OPEN ROOF
                                            </button>

                                            <button id="closeRoofBtn"
                                                    type="submit"
                                                    name="action"
                                                    value="CLOSE"
                                                    class="btn-ctrl btn-roof-close"
                                                    ${dashboard.mode != 'MANUAL' ? 'disabled' : ''}>

                                                <svg viewBox="0 0 24 24"
                                                     fill="none"
                                                     stroke="currentColor"
                                                     stroke-width="2">

                                                <path d="M6 9l6 6 6-6"/>
                                                </svg>

                                                CLOSE ROOF
                                            </button>

                                        </form>
                                        <div id="manualModeNotice"
                                             class="control-notice-box"
                                             style="${dashboard.mode == 'MANUAL' ? 'display:none;' : ''}">

                                            <svg viewBox="0 0 24 24"
                                                 fill="none"
                                                 stroke="currentColor"
                                                 stroke-width="2">

                                            <circle cx="12" cy="12" r="10"></circle>
                                            <line x1="12" y1="8" x2="12" y2="12"></line>
                                            <line x1="12" y1="16" x2="12.01" y2="16"></line>
                                            </svg>

                                            <span>
                                                Switch to
                                                <strong>MANUAL mode</strong>
                                                to actuate the drying roof manually.
                                            </span>

                                        </div>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-device-alert">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="22" height="22">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <line x1="12" y1="8" x2="12" y2="12"></line>
                                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                                    </svg>
                                    <span>No IoT device controller is currently assigned to this warehouse.</span>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </section>

                    <%-- ================================================= --%>
                    <%-- SECTION 4: RECENT SENSOR READINGS                 --%>
                    <%-- ================================================= --%>
                    <section class="dashboard-section">
                        <div class="section-header">
                            <div class="section-title-wrap">
                                <div class="section-icon-box icon-readings">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline>
                                    </svg>
                                </div>
                                <div>
                                    <h2>Recent Sensor Readings</h2>
                                    <p>Sequential telemetry logs recorded from facility monitoring hardware</p>
                                </div>
                            </div>
                        </div>

                        <div class="table-responsive-wrapper">
                            <table class="smart-table">
                                <thead>
                                    <tr>
                                        <th>Recorded Time</th>
                                        <th>Temperature</th>
                                        <th>Humidity</th>
                                        <th>Rain Status</th>
                                        <th>Light Level</th>
                                        <th>Roof Status</th>
                                    </tr>
                                </thead>
                                <tbody id="recentSensorBody">
                                    <c:choose>
                                        <c:when test="${not empty recentSensors}">
                                            <c:forEach var="sensor" items="${recentSensors}">
                                                <tr>
                                                    <td class="time-stamp">
                                                        <fmt:formatDate value="${sensor.recordedAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                                    </td>
                                                    <td>
                                                        <strong><fmt:formatNumber value="${sensor.temperature}" maxFractionDigits="1"/></strong> °C
                                                    </td>
                                                    <td>
                                                        <strong><fmt:formatNumber value="${sensor.humidity}" maxFractionDigits="1"/></strong> %
                                                    </td>
                                                    <td>${sensor.rainStatus}</td>
                                                    <td>${sensor.lightStatus}</td>
                                                    <td>${sensor.roofStatus}</td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="6" class="empty-state-cell">
                                                    <div class="empty-state-box">
                                                        <div class="empty-icon">📊</div>
                                                        <h4>No Sensor Data Available</h4>
                                                        <p>No telemetry records found for this warehouse in the selected timeframe.</p>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </section>

                    <%-- ================================================= --%>
                    <%-- FOOTER STATUS STRIP                               --%>
                    <%-- ================================================= --%>
                    <footer class="dashboard-footer">
                        <div class="footer-system-status">
                            <span class="pulse-dot"></span>
                            <span>Smart Agricultural Drying Telemetry & Supervisory System</span>
                        </div>
                        <div class="footer-version">
                            Environment: Production · Manager Station v2.4.0
                        </div>
                    </footer>

                </div>
            </main>
        </div>
        <script>
            // =====================================
            // Load live manager dashboard data
            // =====================================

            function loadManagerDashboardData() {

                var warehouseSelect
                        = document.getElementById(
                                "warehouseSelect"
                                );

                if (!warehouseSelect) {
                    return;
                }

                var warehouseId
                        = warehouseSelect.value;

                if (!warehouseId) {
                    return;
                }

                fetch(
                        "${pageContext.request.contextPath}/api/dashboard-data"
                        + "?warehouseId="
                        + encodeURIComponent(
                                warehouseId
                                )
                        )
                        .then(function (response) {

                            if (!response.ok) {

                                throw new Error(
                                        "HTTP error: "
                                        + response.status
                                        );
                            }

                            return response.json();
                        })
                        .then(function (data) {

                            // =====================================
                            // Connection status
                            // =====================================

                            var connectionStatus
                                    = document.getElementById(
                                            "connectionStatus"
                                            );

                            var espCard
                                    = document.getElementById(
                                            "espCard"
                                            );

                            if (connectionStatus) {

                                connectionStatus.textContent
                                        = data.connectionStatus;
                            }

                            if (espCard) {

                                espCard.classList.remove(
                                        "is-online"
                                        );

                                if (data.connectionStatus === "ONLINE") {

                                    espCard.classList.add(
                                            "is-online"
                                            );
                                }
                            }


                            // =====================================
                            // Temperature
                            // =====================================

                            var temperature
                                    = document.getElementById(
                                            "temperature"
                                            );

                            if (temperature) {

                                temperature.textContent
                                        = data.temperature === null
                                        ? "N/A"
                                        : Number(
                                                data.temperature
                                                ).toFixed(1)
                                        + " °C";
                            }


                            // =====================================
                            // Humidity
                            // =====================================

                            var humidity
                                    = document.getElementById(
                                            "humidity"
                                            );

                            if (humidity) {

                                humidity.textContent
                                        = data.humidity === null
                                        ? "N/A"
                                        : Number(
                                                data.humidity
                                                ).toFixed(1)
                                        + " %";
                            }


                            // =====================================
                            // Rain status
                            // =====================================

                            var rainStatus
                                    = document.getElementById(
                                            "rainStatus"
                                            );

                            if (rainStatus) {

                                rainStatus.textContent
                                        = data.rainStatus;
                            }


                            // =====================================
                            // Light status
                            // =====================================

                            var lightStatus
                                    = document.getElementById(
                                            "lightStatus"
                                            );

                            if (lightStatus) {

                                lightStatus.textContent
                                        = data.lightStatus;
                            }


                            // =====================================
                            // Roof status
                            // =====================================

                            var roofStatus
                                    = document.getElementById(
                                            "roofStatus"
                                            );

                            var controlRoofStatus
                                    = document.getElementById(
                                            "controlRoofStatus"
                                            );

                            if (roofStatus) {

                                roofStatus.textContent
                                        = data.roofStatus;
                            }

                            if (controlRoofStatus) {

                                controlRoofStatus.textContent
                                        = data.roofStatus;
                            }


                            // =====================================
                            // Operating mode
                            // =====================================

                            var mode
                                    = document.getElementById(
                                            "mode"
                                            );

                            var controlMode
                                    = document.getElementById(
                                            "controlMode"
                                            );

                            if (mode) {

                                mode.textContent
                                        = data.mode;
                            }

                            if (controlMode) {

                                controlMode.textContent
                                        = data.mode;
                            }


                            // =====================================
                            // Warning
                            // =====================================

                            var warning
                                    = document.getElementById(
                                            "warning"
                                            );

                            var warningCard
                                    = document.getElementById(
                                            "warningCard"
                                            );

                            if (warning) {

                                warning.textContent
                                        = data.warning;
                            }

                            if (warningCard) {

                                warningCard.classList.remove(
                                        "card-warning-alert"
                                        );

                                if (data.warning !== "NORMAL") {

                                    warningCard.classList.add(
                                            "card-warning-alert"
                                            );
                                }
                            }


                            // =====================================
                            // Control buttons
                            // =====================================

                            var autoModeBtn
                                    = document.getElementById(
                                            "autoModeBtn"
                                            );

                            var manualModeBtn
                                    = document.getElementById(
                                            "manualModeBtn"
                                            );

                            var openRoofBtn
                                    = document.getElementById(
                                            "openRoofBtn"
                                            );

                            var closeRoofBtn
                                    = document.getElementById(
                                            "closeRoofBtn"
                                            );

                            var manualModeNotice
                                    = document.getElementById(
                                            "manualModeNotice"
                                            );


                            // =====================================
                            // Update active mode button
                            // =====================================

                            if (autoModeBtn) {

                                autoModeBtn.classList.remove(
                                        "active-mode"
                                        );
                            }

                            if (manualModeBtn) {

                                manualModeBtn.classList.remove(
                                        "active-mode"
                                        );
                            }


                            if (data.mode === "AUTO") {

                                if (autoModeBtn) {

                                    autoModeBtn.classList.add(
                                            "active-mode"
                                            );
                                }

                                if (openRoofBtn) {

                                    openRoofBtn.disabled
                                            = true;
                                }

                                if (closeRoofBtn) {

                                    closeRoofBtn.disabled
                                            = true;
                                }

                                if (manualModeNotice) {

                                    manualModeNotice.style.display
                                            = "";
                                }

                            } else if (data.mode === "MANUAL") {

                                if (manualModeBtn) {

                                    manualModeBtn.classList.add(
                                            "active-mode"
                                            );
                                }

                                if (openRoofBtn) {

                                    openRoofBtn.disabled
                                            = false;
                                }

                                if (closeRoofBtn) {

                                    closeRoofBtn.disabled
                                            = false;
                                }

                                if (manualModeNotice) {

                                    manualModeNotice.style.display
                                            = "none";
                                }
                            }
                            // =====================================
// Update recent sensor readings
// =====================================

                            var recentSensorBody =
                                    document.getElementById(
                                            "recentSensorBody"
                                            );

                            if (recentSensorBody) {

                                var sensors =
                                        data.recentSensors;

                                if (
                                        sensors
                                        && sensors.length > 0
                                        ) {

                                    var rows = "";

                                    sensors.forEach(
                                            function (sensor) {

                                                rows +=
                                                        "<tr>"
                                                        + "<td class='time-stamp'>"
                                                        + sensor.recordedAt
                                                        + "</td>"

                                                        + "<td>"
                                                        + "<strong>"
                                                        + Number(
                                                                sensor.temperature
                                                                ).toFixed(1)
                                                        + "</strong> °C"
                                                        + "</td>"

                                                        + "<td>"
                                                        + "<strong>"
                                                        + Number(
                                                                sensor.humidity
                                                                ).toFixed(1)
                                                        + "</strong> %"
                                                        + "</td>"

                                                        + "<td>"
                                                        + sensor.rainStatus
                                                        + "</td>"

                                                        + "<td>"
                                                        + sensor.lightStatus
                                                        + "</td>"

                                                        + "<td>"
                                                        + sensor.roofStatus
                                                        + "</td>"

                                                        + "</tr>";
                                            }
                                    );

                                    recentSensorBody.innerHTML =
                                            rows;

                                } else {

                                    recentSensorBody.innerHTML =
                                            "<tr>"
                                            + "<td colspan='6' class='empty-state-cell'>"
                                            + "<div class='empty-state-box'>"
                                            + "<div class='empty-icon'>📊</div>"
                                            + "<h4>No Sensor Data Available</h4>"
                                            + "<p>No telemetry records found for this warehouse.</p>"
                                            + "</div>"
                                            + "</td>"
                                            + "</tr>";
                                }
                            }
                        })
                        .catch(function (error) {

                            console.error(
                                    "Failed to refresh manager dashboard:",
                                    error
                                    );
                        });
            }


            // =====================================
            // Load immediately
            // =====================================

            loadManagerDashboardData();


            // =====================================
            // Refresh every 2 seconds
            // =====================================

            setInterval(
                    loadManagerDashboardData,
                    2000
                    );
        </script>
    </body>
</html>
