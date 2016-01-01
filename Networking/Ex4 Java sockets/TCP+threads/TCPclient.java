import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.SocketAddress;
import javax.swing.JOptionPane;


public class TCPclient {

    public static void main(String[] args) throws IOException {

        Socket mySock = new Socket("localhost", 3333);  //Socket(<server name>/<server IP address>, <server port>)
        //Eqivalent to:
        //Socket mySock = new Socket();
        //mySock.connect(new InetSocketAddress("127.1.1.1", 3333));
        
        System.out.println("Connected to " + mySock.getInetAddress());

        PrintWriter out = new PrintWriter(mySock.getOutputStream(), true);
        out.println("get date");    //send something to the server

        BufferedReader input
                = new BufferedReader(new InputStreamReader(mySock.getInputStream()));
        String answer = input.readLine();
        JOptionPane.showMessageDialog(null, answer);

        mySock.close();

    }
}
