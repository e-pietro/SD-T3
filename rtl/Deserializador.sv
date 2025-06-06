module Deserializador (
    input logic clk,
    input logic reset,
    input logic data_in,
    input logic write_in,
    input logic ack_in,
    output logic [7:0] data_out,
    output logic data_ready,
    output logic status_out
);

    logic [7:0] buffer;
    logic [2:0] bit_count;

    typedef enum logic [1:0] {
        WAITING = 2'b00,
        RECEBA  = 2'b01,
        READY   = 2'b10
    } state_t;

    state_t state;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state       <= WAITING;
            buffer      <= 8'b0;
            bit_count   <= 3'b0;
            data_out    <= 8'b0;
            data_ready  <= 0;
            status_out  <= 0;
        end else begin
            case (state)

                WAITING: begin
                    status_out <= 0;
                    data_ready <= 0;
                    if (write_in) begin
                        buffer[0]  <= data_in;
                        bit_count  <= 3'd1;
                        state      <= RECEBA;
                    end
                end

                RECEBA: begin
                    if (write_in) begin
                        buffer[bit_count] <= data_in;
                        bit_count <= bit_count + 1;
                        if (bit_count == 3'd7) begin
                            data_out    <= {data_in, buffer[6:0]};
                            data_ready  <= 1;
                            status_out  <= 1;
                            state       <= READY;
                        end
                    end
                end

                READY: begin
                    if (ack_in) begin
                        buffer      <= 8'b0;
                        bit_count   <= 3'd0;
                        data_ready  <= 0;
                        status_out  <= 0;
                        state       <= WAITING;
                    end
                end

                default: state <= WAITING;

            endcase
        end
    end

endmodule
