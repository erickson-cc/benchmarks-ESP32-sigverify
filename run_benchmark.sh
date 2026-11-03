#!/bin/bash

# Verifica se o usuário passou o nome do algoritmo
if [ -z "$1" ]; then
    echo "Uso: ./run_benchmark.sh <NOME_DO_ALGORITMO>"
    echo "Exemplo: ./run_benchmark.sh SPHINCSSHA2256SSIMPLE_CLEAN"
    exit 1
fi

ALGO=$1
SKETCH_DIR="esp32_verifier/PQClean/${ALGO}"
VECTOR_FILE="test_vectors/${ALGO}_vectors.h"
LOG_FILE="monitor/${ALGO}_benchmark.log"
PORT="/dev/ttyUSB0"
FQBN="esp32:esp32:esp32"

# Cria a pasta de logs se não existir
mkdir -p monitor

if [ ! -f "$VECTOR_FILE" ]; then
    echo "Erro: Vetor de teste não encontrado em $VECTOR_FILE. Execute o batch_gen_vectors.sh primeiro."
    exit 1
fi

echo "Injetando vetores de teste..."
cp "$VECTOR_FILE" "${SKETCH_DIR}/test_data.h"

echo "Compilando firmware..."
arduino-cli compile --fqbn $FQBN "$SKETCH_DIR"

echo "Enviando para o ESP32..."
arduino-cli upload -p $PORT --fqbn $FQBN "$SKETCH_DIR"

echo "Conectando ao monitor serial... (Pressione o botão BOOT no ESP32 para iniciar)"
# O comando 'tee' salva a tabela no arquivo .log enquanto exibe no terminal
arduino-cli monitor -p $PORT --config baudrate=115200 | tee "$LOG_FILE"
