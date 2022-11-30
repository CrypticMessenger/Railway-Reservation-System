import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.io.IOException;

public class client {
    public static void main(String args[]) throws IOException {
        /**************************/
        int firstLevelThreads = 2; // Indicate no of users
        /**************************/
        // Creating a thread pool
        ExecutorService executorService = Executors.newFixedThreadPool(firstLevelThreads);

        for (int i = 0; i < firstLevelThreads; i++) {
            Runnable runnableTask = new invokeWorkers();
            executorService.submit(runnableTask);
        }

        executorService.shutdown();
        try {
            if (!executorService.awaitTermination(10, TimeUnit.SECONDS)) {
                executorService.shutdownNow();
            }
        } catch (InterruptedException e) {
            executorService.shutdownNow();
        }
    }
}