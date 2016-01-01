import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Date;


public class TCPmultiServer_threads implements Runnable {    //TCPmultiServer_threads extends Thread  -> can be done either way 
								//because TCPmultiServer_threads does not extend another class

    Socket clientSocket;
    private Object socket;
    private Object mySock;

    TCPmultiServer_threads(Socket clientSocket) {
        this.clientSocket = clientSocket;
    }

    public static void main(String args[]) throws IOException {
        ServerSocket listener = new ServerSocket(3333);
        System.out.println("Listening");
        while (true) {
            Socket sock = listener.accept();
            System.out.println("Got connection from " + sock.getInetAddress());
            new Thread(new TCPmultiServer_threads(sock)).start();   //start a new thread for the client, 
        }                                                  //so that we could accept other clients on ServerSocket listener at the same time   
    }

    @Override
    public void run() {      //executed by every client thread
        try {

            BufferedReader input
                    = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
            String query = input.readLine();
            String answer;
            if (query.equals("get date")) {
                answer = new Date().toString();
            } else {
                answer = "What do you want?";
            }
            PrintWriter out = new PrintWriter(clientSocket.getOutputStream(), true);
            out.println(answer);

            clientSocket.close();
        } catch (IOException e) {
            System.out.println(e);
        }
    }
}
