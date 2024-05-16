<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Réinitialiser le mot de passe</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 400px;
            margin: 50px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        h1 {
            font-size: 24px;
            margin-bottom: 20px;
            text-align: center;
        }

        form {
            display: flex;
            flex-direction: column;
        }

        label {
            font-size: 16px;
            margin-bottom: 8px;
        }

        input[type="password"] {
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 16px;
        }

        button[type="submit"] {
            padding: 12px 20px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
        }

        button[type="submit"]:hover {
            background-color: #0056b3;
        }
    </style>
    <script>
        function validatePasswords() {
            const passwordInput = document.getElementById('password');
            const confirmPasswordInput = document.getElementById('confirm-password');
            if (passwordInput.value !== confirmPasswordInput.value) {
                confirmPasswordInput.setCustomValidity('Les mots de passe ne correspondent pas.');
            } else {
                confirmPasswordInput.setCustomValidity('');
            }
        }
    </script>
</head>

<body>
    <div class="container">
        <h1>Réinitialiser le mot de passe</h1>
        <form method="POST" action="{{ route('password.resetConfirm') }}"> @csrf <input type="hidden" name="token"
                value="{{ $token }}"> <label for="password">Nouveau mot de passe:</label> <input type="password"
                id="password" name="password" oninput="validatePasswords()"> <label for="confirm-password">Confirmer le
                mot de passe:</label> <input type="password" id="confirm-password" name="confirm-password"
                oninput="validatePasswords()"> <button type="submit">Réinitialiser le mot de passe</button> </form>
    </div>
</body>

</html>
