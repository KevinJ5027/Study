<%@page import="semi_bts.common.PagingVO"%>
<%@page import="semi_bts.tourplace.model.TourplaceDAO"%>
<%@page import="java.sql.SQLException"%>
<%@page import="semi_bts.tourplace.model.TourplaceDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="../inc/planTop.jsp"%>
<style type="text/css">
/*datepicker에서 사용한 이미지 버튼 style적용*/
img.ui-datepicker-trigger {
	margin-left: 5px;
	vertical-align: middle;
	cursor: pointer;
}
#map {
	clear: both;
	float: right;
	width: 40%;
	height: 800px;
	margin-right: 10%;
	margin-top: 113px;
}

#cal {
	float: left;
	width: 20%;
	height: 800px;
	margin-left: 10%;
	background: skyblue;
	margin-top: 40px;
}
#placeList{
	float: left;
	width: 20%;
	height: 800px;
	background: pink;
	overflow: scroll;
	margin-top: 40px;
}
#placeList .listWrap {
	padding: 10px;
	border: 1px solid gray;
}


</style>
<jsp:useBean id="tourplaceService"
	class="semi_bts.tourplace.model.TourplaceService" scope="page"></jsp:useBean>
<jsp:useBean id="tourplaceDto"
	class="semi_bts.tourplace.model.TourplaceDTO" scope="page"></jsp:useBean>
<%
	//2. db - db에서 여행지이름, 위도, 경도 가져옴
	List<TourplaceDTO> list = null;
	List<TourplaceDTO> list2 = null;
	try{
		list = tourplaceService.selectByCatNo(1);
		list2 = tourplaceService.selectByCatNo(2);
	}catch(SQLException e){
		e.printStackTrace();
	}
	

	   
	   request.setCharacterEncoding("utf-8");
	   String condition=request.getParameter("searchCondition");
	   String keyword=request.getParameter("searchKeyword");
	   
	   TourplaceDAO dao = new TourplaceDAO();

	   List<TourplaceDTO> list3=null;
	   
	   try{
	      list3 = dao.selectAll(condition,keyword);
	      
	   }catch(SQLException e){
	      e.printStackTrace();
	   }


	   //페이징 처리
	   int currentPage=1;  //현재 페이지
	   
	   if(request.getParameter("currentPage") !=null ){
	      currentPage=Integer.parseInt(request.getParameter("currentPage"));
	   }
	   
	   //(1) 현재 페이지와 무관한 변수
	   int totalRecord = 0;  //전체 레코드 개수, 예) 17
	   if(list3 !=null && !list3.isEmpty()){
	      totalRecord=list3.size();
	   }
	   int pageSize=10;  //한 페이지에 보여줄 레코드 수, 5
	   int blockSize=5;  //한 블럭에 보여줄 페이지 수, 10
	   
	   PagingVO pageVo = new PagingVO(currentPage, totalRecord, pageSize, blockSize);

	%>


<div class="site-section">
	<div id="map"></div>
	<script>
		var mapContainer = document.getElementById('map'), // 지도를 표시할 div  
		mapOption = {
			center : new kakao.maps.LatLng(35.17981758789283, 129.07496554097818), // 지도의 중심좌표
			level : 9
		// 지도의 확대 레벨
		};

		var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
		var marker="";
		<%
		String title = "", lat="", lng="", tel="", homepage="", address="", imageURL="";
		for(int i=0; i<list.size();i++){
			tourplaceDto = list.get(i);
			title = tourplaceDto.getPlaceName();
			lat = tourplaceDto.getLatitude();
			lng = tourplaceDto.getLongitude();
			homepage = tourplaceDto.getHomepage();
			address = tourplaceDto.getPlaceAddress();
			imageURL = tourplaceDto.getImageURL();
			tel = tourplaceDto.getPlaceTel();
		%>

		// 마커를 표시할 위치와 title 객체 배열입니다 
		var positions = [ {
			title : '<%=title%>',
			latlng : new kakao.maps.LatLng(<%=lat%>, <%=lng%>)
			}
		];

		// 마커 이미지의 이미지 주소입니다
		var imageSrc = "../images/place.png";

		for (var i = 0; i < positions.length; i++) {

			// 마커 이미지의 이미지 크기 입니다
			var imageSize = new kakao.maps.Size(24, 35);

			// 마커 이미지를 생성합니다    
			var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize);

			// 마커를 생성합니다
			marker = new kakao.maps.Marker({
				map : map, // 마커를 표시할 지도
				position : positions[i].latlng, // 마커를 표시할 위치
				title : positions[i].title, // 마커의 타이틀, 마커에 마우스를 올리면 타이틀이 표시됩니다
				image : markerImage
			// 마커 이미지 
			});
		}

		// 커스텀 오버레이에 표시할 컨텐츠 입니다
		// 커스텀 오버레이는 아래와 같이 사용자가 자유롭게 컨텐츠를 구성하고 이벤트를 제어할 수 있기 때문에
		// 별도의 이벤트 메소드를 제공하지 않습니다 
		var content = '<div class="wrap">' + 
		            '    <div class="info">' + 
		            '        <div class="title">' + 
		            '            <%=title%>' + 
		            '            <div class="close" onclick="closeOverlay()" title="닫기"></div>' + 
		            '        </div>' + 
		            '        <div class="body">' + 
		            '            <div class="img">' +
		            '                <img src="<%=imageURL%>" width="73" height="70">' +
		            '           </div>' + 
		            '            <div class="desc">' + 
		            '                <div class="ellipsis"><%=address%></div>' + 
		            '                <div class="jibun ellipsis">tel : <%=tel%></div>' + 
		            '                <div><a href="<%=homepage%>" target="_blank" class="link">홈페이지</a></div>' + 
		            '            </div>' + 
		            '        </div>' + 
		            '    </div>' +    
		            '</div>';
		         // 마커 위에 커스텀오버레이를 표시합니다
					// 마커를 중심으로 커스텀 오버레이를 표시하기위해 CSS를 이용해 위치를 설정했습니다
					var overlay = new kakao.maps.CustomOverlay({
					    content: content,
					    map: map,
					    position: marker.getPosition()       
			});
		<%}//for%>
		<%
		String title2 = "", lat2="", lng2="", tel2="", homepage2="", address2="", imageURL2="";
		for(int i=0; i<list2.size();i++){
			tourplaceDto = list2.get(i);
			title2 = tourplaceDto.getPlaceName();
			lat2 = tourplaceDto.getLatitude();
			lng2 = tourplaceDto.getLongitude();
			homepage2 = tourplaceDto.getHomepage();
			address2 = tourplaceDto.getPlaceAddress();
			imageURL2 = tourplaceDto.getImageURL();
			tel2 = tourplaceDto.getPlaceTel();
		%>
	
		// 마커를 표시할 위치와 title 객체 배열입니다 
		var positions = [ {
			title : '<%=title2%>',
			latlng : new kakao.maps.LatLng(<%=lat2%>, <%=lng2%>)
			}
		];

		// 마커 이미지의 이미지 주소입니다
		var imageSrc = "../images/food.png";

		for (var i = 0; i < positions.length; i++) {

			// 마커 이미지의 이미지 크기 입니다
			var imageSize = new kakao.maps.Size(24, 35);

			// 마커 이미지를 생성합니다    
			var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize);

			// 마커를 생성합니다
			marker = new kakao.maps.Marker({
				map : map, // 마커를 표시할 지도
				position : positions[i].latlng, // 마커를 표시할 위치
				title : positions[i].title, // 마커의 타이틀, 마커에 마우스를 올리면 타이틀이 표시됩니다
				image : markerImage
			});
		}

		var content = '<div class="wrap">' + 
		            '    <div class="info">' + 
		            '        <div class="title">' + 
		            '            <%=title2%>' + 
		            '            <div class="close" onclick="closeOverlay()" title="닫기"></div>' + 
		            '        </div>' + 
		            '        <div class="body">' + 
		            '            <div class="img">' +
		            '                <img src="<%=imageURL2%>" width="73" height="70">' +
		            '           </div>' + 
		            '            <div class="desc">' + 
		            '                <div class="ellipsis"><%=address2%></div>' + 
		            '                <div class="jibun ellipsis">tel : <%=tel2%></div>' + 
		            '                <div><a href="<%=homepage2%>" target="_blank" class="link">홈페이지</a></div>' + 
		            '            </div>' + 
		            '        </div>' + 
		            '    </div>' +    
		            '</div>';
		        // 마커 위에 커스텀오버레이를 표시합니다
				// 마커를 중심으로 커스텀 오버레이를 표시하기위해 CSS를 이용해 위치를 설정했습니다
					var overlay = new kakao.maps.CustomOverlay({
					    content: content,
					    map: map,
					    position: marker.getPosition()       
					});
			<%}//for%>	
		
		// 마커를 클릭했을 때 커스텀 오버레이를 표시합니다
		kakao.maps.event.addListener(marker, 'click', function() {
		    overlay.setMap(map);
		    console.log("열기");
		});		
		//커스텀 오버레이를 닫기 위해 호출되는 함수입니다 
		function closeOverlay() {
			overlay.setMap(null);   
			console.log("닫기");
		}
	</script>
</div>
<div id="cal">
	오늘 날짜 : <span id="today"></span>
	<form>
		<label for="fromDate">출발일</label> <input type="text" name="fromDate"
			id="fromDate"><br> ~ <label for="toDate">도착일</label> <input
			type="text" name="toDate" id="toDate">
	</form>
</div>
<script type="text/javascript">
		$("#today").text(new Date().toLocaleDateString());

		$('#fromDate').datepicker({
			showOn : "both",
			buttonImage : "../images/cal.jpg",
			buttonImageOnly : true,
			buttonText : "날짜선택",
			dateFormat : "yy-mm-dd",
			changeMonth : true,
			onClose : function(selectedDate) {
				$("#toDate").datepicker("option", "minDate", selectedDate);
			}
		});

		$('#toDate').datepicker({
			showOn : "both",
			buttonImage : "../images/cal.jpg",
			buttonImageOnly : true,
			buttonText : "날짜선택",
			dateFormat : "yy-mm-dd",
			changeMonth : true,
			onClose : function(selectedDate) {
				$("#fromDate").datepicker("option", "maxDate", selectedDate);
			}
		});
</script>



<div id="placeList">
	<div style="background: #eee;">여행지 리스트</div>
	<div class="listWrap">
          <!-- 여기서부터 사진 시작 -->
             <%
           int num = pageVo.getNum();
           int curPos = pageVo.getCurPos();
           
             for(int i=0; i<pageVo.getPageSize();i++){ 
                if(num<1) break;
                TourplaceDTO dto=list3.get(curPos++); //0, 5, 10, 15
              	num--;
         	%>
         
         <!-- 여기서 받아와야 하는거 장소번호, 장소이름, 장소메인이미지 -->
            <div class="listTable">
                  <div class="info">
                    <!-- <a href="single.html"> -->
                      <a href="tourplace_detail.jsp?no=<%=dto.getPlaceNo()%>" name ="title"> <img src="<%=dto.getImagemain() %>" alt="Image"
                       class="img-fluid" ></a>
                    <!-- </a> -->
                    <div class="post-entry-1-contents">
                      <span class="meta1" style="color: blue"><%=dto.getPlacetitle() %></span>
                      <a href="tourplace_detail.jsp?no=<%=dto.getPlaceNo()%>" name ="title"><h2><%=dto.getPlaceName() %></h2></a>
                      <p class="my-3"><a href="tourplace_detail.jsp?no=<%=dto.getPlaceNo()%>" class="more-39291">자세히 보기</a></p>
                      <p class="my-3"><input type="button" value="일정추가"></p>
                    </div>
                  </div>
              </div>
         <%} %>
         <!-- 페이징 처리 -->
          
          <div class="col-12">
          
         <!-- 페이지 번호 추가 -->      
         <!-- 이전 블럭으로 이동 -->
            <%
            if (pageVo.getFirstPage() > 1) {
            %>
               <a href="plan.jsp?currentPage=<%=pageVo.getFirstPage()-1%>">
                  <img src="../images/first.JPG" alt="이전 블럭으로">
               </a>
            <%}//if %>
                           
            <!-- [1][2][3][4][5][6][7][8][9][10] -->
            <%for(int i=pageVo.getFirstPage();i<=pageVo.getLastPage();i++){
                  if(i>pageVo.getTotalPage()) break;
                  
                  if(i == currentPage){%>
                     <span style="color:#eee;font-weight: bold"><%=i %></span>
                  <%}else{ %>
                     <a href="plan.jsp?currentPage=<%=i%>"><%=i %></a>
                  <%}//if %>   
            <%}//for %>
            
            <!-- 다음 블럭으로 이동 -->
            <%if(pageVo.getLastPage() < pageVo.getTotalPage()){ %>
               <a href="plan.jsp?currentPage=<%=pageVo.getLastPage()+1%>">
                  <img src="../images/last.JPG" alt="다음 블럭으로">
               </a>
            <%}//if %>
            <!--  페이지 번호 끝 -->
          </div>
        </div>
</div>



<%@include file="../inc/planBottom.jsp"%>
