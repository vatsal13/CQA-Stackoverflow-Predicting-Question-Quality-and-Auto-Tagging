import java.io.*;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;
import java.sql.*;

public class ReadUsers  extends DefaultHandler {

	private int counter = 0;

	// JDBC driver name and database URL
	static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";
	static final String DB_URL = "jdbc:mysql://personaldb1.cacsnunleniu.us-west-2.rds.amazonaws.com/sml_project_new";

	//  Database credentials
	static final String USER = "root";
	static final String PASS = "&RQQz6;_xv}37HHa";
	private Connection conn = null;
	private Statement stmt = null;
	private String tableName = "";
  private PrintWriter fileWriter;

	public static void main(String[] args) throws Exception {
		SAXParserFactory factory = SAXParserFactory.newInstance();
    SAXParser saxParser = factory.newSAXParser();
		ReadUsers app = new ReadUsers();
		app.tableName = "math_se_users_history_20130531";
		saxParser.parse("MOdump20130531/users.xml", app);

		app.tableName = "math_se_users_history_20120401";
		app.counter = 0;
		saxParser.parse("MOdump20120401/users.xml", app);
		app.stmt.close();
		app.conn.close();
	}

	public ReadUsers() throws Exception {
		//STEP 2: Register JDBC driver
		Class.forName("com.mysql.jdbc.Driver");

		//STEP 3: Open a connection
		System.out.println("Connecting to database...");
		conn = DriverManager.getConnection(DB_URL,USER,PASS);

		//STEP 4: Execute a query
		System.out.println("Creating statement...");
		stmt = conn.createStatement();
	}

	@Override
	public void startElement(String uri,
		String localName, String qName, Attributes attributes)
			throws SAXException {

		if (qName.equalsIgnoreCase("row")) {
			String displayName = attributes.getValue("DisplayName") == null ? attributes.getValue("DisplayName") : attributes.getValue("DisplayName").replaceAll("'", "\\\\'");
			String websiteUrl = attributes.getValue("WebsiteUrl") == null ? attributes.getValue("WebsiteUrl") :attributes.getValue("WebsiteUrl").replaceAll("'", "\\\\'");
			String location = attributes.getValue("Location") == null ? attributes.getValue("Location") :attributes.getValue("Location").replaceAll("'", "\\\\'");

			String query = "";
			query = "INSERT INTO `"+ tableName +"` VALUES ("+
			attributes.getValue("Id")+", "+
			attributes.getValue("Reputation")+", '"+
			attributes.getValue("CreationDate")+"', '"+
			displayName + "', '"+
			attributes.getValue("LastAccessDate")+"', '"+
			websiteUrl +"', '"+
			location +"', "+
			attributes.getValue("Views")+", "+
			attributes.getValue("UpVotes")+", "+
			attributes.getValue("DownVotes")+", "+
			attributes.getValue("Age")+", "+
			attributes.getValue("AccountId") + ")";

			try {
				//fileWriter.print(query);
				stmt.executeUpdate(query);
			} catch (Exception e) {
				System.out.println(query);
			}
		}
	}

	@Override
	public void endElement(String uri,
		String localName, String qName) throws SAXException {
	}

	@Override
	public void characters(char ch[],
      int start, int length) throws SAXException {
	}
}
