import java.io.*;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;
import java.sql.*;

public class ReadVotes  extends DefaultHandler {

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
		ReadVotes app = new ReadVotes();
		app.tableName = "math_se_votes_20130531";
		saxParser.parse("MOdump20130531/votes.xml", app);

		app.tableName = "math_se_votes_20120401";
		app.counter = 0;
		saxParser.parse("MOdump20120401/votes.xml", app);
		app.stmt.close();
		app.conn.close();
	}

	public ReadVotes() throws Exception {
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
			String userDisplayName = attributes.getValue("UserDisplayName") == null ? attributes.getValue("UserDisplayName") :attributes.getValue("UserDisplayName").replaceAll("\\\\", "\\\\\\\\").replaceAll("'", "\\\\'");
			String comment = attributes.getValue("Comment") == null ? attributes.getValue("Comment") :attributes.getValue("Comment").replaceAll("\\\\", "\\\\\\\\").replaceAll("'", "\\\\'");
			String text = attributes.getValue("Text") == null ? attributes.getValue("Text") :attributes.getValue("Text").replaceAll("\\\\", "\\\\\\\\").replaceAll("'", "\\\\'");

			String query = "";
			query = "INSERT INTO `"+ tableName +"` VALUES ("+
			attributes.getValue("Id")+", "+
			attributes.getValue("PostId")+", "+
			attributes.getValue("VoteTypeId")+", "+
			attributes.getValue("UserId")+", '"+
			attributes.getValue("CreationDate")+"', "+
			attributes.getValue("BountyAmount")+")";
			query = query.replaceAll("'null'","null");

			try {
				  //fileWriter.print(query);
					stmt.executeUpdate(query);
			} catch (Exception e) {
				System.out.println(e.getMessage());
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
