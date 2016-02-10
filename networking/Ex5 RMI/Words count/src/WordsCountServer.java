import java.rmi.registry.Registry;
import java.rmi.registry.LocateRegistry;
import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;
import java.util.HashMap;
import java.util.Scanner;

public class WordsCountServer implements WordsCount {

    HashMap<String,Integer> HashMapWords;

    public WordsCountServer() {
        this.HashMapWords = new HashMap<>();
    }

    @Override
    public String count(String line) throws RemoteException {
        System.out.println("Line received: " + line);
        String[] words = line.split("\\W");
        for (String word : words) {
            if(HashMapWords.containsKey(word)){
                HashMapWords.put(word, HashMapWords.get(word) + 1);
            }else {
                HashMapWords.put(word, 1);
            }            
        }
        return HashMapWords.toString();
    }


    public static void main(String args[]) {
        
        System.out.println("Enter global IP address of the RMI server to bind to:");
        Scanner in = new Scanner(System.in);
        String serverIP = in.next();
        System.setProperty("java.rmi.server.hostname", serverIP);
        // Otherwise binds to localhost only
        try {

            WordsCountServer obj = new WordsCountServer();

            WordsCount stub = (WordsCount) UnicastRemoteObject.exportObject(obj, 1099);

            LocateRegistry.createRegistry(1099);
            /*
            Creates and exports a Registry instance on the local host that accepts requests on the specified port.
            The Registry instance is exported as if the static UnicastRemoteObject.exportObject method is invoked, 
            passing the Registry instance and the specified port as arguments, except that the Registry instance is exported with a well-known object identifier, 
            an ObjID instance constructed with the value ObjID.REGISTRY_ID.
            */
            Registry registry = LocateRegistry.getRegistry();

            registry.rebind("WordsCount", stub);

            System.out.println("Server is started");

        } catch (RemoteException e) {
            System.out.println("Error: " + e.getMessage());
        }
    }

}
