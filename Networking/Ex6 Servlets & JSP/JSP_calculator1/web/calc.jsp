
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Calculated result</title>
    </head>
    <body>
        <%
            int dig1 = Integer.parseInt(request.getParameter("digit1"));
            int dig2 = Integer.parseInt(request.getParameter("digit2"));
            String func = request.getParameter("math_func");
            int result = 0;
            if (func.equals("sum")){
               result = dig1 + dig2; 
            }
            else if (func.equals("sub")){
                result = dig1 - dig2;
            }
            else if (func.equals("div")){
               result = dig1 / dig2; 
            }
            else result = (dig1 + dig2) / 2;
            /*
            switch ( func ) {
                case "sum":
                    result = dig1 + dig2;
                    break;
                case "sub":
                    result = dig1 - dig2;
                    break;
                case "div":
                    result = dig1 / dig2;
                    break;
                case "avg":
                    result = (dig1 + dig2) / 2;
                    break;
            }
*/
        %>
        
        <h3>Calculated result = <%= result %> </h3>
        
    </body>
</html>