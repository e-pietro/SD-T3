# sim.do - Script para compilar e simular os testbenches no ModelSim

# Configurações iniciais
vlib work
vmap work work

# Compila todos os módulos e testbenches
vlog -sv Deserializador.sv Fila.sv Top.sv
vlog -sv top_tb_fila_cheia.sv
vlog -sv top_tb_fluxo_continuo.sv

# Simula o testbench do caso ruim (fila cheia)
echo "\n\n=== SIMULAÇÃO CASO RUIM (FILA CHEIA) ==="
vsim -voptargs=+acc work.top_tb_fila_cheia
run -all

# Simula o testbench do caso bom (fluxo contínuo)
echo "\n\n=== SIMULAÇÃO CASO BOM (FLUXO CONTÍNUO) ==="
vsim -voptargs=+acc work.top_tb_fluxo_continuo
run -all

# Fecha a simulação
quit -sim