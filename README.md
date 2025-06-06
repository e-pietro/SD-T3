# 🚀 Projeto de Sistema Digital com Múltiplos Domínios de Clock

## 1️⃣ Introdução

Este projeto tem como objetivo desenvolver um sistema digital que integra dois módulos com clocks diferentes: um **Deserializador** e uma **Fila (FIFO)**.

✨ **Deserializador:** recebe dados seriais (bit a bit) e gera palavras de 8 bits.  
📥 **Fila (FIFO):** armazena essas palavras seguindo a ordem First-In, First-Out.  
🧩 **Módulo Top:** integra os módulos e gera clocks derivados a partir de um clock principal de 1 MHz.

---

## 2️⃣ Organização do Projeto

### 🔄 Deserializador

- Recebe 1 bit por vez via `data_in`.
- Após 8 bits, gera palavra de 8 bits em `data_out` e sinaliza com `data_ready`.
- Espera confirmação via `ack_in`.
- Indica ocupado com `status_out`.
- Opera a 100 kHz.

### 📊 Fila (FIFO)

- Armazena até 8 palavras (8 bits cada).
- Entrada por `enqueue_in`, saída por `dequeue_in`.
- Modelo FIFO: o primeiro que entra é o primeiro que sai.
- Indica quantidade de dados com `len_out`.
- Opera a 10 kHz.

### 🏗️ Módulo Top

- Integra deserializador e fila.
- Gera clocks de 100 kHz e 10 kHz a partir do clock base 1 MHz.
- Envia dados completos do deserializador para fila, respeitando o espaço disponível.
- Controla handshake entre módulos.

---

## 3️⃣ Execução

### Como rodar

1. Abra o projeto no Modelsim/Questa.  
2. Execute o arquivo `sim.do` para rodar a simulação automaticamente.  
3. Verifique os resultados no waveform.  
4. Todos os módulos estão prontos para simulação.

---

## 4️⃣ Interface e Simulação

- Dados entram pelo `data_in` controlado pelo testbench.  
- Fila armazena dados via `enqueue_in` e retira via `dequeue_in`.  
- Saídas monitoradas: `data_out`, `status_out`, `data_ready`, `len_out`.  
- Fluxo de dados e clocks validados pela simulação.

---

**Desenvolvido por Eduardo Pietro e Gabriel Woltmann**  
