<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manager Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/common.css">
</head>

<body>

<jsp:include page="/includes/sidebar.jsp"/>

<main class="main-content">

    <h1>Manager Dashboard</h1>

    <div class="cards">

        <div class="card">
            <h3>Assigned Warehouses</h3>
            <p id="assignedWarehouses">
                ${assignedWarehousesCount}
            </p>
        </div>

        <div class="card">
            <h3>Online Devices</h3>
            <p id="onlineDevices">
                ${onlineDevices}
            </p>
        </div>

        <div class="card">
            <h3>Active Batches</h3>
            <p id="activeBatches">
                ${activeBatches}
            </p>
        </div>

    </div>

    <h2>Warehouses</h2>

    <table>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Location</th>
            <th>Devices</th>
            <th>Online</th>
            <th>Active Batches</th>
        </tr>

        <c:forEach var="w"
                   items="${warehouseList}">

            <tr>

                <td>${w.warehouseId}</td>
                <td>${w.name}</td>
                <td>${w.location}</td>
                <td>${w.deviceCount}</td>
                <td>${w.onlineDeviceCount}</td>
                <td>${w.activeBatchCount}</td>

            </tr>

        </c:forEach>

    </table>


    <h2>Device Control</h2>

    <table>

        <tr>
            <th>Device</th>
            <th>Warehouse</th>
            <th>Mode</th>
            <th>Roof</th>
            <th>Connection</th>
            <th>Control</th>
        </tr>

        <c:forEach var="d"
                   items="${deviceList}">

            <tr>

                <td>
                    ${d.deviceCode}
                    <br>
                    ${d.deviceName}
                </td>

                <td>${d.warehouseName}</td>

                <td>${d.mode}</td>

                <td>${d.roofStatus}</td>

                <td>${d.connectionStatus}</td>

                <td>

                    <form action="${pageContext.request.contextPath}/control"
                          method="post">

                        <input type="hidden"
                               name="deviceId"
                               value="${d.deviceId}">

                        <button name="action"
                                value="setAuto">
                            AUTO
                        </button>

                        <button name="action"
                                value="setManual">
                            MANUAL
                        </button>

                        <button name="action"
                                value="open">
                            OPEN
                        </button>

                        <button name="action"
                                value="close">
                            CLOSE
                        </button>

                    </form>

                </td>

            </tr>

        </c:forEach>

    </table>


    <h2>Recent Sensor Readings</h2>

    <table>

        <tr>
            <th>Device</th>
            <th>Warehouse</th>
            <th>Temperature</th>
            <th>Humidity</th>
            <th>Rain</th>
            <th>Light</th>
            <th>Roof</th>
            <th>Time</th>
        </tr>

        <c:forEach var="s"
                   items="${latestSensors}">

            <tr>

                <td>${s.deviceCode}</td>
                <td>${s.warehouseName}</td>
                <td>${s.temperature}</td>
                <td>${s.humidity}</td>
                <td>${s.rainStatus}</td>
                <td>${s.lightStatus}</td>
                <td>${s.roofStatus}</td>
                <td>${s.recordedAt}</td>

            </tr>

        </c:forEach>

    </table>

</main>


<script>
    const contextPath = '${pageContext.request.contextPath}';
</script>

<script src="${pageContext.request.contextPath}/js/dashboard.js"></script>

</body>
</html>
