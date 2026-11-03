#!/bin/bash

# Define os caminhos relativos a partir da raiz do projeto
HOST_DIR="host_generator/PQClean"
VERIFIER_DIR="esp32_verifier/PQClean"
VECTOR_DIR="test_vectors"

# Garante que a pasta de vetores exista
mkdir -p "$VECTOR_DIR"

echo "Iniciando geracao em lote dos vetores de teste..."

# Itera sobre todos os diretorios de algoritmos no host
for ALGO_PATH in "$HOST_DIR"/*/; do
    # Extrai o nome exato da pasta (ex: SPHINCSSHA2256SSIMPLE_CLEAN)
    ALGO=$(basename "$ALGO_PATH")
    
    GEN_FILE="${ALGO_PATH}gen.c"
    SRC_DIR="${VERIFIER_DIR}/${ALGO}/src"
    OUT_HEADER="${VECTOR_DIR}/${ALGO}_vectors.h"

    if [ -f "$GEN_FILE" ]; then
        echo "Processando algoritmo: $ALGO"
        
        # Compila ignorando o randombytes.c (que pertence apenas ao ESP32)
        gcc -O3 "$GEN_FILE" $(ls "$SRC_DIR"/*.c | grep -v randombytes.c) -o "${ALGO_PATH}gerador"
        
        # Executa o binário e exporta o cabeçalho C
        "${ALGO_PATH}gerador" > "$OUT_HEADER"
        
        # Remove o binário temporário para manter o repositório limpo
        rm "${ALGO_PATH}gerador"
    fi
done

echo "Todos os vetores foram gerados e salvos em /$VECTOR_DIR/"
