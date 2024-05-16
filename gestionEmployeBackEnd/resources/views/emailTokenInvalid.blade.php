<!-- resources/views/invalid_token.blade.php -->
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Jeton Invalide</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
</head>

<body class="bg-light">
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow-sm">
                    <div class="card-body text-center">
                        <h1 class="text-danger">Jeton invalide</h1>
                        <p class="mt-3">Le lien de vérification est invalide ou a expiré. Veuillez demander un nouveau
                            lien de vérification.</p>
                        <form id="resendVerificationForm">
                            <input type="email" name="email" class="form-control mt-3"
                                placeholder="Entrez votre adresse email" required>
                            <button type="submit" class="btn btn-primary mt-4">Renvoyer le lien de
                                vérification</button>
                        </form>
                        <div id="responseMessage" class="mt-3"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        $(document).ready(function() {
            $('#resendVerificationForm').on('submit', function(event) {
                event.preventDefault();


                $.ajax({
                    url: '/api/resend-verification',
                    type: 'POST',
                    data: {
                        email: $('input[name="email"]').val(),
                    },
                    success: function(response) {
                        $('#responseMessage').text(response.message).addClass('text-success');
                    },
                    error: function(xhr) {
                        $('#responseMessage').text(xhr.responseJSON.message).addClass(
                            'text-danger');
                    }
                });
            });
        });
    </script>
</body>

</html>
