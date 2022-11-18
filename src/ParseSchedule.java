
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ParseSchedule {
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
            stmt.executeUpdate(query);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    public static void main(String[] args) throws Exception {
        ParseSchedule app = new ParseSchedule();
        Connection conn = app.connect();
        File file = new File(
                "D:\\Desktop\\Multi-Thread_sample\\Multi-Thread_sample\\testSubject\\Experiment3\\Reservation-System-Project\\client\\train_schedule.txt");
        BufferedReader br = new BufferedReader(new FileReader(file));

        String st;
        String train_id = "";
        String station_name = "";
        String arrival_time = "";
        String departure_time = "";
        String arrival_date = "";
        String departure_date = "";
        int num_line = 0;
        while ((st = br.readLine()) != null && !(st.equals("*"))) {
            if (st.equals("#")) {
                String[] station_names = station_name.split(",");
                String[] arrival_dates = arrival_date.split(",");
                String[] arrival_times = arrival_time.split(",");
                String[] departure_dates = departure_date.split(",");
                String[] departure_times = departure_time.split(",");
                int len = station_names.length;
                for (int i = 0; i < len; i++) {
                    for (int j = i + 1; j < len; j++) {
                        String query = "insert into routes(train_id,src,dest,src_departure_time,dest_arrival_time,src_departure_date,dest_arrival_date)values ("
                                + "'" + train_id + "','" + station_names[i] + "','" + station_names[j] + "','" +
                                departure_times[i]
                                + "','" + arrival_times[j] + "','" + departure_dates[i] + "','" +
                                arrival_dates[j] + "')";
                        // System.out.println(query);
                        app.getResultSet(conn, query);
                    }
                }
                System.out.println("-----------------------------------------------------------");
                num_line = 0;
                continue;
            }

            if (num_line == 0) {
                train_id = st;
                num_line++;
            } else if (num_line == 1) {
                String[] parameters = st.split(",");
                station_name = station_name + parameters[0];
                arrival_time += parameters[1];
                departure_time += parameters[2];
                arrival_date += parameters[3];
                departure_date += parameters[4];
                num_line++;
            } else {

                String[] parameters = st.split(",");
                station_name += "," + parameters[0];
                arrival_time += "," + parameters[1];
                departure_time += "," + parameters[2];
                arrival_date += "," + parameters[3];
                departure_date += "," + parameters[4];
            }

        }
        String join = "select r1.train_id as train1_id,r2.train_id as train2_id,r1.src as src, r1.dest as stop, r2.dest as dest,r1.arrival_time as src_dept_time,r1.departure_time as stop_arrival_time,r2.arrival_time as stop_dept_time,r2.departure_time as dest_reach_time, r1.arrival_date as doj, r1.departure_date as stop_doj_1,r2.arrival_date as stop_doj_2, r2.departure_date as eoj  into one_stop from routes as r1,routes as r2 where r1.dest = r2.src and r1.train_id != r2.train_id and check_time(r1.arrival_time,r2.departure_time,r1.arrival_date,r2.departure_date)= 'true'";
        app.getResultSet(conn, join);
        br.close();

    }
}
