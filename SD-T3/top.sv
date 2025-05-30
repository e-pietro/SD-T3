module top(
  input logic reset,
  input logic clock,
  input logic data_in,
  output logic [7:0] buffer,
  output logic data_ready,
);

  Deserializador dut(
    .clk(clk),
    .reset(reset),
    .data_in(data_in),
    .write_in(write_in),
    .ack_in(ack_in),
    .data_out(data_out),
    .data_ready(data_ready),
    .status_out(status_out)
  );

  Fila dut(
    .data_in(data_in),
    .enqueue_in(enqueue_in),
    .reset(reset),
    .dequeue_in(dequeue_in),
    .clock_10khz(clock_10khz),
    .len_out(len_out),
    .data_out(dataout)
  );
      

