
import static java.lang.Thread.sleep;
import java.rmi.NotBoundException;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.util.Random;
import java.util.Scanner;

/**
 *
 * @author Nikola
 */
public class MessagePutClient {
    
        public static void main(String[] args) throws InterruptedException {

        System.out.println("Enter IP address of the RMI server:");
        Scanner in = new Scanner(System.in);
        String serverIP = in.next();

        try {
            Registry registry = LocateRegistry.getRegistry(serverIP);
            MessagePool stub = (MessagePool) registry.lookup("MessagePool");
            while (true) {
                sleep(300);
                String randGenerated = randomString("asdfghzxcvbn_1234567890");
                stub.put(randGenerated);
                System.out.println("Sent string: " + randGenerated);
            }

        } catch (NotBoundException | RemoteException e) {
            System.out.println("RMI Client exception: " + e.getMessage());
        }
    }

    public static String randomString(String chars) {
        Random randomGenerator = new Random();
        int length = randomGenerator.nextInt(500);
        Random rand = new Random();
        StringBuilder buf = new StringBuilder();
        for (int i = 0; i < length; i++) {
            buf.append(chars.charAt(rand.nextInt(chars.length())));
        }
        return buf.toString();
    }
}
