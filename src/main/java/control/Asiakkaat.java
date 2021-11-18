package control;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONObject;
import model.Asiakas;
import model.dao.Dao;

@WebServlet("/asiakkaat/*")
public class Asiakkaat extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public Asiakkaat() {
		super();
		System.out.println("Asiakkaat.Asiakkaat()");
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("Asiakkaat.doGet()");
		String pathInfo = request.getPathInfo();
		System.out.println("polku: " + pathInfo);
		Dao dao = new Dao();
		ArrayList<Asiakas> asiakkaat;
		String strJSON = "";
		if (pathInfo == null) {
			asiakkaat = dao.listaaKaikki();
			strJSON = new JSONObject().put("asiakkaat", asiakkaat).toString();
		} else if (pathInfo.indexOf("haeyksi") != -1) {
			String asiakas_id = pathInfo.replace("/haeyksi/", "");
			System.out.println("Hae yksi asiakasID: " + asiakas_id);
			Asiakas asiakas = dao.etsiAsiakas(asiakas_id);
			if (asiakas == null) {
				strJSON = "{}";
			} else {
				JSONObject JSON = new JSONObject();
				JSON.put("asiakas_id", asiakas.getAsiakas_id());
				JSON.put("etunimi", asiakas.getEtunimi());
				JSON.put("sukunimi", asiakas.getSukunimi());
				JSON.put("puhelin", asiakas.getPuhelin());
				JSON.put("sposti", asiakas.getSposti());
				strJSON = JSON.toString();
			}
		} else {
			String hakusana = pathInfo.replace("/", "");
			asiakkaat = dao.listaaKaikki(hakusana);
			strJSON = new JSONObject().put("asiakkaat", asiakkaat).toString();
		}
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		out.println(strJSON);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("Asiakkaa.doPost()");
		JSONObject jsonObj = new JsonStrToObj().convert(request);
		Asiakas asiakas = new Asiakas();
		asiakas.setEtunimi(jsonObj.getString("etunimi"));
		asiakas.setSukunimi(jsonObj.getString("sukunimi"));
		asiakas.setPuhelin(jsonObj.getString("puhelin"));
		asiakas.setSposti(jsonObj.getString("sposti"));
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		Dao dao = new Dao();
		if (dao.lisaaAsiakas(asiakas)) {
			out.println("{\"response\":1}");
		} else {
			out.println("{\"response\":0}");
		}
	}

	protected void doPut(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("Asiakkaat.doPut()");
		JSONObject jsonObj = new JsonStrToObj().convert(request);
		String asiakas_id = jsonObj.getString("asiakas_id");
		Asiakas asiakas = new Asiakas();
		int asiakas_id1 = 0;
		if (asiakas_id != "") {
			asiakas_id1 = Integer.parseInt(asiakas_id);
		}
		System.out.println("Asiakasid int: " + asiakas_id1);
		System.out.println("Asiakasid string: " + asiakas_id);
		asiakas.setAsiakas_id(asiakas_id1);
		asiakas.setEtunimi(jsonObj.getString("etunimi"));
		asiakas.setSukunimi(jsonObj.getString("sukunimi"));
		asiakas.setPuhelin(jsonObj.getString("puhelin"));
		asiakas.setSposti(jsonObj.getString("sposti"));
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		Dao dao = new Dao();
		if (dao.muutaAsiakas(asiakas)) {
			out.println("{\"response\":1}");
		} else {
			out.println("{\"response\":0}");
		}
	}

	protected void doDelete(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("Asiakkaat.doDelete()");
		String pathInfo = request.getPathInfo();
		System.out.println("polku: " + pathInfo);
		String poistettavaAsiakas_id = pathInfo;
		if (pathInfo != null) {
			poistettavaAsiakas_id = pathInfo.replace("/", "");
		}
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		Dao dao = new Dao();
		if (dao.poistaAsiakas(poistettavaAsiakas_id)) {
			out.println("{\"response\":1}");
		} else {
			out.println("{\"response\":0}");
		}
	}

}
