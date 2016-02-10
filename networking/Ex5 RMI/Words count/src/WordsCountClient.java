import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import static java.lang.Thread.sleep;
import java.rmi.NotBoundException;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.util.Scanner;

public class WordsCountClient {

    public static void main(String[] args) throws InterruptedException, IOException {

        System.out.println("Enter IP address of the RMI server:");
        Scanner in = new Scanner(System.in);
        String serverIP = in.next();

        try {
            Registry registry = LocateRegistry.getRegistry(serverIP);
            WordsCount stub = (WordsCount) registry.lookup("WordsCount");

//            System.out.println("Enter file:");
            String projectabsolutePath = new File("").getAbsolutePath();
            String readFile = projectabsolutePath+File.separator+"resources"+File.separator+"file.txt";
            // File.separator - OS-independent ("\\" - Windows, "/" - Unix/Linux)
            File file = new File(readFile);
            if (!file.exists() || !file.canRead()) {
                System.out.println("Can't read " + file);
                return;
            }
            BufferedReader br = new BufferedReader(new FileReader(file));
            String line;
            while ((line = br.readLine()) != null) {
                System.out.println(stub.count(line));
            }
            br.close();

        } catch (NotBoundException | RemoteException e) {
            System.out.println("RMI Client exception: " + e.getMessage());
        }
    }

}
