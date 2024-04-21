package webapp;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

public class ServletTask extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html");
        PrintWriter out = resp.getWriter();
        String task = req.getParameter("task");

        try{
            String hostname = "localhost";
            String port = "3306";
            String username = "root";
            String password = "root";
            String schema = "db";
            // using jdbc to connect to database
            Class.forName("com.mysql.cj.jdbc.Driver");

            String connectionUrl = String.format("jdbc:mysql://%s:%s/%s?useSSL=false", hostname, port, schema);
            Connection connection = DriverManager.getConnection(connectionUrl, username, password);
            String query = "INSERT INTO tasks VALUES (?)";
            PreparedStatement preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, task);

            // Execute the INSERT query
            int rowsAffected = preparedStatement.executeUpdate();

            if (rowsAffected > 0) {
                // Task added successfully
                // Set the task attribute in the session
                HttpSession session = req.getSession();
                session.setAttribute("task", task);

                // Redirect back to the home.jsp page
                resp.sendRedirect(req.getContextPath() + "/home.jsp");
            } else {
                // Failed to add task
                System.out.println("Error: Failed to add task.");
            }

        } catch (Exception e){
            System.out.println(e.getMessage());
        }
    }
}
