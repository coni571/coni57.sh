#!/bin/bash
#######################################################################################
echo -e "\033[32m### Termux-Xtreammulti Install without menu\033[0m"
echo -e "\033[1;31m                ®coni 🤗\033[0m"
#######################################################################################
echo -e " "
### Install
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RESET="\033[0m"
echo -e "${GREEN}-> Install/Update Pakete pls wait"
pkg update >/dev/null 2>&1
pkg install -o Dpkg::Options::="--force-confnew" apache2 php php-apache wget curl jq openssl php-fpm fzf net-tools python3 openssh iproute2 cronie -y >/dev/null 2>&1

pip install aiohttp >/dev/null 2>&1
homefolder="/data/data/com.termux/files/home/xtreammulti/"
tmpfolder="/data/data/com.termux/files/usr/tmp/"
apachefolder="/data/data/com.termux/files/usr/share/apache2/default-site/htdocs/"
# Standardwert für die Konfigurationsdatei (falls keine Umgebungsvariable gesetzt)
config_file="${CONFIGHTV:-confightv}"
# Funktion zum Speichern der Konfiguration in die Datei
save_config() {
    echo "user=$user" > "$config_file"
    echo "pw=$pw" >> "$config_file"
    echo "port=$port" >> "$config_file"
}
# Wenn die Datei existiert, lese die Werte
if [ -f "$config_file" ]; then
    echo -e "\033[33mKonfigurationsdatei $config_file gefunden. Möchtest du die Werte ändern? (j/n)\033[0m"
    
    # Wartezeit für die Eingabe (in Sekunden), hier 10 Sekunden
    read -t 5 change
    if [[ "$change" =~ ^[Jj]$ ]]; then
        # Neue Werte eingeben, wenn der Benutzer zustimmt
        echo -e "${GREEN}Set User:${RESET}"
        read user
        echo -e "${GREEN}Set PW:${RESET}"
        read pw
        echo -e "${GREEN}Set Port (z.B. 8080):${RESET}"
        read port
        save_config
    elif [ -z "$change" ]; then
        # Wenn keine Eingabe erfolgt ist, keine Änderungen vornehmen
        echo -e "\033[33mKeine Änderungen vorgenommen. Verwende die gespeicherten Werte.\033[0m"
        echo -e "\033[1;31m           Bitte warten.....\033[0m⏰"
        # Werte aus der Konfigurationsdatei laden
        user=$(grep -oP '^user=\K.*' "$config_file")
        pw=$(grep -oP '^pw=\K.*' "$config_file")
        port=$(grep -oP '^port=\K.*' "$config_file")
    else
        # Wenn der Benutzer mit "n" antwortet
        echo -e "\033[33mKeine Änderungen vorgenommen. Verwende die gespeicherten Werte.\033[0m"
        # Werte aus der Konfigurationsdatei laden
        user=$(grep -oP '^user=\K.*' "$config_file")
        pw=$(grep -oP '^pw=\K.*' "$config_file")
        port=$(grep -oP '^port=\K.*' "$config_file")
    fi
else
    # Konfigurationsdatei existiert nicht, neue Werte setzen
    echo -e "${GREEN}Set User:${RESET}"
    read user
    echo -e "${GREEN}Set PW:${RESET}"
    read pw
    echo -e "${GREEN}Set Port (z.B. 8080):${RESET}"
    read port
    save_config
fi
    ipconfig=$(ifconfig 2>/dev/null | grep 'inet ' | awk '{ print $2 }' | grep 192.168)
    # Überprüfe, ob eine gültige IP-Adresse gefunden wurde
    if echo "$ipconfig" | grep -q 192.168; then
        echo "$ipconfig" > /dev/null 2>&1
        ip=$ipconfig
    else
        echo "127.0.0.1" > /dev/null 2>&1
        ip="127.0.0.1"
    fi
mkdir $homefolder > /dev/null 2>&1
wget http://robinhoodtv.mooo.com/htv/htvbest.zip > /dev/null 2>&1
DATEI="htvbest.zip"
if [ -e "$DATEI" ]; then
echo -e "${GREEN}-> Download erfolgreich, install best"
sleep 1
unzip -o htvbest.zip -d $homefolder > /dev/null 2>&1
rm htvbest.zip
for Portal in best; do
rm -r "$apachefolder""$Portal" > /dev/null 2>&1
mkdir "$apachefolder""$Portal" > /dev/null 2>&1
mkdir -p "$apachefolder""$Portal"/live/$user/$pw > /dev/null 2>&1
mkdir -p "$apachefolder""$Portal"/series/$user/$pw > /dev/null 2>&1
mkdir -p "$apachefolder""$Portal"/vod/$user/$pw > /dev/null 2>&1
mkdir -p "$apachefolder""$Portal"/movie/$user/$pw > /dev/null 2>&1
cp -r "$homefolder""$Portal"/apache/api "$apachefolder""$Portal"
cp "$homefolder""$Portal"/apache/*.php "$apachefolder""$Portal"
cat "$homefolder""$Portal"/apache/.htaccess | sed 's#htvuser#'$user'#g' | sed 's#htvpw#'$pw'#g' | sed 's#127.0.0.1#'$ip'#g' | sed 's#8080#'$port'#g' > "$apachefolder""$Portal"/.htaccess
cat "$homefolder""$Portal"/apache/live/htvuser/htvpw/.htaccess | sed 's#htvuser#'$user'#g' | sed 's#htvpw#'$pw'#g' | sed 's#127.0.0.1#'$ip'#g' | sed 's#8080#'$port'#g' > "$apachefolder""$Portal"/live/$user/$pw/.htaccess
cat "$homefolder""$Portal"/apache/series/htvuser/htvpw/.htaccess | sed 's#htvuser#'$user'#g' | sed 's#htvpw#'$pw'#g' | sed 's#127.0.0.1#'$ip'#g' | sed 's#8080#'$port'#g' > "$apachefolder""$Portal"/series/$user/$pw/.htaccess
cat "$homefolder""$Portal"/apache/vod/htvuser/htvpw/.htaccess | sed 's#htvuser#'$user'#g' | sed 's#htvpw#'$pw'#g' | sed 's#127.0.0.1#'$ip'#g' | sed 's#8080#'$port'#g' > "$apachefolder""$Portal"/vod/$user/$pw/.htaccess
cat "$homefolder""$Portal"/apache/movie/htvuser/htvpw/.htaccess | sed 's#htvuser#'$user'#g' | sed 's#htvpw#'$pw'#g' | sed 's#127.0.0.1#'$ip'#g' | sed 's#8080#'$port'#g' > "$apachefolder""$Portal"/movie/$user/$pw/.htaccess
cat "$homefolder""$Portal"/apache/api/player_api | sed 's#htvuser#'$user'#g' | sed 's#htvpw#'$pw'#g' | sed 's#127.0.0.1#'$ip'#g' | sed 's#8080#'$port'#g' > "$apachefolder""$Portal"/api/player_api
done
cat "$homefolder"best/httpd.conf | sed 's#Listen 8080#Listen '$port'#g' > /data/data/com.termux/files/usr/etc/apache2/httpd.conf && apachectl restart > /dev/null 2>&1
mkdir "$apachefolder"live > /dev/null 2>&1
echo -e "${GREEN}-> Download best EPG"
"$homefolder"best/epg.sh > /dev/null 2>&1
cp "$homefolder"best/.bashrc /data/data/com.termux/files/home
####vavoo
echo -e "${GREEN}-> Install vavoo"
rm -r "$apachefolder"vavoo > /dev/null 2>&1
mkdir "$apachefolder"vavoo > /dev/null 2>&1
"$homefolder"vavoo/vavoo.sh > /dev/null 2>&1
mv vavoo-* "$homefolder"vavoo/
echo -e "${GREEN}-> vavoo sort"
"$homefolder"vavoo/m3usort.sh "$homefolder"vavoo/vavoo-Germany.m3u "$homefolder"vavoo/bla.m3u
"$homefolder"vavoo/tvhrytecid.sh "$homefolder"vavoo/bla.m3u "$homefolder"vavoo/vavoosort
cat "$homefolder"vavoo/vavoosort.m3u | sed 's#.ts.*#.ts#g' | sed 's#https://vavoo.to/live2/play/#http://'$ip':'$port'/vavoo/play.php?cmd=#g' | sed 's#(1)#HD (1)#g' | sed 's#(6)#HD (6)#g' | sed 's#(7)#HD (7)#g' | sed 's#FreeTV#FreeTV Vavoo#g' | sed 's#FreeTV Sport#FreeTV Sport Vavoo#g' > "$apachefolder"vavoo/vavoo.m3u

for Portal in best ; do
echo -e "${GREEN}-> $Portal sort"
cat "$homefolder""$Portal"/live.m3u | sed '/discovery+/d' | sed 's#SKY CINEMA PREMIERE#SKY CINEMA PREMIEREN#g' | grep -A1 "DE_" | sed 's#DE: VIP ##g' | sed 's#DE: ##g'  | sed 's#FHD#HD#g' | sed 's#QHD#HD#g' | sed 's#RAW#HD#g' | sed 's#HEVC#HD#g' | sed 's#DE ##g' > "$Portal".m3u
cat "$homefolder""$Portal"/live.m3u | sed '/discovery+/d' | sed 's#SKY CINEMA PREMIERE#SKY CINEMA PREMIEREN#g' | grep -A1 ",DE " | sed 's#DE: VIP ##g' | sed 's#DE: ##g'  | sed 's#FHD#HD#g' | sed 's#QHD#HD#g' | sed 's#RAW#HD#g' | sed 's#HEVC#HD#g' | sed 's#DE ##g' >> "$Portal".m3u
cat "$homefolder""$Portal"/live.m3u | sed '/discovery+/d' | sed 's#SKY CINEMA PREMIERE#SKY CINEMA PREMIEREN#g' | grep -A1 "AT_AUSTRIA" | sed 's#AT: VIP ##g' | sed 's#AT: ##g' | sed 's#FHD#HD#g' | sed 's#RAW#HD#g' | sed 's#HEVC#HD#g' | sed 's#AT ##g' >> "$Portal".m3u
cat "$homefolder""$Portal"/live.m3u | sed '/discovery+/d' | sed 's#SKY CINEMA PREMIERE#SKY CINEMA PREMIEREN#g' | grep -A1 "AU_" | sed 's#AT: VIP ##g' | sed 's#AT: ##g' | sed 's#FHD#HD#g' | sed 's#RAW#HD#g' | sed 's#HEVC#HD#g' | sed 's#AT ##g' >> "$Portal".m3u
cat "$homefolder""$Portal"/live.m3u | sed '/discovery+/d' | sed 's#SKY CINEMA PREMIERE#SKY CINEMA PREMIEREN#g' | grep -A1 "_ÖSTERREICH_" | sed 's#AT: VIP ##g' | sed 's#AT: ##g' | sed 's#FHD#HD#g' | sed 's#RAW#HD#g' | sed 's#HEVC#HD#g' | sed 's#AT ##g' >> "$Portal".m3u
cat "$homefolder""$Portal"/live.m3u | sed '/discovery+/d' | sed 's#SKY CINEMA PREMIERE#SKY CINEMA PREMIEREN#g' | grep -A1 "CH_" | sed 's#CH: VIP ##g' | sed 's#CH: ##g' | sed 's#FHD#HD#g' | sed 's#RAW#HD#g' | sed 's#HEVC#HD#g' | sed 's#CH ##g'>> "$Portal".m3u
cat "$homefolder""$Portal"/live.m3u | sed '/discovery+/d' | sed 's#SKY CINEMA PREMIERE#SKY CINEMA PREMIEREN#g' | grep -A1 "_SWISS_" | sed 's#CH: VIP ##g' | sed 's#CH: ##g' | sed 's#FHD#HD#g' | sed 's#RAW#HD#g' | sed 's#HEVC#HD#g' | sed 's#CH ##g' >> "$Portal".m3u
"$homefolder"vavoo/m3usort.sh "$Portal".m3u "$homefolder"vavoo/"$Portal".m3u
"$homefolder"vavoo/tvhrytecid.sh "$homefolder"vavoo/"$Portal".m3u "$homefolder"vavoo/"$Portal"
cat "$homefolder"vavoo/"$Portal".m3u | sed 's#FreeTV#FreeTV '$Portal'#g' | sed 's#FreeTV Sport#FreeTV Sport '$Portal'#g' | sed '/EXTM3U/d' | sed 's#127.0.0.1:8080#'$ip':'$port'#g' >> "$apachefolder"vavoo/vavoo.m3u
rm "$Portal".m3u*
done

cat "$homefolder"vavoo/vavoo-*.m3u | sed '/#EXTM3U/d' | sed 's#.ts.*#.ts#g' | sed 's#https://vavoo.to/live2/play/#http://'$ip':'$port'/vavoo/play.php?cmd=#g' | sed 's#(1)#HD (1)#g' | sed 's#(6)#HD (6)#g' | sed 's#(7)#HD (7)#g' >> "$apachefolder"vavoo/vavoo.m3u
rm "$homefolder"vavoo/*.m3u > /dev/null 2>&1
rm "$homefolder"vavoo/vavoo > /dev/null 2>&1
echo "<?php
// Den Query-String analysieren
\$cmd = \$_GET['cmd'] ?? ''; // Den Wert des cmd-Parameters erhalten (falls vorhanden)
\$series = \$_GET['series'] ?? ''; // Den Wert des series-Parameters erhalten (falls vorhanden)

// Pfad zum Skript
\$scriptPath = '"$homefolder"vavoo/play.sh';

// Befehl zusammenstellen (falls erforderlich)
\$command = \$scriptPath . \" \\\"\$cmd\\\" \\\"\$series\\\"\"; // Leerzeichen und Punkt hinzufügen

// Den Befehl ausführen und Ergebnis speichern
\$output = exec(\$command);

// Ergebnis als Location-Header zurückgeben
header('Location: ' . \$output);
exit(); // Exit, um sicherzustellen, dass keine weitere Ausgabe erfolgt
?>" > "$apachefolder"vavoo/play.php





URL="http://robinhoodtv.mooo.com/htv/install.sh"
FILE="install.sh"
TMPFILE="${FILE}.tmp"

# erst in eine temp-Datei laden
wget -q -O "$TMPFILE" "$URL"

# prüfen ob Download erfolgreich und Datei > 0 Byte
if [ -s "$TMPFILE" ]; then
    mv "$TMPFILE" "$FILE"
    chmod +x "$FILE"
    echo -e "${GREEN}-> Update install.sh erfolgreich${RESET}"
else
    echo -e "${YELLOW}-> Update install.sh fehlgeschlagen${RESET}"
    rm -f "$TMPFILE"
fi

# Ausgabe der Daten in den gewÃ¼nschten Farben
echo -e "\n${GREEN}Xtream login:${RESET}"
echo -e "${GREEN}User:${RESET} ${YELLOW}$user${RESET}"
echo -e "${GREEN}PW:${RESET} ${YELLOW}$pw${RESET}"
echo -e "${GREEN}xtream link:${RESET} ${YELLOW}http://$ip:"$port"/best${RESET}"

echo -e "${GREEN}vavoo link:${RESET} ${YELLOW}http://$ip:"$port"/vavoo/vavoo.m3u${RESET}"

echo -e " "
echo -e "\033[0;32m            ***FERTIG ***\033[0m"
echo -e " "
echo -e "\033[0;33mBitte \033[1;34mTelevizo-Player\033[0;33m starten... 🤗 \033[0m"
########
if [ -f $HOME/install.sh ]; then
 rm $HOME/install.sh
fi
#######
apachectl restart > /dev/null 2>&1
else
    echo "Die Datei $DATEI ist nicht vorhanden. install abbruch"
fi
exit 0
