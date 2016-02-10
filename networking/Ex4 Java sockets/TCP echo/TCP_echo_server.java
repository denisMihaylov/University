import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Date;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 *
 * @author N
 */
public class TCP_echo_server {

    public static final int LISTENING_TCP_PORT = 3333;

    public static void main(String args[]) throws IOException {
        ServerSocket listener = new ServerSocket(LISTENING_TCP_PORT);
        System.out.println("Listening on port "+LISTENING_TCP_PORT);
        while (true) {
            Socket clientSocket = listener.accept();
            System.out.println("Got connection from " + clientSocket.getInetAddress());
            BufferedReader input = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
            PrintWriter out = new PrintWriter(clientSocket.getOutputStream(), true);    //autoflush=true
            //autoflush - A value indicating whether the stream should be automatically flushed when it is written to.
            //equivalent to manual flush: out.flush(); -> This forces data to be sent to the server without closing the Socket.
            while (true) {                
                String query = input.readLine();
                if (query.equals("END")) {
                    break;
                }
                out.println(query);
            }
            System.out.println("Connection with " + clientSocket.getInetAddress() + " closed.");
            clientSocket.close();
        }
    }
}
