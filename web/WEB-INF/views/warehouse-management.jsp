<%-- Warehouse Management - Smart Agricultural Drying System --%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Warehouse Management - Smart Agricultural Drying System</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&amp;family=JetBrains+Mono:wght@500;600;700&amp;display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
<link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/warehouse-management.css?v=2">
</head>
<body>
<div class="app-layout">
    <jsp:include page="/WEB-INF/views/includes/sidebar.jsp" />
    <main class="main-content">
        <div class="content-container">
            <header class="warehouse-header-card">
                <div class="header-meta">
                    <div class="header-badge-row">
                        <span class="role-pill">${sessionScope.LOGIN_USER.role}</span>
                        <span class="system-pill"><span class="pulse-dot"></span> Smart Drying System</span>
                    </div>
                    <h1>Warehouse Overview</h1>
                    <p class="header-subtitle">Manage warehouse information and operational status.</p>
                </div>
                <c:if test="${sessionScope.LOGIN_USER.role eq 'ADMIN'}">
                    <button class="btn-toggle-add" type="button" onclick="toggleAddWarehouse()" aria-controls="addWarehouseForm" aria-expanded="false" id="addWarehouseToggle">+ Add Warehouse</button>
                </c:if>
            </header>

            <section class="warehouse-metric-grid" aria-label="Warehouse statistics">
                <div class="warehouse-stat-card card-total">
                    <div class="stat-icon-box" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9 12 3l9 6v12H3V9Z"/><path d="M9 21v-8h6v8"/></svg></div>
                    <div class="stat-details"><span class="stat-label">Total Warehouses</span><strong class="stat-val">${totalWarehouses}</strong></div>
                </div>
                <div class="warehouse-stat-card card-active">
                    <div class="stat-icon-box" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="9"/><path d="m8 12 3 3 5-6"/></svg></div>
                    <div class="stat-details"><span class="stat-label">Active Warehouses</span><strong class="stat-val text-active">${activeWarehouses}</strong></div>
                </div>
                <div class="warehouse-stat-card card-inactive">
                    <div class="stat-icon-box" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="9"/><path d="M8 8l8 8m0-8-8 8"/></svg></div>
                    <div class="stat-details"><span class="stat-label">Inactive Warehouses</span><strong class="stat-val text-inactive">${inactiveWarehouses}</strong></div>
                </div>
            </section>

            <c:if test="${not empty error}">
                <div class="alert-banner alert-error" role="alert">
                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M12 7v6m0 4h.01"/></svg>
                    <span><c:out value="${error}" /></span>
                </div>
            </c:if>

            <c:if test="${sessionScope.LOGIN_USER.role eq 'ADMIN'}">
                <section id="addWarehouseForm" class="add-warehouse-drawer" style="display:none" aria-label="Add a new warehouse">
                    <div class="drawer-header">
                        <div class="drawer-heading-wrap">
                            <span class="drawer-icon-box" aria-hidden="true"><svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 5v14M5 12h14"/></svg></span>
                            <div><h3>Add New Warehouse</h3><p>Register an agricultural drying warehouse.</p></div>
                        </div>
                        <button type="button" class="btn-drawer-close" onclick="toggleAddWarehouse()" aria-label="Close">&times;</button>
                    </div>
                    <form action="${pageContext.request.contextPath}/warehouses" method="post">
                        <input type="hidden" name="action" value="add">
                        <div class="form-grid-2col">
                            <div class="form-field"><label for="newWarehouseId">Warehouse ID <span class="required">*</span></label><div class="input-with-icon"><span class="field-icon">#</span><input id="newWarehouseId" type="text" name="warehouseId" placeholder="W001" required maxlength="50"></div></div>
                            <div class="form-field"><label for="newWarehouseCode">Warehouse Code <span class="required">*</span></label><div class="input-with-icon"><span class="field-icon">#</span><input id="newWarehouseCode" type="text" name="warehouseCode" placeholder="WH-001" required maxlength="50"></div></div>
                            <div class="form-field"><label for="newWarehouseName">Warehouse Name <span class="required">*</span></label><div class="input-with-icon"><span class="field-icon">⌂</span><input id="newWarehouseName" type="text" name="warehouseName" placeholder="Main Drying Area" required maxlength="150"></div></div>
                            <div class="form-field"><label for="newWarehouseLocation">Location <span class="required">*</span></label><div class="input-with-icon"><span class="field-icon">⌖</span><input id="newWarehouseLocation" type="text" name="location" placeholder="Warehouse location" required maxlength="255"></div></div>
                        </div>
                        <div class="drawer-actions-row"><span class="drawer-note">Fields marked * are required.</span><div class="drawer-btn-group"><button type="button" class="btn-drawer-cancel" onclick="toggleAddWarehouse()">Cancel</button><button type="submit" class="btn-drawer-submit">Add Warehouse</button></div></div>
                    </form>
                </section>
            </c:if>

            <section class="warehouse-content-card">
                <div class="card-top-strip"><div class="strip-header-cluster"><span class="strip-icon-box" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9 12 3l9 6v12H3V9Z"/><path d="M9 21v-8h6v8"/></svg></span><div><h2>Warehouse List</h2><p>All registered warehouses and their current status.</p></div></div></div>
                <div class="table-responsive-wrapper desktop-only">
                    <table class="smart-warehouse-table">
                        <thead><tr><th>#</th><th>Warehouse ID</th><th>Code</th><th>Warehouse Name</th><th>Location</th><th>Status</th><th>Created At</th><c:if test="${sessionScope.LOGIN_USER.role eq 'ADMIN'}"><th class="text-right">Actions</th></c:if></tr></thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty warehouseList}">
                                <c:forEach var="warehouse" items="${warehouseList}" varStatus="loop">
                                    <tr class="warehouse-row">
                                        <td class="num-cell">${loop.count}</td>
                                        <td><span class="id-pill"><c:out value="${warehouse.warehouseId}"/></span></td>
                                        <td><span class="code-pill"><c:out value="${warehouse.warehouseCode}"/></span></td>
                                        <td class="warehouse-name-cell"><c:out value="${warehouse.warehouseName}"/></td>
                                        <td><span class="location-cell"><c:out value="${warehouse.location}"/></span></td>
                                        <td><c:choose><c:when test="${warehouse.status eq 'ACTIVE'}"><span class="status-badge status-active"><span class="pulse-indicator-green"></span> ACTIVE</span></c:when><c:otherwise><span class="status-badge status-inactive"><span class="pulse-indicator-gray"></span> INACTIVE</span></c:otherwise></c:choose></td>
                                        <td class="time-cell"><fmt:formatDate value="${warehouse.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                                        <c:if test="${sessionScope.LOGIN_USER.role eq 'ADMIN'}"><td class="text-right"><div class="action-btn-cluster">
                                            <button type="button" class="btn-action-edit" onclick="toggleEditWarehouse(this)" data-target="edit-${loop.index}">Edit</button>
                                            <form action="${pageContext.request.contextPath}/warehouses" method="post" class="inline-form" onsubmit="return confirm('Change this warehouse status?');"><input type="hidden" name="action" value="toggleStatus"><input type="hidden" name="warehouseId" value="${warehouse.warehouseId}"><button class="btn-action-status ${warehouse.status eq 'ACTIVE' ? 'btn-status-disable' : 'btn-status-enable'}" type="submit">${warehouse.status eq 'ACTIVE' ? 'Disable' : 'Activate'}</button></form>
                                        </div></td></c:if>
                                    </tr>
                                    <c:if test="${sessionScope.LOGIN_USER.role eq 'ADMIN'}">
                                        <tr id="edit-${loop.index}" class="edit-warehouse-row" style="display:none"><td colspan="8"><div class="edit-drawer-box"><div class="edit-drawer-head"><div class="edit-title"><strong>Edit Warehouse: <c:out value="${warehouse.warehouseCode}"/></strong></div><button type="button" class="btn-close-sub" onclick="closeEditWarehouse(this)" aria-label="Close">&times;</button></div>
                                            <form class="edit-form-inner" action="${pageContext.request.contextPath}/warehouses" method="post"><input type="hidden" name="action" value="update"><input type="hidden" name="warehouseId" value="${warehouse.warehouseId}">
                                                <div class="edit-grid">
                                                    <div class="form-field"><label>Warehouse ID</label><input type="text" class="input-disabled" value="${warehouse.warehouseId}" disabled></div>
                                                    <div class="form-field"><label>Warehouse Code <span class="required">*</span></label><input type="text" name="warehouseCode" value="${warehouse.warehouseCode}" required></div>
                                                    <div class="form-field"><label>Warehouse Name <span class="required">*</span></label><input type="text" name="warehouseName" value="${warehouse.warehouseName}" required></div>
                                                    <div class="form-field"><label>Location <span class="required">*</span></label><input type="text" name="location" value="${warehouse.location}" required></div>
                                                </div><div class="drawer-actions-row"><span class="drawer-note">Update warehouse details.</span><div class="drawer-btn-group"><button type="button" class="btn-drawer-cancel" onclick="closeEditWarehouse(this)">Cancel</button><button class="btn-drawer-submit" type="submit">Save Changes</button></div></div>
                                            </form></div></td></tr>
                                    </c:if>
                                </c:forEach>
                            </c:when>
                            <c:otherwise><tr><td class="empty-state-cell" colspan="${sessionScope.LOGIN_USER.role eq 'ADMIN' ? 8 : 7}"><div class="empty-state-box"><div class="empty-icon">📦</div><h4>No warehouses found</h4><p>No warehouse records are available.</p></div></td></tr></c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
                <div class="mobile-warehouse-card-list mobile-only">
                    <c:choose>
                        <c:when test="${not empty warehouseList}">
                            <c:forEach var="warehouse" items="${warehouseList}" varStatus="loop">
                                <article class="mobile-warehouse-card ${warehouse.status eq 'ACTIVE' ? '' : 'is-inactive'}">
                                    <div class="m-card-top-row"><div class="m-id-code"><span class="id-pill"><c:out value="${warehouse.warehouseId}"/></span><span class="code-pill"><c:out value="${warehouse.warehouseCode}"/></span></div><span class="status-badge ${warehouse.status eq 'ACTIVE' ? 'status-active' : 'status-inactive'}">${warehouse.status eq 'ACTIVE' ? 'ACTIVE' : 'INACTIVE'}</span></div>
                                    <h3 class="m-warehouse-title"><c:out value="${warehouse.warehouseName}"/></h3>
                                    <div class="m-meta-grid"><div class="m-meta-tile full-span"><span class="m-label">Location</span><span class="m-val"><c:out value="${warehouse.location}"/></span></div><div class="m-meta-tile full-span"><span class="m-label">Created At</span><span class="m-val"><fmt:formatDate value="${warehouse.createdAt}" pattern="yyyy-MM-dd HH:mm"/></span></div></div>
                                    <c:if test="${sessionScope.LOGIN_USER.role eq 'ADMIN'}"><div class="m-actions-toolbar"><button class="btn-action-edit m-btn-flex" type="button" onclick="toggleMobileEdit(this)" aria-expanded="false">Edit</button><form action="${pageContext.request.contextPath}/warehouses" method="post" class="m-btn-flex" onsubmit="return confirm('Change this warehouse status?');"><input type="hidden" name="action" value="toggleStatus"><input type="hidden" name="warehouseId" value="${warehouse.warehouseId}"><button type="submit" class="btn-action-status w-100 ${warehouse.status eq 'ACTIVE' ? 'btn-status-disable' : 'btn-status-enable'}">${warehouse.status eq 'ACTIVE' ? 'Disable' : 'Activate'}</button></form></div>
                                        <div class="mobile-edit-container" style="display:none"><form class="edit-form-inner" action="${pageContext.request.contextPath}/warehouses" method="post"><input type="hidden" name="action" value="update"><input type="hidden" name="warehouseId" value="${warehouse.warehouseId}"><div class="edit-grid"><div class="form-field"><label>Warehouse Code</label><input name="warehouseCode" type="text" value="${warehouse.warehouseCode}" required></div><div class="form-field"><label>Warehouse Name</label><input name="warehouseName" type="text" value="${warehouse.warehouseName}" required></div><div class="form-field"><label>Location</label><input name="location" type="text" value="${warehouse.location}" required></div></div><div class="drawer-actions-row"><span class="drawer-note">Edit warehouse information.</span><div class="drawer-btn-group"><button type="button" class="btn-drawer-cancel" onclick="closeMobileEdit(this)">Cancel</button><button type="submit" class="btn-drawer-submit">Save Changes</button></div></div></form></div>
                                    </c:if>
                                </article>
                            </c:forEach>
                        </c:when>
                        <c:otherwise><div class="empty-state-box"><div class="empty-icon">📦</div><h4>No warehouses found</h4><p>No warehouse records are available.</p></div></c:otherwise>
                    </c:choose>
                </div>
            </section>
            <footer class="dashboard-footer"><div class="footer-system-status"><span class="pulse-dot"></span> Smart Agricultural Drying System</div><span class="footer-version">Warehouse Management</span></footer>
        </div>
    </main>
</div>
<script>
    function toggleAddWarehouse() {
        var el = document.getElementById('addWarehouseForm');
        if (!el) return;
        var open = el.style.display === 'none' || el.style.display === '';
        el.style.display = open ? 'block' : 'none';
        var button = document.getElementById('addWarehouseToggle');
        if (button) button.setAttribute('aria-expanded', String(open));
    }
    function toggleEditWarehouse(button) {
        var row = document.getElementById(button.getAttribute('data-target'));
        if (row) row.style.display = row.style.display === 'none' ? 'table-row' : 'none';
    }
    function closeEditWarehouse(button) {
        var row = button.closest('tr.edit-warehouse-row');
        if (row) row.style.display = 'none';
    }
    function toggleMobileEdit(button) {
        var edit = button.closest('.mobile-warehouse-card').querySelector('.mobile-edit-container');
        if (!edit) return;
        var open = edit.style.display === 'none';
        edit.style.display = open ? 'block' : 'none';
        button.setAttribute('aria-expanded', String(open));
    }
    function closeMobileEdit(button) {
        var card = button.closest('.mobile-warehouse-card');
        card.querySelector('.mobile-edit-container').style.display = 'none';
        card.querySelector('.m-actions-toolbar .btn-action-edit').setAttribute('aria-expanded', 'false');
    }
</script>
</body>
</html>
