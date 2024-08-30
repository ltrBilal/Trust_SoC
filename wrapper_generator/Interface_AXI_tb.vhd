library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;


entity Interface_AXI_tb is
end Interface_AXI_tb;

architecture rtl of Interface_AXI_tb is

    -- Largeur de l'identifiant de transaction AXI
    signal C_S_AXI_ID_WIDTH       : integer := 3;
    -- Largeur des données AXI en bits
    signal C_S_AXI_DATA_WIDTH     : integer := 16;
    -- Largeur de l'adresse AXI en bits
    signal C_S_AXI_ADDR_WIDTH     : integer := 5;
    -- Largeur des signaux utilisateur pour les canaux AW, AR, W, R et B
    -- optional
    signal C_S_AXI_AWUSER_WIDTH   : integer := 0;
    signal C_S_AXI_ARUSER_WIDTH   : integer := 0;
    signal C_S_AXI_WUSER_WIDTH    : integer := 0;
    signal C_S_AXI_RUSER_WIDTH    : integer := 0;
    signal C_S_AXI_BUSER_WIDTH    : integer := 0;

    signal C_MASTER_ID_WIDTH 	: integer := 3;

    -- ID des maitres
    signal MID_R 			  :  std_logic_vector(C_MASTER_ID_WIDTH-1 downto 0); -- signal pour l'ID du maitre qui demande la lecture
    signal MID_W 			  : std_logic_vector(C_MASTER_ID_WIDTH-1 downto 0); -- signal pour l'ID du maitre qui demande l'écriture

    signal rule_number       : std_logic_vector(2 downto 0);
    signal data_rule         : std_logic_vector(15 downto 0);
    signal w_rule_enable	  : std_logic; -- signal pour indiquer qu'on est entrain d'écrire une règle dans la mémoire

    signal x_enable          : std_logic;

    -- signaux pour les réponses
    signal wrapper_write_response  : std_logic;
    signal wrapper_read_response   : std_logic;

    -- D�claration du fichier de log global
    file log_file : text;

    -- D�claration de la fonction pour la v�rification et l'�criture
    function check_write_test( wrapper_response : std_logic; test_number : integer) return boolean is
        variable log_line : line;
    begin
        if wrapper_write_response = wrapper_response then
            report "Test PASSED" severity note;
            return true;
        else
            report "Test FAILED" severity error;
            write(log_line, string'("ERROR : test number "));
            write(log_line, integer'image(test_number));
            write(log_line, string'(" FAILED "));
            writeline(log_file, log_line);
            return false;
        end if;
    end function;

    -- D�claration de la fonction pour la v�rification et l'�criture
    function check_read_test( wrapper_response : std_logic; test_number : integer) return boolean is
        variable log_line : line;
    begin
        if wrapper_read_response = wrapper_response then
            report "Test PASSED" severity note;
            return true;
        else
            report "Test FAILED" severity error;
            write(log_line, string'("ERROR : test number "));
            write(log_line, integer'image(test_number));
            write(log_line, string'(" FAILED "));
            writeline(log_file, log_line);
            return false;
        end if;
    end function;

    ------------------------------------------- AXI signals -------------------------------------------
    -- Horloge
    signal S_AXI_ACLK        : std_logic;
    -- Signal pour la réinitialisation
    signal S_AXI_ARESETN     : std_logic;

    -- Adresse d'écriture et canaux de contrôle
    signal S_AXI_AWID        : std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);   -- Identifiant de la transaction d'écriture
    signal S_AXI_AWADDR      : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0); -- Adresse où le maître veut écrire
    signal S_AXI_AWLEN       : std_logic_vector(7 downto 0); -- Longueur de la transaction (nombre de transferts de données)
    signal S_AXI_AWSIZE      : std_logic_vector(2 downto 0); -- Taille de chaque transfert de données
    signal S_AXI_AWBURST     : std_logic_vector(1 downto 0); -- Type de burst (INCR, WRAP, etc.)
    signal S_AXI_AWLOCK      : std_logic; -- Verrouillage de la transaction
    signal S_AXI_AWCACHE     : std_logic_vector(3 downto 0); -- Attributs de cache
    signal S_AXI_AWPROT      : std_logic_vector(2 downto 0); -- Attributs de protection
    signal S_AXI_AWQOS       : std_logic_vector(3 downto 0); -- Qualité de service
    signal S_AXI_AWREGION    : std_logic_vector(3 downto 0); -- Région de l'adresse
    signal S_AXI_AWUSER      : std_logic_vector(C_S_AXI_AWUSER_WIDTH-1 downto 0); -- Signaux utilisateur supplémentaires 
    signal S_AXI_AWVALID     : std_logic; -- Indique que l'adresse d'écriture et les signaux de contrôle sont valides

    -- Données d'écriture et canaux de contrôle
    signal S_AXI_WDATA       : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0); -- Données d'écriture
    signal S_AXI_WSTRB       : std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0); -- Strobes de données (indique les octets valides)
    signal S_AXI_WLAST       : std_logic; -- Indique le dernier transfert de données dans un burst
    signal S_AXI_WUSER       : std_logic_vector(C_S_AXI_WUSER_WIDTH-1 downto 0); -- Signaux utilisateur supplémentaires 
    signal S_AXI_WVALID      : std_logic; -- Indique que les données d'écriture sont valides

    -- Réponse d'écriture du maître
    signal S_AXI_BREADY      : std_logic; -- Indique que le maître est prêt à accepter une réponse d'écriture

    -- Adresse de lecture et canaux de contrôle
    signal S_AXI_ARID        : std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);   -- Identifiant de la transaction de lecture
    signal S_AXI_ARADDR      : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0); -- Adresse où le maître veut lire
    signal S_AXI_ARLEN       : std_logic_vector(7 downto 0); -- Longueur de la transaction de lecture (nombre de transferts de données)
    signal S_AXI_ARSIZE      : std_logic_vector(2 downto 0); -- Taille de chaque transfert de données
    signal S_AXI_ARBURST     : std_logic_vector(1 downto 0); -- Type de burst de lecture (INCR, WRAP)
    signal S_AXI_ARLOCK      : std_logic; -- Verrouillage de la transaction de lecture
    signal S_AXI_ARCACHE     : std_logic_vector(3 downto 0); -- Attributs de cache de lecture
    signal S_AXI_ARPROT      : std_logic_vector(2 downto 0); -- Attributs de protection de lecture
    signal S_AXI_ARQOS       : std_logic_vector(3 downto 0); -- Qualité de service de lecture
    signal S_AXI_ARREGION    : std_logic_vector(3 downto 0); -- Région de l'adresse de lecture
    signal S_AXI_ARUSER      : std_logic_vector(C_S_AXI_ARUSER_WIDTH-1 downto 0); -- Signaux utilisateur supplémentaires de lecture 
    signal S_AXI_ARVALID     : std_logic; -- Indique que l'adresse de lecture et les signaux de contrôle sont valides

    -- Réponse de lecture du maître
    signal S_AXI_RREADY      : std_logic; -- Indique que le maître est prêt à accepter des données de lecture

    -- Signaux de sortie de l'esclave vers le maître

    -- Réception des transactions d'écriture
    signal S_AXI_AWREADY     : std_logic; -- Indique que l'esclave est prêt à accepter une adresse d'écriture et le contrôle
    signal S_AXI_WREADY      : std_logic; -- Indique que l'esclave est prêt à accepter des données d'écriture

    -- Réponse d'écriture de l'esclave
    signal S_AXI_BID         : std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0); -- Identifiant de la transaction d'écriture
    signal S_AXI_BRESP       : std_logic_vector(1 downto 0); -- Code de réponse d'écriture (OKAY, EXOKAY, SLVERR, DECERR)
    signal S_AXI_BUSER       : std_logic_vector(C_S_AXI_BUSER_WIDTH-1 downto 0); -- Signaux utilisateur supplémentaires 
    signal S_AXI_BVALID      : std_logic; -- Indique que la réponse d'écriture est valide

    -- Réception des transactions de lecture
    signal S_AXI_ARREADY     : std_logic; -- Indique que l'esclave est prêt à accepter une adresse de lecture et le contrôle

    -- Réponse de lecture de l'esclave
    signal S_AXI_RID         : std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0); -- Identifiant de la transaction de lecture
    signal S_AXI_RDATA       : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0); -- Données de lecture
    signal S_AXI_RRESP       : std_logic_vector(1 downto 0); -- Code de réponse de lecture (OKAY, EXOKAY, SLVERR, DECERR)
    signal S_AXI_RLAST       : std_logic; -- Indique le dernier transfert de données dans un burst de lecture
    signal S_AXI_RUSER       : std_logic_vector(C_S_AXI_RUSER_WIDTH-1 downto 0); -- Signaux utilisateur supplémentaires 
    signal S_AXI_RVALID      : std_logic;  -- Indique que les données de lecture sont valides

begin

    interface_AXI_inst: entity work.interface_AXI
     generic map(
        C_S_AXI_ID_WIDTH => C_S_AXI_ID_WIDTH,
        C_S_AXI_DATA_WIDTH => C_S_AXI_DATA_WIDTH,
        C_S_AXI_ADDR_WIDTH => C_S_AXI_ADDR_WIDTH,
        C_S_AXI_AWUSER_WIDTH => C_S_AXI_AWUSER_WIDTH,
        C_S_AXI_ARUSER_WIDTH => C_S_AXI_ARUSER_WIDTH,
        C_S_AXI_WUSER_WIDTH => C_S_AXI_WUSER_WIDTH,
        C_S_AXI_RUSER_WIDTH => C_S_AXI_RUSER_WIDTH,
        C_S_AXI_BUSER_WIDTH => C_S_AXI_BUSER_WIDTH,
        C_MASTER_ID_WIDTH => C_MASTER_ID_WIDTH
    )
     port map(
        rule_number => rule_number,
        data_rule => data_rule,
        w_rule_enable => w_rule_enable,
        MID_R => MID_R,
        MID_W => MID_W,
        x_enable => x_enable,
        wrapper_write_response => wrapper_write_response,
        wrapper_read_response => wrapper_read_response,
        S_AXI_ACLK => S_AXI_ACLK,
        S_AXI_ARESETN => S_AXI_ARESETN,
        S_AXI_AWID => S_AXI_AWID,
        S_AXI_AWADDR => S_AXI_AWADDR,
        S_AXI_AWLEN => S_AXI_AWLEN,
        S_AXI_AWSIZE => S_AXI_AWSIZE,
        S_AXI_AWBURST => S_AXI_AWBURST,
        S_AXI_AWLOCK => S_AXI_AWLOCK,
        S_AXI_AWCACHE => S_AXI_AWCACHE,
        S_AXI_AWPROT => S_AXI_AWPROT,
        S_AXI_AWQOS => S_AXI_AWQOS,
        S_AXI_AWREGION => S_AXI_AWREGION,
        S_AXI_AWUSER => S_AXI_AWUSER,
        S_AXI_AWVALID => S_AXI_AWVALID,
        S_AXI_WDATA => S_AXI_WDATA,
        S_AXI_WSTRB => S_AXI_WSTRB,
        S_AXI_WLAST => S_AXI_WLAST,
        S_AXI_WUSER => S_AXI_WUSER,
        S_AXI_WVALID => S_AXI_WVALID,
        S_AXI_BREADY => S_AXI_BREADY,
        S_AXI_ARID => S_AXI_ARID,
        S_AXI_ARADDR => S_AXI_ARADDR,
        S_AXI_ARLEN => S_AXI_ARLEN,
        S_AXI_ARSIZE => S_AXI_ARSIZE,
        S_AXI_ARBURST => S_AXI_ARBURST,
        S_AXI_ARLOCK => S_AXI_ARLOCK,
        S_AXI_ARCACHE => S_AXI_ARCACHE,
        S_AXI_ARPROT => S_AXI_ARPROT,
        S_AXI_ARQOS => S_AXI_ARQOS,
        S_AXI_ARREGION => S_AXI_ARREGION,
        S_AXI_ARUSER => S_AXI_ARUSER,
        S_AXI_ARVALID => S_AXI_ARVALID,
        S_AXI_RREADY => S_AXI_RREADY,
        S_AXI_AWREADY => S_AXI_AWREADY,
        S_AXI_WREADY => S_AXI_WREADY,
        S_AXI_BID => S_AXI_BID,
        S_AXI_BRESP => S_AXI_BRESP,
        S_AXI_BUSER => S_AXI_BUSER,
        S_AXI_BVALID => S_AXI_BVALID,
        S_AXI_ARREADY => S_AXI_ARREADY,
        S_AXI_RID => S_AXI_RID,
        S_AXI_RDATA => S_AXI_RDATA,
        S_AXI_RRESP => S_AXI_RRESP,
        S_AXI_RLAST => S_AXI_RLAST,
        S_AXI_RUSER => S_AXI_RUSER,
        S_AXI_RVALID => S_AXI_RVALID
    );

    -- simulation d'horloge
    horloge_process : process
    begin
        S_AXI_ACLK <= '0';
        wait for 5 us;
        S_AXI_ACLK <= '1';
        wait for 5 us;
    end process;
    
    -- simulation de S_AXI_ARESETN
    reset_process : process
    begin
        S_AXI_ARESETN <= '1';
        wait for 5 us;
        S_AXI_ARESETN <= '0';
        wait;
    end process;

    -- simulation pour la memoire
    memory_process : process
    begin
        w_rule_enable <= '0';
        data_rule <= (others => '-');
        rule_number <= "---";
        wait for 5 us;
        rule_number <= "000";
        w_rule_enable <= '1';
        data_rule <= "0000100000011111";
        wait for 10 us;
        rule_number <= "001";
        w_rule_enable <= '1';
        data_rule <= "1001000001111100";
        wait for 10 us;
        rule_number <= "010";
        w_rule_enable <= '1';
        data_rule <= "0011010001111110";
        wait for 10 us;
        w_rule_enable <= '0';
        data_rule <= (others => '-');
        rule_number <= "---";
        wait;
    end process;

    -- simulation pour le wrappeur
    wrapper_process : process
        variable log_line : line; -- Variable for writing lines to the file
        variable test_resp : boolean;
    begin
        file_open(log_file, "test_bench.log", write_mode);
        wait for 30 us;
    -- TEST SUR LE CANAL D'ECRITURE
        ---------------------------------- TEST 1 et 2 " resp est 0 pendant 20 us (n'a pas le droit a executer) "
        MID_W <= "000";
        MID_R <= (others => '-');
        x_enable <= '1'; --RWX <= "011";    
        S_AXI_AWADDR <= "01100";
        wait for 20 us;
        test_resp := check_write_test('0', 1);

        ---------------------------------- TEST 3 " resp est 0 ( ID n'existe pas ) "
        MID_W <= "101";
        MID_R <= (others => '-');
        x_enable <= '0'; --RWX <= "010";
        S_AXI_AWADDR <= "01100";
        wait for 10 us;
        test_resp := check_write_test('0', 2);
        ---------------------------------- TEST 4 " resp est 1 "
        MID_W <= "000";
        MID_R <= (others => '-');
        x_enable <= '0'; --RWX <= "010";
        S_AXI_AWADDR <= "01100";
        wait for 10 us;
        test_resp := check_write_test('0', 3);
        ---------------------------------- TEST 5 " resp est 0 ( ecriture hors addresse )"
        MID_W <= "000";
        MID_R <= (others => '-');
        x_enable <= '0'; --RWX <= "010";
        S_AXI_AWADDR <= "11111";
        wait for 10 us;
-- TEST SUR LE CANAL DE LECTURE
        ---------------------------------- TEST 6 " resp est 0 ( RWX n'est pas compatible avec RWX de cette ID )"
        MID_W <= (others => '-');
        MID_R <= "100";
        x_enable <= '1'; --RWX <= "101";
        S_AXI_ARADDR <= "01100";
        wait for 10 us;
        ---------------------------------- TEST 7 " resp est 1 "
        MID_W <= (others => '-');
        MID_R <= "100";
        x_enable <= '0'; --RWX <= "100";
        S_AXI_ARADDR <= "01100";
        wait for 10 us;
        ---------------------------------- TEST 8 " resp est 1 "
        MID_W <= (others => '-');
        MID_R <= "001";
        x_enable <= '1'; --RWX <= "101";
        S_AXI_ARADDR <= "01100";
        wait for 10 us;
        
        ---------------------------------- TEST 9 " resp est 0 (LECTURE HORS ADDRESS) "
        MID_W <= (others => '-');
        MID_R <= "001";
        x_enable <= '1'; --RWX <= "101";
        S_AXI_ARADDR <= "11111";
        wait for 10 us;

        -- close file
        file_close(log_file);

        MID_W <= (others => '-');
        MID_R <= (others => '-');
        x_enable <= '-'; --RWX <= "101";
        S_AXI_ARADDR <= (others => '-');
        wait;
    end process;

end architecture;