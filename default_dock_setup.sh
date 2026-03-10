#!/usr/bin/env bash

# Vider le Dock
defaults write com.apple.dock persistent-apps -array

# Fonction pour ajouter une app
add_app() {
    if [ -d "$1" ]; then
        defaults write com.apple.dock persistent-apps -array-add \
            "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$1</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
    else
        echo "Skipping $1: App not found."
    fi
}


# Fonction pour ajouter un séparateur
add_separator() {
    defaults write com.apple.dock persistent-apps -array-add \
        '<dict><key>tile-data</key><dict/><key>tile-type</key><string>spacer-tile</string></dict>'
}

# Fonction pour ajouter un dossier
add_folder() {
    local path="$1"
    local arrangement="$2"  # 1=Nom, 2=Date ajout, 3=Date modif, 4=Date création, 5=Type
    local displayas="$3"    # 1=Dossier, 2=Pile
    local showas="$4"       # 1=Automatique, 2=Grille, 3=Liste, 4=Aperçu

    defaults write com.apple.dock persistent-others -array-add \
        "<dict>
            <key>tile-data</key>
            <dict>
                <key>file-data</key>
                <dict>
                    <key>_CFURLString</key>
                    <string>${path}</string>
                    <key>_CFURLStringType</key>
                    <integer>0</integer>
                </dict>
                <key>arrangement</key>
                <integer>${arrangement}</integer>
                <key>displayas</key>
                <integer>${displayas}</integer>
                <key>showas</key>
                <integer>${showas}</integer>
            </dict>
            <key>tile-type</key>
            <string>directory-tile</string>
        </dict>"
}

# Apps
add_app "/System/Library/CoreServices/Finder.app"
add_app "/System/Applications/Mail.app"
add_app "/System/Applications/Calendar.app"
add_app "/Applications/Firefox.app"
add_app "/Applications/Google Chrome.app"
add_app "/Applications/Zen.app"
add_app "/Applications/Safari.app"
add_app "/Applications/Spotify.app"
add_app "/System/Applications/Notes.app"
add_app "/System/Applications/TextEdit.app"
add_app "/Applications/Ghostty.app"
add_app "/Applications/Visual Studio Code.app"
add_app "/Applications/Antigravity.app"
add_app "/Applications/DevDocs.app"
add_app "/System/Applications/Calculator.app"

# Séparateur
add_separator

# Dossiers (arrangement: 1=Nom, 2=Date ajout | displayas: 1=Dossier | showas: 3=Liste)
add_folder "$HOME/Desktop" 1 1 3
add_folder "$HOME/Downloads" 2 1 3

# Appliquer
killall Dock
