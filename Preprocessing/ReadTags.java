import java.io.*;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;
import java.sql.*;

public class ReadTags  extends DefaultHandler {

	private int counter = 0;

	// JDBC driver name and database URL
	static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";
	static final String DB_URL = "jdbc:mysql://localhost/sml_project";

	//  Database credentials
	static final String USER = "root";
	static final String PASS = "system";
	private Connection conn = null;
	private Statement stmt = null;

	public static void main(String[] args) throws Exception {
		SAXParserFactory factory = SAXParserFactory.newInstance();
        SAXParser saxParser = factory.newSAXParser();
		ReadTags app = new ReadTags();
		saxParser.parse("Tags.xml", app);
		app.stmt.close();
		app.conn.close();
	}

	public ReadTags() throws Exception {
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


			String query = "INSERT INTO sml_project.vi_stackexchange_tags VALUES ("+
			attributes.getValue("Id")+", '"+
			attributes.getValue("TagName")+"', "+
			attributes.getValue("Count")+", "+
			attributes.getValue("ExcerptPostId")+", "+
			attributes.getValue("WikiPostId")+")";
			query = query.replaceAll("'null'","null");

			try {
				stmt.executeUpdate(query);
				// System.out.println(query);
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
