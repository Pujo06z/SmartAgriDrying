<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>History</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
</head>

<body>

<jsp:include page="/includes/sidebar.jsp"/>

<main class="main-content">

    <h1>History</h1>


    <h2>Batch History</h2>

    <table>

        <tr>
            <th>Batch</th>
            <th>Warehouse</th>
            <th>Status</th>
            <th>Start</th>
            <th>End</th>
        </tr>

        <c:forEach var="b"
                   items="${batchHistory}">

            <tr>
                <td>${b.batchId}</td>
                <td>${b.warehouseName}</td>
                <td>${b.status}</td>
                <td>${b.startTime}</td>
                <td>${b.endTime}</td>
            </tr>

        </c:forEach>

    </table>


    <h2>Sensor History</h2>

    <form method="get"
          action="${pageContext.request.contextPath}/history">

        <select name="deviceId">

            <option value="">
                All Devices
            </option>

            <c:forEach var="d"
                       items="${deviceList}">

                <option value="${d.deviceId}">
                    ${d.deviceCode}
                </option>

            </c:forEach>

        </select>

        <button type="submit">
            Filter
        </button>

    </form>

    <table>

        <tr>
            <th>Device</th>
            <th>Warehouse</th>
            <th>Temperature</th>
            <th>Humidity</th>
            <th>Rain</th>
            <th>Light</th>
            <th>Roof</th>
            <th>Recorded At</th>
        </tr>

        <c:forEach var="s"
                   items="${sensorHistory}">

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


    <h2>Event History</h2>

    <table>

        <tr>
            <th>Time</th>
            <th>Warehouse</th>
            <th>Device</th>
            <th>Event</th>
            <th>Description</th>
        </tr>

        <c:forEach var="e"
                   items="${eventHistory}">

            <tr>
                <td>${e.createdAt}</td>
                <td>${e.warehouseName}</td>
                <td>${e.deviceCode}</td>
                <td>${e.eventType}</td>
                <td>${e.description}</td>
            </tr>

        </c:forEach>

    </table>

</main>

</body>
</html>
