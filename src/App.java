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

    public void getResultSet(Connection conn, String query, int type) {
        try {
            // 1 : request
            Statement stmt = conn.createStatement();
            // ResultSet rs = stmt.executeQuery(query);
            stmt.executeUpdate(query);
            if (type == 1) {
                System.out.println("Ticket Booked successfully!");
            }
            // ResultSetMetaData rsmd = rs.getMetaData();
            // int columnsNumber = rsmd.getColumnCount();
            // for (int i = 1; i <= columnsNumber; i++) {
            // if (i > 1)
            // System.out.print(" ");
            // System.out.print(rsmd.getColumnName(i));
            // }
            // System.out.println("");
            // while (rs.next()) {
            // for (int i = 1; i <= columnsNumber; i++) {
            // if (i > 1)
            // System.out.print(" ");
            // String columnValue = rs.getString(i);
            // System.out.print(columnValue + " ");
            // }
            // System.out.println("");
            // }
        } catch (SQLException e) {
            System.out.println(e.getMessage());

        }

    }

    public static void main(String[] args) throws Exception {
        App app = new App();
        String path = new File("").getAbsolutePath();
        System.out.println(path);
        Connection conn = app.connect();

        File file = new File(
                "D:\\Desktop\\Multi-Thread_sample\\Multi-Thread_sample\\testSubject\\Experiment1\\client\\admin.txt");
        BufferedReader br = new BufferedReader(new FileReader(file));
        String st;
        while ((st = br.readLine()) != null && !(st.equals("#"))) {
            // System.out.println(st);

            String[] parameters = st.split(" ");
            String date = parameters[1].replace("-", "");
            String query = "insert into date_train_records (date,train_id,num_ac,num_slr) values ('" + date + "','"
                    + parameters[0] + "','" + parameters[2] + "','" + parameters[3] + "')";

            app.getResultSet(conn, query, 0);
        }

        br.close();

        // file = new File(
        // "D:\\Desktop\\Multi-Thread_sample\\Multi-Thread_sample\\testSubject\\Experiment1\\client\\requests.txt");
        // br = new BufferedReader(new FileReader(file));
        // while ((st = br.readLine()) != null && !(st.equals("#"))) {
        // // System.out.println(st);
        // st = st.replace(",", "");
        // String[] parameters = st.split(" ");
        // int len = parameters.length;
        // String date = parameters[len - 2].replace("-", "");

        // String passenger_names = "";
        // String passenger_genders = "";
        // String passenger_ages = "";
        // int num_passenger = Integer.parseInt(parameters[0]);
        // for (int i = 1; i <= num_passenger; i++) {
        // if (i != num_passenger) {
        // passenger_names += parameters[i] + ",";
        // passenger_ages += parameters[i + num_passenger] + ",";
        // passenger_genders += parameters[i + 2 * num_passenger] + ",";
        // } else {
        // passenger_names += parameters[i];
        // passenger_ages += parameters[i + num_passenger];
        // passenger_genders += parameters[i + 2 * num_passenger];
        // }
        // }

        // // TODO: add stored procedure
        // String query = "insert into bookingq_" + date + "_" + parameters[len - 3]
        // + " (date, train_id, num_passenger,pref,names,ages, genders) values ('" +
        // date + "','"
        // + parameters[len - 3] + "'," + parameters[0] + ",'" + (parameters[len -
        // 1]).toLowerCase() + "',"
        // + "'" + passenger_names + "'"
        // + "," + "'" + passenger_ages + "'" + "," + "'" + passenger_genders + "'" +
        // ")";

        // // System.out.println(query);
        // app.getResultSet(conn, query, 1);
        // }
        // br.close();
    }
}
