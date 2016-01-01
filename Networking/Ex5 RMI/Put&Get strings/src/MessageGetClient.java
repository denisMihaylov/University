
import static java.lang.Thread.sleep;
import java.rmi.NotBoundException;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.util.Scanner;

public class MessageGetClient {

    public static void main(String[] args) throws InterruptedException {

        System.out.println("Enter IP address of the RMI server:");
        Scanner in = new Scanner(System.in);
        String serverIP = in.next();

        try {
            Registry registry = LocateRegistry.getRegistry(serverIP);
            MessagePool stub = (MessagePool) registry.lookup("MessagePool");

            while (true) {
                sleep(600);
                System.out.println(stub.get());
            }

        } catch (NotBoundException | RemoteException e) {
            System.out.println("RMI Client exception: " + e.getMessage());
        }
    }

}
