#include "randombytes.h"
#include <esp_random.h>
#include <stdint.h>
#include <stddef.h>

int randombytes(uint8_t *buf, size_t n) {
    esp_fill_random(buf, n);
    return 0; 
}
