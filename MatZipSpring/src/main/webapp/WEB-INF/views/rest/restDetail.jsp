<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css">
<div style="height:100%;">
	<div class="recMenuContainer">
		<c:forEach items="${recMenuList}" var="item">
			<div class="recMenuItem" id="recMenuItem_${item.seq}">
				<div class="pic">
					<c:if test="${item.menu_pic != null and item.menu_pic != ''}">
						<img src="/res/img/rest/${data.i_rest}/rec_menu/${item.menu_pic}">
					</c:if>
				</div>
				<div class="info">
					<div class="nm">${item.menu_nm}</div>
					<div class="price"><fmt:formatNumber type="number" value="${item.menu_price}"/>원</div>
				</div>
				<c:if test="${loginUser.i_user == data.i_user}">
					<div class="delIconContainer" onclick="delRecMenu(${item.seq})">
						<span class="material-icons">clear</span>
					</div>
				</c:if>
			</div>
		</c:forEach>
	</div>
	<div id="sectionContainerCenter">
		<div>
			<c:if test="${loginUser.i_user == data.i_user}">
				<button onclick="isDel()">가게 삭제</button>
				
				<h2>- 추천 메뉴 -</h2>
				<div>
					<div><button type="button" onclick="addRecMenu()">추천 메뉴 추가</button></div>
					<form id="recFrm" action="/rest/recMenus" enctype="multipart/form-data" method="post">
						<input type="hidden" name="i_rest" value="${data.i_rest}">
						<div id="recItem"></div>
						<div><input type="submit" value="등록"></div>
					</form>
				</div>
				
				<h2>- 메뉴 -</h2>
				<div>
					<form id="menuFrm" action="/rest/menus" enctype="multipart/form-data" method="post">
						<input type="hidden" name="i_rest" value="${data.i_rest}">
						<input type="file" name="menu_pic" multiple>
						<div><input type="submit" value="등록"></div>
					</form>
				</div>
			</c:if>
			
			<div class="restaurant-detail">
				<div id="detail-header">
					<div class="restaurant_title_wrap">
						<h1 class="restaurant_name">${data.nm}</h1>
					</div>
					<div class="status branch_none">
						<span class="cnt hit">${data.hits}</span>					
						<span class="cnt favorite">${data.cnt_favorite}</span>
					</div>
				</div>
				<div>
					<table>
						<caption>레스토랑 상세 정보</caption>
						<tbody>
							<tr>
								<th>주소</th>
								<td>${data.addr}</td>
							</tr>
							<tr>
								<th>카테고리</th>
								<td>${data.cd_category_nm}</td>
							</tr>
							<tr>
								<th>작성자</th>
								<td>${data.user_nm}</td>
							</tr>
							<tr>
								<th>메뉴</th>
								<td>	
									<div id="conMenuList" class="menuList">
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>

<div id="carouselContainer">
	<div id="imgContainer">
		<div class="swiper-container">
			<div class="swiper-wrapper">
			<!-- Slides -->
			    <div class="swiper-slide">Slide 1</div>
			    <div class="swiper-slide">Slide 2</div>
			    <div class="swiper-slide">Slide 3</div>
			    ...
			</div>
			<!-- If we need pagination -->
			<div class="swiper-pagination"></div>
			
			<!-- If we need navigation buttons -->
			<div class="swiper-button-prev"></div>
			<div class="swiper-button-next"></div>
		</div>
	</div>
	<span class="material-icons">clear</span>
</div>

<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
<script>

	//core version + navigation, pagination modules:
	
	
	var mySwiper = new Swiper('.swiper-container', {
		  // Optional parameters
		  direction: 'horizontal',
		  loop: true,
		
		  // If we need pagination
		  pagination: {
		    el: '.swiper-pagination',
		  },
		
		  // Navigation arrows
		  navigation: {
		    nextEl: '.swiper-button-next',
		    prevEl: '.swiper-button-prev',
		  },
		
		  // And if we need scrollbar
		  scrollbar: {
		    el: '.swiper-scrollbar',
		  },
		})

	
	
	

	var menuList = []

	function ajaxSelMenuList() {
		axios.get('/rest/ajaxSelMenuList', {
			params: {
				i_rest: ${data.i_rest}
			}
		}).then(function(res) {
			menuList = res.data
			refreshMenu()
		})
	}
	
	function refreshMenu() {
		conMenuList.innerHTML = ''
		menuList.forEach(function(item, idx) {
			makeMenuItem(item, idx)
		})
	}
	
	function makeMenuItem(item, idx) {
		const div = document.createElement('div')
		div.setAttribute('class', 'menuItem')
				
		const img = document.createElement('img')
		img.setAttribute('src', `/res/img/rest/${data.i_rest}/menu/\${item.menu_pic}`)
		
		div.append(img)
		
		<c:if test="${loginUser.i_user == data.i_user}">
			const delDiv = document.createElement('div')
			delDiv.setAttribute('class', 'delIconContainer')
			delDiv.addEventListener('click', function() {
				if(idx > -1) {
					//서버 삭제 요청!
					axios.get('/rest/ajaxDelMenu', {
						params: {
							i_rest: ${data.i_rest},
							seq: item.seq,
							menu_pic: item.menu_pic
						}
					}).then(function(res) {
						if(res.data == 1) {
							menuList.splice(idx, 1)
							refreshMenu()
						} else {
							alert('메뉴를 삭제할 수 없습니다.')
						}
					})	
				}
			})
			
			const span = document.createElement('span')
			span.setAttribute('class', 'material-icons')
			span.innerText = 'clear'
			
			delDiv.append(span)
			div.append(delDiv)
		</c:if>
			
		conMenuList.append(div)
	}

	<c:if test="${loginUser.i_user == data.i_user}">
	function delRecMenu(seq) {
		if(!confirm('삭제하시겠습니까?')) {
			return
		}	
		console.log('seq : ' + seq)
		
		axios.get('/rest/ajaxDelRecMenu', {
			params: {
				i_rest: ${data.i_rest},
				seq: seq
			}
		}).then(function(res) {
			console.log(res)
			if(res.data == 1) {
				//엘리먼트 삭제
				var ele = document.querySelector('#recMenuItem_' + seq)
				ele.remove()
			}
		})
	}
	
	var idx = 0;
	function addRecMenu() {
		var div = document.createElement('div')
		div.setAttribute('id', 'recMenu_' + idx++)
		
		var inputNm = document.createElement('input')
		inputNm.setAttribute('type', 'text')
		inputNm.setAttribute('name', 'menu_nm')
		var inputPrice = document.createElement('input')
		inputPrice.setAttribute('type', 'number')
		inputPrice.setAttribute('name', 'menu_price')
		inputPrice.value = '0'
		var inputPic = document.createElement('input')
		inputPic.setAttribute('type', 'file')
		inputPic.setAttribute('name', 'menu_pic')
		var delBtn = document.createElement('input')
		delBtn.setAttribute('type', 'button')
		delBtn.setAttribute('value', 'X')		
		delBtn.addEventListener('click', function() {
			div.remove()
		})		
		div.append('메뉴: ')
		div.append(inputNm)
		div.append(' 가격: ')
		div.append(inputPrice)
		div.append(' 사진: ')
		div.append(inputPic)
		div.append(delBtn)
		
		recItem.append(div)
	}

	function isDel() {
		if(confirm('삭제 하시겠습니까?')) {
			location.href = '/rest/del?i_rest=${data.i_rest}'
		}
	}
	addRecMenu()
	
	</c:if>
	ajaxSelMenuList()
	
</script>


