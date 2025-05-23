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
    input logic data_in,
    input loigc enqueue_in,
    input logic reset,
    input logic dequeue_in,
    input logic clock_10khz
    output logic len_out,
    output logic data_out
);

    //registrador
    logic [7:0] queue
    

