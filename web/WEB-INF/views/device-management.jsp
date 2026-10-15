<%-- Device Management - Smart Agricultural Drying System --%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Device Management - Smart Agricultural Drying System</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/device-management.css">
    </head>
    <body>
        <div class="app-layout">
            <jsp:include page="/WEB-INF/views/includes/sidebar.jsp"/>
            <main class="main-content">
                <div class="content-container">
                    <header class="device-header-card">
                        <div class="header-meta">
                            <div class="header-badge-row">
                                <span class="role-pill">Device Administration</span>
                                <span class="system-pill"><span class="pulse-dot"></span> IoT Management</span>
                            </div>
                            <h1>Device Management</h1>
                            <p class="header-subtitle">Manage connected devices, warehouse assignments, and operational status.</p>
                        </div>
                        <button class="btn-add-device" type="button" onclick="toggleAddDevice()" aria-controls="addDeviceForm" aria-expanded="false" id="addDeviceToggle">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><path d="M12 5v14M5 12h14"/></svg>
                            Add Device
                        </button>
                    </header>

                    <c:if test="${not empty error}">
                        <div class="alert-banner alert-error" role="alert">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><circle cx="12" cy="12" r="10"/><path d="M12 7v6M12 17h.01"/></svg>
                            <c:out value="${error}"/>
                        </div>
                    </c:if>

                    <section class="device-metric-grid" aria-label="Device statistics">
                        <div class="metric-card card-total">
                            <div class="metric-icon-box">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" aria-hidden="true"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                            </div>
                            <div class="metric-data">
                                <span class="metric-label">Total Devices</span>
                                <strong class="metric-number">${totalDevices}</strong>
                                <span class="metric-sub">Registered IoT devices</span>
                            </div>
                        </div>
                        <div class="metric-card card-online">
                            <div class="metric-icon-box">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" aria-hidden="true"><path d="M5 12a7 7 0 0 1 14 0"/><path d="M8 12a4 4 0 0 1 8 0"/><circle cx="12" cy="16" r="2"/></svg>
                            </div>
                            <div class="metric-data">
                                <span class="metric-label">Online Devices</span>
                                <strong class="metric-number text-online">${onlineDevices}</strong>
                                <span class="metric-sub">Currently connected</span>
                            </div>
                        </div>
                        <div class="metric-card card-offline">
                            <div class="metric-icon-box">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" aria-hidden="true"><path d="M3 3l18 18M5 12a7 7 0 0 1 3-5.7M12 5a7 7 0 0 1 7 7M9 11a4 4 0 0 1 6 0"/><circle cx="12" cy="16" r="2"/></svg>
                            </div>
                            <div class="metric-data">
                                <span class="metric-label">Offline Devices</span>
                                <strong class="metric-number text-offline">${totalDevices - onlineDevices}</strong>
                                <span class="metric-sub">Not currently connected</span>
                            </div>
                        </div>
                    </section>

                    <section id="addDeviceForm" class="add-device-drawer" style="display:none" aria-label="Add device form">
                        <div class="drawer-header">
                            <div class="drawer-title-wrap">
                                <div class="drawer-icon-box">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><path d="M12 5v14M5 12h14"/></svg>
                                </div>
                                <div><h3>Add New Device</h3><p>Register an IoT device and assign it to a warehouse.</p></div>
                            </div>
                            <button type="button" class="btn-drawer-close" onclick="toggleAddDevice()" aria-label="Close add device form">✕</button>
                        </div>
                        <form action="${pageContext.request.contextPath}/devices" method="post">
                            <input type="hidden" name="action" value="add">
                            <div class="form-grid">
                                <div class="form-group">
                                    <label for="newDeviceId">Device ID <span class="required">*</span></label>
                                    <div class="input-with-icon"><span class="input-icon">#</span><input id="newDeviceId" name="deviceId" type="text" placeholder="D001" required></div>
                                </div>
                                <div class="form-group">
                                    <label for="newDeviceCode">Device Code <span class="required">*</span></label>
                                    <div class="input-with-icon"><span class="input-icon">⌘</span><input id="newDeviceCode" name="deviceCode" type="text" placeholder="ESP8266-01" required></div>
                                </div>
                                <div class="form-group">
                                    <label for="newDeviceName">Device Name <span class="required">*</span></label>
                                    <div class="input-with-icon"><span class="input-icon">▣</span><input id="newDeviceName" name="deviceName" type="text" placeholder="Main Roof Controller" required></div>
                                </div>
                                <div class="form-group">
                                    <label for="newWarehouseId">Warehouse <span class="required">*</span></label>
                                    <div class="select-wrapper">
                                        <select id="newWarehouseId" name="warehouseId" required>
                                            <option value="">Select Warehouse</option>
                                            <c:forEach var="warehouse" items="${warehouseList}">
                                                <option value="${warehouse.warehouseId}"><c:out value="${warehouse.warehouseId}"/></option>
                                            </c:forEach>
                                        </select><span class="select-chevron">▼</span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-actions-row">
                                <span class="form-note">Assign each device to its designated warehouse.</span>
                                <div class="btn-group">
                                    <button type="button" class="btn-secondary" onclick="toggleAddDevice()">Cancel</button>
                                    <button type="submit" class="btn-primary">Add Device</button>
                                </div>
                            </div>
                        </form>
                    </section>

                    <section class="device-section-card">
                        <div class="section-title-bar">
                            <div class="section-heading-cluster">
                                <div class="section-icon-box">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" aria-hidden="true"><rect x="3" y="4" width="18" height="16" rx="2"/><path d="M7 9h10M7 13h10"/></svg>
                                </div>
                                <div><h2>Device Registry</h2><p>Monitor and manage all registered devices.</p></div>
                            </div>
                        </div>

                        <div class="table-responsive-wrapper desktop-only">
                            <table class="smart-device-table">
                                <thead><tr>
                                        <th>Device ID</th><th>Device Code</th><th>Device Name</th><th>Warehouse</th>
                                        <th>Mode</th><th>Roof Status</th><th>Connection</th><th>Last Seen</th><th>Status</th><th class="text-right">Actions</th>
                                    </tr></thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty deviceList}">
                                            <c:forEach var="device" items="${deviceList}">
                                                <tr class="device-row">
                                                    <td><span class="id-badge"><c:out value="${device.deviceId}"/></span></td>
                                                    <td><span class="code-pill"><c:out value="${device.deviceCode}"/></span></td>
                                                    <td><strong><c:out value="${device.deviceName}"/></strong></td>
                                                    <td><span class="warehouse-tag"><c:out value="${device.warehouseId}"/></span></td>
                                                    <td><c:choose><c:when test="${device.mode eq 'AUTO'}"><span class="mode-pill mode-auto"><span class="mode-dot"></span>AUTO</span></c:when><c:otherwise><span class="mode-pill mode-manual"><span class="mode-dot"></span>MANUAL</span></c:otherwise></c:choose></td>
                                                    <td><c:choose><c:when test="${device.roofStatus eq 'OPEN'}"><span class="roof-pill roof-open">OPEN</span></c:when><c:otherwise><span class="roof-pill roof-closed">CLOSED</span></c:otherwise></c:choose></td>
                                                    <td><c:choose><c:when test="${deviceOnlineMap[device.deviceId]}"><span class="conn-pill conn-online"><span class="pulse-indicator-green"></span>ONLINE</span></c:when><c:otherwise><span class="conn-pill conn-offline"><span class="pulse-indicator-red"></span>OFFLINE</span></c:otherwise></c:choose></td>
                                                    <td class="time-cell"><c:choose><c:when test="${device.lastSeen ne null}"><fmt:formatDate value="${device.lastSeen}" pattern="dd/MM/yyyy HH:mm:ss"/></c:when><c:otherwise><span class="text-never">Never</span></c:otherwise></c:choose></td>
                                                    <td><c:choose><c:when test="${device.status eq 'ACTIVE'}"><span class="state-badge state-active">ACTIVE</span></c:when><c:otherwise><span class="state-badge state-inactive">INACTIVE</span></c:otherwise></c:choose></td>
                                                            <td class="text-right">
                                                                <div class="action-btn-cluster">

                                                                    <button type="button"
                                                                            class="btn-action-edit"
                                                                            onclick="toggleEdit(this)"
                                                                                data-target="edit-${device.deviceId}">
                                                                Edit
                                                            </button>

                                                            <form class="inline-form"
                                                                  action="${pageContext.request.contextPath}/devices"
                                                                  method="post">

                                                                <input type="hidden"
                                                                       name="action"
                                                                       value="toggleStatus">

                                                                <input type="hidden"
                                                                       name="deviceId"
                                                                       value="${device.deviceId}">

                                                                <c:choose>

                                                                    <c:when test="${device.status eq 'ACTIVE'}">
                                                                        <button type="submit"
                                                                                class="btn-action-status btn-status-disable">
                                                                            Disable
                                                                        </button>
                                                                    </c:when>

                                                                    <c:otherwise>
                                                                        <button type="submit"
                                                                                class="btn-action-status btn-status-enable">
                                                                            Activate
                                                                        </button>
                                                                    </c:otherwise>

                                                                </c:choose>

                                                            </form>


                                                            <form class="inline-form"
                                                                  action="${pageContext.request.contextPath}/devices"
                                                                  method="post"
                                                                  onsubmit="return confirm('Delete this device permanently?');">

                                                                <input type="hidden"
                                                                       name="action"
                                                                       value="delete">

                                                                <input type="hidden"
                                                                       name="deviceId"
                                                                       value="${device.deviceId}">

                                                                <button type="submit"
                                                                        class="btn-delete">
                                                                    Delete
                                                                </button>

                                                            </form>

                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr id="edit-${device.deviceId}" class="edit-device-row" style="display:none">
                                                    <td colspan="10">
                                                        <div class="edit-drawer-box">
                                                            <div class="edit-drawer-head"><div class="edit-title"><strong>Edit Device: <c:out value="${device.deviceId}"/></strong></div><button type="button" class="btn-close-sub" onclick="toggleEdit(this)" data-target="edit-${device.deviceId}" aria-label="Close edit form">✕</button></div>
                                                            <form action="${pageContext.request.contextPath}/devices" method="post">
                                                                <input type="hidden" name="action" value="update">
                                                                <input type="hidden" name="deviceId" value="${device.deviceId}">
                                                                <div class="form-grid">
                                                                    <div class="form-group"><label>Device ID</label><input class="input-disabled" type="text" value="${device.deviceId}" disabled></div>
                                                                    <div class="form-group"><label>Device Code <span class="required">*</span></label><input type="text" name="deviceCode" value="${device.deviceCode}" required></div>
                                                                    <div class="form-group"><label>Device Name <span class="required">*</span></label><input type="text" name="deviceName" value="${device.deviceName}" required></div>
                                                                    <div class="form-group"><label>Warehouse <span class="required">*</span></label><div class="select-wrapper"><select name="warehouseId" required><c:forEach var="warehouse" items="${warehouseList}"><option value="${warehouse.warehouseId}" ${warehouse.warehouseId eq device.warehouseId ? 'selected="selected"' : ''}><c:out value="${warehouse.warehouseId}"/></option></c:forEach></select><span class="select-chevron">▼</span></div></div>
                                                                    </div>
                                                                    <div class="form-actions-row"><span class="form-note">Changes will be saved to this device.</span><div class="btn-group"><button class="btn-secondary" type="button" onclick="toggleEdit(this)" data-target="edit-${device.deviceId}">Cancel</button><button class="btn-primary" type="submit">Save Changes</button></div></div>
                                                            </form>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise><tr><td colspan="10" class="empty-state-cell"><div class="empty-state-box"><div class="empty-icon">📡</div><h4>No devices found</h4><p>Add an IoT device to get started.</p></div></td></tr></c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>

                        <div class="mobile-card-list mobile-only">
                            <c:choose>
                                <c:when test="${not empty deviceList}">
                                    <c:forEach var="device" items="${deviceList}">
                                        <article class="mobile-device-card ${deviceOnlineMap[device.deviceId] ? 'is-online' : 'is-offline'}">
                                            <div class="mobile-card-top">
                                                <div class="m-card-id-row"><span class="id-badge"><c:out value="${device.deviceId}"/></span><span class="code-pill"><c:out value="${device.deviceCode}"/></span></div>
                                                <c:choose><c:when test="${deviceOnlineMap[device.deviceId]}"><span class="conn-pill conn-online">ONLINE</span></c:when><c:otherwise><span class="conn-pill conn-offline">OFFLINE</span></c:otherwise></c:choose>
                                                    </div>
                                                        <h3 class="m-device-name"><c:out value="${device.deviceName}"/></h3>
                                            <div class="m-meta-grid">
                                                <div class="m-meta-item"><span class="m-meta-label">Warehouse</span><span class="m-meta-val"><c:out value="${device.warehouseId}"/></span></div>
                                                <div class="m-meta-item"><span class="m-meta-label">Mode</span><span class="m-meta-val"><c:out value="${device.mode}"/></span></div>
                                                <div class="m-meta-item"><span class="m-meta-label">Roof Status</span><span class="m-meta-val"><c:out value="${device.roofStatus}"/></span></div>
                                                <div class="m-meta-item"><span class="m-meta-label">Device Status</span><span class="m-meta-val"><c:out value="${device.status}"/></span></div>
                                                <div class="m-meta-item full-span"><span class="m-meta-label">Last Seen</span><span class="m-meta-val"><c:choose><c:when test="${device.lastSeen ne null}"><fmt:formatDate value="${device.lastSeen}" pattern="dd/MM/yyyy HH:mm:ss"/></c:when><c:otherwise>Never</c:otherwise></c:choose></span></div>
                                                    </div>
                                                    <div class="m-actions-toolbar">

                                                        <button type="button"
                                                                class="btn-action-edit m-btn-flex"
                                                                onclick="toggleEdit(this)"
                                                                    data-target="mobile-edit-${device.deviceId}">
                                                    Edit
                                                </button>

                                                <form class="m-btn-flex"
                                                      action="${pageContext.request.contextPath}/devices"
                                                      method="post">

                                                    <input type="hidden"
                                                           name="action"
                                                           value="toggleStatus">

                                                    <input type="hidden"
                                                           name="deviceId"
                                                           value="${device.deviceId}">

                                                    <c:choose>

                                                        <c:when test="${device.status eq 'ACTIVE'}">
                                                            <button class="btn-action-status btn-status-disable w-100"
                                                                    type="submit">
                                                                Disable
                                                            </button>
                                                        </c:when>

                                                        <c:otherwise>
                                                            <button class="btn-action-status btn-status-enable w-100"
                                                                    type="submit">
                                                                Activate
                                                            </button>
                                                        </c:otherwise>

                                                    </c:choose>

                                                </form>

                                                <form class="m-btn-flex"
                                                      action="${pageContext.request.contextPath}/devices"
                                                      method="post"
                                                      onsubmit="return confirm('Delete this device permanently?');">

                                                    <input type="hidden"
                                                           name="action"
                                                           value="delete">

                                                    <input type="hidden"
                                                           name="deviceId"
                                                           value="${device.deviceId}">

                                                    <button type="submit"
                                                            class="btn-delete w-100">
                                                        Delete
                                                    </button>

                                                </form>

                                            </div>
                                            <div id="mobile-edit-${device.deviceId}" class="edit-drawer-box" style="display:none">
                                                <div class="edit-drawer-head"><strong>Edit Device</strong><button type="button" class="btn-close-sub" onclick="toggleEdit(this)" data-target="mobile-edit-${device.deviceId}">✕</button></div>
                                                <form action="${pageContext.request.contextPath}/devices" method="post">
                                                    <input type="hidden" name="action" value="update"><input type="hidden" name="deviceId" value="${device.deviceId}">
                                                    <div class="form-grid">
                                                        <div class="form-group"><label>Device ID</label><input class="input-disabled" type="text" value="${device.deviceId}" disabled></div>
                                                        <div class="form-group"><label>Device Code</label><input type="text" name="deviceCode" value="${device.deviceCode}" required></div>
                                                        <div class="form-group"><label>Device Name</label><input type="text" name="deviceName" value="${device.deviceName}" required></div>
                                                        <div class="form-group"><label>Warehouse</label><div class="select-wrapper"><select name="warehouseId" required><c:forEach var="warehouse" items="${warehouseList}"><option value="${warehouse.warehouseId}" ${warehouse.warehouseId eq device.warehouseId ? 'selected="selected"' : ''}><c:out value="${warehouse.warehouseId}"/></option></c:forEach></select><span class="select-chevron">▼</span></div></div>
                                                        </div>
                                                        <div class="form-actions-row"><div class="btn-group"><button type="button" class="btn-secondary" onclick="toggleEdit(this)" data-target="mobile-edit-${device.deviceId}">Cancel</button><button type="submit" class="btn-primary">Save Changes</button></div></div>
                                                </form>
                                            </div>
                                        </article>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise><div class="empty-state-box"><div class="empty-icon">📡</div><h4>No devices found</h4><p>Add an IoT device to get started.</p></div></c:otherwise>
                            </c:choose>
                        </div>
                    </section>
                    <footer class="dashboard-footer">
                        <div class="footer-system-status"><span class="pulse-dot"></span> Smart Agricultural Drying System</div>
                        <span class="footer-version">Device Management</span>
                    </footer>
                </div>
            </main>
        </div>
        <script>
            function toggleAddDevice() {
                const panel = document.getElementById('addDeviceForm');
                const trigger = document.getElementById('addDeviceToggle');
                const shouldShow = getComputedStyle(panel).display === 'none';
                panel.style.display = shouldShow ? 'block' : 'none';
                trigger.setAttribute('aria-expanded', String(shouldShow));
            }
            function toggleEdit(button) {
                const panel = document.getElementById(button.getAttribute('data-target'));
                if (!panel)
                    return;
                const shouldShow = getComputedStyle(panel).display === 'none';
                panel.style.display = shouldShow ? (panel.tagName === 'TR' ? 'table-row' : 'block') : 'none';
            }
        </script>
    </body>
</html>
