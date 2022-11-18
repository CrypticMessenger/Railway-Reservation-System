
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

public class routePlanner {
    private final String url = "jdbc:postgresql://localhost/train_schedule";
    private final String user = "postgres";
    private final String password = "1421";
    // private final String password = "iitropar";

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
                    System.out.print(" ");
                System.out.print(rsmd.getColumnName(i));
            }
            System.out.println("");
            while (rs.next()) {
                for (int i = 1; i <= columnsNumber; i++) {
                    if (i > 1)
                        System.out.print(" ");
                    String columnValue = rs.getString(i);
                    System.out.print(columnValue + " ");
                }
                System.out.println("");
            }

            stmt.executeUpdate(query);

        } catch (SQLException e) {
            // System.out.println(e.getMessage());

        }

    }

    public static void main(String[] args) throws Exception {
        routePlanner app = new routePlanner();

        Connection conn = app.connect();

        File file = new File(
                "D:\\Desktop\\Multi-Thread_sample\\Multi-Thread_sample\\testSubject\\Experiment3\\Reservation-System-Project\\client\\route_query.txt");
        BufferedReader br = new BufferedReader(new FileReader(file));
        String st = "";
        while ((st = br.readLine()) != null && !(st.equals("#"))) {
            String[] parameters = st.split(",");
            String src = parameters[0];
            String dest = parameters[1];
            String doj = parameters[2];
            System.out.println("\n***********************************************************************************");
            System.out.println("Direct path: ");
            String query = "select * from routes where src = '" + src + "' and dest = '" + dest
                    + "' and src_departure_date = '" + doj + "' ";
            app.getResultSet(conn, query);
            System.out.println("------------------------------------------------------------------------------------");
            System.out.println("Paths with one stop: ");
            query = "select * from one_stop where src = '" + src + "' and dest = '" + dest + "' and doj = '" + doj
                    + "' ";
            app.getResultSet(conn, query);
            System.out.println("***********************************************************************************\n");
        }
        br.close();

    }
}
