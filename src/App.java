//! remove slr from requests.txt, use sl instead.

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.DriverManager;
import java.sql.SQLException;

public class App {
    private final String url = "jdbc:postgresql://localhost/railway_reservation_system";
    private final String user = "postgres";
    // private final String password = "iitropar";
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
            stmt.executeUpdate(query);

        } catch (SQLException e) {
            System.out.println(e.getMessage());

        }

    }

    public static void main(String[] args) throws Exception {
        App app = new App();

        Connection conn = app.connect();

        File file = new File(
                "D:\\Desktop\\Multi-Thread_sample\\Multi-Thread_sample\\testSubject\\Experiment3\\Reservation-System-Project\\client\\admin.txt");
        BufferedReader br = new BufferedReader(new FileReader(file));
        String st;
        while ((st = br.readLine()) != null && !(st.equals("#"))) {

            String[] parameters = st.split(" ");
            String date = parameters[1].replace("-", "");
            String query = "insert into date_train_records (date,train_id,num_ac,num_slr) values ('" + date + "','"
                    + parameters[0] + "','" + parameters[2] + "','" + parameters[3] + "')";

            app.getResultSet(conn, query);
        }

        br.close();

    }
}
