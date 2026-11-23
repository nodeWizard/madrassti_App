// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppL10nFr extends AppL10n {
  AppL10nFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Madrassti';

  @override
  String get appTagline => 'L\'école de mon enfant, dans ma poche.';

  @override
  String get appNameArabic => 'مدرستي';

  @override
  String get appVersion => 'Madrassti · version 1.0';

  @override
  String get openApp => 'Ouvrir Madrassti';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageGroup => 'Langue';

  @override
  String get skip => 'Passer';

  @override
  String get next => 'Suivant';

  @override
  String get start => 'Commencer';

  @override
  String get slide1Title => 'La journée de votre enfant, d’un coup d’œil';

  @override
  String get slide1Body =>
      'Le cours en ce moment, le suivant et ce qui change — sans chercher.';

  @override
  String get slide2Title => 'Les changements arrivent à temps';

  @override
  String get slide2Body =>
      'Absence d’un enseignant, horaire modifié, nouvelle leçon : vous êtes prévenu, sans être dérangé.';

  @override
  String get slide3Title => 'Parlez simplement avec l’enseignant';

  @override
  String get slide3Body =>
      'Des messages directs, respectueux et vérifiés, pour chaque enfant.';

  @override
  String get slide1CardTitle => 'La journée de Yassine';

  @override
  String get nowUpper => 'MAINTENANT';

  @override
  String get tomorrowUpper => 'DEMAIN';

  @override
  String get moderationBadge => 'Messages vérifiés et bienveillants';

  @override
  String get roleTitle => 'Qui utilise Madrassti ?';

  @override
  String get roleSubtitle =>
      'Choisissez votre profil. L\'école vous a envoyé un code pour le confirmer.';

  @override
  String get roleGroup => 'Profil';

  @override
  String get roleParent => 'Parent';

  @override
  String get roleParentDesc =>
      'Suivre la journée, les leçons et parler aux enseignants.';

  @override
  String get roleParentHint =>
      'Reçu par SMS ou sur le carnet de liaison. Un seul code suffit pour tous vos enfants.';

  @override
  String get roleStudent => 'Élève';

  @override
  String get roleStudentDesc =>
      'Sur le téléphone d’un parent ? Ouvrez le mode enfant.';

  @override
  String get roleStudentHint =>
      'Demandez le code à un parent. Il pourra verrouiller le mode enfant avec un code secret.';

  @override
  String get roleTeacher => 'Enseignant';

  @override
  String get roleTeacherDesc =>
      'Publier des leçons, signaler un changement, répondre aux parents.';

  @override
  String get roleTeacherHint => 'Code fourni par la direction de votre école.';

  @override
  String get invitationCodeLabel => 'Code d\'invitation de l\'école';

  @override
  String get invitationCodeHint => 'Ex. : 4B-7K2Q';

  @override
  String get continueLabel => 'Continuer';

  @override
  String get back => 'Retour';

  @override
  String get loginTitle => 'Bon retour !';

  @override
  String get phoneLabel => 'Numéro de téléphone';

  @override
  String get phoneHint => '12 345 678';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get passwordHint => 'Votre mot de passe';

  @override
  String get showPassword => 'Afficher le mot de passe';

  @override
  String get hidePassword => 'Masquer le mot de passe';

  @override
  String get signIn => 'Se connecter';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get noAccountYet => 'Pas encore de compte ?';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String signupStepLabel(int current, int total) {
    return 'Étape $current sur $total';
  }

  @override
  String get signupDetailsTitle => 'Vos informations';

  @override
  String get signupDetailsSubtitle => 'Encore une étape et c\'est prêt.';

  @override
  String get firstNameLabel => 'Prénom';

  @override
  String get lastNameLabel => 'Nom';

  @override
  String get passwordConfirmLabel => 'Confirmer le mot de passe';

  @override
  String get acceptTerms => 'J\'accepte les ';

  @override
  String get termsOfUse => 'conditions d\'utilisation';

  @override
  String get createMyAccount => 'Créer mon compte';

  @override
  String get errorFirstName => 'Indiquez votre prénom, s\'il vous plaît.';

  @override
  String get errorLastName => 'Indiquez votre nom, s\'il vous plaît.';

  @override
  String get errorPhone => 'Un numéro tunisien compte 8 chiffres.';

  @override
  String get errorPasswordShort =>
      'Choisissez un mot de passe d\'au moins 6 caractères.';

  @override
  String get errorPasswordEmpty => 'Saisissez votre mot de passe.';

  @override
  String get errorPasswordMismatch =>
      'Les deux mots de passe ne sont pas identiques.';

  @override
  String get errorTerms => 'Merci d\'accepter les conditions pour continuer.';

  @override
  String get errorCode => 'Saisissez le code envoyé par l\'école.';

  @override
  String greeting(String name) {
    return 'Bonjour $name';
  }

  @override
  String notificationsWithCount(int count) {
    return 'Notifications, $count non lues';
  }

  @override
  String get chooseChild => 'Choisir un enfant';

  @override
  String get importantChange => 'Changement important';

  @override
  String get seeTomorrow => 'Voir demain';

  @override
  String get understood => 'Compris';

  @override
  String dayOf(String name) {
    return 'La journée de $name';
  }

  @override
  String get changeTomorrow => 'Changement demain';

  @override
  String get normalDay => 'Journée normale';

  @override
  String get breakLabel => 'Pause';

  @override
  String nowRemaining(int minutes) {
    return 'Maintenant · encore $minutes min';
  }

  @override
  String nextLesson(String name) {
    return 'Ensuite : $name';
  }

  @override
  String get shortcuts => 'Raccourcis';

  @override
  String get write => 'Écrire';

  @override
  String get lessonsLabel => 'Leçons';

  @override
  String get theWeek => 'La semaine';

  @override
  String get timetable => 'Emploi du temps';

  @override
  String get recently => 'Récemment';

  @override
  String get seeAll => 'Tout voir';

  @override
  String get weekRange => 'Semaine du 23 au 28 novembre';

  @override
  String get weekDays => 'Jours de la semaine';

  @override
  String get today => 'Aujourd’hui';

  @override
  String todayWithDay(String day) {
    return 'Aujourd’hui · $day';
  }

  @override
  String daySummary(int count, String from, String to) {
    return '$count cours · $from–$to';
  }

  @override
  String get lunchBreak => 'Pause déjeuner';

  @override
  String get inProgress => 'En cours';

  @override
  String get changed => 'Modifié';

  @override
  String get replacesScience =>
      'Remplace l\'éveil scientifique · Mme Trabelsi absente';

  @override
  String get freeAfternoon => 'Après-midi libre, à demain !';

  @override
  String get changeLabel => 'Changement';

  @override
  String get lessonsTitle => 'Leçons et documents';

  @override
  String get searchLesson => 'Rechercher une leçon';

  @override
  String get filterBySubject => 'Filtrer par matière';

  @override
  String get filterAll => 'Toutes';

  @override
  String get filterFrench => 'Français';

  @override
  String get filterMaths => 'Maths';

  @override
  String get filterArabic => 'Arabe';

  @override
  String get filterScience => 'Éveil';

  @override
  String get newLabel => 'Nouveau';

  @override
  String get offline => 'Hors connexion';

  @override
  String download(String title) {
    return 'Télécharger $title';
  }

  @override
  String get notifications => 'Notifications';

  @override
  String get backToHome => 'Retour à l\'accueil';

  @override
  String get markAllRead => 'Tout lire';

  @override
  String get filter => 'Filtrer';

  @override
  String get filterEverything => 'Tout';

  @override
  String get filterChanges => 'Changements';

  @override
  String get filterLessons => 'Leçons';

  @override
  String get filterSchool => 'École';

  @override
  String get toRemember => 'À retenir';

  @override
  String get seeTuesday => 'Voir mardi';

  @override
  String get unread => 'Non lu';

  @override
  String get messages => 'Messages';

  @override
  String get replyHours =>
      'Les enseignants répondent en général entre 8h et 17h, du lundi au samedi.';

  @override
  String get moderationNotice =>
      'Chaque message est relu automatiquement pour rester respectueux. Seuls vous et l\'enseignant le lisez.';

  @override
  String get backToMessages => 'Retour aux messages';

  @override
  String get todayChip => 'Aujourd\'hui';

  @override
  String get readReceipt => 'Lu';

  @override
  String get justNowSent => 'À l\'instant · Envoyé';

  @override
  String get yourMessage => 'Votre message';

  @override
  String get writeMessage => 'Écrire un message…';

  @override
  String get attachFile => 'Joindre un fichier';

  @override
  String get send => 'Envoyer';

  @override
  String writeTo(String name) {
    return 'Écrire à $name';
  }

  @override
  String get childProfile => 'Profil de l\'enfant';

  @override
  String get classUpper => 'CLASSE';

  @override
  String get roomUpper => 'SALLE';

  @override
  String get studentsUpper => 'ÉLÈVES';

  @override
  String get histeachers => 'Ses enseignants';

  @override
  String get theSchool => 'L\'école';

  @override
  String get schoolHours => 'Lun–ven 8h–12h et 14h–16h · Mer et sam 8h–12h';

  @override
  String get schoolAddressPlaceholder => '[Adresse de l\'école]';

  @override
  String get callSchool => 'Appeler l\'école';

  @override
  String get information => 'Informations';

  @override
  String get birthDate => 'Date de naissance';

  @override
  String get birthDatePlaceholder => '[JJ/MM/AAAA]';

  @override
  String get mainContact => 'Contact principal';

  @override
  String get otherContact => 'Autre contact';

  @override
  String get otherContactPlaceholder => '[Nom · téléphone]';

  @override
  String get infoWrongNotice =>
      'Une information est fausse ? Seule l\'école peut la modifier — écrivez à l\'enseignante principale.';

  @override
  String studentGreeting(String name) {
    return 'Salut $name !';
  }

  @override
  String get exitKidMode => 'Quitter le mode enfant (code parent)';

  @override
  String timeForSubject(String subject) {
    return 'C\'est l\'heure des $subject !';
  }

  @override
  String get listen => 'Écouter';

  @override
  String get now => 'Maintenant';

  @override
  String withTeacher(String name) {
    return 'avec $name';
  }

  @override
  String untilTime(String time) {
    return 'jusqu\'à $time';
  }

  @override
  String get myDay => 'Ma journée';

  @override
  String get lunch => 'Déjeuner';

  @override
  String get myLessons => 'Mes leçons';

  @override
  String get myWeek => 'Ma semaine';

  @override
  String get oneNewLesson => '1 nouvelle';

  @override
  String get days => 'Jours';

  @override
  String get morning => 'Le matin';

  @override
  String get afternoon => 'L\'après-midi';

  @override
  String get noSchoolPlay => 'Pas d\'école, on joue !';

  @override
  String get subjects => 'Matières';

  @override
  String get newExclaim => 'Nouveau !';

  @override
  String openLesson(String title) {
    return 'Ouvrir $title';
  }

  @override
  String get nothingNewHere => 'Rien de nouveau ici.';

  @override
  String get teacherWillAdd => 'Ta maîtresse ajoutera bientôt des leçons.';

  @override
  String get myAlerts => 'Mes alertes';

  @override
  String get tuesdayChanges => 'Mardi, ça change !';

  @override
  String get newLesson => 'Nouvelle leçon';

  @override
  String get seeLesson => 'Voir la leçon';

  @override
  String get treeDayTitle => 'Vendredi : la fête de l\'arbre';

  @override
  String get treeDayBody => 'Apporte une petite plante.';

  @override
  String bravoName(String name) {
    return 'Bravo $name !';
  }

  @override
  String get bravoBody => 'Tu as ouvert toutes tes leçons de la semaine.';

  @override
  String teacherGreeting(String name) {
    return 'Bonjour $name';
  }

  @override
  String get publishLesson => 'Publier une leçon';

  @override
  String get reportChange => 'Signaler un changement';

  @override
  String get myDayTeacher => 'Ma journée';

  @override
  String sessionsCount(int count) {
    return '$count séances';
  }

  @override
  String get unreadMessages => 'messages non lus';

  @override
  String get lessonsPublishedThisWeek => 'leçons publiées cette semaine';

  @override
  String get latestMessages => 'Derniers messages';

  @override
  String get classLabel => 'Classe';

  @override
  String get subjectLabel => 'Matière';

  @override
  String get lessonTitleLabel => 'Titre de la leçon';

  @override
  String get wordForFamilies => 'Mot pour les familles';

  @override
  String get optional => '(facultatif)';

  @override
  String get documents => 'Documents';

  @override
  String get removeFile => 'Retirer le fichier';

  @override
  String get addFileOrPhoto => 'Ajouter un fichier ou une photo';

  @override
  String get notifyParents => 'Prévenir les parents';

  @override
  String get visibleInKidMode => 'Visible dans le mode enfant';

  @override
  String publishSummary(int families, String who) {
    return '$families familles · notifiées : $who';
  }

  @override
  String get audienceBoth => 'parents et élèves';

  @override
  String get audienceParents => 'parents';

  @override
  String get audienceStudents => 'élèves';

  @override
  String get audienceNobody => 'personne';

  @override
  String get publishTheLesson => 'Publier la leçon';

  @override
  String get lessonPublished => 'Leçon publiée !';

  @override
  String lessonPublishedBody(int families, String classes) {
    return 'Les $families familles de $classes la retrouveront dans « Leçons ».';
  }

  @override
  String get bothClasses => '4e A et 4e B';

  @override
  String get notifyFamilies => 'Prévenir les familles';

  @override
  String get type => 'Type';

  @override
  String get typeAbsence => 'Mon absence';

  @override
  String get typeSchedule => 'Changement d’horaire';

  @override
  String get typeAnnouncement => 'Annonce';

  @override
  String get whichDay => 'Quel jour ?';

  @override
  String get yourAnnouncement => 'Votre annonce';

  @override
  String get sessionsConcerned => 'Cours concernés';

  @override
  String get whichSessionMoved => 'Quel cours est déplacé ?';

  @override
  String get whatHappensToStudents => 'Que se passe-t-il pour les élèves ?';

  @override
  String get optionColleague => 'Remplacé par un collègue';

  @override
  String get optionStudyRoom => 'Étude surveillée';

  @override
  String get optionCancelled => 'Cours annulé, sortie plus tôt';

  @override
  String get newDay => 'Nouveau jour';

  @override
  String get newTime => 'Nouvelle heure';

  @override
  String get whatParentsSee => 'Ce que verront les parents';

  @override
  String notifyNFamilies(int count) {
    return 'Prévenir $count familles';
  }

  @override
  String get familiesNotified => 'Familles prévenues';

  @override
  String get familiesNotifiedBody =>
      'L\'emploi du temps des élèves est mis à jour. La direction reçoit une copie.';

  @override
  String get sent => 'Envoyé';

  @override
  String get writeToClass => 'Écrire à une classe';

  @override
  String get availableForMessages => 'Disponible pour les messages';

  @override
  String get availableHours => 'Disponible · 8h–17h';

  @override
  String get availableHoursBody =>
      'Les parents voient vos horaires de réponse.';

  @override
  String get onBreak => 'En pause';

  @override
  String get onBreakBody =>
      'Les parents sont informés que vous répondrez plus tard.';

  @override
  String get filterUnread => 'Non lues';

  @override
  String get absenceBodyColleague =>
      'Un collègue assurera les cours. Horaires de sortie inchangés.';

  @override
  String get absenceBodyStudy =>
      'Les élèves seront en étude surveillée. Horaires inchangés.';

  @override
  String get absenceBodyCancelled =>
      'Les cours concernés sont annulés : sortie plus tôt, pensez à venir chercher votre enfant.';

  @override
  String previewAbsenceKicker(String day) {
    return 'ABSENCE · $day';
  }

  @override
  String previewAbsenceTitle(String name) {
    return '$name sera absente';
  }

  @override
  String get previewScheduleKicker => 'HORAIRE MODIFIÉ';

  @override
  String previewScheduleTitle(String day) {
    return 'Cours du $day déplacé';
  }

  @override
  String get previewScheduleBody =>
      'Le cours aura lieu jeudi 26 à 14:00, même salle.';

  @override
  String get previewAnnouncementKicker => 'ANNONCE · 4E A ET 4E B';

  @override
  String get previewAnnouncementTitle => 'Sortie au jardin public';

  @override
  String get previewAnnouncementBody =>
      'Mardi matin : prévoir une casquette et une bouteille d’eau.';

  @override
  String get moderationTitle => 'Et si on le disait autrement ?';

  @override
  String get moderationSubtitle =>
      'Votre message n\'a pas été envoyé. Personne ne l\'a vu.';

  @override
  String get yourMessageUpper => 'VOTRE MESSAGE';

  @override
  String get moderationExplain =>
      'Les mots surlignés peuvent blesser. Votre inquiétude, elle, est légitime : gardons-la.';

  @override
  String get suggestionUpper => 'PROPOSITION';

  @override
  String get sendThisVersion => 'Envoyer cette version';

  @override
  String get rewriteMyself => 'Je reformule moi-même';

  @override
  String get rewriteThenSend => 'Reformulez, puis envoyez à nouveau.';

  @override
  String get moderationThanks => 'Merci, c\'est parfait !';

  @override
  String get settingsTitle => 'Profil et réglages';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get myChildren => 'MES ENFANTS';

  @override
  String get addChildWithCode => 'Ajouter un enfant avec un code';

  @override
  String get languageAndDisplay => 'LANGUE ET AFFICHAGE';

  @override
  String get textSize => 'Taille du texte';

  @override
  String get textSizeSmall => 'Petit';

  @override
  String get textSizeNormal => 'Normal';

  @override
  String get textSizeLarge => 'Grand';

  @override
  String get notificationsUpper => 'NOTIFICATIONS';

  @override
  String get notifAbsences => 'Absences et changements';

  @override
  String get notifAbsencesBody => 'Toujours activé : c’est l’essentiel';

  @override
  String get notifNewLessons => 'Nouvelles leçons';

  @override
  String get notifNewLessonsBody => 'Un résumé par jour';

  @override
  String get notifSchool => 'Annonces de l’école';

  @override
  String get notifSchoolBody => 'Réunions, sorties, fêtes';

  @override
  String get notifQuietHours => 'Heures calmes · 20h–7h';

  @override
  String get notifQuietHoursBody => 'Rien ne sonne la nuit, sauf urgence';

  @override
  String get alwaysOn => 'Toujours activé';

  @override
  String get kidModeAndSecurity => 'MODE ENFANT ET SÉCURITÉ';

  @override
  String get openKidMode => 'Ouvrir le mode enfant';

  @override
  String get parentCodeToExit => 'Code parent pour quitter';

  @override
  String get privacyAndData => 'Confidentialité et données';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get parentWithPhone => 'Parent · [numéro de téléphone]';

  @override
  String get mainNavigation => 'Navigation principale';

  @override
  String get navHome => 'Accueil';

  @override
  String get navWeek => 'Semaine';

  @override
  String get navMyWeek => 'Ma semaine';

  @override
  String get navLessons => 'Leçons';

  @override
  String get navMessages => 'Messages';

  @override
  String get navProfile => 'Profil';

  @override
  String get navAlerts => 'Alertes';

  @override
  String get navPublish => 'Publier';

  @override
  String get navChanges => 'Changements';

  @override
  String get errorInvalidCredentials => 'Numéro ou mot de passe incorrect.';

  @override
  String get demoAccountsTitle => 'Comptes de démonstration';

  @override
  String demoAccountLine(String role, String phone, String password) {
    return '$role · $phone · $password';
  }
}
