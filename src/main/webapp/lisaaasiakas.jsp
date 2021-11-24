<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="scripts/main.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Insert title here</title>
</head>
<body>
<form id="tiedot">
	<table>
		<thead>			
			<tr>
				<th>Etunimi</th>
				<th>Sukunimi</th>
				<th>Puhelin</th>
				<th>Sähköposti</th>
			</tr>
		</thead>
		<tbody>
			<tr class="lisayslaatikot">
				<td><input type="text" name="etunimi" id="etunimi"></td>
				<td><input type="text" name="sukunimi" id="sukunimi"></td>
				<td><input type="text" name="puhelin" id="puhelin"></td>
				<td><input type="text" name="sposti" id="sposti"></td> 
				<td><input type="button" id="tallenna" value="Lisää" onClick="lisaaTiedot()"></td>
			</tr>
		</tbody>
	</table>
	<span class="ilmoitus" id="ilmo"></span>
	<table class="alanappi">
			<tr>
				<th><a id="takaisin" href="listaaasiakkaat.jsp">Takaisin listaukseen</a></th>
			</tr>	
	</table>
</form>

	<div class="ilmoitusdiv">
	<span class="ilmoitus" id="ilmo"></span>
	</div>

</body>
<script>


document.getElementById("etunimi").focus();


function lisaaTiedot(){	
	var ilmo="";

	if(document.getElementById("etunimi").value.length<1){
		document.getElementById("ilmo").className = "ilmoitus virhe";
		ilmo="Etunimi liian lyhyt";
	}else if(document.getElementById("sukunimi").value.length<1){
		document.getElementById("ilmo").className = "ilmoitus virhe";
		ilmo="Sukunimi liian lyhyt";		
	}else if(document.getElementById("puhelin").value.length<4){
		document.getElementById("ilmo").className = "ilmoitus virhe";
		ilmo="Puhelinnumero liian lyhyt";		
	}else if(document.getElementById("puhelin").value*1!=document.getElementById("puhelin").value){
		document.getElementById("ilmo").className = "ilmoitus virhe";
		ilmo="Puhelinnumero ei ole luku";		
	}else if(document.getElementById("sposti").value.length<5){
		document.getElementById("ilmo").className = "ilmoitus virhe";
		ilmo="Sähköposti on liian lyhyt";
	}	
	
	if(ilmo!=""){
		document.getElementById("ilmo").innerHTML=ilmo;
		setTimeout(function(){ document.getElementById("ilmo").innerHTML=""; }, 3000);
		return;
	}
	document.getElementById("etunimi").value=siivoa(document.getElementById("etunimi").value);
	document.getElementById("sukunimi").value=siivoa(document.getElementById("sukunimi").value);
	document.getElementById("puhelin").value=siivoa(document.getElementById("puhelin").value);
	document.getElementById("sposti").value=siivoa(document.getElementById("sposti").value);	
		
	var formJsonStr=formDataToJSON(document.getElementById("tiedot"));

	fetch("asiakkaat",{
	      method: 'POST',
	      body:formJsonStr
	    })
	.then( function (response) {		
		return response.json()
	})
	.then( function (responseJson) {
		var vastaus = responseJson.response;		
		if(vastaus==0){
			document.getElementById("ilmo").className = "ilmoitus virhe";
			document.getElementById("ilmo").innerHTML= "Asiakkaan lisääminen epäonnistui";
      	}else if(vastaus==1){
      		document.getElementById("ilmo").className = "ilmoitus onnistuminen";
      		document.getElementById("ilmo").innerHTML= "Asiakkaan lisääminen onnistui";			      	
		}
		setTimeout(function(){ document.getElementById("ilmo").innerHTML=""; }, 5000);
	});	
	document.getElementById("tiedot").reset();
}
</script>
</html>