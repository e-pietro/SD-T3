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

module Fila (
    input logic [7:0] data_in,
    input logic enqueue_in,
    input logic reset,
    input logic dequeue_in,
    input logic clock_10khz,
    output logic [7:0] len_out,
    output logic [7:0] data_out
);

    typedef enum logic [1:0] { 
        IDLE      = 2'b00,
        ENQUEUE   = 2'b01,
        DEQUEUE   = 2'b10,
        BOTH      = 2'b11
    } state_t;

    state_t current_state, next_state;

    logic [7:0] fila_mem [7:0];
    logic [7:0] internal_len; //Posição
    logic [7:0] internal_data_out; //Bits

    logic is_full = (internal_len == 8);
    logic is_empty = (internal_len == 0);

    always_comb begin
        next_state = IDLE;
        case (current_state)
            IDLE: begin
                if (enqueue_in && !is_full && dequeue_in && !is_empty) begin
                    next_state = BOTH;
                end else if (enqueue_in && !is_full) begin
                    next_state = ENQUEUE;
                end else if (dequeue_in && !is_empty) begin
                    next_state = DEQUEUE;
                end else begin
                    next_state = IDLE;
                end
            end
            ENQUEUE: next_state = IDLE;
            DEQUEUE: next_state = IDLE;
            BOTH:    next_state = IDLE;
        endcase
    end

    always_ff @(posedge clock_10khz or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            internal_len <= 8'b0;
            internal_data_out <= 8'b0;
            for (int i = 0; i < 8; i++) begin
                fila_mem[i] <= 8'b0;
            end
        end else begin
            current_state <= next_state; 

            case (next_state)
                ENQUEUE: begin
                    fila_mem[internal_len] <= data_in;
                    internal_len <= internal_len + 1;
                end
                DEQUEUE: begin
                    internal_data_out <= fila_mem[0];
                    for (int i = 0; i < 7; i++) begin
                        fila_mem[i] <= fila_mem[i + 1];
                    end
                    fila_mem[internal_len - 1] <= 8'b0;
                    internal_len <= internal_len - 1;
                end
                BOTH: begin
                    internal_data_out <= fila_mem[0];
                    
                    // Desloca e adiciona na última posição
                    for (int i = 0; i < 7; i++) begin
                        fila_mem[i] <= fila_mem[i + 1];
                    end
                    fila_mem[internal_len - 1] <= data_in;
                    // len fica igual (sai 1, entra 1)
                    internal_len <= internal_len;
                end
                IDLE: begin
                    internal_data_out <= 8'b0; 
                end
            endcase
        end
    end

    // Saídas
    assign data_out = internal_data_out;
    assign len_out = internal_len;

endmodule



    

