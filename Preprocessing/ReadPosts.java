import java.io.*;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;
import java.sql.*;

public class ReadPosts  extends DefaultHandler {

	private int counter = 0;

	// JDBC driver name and database URL
	static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";
	static final String DB_URL = "jdbc:mysql://localhost/sml_project_new";

	//  Database credentials
	static final String USER = "root";
	static final String PASS = "system";
	private Connection conn = null;
	private Statement stmt = null;
	private String tableName = "";
  private PrintWriter fileWriter;

	public static void main(String[] args) throws Exception {
		SAXParserFactory factory = SAXParserFactory.newInstance();
    SAXParser saxParser = factory.newSAXParser();
		ReadPosts app = new ReadPosts();
		app.tableName = "math_se_posts_20130531";
		saxParser.parse("MOdump20130531/posts.xml", app);

		app.tableName = "math_se_posts_20120401";
		app.counter = 0;
		saxParser.parse("MOdump20120401/posts.xml", app);
		app.stmt.close();
		app.conn.close();
	}

	public ReadPosts() throws Exception {
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
			//Remove tags
			String body = attributes.getValue("Body") == null ? attributes.getValue("Body") :attributes.getValue("Body").replaceAll("\\\\", "\\\\\\\\").replaceAll("'", "\\\\'");
			body = body.replaceAll("\\<.*?>","");
			body = body.replaceAll(",","");
			body = body.replaceAll("@","");
			String title = attributes.getValue("Title") == null ? attributes.getValue("Title") :attributes.getValue("Title").replaceAll("\\\\", "\\\\\\\\").replaceAll("'", "\\\\'");
			if(title != null)
			{title = title.replaceAll("\\<.*?>","");
			title = title.replaceAll(",","");
			title = title.replaceAll("@","");}

			String query = "";
			query = "INSERT INTO `"+ tableName +"` VALUES ("+
			attributes.getValue("Id")+", "+
			attributes.getValue("PostTypeId")+", "+
			attributes.getValue("AcceptedAnswerId")+", "+
			attributes.getValue("ParentId")+", '"+
			attributes.getValue("CreationDate")+"', '"+
			attributes.getValue("DeletionDate")+"', "+
			attributes.getValue("Score")+", "+
			attributes.getValue("ViewCount")+", '"+
			body + "', "+
			attributes.getValue("OwnerUserId")+", '"+
			attributes.getValue("OwnerDisplayName")+"', "+
			attributes.getValue("LastEditorUserId")+", '"+
			attributes.getValue("LastEditorDisplayName")+"', '"+
			attributes.getValue("LastEditDate")+"', '"+
			attributes.getValue("LastActivityDate")+"', '"+
			title +"', '"+
			attributes.getValue("Tags")+"', "+
			attributes.getValue("AnswerCount")+", "+
			attributes.getValue("CommentCount")+", "+
			attributes.getValue("FavoriteCount")+", '"+
			attributes.getValue("ClosedDate")+"', '"+
			attributes.getValue("CommunityOwnedDate") + "')";
			query = query.replaceAll("'null'","null");

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
