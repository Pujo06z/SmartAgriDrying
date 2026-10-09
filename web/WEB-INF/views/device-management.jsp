<%-- 
    Document   : device
    Created on : Oct 4, 2026, 12:45:54 PM
    Author     : ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ taglib prefix="c"
           uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="fmt"
           uri="http://java.sun.com/jsp/jstl/fmt" %>


<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>Device Management</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/common.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/device-management.css">

</head>


<body>


<div class="app-layout">


    <%-- ===================================================== --%>
    <%-- SIDEBAR --%>
    <%-- ===================================================== --%>

    <jsp:include page="/WEB-INF/views/includes/sidebar.jsp"/>


    <%-- ===================================================== --%>
    <%-- MAIN CONTENT --%>
    <%-- ===================================================== --%>

    <main class="main-content">


        <%-- ================================================= --%>
        <%-- HEADER --%>
        <%-- ================================================= --%>

        <header class="device-page-header">

            <div>

                <h1>
                    Device Management
                </h1>

                <p>
                    Manage devices and their warehouse assignments.
                </p>

            </div>

        </header>



        <%-- ================================================= --%>
        <%-- ERROR --%>
        <%-- ================================================= --%>

        <c:if test="${not empty error}">

            <div class="alert-error">

                ${error}

            </div>

        </c:if>



        <%-- ================================================= --%>
        <%-- DEVICE MANAGEMENT SECTION --%>
        <%-- ================================================= --%>

        <section class="device-section">


            <%-- ============================================= --%>
            <%-- TITLE + ADD DEVICE --%>
            <%-- ============================================= --%>

            <div class="section-header">


                <div>

                    <h2>
                        Device Management
                    </h2>

                    <p>
                        Manage registered IoT devices.
                    </p>

                </div>


                <button type="button"
                        class="btn-add"
                        onclick="toggleAddDevice()">

                    + Add Device

                </button>


            </div>



            <%-- ============================================= --%>
            <%-- STATISTICS --%>
            <%-- ============================================= --%>

            <div class="device-summary">


                <%-- TOTAL --%>

                <div class="summary-card summary-total">

                    <div class="summary-icon">
                        ⚙
                    </div>

                    <div class="summary-info">

                        <span>
                            Total Devices
                        </span>

                        <strong>
                            ${totalDevices}
                        </strong>

                        <small>
                            All registered devices
                        </small>

                    </div>

                </div>



                <%-- ONLINE --%>

                <div class="summary-card summary-online">

                    <div class="summary-icon">
                        ◉
                    </div>

                    <div class="summary-info">

                        <span>
                            Online Devices
                        </span>

                        <strong>
                            ${onlineDevices}
                        </strong>

                        <small>
                            Devices currently online
                        </small>

                    </div>

                </div>



                <%-- OFFLINE --%>

                <div class="summary-card summary-offline">

                    <div class="summary-icon">
                        ◉
                    </div>

                    <div class="summary-info">

                        <span>
                            Offline Devices
                        </span>

                        <strong>
                            ${totalDevices - onlineDevices}
                        </strong>

                        <small>
                            Devices currently offline
                        </small>

                    </div>

                </div>


            </div>



            <%-- ================================================= --%>
            <%-- ADD DEVICE FORM --%>
            <%-- ================================================= --%>

            <div id="addDeviceForm"
                 class="add-device-box"
                 style="display:none;">


                <h3>
                    Add New Device
                </h3>


                <form action="${pageContext.request.contextPath}/devices"
                      method="post"
                      class="device-form">


                    <input type="hidden"
                           name="action"
                           value="add">


                    <div class="form-grid">


                        <%-- DEVICE ID --%>

                        <div class="form-group">

                            <label>
                                Device ID
                            </label>

                            <input type="text"
                                   name="deviceId"
                                   placeholder="D001"
                                   required>

                        </div>



                        <%-- DEVICE CODE --%>

                        <div class="form-group">

                            <label>
                                Device Code
                            </label>

                            <input type="text"
                                   name="deviceCode"
                                   placeholder="ESP8266-01"
                                   required>

                        </div>



                        <%-- DEVICE NAME --%>

                        <div class="form-group">

                            <label>
                                Device Name
                            </label>

                            <input type="text"
                                   name="deviceName"
                                   placeholder="Main Roof Controller"
                                   required>

                        </div>



                        <%-- WAREHOUSE ID --%>

                        <div class="form-group">

                            <label>
                                Warehouse ID
                            </label>

                            <select name="warehouseId"
                                    required>

                                <option value="">
                                    Select Warehouse
                                </option>


                                <c:forEach var="warehouse"
                                           items="${warehouseList}">

                                    <option value="${warehouse.warehouseId}">

                                        ${warehouse.warehouseId}

                                    </option>

                                </c:forEach>

                            </select>

                        </div>


                    </div>


                    <div class="form-actions">


                        <button type="button"
                                class="btn-cancel"
                                onclick="toggleAddDevice()">

                            Cancel

                        </button>


                        <button type="submit"
                                class="btn-primary">

                            Add Device

                        </button>


                    </div>


                </form>


            </div>



            <%-- ================================================= --%>
            <%-- DEVICE TABLE --%>
            <%-- ================================================= --%>

            <div class="table-wrapper">


                <table class="device-table">


                    <thead>

                    <tr>

                        <th>
                            Device ID
                        </th>

                        <th>
                            Device Code
                        </th>

                        <th>
                            Device Name
                        </th>

                        <th>
                            Warehouse ID
                        </th>

                        <th>
                            Mode
                        </th>

                        <th>
                            Roof Status
                        </th>

                        <th>
                            Connection
                        </th>

                        <th>
                            Last Seen
                        </th>

                        <th>
                            Status
                        </th>

                        <th>
                            Action
                        </th>

                    </tr>

                    </thead>



                    <tbody>


                    <c:choose>


                        <%-- ===================================== --%>
                        <%-- HAVE DEVICES --%>
                        <%-- ===================================== --%>

                        <c:when test="${not empty deviceList}">


                            <c:forEach var="device"
                                       items="${deviceList}">


                                <%-- ================================= --%>
                                <%-- DEVICE ROW --%>
                                <%-- ================================= --%>

                                <tr>


                                    <%-- DEVICE ID --%>

                                    <td class="device-id">

                                        ${device.deviceId}

                                    </td>



                                    <%-- CODE --%>

                                    <td>

                                        ${device.deviceCode}

                                    </td>



                                    <%-- NAME --%>

                                    <td class="device-name">

                                        ${device.deviceName}

                                    </td>



                                    <%-- WAREHOUSE ID --%>

                                    <td>

                                        ${device.warehouseId}

                                    </td>



                                    <%-- MODE --%>

                                    <td>


                                        <c:choose>


                                            <c:when test="${device.mode eq 'AUTO'}">

                                                <span class="mode-auto">

                                                    AUTO

                                                </span>

                                            </c:when>


                                            <c:otherwise>

                                                <span class="mode-manual">

                                                    MANUAL

                                                </span>

                                            </c:otherwise>


                                        </c:choose>


                                    </td>



                                    <%-- ROOF STATUS --%>

                                    <td>


                                        <c:choose>


                                            <c:when test="${device.roofStatus eq 'OPEN'}">

                                                <span class="roof-open">

                                                    OPEN

                                                </span>

                                            </c:when>


                                            <c:otherwise>

                                                <span class="roof-closed">

                                                    CLOSED

                                                </span>

                                            </c:otherwise>


                                        </c:choose>


                                    </td>



                                    <%-- CONNECTION STATUS --%>

                                    <td>


                                        <c:choose>


                                            <c:when test="${deviceOnlineMap[device.deviceId]}">

                                                <span class="connection-online">

                                                    ● ONLINE

                                                </span>

                                            </c:when>


                                            <c:otherwise>

                                                <span class="connection-offline">

                                                    ● OFFLINE

                                                </span>

                                            </c:otherwise>


                                        </c:choose>


                                    </td>



                                    <%-- LAST SEEN --%>

                                    <td>


                                        <c:choose>


                                            <c:when test="${device.lastSeen ne null}">

                                                <fmt:formatDate
                                                        value="${device.lastSeen}"
                                                        pattern="dd/MM/yyyy HH:mm:ss"/>

                                            </c:when>


                                            <c:otherwise>

                                                <span class="text-muted">

                                                    Never

                                                </span>

                                            </c:otherwise>


                                        </c:choose>


                                    </td>



                                    <%-- DATABASE STATUS --%>

                                    <td>


                                        <c:choose>


                                            <c:when test="${device.status eq 'ACTIVE'}">

                                                <span class="status-active">

                                                    ACTIVE

                                                </span>

                                            </c:when>


                                            <c:otherwise>

                                                <span class="status-inactive">

                                                    INACTIVE

                                                </span>

                                            </c:otherwise>


                                        </c:choose>


                                    </td>



                                    <%-- ACTION --%>

                                    <td class="action-cell">


                                        <%-- EDIT --%>

                                        <button type="button"
                                                class="btn-edit"
                                                onclick="toggleEdit('${device.deviceId}')">

                                            Edit

                                        </button>



                                        <%-- ACTIVE / INACTIVE --%>

                                        <form action="${pageContext.request.contextPath}/devices"
                                              method="post"
                                              class="inline-form">


                                            <input type="hidden"
                                                   name="action"
                                                   value="toggleStatus">


                                            <input type="hidden"
                                                   name="deviceId"
                                                   value="${device.deviceId}">


                                            <button type="submit"
                                                    class="btn-status-action">


                                                <c:choose>


                                                    <c:when test="${device.status eq 'ACTIVE'}">

                                                        Disable

                                                    </c:when>


                                                    <c:otherwise>

                                                        Activate

                                                    </c:otherwise>


                                                </c:choose>


                                            </button>


                                        </form>


                                    </td>


                                </tr>



                                <%-- ================================= --%>
                                <%-- EDIT DEVICE ROW --%>
                                <%-- ================================= --%>

                                <tr id="edit-${device.deviceId}"
                                    class="edit-row"
                                    style="display:none;">


                                    <td colspan="10">


                                        <form action="${pageContext.request.contextPath}/devices"
                                              method="post"
                                              class="edit-form">


                                            <input type="hidden"
                                                   name="action"
                                                   value="update">


                                            <input type="hidden"
                                                   name="deviceId"
                                                   value="${device.deviceId}">


                                            <div class="edit-grid">


                                                <%-- DEVICE ID --%>

                                                <div class="form-group">

                                                    <label>
                                                        Device ID
                                                    </label>

                                                    <input type="text"
                                                           value="${device.deviceId}"
                                                           disabled>

                                                </div>



                                                <%-- DEVICE CODE --%>

                                                <div class="form-group">

                                                    <label>
                                                        Device Code
                                                    </label>

                                                    <input type="text"
                                                           name="deviceCode"
                                                           value="${device.deviceCode}"
                                                           required>

                                                </div>



                                                <%-- DEVICE NAME --%>

                                                <div class="form-group">

                                                    <label>
                                                        Device Name
                                                    </label>

                                                    <input type="text"
                                                           name="deviceName"
                                                           value="${device.deviceName}"
                                                           required>

                                                </div>



                                                <%-- WAREHOUSE --%>

                                                <div class="form-group">

                                                    <label>
                                                        Warehouse ID
                                                    </label>


                                                    <select name="warehouseId"
                                                            required>


                                                        <c:forEach var="warehouse"
                                                                   items="${warehouseList}">


                                                            <c:choose>


                                                                <c:when test="${warehouse.warehouseId eq device.warehouseId}">

                                                                    <option value="${warehouse.warehouseId}"
                                                                            selected>

                                                                        ${warehouse.warehouseId}

                                                                    </option>

                                                                </c:when>


                                                                <c:otherwise>

                                                                    <option value="${warehouse.warehouseId}">

                                                                        ${warehouse.warehouseId}

                                                                    </option>

                                                                </c:otherwise>


                                                            </c:choose>


                                                        </c:forEach>


                                                    </select>


                                                </div>


                                            </div>



                                            <div class="form-actions">


                                                <button type="button"
                                                        class="btn-cancel"
                                                        onclick="toggleEdit('${device.deviceId}')">

                                                    Cancel

                                                </button>


                                                <button type="submit"
                                                        class="btn-primary">

                                                    Save Changes

                                                </button>


                                            </div>


                                        </form>


                                    </td>


                                </tr>


                            </c:forEach>


                        </c:when>



                        <%-- ===================================== --%>
                        <%-- NO DEVICE --%>
                        <%-- ===================================== --%>

                        <c:otherwise>


                            <tr>

                                <td colspan="10"
                                    class="empty-row">

                                    No devices found.

                                </td>

                            </tr>


                        </c:otherwise>


                    </c:choose>


                    </tbody>


                </table>


            </div>


        </section>


    </main>


</div>



<%-- ========================================================= --%>
<%-- JAVASCRIPT --%>
<%-- ========================================================= --%>

<script>

    function toggleAddDevice() {

        const form =
                document.getElementById(
                        "addDeviceForm"
                );


        if (form.style.display === "none"
                || form.style.display === "") {

            form.style.display = "block";

        } else {

            form.style.display = "none";
        }
    }


    function toggleEdit(deviceId) {

        const row =
                document.getElementById(
                        "edit-" + deviceId
                );


        if (row.style.display === "none"
                || row.style.display === "") {

            row.style.display = "table-row";

        } else {

            row.style.display = "none";
        }
    }

</script>


</body>

</html>