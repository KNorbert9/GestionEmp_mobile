<!-- resources/views/email_already_verified.blade.php -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Email Déjà Vérifié</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow-sm">
                    <div class="card-body text-center">
                        <h1 class="text-warning">Email déjà vérifié</h1>
                        <p class="mt-3">Votre adresse email a déjà été vérifiée. Vous pouvez vous connecter à votre compte.</p>
                        <a href="/login" class="btn btn-primary mt-4">Se connecter</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
