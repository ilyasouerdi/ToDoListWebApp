<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.NamingException" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%

    String username = (String) session.getAttribute("user");
    List<String> tasks = new ArrayList<>();

    try {
        // database connection
        String hostname = "localhost";
        String port = "3306";
        String usern = "root";
        String password = "root";
        String schema = "db";
        // using jdbc to connect to database
        Class.forName("com.mysql.cj.jdbc.Driver");

        String connectionUrl = String.format("jdbc:mysql://%s:%s/%s?useSSL=false", hostname, port, schema);
        Connection connection = DriverManager.getConnection(connectionUrl, usern, password);
        String sql = "SELECT task FROM tasks";
        PreparedStatement pstmt = connection.prepareStatement(sql);
        ResultSet rs = pstmt.executeQuery();

        // Iterate over the result set and add tasks to the list
        while (rs.next()) {
            tasks.add(rs.getString("task"));
        }

        // Close resources
        rs.close();
        pstmt.close();
        connection.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>To-Do List Dashboard</title>
    <style>

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(to left, #000000, #525151);

            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 800px;
            margin: 20px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        h1 {
            text-align: center;
            margin: 20px 0;
            color: #333;
        }

        .add-task-form {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: 20px;
        }

        .add-task-form input[type="text"] {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            margin-right: 10px;
            flex: 1;
        }

        .add-task-form input[type="submit"] {
            padding: 10px 20px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .add-task-form input[type="submit"]:hover {
            background-color: #0056b3;
        }

        ul {
            list-style-type: none;
            padding: 0;
            margin: 0;
        }

        li {
            background-color: #fff;
            margin-bottom: 10px;
            padding: 10px;
            border-radius: 4px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between; /* align delete button to the right */
        }

        .delete-task {
            background-color: #dc3545;
            color: #fff;
            border: none;
            border-radius: 4px;
            padding: 5px 10px;
            cursor: pointer;
        }
        .edit-task {
            background-color: green;
            color: #fff;
            border: none;
            border-radius: 4px;
            padding: 5px 10px;
            cursor: pointer;
        }

        .delete-task:hover {
            background-color: #bd2130;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Hi! <%= username %></h1>
    <form class="add-task-form" action="ServletTask" method="post">
        <input type="text" name="task" placeholder="Enter task description" required>
        <input type="submit" value="Add Task">
    </form>
    <ul id="task-list">
        <!-- Tasks will be dynamically added here -->
        <% if (tasks != null && !tasks.isEmpty()) {
            for (String task : tasks) { %>
        <li>
            <%= task %>
            <form method="post" action="">
                <input type="hidden" name="taskDescription" value="<%= task %>">
                <input type="submit" class="delete-task" value="Delete" name="deleteTask" onclick="return confirm('Are you sure you want to delete this task?');">
            </form>
            <form method="post" action="">
                <input type="hidden" name="taskDescription" value="<%= task %>">
                <input type="text" name="new-task" >
                <input type="submit" class="edit-task" value="edit" name="editTask" onclick="return confirm('Are you sure you want to edit this task?');">
            </form>
        </li>
        <% }
        } else { %>
        <li>No tasks found</li>
        <% } %>
    </ul>
</div>

<%
    // Handle task deletion
    String taskDescriptionToDelete = request.getParameter("taskDescription");
    String deletetask = request.getParameter("deleteTask");
    if (deletetask != null){
    if (taskDescriptionToDelete != null) {
        try {
            // database connection
            String hostname = "localhost";
            String port = "3306";
            String usern = "root";
            String password = "root";
            String schema = "db";
            // using jdbc to connect to database
            Class.forName("com.mysql.cj.jdbc.Driver");

            String connectionUrl = String.format("jdbc:mysql://%s:%s/%s?useSSL=false", hostname, port, schema);
            Connection connection = DriverManager.getConnection(connectionUrl, usern, password);
            String deleteSql = "DELETE FROM tasks WHERE task = ?";
            PreparedStatement deleteStatement = connection.prepareStatement(deleteSql);
            deleteStatement.setString(1, taskDescriptionToDelete);
            int rowsAffected = deleteStatement.executeUpdate();

            // Close resources
            deleteStatement.close();
            connection.close();

            // Reload the page after deletion
            response.sendRedirect(request.getRequestURI());
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }}
    String taskDescriptionToEdit = request.getParameter("taskDescription");
    String editTaskClicked = request.getParameter("editTask");
    String newtask = request.getParameter("new-task");
    if (editTaskClicked != null){
        if (taskDescriptionToEdit != null) {
            try {
                // database connection
                String hostname = "localhost";
                String port = "3306";
                String usern = "root";
                String password = "root";
                String schema = "db";
                // using jdbc to connect to database
                Class.forName("com.mysql.cj.jdbc.Driver");

                String connectionUrl = String.format("jdbc:mysql://%s:%s/%s?useSSL=false", hostname, port, schema);
                Connection connection = DriverManager.getConnection(connectionUrl, usern, password);
                String deleteSql = "UPDATE tasks SET task = ? WHERE task = ?";
                PreparedStatement deleteStatement = connection.prepareStatement(deleteSql);
                deleteStatement.setString(1, newtask);
                deleteStatement.setString(2, taskDescriptionToEdit);
                int rowsAffected = deleteStatement.executeUpdate();

                // Close resources
                deleteStatement.close();
                connection.close();


            } catch (SQLException | ClassNotFoundException e) {
                e.printStackTrace();
            }
        }
    }
%>

</body>
</html>