import java.net.NetworkInterface;
import java.net.SocketException;
import java.rmi.AccessException;
import java.rmi.AlreadyBoundException;
//import java.rmi.Naming; 
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;
import java.util.Enumeration;
import java.util.LinkedList;

public class ServerImpl extends UnicastRemoteObject implements Server {

    /**
     * Наследниците UnicastRemoteObject се експортират автоматично Преди обектът
     * да се предаде на друга машина той трябва да бъде експортиран
     * UnicastRemoteObject.exportObject(object)
     */
    private static final long serialVersionUID = 1L;

    public ServerImpl() throws RemoteException {
        super();
    }

    public String sayHello() {
        return "Hello world!";
    }
    
    public LinkedList<String> listInterfaces() throws SocketException, RemoteException {
            Enumeration interfaces = NetworkInterface.getNetworkInterfaces();
            LinkedList<String> ls = new LinkedList<String>();     //we can't send to the client an Enumeration<NetworkInterface>,
            while (interfaces.hasMoreElements()) {                // cause it can't be seriallized
                NetworkInterface ni = (NetworkInterface) interfaces.nextElement();
                ls.add(ni.toString());
            }
            return ls;
    }

    public static void main(String args[]) throws RemoteException, AlreadyBoundException, AccessException {
        try {
            ServerImpl obj = new ServerImpl();
            // Bind this object instance to the name "InterfaceLister" 
            //Naming.rebind("InterfaceLister", obj); 
            Registry registry = LocateRegistry.createRegistry(2222);     //default port is 1099
            registry.bind("InterfaceLister", obj);
            System.out.println("RMI server is started on port 2222");
        } catch (Exception e) {
            System.out.println("HelloImpl err: " + e.getMessage());
            e.printStackTrace();
        }
    }

}
