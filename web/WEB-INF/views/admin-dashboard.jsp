<%-- 
    Document   : admin-dashboard.jsp (Redesigned for Smart Agricultural Drying System)
    Description: Modern, responsive Admin Dashboard for Laptop & Mobile viewports,
                 fully preserving 100% of JSTL EL expressions, variables, and include paths.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <title>Admin Dashboard - Smart Agricultural Drying System</title>
        <!-- Modern Typography -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600&display=swap" rel="stylesheet">
        <!-- Common & Page Stylesheets -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-dashboard.css">
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
                    <%-- ADMIN HEADER & QUICK STATUS BANNER                --%>
                    <%-- ================================================= --%>
                    <header class="admin-header-card">
                        <div class="header-meta">
                            <div class="header-badge-row">
                                <span class="role-pill">Administrator</span>
                                <span class="system-pill">
                                    <span class="pulse-dot"></span>
                                    System Live
                                </span>
                            </div>
                            <h1>Admin Dashboard</h1>
                            <p class="header-subtitle">
                                Overview of users, warehouses, devices and drying operations.
                            </p>
                        </div>
                        <div class="header-quick-stats">
                            <div class="quick-stat-badge">
                                <div class="quick-stat-icon">
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
                                <div class="quick-stat-info">
                                    <span class="quick-stat-label">Active Batches</span>
                                    <span class="quick-stat-val">${activeBatches}</span>
                                </div>
                            </div>
                        </div>
                    </header>

                    <%-- ================================================= --%>
                    <%-- SECTION 1: USERS METRICS                          --%>
                    <%-- ================================================= --%>
                    <section class="dashboard-section">
                        <div class="section-title">
                            <div class="section-heading-wrap">
                                <div class="section-icon-box section-icon-users">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="9" cy="7" r="4"></circle>
                                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                    <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                    </svg>
                                </div>
                                <div>
                                    <h2>Users</h2>
                                    <p class="section-sub">Personnel and system access accounts</p>
                                </div>
                            </div>
                            <a href="${pageContext.request.contextPath}/users" class="section-action-btn">
                                <span>View User Management</span>
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                <line x1="5" y1="12" x2="19" y2="12"></line>
                                <polyline points="12 5 19 12 12 19"></polyline>
                                </svg>
                            </a>
                        </div>

                        <div class="stat-grid">
                            <%-- TOTAL USERS --%>
                            <div class="stat-card">
                                <div class="stat-content">
                                    <span class="stat-label">Total Users</span>
                                    <strong class="stat-number">${totalUsers}</strong>
                                    <span class="stat-pill-sub">Registered accounts</span>
                                </div>
                                <div class="stat-icon-watermark">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="12" cy="7" r="4"></circle>
                                    </svg>
                                </div>
                            </div>

                            <%-- ACTIVE USERS --%>
                            <div class="stat-card stat-success">
                                <div class="stat-content">
                                    <span class="stat-label">Active Users</span>
                                    <strong class="stat-number">${activeUsers}</strong>
                                    <span class="stat-pill-sub">Allowed login & operation</span>
                                </div>
                                <div class="stat-icon-watermark">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                    <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                    </svg>
                                </div>
                            </div>

                            <%-- INACTIVE USERS --%>
                            <div class="stat-card stat-danger">
                                <div class="stat-content">
                                    <span class="stat-label">Inactive Users</span>
                                    <strong class="stat-number">${inactiveUsers}</strong>
                                    <span class="stat-pill-sub">Disabled or locked</span>
                                </div>
                                <div class="stat-icon-watermark">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <line x1="15" y1="9" x2="9" y2="15"></line>
                                    <line x1="9" y1="9" x2="15" y2="15"></line>
                                    </svg>
                                </div>
                            </div>
                        </div>
                    </section>

                    <%-- ================================================= --%>
                    <%-- SECTION 2: WAREHOUSES METRICS                     --%>
                    <%-- ================================================= --%>
                    <section class="dashboard-section">
                        <div class="section-title">
                            <div class="section-heading-wrap">
                                <div class="section-icon-box section-icon-warehouses">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                                    <polyline points="9 22 9 12 15 12 15 22"></polyline>
                                    </svg>
                                </div>
                                <div>
                                    <h2>Warehouses</h2>
                                    <p class="section-sub">Drying storage and regional facilities</p>
                                </div>
                            </div>
                            <a href="${pageContext.request.contextPath}/warehouses" class="section-action-btn">
                                <span>View Warehouse Management</span>
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                <line x1="5" y1="12" x2="19" y2="12"></line>
                                <polyline points="12 5 19 12 12 19"></polyline>
                                </svg>
                            </a>
                        </div>

                        <div class="stat-grid">
                            <%-- TOTAL WAREHOUSES --%>
                            <div class="stat-card">
                                <div class="stat-content">
                                    <span class="stat-label">Total Warehouses</span>
                                    <strong class="stat-number">${totalWarehouses}</strong>
                                    <span class="stat-pill-sub">Configured locations</span>
                                </div>
                                <div class="stat-icon-watermark">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <rect x="2" y="7" width="20" height="14" rx="2" ry="2"></rect>
                                    <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"></path>
                                    </svg>
                                </div>
                            </div>

                            <%-- ACTIVE WAREHOUSES --%>
                            <div class="stat-card stat-success">
                                <div class="stat-content">
                                    <span class="stat-label">Active Warehouses</span>
                                    <strong class="stat-number">${activeWarehouses}</strong>
                                    <span class="stat-pill-sub">Operational & receiving</span>
                                </div>
                                <div class="stat-icon-watermark">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                    <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                    </svg>
                                </div>
                            </div>

                            <%-- INACTIVE WAREHOUSES --%>
                            <div class="stat-card stat-danger">
                                <div class="stat-content">
                                    <span class="stat-label">Inactive Warehouses</span>
                                    <strong class="stat-number">${inactiveWarehouses}</strong>
                                    <span class="stat-pill-sub">Paused or maintenance</span>
                                </div>
                                <div class="stat-icon-watermark">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <line x1="15" y1="9" x2="9" y2="15"></line>
                                    <line x1="9" y1="9" x2="15" y2="15"></line>
                                    </svg>
                                </div>
                            </div>
                        </div>
                    </section>

                    <%-- ================================================= --%>
                    <%-- SECTION 3: DEVICES METRICS                        --%>
                    <%-- ================================================= --%>
                    <section class="dashboard-section">
                        <div class="section-title">
                            <div class="section-heading-wrap">
                                <div class="section-icon-box section-icon-devices">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="12" cy="12" r="3"></circle>
                                    <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
                                    </svg>
                                </div>
                                <div>
                                    <h2>Devices</h2>
                                    <p class="section-sub">IoT sensors, actuators & telemetry gateways</p>
                                </div>
                            </div>
                            <a href="${pageContext.request.contextPath}/devices" class="section-action-btn">
                                <span>View Device Management</span>
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                <line x1="5" y1="12" x2="19" y2="12"></line>
                                <polyline points="12 5 19 12 12 19"></polyline>
                                </svg>
                            </a>
                        </div>

                        <div class="stat-grid">
                            <%-- TOTAL DEVICES --%>
                            <div class="stat-card">
                                <div class="stat-content">
                                    <span class="stat-label">Total Devices</span>
                                    <strong class="stat-number">${totalDevices}</strong>
                                    <span class="stat-pill-sub">Installed IoT hardware</span>
                                </div>
                                <div class="stat-icon-watermark">
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
                            </div>

                            <%-- ONLINE DEVICES --%>
                            <div class="stat-card stat-success">
                                <div class="stat-content">
                                    <span class="stat-label">Online Devices</span>
                                    <strong class="stat-number">${onlineDevices}</strong>
                                    <span class="stat-pill-sub">Transmitting live data</span>
                                </div>
                                <div class="stat-icon-watermark">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M5 12.55a11 11 0 0 1 14.08 0"></path>
                                    <path d="M1.42 9a16 16 0 0 1 21.16 0"></path>
                                    <path d="M8.53 16.11a6 6 0 0 1 6.95 0"></path>
                                    <line x1="12" y1="20" x2="12.01" y2="20"></line>
                                    </svg>
                                </div>
                            </div>

                            <%-- OFFLINE DEVICES --%>
                            <div class="stat-card stat-danger">
                                <div class="stat-content">
                                    <span class="stat-label">Offline Devices</span>
                                    <strong class="stat-number">${offlineDevices}</strong>
                                    <span class="stat-pill-sub">Signal lost or disconnected</span>
                                </div>
                                <div class="stat-icon-watermark">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <line x1="1" y1="1" x2="23" y2="23"></line>
                                    <path d="M16.72 11.06A10.94 10.94 0 0 1 19.08 12.55"></path>
                                    <path d="M5 12.55a10.94 10.94 0 0 1 5.17-2.39"></path>
                                    <path d="M10.71 5.05A16 16 0 0 1 22.58 9"></path>
                                    <path d="M1.42 9a15.91 15.91 0 0 1 4.7-2.88"></path>
                                    <path d="M8.53 16.11a6 6 0 0 1 6.95 0"></path>
                                    <line x1="12" y1="20" x2="12.01" y2="20"></line>
                                    </svg>
                                </div>
                            </div>
                        </div>
                    </section>

                    <%-- ================================================= --%>
                    <%-- SECTION 4: DRYING OPERATIONS                      --%>
                    <%-- ================================================= --%>
                    <section class="dashboard-section">
                        <div class="section-title">
                            <div class="section-heading-wrap">
                                <div class="section-icon-box section-icon-operations">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <path d="M12 2a4 4 0 0 1 4 4c0 3-4 6-4 6s-4-3-4-6a4 4 0 0 1 4-4z"></path>
                                    <path d="M22 12a4 4 0 0 1-4 4c-3 0-6-4-6-4s3-4 6-4a4 4 0 0 1 4 4z"></path>
                                    </svg>
                                </div>
                                <div>
                                    <h2>Drying Operations</h2>
                                    <p class="section-sub">Live monitoring of active agricultural batches</p>
                                </div>
                            </div>

                        </div>

                        <div class="stat-grid single-stat">
                            <div class="stat-card hero-operation-card">
                                <div class="hero-op-inner">
                                    <div class="hero-op-left">
                                        <div class="hero-op-icon">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
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
                                        <div class="hero-op-details">
                                            <h3>Active Drying Batches in Progress</h3>
                                            <p>Batches currently in drying and moisture extraction cycles across all warehouses.</p>
                                        </div>
                                    </div>
                                    <div class="hero-op-right">
                                        <strong>${activeBatches}</strong>
                                        <span>Batches Running</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>

                    <%-- ================================================= --%>
                    <%-- FOOTER STATUS STRIP                               --%>
                    <%-- ================================================= --%>
                    <footer class="dashboard-footer">
                        <div class="footer-system-status">
                            <span class="pulse-dot"></span>
                            <span>Smart Agricultural Drying IoT Telemetry Engine</span>
                        </div>

                    </footer>

                </div>
            </main>
        </div>
    </body>
</html>
