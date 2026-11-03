cd host_generator/PQClean/sphincs-sha2-256s-simple/

# Compila o gerador local excluindo o randombytes do ESP32
gcc -O3 gen.c $(ls ../../../esp32_verifier/PQClean/sphincs-sha2-256s-simple/src/*.c | grep -v randombytes.c) -o gerador

# Executa o gerador e salva o output diretamente na pasta de vetores
./gerador > ../../../test_vectors/test_data.h
cd ../../../
cp test_vectors/test_data.h esp32_verifier/PQClean/sphincs-sha2-256s-simple/

echo Compilando
arduino-cli compile --fqbn esp32:esp32:esp32 esp32_verifier/PQClean/sphincs-sha2-256s-simple
arduino-cli upload -p /dev/ttyUSB0 --fqbn esp32:esp32:esp32 esp32_verifier/PQClean/sphincs-sha2-256s-simple

echo Monitorando ESP32
arduino-cli monitor -p /dev/ttyUSB0 --config baudrate=115200
