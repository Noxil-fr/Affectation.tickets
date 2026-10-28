# Affectation des tickets

Page web pour importer des tickets depuis Excel, les affecter à une personne, valider des sessions et suivre les statistiques du mois et de l'année.

- **Page** : un seul fichier `index.html`, hébergé sur GitHub Pages.
- **Connexion et données** : Supabase. Les tickets, sessions, archives et le journal sont partagés entre tous les utilisateurs.
- **Accès** : sur invitation uniquement. Sans compte, on ne voit que l'écran de connexion et aucune donnée n'est lisible : les droits sont vérifiés par la base.

## Rôles

| Action | Utilisateur | Administrateur |
|---|:---:|:---:|
| Importer, affecter, valider une session | ✓ | ✓ |
| Annuler son dernier import ou sa dernière validation | ✓ | ✓ |
| Supprimer une session, vider les tickets | | ✓ |
| Modifier le modèle de colonnes | | ✓ |

Les actions importantes sont inscrites dans le **journal** (roue crantée en haut à droite) avec l'auteur et l'heure. Le journal ne peut être ni modifié ni effacé depuis l'application.

## Mise en place

### 1. Créer le projet Supabase
1. Sur [supabase.com](https://supabase.com), créez un projet en **région Europe** (Francfort ou Paris).
2. **Authentication → Sign In / Providers** : désactivez **Allow new users to sign up**. Seuls les comptes invités pourront se connecter.
3. **SQL Editor → New query** : collez le contenu de [`supabase/schema.sql`](supabase/schema.sql), puis cliquez sur **Run**.
4. Exécutez de la même façon les mises à jour, dans l'ordre :
   - [`supabase/002_tickets_pris.sql`](supabase/002_tickets_pris.sql) : tickets pris directement par les consultants (onglet Statistiques).

### 2. Renseigner la page
Dans `index.html`, remplacez ces deux valeurs par celles de **Project Settings → API** :

```js
var SUPABASE_URL = 'https://VOTRE-PROJET.supabase.co';
var SUPABASE_ANON_KEY = 'VOTRE-CLE-ANON';
```

La clé **anon** (publique) est prévue pour être dans la page. N'y mettez **jamais** la clé `service_role`.

### 3. Publier sur GitHub Pages
1. Poussez le dépôt sur GitHub.
2. **Settings → Pages** : *Deploy from a branch*, branche `main`, dossier `/ (root)`.
3. Notez l'adresse du site, par exemple `https://mon-org.github.io/affectation-tickets/`.

### 4. Relier Supabase au site
**Authentication → URL Configuration** :
- **Site URL** : l'adresse GitHub Pages.
- **Redirect URLs** : la même adresse.

Sans ce réglage, les liens d'invitation et de mot de passe oublié ne ramènent pas sur le site.

### 5. Inviter les utilisateurs
1. **Authentication → Users → Invite user** : saisissez l'e-mail. La personne reçoit un lien, arrive sur le site et choisit son mot de passe.
2. Pour nommer un administrateur (**SQL Editor**) :
   ```sql
   update public.members set role = 'admin' where email = 'prenom.nom@exemple.com';
   ```
3. Si un compte existait **avant** l'exécution du script, ajoutez-le à la main :
   ```sql
   insert into public.members (user_id, email, role)
   select id, email, 'admin' from auth.users where email = 'prenom.nom@exemple.com';
   ```

Pour retirer un accès, supprimez l'utilisateur dans **Authentication → Users**.

### 6. Reprendre les données de l'ancienne version
Si des tickets ont été saisis avec l'ancienne version (sans connexion), ouvrez le site **dans ce même navigateur** avec un compte administrateur. La roue crantée propose alors **Envoyer ces données dans la base**.

## À savoir
- **E-mails** : l'envoi intégré de Supabase est limité à quelques e-mails par heure. Pour inviter beaucoup de monde d'un coup, configurez un serveur SMTP (**Authentication → Emails → SMTP Settings**).
- **Offre gratuite** : le projet se met en pause après 7 jours sans activité (réactivation en un clic) et n'a pas de sauvegarde automatique. Utilisez régulièrement **Exporter → Sauvegarder (JSON)**, ou passez à l'offre Pro.
- **Annuler** : n'annule que les éléments touchés par la dernière opération. Les modifications des autres utilisateurs sur d'autres tickets sont conservées.
