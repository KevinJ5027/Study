<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<link rel="stylesheet" type="text/css" 
   href="<c:url value='/resources/css/mainstyle.css'/>" />
<link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/clear.css'/>" />
<link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/formLayout.css'/>" />
<link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/mystyle.css'/>" />
<script type="text/javascript" 
   src="<c:url value='/resources/js/jquery-3.6.0.min.js'/>"></script>
<script type="text/javascript">   
	$(function(){
		$('#selectAll').click(function(){
	         $.ajax({
	             url:"<c:url value='/guestbook/ajaxList.do'/>",
	             type:"get",
	             dataType:"json",
	             success:function(res){
	    		      if(res.length>0){
	     				 $('#result').empty();
	     				 
	     				 var result= "";
	     				 $.each(res, function(idx, item){
        					result +="<tr><td>"+item.no+"</td>"
	     					result += "<td>"+item.name+"</td>"
	     					result += "<td>"+item.content+"</td>"
	     					result += "<td>"+item.regdate+"</td></tr>"
	     				 });
	     				 
	     				 $('#result').append(result);
	     			 }
	             },
	             error:function(xhr, status, error){
	                alert("error 발생!"+error);
	             }
	          });
		});
		
		$('#selectByNo').click(function(){
			$.ajax({
				url:"<c:url value='/guestbook/ajaxDetail.do'/>",
				type:"post",
				data:"no="+$('#no').val(),
				dataType:"json",
				success:function(res){
					var result = "<tr><td>"+res.no+"</td>"
								+"<td>"+res.name+"</td>"
								+"<td>"+res.content+"</td>"
								+"<td>"+res.regdate+"</td></tr>"
					$('#result').append(result);								
				},
				error:function(xhr, status, error){
					alert("error!!");
				}
			});		
		});
	});
   
</script>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
   <div class="divList">
   	<form>
   	  <input type="button" id="selectAll" value="전체조회">
   	  <label for="no">번호입력 : </label>
   	  <input type="text" name="no" id="no" >
   	  <input type="button" id="selectByNo" value="번호로조회">
  	</form>
      <table class="box2"
         summary="방명록에 대한 표로써, 번호, 작성자, 내용, 작성일에 대한 정보를 제공합니다.">
         <caption>기본 게시판</caption>
         <colgroup>
            <col style="width: 10%;" />
            <col style="width: 20%;" />
            <col style="width: 40%;" />
            <col style="width: 30%;" />
         </colgroup>
         <thead>
            <tr>
               <th scope="col">번호</th>
               <th scope="col">작성자</th>
               <th scope="col">내용</th>
               <th scope="col">작성일</th>
            </tr>
         </thead>
         <tbody id="result">
			 
         </tbody>
      </table>
   </div>
</body>
</html>