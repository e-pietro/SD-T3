module Top (
    input logic clk_1MHz,
    input logic reset,
    input logic data_in,
    input logic write_in,
    input logic dequeue_in,
    output logic [7:0] fila_data_out,
    output logic [7:0] fila_len_out
);

    // ======================
    // CLOCK DIVIDERS
    // ======================
    logic clk_100kHz;
    logic clk_10kHz;
    logic [3:0] clk_div_100kHz = 0;
    logic [6:0] clk_div_10kHz = 0;

    always_ff @(posedge clk_1MHz or posedge reset) begin
        if (reset) begin
            clk_div_100kHz <= 0;
            clk_100kHz <= 0;
        end else begin
            clk_div_100kHz <= clk_div_100kHz + 1;
            if (clk_div_100kHz == 4) begin // Divide por 10
                clk_100kHz <= ~clk_100kHz;
                clk_div_100kHz <= 0;
            end
        end
    end

    always_ff @(posedge clk_1MHz or posedge reset) begin
        if (reset) begin
            clk_div_10kHz <= 0;
            clk_10kHz <= 0;
        end else begin
            clk_div_10kHz <= clk_div_10kHz + 1;
            if (clk_div_10kHz == 49) begin // Divide por 100
                clk_10kHz <= ~clk_10kHz;
                clk_div_10kHz <= 0;
            end
        end
    end

    // ======================
    // INTERCONEXÃO
    // ======================
    logic [7:0] des_data_out;
    logic des_data_ready, des_status;
    logic ack_signal;
    logic enqueue_signal;

    always_ff @(posedge clk_100kHz or posedge reset) begin
    if (reset) begin
        ack_signal <= 0;
        enqueue_signal <= 0;
    end else begin
        if (des_data_ready && !enqueue_signal && !ack_signal) begin
            enqueue_signal <= 1;  // Solicita enqueue
        end else if (enqueue_signal && dut.fila.enqueue_in) begin
            enqueue_signal <= 0;   // Fila aceitou o dado
            ack_signal <= 1;       // Confirma recebimento
        end else begin
            ack_signal <= 0;
        end
    end
end

    // ======================
    // INSTANCIANDO MÓDULOS
    // ======================

    Deserializador des (
        .clk(clk_100kHz),
        .reset(reset),
        .data_in(data_in),
        .write_in(write_in),
        .ack_in(ack_signal),
        .data_out(des_data_out),
        .data_ready(des_data_ready),
        .status_out(des_status)
    );

    Fila fila (
        .data_in(des_data_out),
        .enqueue_in(enqueue_signal),
        .reset(reset),
        .dequeue_in(dequeue_in),
        .clock_10khz(clk_10kHz),
        .len_out(fila_len_out),
        .data_out(fila_data_out)
    );

endmodule
