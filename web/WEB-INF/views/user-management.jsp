<%-- User Management - redesigned to match user-management.css. Servlet contracts retained. --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>User Management - Smart Agricultural Drying System</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user-management.css">
    </head>
    <body>
        <div class="app-layout">
            <jsp:include page="/WEB-INF/views/includes/sidebar.jsp"/>
            <main class="main-content">
                <div class="content-container">
                    <header class="user-header-card">
                        <div class="header-meta">
                            <div class="header-badge-row">
                                <span class="role-pill">User Administration</span>
                                <span class="system-pill"><span class="pulse-dot"></span> Smart Drying System</span>
                            </div>
                            <h1>User Management</h1>
                            <p class="header-subtitle">View and manage users, roles, and warehouse assignments.</p>
                        </div>
                        <c:if test="${sessionScope.LOGIN_USER.role eq 'ADMIN'}">
                            <button type="button" class="btn-toggle-add" onclick="toggleAddUser()" aria-controls="addUserDrawer" aria-expanded="false" id="addUserToggle">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 5v14M5 12h14"/></svg>
                                Add New User
                            </button>
                        </c:if>
                    </header>

                    <section class="user-metric-grid" aria-label="User statistics">
                        <div class="user-stat-card card-total">
                            <div class="stat-icon-box"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2M16 3.1a4 4 0 0 1 0 7.8M22 21v-2a4 4 0 0 0-3-3.87"/><circle cx="9" cy="7" r="4"/></svg></div>
                            <div class="stat-details"><span class="stat-label">Total Users</span><strong class="stat-val">${totalUsers}</strong></div>
                        </div>
                        <div class="user-stat-card card-active">
                            <div class="stat-icon-box"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="m8 12 3 3 5-6"/></svg></div>
                            <div class="stat-details"><span class="stat-label">Active Users</span><strong class="stat-val text-active">${activeUsers}</strong></div>
                        </div>
                        <div class="user-stat-card card-inactive">
                            <div class="stat-icon-box"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M9 9l6 6M15 9l-6 6"/></svg></div>
                            <div class="stat-details"><span class="stat-label">Inactive Users</span><strong class="stat-val text-inactive">${totalUsers - activeUsers}</strong></div>
                        </div>
                    </section>

                    <c:if test="${not empty error}">
                        <div class="alert-banner alert-error" role="alert">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M12 7v6M12 17h.01"/></svg>
                            <c:out value="${error}"/>
                        </div>
                    </c:if>

                    <c:if test="${sessionScope.LOGIN_USER.role eq 'ADMIN'}">
                        <section class="add-user-drawer" id="addUserDrawer" style="display:none;" aria-label="Add new user">
                            <div class="drawer-header">
                                <div class="drawer-heading-wrap">
                                    <div class="drawer-icon-box"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 5v14M5 12h14"/></svg></div>
                                    <div><h3>Add New User</h3><p>Create a user account and assign access permissions.</p></div>
                                </div>
                                <button type="button" class="btn-drawer-close" onclick="toggleAddUser()" aria-label="Close add user form">&#10005;</button>
                            </div>
                            <form action="${pageContext.request.contextPath}/users" method="post">
                                <input type="hidden" name="action" value="add">
                                <div class="form-grid-3col">
                                    <div class="form-field"><label for="newUserId">User ID <span class="required">*</span></label><div class="input-with-icon"><span class="field-icon">#</span><input id="newUserId" type="text" name="userId" placeholder="U001" required></div></div>
                                    <div class="form-field"><label for="newUsername">Username <span class="required">*</span></label><div class="input-with-icon"><span class="field-icon">@</span><input id="newUsername" type="text" name="username" placeholder="username" autocomplete="username" required></div></div>
                                    <div class="form-field"><label for="newPassword">Password <span class="required">*</span></label><div class="input-with-icon"><span class="field-icon">&#9679;</span><input id="newPassword" type="password" name="password" placeholder="Password" autocomplete="new-password" required></div></div>
                                    <div class="form-field"><label for="newFullName">Full Name <span class="required">*</span></label><div class="input-with-icon"><span class="field-icon">&#9823;</span><input id="newFullName" type="text" name="fullName" placeholder="Full name" required></div></div>
                                    <div class="form-field"><label for="newRole">Role <span class="required">*</span></label><div class="select-wrapper"><select id="newRole" name="role" required><option value="">Select role</option><option value="ADMIN">Admin</option><option value="MANAGER">Manager</option><option value="OPERATOR">Operator</option></select><span class="select-arrow">&#9662;</span></div></div>

                                    <div class="form-field">
                                        <label>Assign Warehouses</label>

                                        <div class="warehouse-check-grid">

                                            <c:forEach var="warehouse"
                                                       items="${warehouseList}">

                                                <label class="warehouse-check-card">

                                                    <input type="checkbox"
                                                           name="warehouseIds"
                                                           value="${warehouse.warehouseId}">

                                                    <span class="warehouse-check-text">
                                                        <strong>
                                                            <c:out value="${warehouse.warehouseCode}"/>
                                                        </strong>

                                                        <small>
                                                            <c:out value="${warehouse.warehouseName}"/>
                                                        </small>
                                                    </span>

                                                </label>

                                            </c:forEach>

                                        </div>
                                    </div>
                                </div>
                                <div class="drawer-actions-row"><span class="drawer-note">
                                        Select one or more warehouses if required (Only for Manager)
                                    </span><div class="drawer-btn-group"><button type="button" class="btn-drawer-cancel" onclick="toggleAddUser()">Cancel</button><button type="submit" class="btn-drawer-submit">Create User</button></div></div></form></section> </c:if>

                        <section class="user-content-card">
                            <div class="card-top-strip"><div class="strip-header-cluster"><div class="strip-icon-box"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M8 6h13M8 12h13M8 18h13M3 6h.01M3 12h.01M3 18h.01"/></svg></div><div><h2>User Directory</h2><p>Search, filter and update registered accounts.</p></div></div></div>
                            <form action="${pageContext.request.contextPath}/users" method="get" class="user-filter-toolbar">
                            <div class="form-field search-field"><label for="keyword">Search Users</label><div class="input-with-icon"><span class="field-icon">&#9906;</span><input id="keyword" type="text" name="keyword" value="${keyword}" placeholder="Search by user ID, name or username..."></div></div>
                            <div class="form-field"><label for="filterRole">Role</label><div class="select-wrapper"><select id="filterRole" name="role"><option value="">All Roles</option><option value="ADMIN" ${selectedRole eq 'ADMIN' ? 'selected' : ''}>Admin</option><option value="MANAGER" ${selectedRole eq 'MANAGER' ? 'selected' : ''}>Manager</option><option value="OPERATOR" ${selectedRole eq 'OPERATOR' ? 'selected' : ''}>Operator</option></select><span class="select-arrow">&#9662;</span></div></div>
                            <div class="form-field"><label for="filterStatus">Status</label><div class="select-wrapper"><select id="filterStatus" name="status"><option value="">All Statuses</option><option value="ACTIVE" ${selectedStatus eq 'ACTIVE' ? 'selected' : ''}>Active</option><option value="INACTIVE" ${selectedStatus eq 'INACTIVE' ? 'selected' : ''}>Inactive</option></select><span class="select-arrow">&#9662;</span></div></div>
                            <div class="form-field"><label for="filterSort">Sort By</label><div class="select-wrapper"><select id="filterSort" name="sortBy"><option value="userId" ${empty sortBy or sortBy eq 'userId' ? 'selected' : ''}>User ID</option><option value="username" ${sortBy eq 'username' ? 'selected' : ''}>Username</option><option value="fullName" ${sortBy eq 'fullName' ? 'selected' : ''}>Full Name</option><option value="role" ${sortBy eq 'role' ? 'selected' : ''}>Role</option><option value="createdAt" ${sortBy eq 'createdAt' ? 'selected' : ''}>Created Date</option></select><span class="select-arrow">&#9662;</span></div></div>
                            <div class="form-field"><label for="filterOrder">Order</label><div class="select-wrapper"><select id="filterOrder" name="sortOrder"><option value="ASC" ${sortOrder eq 'ASC' ? 'selected' : ''}>Ascending</option><option value="DESC" ${sortOrder eq 'DESC' ? 'selected' : ''}>Descending</option></select><span class="select-arrow">&#9662;</span></div></div>
                            <input type="hidden" name="page" value="1">
                            <div class="filter-button-cluster"><button class="btn-filter-apply" type="submit">Apply</button><a class="btn-filter-reset" href="${pageContext.request.contextPath}/users">Reset</a></div>
                        </form>

                        <div class="table-responsive-wrapper desktop-only">
                            <table class="smart-user-table">
                                <thead><tr><th>User ID</th><th>Username</th><th>Full Name</th><th>Role</th><th>Warehouses</th><th>Status</th><th>Created At</th><c:if test="${sessionScope.LOGIN_USER.role eq 'ADMIN'}"><th>Actions</th></c:if></tr></thead>
                                    <tbody>
                                    <c:choose>
                                        <c:when test="${not empty users}">
                                            <c:forEach var="user" items="${users}">
                                                <tr class="user-row">
                                                    <td><span class="id-pill"><c:out value="${user.userId}"/></span></td>
                                                    <td><span class="username-tag"><c:out value="${user.username}"/></span></td>
                                                    <td class="user-fullname-cell"><c:out value="${user.fullName}"/></td>
                                                    <td><span class="role-badge ${user.role eq 'ADMIN' ? 'role-admin' : (user.role eq 'MANAGER' ? 'role-manager' : 'role-operator')}"><c:out value="${user.role}"/></span></td>
                                                    <td><div class="warehouse-tag-cluster"><c:set var="assignedWarehouses" value="${userWarehouseMap[user.userId]}"/><c:choose><c:when test="${not empty assignedWarehouses}"><c:forEach var="warehouse" items="${assignedWarehouses}"><span class="warehouse-tag"><c:out value="${warehouse.warehouseCode}"/> - <c:out value="${warehouse.warehouseName}"/></span></c:forEach></c:when><c:otherwise><span class="text-muted">No assignment</span></c:otherwise></c:choose></div></td>
                                                    <td><span class="status-badge ${user.status eq 'ACTIVE' ? 'status-active' : 'status-inactive'}"><c:out value="${user.status}"/></span></td>
                                                    <td class="time-cell">
                                                        <fmt:formatDate value="${user.createdAt}"
                                                                        pattern="dd/MM/yyyy HH:mm"/>
                                                    </td>

                                                    <c:if test="${sessionScope.LOGIN_USER.role eq 'ADMIN'}">

                                                        <td class="actions-cell">

                                                            <div class="admin-action-stack">

                                                                <%-- UPDATE NAME --%>
                                                                <form action="${pageContext.request.contextPath}/users"
                                                                      method="post"
                                                                      class="action-form-row">

                                                                    <input type="hidden"
                                                                           name="action"
                                                                           value="updateName">

                                                                    <input type="hidden"
                                                                           name="userId"
                                                                           value="${user.userId}">

                                                                    <input class="input-sm-action"
                                                                           type="text"
                                                                           name="fullName"
                                                                           value="${user.fullName}"
                                                                           required>

                                                                    <button type="submit"
                                                                            class="btn-action-sm">
                                                                        Update Name
                                                                    </button>

                                                                </form>


                                                                <%-- UPDATE ROLE --%>
                                                                <form action="${pageContext.request.contextPath}/users"
                                                                      method="post"
                                                                      class="action-form-row">

                                                                    <input type="hidden"
                                                                           name="action"
                                                                           value="updateRole">

                                                                    <input type="hidden"
                                                                           name="userId"
                                                                           value="${user.userId}">

                                                                    <select class="select-sm-action"
                                                                            name="role">

                                                                        <option value="ADMIN"
                                                                                ${user.role eq 'ADMIN' ? 'selected' : ''}>
                                                                            ADMIN
                                                                        </option>

                                                                        <option value="MANAGER"
                                                                                ${user.role eq 'MANAGER' ? 'selected' : ''}>
                                                                            MANAGER
                                                                        </option>

                                                                        <option value="OPERATOR"
                                                                                ${user.role eq 'OPERATOR' ? 'selected' : ''}>
                                                                            OPERATOR
                                                                        </option>

                                                                    </select>

                                                                    <button type="submit"
                                                                            class="btn-action-sm">
                                                                        Update Role
                                                                    </button>

                                                                </form>


                                                                <%-- ASSIGN WAREHOUSE --%>
                                                                <c:if test="${user.role ne 'ADMIN'}">

                                                                    <form action="${pageContext.request.contextPath}/users"
                                                                          method="post"
                                                                          class="warehouse-assign-form">

                                                                        <input type="hidden"
                                                                               name="action"
                                                                               value="assignWarehouse">

                                                                        <input type="hidden"
                                                                               name="userId"
                                                                               value="${user.userId}">

                                                                        <div class="warehouse-checkbox-list-sm">

                                                                            <c:forEach var="warehouse"
                                                                                       items="${warehouseList}">

                                                                                <c:set var="warehouseSelected"
                                                                                       value="false"/>

                                                                                <c:forEach var="assigned"
                                                                                           items="${assignedWarehouses}">

                                                                                    <c:if test="${assigned.warehouseId eq warehouse.warehouseId}">
                                                                                        <c:set var="warehouseSelected"
                                                                                               value="true"/>
                                                                                    </c:if>

                                                                                </c:forEach>

                                                                                <label class="warehouse-checkbox-item-sm">

                                                                                    <input type="checkbox"
                                                                                           name="warehouseIds"
                                                                                           value="${warehouse.warehouseId}"
                                                                                           ${warehouseSelected ? 'checked' : ''}>

                                                                                    <span>
                                                                                        <c:out value="${warehouse.warehouseCode}"/>
                                                                                        -
                                                                                        <c:out value="${warehouse.warehouseName}"/>
                                                                                    </span>

                                                                                </label>

                                                                            </c:forEach>
                                                                            <span class="drawer-note">
                                                                                Select one or more warehouses if required (Only for Manager)
                                                                            </span>
                                                                        </div>

                                                                        <button type="submit"
                                                                                class="btn-action-sm">
                                                                            Save Warehouses
                                                                        </button>

                                                                    </form>

                                                                </c:if>


                                                                <%-- ENABLE / DISABLE --%>
                                                                <c:if test="${user.userId ne sessionScope.LOGIN_USER.userId}">

                                                                    <form action="${pageContext.request.contextPath}/users"
                                                                          method="post">

                                                                        <input type="hidden"
                                                                               name="action"
                                                                               value="toggleStatus">

                                                                        <input type="hidden"
                                                                               name="userId"
                                                                               value="${user.userId}">

                                                                        <button type="submit"
                                                                                class="btn-status-toggle ${user.status eq 'ACTIVE'
                                                                                                           ? 'btn-status-disable'
                                                                                                           : 'btn-status-enable'}">

                                                                            ${user.status eq 'ACTIVE'
                                                                              ? 'Disable'
                                                                              : 'Activate'}

                                                                        </button>

                                                                    </form>

                                                                </c:if>
                                                                <%-- delete --%>
                                                                <c:if test="${user.userId ne sessionScope.LOGIN_USER.userId}">
                                                                    <div class="status-delete-group">


                                                                        <form action="${pageContext.request.contextPath}/users"
                                                                              method="post"
                                                                              onsubmit="return confirm('Delete this user permanently?');">

                                                                            <input type="hidden"
                                                                                   name="action"
                                                                                   value="delete">

                                                                            <input type="hidden"
                                                                                   name="userId"
                                                                                   value="${user.userId}">

                                                                            <button type="submit"
                                                                                    class="btn-delete">
                                                                                Delete
                                                                            </button>

                                                                        </form>
                                                                    </div>
                                                                </c:if>

                                                            </div>

                                                        </td>

                                                    </c:if>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise><tr><td colspan="${sessionScope.LOGIN_USER.role eq 'ADMIN' ? 8 : 7}" style="text-align:center;padding:38px;">No users found.</td></tr></c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>

                        <div class="mobile-user-card-list mobile-only">
                            <c:choose><c:when test="${not empty users}"><c:forEach var="user" items="${users}">
                                        <article class="mobile-user-card ${user.status eq 'INACTIVE' ? 'is-inactive' : ''}">
                                            <div class="m-card-top-row"><div class="m-id-username"><span class="id-pill"><c:out value="${user.userId}"/></span><span class="username-tag"><c:out value="${user.username}"/></span></div><span class="status-badge ${user.status eq 'ACTIVE' ? 'status-active' : 'status-inactive'}"><c:out value="${user.status}"/></span></div>
                                            <h3 class="m-user-title"><c:out value="${user.fullName}"/></h3>
                                            <div class="m-user-meta-grid">
                                                <div class="m-meta-tile"><span class="m-label">Role</span><span class="m-val"><c:out value="${user.role}"/></span></div>
                                                <div class="m-meta-tile"><span class="m-label">Created At</span><span class="m-val"><fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy"/></span></div>
                                                <div class="m-meta-tile full-span"><span class="m-label">Assigned Warehouses</span><div class="warehouse-tag-cluster"><c:set var="mobileWarehouses" value="${userWarehouseMap[user.userId]}"/><c:choose><c:when test="${not empty mobileWarehouses}"><c:forEach var="warehouse" items="${mobileWarehouses}"><span class="warehouse-tag"><c:out value="${warehouse.warehouseCode}"/> - <c:out value="${warehouse.warehouseName}"/></span></c:forEach></c:when><c:otherwise><span class="text-muted">No assignment</span></c:otherwise></c:choose></div></div>
                                                        </div>
                                            <c:if test="${sessionScope.LOGIN_USER.role eq 'ADMIN'}"><details class="m-actions-accordion"><summary>Manage User</summary><div class="m-actions-panel">
                                                        <form action="${pageContext.request.contextPath}/users" method="post" class="action-form-row"><input type="hidden" name="action" value="updateName"><input type="hidden" name="userId" value="${user.userId}"><input class="input-sm-action" type="text" name="fullName" value="${user.fullName}" required aria-label="Full name"><button class="btn-action-sm" type="submit">Update Name</button></form>
                                                        <form action="${pageContext.request.contextPath}/users" method="post" class="action-form-row"><input type="hidden" name="action" value="updateRole"><input type="hidden" name="userId" value="${user.userId}"><select class="select-sm-action" name="role" aria-label="Role"><option value="ADMIN" ${user.role eq 'ADMIN' ? 'selected' : ''}>ADMIN</option><option value="MANAGER" ${user.role eq 'MANAGER' ? 'selected' : ''}>MANAGER</option><option value="OPERATOR" ${user.role eq 'OPERATOR' ? 'selected' : ''}>OPERATOR</option></select><button class="btn-action-sm" type="submit">Update Role</button></form>
                                                        <c:if test="${user.role ne 'ADMIN'}"><form action="${pageContext.request.contextPath}/users" method="post" class="action-form-row"><input type="hidden" name="action" value="assignWarehouse"><input type="hidden" name="userId" value="${user.userId}"><select class="multi-select-sm" name="warehouseIds" multiple aria-label="Assign warehouses"><c:forEach var="warehouse" items="${warehouseList}"><option value="${warehouse.warehouseId}"><c:out value="${warehouse.warehouseCode}"/> - <c:out value="${warehouse.warehouseName}"/></option></c:forEach></select><button class="btn-action-sm" type="submit">Assign</button></form></c:if>
                                                        <c:if test="${user.userId ne sessionScope.LOGIN_USER.userId}"><form action="${pageContext.request.contextPath}/users" method="post"><input type="hidden" name="action" value="toggleStatus"><input type="hidden" name="userId" value="${user.userId}"><button class="btn-status-toggle ${user.status eq 'ACTIVE' ? 'btn-status-disable' : 'btn-status-enable'}" type="submit">${user.status eq 'ACTIVE' ? 'Disable' : 'Activate'}</button></form></c:if>
                                                            <c:if test="${user.userId ne sessionScope.LOGIN_USER.userId}">

                                                            <form action="${pageContext.request.contextPath}/users"
                                                                  method="post"
                                                                  onsubmit="return confirm('Delete this user permanently?');">

                                                                <input type="hidden"
                                                                       name="action"
                                                                       value="delete">

                                                                <input type="hidden"
                                                                       name="userId"
                                                                       value="${user.userId}">

                                                                <button type="submit"
                                                                        class="btn-delete w-100">
                                                                    Delete
                                                                </button>

                                                            </form>

                                                        </c:if>
                                                    </div></details></c:if>
                                            </article>
                                    </c:forEach></c:when><c:otherwise><div class="mobile-user-card"><p>No users found.</p></div></c:otherwise></c:choose>
                                </div>

                        <c:if test="${totalPages > 1}">
                            <div class="pagination-wrapper"><div class="pagination-info">Page <strong>${currentPage}</strong> of ${totalPages}</div><nav class="pagination-controls" aria-label="User list pages">
                                    <c:if test="${currentPage > 1}"><c:url var="prevUrl" value="/users"><c:param name="page" value="${currentPage - 1}"/><c:param name="keyword" value="${keyword}"/><c:param name="role" value="${selectedRole}"/><c:param name="status" value="${selectedStatus}"/><c:param name="sortBy" value="${sortBy}"/><c:param name="sortOrder" value="${sortOrder}"/></c:url><a class="page-link-btn" href="${prevUrl}">Previous</a></c:if>
                                    <c:forEach var="i" begin="1" end="${totalPages}"><c:url var="pageUrl" value="/users"><c:param name="page" value="${i}"/><c:param name="keyword" value="${keyword}"/><c:param name="role" value="${selectedRole}"/><c:param name="status" value="${selectedStatus}"/><c:param name="sortBy" value="${sortBy}"/><c:param name="sortOrder" value="${sortOrder}"/></c:url><a class="page-link-btn ${i eq currentPage ? 'active' : ''}" href="${pageUrl}">${i}</a></c:forEach>
                                    <c:if test="${currentPage < totalPages}"><c:url var="nextUrl" value="/users"><c:param name="page" value="${currentPage + 1}"/><c:param name="keyword" value="${keyword}"/><c:param name="role" value="${selectedRole}"/><c:param name="status" value="${selectedStatus}"/><c:param name="sortBy" value="${sortBy}"/><c:param name="sortOrder" value="${sortOrder}"/></c:url><a class="page-link-btn" href="${nextUrl}">Next</a></c:if>
                                        </nav></div>
                            </c:if>
                    </section>
                    <footer class="dashboard-footer"><span class="footer-system-status"><span class="pulse-dot"></span> Smart Agricultural Drying System</span><span class="footer-version">User Management</span></footer>
                </div>
            </main>
        </div>
        <script>
            function toggleAddUser() {
                const drawer = document.getElementById('addUserDrawer');
                const button = document.getElementById('addUserToggle');
                if (!drawer)
                    return;
                const opening = drawer.style.display === 'none' || drawer.style.display === '';
                drawer.style.display = opening ? 'block' : 'none';
                if (button)
                    button.setAttribute('aria-expanded', String(opening));
            }
        </script>
    </body>
</html>
