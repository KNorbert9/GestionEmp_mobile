@component('mail::message')
<p>Hello {{ $user->name }},</p>

Veuillez vérifier valider votre adresse mail grâce à ce lien
@component('mail::button', ['url' => url('api/verify/' . $user->remember_token)])
Verifier
@endcomponent

<p>Merci</p>

@endcomponent
