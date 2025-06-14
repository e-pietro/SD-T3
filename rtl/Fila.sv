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
        DEQUEUE   = 2'b10
    } state_t;

    state_t current_state, next_state;

    logic [7:0] fila_mem [7:0];
    logic [7:0] internal_len; //Posição
    logic [7:0] internal_data_out; //Bits

    logic is_full;
    logic is_empty;

    always_comb begin
        is_full = (internal_len == 8);
        is_empty = (internal_len == 0);
    end


    always_comb begin
        next_state = IDLE;
        case (current_state)
            IDLE: begin
                if (enqueue_in && !is_full) begin
                    next_state = ENQUEUE;
                end else if (dequeue_in && !is_empty) begin
                    next_state = DEQUEUE;
                end else begin
                    next_state = IDLE;
                end
            end
            ENQUEUE: next_state = IDLE;
            DEQUEUE: next_state = IDLE;
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
                if(!is_full) begin
                    fila_mem[internal_len] <= data_in;
                    internal_len <= internal_len + 1;
                end
            end
                DEQUEUE: begin
                    internal_data_out <= fila_mem[0];
                    for (int i = 0; i < 7; i++) begin
                        fila_mem[i] <= fila_mem[i + 1];
                    end
                    fila_mem[internal_len - 1] <= 8'b0;
                    internal_len <= internal_len - 1;
                end
                IDLE: begin
                    
                end
            endcase
        end
    end

    // Saídas
    assign data_out = internal_data_out;
    assign len_out = internal_len;

endmodule
