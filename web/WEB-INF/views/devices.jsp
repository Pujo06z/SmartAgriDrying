<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/includes/_top.jsp"><jsp:param name="title" value="Device Management"/><jsp:param name="sub" value="Quản lý thiết bị và gán vào warehouse"/><jsp:param name="active" value="devices"/></jsp:include>
<div class="row g-3 mb-3">
  <div class="col-md-3"><div class="stat" style="background:#dcfce7">Total<b>${devices.size()}</b></div></div>
  <div class="col-md-3"><div class="stat" style="background:#d1fae5">Online<b>${onlineCount}</b></div></div>
  <div class="col-md-3"><div class="stat" style="background:#fee2e2">Offline<b>${devices.size()-onlineCount}</b></div></div>
</div>
<div class="box"><div class="d-flex justify-content-between mb-2"><h5>Devices</h5>
  <button class="btn btn-g" onclick="openD('add','','','')">+ Add Device</button></div>
<table class="table align-middle"><tr><th>ID</th><th>Name</th><th>Warehouse</th><th>Connection</th><th>Last Seen</th><th>Action</th></tr>
<c:forEach var="d" items="${devices}"><tr><td>${d.id}</td><td>${d.name}</td>
<td><c:choose><c:when test="${empty d.warehouseId}">Unassigned</c:when><c:otherwise>${d.warehouseId} - ${d.warehouseName}</c:otherwise></c:choose></td>
<td><span class="tag ${d.online?'ok':'bad'}">${d.online?'Online':'Offline'}</span></td>
<td><fmt:formatDate value="${d.lastSeen}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
<td><button class="btn btn-sm btn-outline-success" onclick="openD('edit','${d.id}','${d.name}','${d.warehouseId}')">Edit / Assign</button></td></tr></c:forEach></table></div>
<div class="modal fade" id="dM"><div class="modal-dialog"><form method="post" class="modal-content p-3">
  <input type="hidden" name="action" id="da"><h5 id="dt">Device</h5>
  <input name="id" id="did" class="form-control mb-2" placeholder="Device ID (vd: ESP32-09)" required>
  <input name="name" id="dname" class="form-control mb-2" placeholder="Device name" required>
  <select name="warehouseId" id="dw" class="form-select mb-3"><option value="">-- Unassigned --</option>
  <c:forEach var="w" items="${warehouses}"><option value="${w.id}">${w.id} - ${w.name}</option></c:forEach></select>
  <button class="btn btn-g">Save device</button></form></div></div>
<script>function openD(a,i,n,w){const $=id=>document.getElementById(id);$('da').value=a;$('did').value=i;$('did').readOnly=a==='edit';
$('dname').value=n;$('dw').value=w;$('dt').textContent=a==='add'?'Add Device':'Edit Device';new bootstrap.Modal($('dM')).show();}</script>
<jsp:include page="/WEB-INF/views/includes/_bottom.jsp"/>
