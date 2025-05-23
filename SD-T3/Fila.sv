/*
O trabalho consiste da integração de dois módulos funcionando sobre domínios de relógio diferentes. 
Estes módulos são um DESERIALIZADOR e uma PILHA.

FILA:
- Representa um container de tamanho limitado do tipo LIFO de 8 bits.
- Através dos sinais data_in e enqueue_in são inseridos os elementos na fila.
- E para remover serão usados data_out e dequeue_in.
- len_out de 8 bits sempre indica o número de elementos da fila.
- Quando o sinal dequeue_in sobre, o primeiro dado a ser retirado da fila deve
aparecer em data_out no ciclo subsequente se o número de elementos (len_out) for maior que zero.
*/

module Fila(
    input logic [7:0] data_in,
    input loigc enqueue_in,
    input logic reset,
    input logic dequeue_in,
    input logic clock_10khz,
    output logic [7:0] len_out,
    output logic [7:0] data_out
);

    //FSM
    typedef enum logic [2:0] {
    enqueue = 3'b000,
    dequeue = 3'b001,
    ack = 3'b010
    } state_t;

    //Registradores
    state_t state;
    state_t prev_state;
    logic element_count;
    logic head;

    /*
        enqueue:
            bota na primeira posição se estiver vazia
            se não coloca atrás do último colocado

        dequeue:
            não acontece nada se estiver vazia
            tira o primeiro elemento e o elemento de trás vira o head
    */

   funciton logic [7:0] enqueue ()

   always_ff @(posedge clock or posedge reset ) begin
    if (reset) begin
        data_in <= 8'b0;
        data_out <= 8'b0;
        enqueue_in <= 1'b0;
        clock_10khz <= 1'b0;
        len_out <= 8'b0;
        dequeue_in <= 1'b0;
    end

    case (state)
        enqueue: begin 
            if (element_count == 0) head <= data_in
            else 
        
        end

    end



    

