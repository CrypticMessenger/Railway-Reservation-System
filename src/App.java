
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.DriverManager;
import java.sql.SQLException;

public class App {
    private final String url = "jdbc:postgresql://localhost/postgres";
    private final String user = "postgres";
    private final String password = "1421";

    public Connection connect() {
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(url, user, password);
            System.out.println("Connected to the PostgreSQL server successfully.");
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return conn;
    }

    public void getResultSet(Connection conn, String query) {
        try {
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(query);

            ResultSetMetaData rsmd = rs.getMetaData();
            int columnsNumber = rsmd.getColumnCount();
            for (int i = 1; i <= columnsNumber; i++) {
                if (i > 1)
                    System.out.print("  ");
                System.out.print(rsmd.getColumnName(i));
            }
            System.out.println("");
            while (rs.next()) {
                for (int i = 1; i <= columnsNumber; i++) {
                    if (i > 1)
                        System.out.print("  ");
                    String columnValue = rs.getString(i);
                    System.out.print(columnValue + " ");
                }
                System.out.println("");
            }
        } catch (SQLException e) {
            System.err.println(e.getMessage());
        }

    }

    public static void main(String[] args) throws Exception {
        App app = new App();

        Connection conn = app.connect();

        File file = new File(
                "D:\\Desktop\\Multi-Thread_sample\\Multi-Thread_sample\\testSubject\\Experiment1\\client\\query.txt");
        BufferedReader br = new BufferedReader(new FileReader(file));
        String st;
        while ((st = br.readLine()) != null && !(st.equals("FINISH"))) {
            System.out.println(st);
            app.getResultSet(conn, st);
        }
        br.close();

        // int ans = app.getCount("SELECT count(*) FROM classes");
        System.out.println("Hello, World!");
        // System.out.println(ans);
    }
}
