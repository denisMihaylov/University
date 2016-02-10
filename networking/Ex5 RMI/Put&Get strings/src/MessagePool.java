
/**
 *
 * @author Nikola
 */
import java.rmi.*;

public interface MessagePool extends Remote {

    public void put(String msg) throws RemoteException;
    public String get() throws RemoteException;
    
}
