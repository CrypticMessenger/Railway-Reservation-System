import java.util.Scanner;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.Socket;

class sendQuery implements Runnable {
    int sockPort = 7005;

    public void run() {
        try {
            // Creating a client socket to send query requests
            Socket socketConnection = new Socket("localhost", sockPort);
            // String add1 = "/home/course2/Reservation-System-Project/client/";
            // String add2 = "/home/course2/Reservation-System-Project/response/";

            String add1 = "D:\\Desktop\\Multi-Thread_sample\\Multi-Thread_sample\\testSubject\\Experiment3\\Reservation-System-Project\\client\\";
            String add2 = "D:\\Desktop\\Multi-Thread_sample\\Multi-Thread_sample\\testSubject\\Experiment3\\Reservation-System-Project\\response\\";

            String inputfile = Thread.currentThread().getName() + "_input.txt";

            String outputfile = Thread.currentThread().getName() + "_output.txt";

            // -----Initialising the Input & ouput file-streams and buffers-------
            OutputStreamWriter outputStream = new OutputStreamWriter(socketConnection
                    .getOutputStream());
            BufferedWriter bufferedOutput = new BufferedWriter(outputStream);
            InputStreamReader inputStream = new InputStreamReader(socketConnection
                    .getInputStream());
            BufferedReader bufferedInput = new BufferedReader(inputStream);
            PrintWriter printWriter = new PrintWriter(bufferedOutput, true);
            File queries = new File(add1 + inputfile);
            File output = new File(add2 + outputfile);
            FileWriter filewriter = new FileWriter(output);
            Scanner sc = new Scanner(queries);
            String query = "";
            // --------------------------------------------------------------------

            // Read input queries
            while (sc.hasNextLine()) {
                query = sc.nextLine();
                printWriter.println(query);
            }

            String result;
            while ((result = bufferedInput.readLine()) != null) {
                filewriter.write(result + "\n");
            }

            // close the buffers and socket
            filewriter.close();
            sc.close();
            socketConnection.close();
        } catch (IOException e1) {
            e1.printStackTrace();
        }
    }
}