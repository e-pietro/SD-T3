# wave.do - Configura as ondas para visualização no ModelSim

# Abre a janela de ondas
quietly view wave

# Configura a forma de exibição dos sinais
add wave -divider "TOP"
add wave -hex /top_tb_fila_cheia/dut/*
add wave -divider "DESERIALIZADOR"
add wave -hex /top_tb_fila_cheia/dut/des/*
add wave -divider "FILA"
add wave -hex /top_tb_fila_cheia/dut/fila/*

# Sinais específicos para monitorar
add wave -binary /top_tb_fila_cheia/clk_1MHz
add wave -binary /top_tb_fila_cheia/reset
add wave -binary /top_tb_fila_cheia/data_in
add wave -binary /top_tb_fila_cheia/write_in
add wave -binary /top_tb_fila_cheia/dequeue_in
add wave -hex /top_tb_fila_cheia/fila_data_out
add wave -hex /top_tb_fila_cheia/fila_len_out
add wave -binary /top_tb_fila_cheia/dut/des/status_out
add wave -binary /top_tb_fila_cheia/dut/des/data_ready

# Formatação para melhor visualização
configure wave -timelineunits ns
WaveRestoreZoom {0 ns} {200 us}