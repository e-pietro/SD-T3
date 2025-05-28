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
    input logic enqueue_in,
    input logic reset,
    input logic dequeue_in,
    input logic clock_10khz,
    output logic [7:0] len_out,
    output logic [7:0] data_out // Agora será atualizado
);

    //Registradores
    // logic element_count; // Não usado
    // logic head;          // Não usado
    logic [7:0] fila [7:0]; // Armazenamento (0 a 7)

    always_ff @(posedge clock_10khz or posedge reset) begin
        if (reset) begin
            
            data_in <= 8'b0;     
            data_out <= 8'b0;    
            enqueue_in <= 1'b0;  
            clock_10khz <= 1'b0; 
            len_out <= 8'b0;     
            dequeue_in <= 1'b0;
            // Adicionado: Limpar a fila no reset
            for (int i = 0; i < 8; i++) begin
                fila[i] <= 8'b0;
            end
        end
        else begin
            //Lógica de Enqueue 
            if (enqueue_in && !dequeue_in && (len_out < 8)) begin 
                fila[len_out] <= data_in; 
                len_out <= len_out + 1; 
            end
            //Lógica de Dequeue
            else if (dequeue_in && !enqueue_in && (len_out > 0)) begin
                data_out <= fila[0]; 
                for (int i = 0; i < len_out - 1; i++) begin
                    fila[i] <= fila[i+1];
                end
                fila[len_out - 1] <= 8'b0; // Limpa última posição
                len_out <= len_out - 1;
            end
            //Caso Enqueue e Dequeue ao mesmo tempo
            else if (enqueue_in && dequeue_in && (len_out > 0)) begin
                // O dado sai e um novo entra - a fila "anda"
                data_out <= fila[0];
                for (int i = 0; i < len_out - 1; i++) begin
                     fila[i] <= fila[i+1];
                end
                fila[len_out - 1] <= data_in; // Novo dado entra na última posição
                // len_out não muda (sai um, entra um)
            end
            // --- Caso Enqueue e Dequeue ao mesmo tempo, mas fila vazia ---
            else if (enqueue_in && dequeue_in && (len_out == 0)) begin
                 // O dado entra e sai no mesmo ciclo (pass-through)
                 data_out <= data_in;
                 // len_out continua 0
            end

        end
    end

endmodule



    

