`timescale 1ns/1ps

module top_tb_fila_cheia;

    logic clk_1MHz;
    logic reset;
    logic data_in;
    logic write_in;
    logic dequeue_in;
    logic [7:0] fila_data_out;
    logic [7:0] fila_len_out;

    Top dut (
        .clk_1MHz(clk_1MHz),
        .reset(reset),
        .data_in(data_in),
        .write_in(write_in),
        .dequeue_in(dequeue_in),
        .fila_data_out(fila_data_out),
        .fila_len_out(fila_len_out)
    );

    always #500 clk_1MHz = ~clk_1MHz;

    initial begin
        // Inicializacao
        clk_1MHz = 0;
        reset = 1;
        data_in = 0;
        write_in = 0;
        dequeue_in = 0;

        #2000;
        reset = 0;

        // Enche a fila (8 bytes)
        for (int i = 0; i < 8; i++) begin
            send_byte(8'b10101011); // Envia byte ABh
            #15000; // Espera processamento
        end

        // Tenta enviar um 9 byte (deve travar o deserializador)
        send_byte(8'b11001100); // CCh
        #20000;

        // Verifica se status_out esta alto (deserializador travado)
        if (dut.des.status_out) 
            $display("Caso Ruim: Fila cheia travou o deserializador (status_out = 1)");
        else
            $display("Falha: status_out nao esta alto com fila cheia");

        // Tenta remover 1 item para liberar espaço
        dequeue_in = 1;
        #2000;
        dequeue_in = 0;
        #10000;

        // Verifica se status_out voltou a 0 apos dequeue
        if (!dut.des.status_out)
            $display("Deserializador liberado após dequeue");
        else
            $display("Falha: status_out ainda alto após dequeue");

        $finish;
    end

    task send_byte(input [7:0] data);
        for (int i = 0; i < 8; i++) begin
            @(posedge clk_1MHz);
            data_in = data[i];
            write_in = 1;
            @(posedge clk_1MHz);
            write_in = 0;
        end
    endtask

endmodule
