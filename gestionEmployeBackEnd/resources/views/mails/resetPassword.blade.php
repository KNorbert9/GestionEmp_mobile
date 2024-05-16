@component('mail::message')

    <p>{{ $resetUrl }}</p>

    Veuillez cliquer sur le bouton ci-dessous pour réinitialiser votre mot de passe :

    @component('mail::button', ['url' => $resetUrl])
        Réinitialiser le mot de passe
    @endcomponent

    Si vous n'avez pas demandé de réinitialisation de mot de passe, ignorez simplement cet e-mail.

    Merci,<br>
    {{ config('app.name') }}

@endcomponent
