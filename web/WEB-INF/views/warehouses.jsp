<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/includes/_top.jsp"><jsp:param name="title" value="Warehouse Management"/><jsp:param name="sub" value="Quản lý kho/khu phơi"/><jsp:param name="active" value="warehouses"/></jsp:include>
<div class="row g-3 mb-3">
  <div class="col-md-3"><div class="stat" style="background:#dcfce7">Total<b>${warehouses.size()}</b></div></div>
  <div class="col-md-3"><div class="stat" style="background:#d1fae5">Active<b>${activeCount}</b></div></div>
  <div class="col-md-3"><div class="stat" style="background:#fee2e2">Inactive<b>${warehouses.size()-activeCount}</b></div></div>
</div>
<div class="box"><div class="d-flex justify-content-between mb-2"><h5>Warehouses</h5>
  <button class="btn btn-g" onclick="openW('add','','','')">+ Add Warehouse</button></div>
<table class="table align-middle"><tr><th>ID</th><th>Name</th><th>Location</th><th>Manager</th><th>Status</th><th>Updated At</th><th>Action</th></tr>
<c:forEach var="w" items="${warehouses}"><tr><td>${w.id}</td><td>${w.name}</td><td>${w.location}</td>
<td><c:out value="${empty w.manager ? 'Not Assigned' : w.manager}"/></td>
<td><span class="tag ${w.active?'ok':'off'}">${w.active?'Active':'Inactive'}</span></td>
<td><fmt:formatDate value="${w.updatedAt}" pattern="yyyy-MM-dd HH:mm"/></td>
<td><button class="btn btn-sm btn-outline-success" onclick="openW('edit','${w.id}','${w.name}','${w.location}')">Edit</button>
<form method="post" class="d-inline"><input type="hidden" name="action" value="toggle"><input type="hidden" name="id" value="${w.id}">
<button class="btn btn-sm btn-outline-secondary">${w.active?'Deactivate':'Activate'}</button></form></td></tr></c:forEach></table></div>
<div class="modal fade" id="wM"><div class="modal-dialog"><form method="post" class="modal-content p-3">
  <input type="hidden" name="action" id="wa"><h5 id="wt">Warehouse</h5>
  <input name="id" id="wid" class="form-control mb-2" placeholder="Warehouse ID (vd: W005)" required>
  <input name="name" id="wname" class="form-control mb-2" placeholder="Name" required>
  <input name="location" id="wloc" class="form-control mb-3" placeholder="Location" required>
  <button class="btn btn-g">Save warehouse</button></form></div></div>
<script>function openW(a,i,n,l){const $=id=>document.getElementById(id);$('wa').value=a;$('wid').value=i;$('wid').readOnly=a==='edit';
$('wname').value=n;$('wloc').value=l;$('wt').textContent=a==='add'?'Add Warehouse':'Edit Warehouse';new bootstrap.Modal($('wM')).show();}</script>
<jsp:include page="/WEB-INF/views/includes/_bottom.jsp"/>
