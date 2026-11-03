#include <Arduino.h>
#include "test_data.h"

extern "C" {
  #include "src/api.h"
}

const int BUTTON_PIN = 0; 

void sphincsVerifyTask(void *pvParameters) {
  Serial.println("\n--- Pressione o botao BOOT na placa para iniciar o Benchmark ---");
  
  while (digitalRead(BUTTON_PIN) == HIGH) {
    vTaskDelay(50 / portTICK_PERIOD_MS);
  }
  
  Serial.println("Iteracao | Status | Tempo (ms) | Pico Heap (B) | Min Heap Global (B) | Stack Livre (B)");
  Serial.println("------------------------------------------------------------------------------------------");
  
  for (int i = 0; i <= 10; i++) {
    uint32_t heap_antes = ESP.getFreeHeap();
    unsigned long t_inicio = millis();
    
    int status = PQCLEAN_SPHINCSSHA2128SSIMPLE_CLEAN_crypto_sign_verify(
      signature, sizeof(signature), test_message, sizeof(test_message) - 1, public_key
    );
    
    unsigned long t_fim = millis();
    uint32_t heap_depois = ESP.getFreeHeap();
    
    if (i > 0) { // Ignora a iteração 0 (warm-up) e imprime as linhas oficiais
      Serial.printf("%-8d | %-6s | %-10lu | %-13u | %-19u | %-15u\n", 
                    i, 
                    (status == 0) ? "OK" : "FALHOU",
                    (t_fim - t_inicio), 
                    (heap_antes - heap_depois), 
                    ESP.getMinFreeHeap(), 
                    uxTaskGetStackHighWaterMark(NULL));
    }
    vTaskDelay(10 / portTICK_PERIOD_MS);
  }
  
  Serial.println("--- Benchmark Concluido ---");
  vTaskDelete(NULL); 
}

void setup() {
  Serial.begin(115200);
  setCpuFrequencyMhz(240);
  pinMode(BUTTON_PIN, INPUT_PULLUP);
  xTaskCreatePinnedToCore(sphincsVerifyTask, "Verify_Task", 10240, NULL, 1, NULL, 1);
}

void loop() {}
