
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