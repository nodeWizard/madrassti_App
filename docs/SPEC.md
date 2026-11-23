# Madrassti — Spécification extraite des maquettes

Source: `../mockups/` — 6 fichiers HTML (et non 5), exportés d'un canvas de design.
Reference frame: **390 × 844** (sauf « page entière » : 390 × 1260).
Langue d'interface: **français**. Rôles: **Parent**, **Élève**, **Enseignant**.

> Ce document est la source de vérité pour l'implémentation Flutter. Toutes les valeurs
> ci-dessous sont extraites des attributs `style="…"` inline et des fonctions `renderVals()`
> des maquettes, sans interprétation.

---

## 0. Comment les maquettes ont été lues

Les 6 fichiers sont des bundles imbriqués, pas du HTML lisible directement :

```
fichier.html
└── <script type="__bundler/manifest">   → { uuid: {mime, compressed, data: base64(gzip)} }
    └── pour chaque écran : un HTML       (lui-même un bundle)
        ├── <script type="__bundler/template">  → LE MARKUP RÉEL de l'écran
        ├── text/javascript × 3                 → runtime partagé (identique sur les 25 boards)
        ├── text/html × n                       → sous-composants (Nav, Icon, Subject, Zitoun)
        └── font/woff2 × n                      → Fredoka, Nunito, Baloo Bhaijaan 2
```

La logique de chaque écran (`class Component extends DCLogic { renderVals() {…} }`) se trouve
en fin de `template`, dans un `<script type="text/x-dc">`, avec ses `data-props`.
Le langage de template utilise `{{var}}`, `<sc-if value="…">`, `<sc-for list="…" as="…">`,
`<dc-import name="…">`.

---

## 1. Inventaire des écrans

### 1.1 Correspondance avec la liste attendue

| # | Titre maquette | Rôle | Fichier source | Attendu ? |
|---|---|---|---|---|
| 1 | Splash | onboarding | onboarding.html | ✅ |
| 2 | Bienvenue | onboarding | onboarding.html | ✅ |
| 3 | Choix du rôle | onboarding | onboarding.html | ✅ |
| 4 | Accueil parent | parent | Direction créative… | ✅ |
| 4b | Accueil parent — page entière | parent | Direction créative… | ✅ *(même écran, `full=true`)* |
| 5 | Semaine | parent | Direction créative… | ✅ |
| 6 | Leçons et documents | parent | Direction créative… | ✅ |
| 7 | Notifications | parent | Direction créative… | ✅ |
| 8a | Messages | parent | Direction créative… | ✅ |
| 8b | Conversation | parent | Direction créative… | ✅ |
| 9 | Profil de l'enfant | parent | Direction créative… | ✅ |
| 10 | Accueil élève | élève | espaceEtudiant.html | ✅ |
| 11 | Ma semaine | élève | espaceEtudiant.html | ✅ |
| 12 | Mes leçons | élève | espaceEtudiant.html | ✅ |
| 13 | Mes alertes | élève | espaceEtudiant.html | ✅ |
| 14 | Accueil enseignant | enseignant | espaceEnseignat.html | ✅ |
| 15 | Publier une leçon | enseignant | espaceEnseignat.html | ✅ |
| 16 | Absence ou changement | enseignant | espaceEnseignat.html | ✅ |
| 17 | Messages enseignant | enseignant | espaceEnseignat.html | ✅ |
| 18 | Modération IA | partagé | mederateur.html | ✅ |
| 19 | Profil et réglages | partagé | mederateur.html | ✅ |

**Composants** (composants.html) : `Zitoun` (mascotte), `Subject` (pastille matière),
`Icon` (39 glyphes), `Nav` (barre de navigation).

**Rien ne manque, rien n'est en trop** par rapport à la liste attendue.
`4b` est confirmé comme n'étant pas un écran séparé : son template importe
`Accueil parent` avec `full=true`, ce qui ne change que `rootH: auto` et `scrollY: visible`.

### 1.2 Graphe de navigation (tous les `href` des maquettes)

```
Splash ──→ Welcome ──→ Role ──┬─→ Dashboard      (parent)
                        ▲     ├─→ StudentHome    (élève)
                        │     └─→ TeacherHome    (enseignant)
                   (Passer)

PARENT   Dashboard ──→ Notifications, Week, Lessons, Chat
         Week, Lessons, Notifications, Messages ──→ Chat
         Messages ──→ Chat ×3, Notifications (annonces, lecture seule)
         Chat ──→ Messages, Lessons
         Settings ──→ ChildProfile ×2, Role, StudentHome, Splash (déconnexion)
         ChildProfile ──→ Settings, Chat, "#" (appeler l'école)

ÉLÈVE    StudentHome ──→ Role (quitter le mode enfant), StudentLessons, StudentWeek
         StudentNotifs ──→ StudentLessons

ENSEIGN. TeacherHome ──→ TeacherPublish, TeacherAbsence, TeacherMessages, Chat
         TeacherPublish / TeacherAbsence ──→ TeacherHome (retour + feuille de succès)
         TeacherMessages ──→ Chat
```

Barres de navigation (composant `Nav`) :

| Rôle | Onglets (`id`, icône, libellé, cible, badge) |
|---|---|
| parent | home/home/Accueil/Dashboard · week/calendar/Semaine/Week · lessons/book/Leçons/Lessons · messages/message/Messages/Messages **(2)** · profile/user/Profil/Settings |
| eleve | home/home/Accueil/StudentHome · week/calendar/Ma semaine/StudentWeek · lessons/book/Leçons/StudentLessons · alerts/bell/Alertes/StudentNotifs **(1)** |
| enseignant | home/home/Accueil/TeacherHome · publish/upload/Publier/TeacherPublish · change/swap/Changements/TeacherAbsence · messages/message/Messages/TeacherMessages **(5)** · profile/user/Profil/Settings |

---

## 2. Design tokens

### 2.1 Couleurs

Fréquences mesurées sur l'ensemble des maquettes (occurrences dans les styles inline).

#### Marque / structure
| Token | Hex | Usage (occurrences) |
|---|---|---|
| `navy` | `#1B2559` | encre principale, surfaces sombres, boutons secondaires (186) |
| `navyCard` | `#26336E` | cartes sur fond navy (6) |
| `navyDeep` | `#222F6B` | cercles décoratifs sur navy (3) |
| `navyShadow` | `#0E1640` | ombre 3px du bouton navy (2) |
| `navyTrack` | `#3A4785` | fond de barre de progression sur navy (2) |
| `white` | `#FFFFFF` | surfaces (154) |
| `bg` | `#EEF5FF` | fond d'écran général (36) |
| `yellow` | `#FFC83D` | accent primaire, boutons, pilule nav active (52) |
| `yellowShadow` | `#E0A51A` | ombre 3px/4px sous le jaune (15) |
| `yellowDark` | `#F0B323` | détail mascotte (cartable) (2) |

#### Texte
| Token | Hex | Usage |
|---|---|---|
| `ink` | `#1B2559` | texte principal |
| `inkMuted` | `#3A4570` | corps de texte secondaire (26) |
| `inkSubtle` | `#5A6488` | méta, labels (69) |
| `onNavy` | `#FFFFFF` | texte sur navy |
| `onNavyMuted` | `#C9D1EE` | sous-titre sur navy (4) |
| `onNavySubtle` | `#A9B3D6` | méta sur navy (12) |

#### Bordures / séparateurs
| Token | Hex | Usage |
|---|---|---|
| `shadowBlue` | `#D6E4F7` | ombre 2px des cartes blanches (34) |
| `divider` | `#EEF2FA` | séparateur 1.5px en liste (14) |
| `borderField` | `#C9D6EC` | bordure 1.5px des champs (10) |
| `borderCard` | `#D6E4F7` | bordure 1.5px des cartes |
| `borderDashed` | `#A9C3E6` | bordure 2px pointillés (3) |
| `dashNavy` | `#56628F` | pointillés « Pause » sur navy (3) |
| `fieldBg` | `#F7FAFF` | fond des inputs de chat (3) |
| `chipBg` | `#F3F6FC` | fond de puce neutre (3) |

#### Sémantique
| Token | Hex | Usage |
|---|---|---|
| `success` | `#1E7A57` | vert validé, interrupteur actif (37) |
| `successTint` | `#D9F5E8` | fond vert (26) |
| `successTint2` | `#EDFAF3` | fond proposition modération (2) |
| `successBorder` | `#A9E5CB` | bordure proposition / ombre 4px (2) |
| `info` | `#1F5FBF` | bleu liens / icônes (36) |
| `infoTint` | `#DCEBFF` | fond bleu (23) |
| `infoTint2` | `#A9D1FF` | pastille annonce, points inactifs (2) |
| `danger` | `#B83C30` | rouge texte (29) |
| `dangerStrong` | `#C8473A` | badge non-lu (8) |
| `dangerDot` | `#E8604F` | point « changement » onglet jour (1) |
| `coral` | `#FF7A6B` | icône alerte, contour « Nouveau » (12) |
| `coralTint` | `#FFE9E5` | fond carte d'alerte (5) |
| `coralBorder` | `#FFC2B8` | bordure 1.5px carte d'alerte (5) |
| `coralLogout` | `#E6B3AC` | bordure bouton déconnexion (1) |
| `warn` | `#8A5A00` | brun/or texte (19) |
| `warnTint` | `#FFF0C7` | fond or (18) |
| `warnTint2` | `#FFF8E4` | aperçu « horaire modifié » (1) |
| `warnBorder` | `#F3D88A` | bordure/ombre or (2) |
| `warnRow` | `#FFF6DA` | ligne « en cours » agenda enseignant (1) |

#### Matières (pastille `Subject` — tint / ink / glyphe)
| Code | Nom | tint | ink | glyphe | police | k (taille) |
|---|---|---|---|---|---|---|
| `ar` | Arabe | `#FFE1DC` | `#B83C30` | `ع` | Baloo Bhaijaan 2 | 0.56 |
| `fr` | Français | `#FFF0C7` | `#8A5A00` | `Aa` | Fredoka | 0.42 |
| `ma` | Mathématiques | `#DCEBFF` | `#1F5FBF` | `1+2` | Fredoka | 0.34 |
| `ev` | Éveil scientifique | `#D9F5E8` | `#1E7A57` | icône `flask` | — | 0.5 |
| `art` | Arts | `#FFE3EE` | `#A8326A` | icône `palette` | — | 0.5 |
| `sp` | Sport | `#E3E7F5` | `#1B2559` | icône `ball` | — | 0.5 |

`Subject`: `radius = round(size × 0.32)`, `fontSize = round(size × k)`,
`iconSize = round(size × 0.5)`, stroke icône `2.2`.

**⚠️ Second jeu de teintes matières** — l'écran 5 (Semaine) utilise des lavis plus clairs
pour le fond des blocs horaires, distincts des teintes de pastille :
`ar #FFF4F2` · `fr #FFF9E6` · `ma #EEF5FF` · `ev #EDFAF3` · `art #FFF1F6` · `sp #F1F3FA`.
Les deux jeux coexistent (la pastille garde sa teinte saturée **dans** le bloc clair).
→ Deux tokens séparés : `SubjectTints` et `SubjectWashes`.

#### Couleurs de bandeau de document (écran 6)
`fr #FFC83D` · `ma #5B9BEA` · `ar #FF7A6B` · `ev #7FD8B4`
(+ `#E3EAF6` bordure vignette)

#### Mascotte Zitoun
`body #3FA97C` · `highlight #8FDDB8` · `leaf #7FD8B4` · `leafStroke #2E5E46` ·
`satchel #FFC83D` / `#F0B323` · `blush #FF7A6B @0.6` · `eye/feet #1B2559` ·
`shadow #1B2559 @0.12`

### 2.2 Typographie

Polices embarquées dans le bundle (Google Fonts, woff2) :

| Famille | Graisses disponibles | Usage |
|---|---|---|
| **Fredoka** | 500, 600, **700** | titres, chiffres, glyphes `Aa`/`1+2` |
| **Nunito** | 400, 600, 700, **800** | corps de texte, libellés, boutons |
| **Baloo Bhaijaan 2** | 600, **700** | texte arabe (`ع`, `مدرستي`, `الحرف ب`) |

Graisses réellement utilisées dans le markup : Fredoka 600 (72×) et 700 (8×) ·
Nunito 700 (4×) et 800 (18×) · Baloo 700 (3×). Nunito 400/600 viennent de l'héritage
`body` et des `font-weight` sans famille explicite (600/700 fréquents).

Échelle de tailles observée (occurrences) :

| px | occ. | Rôle typique |
|---|---|---|
| 9 | 2 | badge type de doc |
| 10 | 2 | badge nav, kicker |
| 11 | 26 | kicker majuscule, méta sur navy, badge |
| 12 | 48 | méta, libellé nav parent, en-tête de section |
| 13 | 41 | sous-titre, méta |
| 14 | 69 | corps de liste, bouton secondaire |
| 15 | 48 | corps, libellé de réglage |
| 16 | 23 | **corps minimum (inputs, texte de slide)** |
| 17 | 17 | bouton primaire, valeur de champ |
| 18 | 9 | titre de section |
| 19 | 12 | titre de carte |
| 20 | 13 | titre de section (Fredoka 600) |
| 21 | 3 | titre élève |
| 22 | 5 | titre |
| 24 | 4 | titre d'écran (enseignant) |
| 26 | 8 | titre d'écran, grand chiffre |
| 28 | 7 | titre d'écran (parent/onboarding) |
| 30 | 1 | glyphe arabe dans la timeline |
| 32 | 3 | titre élève (Fredoka 700) |
| 34 | 3 | titre élève « Salut Lina ! », « Arts » |
| 36 | 1 | initiale avatar profil enfant |
| 56 | 1 | logotype « madrassti » (Fredoka 700, letter-spacing −0.02em) |

Interlignes utilisés : `1`, `1.1`, `1.15`, `1.2`, `1.25`, `1.3`, `1.4`, `1.45`, `1.5`, `1.55`.
Letter-spacing : `0.08em` (kickers majuscules), `0.1em` (en-têtes de section), `−0.02em` (logo).

### 2.3 Rayons

| px | occ. | Usage |
|---|---|---|
| 2, 3, 4, 5, 6 | 20 | barres de progression, petits détails, coin de bulle |
| 8, 9 | 15 | segments de timeline, badge |
| 10, 11, 12 | 11 | vignette doc, puce |
| 13, 14 | 24 | pastille 40px, bouton d'alerte |
| 15, 16, 17 | 48 | champs, boutons icône 48px, carte |
| 18 | 32 | **bouton primaire 56px**, carte, cloche 52px |
| 20 | 22 | carte, chip, pilule nav |
| 22 | 19 | carte d'alerte, section |
| 24 | 15 | carte, feuille, bouton rôle |
| 26, 28, 30 | 15 | grande carte, feuille modale, section élève |
| `50%` | 37 | avatars, boutons ronds, points |

Composés : `24px 24px 0 0` (nav, barre d'envoi) · `0 0 24px 24px` (en-tête chat) ·
`28px 28px 0 0` (feuille de succès) · `30px 30px 0 0` (feuille de modération) ·
`20px 20px 20px 6px` (bulle reçue) · `20px 20px 6px 20px` (bulle envoyée) ·
`22px 22px 22px 6px` (bulle Zitoun élève).

### 2.4 Ombres

| Ombre | occ. | Usage |
|---|---|---|
| `0 2px 0 #D6E4F7` | 16 | **carte blanche posée** (signature du design) |
| `0 3px 0 #E0A51A` | 13 | **bouton primaire jaune** |
| `0 3px 0 #D6E4F7` | 1 | bulle Zitoun élève |
| `0 3px 0 #0E1640` | 1 | bouton navy enseignant |
| `0 4px 0 #E0A51A` | 2 | bouton rond élève (plus épais) |
| `0 4px 0 #1B2559` | 2 | carte sélectionnée (rôle, matière élève) |
| `0 4px 0 #F5C2D6` / `#A9E5CB` / `#F3D88A` | 3 | grandes cartes élève teintées |
| `0 1px 3px rgba(27,37,89,.25)` | 3 | pouce d'interrupteur |
| `0 -4px 16px rgba(27,37,89,.08)` | 3 | nav / barre collée en bas |
| `0 -4px 16px rgba(27,37,89,.06)` | 2 | barre d'envoi chat |
| `0 4px 16px rgba(27,37,89,.06)` | 2 | en-tête chat |
| `0 8px 20px rgba(27,37,89,.1)` | 2 | carte flottante (slide 3) |
| `0 10px 24px rgba(27,37,89,.1)` / `.14` | 2 | cartes inclinées (slide 2) |
| `0 12px 28px rgba(27,37,89,.22)` | 1 | carte inclinée (slide 1) |
| `0 0 0 2.5px #FFC83D` | 2 | **anneau « en cours »** |
| `0 0 0 3px #FFC83D` | 2 | anneau élève (leçon/cours actuel) |
| `0 0 0 3px #FFFFFF, 0 0 0 6px #FFC83D` | 1 | double anneau étape actuelle (élève) |
| `0 0 0 3px #FF7A6B` | 1 | contour carte « Nouveau » (alertes élève) |

> Les ombres `0 Npx 0 <couleur>` sont des **ombres dures sans flou** — à rendre avec
> `BoxShadow(offset: Offset(0, N), blurRadius: 0)`. Les anneaux `0 0 0 Npx` sont des
> **bordures extérieures** → `Border.all` sur un conteneur externe ou `BoxShadow(spreadRadius: N)`.

### 2.5 Espacements

Gaps flex (occurrences) : `2`(25) `3`(7) `4`(27) `5`(3) `6`(24) `8`(59) `10`(41)
`12`(53) `14`(24) `16`(10) `18`(5).

Paddings d'écran :
- parent / enseignant : `20px 16px 24px` (main scrollable)
- élève : `18px 16px 20px`
- onboarding : `20px 20px 28px`
- barre collée en bas : `14px 16px 22px` ou `12px 12px 20px`
- nav : `8px 6px 18px`

Échelle retenue : **2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 24, 28**.

---

## 3. Composants partagés

### 3.1 `Zitoun(size, mood)` — mascotte
viewBox **120 × 130**, `aria-label="Zitoun, la mascotte de Madrassti"`.
Props: `size` (24–600, défaut 240), `mood` ∈ `content | salut | bravo`.

Construction par opacités (un seul SVG, groupes allumés/éteints) :

| Groupe | content | salut | bravo |
|---|---|---|---|
| bras gauche baissé (`armDownOp`) | 1 | 0 | 0 |
| bras gauche levé (`waveOp`) | 0 | 1 | 1 |
| bras droit baissé (`rightDownOp`) | 1 | 1 | 0 |
| bras droit levé (`rightUpOp`) | 0 | 0 | 1 |
| yeux ouverts (`openOp`) | 1 | 1 | 0 |
| yeux rieurs (`happyOp`) | 0 | 0 | 1 |
| sourire simple (`smileOp`) | 1 | 1 | 0 |
| grand sourire (`grinOp`) | 0 | 0 | 1 |

Éléments fixes (ordre de peinture) : ombre au sol `ellipse(58,124,28,4) #1B2559 @.12` →
cartable `rect(78,50,30,44,r10) #FFC83D` + rabat `rect(78,50,30,15,r7) #F0B323` +
fermoir `rect(90,61,6,6,r1.5) #1B2559` → bras → pieds `ellipse(46|70,117,10,5.5) #1B2559` →
corps `ellipse(58,74,36,42) #3FA97C` → reflet `ellipse(42,52,7,11) #8FDDB8 rotate(20°)` →
bretelle `path #F0B323 w5` → tige `path #2E5E46 w4` → feuille `path #7FD8B4` + nervure →
yeux → joues `ellipse(36|80,86,6,4) #FF7A6B @.6` → bouche.

### 3.2 `AppIcon(name, size, stroke)` — 39 glyphes
viewBox `0 0 24 24`, `fill: none`, `stroke: currentColor`, `stroke-linecap: round`,
`stroke-linejoin: round`, `stroke-width` paramétrable (1–3, défaut **2**, pas 0.25).

Liste complète (39 issus des maquettes) : `bell home calendar book message user users clock
pin swap mega file chevron back check pencil download upload send plus search settings logout
globe shield sparkle school x clip lock speaker flask palette ball phone info alert moon sun`

**+ 2 glyphes ajoutés** (cf. B2, pour Login) : `eye`, `eye-off` — mêmes conventions.

Les 39 tracés `path/circle/rect` exacts sont dans la maquette `composants.html` → `Icon`
et seront transcrits littéralement (voir §7 pour la stratégie de rendu).

Tailles d'usage : 12, 13, 16, 18, 20, 22, 24, 26, 28, 32, 36.
Strokes d'usage : 2 (défaut), 2.2 (pastille), 2.5, 3, 3.5.

### 3.3 `SubjectTile(subj, size)`
Voir table §2.1. `inline-flex`, centré, `flex: none`, `role="img"`, `aria-label` = nom complet.

### 3.4 `RoleBottomNav(role, active)`
`background #FFFFFF`, `border-radius 24px 24px 0 0`,
`box-shadow 0 -4px 16px rgba(27,37,89,.08)`, `padding 8px 6px 18px`,
grille `repeat(n, 1fr)`, `n` = nombre d'onglets.

Par onglet : colonne, `gap 4px`, `min-height 56px`, couleur `#1B2559` si actif sinon `#5A6488`,
`font-weight 800`. Pilule : `border-radius 20px`, fond `#FFC83D` si actif sinon transparent.
Badge : `top 0, right 8px`, `min-width 16px`, `height 16px`, `r 8px`, `#C8473A`/blanc, 10px/800.

| | parent / enseignant | élève |
|---|---|---|
| pilule | 56 × 32 | **68 × 44** |
| icône | 22 | **28** |
| libellé | 12px | **14px** |
| hauteur totale | 82 | **96** |

### 3.5 Boutons
| Variante | Spéc. |
|---|---|
| **Primaire (jaune)** | `h 56`, `r 18`, `bg #FFC83D`, `fg #1B2559`, `17px/800`, `shadow 0 3px 0 #E0A51A` |
| **Primaire compact** | `h 48`, `r 16`, mêmes couleurs, `15px/800`, même ombre |
| **Navy** | `h 56/60`, `r 18`, `bg #1B2559`, `fg #FFF`, `800`, `shadow 0 3px 0 #0E1640` |
| **Navy compact** | `h 44/48`, `r 14`, `bg #1B2559`, `fg #FFF`, `14px/800`, sans ombre |
| **Contour** | `h 48/52/56`, `r 14/16/18`, `border 1.5px #1B2559`, fond transparent, `fg #1B2559`, `800` |
| **Contour danger** | `h 56`, `r 18`, `border 1.5px #E6B3AC`, `bg #FFF`, `fg #B83C30` |
| **Pointillés** | `h 56`, `r 18`, `border 2px dashed #A9C3E6`, `fg #1F5FBF`, `15px/800` |
| **Rond élève** | `48/52/56/60 px`, `r 50%`, `bg #FFC83D`, `shadow 0 3px 0`/`0 4px 0 #E0A51A` |
| **Icône carré** | `44/48 px`, `r 14/16`, `bg #EEF5FF` ou `#F3F6FC`, `fg #1B2559` |

### 3.6 Puces d'état (chips)
`En cours` `h24 r12 #FFC83D/#1B2559 11px/800` ·
`Modifié` `h24 r12 #FFE1DC/#B83C30 11px/800` ·
`Nouveau` `h22 r11 #D9F5E8/#1E7A57 11px/800` ·
`Nouveau !` (élève) `h24 r12 #FFC83D 12px/800` ·
`Hors connexion` `h22 r11 #EEF5FF/#1F5FBF 11px/800` + icône check 12/stroke 3 ·
`1 nouvelle` (élève) `h26 r13 #1E7A57/#FFF 13px/800` ·
classe `h20 r10 #EEF5FF/#1F5FBF 11px/800` ·
statut journée `h28 r14` + point 8px, couleurs selon état.

### 3.7 Interrupteur (switch)
Piste `52 × 32`, `r 16`, `padding 3px`, fond `#1E7A57` (on) / `#C9D6EC` ou `#A9B3D6` (off),
`justify-content: flex-end|flex-start`. Pouce `26 × 26`, `r 50%`, `#FFFFFF`,
`shadow 0 1px 3px rgba(27,37,89,.25)`. Variante verrouillée : piste pleine `#1E7A57`
avec icône `lock` 16/stroke 2.5 centrée, pas de pouce.

### 3.8 Ligne de notification
`padding 12px 8px`, `gap 12px`, `align-items: flex-start`,
`border-top: 1.5px solid #EEF2FA` sauf la première.
Pastille `40 × 40`, `r 13`, teinte/encre selon catégorie.
Titre `14px/800` · heure `12px/700 #5A6488 nowrap` · corps `14px/1.4 #3A4570`.
Point non-lu `9 × 9`, `r 50%`, `#C8473A`, `margin-top 6px`.
Conteneur de liste : `#FFFFFF`, `r 22`, `padding 4px 6px`.

### 3.9 Carte d'alerte (corail)
`bg #FFE9E5`, `border 1.5px #FFC2B8`, `r 22`, `padding 16`, `gap 14`.
Icône `44 × 44`, `r 14`, `bg #FF7A6B`, `fg #1B2559`.
Kicker `12px/800`, `letter-spacing .08em`, majuscules, `#B83C30`.
Titre Fredoka 600 `18px/1.25` · corps `14px/1.45 #3A4570`.
Actions : bouton navy compact `h48 r14` + bouton contour `h48 r14`.

---

## 4. Écrans — détail

### 4.1 Onboarding

#### 1 · Splash → `Welcome`
Toute la surface est un lien. `bg #1B2559`, centré, `gap 14`.
Décor : cercle `420` à `top −150 / right −170` `#222F6B` · cercle `300` à
`bottom −110 / left −130` `#222F6B` · carré `18` `r6` `#FFC83D` `top 170 left 64` `rotate(18°)` ·
cercle `14` `#7FD8B4` `top 240 right 72` · carré `16` `r5` `#FF7A6B`
`bottom 230 right 96` `rotate(−14°)`.
Contenu : disque `196` `r50%` `#DCEBFF` contenant Zitoun `160` mood `salut` →
« madrassti » Fredoka 700 `56px`, `letter-spacing −.02em`, `margin-top 18` →
« مدرستي » Baloo 700 `34px/1.1` `#FFC83D` (`lang=ar dir=rtl`) →
« L'école de mon enfant, dans ma poche. » `16px/700 #C9D1EE`, `margin-top 6`.
3 points `10px` `#FFC83D` opacités `1 / .55 / .25`, `bottom 72`, `gap 8`.

#### 2 · Bienvenue (carrousel 3 slides) → `Role`
`bg #EEF5FF`, `padding 20px 20px 28px`.
En-tête : groupe langue (`bg #FFF`, `r 22`, `padding 4`) avec
« Français » (`h40 r18 #1B2559/#FFF 14px/800`) et « العربية »
(`h40 r18` transparent, Baloo 700 `16px`) + lien « Passer » (`15px/800 #1F5FBF`, `min-h 48`).
Scène : disque `330 × 330` `r50%` `#DCEBFF` centré, contenant une illustration par slide.

| slide | titre | corps | illustration |
|---|---|---|---|
| 0 | La journée de votre enfant, d'un coup d'œil | Le cours en ce moment, le suivant et ce qui change — sans chercher. | carte navy `290` `r26` `rotate(−3°)` `shadow 0 12px 28px rgba(27,37,89,.22)` : « La journée de Yassine » + mini-timeline 6 segments + anneau jaune sur le 2ᵉ + Zitoun 44 à `left 27%` + carte `#26336E` `r16` « MAINTENANT / Mathématiques » |
| 1 | Les changements arrivent à temps | Absence d'un enseignant, horaire modifié, nouvelle leçon : vous êtes prévenu, sans être dérangé. | 2 cartes empilées `gap 12` : alerte corail `rotate(2°)` (icône `swap`, « DEMAIN », « Mme Trabelsi sera absente ») + carte blanche `rotate(−2°)` (icône `book`, « Nouvelle leçon · Français ») |
| 2 | Parlez simplement avec l'enseignant | Des messages directs, respectueux et vérifiés, pour chaque enfant. | bulle reçue + bulle envoyée + puce `#FFF` `r16` avec Zitoun 40 `bravo` et « Messages vérifiés et bienveillants » `13px/800 #1E7A57` |

Pied : indicateurs (`h 8`, `r 4`, largeur `28px` si actif sinon `8px`,
`#1B2559` / `#A9D1FF`) → titre Fredoka 600 `28px/1.2` → corps `16px/1.5 #3A4570`
`max-width 320`, centrés → bouton primaire `margin-top 26` :
« Suivant » (slides 0–1, `onClick → i+1`) ou « Commencer » (slide 2, lien `Role`).

#### 3 · Choix du rôle → `Dashboard` / `StudentHome` / `TeacherHome`
Retour (48, `r16`, `#FFF`, `shadow 0 2px 0 #D6E4F7`) → `Welcome`.
Titre « Qui utilise Madrassti ? » Fredoka 600 `28px/1.2` + sous-titre
« Choisissez votre profil. L'école vous a envoyé un code pour le confirmer. » `15px/1.5 #3A4570`.
`role="radiogroup"`, 3 options (`min-h 84`, `r 24`, `bg #FFF`, `padding 12px 14px 12px 12px`,
`gap 14`) :

| id | titre | description | tint/ink | visuel | cible | aide |
|---|---|---|---|---|---|---|
| parent | Parent | Suivre la journée, les leçons et parler aux enseignants. | `#FFF0C7`/`#8A5A00` | icône `users` 28 | Dashboard | Reçu par SMS ou sur le carnet de liaison. Un seul code suffit pour tous vos enfants. |
| eleve | Élève | Sur le téléphone d'un parent ? Ouvrez le mode enfant. | `#D9F5E8`/`#1E7A57` | **Zitoun 54 `salut`** | StudentHome | Demandez le code à un parent. Il pourra verrouiller le mode enfant avec un code secret. |
| enseignant | Enseignant | Publier des leçons, signaler un changement, répondre aux parents. | `#DCEBFF`/`#1F5FBF` | icône `school` 28 | TeacherHome | Code fourni par la direction de votre école. |

Sélection : `border 2.5px solid #1B2559` + `shadow 0 4px 0 #1B2559` (sinon
`2.5px #FFFFFF` + `0 2px 0 #D6E4F7`). Puce `28` `r50%` : sélectionnée → `bg #FFC83D`
sans bordure + icône `check` 16/stroke 3 ; sinon `border 2px #C9D6EC` sur blanc.
Médaillon `60 × 60`, `r 20`.

Champ code : label `14px/800` « Code d'invitation de l'école » ; input `h 56`, `r 16`,
`border 1.5px #C9D6EC`, `padding 0 16`, `17px/800`, `letter-spacing .08em`,
placeholder « Ex. : 4B-7K2Q », `autocomplete="one-time-code"`.
Aide : icône `info` 16 `#1F5FBF` + texte `13px/1.4 #5A6488/600`, **change selon le rôle**.
Spacer `flex:1` puis bouton primaire « Continuer ».

### 4.2 Parent

#### 4 · Accueil parent
État interne : `{ child: 'yassine', dismissed: false }`. Props : `alerte` (défaut `true`),
`full` (défaut `false`).
Constantes de temps : **`NOW = 620` (10:20)**, `D0 = 480` (8h), `SPAN = 480` (8h → 16h).

Données enfants :

| | Yassine | Lina |
|---|---|---|
| classe | 4e année B | 1re année A |
| avatar | `#FFC83D` / `#1B2559` | `#FFE1DC` / `#B83C30` |
| enseignante | Mme Ben Salah | Mme Chaabane |
| alerte | oui | non |
| leçons | 2 nouvelles | 1 nouvelle |
| blocs | ar 480–570 · ma 585–675 · fr 675–720 · ev 840–900 · sp 900–960 | ar 480–540 · ma 540–600 · art 615–660 · ar 660–720 · sp 840–900 · ev 900–960 |
| salles | Salle 4 (fr : M. Gharbi) ; ev Labo Mme Trabelsi ; sp Cour M. Jlassi | Salle 1 ; sp Cour M. Jlassi |

Sections dans l'ordre :
1. **En-tête** — « Lundi 23 novembre » `13px/700 #5A6488` + « Bonjour Samia »
   Fredoka 600 `28px/1.15` ; cloche `52 × 52` `r18` `#FFF` `shadow 0 2px 0 #D6E4F7`
   avec badge `min-w18 h18 r9 #C8473A` bordé `2px #FFF`, `11px/800` = nb de non-lus → `Notifications`.
2. **Sélecteur d'enfant** — `role="tablist"`, `gap 10`. Bouton `h 52`,
   `padding 0 16 0 8`, `r 26`, avatar `36` `r50%` Fredoka 600 `17px`,
   nom `15px/800` + classe `12px/700 opacity .85`.
   Sélectionné : `bg #1B2559`, `fg #FFF`, `border 1.5px #1B2559` ; sinon `#FFF` / `#1B2559` /
   `1.5px #D6E4F7`.
3. **Carte d'alerte** (si `alerte && enfant.alert && !dismissed`) — « DEMAIN · MARDI 24 »,
   « Mme Trabelsi sera absente », « L'éveil scientifique de 14h est remplacé par une séance
   d'arts. », boutons « Voir demain » (→ `Week`) et « Compris » (`dismiss`).
4. **Ruban de la journée** — section `bg #1B2559`, `r 28`, `padding 20px 18px 14px`, `gap 14`.
   - Titre « La journée de {enfant} » Fredoka 600 `20px` + puce de statut :
     changement → `#FFE1DC`/`#B83C30` « Changement demain » ; sinon `#D9F5E8`/`#1E7A57`
     « Journée normale ».
   - Piste : conteneur `h 30`, `margin-top 50`. Bloc « Pause » `left 50%`,
     `width calc(25% − 3px)`, `border 1.5px dashed #56628F`, `r 9`, texte `11px/800 #A9B3D6`.
     Segments : `left = (start−480)/480 × 100%`, `width = calc((end−start)/480 × 100% − 3px)`,
     `r 9`, fond = teinte matière, `opacity .35` si `end ≤ NOW`,
     `box-shadow 0 0 0 2.5px #FFC83D` si en cours.
   - Ligne « maintenant » : `top −6`, `h 42`, `w 3`, `r 2`, `#FFC83D`,
     `left calc(pct(NOW)% − 1.5px)`.
   - Zitoun `44` mood `content`, `bottom 34`, `left calc(pct(NOW)% − 22px)`.
   - Graduations `8h 10h 12h 14h 16h`, `11px/700 #A9B3D6`, `space-between`, `margin-top −6`.
   - Carte « Maintenant » `bg #26336E` `r 20` `padding 14` : pastille `56` `r18`
     (teinte/encre matière, glyphe texte ou icône 28) ; kicker
     « Maintenant · encore {end−NOW} min » `11px/800 .08em #FFC83D` ; nom Fredoka 600 `19px/1.2` ;
     `{hh:mm–hh:mm} · {enseignant} · {salle}` `13px #C9D1EE` ; barre `h 6` `r 3` `#3A4785`
     remplie `#FFC83D` à `round((NOW−start)/(end−start) × 100)%`.
   - Ligne « Ensuite » (lien → `Week`, `min-h 48`) : heure `13px/800 #A9B3D6 w42` +
     carré `12` `r4` teinte + « Ensuite : {nom} » `15px/700` + chevron 20 `#A9B3D6` stroke 2.2.
5. **Raccourcis** — grille 3 colonnes, `gap 10`. Cartes `#FFF` `r 20`
   `padding 14px 12px` `min-h 108` `shadow 0 2px 0 #D6E4F7` :
   « Écrire / {enseignante} » (icône `message`, `#DCEBFF`/`#1F5FBF`) → `Chat` ·
   « Leçons / {n nouvelles} » (`book`, `#D9F5E8`/`#1E7A57`, sous-titre `12px/800 #1E7A57`) → `Lessons` ·
   « La semaine / Emploi du temps » (`calendar`, `#FFF0C7`/`#8A5A00`) → `Week`.
   Médaillon `40` `r 13`, icône 22.
6. **Récemment** — titre Fredoka 600 `20px` + « Tout voir » (`14px/800 #1F5FBF`, `min-h 44`) →
   `Notifications` ; puis liste de 3 notifications (§3.8) propres à l'enfant.

`full=true` → `height auto`, `overflow-y visible` (= écran 4b, **pas un écran séparé**).

#### 5 · Semaine
État : `{ d: 0 }`. `NOW = 620`.
En-tête : « Semaine du 23 au 28 novembre » `13px/700` + « Emploi du temps » Fredoka 600 `26px` ;
bouton enfant (`h 48`, `r 24`, `border 1.5px #D6E4F7`, avatar `34` `r50%` `#FFC83D`
Fredoka 600 `16px`, « Yassine » `14px/800`).

Onglets jours : grille 6 colonnes `gap 6`, bouton `h 68` `r 18`,
`short 12px/800 opacity .85` + `num` Fredoka 600 `20px/1`.
Sélectionné `#1B2559`/`#FFF` ; aujourd'hui non sélectionné → `border 2px #FFC83D` ;
sinon `2px transparent`. Point de changement : `9 × 9` `r50%` `#E8604F`,
`border 2px` couleur du fond, `top 6 right 6`.

Semaine (Yassine) :

| jour | blocs (début–fin en minutes) | changement |
|---|---|---|
| Lun 23 | ar 480–570 · ma 585–675 · fr 675–720 · ev 840–900 · sp 900–960 | — |
| Mar 24 | fr 480–570 · ar 585–675 · ma 675–720 · **art 840–900 (modifié)** · ar 900–960 | ✅ |
| Mer 25 | ma 480–570 · ar 585–675 · fr 675–720 | — |
| Jeu 26 | ar 480–570 · ev 585–675 · ma 675–720 · fr 840–900 · sp 900–960 | — |
| Ven 27 | ma 480–570 · fr 585–675 · ar 675–720 · art 840–900 · ev 900–960 | — |
| Sam 28 | ar 480–570 · ma 585–675 · sp 675–720 | — |

Enseignants/salles : ar Mme Ben Salah · Salle 4 ; fr M. Gharbi · Salle 4 ;
ma Mme Ben Salah · Salle 4 ; ev Mme Trabelsi · Labo ; art Mme Haddad · Atelier ;
sp M. Jlassi · Cour.

Titre du jour : `Aujourd'hui · Lundi 23` si `d == 0`, sinon le nom complet.
Résumé : `{n} cours · {première}–{dernière}` avec `:00` → `h`.

Lignes (`gap 8`) : colonne horaires `w 46`, `padding-top 10`
(début `14px/800`, fin `12px/700 #5A6488`).
- **Pause** (insérée avant le premier bloc dont `start ≥ 840`) : `h 52`,
  `border 1.5px dashed #A9C3E6`, `r 18`, icône `sun` 18, « Pause déjeuner », 12:00–14:00.
- **Bloc** : `min-h max(68, round((end−start) × 0.9))px`, `r 20`, `padding 12`,
  fond = **lavis** matière (§2.1) ou `#FFFFFF` si en cours, `shadow 0 0 0 2.5px #FFC83D` si en cours.
  Pastille `Subject` 44. Nom Fredoka 600 `17px/1.2`. Puce « En cours » ou « Modifié ».
  `who` `13px/600 #3A4570`. Si modifié : « Remplace l'éveil scientifique · Mme Trabelsi absente »
  `13px/1.4 #B83C30/700`. Si en cours : barre `h 6` `r 3` `#FFF` remplie **39 %** `#1F5FBF`.
  Passé (aujourd'hui, `end ≤ NOW`) → `opacity .5`.
- **Après-midi libre** (si aucun bloc ≥ 840, c.-à-d. mer. et sam.) : carte `#FFF` `r 20`
  `padding 14` avec Zitoun 52 `bravo` + « Après-midi libre, à demain ! » `15px/800`.

#### 6 · Leçons et documents
État : `{ f: 'all' }`.
En-tête « Yassine · 4e année B » + « Leçons et documents » Fredoka 600 `26px`.
Recherche : `h 52`, `r 18`, `#FFF`, `shadow 0 2px 0 #D6E4F7`, icône `search` 20,
placeholder « Rechercher une leçon » (label masqué accessible).
Filtres : rangée scrollable horizontale (`margin 0 −16px`, `padding 0 16px 2px`),
chips `h 40` `r 20` `14px/800`, sélectionné `#1B2559`/`#FFF`/`border 1.5px #1B2559`,
sinon `#FFF`/`#1B2559`/`1.5px #D6E4F7`. Filtres : `Toutes · Français · Maths · Arabe · Éveil`.

Groupes (en-tête : pastille 32 + nom Fredoka 600 `19px` + « n document(s) » `13px/800 #5A6488`) :

| matière | bandeau | documents |
|---|---|---|
| Français | `#FFC83D` | **Les adjectifs qualificatifs** — M. Gharbi · 23 nov. · PDF 420 Ko · `PDF` · *Nouveau* · **Dictée n° 6 — à préparer** — M. Gharbi · 19 nov. · PDF 180 Ko · `PDF` · *Hors connexion* |
| Mathématiques | `#5B9BEA` | **La multiplication posée** — Mme Ben Salah · 22 nov. · PDF 650 Ko · `PDF` · *Nouveau* · **Problèmes : la monnaie** — Mme Ben Salah · 17 nov. · Photo 1,2 Mo · `IMG` |
| Arabe | `#FF7A6B` | **النص : في السوق** — Mme Ben Salah · 20 nov. · PDF 300 Ko · `PDF` · *Hors connexion* |
| Éveil scientifique | `#7FD8B4` | **Le cycle de l'eau** — Mme Trabelsi · 16 nov. · PDF 2,1 Mo · `PDF` |

Ligne de document : `r 20`, `#FFF`, `padding 10`, `gap 12`.
Vignette `52 × 64`, `r 10`, `border 1.5px #E3EAF6`, `padding 16px 7px 0` :
bandeau haut `h 10` couleur matière + 4 traits `h 3` `r 2` `#D6E4F7`
(largeurs 100 / 80 / 90 / 60 %) + badge type `h 16` `r 5` `#1B2559`/blanc `9px/800`
en `bottom 4 right 4`.
Titre `15px/800/1.3` (`dir="auto"` pour l'arabe) · méta `13px/600 #5A6488` ·
puces *Nouveau* / *Hors connexion*.
Bouton d'action `48 × 48` `r 16` `#EEF5FF` : icône `download`, ou `file` si déjà hors connexion.

#### 7 · Notifications
État : `{ f: 'all', read: false }`.
En-tête : retour → `Dashboard` + « Notifications » Fredoka 600 `26px` +
« Tout lire » (`14px/800 #1F5FBF`, `readAll`).
Filtres segmentés : conteneur `#FFF` `r 20` `padding 4`, grille 4 colonnes `gap 4`,
boutons `h 44` `r 16` `13px/800`, actif `#1B2559`/`#FFF`, sinon transparent/`#1B2559`.
`Tout · Changements · Leçons · École`.

**Épinglé « À retenir »** (visible si filtre `all` ou `change`) : titre de section
`12px/800 .1em #B83C30` majuscules ; carte corail (§3.9) `padding 16` `gap 10` :
icône `user`, « ABSENCE · MARDI 24 » + « il y a 2 h », « Mme Trabelsi sera absente »
Fredoka 600 `17px/1.25`, « L'éveil scientifique de 14h est remplacé par une séance d'arts
avec Mme Haddad. Horaires de sortie inchangés. » ; pied : puce enfant
(rond 22 `#FFC83D` + « Yassine » `13px/800`) + bouton navy « Voir mardi » `h 44 r 14` → `Week`.

Sections par date (`Aujourd'hui / Hier / Cette semaine`), en-tête `12px/800 .1em #5A6488` :

| sect. | cat. | qui | titre | corps | heure | non-lu |
|---|---|---|---|---|---|---|
| 0 | leçon | Yassine | Nouvelle leçon · Français | Les adjectifs qualificatifs — fiche PDF | il y a 1 h | ✅ |
| 0 | leçon | Lina | Nouvelle leçon · Arabe | La lettre ب — fiche à colorier | il y a 3 h | ✅ |
| 1 | change | Yassine | Horaire modifié | Jeudi : le sport passe de 15h à 14h. | hier | — |
| 1 | école | École | Réunion parents-enseignants | Samedi 28 nov. à 10h, salle polyvalente. | hier | — |
| 2 | école | École | Journée de l'arbre | Vendredi 27 : chaque élève apporte une petite plante. | jeu. 19 | — |
| 2 | leçon | Yassine | Nouvelle leçon · Éveil | Le cycle de l'eau — PDF 2,1 Mo | lun. 16 | — |

Catégories : `leçon` → `book`/`#D9F5E8`/`#1E7A57` · `change` → `swap`/`#FFF0C7`/`#8A5A00` ·
`école` → `mega`/`#DCEBFF`/`#1F5FBF`.
Personnes : `Y Yassine #FFC83D/#1B2559` · `L Lina #FFE1DC/#B83C30` · `E École #1B2559/#FFF`.
Chaque ligne porte en plus une puce « qui » : `h 22`, `r 11`, `padding 0 8 0 3`,
`bg #F3F6FC`, rond 16 initiale `9px`, nom `12px/800`.
Les sections vides sont masquées. `readAll` passe tous les non-lus à lu.

#### 8a · Messages
En-tête « Messages » Fredoka 600 `28px` + bouton primaire compact
« Écrire » (icône `pencil` 18) → `Chat`.
Bandeau info : `bg #DCEBFF`, `r 18`, `padding 12px 14px`, icône `clock` 22 `#1F5FBF`,
« Les enseignants répondent en général entre 8h et 17h, du lundi au samedi. » `14px/1.4/700`.
Liste (`#FFF`, `r 24`, `padding 4px 6px`), lignes `padding 14px 8px` :

| initiales | nom | rôle | dernier message | heure | non-lus | avatar |
|---|---|---|---|---|---|---|
| BS | Mme Ben Salah | Enseignante principale · Yassine | Avec plaisir ! Je vous envoie la fiche ce soir. | 10:12 | **2** | `#DCEBFF`/`#1F5FBF` |
| G | M. Gharbi | Français · Yassine | Vous : Merci pour la dictée de cette semaine. | hier | 0 | `#FFF0C7`/`#8A5A00` |
| C | Mme Chaabane | Enseignante principale · Lina | Pensez au cahier de dessin pour mardi. | hier | 0 | `#FFE1DC`/`#B83C30` |
| É | Direction de l'école | Annonces · lecture seule | Réunion parents-enseignants samedi 28 nov. | lun. | 0 | `#1B2559`/`#FFF` **+ cadenas** |

Avatar `52 × 52` `r 18` Fredoka 600 `19px`. Cadenas : rond 22 `#FFF` en
`bottom −4 right −4`, icône `lock` 13/stroke 2.5.
Nom `16px/800` · heure `12px/700` (`#B83C30` si non-lus, sinon `#5A6488`) ·
rôle `12px/800 #5A6488` · aperçu `14px` poids `800` si non-lus sinon `600`, ellipsé ·
badge `min-w 22 h 22 r 11 #C8473A` `12px/800`.
Les 3 premières lignes mènent à `Chat`, la dernière à `Notifications`.
Pied : icône `shield` 18 `#1E7A57` + « Chaque message est relu automatiquement pour rester
respectueux. Seuls vous et l'enseignant le lisez. » `13px/1.45 #5A6488/600`.

#### 8b · Conversation
État : `{ draft: '', sent: [] }`.
En-tête fixe `#FFF`, `r 0 0 24px 24px`, `shadow 0 4px 16px rgba(27,37,89,.06)`,
`padding 14px 16px` : retour → `Messages`, avatar `44` `r 15` `#DCEBFF`/`#1F5FBF` « BS »,
« Mme Ben Salah » `16px/800` + « Enseignante · 4e B · à propos de Yassine » `12px/700 #5A6488`.

Fil (`gap 10`, `padding 16`) : puce de date centrée « Aujourd'hui »
(`h 26 r 13 #DCEBFF` `12px/800 #1F5FBF`), puis
1. reçu — « Bonjour Madame. Yassine a très bien participé en mathématiques ce matin. » · 09:40
2. envoyé — « Merci beaucoup ! Pourriez-vous m'envoyer la fiche sur la multiplication ?
   Il veut s'entraîner à la maison. » · « 10:05 · Lu » + check 13/stroke 3 `#1E7A57`
3. reçu — « Avec plaisir ! La voici : » + pièce jointe (lien → `Lessons`, `r 14` `#EEF5FF`
   `padding 8`) : `Subject ma` 40 + « La multiplication posée » `14px/800` /
   « PDF · 650 Ko » `12px/700` + icône `download` 20 `#1F5FBF` · 10:12
4. puis chaque message envoyé (`sent`) : bulle navy + « À l'instant · Envoyé »

Bulles : reçue `#FFF` `r 20 20 20 6`, envoyée `#1B2559`/`#FFF` `r 20 20 6 20`,
`padding 12px 14px`, `15px/1.45`, `max-width 280`. Horodatage `11px/700 #5A6488`.

Barre d'envoi `#FFF`, `r 24 24 0 0`, `shadow 0 -4px 16px rgba(27,37,89,.06)`,
`padding 12px 12px 20px`, `gap 10` :
- Réponses rapides (scroll horizontal, `gap 8`) : « Merci beaucoup ! », « Bien reçu »,
  « Pouvons-nous en parler ? » — chips `h 40` `r 20` `border 1.5px #D6E4F7` `14px/800`,
  **un clic envoie directement le message**.
- Rangée : bouton `clip` `48` `r 16` `#EEF5FF` · input `h 48` `r 16`
  `border 1.5px #D6E4F7` `bg #F7FAFF` `16px`, placeholder « Écrire un message… » ·
  bouton `send` `48` `r 16` `#FFC83D` `shadow 0 3px 0 #E0A51A`.

`send` n'ajoute rien si le brouillon est vide ou blanc ; il vide ensuite le champ.

#### 9 · Profil de l'enfant
Retour → `Settings`. Titre « Profil de l'enfant » Fredoka 600 `22px`.
Carte héro `#1B2559` `r 28` `padding 22px 18px 18px`, cercle décoratif `180`
`#222F6B` `top −60 right −50` : avatar `76` `r 26` `#FFC83D` Fredoka 700 `36px`
`shadow 0 4px 0 #E0A51A` ; « Yassine » Fredoka 600 `26px/1.1` ;
« 4e année B · École primaire Ibn Khaldoun » `14px/700 #C9D1EE`.
Statistiques (3 colonnes, `#26336E` `r 16` `padding 10px 12px`) :
`CLASSE 4e B` · `SALLE 4` · `ÉLÈVES 28` (label `11px/800 #A9B3D6`, valeur Fredoka 600 `17px`).

« Ses enseignants » (`#FFF` `r 24` `padding 16`) — pastille 40 + nom `15px/800` +
rôle `13px/600 #5A6488` + bouton `message` 48 → `Chat` :
`ma` Mme Ben Salah / Enseignante principale · arabe et maths ·
`fr` M. Gharbi / Français · `ev` Mme Trabelsi / Éveil scientifique · `sp` M. Jlassi / Sport.

« L'école » — icône `clock` + « Lun–ven 8h–12h et 14h–16h · Mer et sam 8h–12h » ;
icône `pin` + « [Adresse de l'école] » ; bouton contour « Appeler l'école » (icône `phone` 18),
`href="#"`.

« Informations » — `Date de naissance / [JJ/MM/AAAA]` ·
`Contact principal / Samia (vous)` · `Autre contact / [Nom · téléphone]`
(label `14px/700 #5A6488`, valeur `14px/800`) + note « Une information est fausse ? Seule
l'école peut la modifier — écrivez à l'enseignante principale. » `13px/1.4 #5A6488/600`.

> **Placeholders littéraux** : `[Adresse de l'école]`, `[JJ/MM/AAAA]`, `[Nom · téléphone]`,
> `[numéro de téléphone]` (écran 19) sont **dans la maquette telle quelle** et seront
> reproduits à l'identique.

### 4.3 Élève

Cibles ≥ **64 dp** et textes plus grands ; nav `96` de haut.

#### 10 · Accueil élève
`padding 18px 16px 20px`.
En-tête : « Salut Lina ! » Fredoka **700** `34px/1.1` + bouton `lock` 48 `r 16` `#FFF`
`#5A6488` (`aria-label="Quitter le mode enfant (code parent)"`) → `Role`.
Bulle : Zitoun `112` `salut` + bulle `#FFF` `r 22 22 22 6` `shadow 0 3px 0 #D6E4F7`
`margin-bottom 34`, texte « C'est l'heure des arts ! » Fredoka 600 `19px/1.25` +
bouton rond `48` `#FFC83D` `shadow 0 3px 0 #E0A51A` icône `speaker` 22
(`aria-label="Écouter"`).
Carte « Maintenant » : `bg #FFE3EE`, `r 30`, `padding 18`, `shadow 0 4px 0 #F5C2D6` ;
`Subject art` **88** ; « MAINTENANT » `13px/800 .08em #A8326A` ; « Arts » Fredoka 700 `34px/1` ;
« avec Mme Chaabane » `15px/700 #3A4570` ; barre `h 16` `r 8` `#FFF` remplie **12 %** `#A8326A` +
« jusqu'à 11h » `14px/800` avec icône `clock` 16.
« Ma journée » (`#FFF` `r 26` `padding 16px 12px 14px`) : 7 étapes `space-between` —
`ar 8h (fait) · ma 9h (fait) · art 10h (maintenant) · ar 11h · déjeuner 12h · sp 14h · ev 15h`.
Pastille 44 (déjeuner : carré 44 `r 14` `#FFF0C7`/`#8A5A00` icône `sun` 22) ;
fait → `opacity .55` + badge check (rond 20 `#1E7A57`, `border 2px #FFF`, icône 12/stroke 3.5,
`top −6 right −6`) ; maintenant → `shadow 0 0 0 3px #FFF, 0 0 0 6px #FFC83D` ;
heure `11px/800 #5A6488`.
Deux grandes cartes (`min-h 118`, `r 26`, `padding 16`) :
« Mes leçons » `#D9F5E8` `shadow 0 4px 0 #A9E5CB`, médaillon `52` `r 18` `#FFF`/`#1E7A57`
icône `book` 28, titre Fredoka 600 `20px`, badge « 1 nouvelle » → `StudentLessons` ·
« Ma semaine » `#FFF0C7` `shadow 0 4px 0 #F3D88A`, `#8A5A00`, icône `calendar` 28 → `StudentWeek`.

#### 11 · Ma semaine
État : `{ d: 0 }`. Titre « Ma semaine » Fredoka 700 `32px`.
Onglets jours : 6 colonnes, `h 64`, `r 20`, Fredoka 600 `17px`,
sélectionné `#1B2559`/`#FFF` + `shadow 0 4px 0 #0E1640`, sinon `#FFF` + `0 3px 0 #D6E4F7` ;
aujourd'hui non sélectionné → `border 2.5px #FFC83D`.

| jour | matin | après-midi |
|---|---|---|
| Lun | ar 8h · ma 9h · art 10h · ar 11h | sp 14h · ev 15h |
| Mar | ma 8h · ar 9h · ar 10h · ev 11h | art 14h · ma 15h |
| Mer | ar 8h · ma 9h · sp 10h · ar 11h | — |
| Jeu | ar 8h · ma 9h · ev 10h · ar 11h | art 14h · sp 15h |
| Ven | ma 8h · ar 9h · ar 10h · ma 11h | ev 14h · art 15h |
| Sam | ar 8h · ma 9h · sp 10h | — |

Noms courts côté élève : `ma` = « Maths », `ev` = « Éveil » (vs « Mathématiques » /
« Éveil scientifique » côté parent).
En-têtes « Le matin » (icône `sun` 22 `#8A5A00`) et « L'après-midi » (icône `moon` 20 `#1F5FBF`),
titres Fredoka 600 `20px`.
Ligne de cours : `#FFF`, `r 24`, `padding 10px 14px 10px 10px`, `gap 14`,
`Subject` **60**, nom Fredoka 600 `21px`, heure `h 34` `r 17` `#EEF5FF` `15px/800`.
Anneau `0 0 0 3px #FFC83D` sur le **3ᵉ cours du matin le lundi** (10h, cours en cours).
Si pas d'après-midi : carte `#D9F5E8` `r 24` avec Zitoun 64 `bravo` +
« Pas d'école, on joue ! » Fredoka 600 `20px`.

#### 12 · Mes leçons
État : `{ s: 'ar' }`. Titre « Mes leçons » Fredoka 700 `32px`.
Grille 3 colonnes `gap 10` des 6 matières : bouton `h 112` `r 24` `#FFF`,
`Subject` 56 + nom `15px/800` ; sélectionné `border 3px #1B2559` + `shadow 0 4px 0 #1B2559`,
sinon `3px transparent` + `0 3px 0 #D6E4F7` ; badge « nouveau » = rond 26 `#FFC83D`
icône `sparkle` 16/stroke 2.5 en `top 8 right 8` si la matière a une leçon neuve.
Titre de la matière Fredoka 600 `22px`.

| matière | leçons (glyphe, titre, nouveau) |
|---|---|
| Arabe | `ب` La lettre ب ✅ · `ا` La lettre ا |
| Maths | `5` Compter jusqu'à 20 |
| Français | *(aucune)* |
| Éveil | `☀` Le jour et la nuit |
| Arts | `✿` Dessiner une fleur |
| Sport | *(aucune)* |

Ligne de leçon : `#FFF`, `r 24`, `padding 12`, `gap 14`, anneau `0 0 0 3px #FFC83D` si neuve.
Vignette `58 × 72` `r 12` teinte matière, glyphe `30px/700` encre matière
(police = Baloo pour l'arabe, Fredoka sinon). Puce « Nouveau ! » + titre Fredoka 600 `19px/1.25`
(`dir="auto"`). Bouton rond `60` `#FFC83D` `shadow 0 4px 0 #E0A51A`
icône `chevron` 28/stroke 3.
État vide : carte `#FFF` `r 24` `padding 18` centrée, Zitoun 90 `content`,
« Rien de nouveau ici. » Fredoka 600 `19px`, « Ta maîtresse ajoutera bientôt des leçons. »
`15px/600 #3A4570`.

#### 13 · Mes alertes
Écran statique (`renderVals` vide). Titre « Mes alertes » Fredoka 700 `32px`.
1. **Carte « Mardi, ça change ! »** — `#FFF`, `r 28`, `padding 18`,
   `shadow 0 0 0 3px #FF7A6B` ; étiquette « Nouveau » (`h 26` `r 13` `#FF7A6B`/`#1B2559`
   `13px/800`) en `top −10 left 18` ; titre Fredoka 600 `22px/1.2` ;
   bouton rond `52` `#FFC83D` `speaker` 24. Comparatif (`#F3F6FC`, `r 22`, `padding 12`,
   centré, `gap 14`) : `Subject ma` 64 `opacity .5` + « Maths » barré → chevron 32/stroke 3
   `#B83C30` → `Subject sp` 64 + « Sport » → puce `h 34` `r 17` `#FFF` `15px/800`
   icône `clock` 16 + « 15h ».
2. **Nouvelle leçon** — `#FFF` `r 28` `padding 16` : `Subject ar` 64 +
   « Nouvelle leçon » Fredoka 600 `19px/1.2` + « الحرف ب » Baloo 700 `22px` `#B83C30` +
   bouton rond `56` `#1B2559` chevron 26/stroke 3 → `StudentLessons`.
3. **Fête de l'arbre** — médaillon `64` `r 22` `#D9F5E8`/`#1E7A57` icône `sparkle` 32 ;
   « Vendredi : la fête de l'arbre » Fredoka 600 `19px/1.2` ; « Apporte une petite plante. »
   `15px/700 #3A4570` ; bouton rond `52` `#EEF5FF` `speaker` 24.
4. **Bravo** — `#FFF0C7`, `r 28`, `padding 14px 16px 14px 8px` : Zitoun 84 `bravo` +
   « Bravo Lina ! » Fredoka 700 `22px` + « Tu as ouvert toutes tes leçons de la semaine. »
   `15px/700/1.4 #3A4570`.

### 4.4 Enseignant

#### 14 · Accueil enseignant
En-tête « Lundi 23 novembre · École Ibn Khaldoun » `13px/700` +
« Bonjour Mme Ben Salah » Fredoka 600 `26px/1.15`.
Deux boutons (`h 60`, `r 18`, `gap 8`, `15px/800`) :
« Publier une leçon » primaire jaune (icône `upload` 20) → `TeacherPublish` ·
« Signaler un changement » navy `shadow 0 3px 0 #0E1640` (icône `swap` 20) → `TeacherAbsence`.
« Ma journée » (`#FFF` `r 24` `padding 16`) + « 4 séances » `13px/800 #5A6488` ;
lignes `padding 8` `margin 0 −8` `r 16` : heure `w 46` `14px/800`, pastille 36,
nom `15px/800`, « {classe} · {salle} » `12px/700 #5A6488`, puce « En cours ».
Fond `#FFF6DA` si en cours, `opacity .5` si terminé.

| heure | matière | classe | salle | état |
|---|---|---|---|---|
| 08:00 | Arabe | 4e B | Salle 4 | terminé |
| 09:45 | Mathématiques | 4e B | Salle 4 | **en cours** |
| 14:00 | Arabe | 4e A | Salle 6 | — |
| 15:00 | Mathématiques | 4e A | Salle 6 | — |

Deux tuiles statistiques (`#FFF`, `r 22`, `padding 14`, `shadow 0 2px 0 #D6E4F7`) :
médaillon 40 `r 13` + chiffre Fredoka 600 `26px/1` + libellé `13px/800 #3A4570` —
« **5** messages non lus » (`message`, `#DCEBFF`/`#1F5FBF`) → `TeacherMessages` ·
« **3** leçons publiées cette semaine » (`book`, `#D9F5E8`/`#1E7A57`) → `TeacherPublish`.
« Derniers messages » + « Tout voir » → `TeacherMessages` ; 2 lignes (`#FFF` `r 22`
`padding 4px 12px`), avatar `42` `r 14` Fredoka 600 :
« S · Samia · maman de Yassine » / « Merci ! Pourriez-vous m'envoyer la fiche… » / **10:05**
(`#FFF0C7`/`#8A5A00`) · « K · Karim · papa d'Amira » / « Amira sera absente jeudi matin
(rendez-vous). » / **08:31** (`#D9F5E8`/`#1E7A57`). Heures `12px/800 #B83C30`. → `Chat`.

#### 15 · Publier une leçon
État : `{ cls: '4B', subj: 'ma', parents: true, kids: true, done: false }`.
En-tête : retour → `TeacherHome` + « Publier une leçon » Fredoka 600 `24px`.
Formulaire scrollable (`gap 18`, `padding 12px 16px 24px`) :
1. **Classe** — segmenté 3 colonnes (`#FFF`, `r 18`, `padding 4`), boutons `h 44` `r 14`
   `14px/800` : `4e A` (27 familles) · `4e B` (28) · `Les deux` (55).
2. **Matière** — grille 2 colonnes, boutons `h 64` `r 20` + `Subject` 40 + nom `15px/800`,
   sélection `border 2.5px #1B2559` sinon `2.5px #FFFFFF` : `Arabe` · `Mathématiques`.
3. **Titre de la leçon** — input `h 54` `r 16` `border 1.5px #C9D6EC` `16px/700`,
   valeur « La multiplication posée ».
4. **Mot pour les familles** *(facultatif)* — textarea 3 lignes `r 16` `16px/1.5`,
   valeur « Exercices 1 à 4 à faire pour jeudi. La fiche d'aide est en page 2. ».
5. **Documents** — fichier joint (`#FFF`, `r 18`, `padding 10`) : vignette `44 × 52` `r 10`
   `#DCEBFF`/`#1F5FBF` icône `file` 22 ; « multiplication-posee.pdf » `14px/800` ;
   « PDF · 650 Ko · prêt » `12px/700 #5A6488` ; bouton `x` `44` `r 14` `#F3F6FC`.
   Puis bouton pointillés « Ajouter un fichier ou une photo » (icône `plus` 20).
6. **Audience** — 2 interrupteurs (`#FFF`, `r 18`, `padding 6px 14px`, lignes `min-h 52`) :
   « Prévenir les parents » · « Visible dans le mode enfant ».

Barre collée : résumé centré `13px/700 #5A6488` =
« {familles} familles · notifiées : {parents et élèves | parents | élèves | personne} » +
bouton primaire « Publier la leçon ».

**Feuille de succès** (`done`) : voile `rgba(27,37,89,.55)`, feuille `#FFF`
`r 28 28 0 0` `padding 24px 20px 28px` centrée : Zitoun **120** `bravo`,
« Leçon publiée ! » Fredoka 600 `24px`,
« Les {n} familles de {4e A | 4e B | 4e A et 4e B} la retrouveront dans « Leçons ». »
`15px/1.5 #3A4570`, bouton navy `h 56` « Retour à l'accueil » → `TeacherHome`.

#### 16 · Absence ou changement
État : `{ type: 'absence', day: 1, off: {}, opt: 'collegue', sent: false }`.
En-tête : retour → `TeacherHome` + « Prévenir les familles » Fredoka 600 `24px`.

**3 types** (segmenté, `h 48`, `r 14`, `13px/800/1.15`) :
`Mon absence` · `Changement d'horaire` · `Annonce`.

**Jour** — 6 boutons `h 60` `r 16` (`Lun 23` … `Sam 28`), défaut **Mar 24**,
sélection `#1B2559`/`#FFF` sinon `#FFF`/`#1B2559`.

**Séances** (types `absence` et `horaire`) — libellé
« Cours concernés » / « Quel cours est déplacé ? » ; liste `#FFF` `r 20` `padding 6px 12px`,
lignes `min-h 56` avec case à cocher 24 (`accent-color #1B2559`), heure `w 46` `14px/800`,
`Subject` 32, nom `14px/800`, classe `12px/700 #5A6488` :

| heure | matière | classe | familles |
|---|---|---|---|
| 09:45 | Arabe | 4e B · 28 élèves | 28 |
| 11:15 | Mathématiques | 4e B · 28 élèves | 0 |
| 14:00 | Arabe | 4e A · 27 élèves | 27 |

**Options** (type `absence` uniquement) — `role="radiogroup"`, boutons `min-h 52` `r 16`,
pastille 20 `r50%` (`border 6px #1B2559` si choisi sinon `2px #C9D6EC`),
bordure `2.5px #1B2559` / `2.5px #FFFFFF` :
`Remplacé par un collègue` · `Étude surveillée` · `Cours annulé, sortie plus tôt`.

**Annonce** (type `annonce`) — textarea 4 lignes, valeur « Sortie au jardin public mardi
matin : prévoir une casquette et une bouteille d'eau. ».

**Horaire** (type `horaire`) — 2 sélecteurs `h 52` `r 16` :
« Nouveau jour » (`Jeudi 26` / `Vendredi 27`) · « Nouvelle heure » (`14:00` / `15:00`).

**Aperçu « Ce que verront les parents »** (icône `info` 16 + `14px/800`) — carte `r 22`
`padding 14` `gap 12`, médaillon 40 `r 13`, kicker `11px/800 .08em`,
titre Fredoka 600 `16px/1.25`, corps `13px/1.45 #3A4570` :

| type | fond / bordure / médaillon | icône | encre | kicker | titre | corps |
|---|---|---|---|---|---|---|
| absence | `#FFE9E5` / `#FFC2B8` / `#FF7A6B` | `user` | `#B83C30` | ABSENCE · {JOUR} | Mme Ben Salah sera absente | selon l'option choisie* |
| horaire | `#FFF8E4` / `#F3D88A` / `#FFC83D` | `swap` | `#8A5A00` | HORAIRE MODIFIÉ | Cours du {jour} déplacé | Le cours aura lieu jeudi 26 à 14:00, même salle. |
| annonce | `#EEF5FF` / `#C9DDF7` / `#A9D1FF` | `mega` | `#1F5FBF` | ANNONCE · 4E A ET 4E B | Sortie au jardin public | Mardi matin : prévoir une casquette et une bouteille d'eau. |

\* `collegue` → « Un collègue assurera les cours. Horaires de sortie inchangés. » ·
`etude` → « Les élèves seront en étude surveillée. Horaires inchangés. » ·
`annule` → « Les cours concernés sont annulés : sortie plus tôt, pensez à venir chercher
votre enfant. »

Bouton primaire : « Prévenir {n} familles » où `n` = somme des familles des séances cochées
(ou **28** si aucune), et **55** pour le type `annonce`.
**Feuille de succès** (`sent`) : rond `72` `r50%` `#D9F5E8`/`#1E7A57` icône `check` 36/stroke 3,
« Familles prévenues » Fredoka 600 `24px`, « L'emploi du temps des élèves est mis à jour.
La direction reçoit une copie. », bouton navy « Retour à l'accueil ».

#### 17 · Messages enseignant
État : `{ f: 'all', avail: true }`.
En-tête « Messages » Fredoka 600 `28px` + bouton primaire compact
« Écrire à une classe » (icône `users` 18, `h 48`, `padding 0 14`, `14px/800`) → `Chat`.
**Bandeau disponibilité** (`r 20`, `padding 12px 14px`, `gap 12`), médaillon 40 `r 13` `#FFF` :

| | activé | désactivé |
|---|---|---|
| fond | `#D9F5E8` | `#E3E7F5` |
| encre icône | `#1E7A57` | `#5A6488` |
| icône | `clock` | `moon` |
| titre | Disponible · 8h–17h | En pause |
| sous-titre | Les parents voient vos horaires de réponse. | Les parents sont informés que vous répondrez plus tard. |
| piste | `#1E7A57` | `#A9B3D6` |

Filtres (chips `h 40` `r 20`) : `Toutes` · `Non lues` · `4e A` · `4e B`.
Liste `#FFF` `r 24`, lignes `padding 12px 8px`, avatar `48` `r 16` Fredoka 600 `18px` :

| init. | nom | enfant | classe | dernier message | heure | non-lus | avatar |
|---|---|---|---|---|---|---|---|
| S | Samia | maman de Yassine | 4e B | Merci ! Pourriez-vous m'envoyer la fiche… | 10:05 | 1 | `#FFF0C7`/`#8A5A00` |
| K | Karim | papa d'Amira | 4e B | Amira sera absente jeudi matin (rendez-vous). | 08:31 | 2 | `#D9F5E8`/`#1E7A57` |
| N | Nour | maman d'Elyes | 4e A | Elyes n'a pas compris l'exercice 3. | hier | 2 | `#FFE1DC`/`#B83C30` |
| H | Hédi | papa de Sarra | 4e A | Vous : Bien reçu, merci pour l'information. | hier | 0 | `#DCEBFF`/`#1F5FBF` |
| M | Mouna | maman de Rayen | 4e B | Vous : Rayen a fait de beaux progrès ! | ven. | 0 | `#FFE3EE`/`#A8326A` |

Nom `15px/800`, puce classe `h 20` `r 10` `#EEF5FF`/`#1F5FBF` `11px/800`,
enfant `12px/700 #5A6488`, aperçu ellipsé, badge non-lus `#C8473A`.

### 4.5 Partagé

#### 18 · Modération IA
État : `{ mode: 'sheet', draft: "C'est n'importe quoi, vous êtes incompétente ! Mon fils n'a
toujours pas ses devoirs." }`. Trois modes : `sheet` → `sent` → (ou) `edit`.

Arrière-plan = conversation avec Mme Ben Salah (même en-tête que 8b, retour → `Messages`),
avec un message reçu : « Bonjour, les devoirs de la semaine seront publiés demain matin. ».

**Feuille de modération** (`mode == 'sheet'`) — voile `rgba(27,37,89,.45)`,
feuille `#FFF` `r 30 30 0 0` `padding 12px 18px 24px` `gap 14`,
poignée `44 × 5` `r 3` `#D6E4F7` centrée :
- Médaillon `52` `r 18` `#FFF0C7`/`#8A5A00` icône `sparkle` 26 ;
  « Et si on le disait autrement ? » Fredoka 600 `21px/1.2` ;
  « Votre message n'a pas été envoyé. Personne ne l'a vu. » `13px/700 #5A6488`.
- « VOTRE MESSAGE » `12px/800 .08em #5A6488` ; paragraphe `r 16` `#F7FAFF`
  `padding 12px 14px` `15px/1.55 #3A4570` avec **deux mots surlignés**
  (`<mark>` `bg #FFE1DC` `color #B83C30` `r 4` `padding 0 3px` `font-weight 800`) :
  **« n'importe quoi »** et **« incompétente »** ;
  note « Les mots surlignés peuvent blesser. Votre inquiétude, elle, est légitime :
  gardons-la. » `13px/1.4 #5A6488/600`.
- « PROPOSITION » `12px/800 .08em #1E7A57` ; paragraphe `r 16` `#EDFAF3`
  `border 1.5px #A9E5CB` `15px/1.55 #1B2559` :
  « Bonjour Madame, je m'inquiète : Yassine n'a pas encore reçu ses devoirs. Pourriez-vous
  me dire quand ils seront disponibles ? Merci. »
- Bouton primaire « Envoyer cette version » (`use` → `mode: 'sent'`) ;
  bouton contour `h 52` « Je reformule moi-même » (`edit` → `mode: 'edit'`).

**`mode == 'sent'`** : la suggestion apparaît en bulle envoyée + « À l'instant · Envoyé » ;
sous le fil, puce centrée `#D9F5E8` `r 18` avec Zitoun 40 `bravo` +
« Merci, c'est parfait ! » `14px/800 #1E7A57`. Le champ de saisie est **vidé**.

**`mode == 'edit'`** : la feuille se ferme, **le texte original revient dans le champ**,
bordure de l'input `2px solid #FFC83D`, et une consigne apparaît au-dessus :
icône `pencil` 16 + « Reformulez, puis envoyez à nouveau. » `13px/800 #8A5A00`.
Le bouton d'envoi (`resend`) **rouvre la feuille** (`mode: 'sheet'`).

#### 19 · Profil et réglages
État : `{ lang: 'fr', size: 1, lessons: true, school: true, quiet: true }`.
Titre « Profil et réglages » Fredoka 600 `28px`.
Carte profil (`#FFF`, `r 24`, `padding 16`) : avatar `60` `r 20` `#1B2559`/`#FFF`
Fredoka 600 `26px` « S » ; « Samia » Fredoka 600 `20px` ;
« Parent · [numéro de téléphone] » `13px/700 #5A6488` ;
bouton `pencil` 48 `r 16` `#EEF5FF`.

**MES ENFANTS** — `#FFF` `r 22` `padding 4px 12px` :
« Yassine / 4e année B · Mme Ben Salah » (rond 40 `#FFC83D`) → `ChildProfile` ·
« Lina / 1re année A · Mme Chaabane » (rond 40 `#FFE1DC`/`#B83C30`) → `ChildProfile` ·
« Ajouter un enfant avec un code » (rond 40 `border 2px dashed #A9C3E6`, icône `plus` 18,
texte `15px/800 #1F5FBF`) → `Role`. Lignes `min-h 64` / `56`, chevron 20 `#5A6488`.

**LANGUE ET AFFICHAGE** — segmenté 2 colonnes (`#EEF5FF`, `r 16`, `padding 4`),
boutons `h 44` `r 13` `15px/800` : « Français » (Nunito) · « العربية » (Baloo) ;
actif `#1B2559`/`#FFF`.
« Taille du texte » `15px/700` + 3 boutons `48 × 48` `r 14` Fredoka 600 affichant « A » en
`14px` / `18px` / `23px` (`aria-label` `Petit` / `Normal` / `Grand`), défaut **Normal** ;
sélection `border 2.5px #1B2559` sinon `1.5px #D6E4F7`.

**NOTIFICATIONS** — `#FFF` `r 22` `padding 4px 14px`, lignes `min-h 60` :

| clé | libellé | sous-titre | contrôle |
|---|---|---|---|
| abs | Absences et changements | Toujours activé : c'est l'essentiel | **verrouillé** (piste pleine + cadenas) |
| lessons | Nouvelles leçons | Un résumé par jour | interrupteur (on) |
| school | Annonces de l'école | Réunions, sorties, fêtes | interrupteur (on) |
| quiet | Heures calmes · 20h–7h | Rien ne sonne la nuit, sauf urgence | interrupteur (on) |

**MODE ENFANT ET SÉCURITÉ** — « Ouvrir le mode enfant » (icône `sparkle` 22 `#1E7A57`) →
`StudentHome` · « Code parent pour quitter » (icône `lock`, valeur `••••` `14px/800 #5A6488`) ·
« Confidentialité et données » (icône `shield`, chevron).

Pied : bouton contour danger « Se déconnecter » (icône `logout` 20) → `Splash` ;
« Madrassti · version 1.0 » `12px/700 #5A6488` centré.

---

## 5. Points ambigus / incohérences relevées

> Aucune de ces décisions n'a été prise unilatéralement — merci d'arbitrer.

### 5.1 À arbitrer

| # | Point | Détail | Option proposée |
|---|---|---|---|
| **A1** | **L'écran de modération n'a aucun lien entrant** | Aucun `href` des 21 écrans ne pointe vers l'écran 18. | **✅ ARBITRÉ** — La feuille s'ouvre à l'envoi dans `Chat`, **uniquement** pour le message d'exemple exact de la maquette (texte toxique) ; tout autre texte s'envoie normalement. Modération mockée. |
| **A2** | **Séances contradictoires côté enseignant** | Écran 14 : `09:45 = Mathématiques 4e B`. Écran 16 : `09:45 = Arabe 4e B` et `11:15 = Mathématiques 4e B`. L'écran 5 (Yassine, 4e B) donne `09:45–11:15 = Mathématiques` → **l'écran 14 est cohérent, l'écran 16 ne l'est pas**. | **✅ ARBITRÉ — l'écran 16 est corrigé** : les matières des deux premières séances sont échangées (`09:45 Mathématiques`, `11:15 Arabe`). Heures, classes et compteurs de familles (28 / 0 / 27) **inchangés** — le `0` est volontaire, il évite de compter deux fois les 28 familles de 4e B (total 55 = les deux classes). Seul écart assumé par rapport aux maquettes. |
| **A3** | **Alerte élève incohérente avec « Ma semaine »** | Écran 13 annonce « Mardi : Maths → Sport à 15h », mais l'écran 11 affiche toujours `ma 15h` le mardi. Le changement n'est pas reflété. | Reproduire tel quel (les deux écrans sont statiques dans la maquette). |
| **A4** | **Commutateur FR / العربية non fonctionnel** | Sur l'écran 2 (Bienvenue) les deux boutons n'ont **aucun gestionnaire** ; sur l'écran 19 le sélecteur de langue est fonctionnel mais ne change que son propre état. | Rendre le commutateur **visuellement identique et cliquable** (état local), sans traduire : conforme à « ne rien traduire pour l'instant ». |
| **A5** | **Onglet actif de l'écran 7** | L'écran Notifications affiche la nav avec `active="home"` (il n'y a pas d'onglet « notifications » chez le parent). | Conserver `home` actif, comme la maquette. |
| **A6** | **Deux jeux de teintes matières** | Pastilles saturées (`#FFE1DC`…) vs lavis de blocs (`#FFF4F2`…) — cf. §2.1. | Deux tokens distincts (`SubjectTints` / `SubjectWashes`). Ce n'est pas un bug. |
| **A7** | **Glyphes `☀` et `✿`** (écran 12) | Ces caractères ne sont pas garantis dans Fredoka ; le navigateur retombe sur une police système. | Les dessiner avec `AppIcon` (`sun`, et un glyphe « fleur » à ajouter) **ou** accepter le repli système. **Recommandation : repli système**, pour ne pas inventer une icône absente de la maquette. |
| **A8** | **Barre de progression « 39 % »** (écran 5) | La valeur est **codée en dur** à `39%`, alors que le calcul réel à 10:20 sur `ma 09:45–11:15` donne `(620−585)/90 = 38,9 %`. | Valeur **calculée** (visuellement identique). |
| **A9** | **« Appeler l'école »** pointe sur `#` | Pas de cible. | Bouton inerte (ou `tel:` désactivé), sans action. |

### 5.2 Non reproductible à l'identique en Flutter

| Point | Raison | Option la plus proche |
|---|---|---|
| `overflow-x: auto` avec `margin: 0 -16px; padding: 0 16px` (chips écrans 6 et 8b) | Flutter n'a pas de « bleed » négatif sur un scrollable. | `ListView` horizontal pleine largeur avec `padding: EdgeInsetsDirectional.only(start: 16, end: 16)` — rendu visuel identique. |
| `text-overflow: ellipsis` sur un `flex` imbriqué | — | `Text(maxLines: 1, overflow: TextOverflow.ellipsis)` dans un `Expanded`. |
| `accent-color` de la case à cocher (écran 16) | Propriété CSS natale. | `Checkbox(activeColor: AppColors.navy)` avec `shape` carré `r 4`. |
| `<select>` natif (écran 16) | — | `DropdownButtonFormField` thémé aux tokens du champ. |
| Ombre dure `0 Npx 0 <couleur>` | Material préfère les ombres floues. | `BoxShadow(offset: Offset(0, N), blurRadius: 0, color: …)` — exact. |
| Anneau `box-shadow: 0 0 0 Npx` | — | `BoxShadow(spreadRadius: N, blurRadius: 0)` **ou** conteneur externe `Border.all(width: N)`. Le second est exact lorsqu'il y a aussi une ombre portée. |
| `letter-spacing: 0.08em` / `0.1em` | Flutter utilise des px. | `letterSpacing = fontSize × 0.08` calculé par style. |
| Mise à l'échelle du texte système | La maquette est à taille fixe. | `MediaQuery.textScalerOf(context)` respecté ; les conteneurs à hauteur fixe deviennent `minHeight` pour éviter les débordements. |

---

## 6. Écrans à créer (hors maquettes) — Login & Sign up

Dans le même langage visuel, en réutilisant strictement les tokens et composants ci-dessus.

### 6.1 Login
- Fond `#EEF5FF`, `padding 20px 20px 28px`.
- **Zitoun `salut`** en haut, dans un disque `#DCEBFF` de `196` (continuité avec le splash).
- Titre « **Bon retour !** » Fredoka 600 `28px/1.2`.
- Champ **téléphone** : préfixe fixe `+216` non éditable à gauche
  (puce `#EEF5FF` `r 12`, `17px/800`), puis saisie ; conteneur `h 56` `r 16`
  `border 1.5px #C9D6EC` `bg #FFF`, `17px/800`, `keyboardType: phone`.
- Champ **mot de passe** : même conteneur + bouton œil à droite (`48 × 48`, `r 16`),
  utilisant les nouveaux glyphes `eye` / `eye-off` (cf. B2).
- Bouton primaire « **Se connecter** » (`h 56`, `r 18`, `#FFC83D`, encre navy,
  `shadow 0 3px 0 #E0A51A`, `17px/800`).
- Liens : « **Mot de passe oublié ?** » (`15px/800 #1F5FBF`, `min-h 48`) et
  « Pas encore de compte ? **Créer un compte** » (texte `#3A4570`, lien `#1F5FBF`).
- Erreurs inline dans le style corail (§3.9, version compacte) :
  `bg #FFE9E5`, `border 1.5px #FFC2B8`, `r 14`, icône `alert` 16 `#B83C30`,
  texte `13px/1.4 #B83C30/700`.

### 6.2 Sign up — 2 étapes
Indicateur d'étapes en haut : 2 barres `h 8` `r 4`, active `28px #1B2559`,
inactive `8px #A9D1FF` (même langage que les points de l'écran 2), + « Étape 1 sur 2 »
`13px/700 #5A6488`.

- **Étape 1** — réutilise **tel quel** l'écran 3 (rôle + code d'invitation),
  bouton « Continuer ».
- **Étape 2 — « Vos informations »** : Prénom · Nom · Téléphone (`+216`) ·
  Mot de passe · Confirmation ; puis case à cocher
  « J'accepte les conditions d'utilisation » (case 24 `r 6`, `accent #1B2559`,
  libellé `14px/600`, le segment « conditions d'utilisation » en `#1F5FBF/800`).
  Bouton primaire « **Créer mon compte** ».

Messages de validation (français, bienveillants, style corail) :

| Champ | Règle | Message |
|---|---|---|
| Prénom / Nom | non vide, ≥ 2 car. | « Indiquez votre prénom, s'il vous plaît. » / « Indiquez votre nom, s'il vous plaît. » |
| Téléphone | 8 chiffres après `+216` | « Un numéro tunisien compte 8 chiffres. » |
| Mot de passe | ≥ 6 car. | « Choisissez un mot de passe d'au moins 6 caractères. » |
| Confirmation | identique | « Les deux mots de passe ne sont pas identiques. » |
| Conditions | cochée | « Merci d'accepter les conditions pour continuer. » |
| Code (étape 1) | non vide | « Saisissez le code envoyé par l'école. » |
| Login tél. | 8 chiffres | « Un numéro tunisien compte 8 chiffres. » |
| Login mdp | non vide | « Saisissez votre mot de passe. » |

**Flux** : `Splash → Welcome → Login`. `Login ⇄ Signup`. Les deux terminent sur l'accueil
du rôle choisi (auth mockée). L'écran 3 reste accessible depuis `Welcome` (« Passer »)
et depuis `Settings` (« Ajouter un enfant »), comme dans les maquettes.

> **✅ ARBITRÉ (B1)** : « Commencer » et « Passer » mènent à **`Login`**. L'écran 3 (`Role`)
> devient **l'étape 1 de l'inscription**. Il reste aussi accessible depuis `Settings`
> (« Ajouter un enfant avec un code ») et depuis le bouton « Quitter le mode enfant »
> de l'écran 10, comme dans les maquettes. Aucun écran n'est perdu.

> **✅ ARBITRÉ (B2)** : deux glyphes **`eye` et `eye-off`** sont ajoutés au jeu, dessinés
> dans le style exact des 39 autres (viewBox `0 0 24 24`, `fill: none`,
> `stroke: currentColor`, `stroke-width 2`, bouts et jointures ronds).
> Le jeu passe donc à **41 glyphes**, dont 39 strictement issus des maquettes.

---

## 7. Plan d'implémentation

### 7.1 Environnement
Flutter **3.47.5** stable · Dart **3.13.4** · Material 3 avec thème entièrement surchargé ·
Chrome disponible pour la vérification visuelle.

Paquets : `go_router`, `flutter_riverpod`, `google_fonts`,
`flutter_localizations` + `intl`, `flutter_svg` (seulement si nécessaire).

### 7.2 Arborescence
```
madrasstiApp/
├── docs/SPEC.md
├── lib/
│   ├── main.dart
│   ├── app.dart                      # MaterialApp.router + thème
│   ├── core/
│   │   ├── theme/                    # AppColors AppTextStyles AppRadii AppShadows AppSpacing
│   │   │   └── app_theme.dart
│   │   ├── router/app_router.dart    # go_router + StatefulShellRoute par rôle
│   │   └── widgets/
│   │       ├── app_icon.dart         # 39 (+2 ?) glyphes, CustomPainter
│   │       ├── zitoun.dart           # mascotte, 3 moods
│   │       ├── subject_tile.dart
│   │       ├── role_bottom_nav.dart
│   │       ├── buttons.dart          # primaire / navy / contour / rond / icône
│   │       ├── status_chip.dart
│   │       ├── app_switch.dart
│   │       ├── notification_row.dart
│   │       ├── alert_card.dart
│   │       └── fields.dart           # champs, préfixe +216, mot de passe
│   ├── features/
│   │   ├── onboarding/   # splash, welcome, role
│   │   ├── auth/         # login, signup (2 étapes)
│   │   ├── parent/       # dashboard, week, lessons, notifications, messages, chat, child
│   │   ├── student/      # home, week, lessons, alerts
│   │   ├── teacher/      # home, publish, absence, messages
│   │   └── shared/       # moderation sheet, settings
│   ├── data/
│   │   ├── models/
│   │   ├── repositories/             # interfaces
│   │   └── mock/                     # données d'exemple + NOW figé
│   └── l10n/app_fr.arb
└── test/golden/
```

`NOW` figé : **lundi 23 novembre, 10:20** (= 620 min), journée 8h→16h (480→960),
exposé par un `Clock` injectable pour que les goldens soient déterministes.

### 7.3 Ordre de travail (un commit par phase)
1. **SPEC** ← *ce document* (+ `git init`)
2. Thème et widgets partagés (tokens, 39 icônes, Zitoun, Subject, Nav, boutons, chips, switch)
3. Onboarding (1–3) et auth (Login, Sign up)
4. Parent (4–9)
5. Élève (10–13)
6. Enseignant (14–17)
7. Modération (18) et réglages (19)
8. Goldens + contrôle de fidélité 390 × 844, `flutter analyze` propre, `flutter test` vert

### 7.4 Accessibilité (contraintes tenues tout du long)
Cibles ≥ **48 dp** (≥ **64 dp** sur les écrans élève) · corps ≥ **16** ·
`Semantics` sur chaque bouton icône (libellés déjà présents dans les maquettes via
`aria-label`, repris littéralement) · `textScaler` système respecté ·
`EdgeInsetsDirectional` / `AlignmentDirectional` partout pour préparer le RTL arabe.

### 7.5 Vérification de fidélité
- Rendu Flutter web dans Chrome à **390 × 844**, comparaison côte à côte avec les maquettes
  d'origine (`../mockups/*.html` s'ouvrent directement dans Chrome et affichent
  tous leurs boards).
- L'extraction du markup est reproductible via `docs/tools/01_unpack_boards.py` →
  `02_extract_templates.py` → `03_clean.py` (voir §0).
- Goldens : les widgets partagés + **Dashboard parent**, **Accueil élève**, **feuille de modération**.
