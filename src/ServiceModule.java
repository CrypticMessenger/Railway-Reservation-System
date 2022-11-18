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
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

class QueryRunner implements Runnable {
    // Declare socket for client access
    protected Socket socketConnection;

    public Connection connect() {
        Connection conn = null;
        try {
            conn = DriverManager.getConnection("jdbc:postgresql://localhost/railway_reservation_system", "postgres",
                    "1421");
            // System.out.println("Connected to the PostgreSQL server successfully.");
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return conn;
    }

    // TODO: remove this constructor
    public QueryRunner(Socket clientSocket) {
        this.socketConnection = clientSocket;
    }

    public String getResultSet(Connection conn, String query, int type) {
        try {
            Statement stmt = conn.createStatement();
            stmt.executeUpdate(query);
            if (type == 1) {
                return ("Ticket Booked successfully!");
            }

        } catch (SQLException e) {

            String t = e.getMessage();
            if (t.charAt(7) == 'c') { //
                return "issue";
            }

        }
        return "Seats Unavailable";

    }

    public void run() {
        try {
            // Reading data from client
            Connection conn = connect();
            InputStreamReader inputStream = new InputStreamReader(socketConnection
                    .getInputStream());
            BufferedReader bufferedInput = new BufferedReader(inputStream);
            OutputStreamWriter outputStream = new OutputStreamWriter(socketConnection
                    .getOutputStream());
            BufferedWriter bufferedOutput = new BufferedWriter(outputStream);
            PrintWriter printWriter = new PrintWriter(bufferedOutput, true);

            String st = "";
            String responseQuery = "";

            try {
                conn.setAutoCommit(true);
                conn.setTransactionIsolation(8);
                while (true) {

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
                        conn.close();
                        return;
                    }
                    st = st.replace(",", "");
                    String[] parameters = st.split(" ");
                    int len = parameters.length;
                    String date = parameters[len - 2].replace("-", "");

                    String passenger_names = "";

                    int num_passenger = Integer.parseInt(parameters[0]);
                    for (int i = 1; i <= num_passenger; i++) {
                        if (i != num_passenger) {
                            passenger_names += parameters[i] + ",";

                        } else {
                            passenger_names += parameters[i];

                        }
                    }

                    String query = "insert into bookingq_" + date + "_" + parameters[len - 3]
                            + " (date, train_id, num_passenger,pref,names) values ('" + date + "','"
                            + parameters[len - 3] + "'," + parameters[0] + ",'" + (parameters[len - 1]).toLowerCase()
                            + "',"
                            + "'" + passenger_names + "')";

                    responseQuery = getResultSet(conn, query, 1);
                    while (responseQuery.equals("issue")) {
                        responseQuery = getResultSet(conn, query, 1);
                    }

                    // Sending data back to the client
                    printWriter.println(responseQuery);

                }

            } catch (SQLException e) {

                System.out.println("Client Disconnected");

            }

        } catch (IOException e) {
            return;
        }
    }
}

/**
 * Main Class to control the program flow
 */
public class ServiceModule {
    static int serverPort = 7005;
    static int numServerCores = 2;

    // ------------ Main----------------------
    public static void main(String[] args) throws IOException {
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
            Runnable runnableTask = new QueryRunner(socketConnection);
            executorService.submit(runnableTask);
        }
    }
}
