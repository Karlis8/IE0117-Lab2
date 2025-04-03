#!/bin/bash


if [ $# -eq 0 ]; then
    echo "Uso: $0 <comando>" >&2
    exit 1
fi


LOG_FILE="monitor.log"


"$@" &
PID=$!
echo "Proceso iniciado con PID: $PID"


echo "Timestamp,CPU(%),Mem(%)" > "$LOG_FILE"


while ps -p "$PID" > /dev/null; do
    
    METRICS=$(ps -o %cpu,%mem -p "$PID" --no-headers)
    CPU=$(echo "$METRICS" | awk '{print $1}')
    MEM=$(echo "$METRICS" | awk '{print $2}')
    
   
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
    
   
    echo "$TIMESTAMP,$CPU,$MEM" >> "$LOG_FILE"
    
   
    sleep 0.5
done

echo "Proceso terminado. Datos guardados en $LOG_FILE"


if command -v gnuplot &> /dev/null; then
    echo "Generando grafico..."
    gnuplot <<- EOF
        set terminal png
        set output 'uso_recursos.png'
        set title 'Uso de Recursos del Proceso'
        set xlabel 'Tiempo'
        set ylabel 'Uso (%)'
        set xdata time
        set timefmt "%Y-%m-%d %H:%M:%S"
        set format x "%H:%M:%S"
        plot "$LOG_FILE" using 1:2 with lines title 'CPU', \
             "$LOG_FILE" using 1:3 with lines title 'Memoria'
EOF
    echo "Grafico generado: uso_recursos.png"
else
    echo "Gnuplot no esta instalado. No se generara el grafico."
fi