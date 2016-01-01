import java.rmi.registry.Registry;
import java.rmi.registry.LocateRegistry;
import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;
import java.util.LinkedList;
import java.util.Scanner;

public class MessagePoolServer implements MessagePool {

    LinkedList<String> MessageQueue;

    public MessagePoolServer() {
        this.MessageQueue = new LinkedList<>();
    }

    @Override
    public void put(String msg) throws RemoteException {

        try {
            if (msg.length() == 0) {
                throw new MessageNullException("Message is null.");
            }
        } catch (MessageNullException ex) {
            System.out.println("MessageNullException");
        }

        if (msg.length() > 500) {
            throw new RuntimeException("Message too big");
        }

        try {
            if (MessageQueue.size() == 100) {
                throw new QueueFullException("Queue is full.");
            }
        } catch (QueueFullException ex) {
            System.out.println("QueueFullException");
        }

        MessageQueue.add(msg);
    }

    @Override
    public String get() throws RemoteException {

        try {
            if (MessageQueue.isEmpty()) {
                throw new QueueEmptyException("Queue is empty.");
            }
        } catch (QueueEmptyException ex) {
            System.out.println("QueueEmptyException");
        }
        return MessageQueue.poll();
    }

    public static void main(String args[]) {
        
        System.out.println("Enter global IP address of the RMI server to bind to:");
        Scanner in = new Scanner(System.in);
        String serverIP = in.next();
        System.setProperty("java.rmi.server.hostname", serverIP);
        // Otherwise binds to localhost only
        
        try {

            MessagePoolServer obj = new MessagePoolServer();

            MessagePool stub = (MessagePool) UnicastRemoteObject.exportObject(obj, 1099);

            LocateRegistry.createRegistry(1099);
            Registry registry = LocateRegistry.getRegistry();

            registry.rebind("MessagePool", stub);

            System.out.println("Server is started");

        } catch (RemoteException e) {
            System.out.println("Error: " + e.getMessage());
        }
    }

}
