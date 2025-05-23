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

module deserializador (
    input logic data_in,
    input logic write_in,
    input logic reset,
    input logic clock_100khz
    input logic ack_in,
    output logic status_out,
    output logic [7:0] data_out,
    output logic data_ready

);

always_ff @(posedge clock or posedge reset ) begin : blockName
    
end
