<%-- 
    Document   : operator-dashboard.jsp (Redesigned for Smart Agricultural Drying System)
    Description: Modern, responsive Operator Dashboard for Laptop & Mobile viewports,
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
    <title>Operator Dashboard - Smart Agricultural Drying System</title>
    <!-- Modern Typography -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600&display=swap" rel="stylesheet">
    <!-- Common & Page Stylesheets -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/operator-dashboard.css">
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
            <%-- HEADER & WAREHOUSE CONTEXT CARD                   --%>
            <%-- ================================================= --%>
            <header class="operator-header-card">
                <div class="header-meta">
                    <div class="header-badge-row">
                        <span class="role-pill">Field Operator</span>
                        <span class="live-pill">
                            <span class="pulse-dot"></span>
                            Telemetry Live
                        </span>
                    </div>
                    <h1>Operator Dashboard</h1>
                    <p class="header-subtitle">
                        Welcome, <strong>${sessionScope.LOGIN_USER.fullName}</strong>. Live monitoring and field actuation for drying batches.
                    </p>
                </div>

                <%-- ASSIGNED CONTEXT PILLS --%>
                <div class="header-context-cluster">
                    <div class="context-pill-card">
                        <div class="context-pill-icon icon-wh">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                                <polyline points="9 22 9 12 15 12 15 22"></polyline>
                            </svg>
                        </div>
                        <div class="context-pill-meta">
                            <span class="context-tag">Assigned Warehouse</span>
                            <strong class="context-title" title="${warehouse.warehouseCode} - ${warehouse.warehouseName}">
                                ${warehouse.warehouseCode} - ${warehouse.warehouseName}
                            </strong>
                        </div>
                    </div>

                    <div class="context-pill-card">
                        <div class="context-pill-icon icon-dev">
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
                        <div class="context-pill-meta">
                            <span class="context-tag">IoT Controller</span>
                            <strong class="context-title">
                                <c:choose>
                                    <c:when test="${device != null}">
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
                            <p>Real-time sensor feeds transmitted from drying chamber hardware</p>
                        </div>
                    </div>
                </div>

                <div class="telemetry-grid">
                    <%-- ESP STATUS --%>
                    <article class="telemetry-card ${dashboard.connectionStatus == 'ONLINE' ? 'card-esp-online' : 'card-esp-offline'}">
                        <div class="telemetry-top">
                            <span class="telemetry-label">ESP Controller</span>
                            <div class="telemetry-icon">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M5 12.55a11 11 0 0 1 14.08 0"></path>
                                    <line x1="12" y1="20" x2="12.01" y2="20"></line>
                                </svg>
                            </div>
                        </div>
                        <c:choose>
                            <c:when test="${dashboard.connectionStatus == 'ONLINE'}">
                                <strong class="telemetry-value text-online">
                                    <span class="status-dot-green"></span> ONLINE
                                </strong>
                            </c:when>
                            <c:otherwise>
                                <strong class="telemetry-value text-offline">
                                    <span class="status-dot-red"></span> OFFLINE
                                </strong>
                            </c:otherwise>
                        </c:choose>
                    </article>

                    <%-- TEMPERATURE --%>
                    <article class="telemetry-card">
                        <div class="telemetry-top">
                            <span class="telemetry-label">Temperature</span>
                            <div class="telemetry-icon">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M14 14.76V3.5a2.5 2.5 0 0 0-5 0v11.26a4.5 4.5 0 1 0 5 0z"></path>
                                </svg>
                            </div>
                        </div>
                        <strong class="telemetry-value">
                            <fmt:formatNumber value="${dashboard.temperature}" maxFractionDigits="1"/> °C
                        </strong>
                    </article>

                    <%-- HUMIDITY --%>
                    <article class="telemetry-card">
                        <div class="telemetry-top">
                            <span class="telemetry-label">Humidity</span>
                            <div class="telemetry-icon">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M12 2.69l5.66 5.66a8 8 0 1 1-11.31 0z"></path>
                                </svg>
                            </div>
                        </div>
                        <strong class="telemetry-value">
                            <fmt:formatNumber value="${dashboard.humidity}" maxFractionDigits="1"/> %
                        </strong>
                    </article>

                    <%-- RAIN SENSOR --%>
                    <article class="telemetry-card">
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
                        <strong class="telemetry-value">${dashboard.rainStatus}</strong>
                    </article>

                    <%-- LIGHT / SUNLIGHT --%>
                    <article class="telemetry-card">
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
                        <strong class="telemetry-value">${dashboard.lightStatus}</strong>
                    </article>

                    <%-- ROOF STATUS --%>
                    <article class="telemetry-card">
                        <div class="telemetry-top">
                            <span class="telemetry-label">Roof Mechanism</span>
                            <div class="telemetry-icon">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                                    <line x1="3" y1="9" x2="21" y2="9"></line>
                                </svg>
                            </div>
                        </div>
                        <strong class="telemetry-value">${dashboard.roofStatus}</strong>
                    </article>

                    <%-- MODE --%>
                    <article class="telemetry-card">
                        <div class="telemetry-top">
                            <span class="telemetry-label">Operating Mode</span>
                            <div class="telemetry-icon">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="12" cy="12" r="3"></circle>
                                    <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
                                </svg>
                            </div>
                        </div>
                        <strong class="telemetry-value">${dashboard.mode}</strong>
                    </article>

                    <%-- WARNING --%>
                    <article class="telemetry-card ${dashboard.warning != 'NORMAL' && not empty dashboard.warning ? 'card-warning-alert' : ''}">
                        <div class="telemetry-top">
                            <span class="telemetry-label">Warning Status</span>
                            <div class="telemetry-icon">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path>
                                    <line x1="12" y1="9" x2="12" y2="13"></line>
                                    <line x1="12" y1="17" x2="12.01" y2="17"></line>
                                </svg>
                            </div>
                        </div>
                        <strong class="telemetry-value">${dashboard.warning}</strong>
                    </article>
                </div>
            </section>

            <%-- ================================================= --%>
            <%-- SECTION 2: ACTIVE DRYING BATCH                    --%>
            <%-- ================================================= --%>
            <section class="dashboard-section">
                <div class="section-header">
                    <div class="section-title-wrap">
                        <div class="section-icon-box icon-batch">
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
                            <h2>Active Drying Batch</h2>
                            <p>Currently drying agricultural produce undergoing moisture extraction</p>
                        </div>
                    </div>
                    <a class="section-link-btn" href="${pageContext.request.contextPath}/batch">
                        <span>View All Batches</span>
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                            <polyline points="12 5 19 12 12 19"></polyline>
                        </svg>
                    </a>
                </div>

                <div class="active-batch-container">
                    <c:choose>
                        <c:when test="${activeBatch != null}">
                            <div class="batch-feature-card">
                                <div class="batch-feature-top">
                                    <div class="batch-head-left">
                                        <span class="batch-id-tag">#${activeBatch.batchId}</span>
                                        <div class="product-badge">
                                            <span class="product-icon">🌾</span>
                                            <h3>${activeBatch.productName}</h3>
                                        </div>
                                    </div>
                                    <div class="batch-head-right">
                                        <span class="status-pill status-drying">
                                            <span class="status-dot-amber"></span>
                                            ${activeBatch.status}
                                        </span>
                                    </div>
                                </div>

                                <div class="batch-metrics-grid">
                                    <div class="metric-box">
                                        <span class="metric-label">Operator in Charge</span>
                                        <div class="metric-val-wrap">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                                <circle cx="12" cy="7" r="4"></circle>
                                            </svg>
                                            <strong class="metric-val">${activeBatch.operatorName}</strong>
                                        </div>
                                    </div>

                                    <div class="metric-box">
                                        <span class="metric-label">Weight Loaded</span>
                                        <div class="metric-val-wrap">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <circle cx="12" cy="12" r="10"></circle>
                                                <path d="M12 6v6l4 2"></path>
                                            </svg>
                                            <strong class="metric-val highlight-emerald">
                                                <fmt:formatNumber value="${activeBatch.weightKg}" maxFractionDigits="2"/> kg
                                            </strong>
                                        </div>
                                    </div>

                                    <div class="metric-box full-span-mobile">
                                        <span class="metric-label">Commenced At</span>
                                        <div class="metric-val-wrap">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                                <line x1="16" y1="2" x2="16" y2="6"></line>
                                                <line x1="8" y1="2" x2="8" y2="6"></line>
                                                <line x1="3" y1="10" x2="21" y2="10"></line>
                                            </svg>
                                            <strong class="metric-val time-code">
                                                <fmt:formatDate value="${activeBatch.startTime}" pattern="dd/MM/yyyy HH:mm"/>
                                            </strong>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="batch-empty-card">
                                <div class="empty-icon-wrap">☀️</div>
                                <h3>No Active Drying Batch</h3>
                                <p>No agricultural produce is currently undergoing drying in this facility.</p>
                                <a class="btn-start-batch" href="${pageContext.request.contextPath}/batch">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                        <line x1="12" y1="5" x2="12" y2="19"></line>
                                        <line x1="5" y1="12" x2="19" y2="12"></line>
                                    </svg>
                                    <span>Start New Batch</span>
                                </a>
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
                            <p>Manual override and automation mode settings for drying facility roof</p>
                        </div>
                    </div>
                </div>

                <form class="control-panel-grid" action="${pageContext.request.contextPath}/control" method="post">
                    <c:if test="${device != null}">
                        <input type="hidden" name="deviceId" value="${device.deviceId}">
                    </c:if>
                    <c:if test="${warehouse != null}">
                        <input type="hidden" name="warehouseId" value="${warehouse.warehouseId}">
                    </c:if>

                    <%-- OPERATING MODE GROUP --%>
                    <div class="control-card">
                        <div class="control-card-head">
                            <div class="control-head-icon">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <polyline points="23 4 23 10 17 10"></polyline>
                                    <polyline points="1 20 1 14 7 14"></polyline>
                                    <path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"></path>
                                </svg>
                            </div>
                            <div>
                                <h3>Operating Mode</h3>
                                <span class="control-sub">Current: <strong class="badge-mode-val">${dashboard.mode}</strong></span>
                            </div>
                        </div>

                        <div class="control-btn-row">
                            <button type="submit" name="action" value="AUTO" class="btn-ctrl btn-mode-auto ${dashboard.mode == 'AUTO' ? 'active-mode' : ''}">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                Switch to AUTO
                            </button>
                            <button type="submit" name="action" value="MANUAL" class="btn-ctrl btn-mode-manual ${dashboard.mode == 'MANUAL' ? 'active-mode' : ''}">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 14 14"></polyline></svg>
                                Switch to MANUAL
                            </button>
                        </div>
                    </div>

                    <%-- ROOF ACTUATION GROUP --%>
                    <div class="control-card">
                        <div class="control-card-head">
                            <div class="control-head-icon">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                                </svg>
                            </div>
                            <div>
                                <h3>Roof Mechanism</h3>
                                <span class="control-sub">Status: <strong class="badge-roof-val">${dashboard.roofStatus}</strong></span>
                            </div>
                        </div>

                        <div class="control-btn-row">
                            <c:choose>
                                <c:when test="${dashboard.mode == 'MANUAL'}">
                                    <button type="submit" name="action" value="OPEN" class="btn-ctrl btn-roof-open">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 15l-6-6-6 6"/></svg>
                                        OPEN ROOF
                                    </button>
                                    <button type="submit" name="action" value="CLOSE" class="btn-ctrl btn-roof-close">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 9l6 6 6-6"/></svg>
                                        CLOSE ROOF
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <button type="button" class="btn-ctrl btn-disabled" disabled>
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 15l-6-6-6 6"/></svg>
                                        OPEN ROOF
                                    </button>
                                    <button type="button" class="btn-ctrl btn-disabled" disabled>
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 9l6 6 6-6"/></svg>
                                        CLOSE ROOF
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <c:if test="${dashboard.mode == 'AUTO'}">
                            <div class="control-mode-notice">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <line x1="12" y1="8" x2="12" y2="12"></line>
                                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                                </svg>
                                <span>Manual roof actuation is disabled while operating in <strong>AUTO mode</strong>. Switch to MANUAL to override.</span>
                            </div>
                        </c:if>
                    </div>
                </form>
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
                            <p>Sequential telemetry logs captured by local environmental sensors</p>
                        </div>
                    </div>
                    <a class="section-link-btn" href="${pageContext.request.contextPath}/history">
                        <span>View History</span>
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                            <polyline points="12 5 19 12 12 19"></polyline>
                        </svg>
                    </a>
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
                        <tbody>
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
                                            <p>No telemetry logs recorded for this warehouse in the selected timeframe.</p>
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
                    <span>Smart Agricultural Drying Telemetry & Field Operator Station</span>
                </div>
                <div class="footer-version">
                    Environment: Production · Operator Console v2.4.0
                </div>
            </footer>

        </div>
    </main>
</div>
</body>
</html>
