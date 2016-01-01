import java.net.*;

public class UDPclient {
	public static final String DATE_SERVER = "localhost"; // <server name>/<server IP address> ex.: mydomain.com / 10.10.10.10
	public static final int DATE_PORT = 12345;
	public static final String REQUEST_TO_SERVER = "GET DATE";
	public static final int TIMEOUT_IN_SECONDS = 5;
	public static void main(String[] args) throws Exception {
	       // Send request to the UDP Date Server
		   DatagramSocket datagramSocket = new DatagramSocket();
		   String request = REQUEST_TO_SERVER;
		   byte[] requestBuf = request.getBytes();
		   DatagramPacket packetOut = new DatagramPacket(
		       requestBuf, requestBuf.length,InetAddress.getByName(DATE_SERVER), DATE_PORT);
		   datagramSocket.send(packetOut);
		   System.out.println("Sent date request to the server.");
		   // Receive the server response
		   byte[] responseBuf = new byte[256];
		   DatagramPacket packetIn = new DatagramPacket(responseBuf, responseBuf.length);
		   datagramSocket.setSoTimeout(TIMEOUT_IN_SECONDS * 1000);
		   try {
			   datagramSocket.receive(packetIn);
				String response = new String(
				responseBuf, 0, packetIn.getLength());
				System.out.println("Server response: " + response);
				} catch (SocketTimeoutException ste) {
				System.err.println("Timeout! No response received"+
				" in " + TIMEOUT_IN_SECONDS + " seconds.");
				}
				datagramSocket.close();
		   }
}
