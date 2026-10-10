<%-- Shared sidebar: include from JSP pages. Requires existing LOGIN_USER session. --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="currentURI" value="${pageContext.request.requestURI}" />

<%-- Load this CSS once in the parent page's <head> if already included there. --%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">

<button class="sidebar-toggle-btn" type="button" onclick="toggleSidebar()"
        aria-label="Open navigation" aria-controls="sidebar" aria-expanded="false">
    <span class="hamburger-bar"></span><span class="hamburger-bar"></span><span class="hamburger-bar"></span>
</button>
<div class="sidebar-backdrop" id="sidebarBackdrop" onclick="closeSidebar()"></div>

<aside class="smart-sidebar" id="sidebar" aria-label="Main navigation">
    <%-- The background is separate from all interactive elements. --%>
    <div class="sidebar-bg-layer" aria-hidden="true">
        <img class="sidebar-bg-img"
             src="${pageContext.request.contextPath}/images/sidebar-bg.png"
             alt="">
        <div class="sidebar-bg-gradient"></div>
        <div class="sidebar-bg-glow"></div>
    </div>

    <div class="sidebar-header">
        <div class="sidebar-brand-wrapper">
            <div class="sidebar-logo-badge" aria-hidden="true">
                <svg class="brand-leaf-icon" viewBox="0 0 24 24" fill="none" stroke="#4ade80" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M20 4c-10 0-15 5-15 12 0 3 2 4 5 4 7 0 12-7 10-16Z"/><path d="M4 21c4-7 8-10 13-13"/>
                </svg>
            </div>
            <div class="sidebar-brand-meta">
                <h2>Smart Drying</h2>
                <span class="brand-sub-badge"><span class="pulse-indicator"></span> IoT System</span>
            </div>
        </div>
        <button type="button" class="sidebar-close-btn" onclick="closeSidebar()" aria-label="Close navigation">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 6 6 18M6 6l12 12"/></svg>
        </button>
    </div>

    <div class="sidebar-user-card">
        <div class="user-avatar-ring">
            <div class="user-avatar">${fn:escapeXml(fn:substring(sessionScope.LOGIN_USER.fullName, 0, 1))}</div>
            <span class="user-status-dot"></span>
        </div>
        <div class="user-info">
            <strong title="${fn:escapeXml(sessionScope.LOGIN_USER.fullName)}">${fn:escapeXml(sessionScope.LOGIN_USER.fullName)}</strong>
            <span class="user-role-badge ${sessionScope.LOGIN_USER.role == 'ADMIN' ? 'role-admin' : (sessionScope.LOGIN_USER.role == 'MANAGER' ? 'role-manager' : 'role-operator')}">${fn:escapeXml(sessionScope.LOGIN_USER.role)}</span>
        </div>
    </div>

    <nav class="sidebar-nav">
        <span class="nav-section-label">MAIN MENU</span>
        <a href="${pageContext.request.contextPath}/dashboard" class="sidebar-nav-item ${fn:contains(currentURI, 'dashboard') ? 'active' : ''}" ${fn:contains(currentURI, 'dashboard') ? 'aria-current="page"' : ''}>
            <span class="nav-icon" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg></span>
            <span class="nav-label">Dashboard</span><span class="nav-indicator"></span>
        </a>

        <c:if test="${sessionScope.LOGIN_USER.role == 'OPERATOR' || sessionScope.LOGIN_USER.role == 'MANAGER'}">
            <a href="${pageContext.request.contextPath}/batch" class="sidebar-nav-item ${fn:contains(currentURI, 'batch') ? 'active' : ''}">
                <span class="nav-icon" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"><rect x="5" y="4" width="14" height="17" rx="2"/><path d="M9 4V2h6v2M9 10h6M9 14h6M9 18h4"/></svg></span>
                <span class="nav-label">Drying Batch</span><span class="nav-indicator"></span>
            </a>
            <a href="${pageContext.request.contextPath}/history" class="sidebar-nav-item ${fn:contains(currentURI, 'history') ? 'active' : ''}">
                <span class="nav-icon" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/></svg></span>
                <span class="nav-label">History</span><span class="nav-indicator"></span>
            </a>
        </c:if>

        <c:if test="${sessionScope.LOGIN_USER.role == 'MANAGER' || sessionScope.LOGIN_USER.role == 'ADMIN'}">
            <span class="nav-section-label">MANAGEMENT</span>
            <a href="${pageContext.request.contextPath}/users"
               class="sidebar-nav-item ${fn:contains(currentURI, 'user-management') || fn:contains(currentURI, '/users') ? 'active' : ''}">
                <span class="nav-icon" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"><circle cx="9" cy="8" r="3"/><path d="M3 20v-2a6 6 0 0 1 12 0v2M17 11a3 3 0 1 0-1-6M17 15c2 0 4 2 4 5"/></svg></span>
                <span class="nav-label">User Management</span><span class="nav-indicator"></span>
            </a>
            <a href="${pageContext.request.contextPath}/warehouses" class="sidebar-nav-item ${fn:contains(currentURI, 'warehouse') ? 'active' : ''}">
                <span class="nav-icon" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"><path d="M3 21V8l9-5 9 5v13M3 11h18M8 21v-7h8v7"/></svg></span>
                <span class="nav-label">${sessionScope.LOGIN_USER.role == 'ADMIN' ? 'Warehouse Management' : 'Warehouse'}</span><span class="nav-indicator"></span>
            </a>
        </c:if>

        <c:if test="${sessionScope.LOGIN_USER.role == 'ADMIN'}">
            <a href="${pageContext.request.contextPath}/devices" class="sidebar-nav-item ${fn:contains(currentURI, 'device') ? 'active' : ''}">
                <span class="nav-icon" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"><rect x="5" y="5" width="14" height="14" rx="3"/><path d="M9 2v3m6-3v3M9 19v3m6-3v3M2 9h3m-3 6h3m14-6h3m-3 6h3"/><circle cx="12" cy="12" r="3"/></svg></span>
                <span class="nav-label">Device Management</span><span class="nav-indicator"></span>
            </a>
        </c:if>

        <c:if test="${sessionScope.LOGIN_USER.role == 'OPERATOR' || sessionScope.LOGIN_USER.role == 'MANAGER' || sessionScope.LOGIN_USER.role == 'ADMIN'}">
            <a href="${pageContext.request.contextPath}/events" class="sidebar-nav-item ${fn:contains(currentURI, 'event') ? 'active' : ''}">
                <span class="nav-icon" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"><path d="M8 6h13M8 12h13M8 18h13"/><path d="M3 6h1M3 12h1M3 18h1"/></svg></span>
                <span class="nav-label">Event Log</span><span class="nav-indicator"></span>
            </a>
        </c:if>
    </nav>

    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/logout" class="sidebar-nav-item logout-link">
            <span class="nav-icon logout-icon" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"><path d="M10 17l5-5-5-5M15 12H3"/><path d="M12 3h6a3 3 0 0 1 3 3v12a3 3 0 0 1-3 3h-6"/></svg></span>
            <span class="nav-label">Logout</span>
        </a>
    </div>
</aside>

<script>
    function setSidebarOpen(open) {
        var sidebar = document.getElementById('sidebar');
        var backdrop = document.getElementById('sidebarBackdrop');
        var toggle = document.querySelector('.sidebar-toggle-btn');
        if (!sidebar)
            return;
        sidebar.classList.toggle('open', open);
        if (backdrop)
            backdrop.classList.toggle('active', open);
        if (toggle)
            toggle.setAttribute('aria-expanded', String(open));
    }
    function toggleSidebar() {
        var sidebar = document.getElementById('sidebar');
        setSidebarOpen(!sidebar.classList.contains('open'));
    }
    function closeSidebar() {
        setSidebarOpen(false);
    }
    document.addEventListener('keydown', function (event) {
        if (event.key === 'Escape')
            closeSidebar();
    });
</script>
