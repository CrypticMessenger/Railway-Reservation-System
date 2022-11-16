import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.IOException;
import java.net.ServerSocket;
import java.sql.Statement;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.net.Socket;
import java.sql.Connection;
import java.util.StringTokenizer;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

class QueryRunner implements Runnable {
    // Declare socket for client access
    protected Socket socketConnection;
    // Declare connection to database
    protected Connection conn;

    // TODO: remove this constructor
    public QueryRunner(Socket clientSocket) {
        this.socketConnection = clientSocket;
    }

    public QueryRunner(Socket clientSocket, Connection conn1) {
        this.socketConnection = clientSocket;
        this.conn = conn1;
    }

    public String getResultSet(Connection conn, String query, int type) {
        try {
            // 1 : request
            Statement stmt = conn.createStatement();
            // ResultSet rs = stmt.executeQuery(query);
            int rs = stmt.executeUpdate(query);
            if (type == 1) {
                return ("Ticket Booked successfully!");
            }

        } catch (SQLException e) {
            System.out.println(e.getMessage());

        }
        return "Seats Unavailable";

    }

    public void run() {
        try {
            // Reading data from client
            InputStreamReader inputStream = new InputStreamReader(socketConnection
                    .getInputStream());
            BufferedReader bufferedInput = new BufferedReader(inputStream);
            OutputStreamWriter outputStream = new OutputStreamWriter(socketConnection
                    .getOutputStream());
            BufferedWriter bufferedOutput = new BufferedWriter(outputStream);
            PrintWriter printWriter = new PrintWriter(bufferedOutput, true);

            String st = "";
            String responseQuery = "";
            String queryInput = "";

            while (true) {
                try {
                    conn.setAutoCommit(false);
                    conn.setTransactionIsolation(8); // serilizable
                } catch (SQLException e2) {
                    e2.printStackTrace();
                    break;
                }
                // Read client query
                try {
                    st = bufferedInput.readLine();
                    if (st.equals("#")) {
                        String returnMsg = "Connection Terminated - client : "
                                + socketConnection.getRemoteSocketAddress().toString();
                        System.out.println(returnMsg);
                        inputStream.close();
                        bufferedInput.close();
                        outputStream.close();
                        bufferedOutput.close();
                        printWriter.close();
                        socketConnection.close();
                        return;
                    }
                    System.out.println(st);
                    st = st.replace(",", "");
                    String[] parameters = st.split(" ");
                    int len = parameters.length;
                    String date = parameters[len - 2].replace("-", "");

                    String passenger_names = "";
                    String passenger_genders = "";
                    String passenger_ages = "";
                    int num_passenger = Integer.parseInt(parameters[0]);
                    for (int i = 1; i <= num_passenger; i++) {
                        if (i != num_passenger) {
                            passenger_names += parameters[i] + ",";
                            passenger_ages += parameters[i + num_passenger] + ",";
                            passenger_genders += parameters[i + 2 * num_passenger] + ",";
                        } else {
                            passenger_names += parameters[i];
                            passenger_ages += parameters[i + num_passenger];
                            passenger_genders += parameters[i + 2 * num_passenger];
                        }
                    }

                    // TODO: add stored procedure
                    // TODO: create functions
                    String query = "insert into bookingq_" + date + "_" + parameters[len - 3]
                            + " (date, train_id, num_passenger,pref,names,ages, genders) values ('" + date + "','"
                            + parameters[len - 3] + "'," + parameters[0] + ",'" + (parameters[len - 1]).toLowerCase()
                            + "',"
                            + "'" + passenger_names + "'"
                            + "," + "'" + passenger_ages + "'" + "," + "'" + passenger_genders + "'" + ")";

                    // System.out.println(query);
                    responseQuery = getResultSet(conn, query, 1);

                    // = "******* Dummy result ******";

                    // ----------------------------------------------------------------

                    // Sending data back to the client
                    printWriter.println(responseQuery);
                    // System.out.println("\nSent results to client - "
                    // + socketConnection.getRemoteSocketAddress().toString() );
                    conn.commit();
                    conn.setAutoCommit(true);

                } catch (SQLException e) {
                    System.out.println("Client Disconnected");
                    try {
                        conn.rollback();
                    } catch (SQLException e1) {
                        e1.printStackTrace();
                        break;
                    }
                    break;
                }

            }
        } catch (IOException e) {
            return;
        }
    }
}

/**
 * Main Class to controll the program flow
 */
public class ServiceModule {
    static int serverPort = 7005;
    static int numServerCores = 2;
    private final String url = "jdbc:postgresql://localhost/railway_reservation_system";
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

    // ------------ Main----------------------
    public static void main(String[] args) throws IOException {
        ServiceModule app = new ServiceModule();
        Connection conn = app.connect();
        // Creating a thread pool
        ExecutorService executorService = Executors.newFixedThreadPool(numServerCores);

        // Creating a server socket to listen for clients
        ServerSocket serverSocket = new ServerSocket(serverPort); // need to close the port
        Socket socketConnection = null;

        // Always-ON server
        while (true) {
            System.out.println("Listening port : " + serverPort
                    + "\nWaiting for clients...");
            socketConnection = serverSocket.accept(); // Accept a connection from a client
            System.out.println("Accepted client :"
                    + socketConnection.getRemoteSocketAddress().toString()
                    + "\n");
            // Create a runnable task
            Runnable runnableTask = new QueryRunner(socketConnection, conn);
            // Submit task for execution
            executorService.submit(runnableTask);
        }
    }
}
