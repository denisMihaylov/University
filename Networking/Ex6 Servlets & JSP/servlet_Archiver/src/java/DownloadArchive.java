import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author N
 */
public class DownloadArchive extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String dirName = request.getParameter("dir");
        String filePattern = request.getParameter("filter");
		
		//Adds all the filtered files from the directory to an archive, and sends it to the user.

        File directory = new File(dirName);
        
        FileOutputStream resultFOS = new FileOutputStream(dirName +File.separator+"result.zip");
        try (ZipOutputStream zos = new ZipOutputStream(resultFOS)) {
            for (File f : directory.listFiles()) {
                if (f.getName().matches(filePattern) && && f.isFile()) {
                    zos.putNextEntry(new ZipEntry(f.getName()));
                    try (FileInputStream fileFIS = new FileInputStream(f.getAbsolutePath())) {
                        byte[] buf = new byte[1024];
                        int len;
                        while ((len = fileFIS.read(buf)) > 0) {
                            zos.write(buf, 0, len);
                        }
                    }
                    zos.closeEntry();
                }
            }
            zos.close();

            response.setContentType("application/zip");
            response.setHeader("Content-disposition", "attachment; filename=result.zip");

            File my_file = new File(dirName + File.separator + "result.zip");
            OutputStream out = response.getOutputStream();
            try (FileInputStream in = new FileInputStream(my_file)) {
                byte[] buffer = new byte[4096];
                int length;
                while ((length = in.read(buffer)) > 0) {
                    out.write(buffer, 0, length);
                }
            }
            out.flush();
        }

    }
}
