# Atelier Boucherie : version Supabase + Netlify

Contenu du dossier
- index.html : l'application complète (connexion formateur + base Supabase)
- 01_schema_complet.sql : tables, règles d'accès et temps réel (relançable sans risque)
- students.csv, records.csv, photos.csv : vos données actuelles (55 élèves, 547 enregistrements, 54 photos)

## 1. Supabase
1. SQL Editor > New query : collez tout 01_schema_complet.sql > Run.
2. Table Editor : importez les CSV dans cet ordre, avec « Import data from CSV » :
   students.csv dans `students`, puis records.csv dans `records`, puis photos.csv dans `photos`.
3. Authentication > Users > Add user : créez un compte (e-mail + mot de passe) par formateur.
   Dans les réglages d'authentification, désactivez les inscriptions libres (« Allow new users to sign up »).
4. Project Settings > API : copiez l'adresse du projet (Project URL, de la forme https://xxxx.supabase.co).

## 2. Le fichier index.html
Ouvrez index.html dans un éditeur de texte et remplacez, tout en haut du bloc APP_CONFIG,
https://VOTRE-PROJET.supabase.co par l'adresse de votre projet.
La clé publiable (sb_publishable_...) est déjà renseignée ; remplacez-la si vous en créez une autre.
Ne collez JAMAIS la clé secrète (sb_secret_...) dans ce fichier.

## 3. Netlify
1. app.netlify.com > Add new site > Deploy manually : glissez le dossier qui contient index.html.
2. Ouvrez l'adresse fournie : l'écran de connexion apparaît, entrez l'e-mail et le mot de passe d'un formateur.
3. Le code PIN n'est pas repris de l'ancienne version : il sera à recréer à la première ouverture de « Élèves & groupes ».

## Doublons éventuels à Lille, groupe du mardi, semaine 9
14 enregistrements du 10/11/2026 existent en double. Après avoir choisi quelle version garder, supprimez les anciens :
    delete from public.records
    where id > 1000000000000 and site = 'Lille' and groupe = 'groupe du mardi' and date = '2026-11-10';
(ne lancez cette commande qu'après avoir décidé : elle supprime la version saisie dans l'application, pas l'import du CSV d'origine.)
