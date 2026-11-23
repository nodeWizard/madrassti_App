import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppL10n
/// returned by `AppL10n.of(context)`.
///
/// Applications need to include `AppL10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppL10n.localizationsDelegates,
///   supportedLocales: AppL10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppL10n.supportedLocales
/// property.
abstract class AppL10n {
  AppL10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppL10n of(BuildContext context) {
    return Localizations.of<AppL10n>(context, AppL10n)!;
  }

  static const LocalizationsDelegate<AppL10n> delegate = _AppL10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('fr')];

  /// Nom de l'application
  ///
  /// In fr, this message translates to:
  /// **'Madrassti'**
  String get appName;

  /// Accroche du splash
  ///
  /// In fr, this message translates to:
  /// **'L\'école de mon enfant, dans ma poche.'**
  String get appTagline;

  /// Nom de l'application en arabe
  ///
  /// In fr, this message translates to:
  /// **'مدرستي'**
  String get appNameArabic;

  /// Pied de page des réglages
  ///
  /// In fr, this message translates to:
  /// **'Madrassti · version 1.0'**
  String get appVersion;

  /// Libellé accessible du splash
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir Madrassti'**
  String get openApp;

  /// Bouton de langue
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// Bouton de langue, en arabe
  ///
  /// In fr, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// Libellé du groupe de langue
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get languageGroup;

  /// Lien pour passer l'introduction
  ///
  /// In fr, this message translates to:
  /// **'Passer'**
  String get skip;

  /// Bouton du carrousel
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get next;

  /// Bouton de la dernière diapositive
  ///
  /// In fr, this message translates to:
  /// **'Commencer'**
  String get start;

  /// Titre diapositive 1
  ///
  /// In fr, this message translates to:
  /// **'La journée de votre enfant, d’un coup d’œil'**
  String get slide1Title;

  /// Corps diapositive 1
  ///
  /// In fr, this message translates to:
  /// **'Le cours en ce moment, le suivant et ce qui change — sans chercher.'**
  String get slide1Body;

  /// Titre diapositive 2
  ///
  /// In fr, this message translates to:
  /// **'Les changements arrivent à temps'**
  String get slide2Title;

  /// Corps diapositive 2
  ///
  /// In fr, this message translates to:
  /// **'Absence d’un enseignant, horaire modifié, nouvelle leçon : vous êtes prévenu, sans être dérangé.'**
  String get slide2Body;

  /// Titre diapositive 3
  ///
  /// In fr, this message translates to:
  /// **'Parlez simplement avec l’enseignant'**
  String get slide3Title;

  /// Corps diapositive 3
  ///
  /// In fr, this message translates to:
  /// **'Des messages directs, respectueux et vérifiés, pour chaque enfant.'**
  String get slide3Body;

  /// Titre de la carte illustrée, diapositive 1
  ///
  /// In fr, this message translates to:
  /// **'La journée de Yassine'**
  String get slide1CardTitle;

  /// Étiquette majuscule
  ///
  /// In fr, this message translates to:
  /// **'MAINTENANT'**
  String get nowUpper;

  /// Étiquette majuscule
  ///
  /// In fr, this message translates to:
  /// **'DEMAIN'**
  String get tomorrowUpper;

  /// Puce de la diapositive 3
  ///
  /// In fr, this message translates to:
  /// **'Messages vérifiés et bienveillants'**
  String get moderationBadge;

  /// Titre du choix de rôle
  ///
  /// In fr, this message translates to:
  /// **'Qui utilise Madrassti ?'**
  String get roleTitle;

  /// Sous-titre du choix de rôle
  ///
  /// In fr, this message translates to:
  /// **'Choisissez votre profil. L\'école vous a envoyé un code pour le confirmer.'**
  String get roleSubtitle;

  /// Libellé du groupe de rôles
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get roleGroup;

  /// Rôle
  ///
  /// In fr, this message translates to:
  /// **'Parent'**
  String get roleParent;

  /// Description du rôle parent
  ///
  /// In fr, this message translates to:
  /// **'Suivre la journée, les leçons et parler aux enseignants.'**
  String get roleParentDesc;

  /// Aide du rôle parent
  ///
  /// In fr, this message translates to:
  /// **'Reçu par SMS ou sur le carnet de liaison. Un seul code suffit pour tous vos enfants.'**
  String get roleParentHint;

  /// Rôle
  ///
  /// In fr, this message translates to:
  /// **'Élève'**
  String get roleStudent;

  /// Description du rôle élève
  ///
  /// In fr, this message translates to:
  /// **'Sur le téléphone d’un parent ? Ouvrez le mode enfant.'**
  String get roleStudentDesc;

  /// Aide du rôle élève
  ///
  /// In fr, this message translates to:
  /// **'Demandez le code à un parent. Il pourra verrouiller le mode enfant avec un code secret.'**
  String get roleStudentHint;

  /// Rôle
  ///
  /// In fr, this message translates to:
  /// **'Enseignant'**
  String get roleTeacher;

  /// Description du rôle enseignant
  ///
  /// In fr, this message translates to:
  /// **'Publier des leçons, signaler un changement, répondre aux parents.'**
  String get roleTeacherDesc;

  /// Aide du rôle enseignant
  ///
  /// In fr, this message translates to:
  /// **'Code fourni par la direction de votre école.'**
  String get roleTeacherHint;

  /// Libellé du champ code
  ///
  /// In fr, this message translates to:
  /// **'Code d\'invitation de l\'école'**
  String get invitationCodeLabel;

  /// Exemple de code
  ///
  /// In fr, this message translates to:
  /// **'Ex. : 4B-7K2Q'**
  String get invitationCodeHint;

  /// Bouton continuer
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get continueLabel;

  /// Libellé accessible du bouton retour
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get back;

  /// Titre de l'écran de connexion
  ///
  /// In fr, this message translates to:
  /// **'Bon retour !'**
  String get loginTitle;

  /// Libellé du champ téléphone
  ///
  /// In fr, this message translates to:
  /// **'Numéro de téléphone'**
  String get phoneLabel;

  /// Exemple de numéro
  ///
  /// In fr, this message translates to:
  /// **'12 345 678'**
  String get phoneHint;

  /// Libellé du champ mot de passe
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get passwordLabel;

  /// Exemple de mot de passe
  ///
  /// In fr, this message translates to:
  /// **'Votre mot de passe'**
  String get passwordHint;

  /// Libellé accessible
  ///
  /// In fr, this message translates to:
  /// **'Afficher le mot de passe'**
  String get showPassword;

  /// Libellé accessible
  ///
  /// In fr, this message translates to:
  /// **'Masquer le mot de passe'**
  String get hidePassword;

  /// Bouton de connexion
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get signIn;

  /// Lien de récupération
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié ?'**
  String get forgotPassword;

  /// Texte avant le lien d'inscription
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de compte ?'**
  String get noAccountYet;

  /// Lien d'inscription
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get createAccount;

  /// Indicateur d'étape
  ///
  /// In fr, this message translates to:
  /// **'Étape {current} sur {total}'**
  String signupStepLabel(int current, int total);

  /// Titre de l'étape 2
  ///
  /// In fr, this message translates to:
  /// **'Vos informations'**
  String get signupDetailsTitle;

  /// Sous-titre de l'étape 2
  ///
  /// In fr, this message translates to:
  /// **'Encore une étape et c\'est prêt.'**
  String get signupDetailsSubtitle;

  /// Libellé du champ prénom
  ///
  /// In fr, this message translates to:
  /// **'Prénom'**
  String get firstNameLabel;

  /// Libellé du champ nom
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get lastNameLabel;

  /// Libellé de la confirmation
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le mot de passe'**
  String get passwordConfirmLabel;

  /// Début de la case à cocher des conditions
  ///
  /// In fr, this message translates to:
  /// **'J\'accepte les '**
  String get acceptTerms;

  /// Lien des conditions d'utilisation
  ///
  /// In fr, this message translates to:
  /// **'conditions d\'utilisation'**
  String get termsOfUse;

  /// Bouton d'inscription
  ///
  /// In fr, this message translates to:
  /// **'Créer mon compte'**
  String get createMyAccount;

  /// Erreur de validation
  ///
  /// In fr, this message translates to:
  /// **'Indiquez votre prénom, s\'il vous plaît.'**
  String get errorFirstName;

  /// Erreur de validation
  ///
  /// In fr, this message translates to:
  /// **'Indiquez votre nom, s\'il vous plaît.'**
  String get errorLastName;

  /// Erreur de validation
  ///
  /// In fr, this message translates to:
  /// **'Un numéro tunisien compte 8 chiffres.'**
  String get errorPhone;

  /// Erreur de validation
  ///
  /// In fr, this message translates to:
  /// **'Choisissez un mot de passe d\'au moins 6 caractères.'**
  String get errorPasswordShort;

  /// Erreur de validation
  ///
  /// In fr, this message translates to:
  /// **'Saisissez votre mot de passe.'**
  String get errorPasswordEmpty;

  /// Erreur de validation
  ///
  /// In fr, this message translates to:
  /// **'Les deux mots de passe ne sont pas identiques.'**
  String get errorPasswordMismatch;

  /// Erreur de validation
  ///
  /// In fr, this message translates to:
  /// **'Merci d\'accepter les conditions pour continuer.'**
  String get errorTerms;

  /// Erreur de validation
  ///
  /// In fr, this message translates to:
  /// **'Saisissez le code envoyé par l\'école.'**
  String get errorCode;

  /// Salutation de l'accueil parent
  ///
  /// In fr, this message translates to:
  /// **'Bonjour {name}'**
  String greeting(String name);

  /// Libellé accessible de la cloche
  ///
  /// In fr, this message translates to:
  /// **'Notifications, {count} non lues'**
  String notificationsWithCount(int count);

  /// Libellé du sélecteur d'enfant
  ///
  /// In fr, this message translates to:
  /// **'Choisir un enfant'**
  String get chooseChild;

  /// Libellé accessible de la carte d'alerte
  ///
  /// In fr, this message translates to:
  /// **'Changement important'**
  String get importantChange;

  /// Bouton de la carte d'alerte
  ///
  /// In fr, this message translates to:
  /// **'Voir demain'**
  String get seeTomorrow;

  /// Bouton pour masquer l'alerte
  ///
  /// In fr, this message translates to:
  /// **'Compris'**
  String get understood;

  /// Titre du ruban de la journée
  ///
  /// In fr, this message translates to:
  /// **'La journée de {name}'**
  String dayOf(String name);

  /// Puce de statut
  ///
  /// In fr, this message translates to:
  /// **'Changement demain'**
  String get changeTomorrow;

  /// Puce de statut
  ///
  /// In fr, this message translates to:
  /// **'Journée normale'**
  String get normalDay;

  /// Étiquette de la pause dans le ruban
  ///
  /// In fr, this message translates to:
  /// **'Pause'**
  String get breakLabel;

  /// Kicker de la carte en cours
  ///
  /// In fr, this message translates to:
  /// **'Maintenant · encore {minutes} min'**
  String nowRemaining(int minutes);

  /// Prochaine matière
  ///
  /// In fr, this message translates to:
  /// **'Ensuite : {name}'**
  String nextLesson(String name);

  /// Libellé de la grille de raccourcis
  ///
  /// In fr, this message translates to:
  /// **'Raccourcis'**
  String get shortcuts;

  /// Raccourci vers la messagerie
  ///
  /// In fr, this message translates to:
  /// **'Écrire'**
  String get write;

  /// Raccourci vers les leçons
  ///
  /// In fr, this message translates to:
  /// **'Leçons'**
  String get lessonsLabel;

  /// Raccourci vers l'emploi du temps
  ///
  /// In fr, this message translates to:
  /// **'La semaine'**
  String get theWeek;

  /// Sous-titre du raccourci semaine
  ///
  /// In fr, this message translates to:
  /// **'Emploi du temps'**
  String get timetable;

  /// Titre de section
  ///
  /// In fr, this message translates to:
  /// **'Récemment'**
  String get recently;

  /// Lien vers la liste complète
  ///
  /// In fr, this message translates to:
  /// **'Tout voir'**
  String get seeAll;

  /// Sur-titre de l'emploi du temps
  ///
  /// In fr, this message translates to:
  /// **'Semaine du 23 au 28 novembre'**
  String get weekRange;

  /// Libellé des onglets de jour
  ///
  /// In fr, this message translates to:
  /// **'Jours de la semaine'**
  String get weekDays;

  /// Préfixe du jour courant
  ///
  /// In fr, this message translates to:
  /// **'Aujourd’hui'**
  String get today;

  /// Titre du jour courant
  ///
  /// In fr, this message translates to:
  /// **'Aujourd’hui · {day}'**
  String todayWithDay(String day);

  /// Résumé du jour
  ///
  /// In fr, this message translates to:
  /// **'{count} cours · {from}–{to}'**
  String daySummary(int count, String from, String to);

  /// Ligne de pause
  ///
  /// In fr, this message translates to:
  /// **'Pause déjeuner'**
  String get lunchBreak;

  /// Puce du cours en cours
  ///
  /// In fr, this message translates to:
  /// **'En cours'**
  String get inProgress;

  /// Puce du cours modifié
  ///
  /// In fr, this message translates to:
  /// **'Modifié'**
  String get changed;

  /// Détail du cours modifié
  ///
  /// In fr, this message translates to:
  /// **'Remplace l\'éveil scientifique · Mme Trabelsi absente'**
  String get replacesScience;

  /// Message d'après-midi libre
  ///
  /// In fr, this message translates to:
  /// **'Après-midi libre, à demain !'**
  String get freeAfternoon;

  /// Libellé accessible du point de changement
  ///
  /// In fr, this message translates to:
  /// **'Changement'**
  String get changeLabel;

  /// Titre de l'écran leçons
  ///
  /// In fr, this message translates to:
  /// **'Leçons et documents'**
  String get lessonsTitle;

  /// Placeholder de recherche
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une leçon'**
  String get searchLesson;

  /// Libellé des filtres
  ///
  /// In fr, this message translates to:
  /// **'Filtrer par matière'**
  String get filterBySubject;

  /// Filtre : toutes les matières
  ///
  /// In fr, this message translates to:
  /// **'Toutes'**
  String get filterAll;

  /// Filtre matière
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get filterFrench;

  /// Filtre matière
  ///
  /// In fr, this message translates to:
  /// **'Maths'**
  String get filterMaths;

  /// Filtre matière
  ///
  /// In fr, this message translates to:
  /// **'Arabe'**
  String get filterArabic;

  /// Filtre matière
  ///
  /// In fr, this message translates to:
  /// **'Éveil'**
  String get filterScience;

  /// Puce nouveau
  ///
  /// In fr, this message translates to:
  /// **'Nouveau'**
  String get newLabel;

  /// Puce hors connexion
  ///
  /// In fr, this message translates to:
  /// **'Hors connexion'**
  String get offline;

  /// Libellé accessible du bouton de téléchargement
  ///
  /// In fr, this message translates to:
  /// **'Télécharger {title}'**
  String download(String title);

  /// Titre de l'écran
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Libellé accessible / bouton
  ///
  /// In fr, this message translates to:
  /// **'Retour à l\'accueil'**
  String get backToHome;

  /// Bouton tout marquer comme lu
  ///
  /// In fr, this message translates to:
  /// **'Tout lire'**
  String get markAllRead;

  /// Libellé du groupe de filtres
  ///
  /// In fr, this message translates to:
  /// **'Filtrer'**
  String get filter;

  /// Filtre : tout
  ///
  /// In fr, this message translates to:
  /// **'Tout'**
  String get filterEverything;

  /// Filtre : changements
  ///
  /// In fr, this message translates to:
  /// **'Changements'**
  String get filterChanges;

  /// Filtre : leçons
  ///
  /// In fr, this message translates to:
  /// **'Leçons'**
  String get filterLessons;

  /// Filtre : école
  ///
  /// In fr, this message translates to:
  /// **'École'**
  String get filterSchool;

  /// Titre de la section épinglée
  ///
  /// In fr, this message translates to:
  /// **'À retenir'**
  String get toRemember;

  /// Bouton de l'élément épinglé
  ///
  /// In fr, this message translates to:
  /// **'Voir mardi'**
  String get seeTuesday;

  /// Libellé accessible du point non-lu
  ///
  /// In fr, this message translates to:
  /// **'Non lu'**
  String get unread;

  /// Titre de l'écran messages
  ///
  /// In fr, this message translates to:
  /// **'Messages'**
  String get messages;

  /// Bandeau d'information
  ///
  /// In fr, this message translates to:
  /// **'Les enseignants répondent en général entre 8h et 17h, du lundi au samedi.'**
  String get replyHours;

  /// Pied de la liste des messages
  ///
  /// In fr, this message translates to:
  /// **'Chaque message est relu automatiquement pour rester respectueux. Seuls vous et l\'enseignant le lisez.'**
  String get moderationNotice;

  /// Libellé accessible
  ///
  /// In fr, this message translates to:
  /// **'Retour aux messages'**
  String get backToMessages;

  /// Séparateur de date du fil
  ///
  /// In fr, this message translates to:
  /// **'Aujourd\'hui'**
  String get todayChip;

  /// Accusé de lecture
  ///
  /// In fr, this message translates to:
  /// **'Lu'**
  String get readReceipt;

  /// Horodatage d'un message venant d'être envoyé
  ///
  /// In fr, this message translates to:
  /// **'À l\'instant · Envoyé'**
  String get justNowSent;

  /// Libellé accessible du champ de saisie
  ///
  /// In fr, this message translates to:
  /// **'Votre message'**
  String get yourMessage;

  /// Placeholder du champ de saisie
  ///
  /// In fr, this message translates to:
  /// **'Écrire un message…'**
  String get writeMessage;

  /// Libellé accessible
  ///
  /// In fr, this message translates to:
  /// **'Joindre un fichier'**
  String get attachFile;

  /// Libellé accessible du bouton d'envoi
  ///
  /// In fr, this message translates to:
  /// **'Envoyer'**
  String get send;

  /// Libellé accessible
  ///
  /// In fr, this message translates to:
  /// **'Écrire à {name}'**
  String writeTo(String name);

  /// Titre de l'écran
  ///
  /// In fr, this message translates to:
  /// **'Profil de l\'enfant'**
  String get childProfile;

  /// Étiquette de statistique
  ///
  /// In fr, this message translates to:
  /// **'CLASSE'**
  String get classUpper;

  /// Étiquette de statistique
  ///
  /// In fr, this message translates to:
  /// **'SALLE'**
  String get roomUpper;

  /// Étiquette de statistique
  ///
  /// In fr, this message translates to:
  /// **'ÉLÈVES'**
  String get studentsUpper;

  /// Titre de section
  ///
  /// In fr, this message translates to:
  /// **'Ses enseignants'**
  String get histeachers;

  /// Titre de section
  ///
  /// In fr, this message translates to:
  /// **'L\'école'**
  String get theSchool;

  /// Horaires de l'école
  ///
  /// In fr, this message translates to:
  /// **'Lun–ven 8h–12h et 14h–16h · Mer et sam 8h–12h'**
  String get schoolHours;

  /// Adresse, telle quelle dans la maquette
  ///
  /// In fr, this message translates to:
  /// **'[Adresse de l\'école]'**
  String get schoolAddressPlaceholder;

  /// Bouton d'appel
  ///
  /// In fr, this message translates to:
  /// **'Appeler l\'école'**
  String get callSchool;

  /// Titre de section
  ///
  /// In fr, this message translates to:
  /// **'Informations'**
  String get information;

  /// Libellé d'information
  ///
  /// In fr, this message translates to:
  /// **'Date de naissance'**
  String get birthDate;

  /// Date, telle quelle dans la maquette
  ///
  /// In fr, this message translates to:
  /// **'[JJ/MM/AAAA]'**
  String get birthDatePlaceholder;

  /// Libellé d'information
  ///
  /// In fr, this message translates to:
  /// **'Contact principal'**
  String get mainContact;

  /// Libellé d'information
  ///
  /// In fr, this message translates to:
  /// **'Autre contact'**
  String get otherContact;

  /// Contact, tel quel dans la maquette
  ///
  /// In fr, this message translates to:
  /// **'[Nom · téléphone]'**
  String get otherContactPlaceholder;

  /// Note de bas de section
  ///
  /// In fr, this message translates to:
  /// **'Une information est fausse ? Seule l\'école peut la modifier — écrivez à l\'enseignante principale.'**
  String get infoWrongNotice;

  /// Salutation de l'accueil élève
  ///
  /// In fr, this message translates to:
  /// **'Salut {name} !'**
  String studentGreeting(String name);

  /// Libellé accessible
  ///
  /// In fr, this message translates to:
  /// **'Quitter le mode enfant (code parent)'**
  String get exitKidMode;

  /// Bulle de Zitoun
  ///
  /// In fr, this message translates to:
  /// **'C\'est l\'heure des {subject} !'**
  String timeForSubject(String subject);

  /// Libellé accessible du bouton de lecture audio
  ///
  /// In fr, this message translates to:
  /// **'Écouter'**
  String get listen;

  /// Libellé accessible de la carte en cours
  ///
  /// In fr, this message translates to:
  /// **'Maintenant'**
  String get now;

  /// Enseignant du cours en cours
  ///
  /// In fr, this message translates to:
  /// **'avec {name}'**
  String withTeacher(String name);

  /// Heure de fin du cours
  ///
  /// In fr, this message translates to:
  /// **'jusqu\'à {time}'**
  String untilTime(String time);

  /// Titre de section élève
  ///
  /// In fr, this message translates to:
  /// **'Ma journée'**
  String get myDay;

  /// Libellé accessible de l'étape déjeuner
  ///
  /// In fr, this message translates to:
  /// **'Déjeuner'**
  String get lunch;

  /// Titre / carte élève
  ///
  /// In fr, this message translates to:
  /// **'Mes leçons'**
  String get myLessons;

  /// Titre / carte élève
  ///
  /// In fr, this message translates to:
  /// **'Ma semaine'**
  String get myWeek;

  /// Badge de la carte leçons
  ///
  /// In fr, this message translates to:
  /// **'1 nouvelle'**
  String get oneNewLesson;

  /// Libellé des onglets de jour
  ///
  /// In fr, this message translates to:
  /// **'Jours'**
  String get days;

  /// Titre de section
  ///
  /// In fr, this message translates to:
  /// **'Le matin'**
  String get morning;

  /// Titre de section
  ///
  /// In fr, this message translates to:
  /// **'L\'après-midi'**
  String get afternoon;

  /// Message d'après-midi libre, élève
  ///
  /// In fr, this message translates to:
  /// **'Pas d\'école, on joue !'**
  String get noSchoolPlay;

  /// Libellé des onglets de matière
  ///
  /// In fr, this message translates to:
  /// **'Matières'**
  String get subjects;

  /// Puce nouveau, élève
  ///
  /// In fr, this message translates to:
  /// **'Nouveau !'**
  String get newExclaim;

  /// Libellé accessible
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir {title}'**
  String openLesson(String title);

  /// État vide
  ///
  /// In fr, this message translates to:
  /// **'Rien de nouveau ici.'**
  String get nothingNewHere;

  /// État vide
  ///
  /// In fr, this message translates to:
  /// **'Ta maîtresse ajoutera bientôt des leçons.'**
  String get teacherWillAdd;

  /// Titre de l'écran alertes élève
  ///
  /// In fr, this message translates to:
  /// **'Mes alertes'**
  String get myAlerts;

  /// Titre de l'alerte élève
  ///
  /// In fr, this message translates to:
  /// **'Mardi, ça change !'**
  String get tuesdayChanges;

  /// Titre d'alerte
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle leçon'**
  String get newLesson;

  /// Libellé accessible
  ///
  /// In fr, this message translates to:
  /// **'Voir la leçon'**
  String get seeLesson;

  /// Titre d'alerte
  ///
  /// In fr, this message translates to:
  /// **'Vendredi : la fête de l\'arbre'**
  String get treeDayTitle;

  /// Corps d'alerte
  ///
  /// In fr, this message translates to:
  /// **'Apporte une petite plante.'**
  String get treeDayBody;

  /// Félicitations
  ///
  /// In fr, this message translates to:
  /// **'Bravo {name} !'**
  String bravoName(String name);

  /// Corps des félicitations
  ///
  /// In fr, this message translates to:
  /// **'Tu as ouvert toutes tes leçons de la semaine.'**
  String get bravoBody;

  /// Salutation de l'accueil enseignant
  ///
  /// In fr, this message translates to:
  /// **'Bonjour {name}'**
  String teacherGreeting(String name);

  /// Bouton / titre
  ///
  /// In fr, this message translates to:
  /// **'Publier une leçon'**
  String get publishLesson;

  /// Bouton
  ///
  /// In fr, this message translates to:
  /// **'Signaler un changement'**
  String get reportChange;

  /// Titre de section
  ///
  /// In fr, this message translates to:
  /// **'Ma journée'**
  String get myDayTeacher;

  /// Nombre de séances
  ///
  /// In fr, this message translates to:
  /// **'{count} séances'**
  String sessionsCount(int count);

  /// Libellé de statistique
  ///
  /// In fr, this message translates to:
  /// **'messages non lus'**
  String get unreadMessages;

  /// Libellé de statistique
  ///
  /// In fr, this message translates to:
  /// **'leçons publiées cette semaine'**
  String get lessonsPublishedThisWeek;

  /// Titre de section
  ///
  /// In fr, this message translates to:
  /// **'Derniers messages'**
  String get latestMessages;

  /// Libellé de champ
  ///
  /// In fr, this message translates to:
  /// **'Classe'**
  String get classLabel;

  /// Libellé de champ
  ///
  /// In fr, this message translates to:
  /// **'Matière'**
  String get subjectLabel;

  /// Libellé de champ
  ///
  /// In fr, this message translates to:
  /// **'Titre de la leçon'**
  String get lessonTitleLabel;

  /// Libellé de champ
  ///
  /// In fr, this message translates to:
  /// **'Mot pour les familles'**
  String get wordForFamilies;

  /// Suffixe de libellé
  ///
  /// In fr, this message translates to:
  /// **'(facultatif)'**
  String get optional;

  /// Libellé de section
  ///
  /// In fr, this message translates to:
  /// **'Documents'**
  String get documents;

  /// Libellé accessible
  ///
  /// In fr, this message translates to:
  /// **'Retirer le fichier'**
  String get removeFile;

  /// Bouton d'ajout
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un fichier ou une photo'**
  String get addFileOrPhoto;

  /// Libellé d'interrupteur
  ///
  /// In fr, this message translates to:
  /// **'Prévenir les parents'**
  String get notifyParents;

  /// Libellé d'interrupteur
  ///
  /// In fr, this message translates to:
  /// **'Visible dans le mode enfant'**
  String get visibleInKidMode;

  /// Résumé avant publication
  ///
  /// In fr, this message translates to:
  /// **'{families} familles · notifiées : {who}'**
  String publishSummary(int families, String who);

  /// Audience
  ///
  /// In fr, this message translates to:
  /// **'parents et élèves'**
  String get audienceBoth;

  /// Audience
  ///
  /// In fr, this message translates to:
  /// **'parents'**
  String get audienceParents;

  /// Audience
  ///
  /// In fr, this message translates to:
  /// **'élèves'**
  String get audienceStudents;

  /// Audience
  ///
  /// In fr, this message translates to:
  /// **'personne'**
  String get audienceNobody;

  /// Bouton de publication
  ///
  /// In fr, this message translates to:
  /// **'Publier la leçon'**
  String get publishTheLesson;

  /// Titre de la feuille de succès
  ///
  /// In fr, this message translates to:
  /// **'Leçon publiée !'**
  String get lessonPublished;

  /// Corps de la feuille de succès
  ///
  /// In fr, this message translates to:
  /// **'Les {families} familles de {classes} la retrouveront dans « Leçons ».'**
  String lessonPublishedBody(int families, String classes);

  /// Les deux classes
  ///
  /// In fr, this message translates to:
  /// **'4e A et 4e B'**
  String get bothClasses;

  /// Titre de l'écran absence
  ///
  /// In fr, this message translates to:
  /// **'Prévenir les familles'**
  String get notifyFamilies;

  /// Libellé du groupe de types
  ///
  /// In fr, this message translates to:
  /// **'Type'**
  String get type;

  /// Type de signalement
  ///
  /// In fr, this message translates to:
  /// **'Mon absence'**
  String get typeAbsence;

  /// Type de signalement
  ///
  /// In fr, this message translates to:
  /// **'Changement d’horaire'**
  String get typeSchedule;

  /// Type de signalement
  ///
  /// In fr, this message translates to:
  /// **'Annonce'**
  String get typeAnnouncement;

  /// Libellé de champ
  ///
  /// In fr, this message translates to:
  /// **'Quel jour ?'**
  String get whichDay;

  /// Libellé de champ
  ///
  /// In fr, this message translates to:
  /// **'Votre annonce'**
  String get yourAnnouncement;

  /// Libellé de la liste de séances
  ///
  /// In fr, this message translates to:
  /// **'Cours concernés'**
  String get sessionsConcerned;

  /// Libellé de la liste de séances
  ///
  /// In fr, this message translates to:
  /// **'Quel cours est déplacé ?'**
  String get whichSessionMoved;

  /// Libellé du groupe d'options
  ///
  /// In fr, this message translates to:
  /// **'Que se passe-t-il pour les élèves ?'**
  String get whatHappensToStudents;

  /// Option d'absence
  ///
  /// In fr, this message translates to:
  /// **'Remplacé par un collègue'**
  String get optionColleague;

  /// Option d'absence
  ///
  /// In fr, this message translates to:
  /// **'Étude surveillée'**
  String get optionStudyRoom;

  /// Option d'absence
  ///
  /// In fr, this message translates to:
  /// **'Cours annulé, sortie plus tôt'**
  String get optionCancelled;

  /// Libellé de champ
  ///
  /// In fr, this message translates to:
  /// **'Nouveau jour'**
  String get newDay;

  /// Libellé de champ
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle heure'**
  String get newTime;

  /// Libellé de l'aperçu
  ///
  /// In fr, this message translates to:
  /// **'Ce que verront les parents'**
  String get whatParentsSee;

  /// Bouton d'envoi
  ///
  /// In fr, this message translates to:
  /// **'Prévenir {count} familles'**
  String notifyNFamilies(int count);

  /// Titre de la feuille de succès
  ///
  /// In fr, this message translates to:
  /// **'Familles prévenues'**
  String get familiesNotified;

  /// Corps de la feuille de succès
  ///
  /// In fr, this message translates to:
  /// **'L\'emploi du temps des élèves est mis à jour. La direction reçoit une copie.'**
  String get familiesNotifiedBody;

  /// Libellé accessible de la feuille de succès
  ///
  /// In fr, this message translates to:
  /// **'Envoyé'**
  String get sent;

  /// Bouton
  ///
  /// In fr, this message translates to:
  /// **'Écrire à une classe'**
  String get writeToClass;

  /// Libellé accessible de l'interrupteur
  ///
  /// In fr, this message translates to:
  /// **'Disponible pour les messages'**
  String get availableForMessages;

  /// Titre quand disponible
  ///
  /// In fr, this message translates to:
  /// **'Disponible · 8h–17h'**
  String get availableHours;

  /// Sous-titre quand disponible
  ///
  /// In fr, this message translates to:
  /// **'Les parents voient vos horaires de réponse.'**
  String get availableHoursBody;

  /// Titre quand indisponible
  ///
  /// In fr, this message translates to:
  /// **'En pause'**
  String get onBreak;

  /// Sous-titre quand indisponible
  ///
  /// In fr, this message translates to:
  /// **'Les parents sont informés que vous répondrez plus tard.'**
  String get onBreakBody;

  /// Filtre
  ///
  /// In fr, this message translates to:
  /// **'Non lues'**
  String get filterUnread;

  /// Aperçu parent
  ///
  /// In fr, this message translates to:
  /// **'Un collègue assurera les cours. Horaires de sortie inchangés.'**
  String get absenceBodyColleague;

  /// Aperçu parent
  ///
  /// In fr, this message translates to:
  /// **'Les élèves seront en étude surveillée. Horaires inchangés.'**
  String get absenceBodyStudy;

  /// Aperçu parent
  ///
  /// In fr, this message translates to:
  /// **'Les cours concernés sont annulés : sortie plus tôt, pensez à venir chercher votre enfant.'**
  String get absenceBodyCancelled;

  /// Kicker de l'aperçu
  ///
  /// In fr, this message translates to:
  /// **'ABSENCE · {day}'**
  String previewAbsenceKicker(String day);

  /// Titre de l'aperçu
  ///
  /// In fr, this message translates to:
  /// **'{name} sera absente'**
  String previewAbsenceTitle(String name);

  /// Kicker de l'aperçu
  ///
  /// In fr, this message translates to:
  /// **'HORAIRE MODIFIÉ'**
  String get previewScheduleKicker;

  /// Titre de l'aperçu
  ///
  /// In fr, this message translates to:
  /// **'Cours du {day} déplacé'**
  String previewScheduleTitle(String day);

  /// Corps de l'aperçu
  ///
  /// In fr, this message translates to:
  /// **'Le cours aura lieu jeudi 26 à 14:00, même salle.'**
  String get previewScheduleBody;

  /// Kicker de l'aperçu
  ///
  /// In fr, this message translates to:
  /// **'ANNONCE · 4E A ET 4E B'**
  String get previewAnnouncementKicker;

  /// Titre de l'aperçu
  ///
  /// In fr, this message translates to:
  /// **'Sortie au jardin public'**
  String get previewAnnouncementTitle;

  /// Corps de l'aperçu
  ///
  /// In fr, this message translates to:
  /// **'Mardi matin : prévoir une casquette et une bouteille d’eau.'**
  String get previewAnnouncementBody;

  /// Titre de la feuille de modération
  ///
  /// In fr, this message translates to:
  /// **'Et si on le disait autrement ?'**
  String get moderationTitle;

  /// Sous-titre rassurant
  ///
  /// In fr, this message translates to:
  /// **'Votre message n\'a pas été envoyé. Personne ne l\'a vu.'**
  String get moderationSubtitle;

  /// Étiquette de section
  ///
  /// In fr, this message translates to:
  /// **'VOTRE MESSAGE'**
  String get yourMessageUpper;

  /// Explication de la modération
  ///
  /// In fr, this message translates to:
  /// **'Les mots surlignés peuvent blesser. Votre inquiétude, elle, est légitime : gardons-la.'**
  String get moderationExplain;

  /// Étiquette de section
  ///
  /// In fr, this message translates to:
  /// **'PROPOSITION'**
  String get suggestionUpper;

  /// Bouton d'envoi de la suggestion
  ///
  /// In fr, this message translates to:
  /// **'Envoyer cette version'**
  String get sendThisVersion;

  /// Bouton de reformulation
  ///
  /// In fr, this message translates to:
  /// **'Je reformule moi-même'**
  String get rewriteMyself;

  /// Consigne après reformulation
  ///
  /// In fr, this message translates to:
  /// **'Reformulez, puis envoyez à nouveau.'**
  String get rewriteThenSend;

  /// Confirmation après envoi
  ///
  /// In fr, this message translates to:
  /// **'Merci, c\'est parfait !'**
  String get moderationThanks;

  /// Titre de l'écran réglages
  ///
  /// In fr, this message translates to:
  /// **'Profil et réglages'**
  String get settingsTitle;

  /// Libellé accessible
  ///
  /// In fr, this message translates to:
  /// **'Modifier le profil'**
  String get editProfile;

  /// Titre de section
  ///
  /// In fr, this message translates to:
  /// **'MES ENFANTS'**
  String get myChildren;

  /// Lien d'ajout d'enfant
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un enfant avec un code'**
  String get addChildWithCode;

  /// Titre de section
  ///
  /// In fr, this message translates to:
  /// **'LANGUE ET AFFICHAGE'**
  String get languageAndDisplay;

  /// Libellé de réglage
  ///
  /// In fr, this message translates to:
  /// **'Taille du texte'**
  String get textSize;

  /// Taille de texte
  ///
  /// In fr, this message translates to:
  /// **'Petit'**
  String get textSizeSmall;

  /// Taille de texte
  ///
  /// In fr, this message translates to:
  /// **'Normal'**
  String get textSizeNormal;

  /// Taille de texte
  ///
  /// In fr, this message translates to:
  /// **'Grand'**
  String get textSizeLarge;

  /// Titre de section
  ///
  /// In fr, this message translates to:
  /// **'NOTIFICATIONS'**
  String get notificationsUpper;

  /// Réglage de notification
  ///
  /// In fr, this message translates to:
  /// **'Absences et changements'**
  String get notifAbsences;

  /// Détail du réglage
  ///
  /// In fr, this message translates to:
  /// **'Toujours activé : c’est l’essentiel'**
  String get notifAbsencesBody;

  /// Réglage de notification
  ///
  /// In fr, this message translates to:
  /// **'Nouvelles leçons'**
  String get notifNewLessons;

  /// Détail du réglage
  ///
  /// In fr, this message translates to:
  /// **'Un résumé par jour'**
  String get notifNewLessonsBody;

  /// Réglage de notification
  ///
  /// In fr, this message translates to:
  /// **'Annonces de l’école'**
  String get notifSchool;

  /// Détail du réglage
  ///
  /// In fr, this message translates to:
  /// **'Réunions, sorties, fêtes'**
  String get notifSchoolBody;

  /// Réglage de notification
  ///
  /// In fr, this message translates to:
  /// **'Heures calmes · 20h–7h'**
  String get notifQuietHours;

  /// Détail du réglage
  ///
  /// In fr, this message translates to:
  /// **'Rien ne sonne la nuit, sauf urgence'**
  String get notifQuietHoursBody;

  /// Libellé accessible de l'interrupteur verrouillé
  ///
  /// In fr, this message translates to:
  /// **'Toujours activé'**
  String get alwaysOn;

  /// Titre de section
  ///
  /// In fr, this message translates to:
  /// **'MODE ENFANT ET SÉCURITÉ'**
  String get kidModeAndSecurity;

  /// Lien vers le mode enfant
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir le mode enfant'**
  String get openKidMode;

  /// Réglage de sécurité
  ///
  /// In fr, this message translates to:
  /// **'Code parent pour quitter'**
  String get parentCodeToExit;

  /// Réglage de sécurité
  ///
  /// In fr, this message translates to:
  /// **'Confidentialité et données'**
  String get privacyAndData;

  /// Bouton de déconnexion
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get signOut;

  /// Sous-titre du profil, tel quel dans la maquette
  ///
  /// In fr, this message translates to:
  /// **'Parent · [numéro de téléphone]'**
  String get parentWithPhone;

  /// Libellé accessible de la barre de navigation
  ///
  /// In fr, this message translates to:
  /// **'Navigation principale'**
  String get mainNavigation;

  /// Onglet
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get navHome;

  /// Onglet
  ///
  /// In fr, this message translates to:
  /// **'Semaine'**
  String get navWeek;

  /// Onglet
  ///
  /// In fr, this message translates to:
  /// **'Ma semaine'**
  String get navMyWeek;

  /// Onglet
  ///
  /// In fr, this message translates to:
  /// **'Leçons'**
  String get navLessons;

  /// Onglet
  ///
  /// In fr, this message translates to:
  /// **'Messages'**
  String get navMessages;

  /// Onglet
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// Onglet
  ///
  /// In fr, this message translates to:
  /// **'Alertes'**
  String get navAlerts;

  /// Onglet
  ///
  /// In fr, this message translates to:
  /// **'Publier'**
  String get navPublish;

  /// Onglet
  ///
  /// In fr, this message translates to:
  /// **'Changements'**
  String get navChanges;

  /// Erreur de connexion : identifiants invalides
  ///
  /// In fr, this message translates to:
  /// **'Numéro ou mot de passe incorrect.'**
  String get errorInvalidCredentials;

  /// Titre du bloc de comptes de test sur l’écran de connexion
  ///
  /// In fr, this message translates to:
  /// **'Comptes de démonstration'**
  String get demoAccountsTitle;

  /// Une ligne de compte de demonstration
  ///
  /// In fr, this message translates to:
  /// **'{role} · {phone} · {password}'**
  String demoAccountLine(String role, String phone, String password);
}

class _AppL10nDelegate extends LocalizationsDelegate<AppL10n> {
  const _AppL10nDelegate();

  @override
  Future<AppL10n> load(Locale locale) {
    return SynchronousFuture<AppL10n>(lookupAppL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppL10nDelegate old) => false;
}

AppL10n lookupAppL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'fr':
      return AppL10nFr();
  }

  throw FlutterError(
    'AppL10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
