# Ouvrir le fichier VCD
open_trace "generated_tb.vcd"

# Liste des signaux à récupérer
set signals_list {"mid_r" "mid_w" "s_axi_awaddr" "s_axi_araddr" "wrapper_write_response" "wrapper_read_response" "error_signal"}

# Sélectionner les signaux
foreach signal $signals_list {
    gtkwave::addSignalsFromList $signal
}

# Définir le temps à inspecter
gtkwave::setCursorTime 30us

# Récupérer et afficher les valeurs des signaux
foreach signal $signals_list {
    set signal_value [gtkwave::getSignalValue $signal]
    puts "La valeur de $signal à 30us est $signal_value"
}

