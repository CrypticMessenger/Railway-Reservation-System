import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

public class invokeWorkers implements Runnable {
    /*************************/
    int secondLevelThreads = 30;

    /**************************/
    public invokeWorkers() {

    }

    ExecutorService executorService = Executors.newFixedThreadPool(secondLevelThreads);

    public void run() {
        for (int i = 0; i < secondLevelThreads; i++) {
            Runnable runnableTask = new sendQuery();
            executorService.submit(runnableTask);
        }

        sendQuery s = new sendQuery();
        s.run();

        executorService.shutdown();
        try {

            if (!executorService.awaitTermination(8, TimeUnit.SECONDS)) {
                executorService.shutdownNow();
            }
        } catch (InterruptedException e) {
            executorService.shutdownNow();
        }
    }
}
