
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Calculator</title>
    </head>
    <body>
        <div>
            <form name="calc" action="calc.jsp" method="get">
                First digit: <input type="number" name="digit1"><br/>
                Second digit: <input type="number" name="digit2"><br/>
                <input type="radio" name="math_func" value="sum" checked>Sum<br/>
                <input type="radio" name="math_func" value="div">Divide<br/>
                <input type="radio" name="math_func" value="sub">Substitute<br/>
                <input type="radio" name="math_func" value="avg">Average<br/>
                <input type="submit" value="Submit">
            </form>
        </div>
    </body>
</html>