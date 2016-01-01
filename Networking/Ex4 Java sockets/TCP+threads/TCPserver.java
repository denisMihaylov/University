
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Date;


public class TCPserver {

    public static final int LISTENING_TCP_PORT = 3333;

    public static void main(String args[]) throws IOException {
        ServerSocket listener = new ServerSocket(LISTENING_TCP_PORT);
        System.out.println("Listening");
        while (true) {
            Socket clientSocket = listener.accept();
            System.out.println("Got connection from " + clientSocket.getInetAddress());

            BufferedReader input = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
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

        }
    }
}
