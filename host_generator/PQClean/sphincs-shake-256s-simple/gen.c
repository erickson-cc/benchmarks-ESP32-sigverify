#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <sys/random.h>
#include "../../../esp32_verifier/PQClean/sphincs-shake-256s-simple/src/api.h"

// Implementação do TRNG local para rodar no Arch Linux
int PQCLEAN_randombytes(uint8_t *buf, size_t n) {
    getrandom(buf, n, 0);
    return 0;
}

void print_array(const char *name, const uint8_t *data, size_t len) {
    printf("const uint8_t %s[%zu] = {\n", name, len);
    for (size_t i = 0; i < len; i++) {
        printf("0x%02X", data[i]);
        if (i < len - 1) printf(", ");
        if ((i + 1) % 12 == 0) printf("\n");
    }
    printf("\n};\n");
}

int main() {
    uint8_t pk[PQCLEAN_SPHINCSSHA2256SSIMPLE_CLEAN_CRYPTO_PUBLICKEYBYTES];
    uint8_t sk[PQCLEAN_SPHINCSSHA2256SSIMPLE_CLEAN_CRYPTO_SECRETKEYBYTES];
    uint8_t sig[PQCLEAN_SPHINCSSHA2256SSIMPLE_CLEAN_CRYPTO_BYTES];
    size_t sig_len;

    uint8_t msg[] = "Mensagem TCC ESP32";
    size_t msg_len = strlen((char *)msg);

    PQCLEAN_SPHINCSSHA2256SSIMPLE_CLEAN_crypto_sign_keypair(pk, sk);
    PQCLEAN_SPHINCSSHA2256SSIMPLE_CLEAN_crypto_sign_signature(sig, &sig_len, msg, msg_len, sk);

    printf("#ifndef TEST_DATA_H\n#define TEST_DATA_H\n\n");
    printf("#include <stdint.h>\n#include <stddef.h>\n\n");
    printf("const uint8_t test_message[] = \"%s\";\n\n", msg);
    print_array("public_key", pk, sizeof(pk));
    print_array("signature", sig, sig_len);
    printf("\n#endif\n");

    return 0;
}
