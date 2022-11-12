import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.StringTokenizer;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

class QueryRunner implements Runnable {
    // Declare socket for client access
    protected Socket socketConnection;

    public QueryRunner(Socket clientSocket) {
        this.socketConnection = clientSocket;
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

            String clientCommand = "";
            String responseQuery = "";
            String queryInput = "";

            while (true) {
                // Read client query
                clientCommand = bufferedInput.readLine();

                // Tokenize here
                StringTokenizer tokenizer = new StringTokenizer(clientCommand);
                queryInput = tokenizer.nextToken();
                // what does StringTokenizer do?

                if (queryInput.equals("#")) {
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

                // -------------- your DB code goes here----------------------------
                // try
                // {
                // // Thread.sleep(6000);
                // }
                // catch (InterruptedException e)
                // {
                // e.printStackTrace();
                // }

                responseQuery = "******* Dummy result ******";

                // ----------------------------------------------------------------

                // Sending data back to the client
                printWriter.println(responseQuery);
                // System.out.println("\nSent results to client - "
                // + socketConnection.getRemoteSocketAddress().toString() );

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
            // Create a runnable task
            Runnable runnableTask = new QueryRunner(socketConnection);
            // Submit task for execution
            executorService.submit(runnableTask);
        }
    }
}

// connect to database using sockets
// http://www.java2s.com/Code/Java/Network-Protocol/Connecttoadatabaseusingsockets.htm

// java - How to use Socket to connect to a database? - Stack Overflow
// http://stackoverflow.com/questions/10000000/how-to-use-socket-to-connect-to-a-database
