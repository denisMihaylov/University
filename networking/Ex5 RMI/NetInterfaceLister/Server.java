import java.net.SocketException;
import java.rmi.*;
import java.util.LinkedList;

public interface Server extends java.rmi.Remote {

    String sayHello() throws RemoteException;
    public LinkedList<String> listInterfaces() throws SocketException, RemoteException;
}
