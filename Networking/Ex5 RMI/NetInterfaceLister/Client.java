import java.net.NetworkInterface;
import java.rmi.Naming;
import java.rmi.NotBoundException;
//import java.rmi.RMISecurityManager; 
//import java.rmi.Naming; 
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.util.Iterator;
import java.util.LinkedList;


public class Client {

    public static void main(String arg[]) throws RemoteException, NotBoundException {
        //String message = "blank";

        // I download server's stubs ==> must set a SecurityManager 
        //System.setSecurityManager(new RMISecurityManager());
        try {
            Server serv = (Server) Naming.lookup("//localhost:2222/InterfaceLister");  //<server name/IP adress>:<port>/<object name in registry>
          /* Returns a reference, a stub, for the remote object associated with the specified name.
             * Parameters:
             * name - a name in URL format (without the scheme component)
             */
        //	Registry registry = LocateRegistry.getRegistry("localhost", 2222);
            //	Server serv = (Server) registry.lookup("reg");
            System.out.println(serv.sayHello());
            
            LinkedList<String> serverInterfaces = serv.listInterfaces();
            
            for (Iterator<String> i = serverInterfaces.iterator(); i.hasNext(); )
            {
                System.out.println(i.next());
            }
            
        } catch (Exception e) {
            System.out.println("HelloClient exception: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
