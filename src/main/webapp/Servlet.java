package webapp;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

public class Servlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html");

        String user = req.getParameter("username");
        String pass = req.getParameter("password");
        try{
            String hostname = "localhost";
            String port = "3306";
            String username = "root";
            String password = "root";
            String schema = "db";
            // connect to database
            Class.forName("com.mysql.cj.jdbc.Driver");

            String connectionUrl = String.format("jdbc:mysql://%s:%s/%s?useSSL=false", hostname, port, schema);
            Connection connection = DriverManager.getConnection(connectionUrl, username, password);
            String query = "SELECT * FROM users WHERE username = ? AND password = ?";
            PreparedStatement preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, user);
            preparedStatement.setString(2, pass);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()){
                HttpSession session = req.getSession();
                session.setAttribute("user", user);

                resp.sendRedirect(req.getContextPath() + "/home.jsp");

            }else {
                System.out.println("error");
            }

        }catch (Exception e){
            System.out.println(e.getMessage());
        }
    }
}
