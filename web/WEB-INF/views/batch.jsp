<%-- 
    Document   : batch.jsp (Redesigned for Smart Drying IoT System)
    Description: Modern agricultural drying batch management, responsive on desktop and mobile, preserving all JSTL variables
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <title>Drying Batch - Smart Drying IoT System</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/batch.css">
    </head>
    <body class="smart-drying-app">
        <div class="app-layout">
            <jsp:include page="/WEB-INF/views/includes/sidebar.jsp"/>
            
            <main class="main-content">
                <div class="content-container">

                    <%-- ===================================== --%>
                    <%-- TOP APP BAR / AGRICULTURAL IOT HEADER --%>
                    <%-- ===================================== --%>
                    <header class="batch-page-header">
                        <div class="header-title-group">
                            <div class="header-badge">
                                <span class="badge-dot"></span>
                                IoT Facility Live
                            </div>
                            <h1>Drying Batch</h1>
                            <p class="header-subtitle">
                                <c:choose>
                                    <c:when test="${sessionScope.LOGIN_USER.role eq 'MANAGER'}">
                                        Monitor and coordinate agricultural drying batches across managed warehouses.
                                    </c:when>
                                    <c:otherwise>
                                        Monitor and operate agricultural drying batches at your assigned warehouse.
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>

                        <%-- MANAGER: MODERN QUICK WAREHOUSE SELECTOR --%>
                        <c:if test="${sessionScope.LOGIN_USER.role eq 'MANAGER'}">
                            <div class="batch-warehouse-select-card">
                                <label for="warehouseSelect" class="selector-label">
                                    <svg class="icon-svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg>
                                    Assigned Warehouse
                                </label>
                                <form action="${pageContext.request.contextPath}/batch" method="get" class="warehouse-form">
                                    <div class="custom-select-wrapper">
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
                                        <span class="select-chevron">▾</span>
                                    </div>
                                </form>
                            </div>
                        </c:if>

                        <%-- OPERATOR: ASSIGNED WAREHOUSE SUMMARY CARD --%>
                        <c:if test="${sessionScope.LOGIN_USER.role eq 'OPERATOR'}">
                            <div class="warehouse-summary-card">
                                <div class="warehouse-icon-box">
                                    <svg class="icon-svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                                </div>
                                <div class="summary-details">
                                    <span class="summary-label">Assigned Warehouse</span>
                                    <strong>
                                        <c:choose>
                                            <c:when test="${warehouse ne null}">
                                                ${warehouse.warehouseCode} - ${warehouse.warehouseName}
                                            </c:when>
                                            <c:otherwise>
                                                No warehouse assigned
                                            </c:otherwise>
                                        </c:choose>
                                    </strong>
                                </div>
                            </div>
                        </c:if>
                    </header>

                    <%-- ===================================== --%>
                    <%-- CURRENT WAREHOUSE STATUS BANNER --%>
                    <%-- ===================================== --%>
                    <c:if test="${warehouse ne null}">
                        <section class="batch-current-warehouse-banner">
                            <div class="warehouse-banner-info">
                                <span class="badge-tag">Operational</span>
                                <div class="warehouse-meta">
                                    <h3>${warehouse.warehouseCode} · ${warehouse.warehouseName}</h3>
                                    <span class="warehouse-loc">
                                        <svg class="icon-svg-mini" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                                        ${warehouse.location}
                                    </span>
                                </div>
                            </div>
                            <div class="warehouse-banner-stats">
                                <div class="stat-pill">
                                    <span class="stat-pill-label">IoT Sensors</span>
                                    <span class="stat-pill-value status-online">● Online</span>
                                </div>
                            </div>
                        </section>
                    </c:if>

                    <%-- ===================================== --%>
                    <%-- NOTIFICATION ALERTS (TOAST / BANNER) --%>
                    <%-- ===================================== --%>
                    <c:if test="${not empty sessionScope.message}">
                        <div class="alert-banner alert-success" role="alert">
                            <div class="alert-icon">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"></polyline></svg>
                            </div>
                            <div class="alert-content">
                                <strong>Success!</strong>
                                <span>${sessionScope.message}</span>
                            </div>
                        </div>
                        <c:remove var="message" scope="session"/>
                    </c:if>

                    <c:if test="${not empty error}">
                        <div class="alert-banner alert-error" role="alert">
                            <div class="alert-icon">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                            </div>
                            <div class="alert-content">
                                <strong>Error!</strong>
                                <span>${error}</span>
                            </div>
                        </div>
                    </c:if>

                    <%-- ===================================== --%>
                    <%-- START NEW DRYING BATCH --%>
                    <%-- ===================================== --%>
                    <c:if test="${warehouse ne null}">
                        <section class="dashboard-section card-box form-section">
                            <div class="section-header-compact">
                                <div class="section-title-wrap">
                                    <div class="icon-circle primary-light">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="16"></line><line x1="8" y1="12" x2="16" y2="12"></line></svg>
                                    </div>
                                    <div>
                                        <h2>Start New Drying Batch</h2>
                                        <p>Add an agricultural product batch to the drying area of ${warehouse.warehouseCode}.</p>
                                    </div>
                                </div>
                            </div>

                            <form action="${pageContext.request.contextPath}/batch" method="post" class="batch-form-modern">
                                <input type="hidden" name="action" value="start">
                                <input type="hidden" name="warehouseId" value="${warehouse.warehouseId}">
                                
                                <div class="form-grid">
                                    <div class="form-group">
                                        <label for="productName">
                                            Agricultural Product Name <span class="required">*</span>
                                        </label>
                                        <div class="input-with-icon">
                                            <span class="field-icon">🌾</span>
                                            <input type="text" id="productName" name="productName" placeholder="e.g., Robusta coffee beans, black pepper..." maxlength="100" required>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label for="weightKg">
                                            Drying Weight (kg) <span class="required">*</span>
                                        </label>
                                        <div class="input-with-icon">
                                            <span class="field-icon">⚖️</span>
                                            <input type="number" id="weightKg" name="weightKg" min="0.1" step="0.1" placeholder="e.g., 250.5" required>
                                            <span class="input-suffix">KG</span>
                                        </div>
                                    </div>

                                    <div class="form-group full-width">
                                        <label for="notes">
                                            Initial Condition / Moisture Level Notes
                                        </label>
                                        <textarea id="notes" name="notes" rows="3" maxlength="500" placeholder="Initial moisture content: 24%; drying rack: level 2; sunny weather..."></textarea>
                                    </div>
                                </div>

                                <div class="form-actions-bar">
                                    <div class="helper-text">
                                        <svg class="icon-info" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>
                                        The IoT system will automatically monitor temperature and humidity once the batch starts.
                                    </div>
                                    <button type="submit" class="btn-primary-action">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polygon points="5 3 19 12 5 21 5 3"></polygon></svg>
                                        Start Drying Batch
                                    </button>
                                </div>
                            </form>
                        </section>
                    </c:if>

                    <%-- ===================================== --%>
                    <%-- ACTIVE DRYING BATCHES --%>
                    <%-- ===================================== --%>
                    <section class="dashboard-section card-box active-batches-section">
                        <div class="section-header-compact">
                            <div class="section-title-wrap">
                                <div class="icon-circle amber-light pulse-glow">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="5"></circle><line x1="12" y1="1" x2="12" y2="3"></line><line x1="12" y1="21" x2="12" y2="23"></line><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"></line><line x1="1" y1="12" x2="3" y2="12"></line><line x1="21" y1="12" x2="23" y2="12"></line><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"></line><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"></line></svg>
                                </div>
                                <div>
                                    <div class="title-with-chip">
                                        <h2>Active Drying Batches</h2>
                                        <span class="live-tag">DRYING IN PROGRESS</span>
                                    </div>
                                    <p>All agricultural batches currently being dried at this warehouse.</p>
                                </div>
                            </div>
                        </div>

                        <%-- DESKTOP TABLE VIEW --%>
                        <div class="table-responsive-wrapper desktop-only">
                            <table class="smart-table">
                                <thead>
                                    <tr>
                                        <th>Batch ID</th>
                                        <th>Product Type</th>
                                        <th>Operator</th>
                                        <th>Weight</th>
                                        <th>Start Time</th>
                                        <th>Status</th>
                                        <th class="text-right">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:set var="activeCount" value="0"/>
                                    <c:forEach var="batch" items="${activeBatches}">
                                        <c:if test="${batch.status eq 'DRYING'}">
                                            <c:set var="activeCount" value="${activeCount + 1}"/>
                                            <tr class="batch-row-active">
                                                <td class="batch-id-cell">
                                                    <span class="id-tag">#${batch.batchId}</span>
                                                </td>
                                                <td>
                                                    <div class="product-cell">
                                                        <span class="product-icon">🌾</span>
                                                        <strong>${batch.productName}</strong>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="operator-tag">${batch.operatorName}</span>
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
                                                <td>
                                                    <span class="status-badge status-drying">
                                                        <span class="status-dot"></span>
                                                        DRYING
                                                    </span>
                                                </td>
                                                <td class="text-right">
                                                    <%-- MANAGER: Can complete batches within the warehouse --%>
                                                    <c:if test="${sessionScope.LOGIN_USER.role eq 'MANAGER'}">
                                                        <form action="${pageContext.request.contextPath}/batch" method="post" class="inline-action-form" onsubmit="return confirm('Confirm completion of drying batch #${batch.batchId}?');">
                                                            <input type="hidden" name="action" value="complete">
                                                            <input type="hidden" name="batchId" value="${batch.batchId}">
                                                            <input type="hidden" name="warehouseId" value="${warehouse.warehouseId}">
                                                            <button type="submit" class="btn-complete-action">
                                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                                                Complete Batch
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                    <%-- OPERATOR: Can only complete their own batches --%>
                                                    <c:if test="${sessionScope.LOGIN_USER.role eq 'OPERATOR' and batch.operatorId eq sessionScope.LOGIN_USER.userId}">
                                                        <form action="${pageContext.request.contextPath}/batch" method="post" class="inline-action-form" onsubmit="return confirm('Confirm completion of drying batch #${batch.batchId}?');">
                                                            <input type="hidden" name="action" value="complete">
                                                            <input type="hidden" name="batchId" value="${batch.batchId}">
                                                            <input type="hidden" name="warehouseId" value="${warehouse.warehouseId}">
                                                            <button type="submit" class="btn-complete-action">
                                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                                                Complete Batch
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${activeCount eq 0}">
                                        <tr>
                                            <td colspan="7" class="empty-state-cell">
                                                <div class="empty-state-box">
                                                    <div class="empty-icon">☀️</div>
                                                    <h4>No active drying batches</h4>
                                                    <p>Start a new batch above to begin the agricultural drying process.</p>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>

                        <%-- MOBILE CARDS VIEW (TOUCH OPTIMIZED) --%>
                        <div class="mobile-cards-list mobile-only">
                            <c:set var="activeMobileCount" value="0"/>
                            <c:forEach var="batch" items="${activeBatches}">
                                <c:if test="${batch.status eq 'DRYING'}">
                                    <c:set var="activeMobileCount" value="${activeMobileCount + 1}"/>
                                    <article class="mobile-batch-card active-card">
                                        <div class="mobile-card-top">
                                            <div class="m-batch-header">
                                                <span class="id-tag">#${batch.batchId}</span>
                                                <span class="status-badge status-drying">
                                                    <span class="status-dot"></span> DRYING
                                                </span>
                                            </div>
                                            <h3 class="m-product-title">${batch.productName}</h3>
                                        </div>

                                        <div class="mobile-card-grid">
                                            <div class="m-grid-item">
                                                <span class="m-label">Weight</span>
                                                <strong class="m-val highlight">
                                                    <fmt:formatNumber value="${batch.weightKg}" maxFractionDigits="2"/> kg
                                                </strong>
                                            </div>
                                            <div class="m-grid-item">
                                                <span class="m-label">Operator</span>
                                                <strong class="m-val">${batch.operatorName}</strong>
                                            </div>
                                            <div class="m-grid-item full-span">
                                                <span class="m-label">Start Time</span>
                                                <span class="m-val-time">
                                                    <fmt:formatDate value="${batch.startTime}" pattern="dd/MM/yyyy HH:mm"/>
                                                </span>
                                            </div>
                                        </div>

                                        <%-- ACTION CHO MOBILE --%>
                                        <div class="mobile-card-actions">
                                            <c:if test="${sessionScope.LOGIN_USER.role eq 'MANAGER'}">
                                                <form action="${pageContext.request.contextPath}/batch" method="post" class="w-100" onsubmit="return confirm('Complete Batch #${batch.batchId}?');">
                                                    <input type="hidden" name="action" value="complete">
                                                    <input type="hidden" name="batchId" value="${batch.batchId}">
                                                    <input type="hidden" name="warehouseId" value="${warehouse.warehouseId}">
                                                    <button type="submit" class="btn-complete-action-full">
                                                        Complete Batch
                                                    </button>
                                                </form>
                                            </c:if>
                                            <c:if test="${sessionScope.LOGIN_USER.role eq 'OPERATOR' and batch.operatorId eq sessionScope.LOGIN_USER.userId}">
                                                <form action="${pageContext.request.contextPath}/batch" method="post" class="w-100" onsubmit="return confirm('Complete Batch #${batch.batchId}?');">
                                                    <input type="hidden" name="action" value="complete">
                                                    <input type="hidden" name="batchId" value="${batch.batchId}">
                                                    <input type="hidden" name="warehouseId" value="${warehouse.warehouseId}">
                                                    <button type="submit" class="btn-complete-action-full">
                                                        Complete Batch
                                                    </button>
                                                </form>
                                            </c:if>
                                        </div>
                                    </article>
                                </c:if>
                            </c:forEach>

                            <c:if test="${activeMobileCount eq 0}">
                                <div class="empty-state-box mobile-empty">
                                    <div class="empty-icon">☀️</div>
                                    <h4>No active drying batches</h4>
                                    <p>All batches have been completed or no new batches have been started.</p>
                                </div>
                            </c:if>
                        </div>
                    </section>

                    <%-- ===================================== --%>
                    <%-- ALL BATCHES (HISTORY / OVERVIEW) --%>
                    <%-- ===================================== --%>
                    <section class="dashboard-section card-box history-section">
                        <div class="section-header-compact">
                            <div class="section-title-wrap">
                                <div class="icon-circle slate-light">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                                </div>
                                <div>
                                    <h2>All Drying Batches</h2>
                                    <p>All active and completed drying batches at this warehouse.</p>
                                </div>
                            </div>
                        </div>

                        <%-- FILTER TOOLBAR FOR DESKTOP AND MOBILE --%>
                        <form action="${pageContext.request.contextPath}/batch" method="get" class="batch-filter-toolbar">
                            <input type="hidden" name="warehouseId" value="${warehouse.warehouseId}">
                            
                            <div class="search-input-box">
                                <span class="search-icon">🔍</span>
                                <input type="text" name="keyword" value="${keyword}" placeholder="Search by batch ID, product name, or operator...">
                            </div>

                            <div class="filters-cluster">
                                <div class="filter-item">
                                    <select name="status">
                                        <option value="">All Statuses</option>
                                        <option value="DRYING" ${selectedStatus eq 'DRYING' ? 'selected' : ''}>Drying (DRYING)</option>
                                        <option value="COMPLETED" ${selectedStatus eq 'COMPLETED' ? 'selected' : ''}>Completed (COMPLETED)</option>
                                    </select>
                                </div>

                                <div class="filter-item">
                                    <select name="sortBy">
                                        <option value="startTime" ${sortBy eq 'startTime' ? 'selected' : ''}>Start Time</option>
                                        <option value="endTime" ${sortBy eq 'endTime' ? 'selected' : ''}>End Time</option>
                                        <option value="productName" ${sortBy eq 'productName' ? 'selected' : ''}>Product Name</option>
                                        <option value="weight" ${sortBy eq 'weight' ? 'selected' : ''}>Weight</option>
                                        <option value="status" ${sortBy eq 'status' ? 'selected' : ''}>Status</option>
                                    </select>
                                </div>

                                <div class="filter-item">
                                    <select name="sortOrder">
                                        <option value="DESC" ${sortOrder eq 'DESC' ? 'selected' : ''}>Descending (Newest First)</option>
                                        <option value="ASC" ${sortOrder eq 'ASC' ? 'selected' : ''}>Ascending</option>
                                    </select>
                                </div>

                                <input type="hidden" name="page" value="1">

                                <div class="filter-buttons">
                                    <button type="submit" class="btn-filter-apply">
                                        Apply Filters
                                    </button>
                                    <a href="${pageContext.request.contextPath}/batch?warehouseId=${warehouse.warehouseId}" class="btn-filter-reset">
                                        Reset
                                    </a>
                                </div>
                            </div>
                        </form>

                        <%-- DESKTOP ALL BATCHES TABLE --%>
                        <div class="table-responsive-wrapper desktop-only">
                            <table class="smart-table">
                                <thead>
                                    <tr>
                                        <th>Batch ID</th>
                                        <th>Product</th>
                                        <th>Operator</th>
                                        <th>Weight</th>
                                        <th>Start</th>
                                        <th>End</th>
                                        <th>Status</th>
                                        <th>Notes</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty batches}">
                                            <c:forEach var="batch" items="${batches}">
                                                <tr>
                                                    <td>
                                                        <span class="id-tag">#${batch.batchId}</span>
                                                    </td>
                                                    <td class="font-medium">${batch.productName}</td>
                                                    <td>${batch.operatorName}</td>
                                                    <td>
                                                        <strong><fmt:formatNumber value="${batch.weightKg}" maxFractionDigits="2"/></strong> kg
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
                                                                <span class="dash-text">—</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${batch.status eq 'DRYING'}">
                                                                <span class="status-badge status-drying">
                                                                    <span class="status-dot"></span> DRYING
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="status-badge status-completed">
                                                                    <span class="status-dot-green"></span> COMPLETED
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="notes-cell">
                                                        <c:choose>
                                                            <c:when test="${not empty batch.notes}">
                                                                <span class="note-tooltip" title="${batch.notes}">${batch.notes}</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="dash-text">—</span>
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
                                                        <div class="empty-icon">📂</div>
                                                        <h4>No drying batches found</h4>
                                                        <p>Try changing the search keyword or clearing the filters.</p>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>

                        <%-- MOBILE ALL BATCHES CARD LIST --%>
                        <div class="mobile-cards-list mobile-only">
                            <c:choose>
                                <c:when test="${not empty batches}">
                                    <c:forEach var="batch" items="${batches}">
                                        <article class="mobile-batch-card">
                                            <div class="mobile-card-top">
                                                <div class="m-batch-header">
                                                    <span class="id-tag">#${batch.batchId}</span>
                                                    <c:choose>
                                                        <c:when test="${batch.status eq 'DRYING'}">
                                                            <span class="status-badge status-drying">
                                                                <span class="status-dot"></span> DRYING
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge status-completed">
                                                                <span class="status-dot-green"></span> COMPLETED
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <h3 class="m-product-title">${batch.productName}</h3>
                                            </div>

                                            <div class="mobile-card-grid">
                                                <div class="m-grid-item">
                                                    <span class="m-label">Weight</span>
                                                    <strong class="m-val"><fmt:formatNumber value="${batch.weightKg}" maxFractionDigits="2"/> kg</strong>
                                                </div>
                                                <div class="m-grid-item">
                                                    <span class="m-label">Operator</span>
                                                    <strong class="m-val">${batch.operatorName}</strong>
                                                </div>
                                                <div class="m-grid-item">
                                                    <span class="m-label">Start</span>
                                                    <span class="m-val-time"><fmt:formatDate value="${batch.startTime}" pattern="dd/MM HH:mm"/></span>
                                                </div>
                                                <div class="m-grid-item">
                                                    <span class="m-label">End</span>
                                                    <span class="m-val-time">
                                                        <c:choose>
                                                            <c:when test="${batch.endTime ne null}">
                                                                <fmt:formatDate value="${batch.endTime}" pattern="dd/MM HH:mm"/>
                                                            </c:when>
                                                            <c:otherwise>Drying...</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </div>
                                                <c:if test="${not empty batch.notes}">
                                                    <div class="m-grid-item full-span notes-block">
                                                        <span class="m-label">Notes</span>
                                                        <p class="m-notes-text">${batch.notes}</p>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </article>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state-box mobile-empty">
                                        <div class="empty-icon">📂</div>
                                        <h4>No results found</h4>
                                        <p>No drying batches match the selected filters.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <%-- ===================================== --%>
                        <%-- PAGINATION --%>
                        <%-- ===================================== --%>
                        <c:if test="${totalPages > 1}">
                            <div class="pagination-container">
                                <div class="pagination-info">
                                    Page <strong>${currentPage}</strong> / ${totalPages}
                                </div>
                                <div class="pagination-nav">
                                    <%-- PREVIOUS --%>
                                    <c:if test="${currentPage > 1}">
                                        <c:url var="prevUrl" value="/batch">
                                            <c:param name="warehouseId" value="${warehouse.warehouseId}"/>
                                            <c:param name="keyword" value="${keyword}"/>
                                            <c:param name="status" value="${selectedStatus}"/>
                                            <c:param name="sortBy" value="${sortBy}"/>
                                            <c:param name="sortOrder" value="${sortOrder}"/>
                                            <c:param name="page" value="${currentPage - 1}"/>
                                        </c:url>
                                        <a href="${prevUrl}" class="page-btn page-arrow" aria-label="Previous page">
                                            ‹ Previous
                                        </a>
                                    </c:if>

                                    <%-- PAGE NUMBER --%>
                                    <div class="page-numbers-group">
                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <c:url var="pageUrl" value="/batch">
                                                <c:param name="warehouseId" value="${warehouse.warehouseId}"/>
                                                <c:param name="keyword" value="${keyword}"/>
                                                <c:param name="status" value="${selectedStatus}"/>
                                                <c:param name="sortBy" value="${sortBy}"/>
                                                <c:param name="sortOrder" value="${sortOrder}"/>
                                                <c:param name="page" value="${i}"/>
                                            </c:url>
                                            <a href="${pageUrl}" class="page-btn ${i eq currentPage ? 'active' : ''}">
                                                ${i}
                                            </a>
                                        </c:forEach>
                                    </div>

                                    <%-- NEXT --%>
                                    <c:if test="${currentPage < totalPages}">
                                        <c:url var="nextUrl" value="/batch">
                                            <c:param name="warehouseId" value="${warehouse.warehouseId}"/>
                                            <c:param name="keyword" value="${keyword}"/>
                                            <c:param name="status" value="${selectedStatus}"/>
                                            <c:param name="sortBy" value="${sortBy}"/>
                                            <c:param name="sortOrder" value="${sortOrder}"/>
                                            <c:param name="page" value="${currentPage + 1}"/>
                                        </c:url>
                                        <a href="${nextUrl}" class="page-btn page-arrow" aria-label="Next page">
                                            Next ›
                                        </a>
                                    </c:if>
                                </div>
                            </div>
                        </c:if>
                    </section>

                </div>
            </main>
        </div>
    </body>
</html>
