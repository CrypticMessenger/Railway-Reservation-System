import java.util.Scanner;
import java.util.concurrent.ExecutorService ;
import java.util.concurrent.Executors   ;
import java.util.concurrent.TimeUnit;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException  ;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.Socket;


class sendQuery implements Runnable
{
    int sockPort = 7005 ;
    // public sendQuery(int arg)            // constructor to get arguments from the main thread
    // {
    //    // arg from main thread
    // }
    
    public void run()
    {
        try 
        {
            //Creating a client socket to send query requests
            Socket socketConnection = new Socket("localhost", sockPort) ;
            
            // Files for input queries and responses
            String inputfile = Thread.currentThread().getName() + "_input.txt" ;
            String outputfile = Thread.currentThread().getName() + "_output.txt" ;

            //-----Initialising the Input & ouput file-streams and buffers-------
            OutputStreamWriter outputStream = new OutputStreamWriter(socketConnection
                                                                     .getOutputStream());
            BufferedWriter bufferedOutput = new BufferedWriter(outputStream);
            InputStreamReader inputStream = new InputStreamReader(socketConnection
                                                                  .getInputStream());
            BufferedReader bufferedInput = new BufferedReader(inputStream);
            PrintWriter printWriter = new PrintWriter(bufferedOutput,true);
            File queries = new File(inputfile); 
            File output = new File(outputfile); 
            FileWriter filewriter = new FileWriter(output);
            Scanner sc = new Scanner(queries);
            String query = "";
            //--------------------------------------------------------------------

            // Read input queries
            while(sc.hasNextLine())
            {
                query = sc.nextLine();
                printWriter.println(query);
            }

            // Get query responses from the input end of the socket of client
            char c;
            while((c = (char) bufferedInput.read()) != (char)-1)      
            {
                // System.out.print(i);
                filewriter.write(c);
            }

            // close the buffers and socket
            filewriter.close();
            sc.close();
            socketConnection.close();
        } 
        catch (IOException e1)
        {
            e1.printStackTrace();
        }
    }
}

public class client
{
    public static void main(String args[])throws IOException
    {
        int numberOfusers = 5 ;   // Indicate no of users 

        // Creating a thread pool
        ExecutorService executorService = Executors.newFixedThreadPool(numberOfusers) ;
        
        for(int i = 0; i < numberOfusers; i++)
        {
            Runnable runnableTask = new sendQuery()  ;    //  Pass arg if any as sendQuery(arg)
            executorService.submit(runnableTask) ;
        }
        
        executorService.shutdown()  ;
        try
        {
            if (!executorService.awaitTermination(900, TimeUnit.MILLISECONDS))
            {
                executorService.shutdownNow();
            } 
        } 
        catch (InterruptedException e)
        {
            executorService.shutdownNow();
        }
    }
}