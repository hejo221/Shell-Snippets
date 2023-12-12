#!/bin/bash

# Gets data from Bash Command History
history_file="$HOME/.bash_history"

# Gets number of commands in Command History
num_commands=$(wc -l < "$history_file")

# Gets size of saved commands in Command History
history_size=$(set | grep HISTSIZE | cut -d '=' -f 2)

# Cuts parts of History in case number of saved commands is lesser than number of actual
# number of commands found in the History
if [ "$num_commands" -gt "$history_size" ]; then
    num_commands="$history_size"
fi

# Extracts commands from History and filters multiples
commands=$(tail -n "$num_commands" "$history_file" | cut -d ' ' -f 1 | sort | uniq -c)

# Displays the absolute probabilities
echo "Absolute Häufigkeiten der genutzten Kommandos:"
echo "$commands"

# Saves the data for gnuplot in an external file
echo "$commands" | awk '{print $2, $1}' > command_histogram.dat

# Runs gnuplot for vizualization of Command History
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
