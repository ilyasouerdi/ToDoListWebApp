
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(to left, #000000, #525151);

            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .container {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            width: 300px;
        }

        .container h2 {
            margin-bottom: 20px;
            text-align: center;
        }

        .container input[type="text"],
        .container input[type="password"],
        .container input[type="submit"] {
            width: calc(100% - 22px); /* Adjusted width to match the text inputs */
            padding: 10px;
            margin-bottom: 10px;
            margin-left: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        .container input[type="submit"] {
            background-color: #007bff;
            color: #fff;
            border: none;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .container input[type="submit"]:hover {
            background-color: #0056b3;
        }

    </style>
</head>z
<body>
<div class="container">
    <h2>Login</h2>
    <form action="Servlet" method="post">
        <input type="text" name="username" placeholder="Username" required>
        <input type="password" name="password" placeholder="Password" required>
        <input type="submit" value="Login">
    </form>
</div>
</body>
</html>
