<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Insert title here</title>
</head>
<body>
<table id="listaus">
	<thead>
		<tr>
			<th>Hakusana:</th>
			<th colspan="5"><input type="text" id="hakusana" class="hakulaatikko"></th>
			<th><input type="button" value="Hae" id="hakunappi"></th>
		</tr>			
		<tr class="tiedot">
			<th>AsiakasID</th>
			<th>Etunimi</th>
			<th>Sukunimi</th>
			<th>Puhelin</th>
			<th>Sähköposti</th>
			<th></th>
			<th></th>						
		</tr>
	</thead>
	<tbody>
	</tbody>
</table>
<table class="alanappi">
	<tr>
		<th><span id="uusiAsiakas">Lisää uusi asiakas</span></th>
	</tr>
</table>
<script>
$(document).ready(function(){
	
	$("#uusiAsiakas").click(function(){
		document.location="lisaaasiakas.jsp";
	});
	
	haeAsiakkaat();
	$("#hakunappi").click(function(){		
		haeAsiakkaat();
	});
	$(document.body).on("keydown", function(event){
		  if(event.which==13){ //Enteriä painettu, ajetaan haku
			  haeAsiakkaat();
		  }
	});
	$("#hakusana").focus();//viedään kursori hakusana-kenttään sivun latauksen yhteydessä
});	

function haeAsiakkaat(){
	$("#listaus tbody").empty();
	$.ajax({url:"asiakkaat/"+$("#hakusana").val(), type:"GET", dataType:"json", success:function(result){//Funktio palauttaa tiedot json-objektina		
		$.each(result.asiakkaat, function(i, field){  
        	var htmlStr;
        	htmlStr+="<tr id='rivi_"+field.asiakas_id+"' class='tiedot'>";
        	htmlStr+="<td>"+field.asiakas_id+"</td>";
        	htmlStr+="<td>"+field.etunimi+"</td>";
        	htmlStr+="<td>"+field.sukunimi+"</td>";
        	htmlStr+="<td>"+field.puhelin+"</td>";
        	htmlStr+="<td>"+field.sposti+"</td>";
        	htmlStr+="<td><a class='muuta' href='muutaasiakas.jsp?asiakas_id="+field.asiakas_id+"'>Muuta</a></td>"; 
        	htmlStr+="<td><span class='poista' onclick=poista('"+field.asiakas_id+"')>Poista</span></td>";
        	htmlStr+="</tr>";
        	$("#listaus tbody").append(htmlStr);
        });	
    }});
}

function poista(asiakas_id){
	if(confirm("Poista asiakas " + asiakas_id + "?")){
		$.ajax({url:"asiakkaat/"+asiakas_id, type:"DELETE", dataType:"json", success:function(result) {
	        if(result.response==0){
	        	$("#ilmo").html("Asiakkaan poisto epäonnistui.");
	        }else if(result.response==1){
	        	alert("Asiakkaan " + asiakas_id +" poisto onnistui.");
				haeAsiakkaat();        	
			}
	    }});
	}
}

</script>
</body>
</html>