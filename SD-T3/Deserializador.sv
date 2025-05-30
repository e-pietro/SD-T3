/*
O trabalho consiste da integração de dois módulos funcionando sobre domínios de relógio diferentes. 
Estes módulos são um DESERIALIZADOR e uma PILHA.

DESERIALIZADOR:
- Recebe sequência de bits pelo data_in.
- Escreve palavras de 8 bits no sinal data_out.
- status_out indica se o serializador está em condições de receber dados.
- sinal write_in indica que o dado deve ser interpretado pelo deserializador.
- Fio data_out possui 8 bits e representa a saída de dados do deserializador.
- Sinal data_ready informa se os dados estão prontos para consumo quando está alto.
- Sinal ack_in é escrito quando se confirma o dado recebido
*/

module Deserializador (
    input clk,
    input reset,
    input data_in,
    input write_in,
    input ack_in,
    output [7:0] data_out,
    output data_ready,
    output status_out
);

    reg [7:0] buffer;
    reg [2:0] bit_count;

    typedef enum logic [1:0] {
        WAITING = 2'b00,
        RECEBA = 2'b01,
        READY = 2'b10
    } state_t;

    state_t state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state       <= WAITING;
            buffer      <= 8'b0;
            bit_count   <= 3'b0;
            data_out    <= 8'b0;
            data_ready  <= 0;
            status_out  <= 0;

        end else begin
            case (state)

                // Estado Inicial
                WAITING: begin
                    status_out <= 0;
                    data_ready <= 0;
                    if (write_in) begin
                        buffer[0]  <= data_in;
                        bit_count  <= 3'd1;
                        state      <= RECEBA;
                    end
                end

                // Recebendo bits
                RECEBA: begin
                    if (write_in) begin
                        buffer[bit_count] <= data_in;
                        bit_count <= bit_count + 1;
                        if (bit_count == 3'd7) begin
                            data_out    <= {data_in, buffer[6:0]}; // completa 8 bits
                            data_ready  <= 1;
                            status_out  <= 1;
                            state       <= READY;
                        end
                    end
                end

                // Pronto para transmitir
                READY: begin
                    if (ack_in) begin
                        buffer  <= 8'b0;
                        bit_count <= 3'd0;
                        data_ready <= 0;
                        status_out <= 0;
                        state <= WAITING;
                    end
                end

                default: state <= WAITING;
            endcase
        end
    end

endmodule

