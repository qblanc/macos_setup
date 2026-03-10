#!/usr/bin/env bash

# english commented commands inspired by https://github.com/mathiasbynens/dotfiles/blob/master/.macos

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Always show scrollbars
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
# Possible values: `WhenScrolling`, `Automatic` and `Always`

# Disable the over-the-top focus ring animation
defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false

# Adjust toolbar title rollover delay
defaults write NSGlobalDomain NSToolbarTitleViewRolloverDelay -float 0

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Remove duplicates in the “Open With” menu (also see `lscleanup` alias)
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

# Display ASCII control characters using caret notation in standard text views (display hidden characters in documents)
# Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
# defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true

# Disable automatic termination of inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Disable the crash reporter
defaults write com.apple.CrashReporter DialogType -string "none"

# Disable Notification Center and remove the menu bar icon
# launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

# Disable automatic capitalization as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

###############################################################################
# Gestion de l'énergie & Verrouillage                                         #
###############################################################################

# Réveil par le bouton d'alimentation
sudo pmset -a powerbutton 1

# Désactiver le mode économie d'énergie (Low Power Mode)
sudo pmset -a lowpowermode 0

# Hibernation mode 3 (Standard : RAM sauvegardée sur disque + alimentée)
sudo pmset -a hibernatemode 3

# Ne amais lancer l'économiseur d'écran
defaults write com.apple.screensaver idleTime -int 0

# Éteindre écran sur batterie après 3 minutes
sudo pmset -a displaysleep 3

# Mot de passe immédiatement après verrouillage
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Afficher l'horloge en grand sur l'écran verrouillé
defaults write com.apple.screensaver showClock -bool true

# Affichage 24h
defaults write NSGlobalDomain AppleICUForce24HourTime -bool true

# Définit le premier jour de la semaine sur Lundi (Code "2")
# (1 = Dimanche, 2 = Lundi, 3 = Mardi, etc.)
defaults write NSGlobalDomain AppleFirstWeekday -dict 'gregorian' 2

# Afficher nom d'utilisateur et photo
defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -bool false

# Afficher boutons Suspendre, Redémarrer, Éteindre
sudo defaults write /Library/Preferences/com.apple.loginwindow PowerOffDisabled -bool false

###############################################################################
# Dock                                                                        #
###############################################################################

# Position en bas
defaults write com.apple.dock orientation -string "bottom"

# Effet génie
defaults write com.apple.dock mineffect -string "genie"

# Masquer/afficher automatiquement
defaults write com.apple.dock autohide -bool true

# Animer les applications à l'ouverture
defaults write com.apple.dock launchanim -bool true

# Afficher les indicateurs des apps ouvertes
defaults write com.apple.dock show-process-indicators -bool true

# Ne pas afficher les apps suggérées/récentes
defaults write com.apple.dock show-recents -bool false

# Double-clic sur barre de titre = réduire/agrandir
defaults write NSGlobalDomain AppleActionOnDoubleClick -string "Maximize"

# Stage Manager activé
defaults write com.apple.windowmanager GloballyEnabled -bool true

# Set the icon size of Dock items to 36 pixels
defaults write com.apple.dock "tilesize" -int 43

# Show only open applications in the Dock
 defaults write com.apple.dock static-only -bool false

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0

# Remove the animation when hiding/showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0.15

###############################################################################
# Bureau & Fenêtres                                                           #
###############################################################################

# Sauvegarde les captures d'écran sur le bureau
defaults write com.apple.screencapture location -string "${HOME}/Desktop/Screenshots"

# Cliquer fond d'écran affiche le bureau : Toujours
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool true

# Widgets sur le bureau activés
defaults write com.apple.WindowManager StandardHideWidgets -bool false

# Style des widgets : automatique
defaults write com.apple.widgets widgetAppearance -int 0

# Utiliser widgets iPhone
defaults write com.apple.widgetkit allowWidgetsFromiPhone -bool true

# Préférer onglets en plein écran
defaults write NSGlobalDomain AppleWindowTabbingMode -string "fullscreen"

# Fermer fenêtres à la fermeture d'une app
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false

# Disposition en mosaïque sur les bords
defaults write com.apple.WindowManager EnableTilingByEdgeDrag -bool false

# Mosaïque avec touche Option
defaults write com.apple.WindowManager EnableTilingOptionAccelerator -bool true

# Marge autour des fenêtres en mosaïque
defaults write com.apple.WindowManager EnableTilingByEdgeDragMargin -bool false

# Activer les piles sur le bureau
defaults write com.apple.finder ShowDesktopIcons -bool true
defaults write com.apple.finder FXEnableDesktopGroups -bool true

# Organiser les piles par type
defaults write com.apple.finder FXDesktopGroupBy -string "Kind"

###############################################################################
# Mission Control                                                             #
###############################################################################

# Ne pas réarranger les Spaces automatiquement
defaults write com.apple.dock mru-spaces -bool false

# Activer Space de l'app lors du changement
defaults write NSGlobalDomain AppleSpacesSwitchOnActivate -bool true

# Ne pas grouper les fenêtres par application
defaults write com.apple.dock expose-group-apps -bool false

# Écrans avec Spaces distincts
defaults write com.apple.spaces spans-displays -bool false

###############################################################################
# Barre des menus & Centre de contrôle                                        #
###############################################################################

# Wi-Fi dans la barre des menus
defaults write com.apple.controlcenter "NSStatusItem Visible WiFi" -bool true

# Bluetooth dans la barre des menus
defaults write com.apple.controlcenter "NSStatusItem Visible Bluetooth" -bool true

# AirDrop : ne pas afficher dans la barre des menus
defaults write com.apple.controlcenter "NSStatusItem Visible AirDrop" -bool false

# Batterie : afficher dans la barre des menus + pourcentage
defaults write com.apple.controlcenter "NSStatusItem Visible Battery" -bool true
defaults write com.apple.controlcenter ShowBatteryPercentage -bool true

# Son : toujours dans la barre des menus
defaults write com.apple.controlcenter "NSStatusItem Visible Sound" -bool true

# Spotlight dans la barre des menus
defaults write com.apple.Spotlight "NSStatusItem Visible Item-0" -bool true

# Siri : ne pas afficher dans la barre des menus
defaults write com.apple.Siri StatusMenuVisible -bool false

# Masquer barre des menus en plein écran seulement
defaults write NSGlobalDomain AppleMenuBarVisibleInFullscreen -bool false

# Documents/apps récents : 10
defaults write NSGlobalDomain NSRecentDocumentsLimit -int 10

###############################################################################
# Notifications                                                               #
###############################################################################

# Afficher aperçus si déverrouillé
defaults write com.apple.ncprefs content_visibility -int 2

# Autoriser notifications écran verrouillé
defaults write com.apple.ncprefs allow_in_lock_screen -bool true

# Refuser notifications moniteur en veille
defaults write com.apple.ncprefs allow_in_sleep -bool false

# Refuser notifications pendant partage d'écran
defaults write com.apple.ncprefs allow_in_car_play -bool false

###############################################################################
# Son                                                                         #
###############################################################################

# Son d'alerte : Boop
defaults write NSGlobalDomain com.apple.sound.beep.sound -string "/System/Library/Sounds/Boop.aiff"

# Pas de son au démarrage
sudo nvram StartupMute=%01

# Désactiver effets sonores UI
defaults write NSGlobalDomain com.apple.sound.uiaudio.enabled -int 0

# Pas de son lors du changement de volume
defaults write NSGlobalDomain com.apple.sound.beep.feedback -int 0

############################################################################
# Écran                                                                    #
############################################################################

# Luminosité automatique
defaults write /Library/Preferences/com.apple.iokit.AmbientLightSensor "Automatic Display Enabled" -bool true

# True Tone
defaults write /Library/Preferences/com.apple.CoreBrightness "NightShiftUI.TrueToneEnabled" -bool true

# Résolution 1440x900 (par défaut)
# Cela correspond à la résolution native — aucun changement nécessaire

# Enable subpixel font rendering on non-Apple LCDs
# Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
defaults write NSGlobalDomain AppleFontSmoothing -int 1

############################################################################
# Mode économie d'énergie                                                  #
############################################################################

# Économie d'énergie sur batterie seulement
sudo pmset -b lowpowermode 1
sudo pmset -c lowpowermode 0

############################################################################
# Siri                                                                     #
############################################################################

# Désactiver Siri
defaults write com.apple.assistant.support "Assistant Enabled" -bool false
defaults write com.apple.Siri SiriPrefStashedStatusMenuVisible -bool false

############################################################################
# Trackpad                                                                 #
############################################################################

# Toucher pour cliquer
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Clic discret (retour haptique silencieux)
defaults write com.apple.AppleMultitouchTrackpad ActuationStrength -int 0

# Désactiver clic forcé / retour tactile
defaults write com.apple.AppleMultitouchTrackpad ForceSuppressed -bool true

# Clic secondaire : 2 doigts
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true

# Désactiver recherche et détection de données (3 doigts)
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -int 0

# Vitesse du curseur (0.0 à 3.0 — environ milieu = 0.6875)
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 0.6875

# Désactiver défilement naturel
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Zoom avant/arrière (pincer 2 doigts)
defaults write com.apple.AppleMultitouchTrackpad TrackpadPinch -bool true

# Désactiver zoom intelligent
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -int 0

# Pivoter avec 2 doigts
defaults write com.apple.AppleMultitouchTrackpad TrackpadRotate -bool true

# Balayer entre les pages : défiler latéralement avec 2 doigts
defaults write NSGlobalDomain AppleEnableSwipeNavigateWithScrolls -bool true

# Balayer entre apps plein écran : 3 doigts
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 2

# Centre de notifications : balayer de droite à gauche avec 2 doigts
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 3

# Mission Control : balayer vers le haut avec 3 doigts
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 2

# App Exposé : balayer vers le bas avec 3 doigts
defaults write com.apple.dock showAppExposeGestureEnabled -bool true

# Désactiver Launchpad (pincer pouce + 3 doigts)
defaults write com.apple.dock showLaunchpadGestureEnabled -bool false

# Afficher le bureau : écarter pouce + 3 doigts
defaults write com.apple.dock showDesktopGestureEnabled -bool true

############################################################################
# Souris                                                                   #
############################################################################

# Clic secondaire : côté droit
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode -string "TwoButton"

# Vitesse curseur souris (milieu ≈ 0.6875)
defaults write NSGlobalDomain com.apple.mouse.scaling -float 0.6875

# Vitesse double-clic (milieu ≈ 0.5)
defaults write NSGlobalDomain com.apple.mouse.doubleClickThreshold -float 0.5

# Vitesse de défilement
defaults write NSGlobalDomain com.apple.scrollwheel.scaling -float 0.6875

############################################################################
# Clavier                                                                  #
############################################################################

# Vitesse de répétition des touches (2 = rapide, 6 = lente)
defaults write NSGlobalDomain KeyRepeat -int 2

# Pause avant répétition (15 = courte, 68 = longue)
defaults write NSGlobalDomain InitialKeyRepeat -int 25

# Régler luminosité clavier en faible éclairage
defaults write com.apple.BezelServices kDim -bool true

# Ne jamais désactiver le rétroéclairage en cas d'inactivité
defaults write com.apple.BezelServices kDimTime -int 0

# Touche Globe : afficher Emoji et symboles
defaults write com.apple.HIToolbox AppleFnUsageType -int 2

# Navigation au clavier (Tab entre tous les contrôles)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Dictée : ponctuation auto activée
defaults write com.apple.SpeechRecognitionCore AutoPunctuation -bool true

# Set language and text formats
defaults write NSGlobalDomain AppleLanguages -array "fr-FR" "en-FR"
defaults write NSGlobalDomain AppleLocale -string "fr_FR@currency=EUR"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

# Show language menu in the top right corner of the boot screen
sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool true

# Set the timezone; see `sudo systemsetup -listtimezones` for other values
sudo systemsetup -settimezone "Europe/Paris" > /dev/null

# Définit le Français Numérique comme source sélectionnée par défaut
defaults write com.apple.HIToolbox AppleEnabledInputSources -array-add '<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>1</integer><key>KeyboardLayout Name</key><string>French - Numerical</string></dict>'
defaults write com.apple.HIToolbox AppleSelectedInputSources -array '<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>1</integer><key>KeyboardLayout Name</key><string>French - Numerical</string></dict>'

############################################################################
# Hot Corners (Mission Control / Bureau / Launchpad)                     #
############################################################################

# Coin supérieur gauche : Mission Control
defaults write com.apple.dock wvous-tl-corner -int 2
defaults write com.apple.dock wvous-tl-modifier -int 0

# Coin supérieur droit : Launchpad
defaults write com.apple.dock wvous-tr-corner -int 11
defaults write com.apple.dock wvous-tr-modifier -int 0

# Coin inférieur gauche : Bureau
defaults write com.apple.dock wvous-bl-corner -int 4
defaults write com.apple.dock wvous-bl-modifier -int 0

# Coin inférieur droit : Mission Control
defaults write com.apple.dock wvous-br-corner -int 2
defaults write com.apple.dock wvous-br-modifier -int 0

############################################################################
# Touch ID                                                                 #
############################################################################

# Touch ID : toutes les options sont activées par défaut à la configuration
# Elles ne sont pas modifiables via Terminal — à configurer manuellement
# dans Préférences Système > Touch ID & code

############################################################################
# Sécurité & Confidentialité                                               #
############################################################################

# Autoriser apps depuis App Store et développeurs connus
sudo spctl --master-enable
sudo defaults write /Library/Preferences/com.apple.security GKAutoRearm -bool false

# FileVault : activer le chiffrement
sudo fdesetup enable
# (vous serez invité à entrer vos identifiants)

# Service de localisation : désactivé
sudo defaults write /var/db/locationd/Library/Preferences/ByHost/com.apple.locationd LocationServicesEnabled -bool false

############################################################################
# Analyse & Améliorations (tout désactivé)                                #
############################################################################

defaults write com.apple.assistant.support "Siri Data Sharing Opt-In Status" -int 2
defaults write com.apple.DiagnosticReportingPrefs AutoSubmit -bool false
defaults write com.apple.DiagnosticReportingPrefs ThirdPartyDataSubmit -bool false
sudo defaults write /Library/Application\ Support/CrashReporter/DiagnosticMessagesHistory.plist AutoSubmit -bool false
defaults write com.apple.Siri DisableSiriVoiceAnalysis -bool true
defaults write com.apple.iCloud analyticsOptIn -bool false

############################################################################
# Publicité Apple (annonces personnalisées désactivées)                    #
############################################################################

defaults write com.apple.AdLib allowApplePersonalizedAdvertising -bool false

###############################################################################
# Finder                                                                      #
###############################################################################

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
# defaults write com.apple.finder QuitMenuItem -bool true

# Finder: disable window animations and Get Info animations
# defaults write com.apple.finder DisableAllAnimations -bool true

# Set Desktop as the default location for new Finder windows
# For other paths, use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"

# Toujours présenter par liste
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Naviguer en présentation par liste
defaults write com.apple.finder FXPreferredSearchViewStyle -string "Nlsv"

# Grouper par : Type
defaults write com.apple.finder FXPreferredGroupBy -string "Kind"

# Trier par : Nom
defaults write com.apple.finder FXArrangeGroupViewBy -string "Name"

# Taille des icônes : petite (première option sélectionnée)
defaults write com.apple.finder FXListViewIconSize -int 16

# Taille du texte : 13
defaults write com.apple.finder FXFontSizeListView -int 13

# Colonnes affichées
defaults write com.apple.finder FXListViewShowDateModified -bool true
defaults write com.apple.finder FXListViewShowDateCreated -bool false
defaults write com.apple.finder FXListViewShowDateLastOpened -bool false
defaults write com.apple.finder FXListViewShowDateAdded -bool false
defaults write com.apple.finder FXListViewShowSize -bool true
defaults write com.apple.finder FXListViewShowKind -bool true
defaults write com.apple.finder FXListViewShowVersion -bool false
defaults write com.apple.finder FXListViewShowComments -bool false
defaults write com.apple.finder FXListViewShowTags -bool false

# Utiliser les dates relatives
defaults write com.apple.finder FXListViewRelativeDates -bool true

# Calculer toutes les tailles
defaults write com.apple.finder FXListViewCalculateAllSizes -bool true

# Utiliser un aperçu comme icône
defaults write com.apple.finder FXListViewShowIconPreview -bool true

# Choisir les panneaux dépliés par défaut dans les fenêtres "Lire les informations"
defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \        # Général (nom, taille, dates...)
    MetaData -bool true \       # Informations supplémentaires (balises EXIF, etc.)
    OpenWith -bool true \       # Ouvrir avec
    MoreInfo -bool true \       # Plus d'infos
    Name -bool false \           # Nom & extension
    Comments -bool false \       # Commentaires Spotlight
    Preview -bool false \        # Aperçu
    Privileges -bool false       # Partage & permissions

# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Finder: show hidden files by default
 defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Display full POSIX path as Finder window title
# defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Enable spring loading for directories
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# Remove the spring loading delay for directories
defaults write NSGlobalDomain com.apple.springing.delay -float 0

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Show the ~/Library folder
chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library

# Show the /Volumes folder
sudo chflags nohidden /Volumes

###############################################################################
# Safari & WebKit                                                             #
###############################################################################

# Privacy: don’t send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Press Tab to highlight each item on a web page
defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true

# Show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Set Safari’s home page to `about:blank` for faster loading
defaults write com.apple.Safari HomePage -string "about:blank"

# Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Disable auto-correct
defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false

# Disable AutoFill
defaults write com.apple.Safari AutoFillFromAddressBook -bool false
defaults write com.apple.Safari AutoFillPasswords -bool false
defaults write com.apple.Safari AutoFillCreditCardData -bool false
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

# Warn about fraudulent websites
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

# Block pop-up windows
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false

# Disable auto-playing video
defaults write com.apple.Safari WebKitMediaPlaybackAllowsInline -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false

# Update extensions automatically
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

###############################################################################
# Mail                                                                        #
###############################################################################

# Relever le courrier automatiquement
defaults write com.apple.mail AutoFetch -bool true
defaults write com.apple.mail PollTime -string "-1"

# Pas de son à la réception
defaults write com.apple.mail PlayMailSounds -bool false
defaults write com.apple.mail NewMailSoundName -string ""

# Ne pas émettre de son pour les autres actions
defaults write com.apple.mail PlayMailSounds -bool false

# Badge Dock : boîte de réception uniquement
defaults write com.apple.mail BadgeType -int 1

# Dossier de téléchargement : Téléchargements
defaults write com.apple.mail DownloadsDirectory -string "~/Downloads"

# Effacer téléchargements non modifiés : après suppression du message
defaults write com.apple.mail ExpungeAttachmentsAfterMessageDeletion -bool true

# Suggestions de suivi
defaults write com.apple.mail FollowUpSuggestionsEnabled -bool true

# Ne pas archiver/supprimer les messages masqués
defaults write com.apple.mail ArchiveOrDeleteMaskedMessages -bool false

# Réessayer si serveur indisponible
defaults write com.apple.mail RetryOnTransportFailure -bool true

# Split View en plein écran
defaults write com.apple.mail PreferMessageViewInSplitView -bool true

# Recherche : inclure Corbeille et Indésirables
defaults write com.apple.mail IndexTrash -bool true
defaults write com.apple.mail IndexJunk -bool true
defaults write com.apple.mail IndexEncryptedMessages -bool false

# Police liste des messages : Système 11
defaults write com.apple.mail MessageListFont -string "System 11"

# Police espacement fixe : Menlo 11
defaults write com.apple.mail FixedWidthFont -string "Menlo-Regular"
defaults write com.apple.mail FixedWidthFontSize -int 11

# Ne pas utiliser police fixe pour messages texte brut
defaults write com.apple.mail UseFixedWidthFontForPlainTextMessages -bool false

# Couleur du texte cité activée
defaults write com.apple.mail ColorQuotedText -bool true

# Aperçu en mode liste : 2 lignes
defaults write com.apple.mail NumberOfSnippetLines -int 2

# Messages supprimés dans la Corbeille
defaults write com.apple.mail MoveDeletedMessagesToTrash -bool true

# Ne pas afficher messages non lus en gras
defaults write com.apple.mail ShouldShowUnreadMessagesInBold -bool false

# Résumer les aperçus
defaults write com.apple.mail SummarizeInThreadList -bool true

# Ne pas utiliser adresses intelligentes
defaults write com.apple.mail ShowContactNameInThreadList -bool false

# Arrière-plans sombres pour les messages
defaults write com.apple.mail UseDarkBackgroundForMessages -bool true

# Inclure messages associés
defaults write com.apple.mail ThreadingDefault -bool true

# Marquer tous les messages comme lus à l'ouverture
defaults write com.apple.mail ConversationViewMarkAllAsRead -bool true

# Messages les plus récents en haut
defaults write com.apple.mail ConversationViewSortDescending -bool true

# Format texte enrichi
defaults write com.apple.mail SendFormat -string "Rich Text"

# Vérifier orthographe lors de la saisie
defaults write com.apple.mail SpellCheckingBehavior -string "InlineSpellCheckingEnabled"

# Ne pas m'ajouter en Cc
defaults write com.apple.mail AutocopyCC -bool false

# Ajouter aperçu des liens
defaults write com.apple.mail AddLinkPreviews -bool true

# Lors d'envoi groupé : afficher toutes les adresses
defaults write com.apple.mail ExpandPrivateAliases -bool true

# Délai d'annulation d'envoi : 10 secondes
defaults write com.apple.mail UndoSendDelay -int 10

# Citer le texte original en réponse
defaults write com.apple.mail QuoteOriginalMessage -bool true

# Augmenter le niveau de citation
defaults write com.apple.mail AttachAtEnd -bool false
defaults write com.apple.mail IndentRepliedText -bool true

# Inclure texte sélectionné ou tout le texte
defaults write com.apple.mail ReplyIncludesSelectedText -bool true

# Protéger l'activité dans Mail
defaults write com.apple.mail MailPrivacyProtection_ProtectionLevel -int 1

# Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

# Disable inline attachments (just show the icons)
defaults write com.apple.mail DisableInlineAttachmentViewing -bool true


###############################################################################
# Time Machine                                                                #
###############################################################################

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

###############################################################################
# Activity Monitor                                                            #
###############################################################################

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# Text Edit                                                                   #
###############################################################################

# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0

# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

###############################################################################
# Photos                                                                      #
###############################################################################

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

###############################################################################
# Messages                                                                    #
###############################################################################

# Disable automatic emoji substitution (i.e. use plain text smileys)
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false

# Disable smart quotes as it’s annoying for messages that contain code
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

# Disable continuous spell checking
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false

###############################################################################
# Google Chrome                                                               #
###############################################################################

# Expand the print dialog by default
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Activity Monitor" \
	"Calendar" \
	"Dock" \
	"Finder" \
	"Google Chrome" \
	"Mail" \
	"Messages" \
	"Photos" \
	"Safari" \
	"SystemUIServer"; do
	killall "${app}" &> /dev/null
done
echo "Done. Note that some of these changes require a logout/restart to take effect."
