`timescale 1ns/1ps

module top_tb_fluxo_continuo;

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

        // Reset
        #2000;
        reset = 0;

        // Envia 4 bytes e faz dequeues intercalados
        fork
            begin //Envia dados
                for (int i = 0; i < 4; i++) begin
                    send_byte(8'b10101011); // ABh
                    #10000;
                end
            end
            begin //Remove dados
                #30000; // Espera a fila ter alguns itens
                for (int i = 0; i < 4; i++) begin
                    dequeue_in = 1;
                    #2000;
                    dequeue_in = 0;
                    #10000;
                end
            end
        join

        // Verifica se status_out nunca ficou alto (sem travamento)
        if (!dut.des.status_out)
            $display("Caso Bom: Fluxo continuo sem travamento (status_out = 0)");
        else
            $display("Falha: status_out alto durante fluxo continuo");

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
