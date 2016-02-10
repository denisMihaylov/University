import java.rmi.*;

public interface WordsCount extends Remote {

    public String count(String msg) throws RemoteException;
    
}