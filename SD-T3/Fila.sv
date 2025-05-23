
module Fila(
    input logic data_in,
    input loigc enqueue_in,
    input logic reset,
    input logic dequeue_in,
    input logic clock_10khz
    output logic len_out,
    output logic data_out
);

    //registrador
    logic [7:0] queue
    

