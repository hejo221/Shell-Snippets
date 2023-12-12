#!/bin/bash

# Datei mit Bash-Befehlshistorie
history_file="$HOME/.bash_history"

# Anzahl der Befehle in der Historie
num_commands=$(wc -l < "$history_file")

# Anzahl der gespeicherten Befehle im Speicher
history_size=$(set | grep HISTSIZE | cut -d '=' -f 2)

# Falls die Anzahl der gespeicherten Befehle kleiner ist als die tatsächliche Anzahl,
# die in der Historie gefunden wurde, schneide die Historie entsprechend ab.
if [ "$num_commands" -gt "$history_size" ]; then
    num_commands="$history_size"
fi

# Extrahiere die Befehle aus der Historie und filtere Mehrfachnennungen heraus
commands=$(tail -n "$num_commands" "$history_file" | cut -d ' ' -f 1 | sort | uniq -c)

# Ausgabe der absoluten Häufigkeiten
echo "Absolute Häufigkeiten der genutzten Kommandos:"
echo "$commands"

# Speichere die Daten für gnuplot in einer Datei
echo "$commands" | awk '{print $2, $1}' > command_histogram.dat

gnuplot <<EOF
set term pngcairo enhanced font 'Verdana,10'
set output 'command_histogram.png'
set title 'Absolute Häufigkeiten der genutzten Kommandos'
set xlabel 'Kommando'
set ylabel 'Absolute Häufigkeit'
set style data histogram
set style fill solid
plot 'command_histogram.dat' using 2:xtic(1) title ''
EOF