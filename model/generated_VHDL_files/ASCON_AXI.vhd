library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ASCON_AXI is
	generic(
			C_AXI_WORLD_ID		: integer,
			C_AXI_WORLD_ID_WIDTH		: integer := 2,
			C_AXI_USER_ID		: integer := 3,
			C_AXI_USER_ID_WIDTH		: integer := 3,
			nb_id_system		: integer := 2,
			vector_perm_width		: integer := 8,
			C_S_AXI_ID_WIDTH		: integer := 1,
			C_S_AXI_DATA_WIDTH		: integer := 32,
			C_S_AXI_ADDR_WIDTH		: integer := 6,
			C_S_AXI_AWUSER_WIDTH		: integer := 0,
			C_S_AXI_ARUSER_WIDTH		: integer := 0,
			C_S_AXI_WUSER_WIDTH		: integer := 0,
			C_S_AXI_RUSER_WIDTH		: integer := 0,
			C_S_AXI_BUSER_WIDTH		: integer := 0
		);
	port(
			configure_enable		: in std_logic;
			configure_vector_permissions		: in std_logic_vector(vector_perm_width-1 downto 0);
			S_AXI_ACLK		: in std_logic;
			S_AXI_ARESETN		: in std_logic;
			S_AXI_AWID		: in std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
			S_AXI_AWADDR		: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
			S_AXI_AWLEN		: in std_logic_vector(7 downto 0);
			S_AXI_AWSIZE		: in std_logic_vector(2 downto 0);
			S_AXI_AWBURST		: in std_logic_vector(1 downto 0);
			S_AXI_AWLOCK		: in std_logic;
			S_AXI_AWCACHE		: in std_logic_vector(3 downto 0);
			S_AXI_AWPROT		: in std_logic_vector(2 downto 0);
			S_AXI_AWQOS		: in std_logic_vector(3 downto 0);
			S_AXI_AWREGION		: in std_logic_vector(3 downto 0);
			S_AXI_AWUSER		: in std_logic_vector(C_S_AXI_AWUSER_WIDTH-1 downto 0);
			S_AXI_AWVALID		: in std_logic;
			S_AXI_WDATA		: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
			S_AXI_WSTRB		: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
			S_AXI_WLAST		: in std_logic;
			S_AXI_WUSER		: in std_logic_vector(C_S_AXI_WUSER_WIDTH-1 downto 0);
			S_AXI_WVALID		: in std_logic;
			S_AXI_BREADY		: in std_logic;
			S_AXI_ARID		: in std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
			S_AXI_ARADDR		: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
			S_AXI_ARLEN		: in std_logic_vector(7 downto 0);
			S_AXI_ARSIZE		: in std_logic_vector(2 downto 0);
			S_AXI_ARBURST		: in std_logic_vector(1 downto 0);
			S_AXI_ARLOCK		: in std_logic;
			S_AXI_ARCACHE		: in std_logic_vector(3 downto 0);
			S_AXI_ARPROT		: in std_logic_vector(2 downto 0);
			S_AXI_ARQOS		: in std_logic_vector(3 downto 0);
			S_AXI_ARREGION		: in std_logic_vector(3 downto 0);
			S_AXI_ARUSER		: in std_logic_vector(C_S_AXI_ARUSER_WIDTH-1 downto 0);
			S_AXI_ARVALID		: in std_logic;
			S_AXI_RREADY		: in std_logic;
			S_AXI_AWREADY		: out std_logic;
			S_AXI_WREADY		: out std_logic;
			S_AXI_BID		: out std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
			S_AXI_BRESP		: out std_logic_vector(1 downto 0);
			S_AXI_BUSER		: out std_logic_vector(C_S_AXI_BUSER_WIDTH-1 downto 0);
			S_AXI_BVALID		: out std_logic;
			S_AXI_ARREADY		: out std_logic;
			S_AXI_RID		: out std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
			S_AXI_RDATA		: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
			S_AXI_RRESP		: out std_logic_vector(1 downto 0);
			S_AXI_RLAST		: out std_logic;
			S_AXI_RUSER		: out std_logic_vector(C_S_AXI_RUSER_WIDTH-1 downto 0);
			S_AXI_RVALID		: out std_logic
		);
end ASCON_AXI;

architecture ASCON_AXI_arch of ASCON_AXI is
	attribute dont_touch : string;
	attribute dont_touch of ASCON_AXI_arch : architecture is "yes";
	component core_interface is
		generic(
			NBITS		: integer := 736,
			WID		: integer := 32
		);
		port(
			clk_i		: in std_logic;
			rst_i		: in std_logic;
			ctr_i		: in std_logic_vector(22 downto 0);
			inputs		: in std_logic_vector(31 downto 0);
			outputs		: out std_logic_vector(31 downto 0)
		);
	end component;
	signal data_in		: std_logic_vector(31 downto 0);	signal data_out		: std_logic_vector(31 downto 0);	signal ctr_i		: std_logic_vector(22 downto 0);	signal axi_awaddr		: std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
	signal axi_awready		: std_logic;
	signal axi_wready		: std_logic;
	signal axi_bresp		: std_logic_vector(1 downto 0);
	signal axi_buser		: std_logic_vector(C_S_AXI_BUSER_WIDTH-1 downto 0);
	signal axi_bvalid		: std_logic;
	signal axi_araddr		: std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
	signal axi_arready		: std_logic;
	signal axi_rdata		: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal axi_rresp		: std_logic_vector(1 downto 0);
	signal axi_rlast		: std_logic;
	signal axi_ruser		: std_logic_vector(C_S_AXI_RUSER_WIDTH-1 downto 0);
	signal axi_rvalid		: std_logic;
	signal  aw_wrap_en 		: std_logic;
	signal  ar_wrap_en 		: std_logic;
	signal aw_wrap_size		: integer;
	signal ar_wrap_size		: integer;
	signal axi_awv_awr_flag		: std_logic;
	signal axi_arv_arr_flag		: std_logic;
	signal axi_awlen_cntr		: std_logic_vector(7 downto 0);
	signal axi_arlen_cntr		: std_logic_vector(7 downto 0);
	signal axi_arburst		: std_logic_vector(1 downto 0);
	signal axi_awburst		: std_logic_vector(1 downto 0);
	signal axi_arlen		: std_logic_vector(7 downto 0);
	signal axi_awlen		: std_logic_vector(7 downto 0);
	signal slv_reg1		: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg0		: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg2		: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg3		: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg4		: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg5		: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg6		: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg7		: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg8		: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg9		: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg10		: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg11		: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg12		: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg13		: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg14		: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg15		: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg_rden		:  std_logic;
	signal slv_reg_wren		:  std_logic;
	signal reg_data_out		: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal byte_index 		: integer;
	signal aw_en		: std_logic;
	constant ADDR_LSB		: integer := (C_S_AXI_DATA_WIDTH/32)+ 1;
	constant OPT_MEM_ADDR_BITS		: integer := 3;
	constant USER_NUM_MEM		: integer := 1;
	constant low		: std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0) := "000000";
    constant width_part : integer := nb_id_system *2;
    signal indice_w       : integer range 0 to 25000:= 0;
    signal indice_r       : integer range 0 to 25000:= 0;
    signal r_w_r		: std_logic;    
    signal w_r_w		: std_logic;
    constant configure_vector_permissions_i : std_logic_vector(vector_perm_width-1 downto 0):=X"01";
begin
    
    S_AXI_AWREADY	<= axi_awready;
	S_AXI_WREADY	<= axi_wready;
	S_AXI_BRESP	<= axi_bresp;
	S_AXI_BUSER	<= std_logic_vector(to_unsigned(C_AXI_USER_ID, C_AXI_USER_ID_WIDTH))& std_logic_vector(to_unsigned(C_AXI_WORLD_ID, C_AXI_WORLD_ID_WIDTH));
	S_AXI_BVALID	<= axi_bvalid;
	S_AXI_ARREADY	<= axi_arready;
	S_AXI_RDATA	<= axi_rdata;
	S_AXI_RRESP	<= axi_rresp;
	S_AXI_RLAST	<= axi_rlast;
	S_AXI_RUSER	<= std_logic_vector(to_unsigned(C_AXI_USER_ID, C_AXI_USER_ID_WIDTH))& std_logic_vector(to_unsigned(C_AXI_WORLD_ID, C_AXI_WORLD_ID_WIDTH));
	S_AXI_RVALID	<= axi_rvalid;
	S_AXI_BID <= S_AXI_AWID;
	S_AXI_RID <= S_AXI_ARID;
	aw_wrap_size <= ((C_S_AXI_DATA_WIDTH)/8 * to_integer(unsigned(axi_awlen))); 
	ar_wrap_size <= ((C_S_AXI_DATA_WIDTH)/8 * to_integer(unsigned(axi_arlen))); 
	aw_wrap_en <= '1' when (((axi_awaddr AND std_logic_vector(to_unsigned(aw_wrap_size,C_S_AXI_ADDR_WIDTH))) XOR std_logic_vector(to_unsigned(aw_wrap_size,C_S_AXI_ADDR_WIDTH))) = low) else '0';
	ar_wrap_en <= '1' when (((axi_araddr AND std_logic_vector(to_unsigned(ar_wrap_size,C_S_AXI_ADDR_WIDTH))) XOR std_logic_vector(to_unsigned(ar_wrap_size,C_S_AXI_ADDR_WIDTH))) = low) else '0';

    -- perm_table_config process
	perm_table_config : process (S_AXI_ACLK)
	begin
       if rising_edge(S_AXI_ACLK) then 
	       if (configure_enable = '1') then
	           configure_vector_permissions_i <= configure_vector_permissions;  
	       else 
	           configure_vector_permissions_i <= configure_vector_permissions_i;
	       end if;
	    end if;
	end process;

	 -- process
	process(S_AXI_AWADDR,configure_enable,configure_vector_permissions,S_AXI_AWUSER)
	begin
       indice_w <= width_part * to_integer(unsigned(S_AXI_AWUSER(C_AXI_WORLD_ID_WIDTH - 1 DOWNTO 0))) +2*(to_integer(unsigned(S_AXI_AWUSER((C_AXI_USER_ID_WIDTH + C_AXI_WORLD_ID_WIDTH - 1) DOWNTO C_AXI_WORLD_ID_WIDTH)))-1);
	end process;

	w_r_w <= configure_vector_permissions_i(indice_w) when (indice_w >=0) else '0';

	 -- process
	process(S_AXI_ARADDR,configure_enable,configure_vector_permissions,S_AXI_ARUSER)
	begin
       indice_r <= width_part * to_integer(unsigned(S_AXI_ARUSER(C_AXI_WORLD_ID_WIDTH - 1 DOWNTO 0)))+2*(to_integer(unsigned(S_AXI_ARUSER((C_AXI_USER_ID_WIDTH + C_AXI_WORLD_ID_WIDTH - 1) DOWNTO C_AXI_WORLD_ID_WIDTH)))-1)+1;
	end process;

	r_w_r <= configure_vector_permissions_i(indice_r) when (indice_r >=0) else '0';

	 -- process
	process(S_AXI_ACLK)
	begin
       if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_awready <= '0';
	      axi_awv_awr_flag <= '0';
	    else
	      if (axi_awready = '0' and S_AXI_AWVALID = '1' and axi_awv_awr_flag = '0' and axi_arv_arr_flag = '0') then
	        -- slave is ready to accept an address and
	        -- associated control signals
	        axi_awv_awr_flag  <= '1'; -- used for generation of bresp() and bvalid
	        axi_awready <= '1';
	      elsif (S_AXI_WLAST = '1' and axi_wready = '1') then 
	      -- preparing to accept next address after current write burst tx completion
	        axi_awv_awr_flag  <= '0';
	      else
	        axi_awready <= '0';
	      end if;
	    end if;
	  end if;  
	end process;

	 -- process
	process(S_AXI_ACLK)
	begin
       if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_awaddr <= (others => '0');
	      axi_awburst <= (others => '0'); 
	      axi_awlen <= (others => '0'); 
	      axi_awlen_cntr <= (others => '0');
	    else
	      if (axi_awready = '0' and S_AXI_AWVALID = '1' and axi_awv_awr_flag = '0') then
	      -- address latching 
	        axi_awaddr <= S_AXI_AWADDR(C_S_AXI_ADDR_WIDTH - 1 downto 0);  ---- start address of transfer
	        axi_awlen_cntr <= (others => '0');
	        axi_awburst <= S_AXI_AWBURST;
	        axi_awlen <= S_AXI_AWLEN;
	      elsif((axi_awlen_cntr <= axi_awlen) and axi_wready = '1' and S_AXI_WVALID = '1') then     
	        axi_awlen_cntr <= std_logic_vector (unsigned(axi_awlen_cntr) + 1);

	        case (axi_awburst) is
	          when "00" => -- fixed burst
	            -- The write address for all the beats in the transaction are fixed
	            axi_awaddr     <= axi_awaddr;       ----for awsize = 4 bytes (010)
	          when "01" => --incremental burst
	            -- The write address for all the beats in the transaction are increments by awsize
	            axi_awaddr(C_S_AXI_ADDR_WIDTH - 1 downto ADDR_LSB) <= std_logic_vector (unsigned(axi_awaddr(C_S_AXI_ADDR_WIDTH - 1 downto ADDR_LSB)) + 1);--awaddr aligned to 4 byte boundary
	            axi_awaddr(ADDR_LSB-1 downto 0)  <= (others => '0');  ----for awsize = 4 bytes (010)
	          when "10" => --Wrapping burst
	            -- The write address wraps when the address reaches wrap boundary 
	            if (aw_wrap_en = '1') then
	              axi_awaddr <= std_logic_vector (unsigned(axi_awaddr) - (to_unsigned(aw_wrap_size,C_S_AXI_ADDR_WIDTH)));                
	            else 
	              axi_awaddr(C_S_AXI_ADDR_WIDTH - 1 downto ADDR_LSB) <= std_logic_vector (unsigned(axi_awaddr(C_S_AXI_ADDR_WIDTH - 1 downto ADDR_LSB)) + 1);--awaddr aligned to 4 byte boundary
	              axi_awaddr(ADDR_LSB-1 downto 0)  <= (others => '0');  ----for awsize = 4 bytes (010)
	            end if;
	          when others => --reserved (incremental burst for example)
	            axi_awaddr(C_S_AXI_ADDR_WIDTH - 1 downto ADDR_LSB) <= std_logic_vector (unsigned(axi_awaddr(C_S_AXI_ADDR_WIDTH - 1 downto ADDR_LSB)) + 1);--for awsize = 4 bytes (010)
	            axi_awaddr(ADDR_LSB-1 downto 0)  <= (others => '0');
	        end case;        
	      end if;
	    end if;
	  end if;
	end process;

	 -- process
	process(S_AXI_ACLK)
	begin
        if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_wready <= '0';
	    else
	      if (axi_wready = '0' and S_AXI_WVALID = '1' and axi_awv_awr_flag = '1') then
	        axi_wready <= '1';
	        -- elsif (axi_awv_awr_flag = '0') then
	      elsif (S_AXI_WLAST = '1' and axi_wready = '1') then 

	        axi_wready <= '0';
	      end if;
	    end if;
	  end if;
	end process;

	slv_reg_wren <= axi_wready and S_AXI_WVALID ;

	 -- process
	process(S_AXI_ACLK)
		variable loc_addr		: std_logic_vector(OPT_MEM_ADDR_BITS-1 downto 0);
	begin
       if rising_edge(S_AXI_ACLK) then
			if S_AXI_ARESETN = '0' then
				slv_reg0 <= (others => '0');
				slv_reg1 <= (others => '0');
				slv_reg2 <= (others => '0');
				slv_reg3 <= (others => '0');
				slv_reg4 <= (others => '0');
				slv_reg5 <= (others => '0');
				slv_reg6 <= (others => '0');
				slv_reg7 <= (others => '0');
				slv_reg8 <= (others => '0');
				slv_reg9 <= (others => '0');
				slv_reg10 <= (others => '0');
				slv_reg11 <= (others => '0');
			else
				loc_addr := axi_awaddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
				if (slv_reg_wren = '1' and w_r_w = '1') then
				case loc_addr is
						when b"0000" =>			
						for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then	
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 0
									slv_reg0(byte_index * 8 + 7 downto byte_index * 8)<= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
						end loop;
						when b"0001" =>
						for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then	
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 1
									slv_reg1(byte_index * 8 + 7 downto byte_index * 8)<= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
						end loop;
						when b"0010" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 2
									slv_reg2(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0011" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 3
									slv_reg3(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0100" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 4
									slv_reg4(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0101" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 5
									slv_reg5(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0110" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 6
									slv_reg6(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"0111" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 7
									slv_reg7(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1000" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 8
									slv_reg8(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1001" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 9
									slv_reg9(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1010" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 10
									slv_reg10(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when b"1011" =>
							for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
								if (S_AXI_WSTRB(byte_index) = '1') then
									-- Respective byte enables are asserted as per write strobes                   
									-- slave registor 11
									slv_reg11(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
								end if;
							end loop;
						when others =>
							slv_reg0 <= slv_reg0;
							slv_reg1 <= slv_reg1;
							slv_reg2 <= slv_reg2;
							slv_reg3 <= slv_reg3;
							slv_reg4 <= slv_reg4;
							slv_reg5 <= slv_reg5;
							slv_reg6 <= slv_reg6;
							slv_reg7 <= slv_reg7;
							slv_reg8 <= slv_reg8;
							slv_reg9 <= slv_reg9;
							slv_reg10 <= slv_reg10;
							slv_reg11 <= slv_reg11;
					end case;
				end if;
			end if;
		end if;
	end process;

	 -- process
	process(S_AXI_ACLK)
	begin
       if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_bvalid  <= '0';
	      axi_bresp  <= "00"; --need to work more on the responses
	    else
	      if (axi_awv_awr_flag = '1' and axi_wready = '1' and S_AXI_WVALID = '1' and axi_bvalid = '0' and S_AXI_WLAST = '1' ) then
	        axi_bvalid <= '1';
	        if (w_r_w = '1') then
	           axi_bresp  <= "00"; 
	        else 
	           axi_bresp <= "10";
	        end if;
	      elsif (S_AXI_BREADY = '1' and axi_bvalid = '1') then  
	      --check if bready is asserted while bvalid is high)
	        axi_bvalid <= '0';                      
	      end if;
	    end if;
	  end if;
	end process;

	 -- process
	process(S_AXI_ACLK)
	begin
       if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_arready <= '0';
	      axi_arv_arr_flag <= '0';
	    else
	      if (axi_arready = '0' and S_AXI_ARVALID = '1' and axi_awv_awr_flag = '0' and axi_arv_arr_flag = '0') then
	        axi_arready <= '1';
	        axi_arv_arr_flag <= '1';
	      elsif (axi_rvalid = '1' and S_AXI_RREADY = '1' and (axi_arlen_cntr = axi_arlen)) then 
	      -- preparing to accept next address after current read completion
	        axi_arv_arr_flag <= '0';
	      else
	        axi_arready <= '0';
	      end if;
	    end if;
	  end if;
	end process;

	 -- process
	process(S_AXI_ACLK)
	begin
       if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_araddr <= (others => '0');
	      axi_arburst <= (others => '0');
	      axi_arlen <= (others => '0'); 
	      axi_arlen_cntr <= (others => '0');
	      axi_rlast <= '0';
	    else
	      if (axi_arready = '0' and S_AXI_ARVALID = '1' and axi_arv_arr_flag = '0') then
	        -- address latching 
	        axi_araddr <= S_AXI_ARADDR(C_S_AXI_ADDR_WIDTH - 1 downto 0); ---- start address of transfer
	        axi_arlen_cntr <= (others => '0');
	        axi_rlast <= '0';
	        axi_arburst <= S_AXI_ARBURST;
	        axi_arlen <= S_AXI_ARLEN;
	      elsif((axi_arlen_cntr <= axi_arlen) and axi_rvalid = '1' and S_AXI_RREADY = '1') then     
	        axi_arlen_cntr <= std_logic_vector (unsigned(axi_arlen_cntr) + 1);
	        axi_rlast <= '0';      
	     
	        case (axi_arburst) is
	          when "00" =>  -- fixed burst
	            -- The read address for all the beats in the transaction are fixed
	            axi_araddr     <= axi_araddr;      ----for arsize = 4 bytes (010)
	          when "01" =>  --incremental burst
	            -- The read address for all the beats in the transaction are increments by awsize
	            axi_araddr(C_S_AXI_ADDR_WIDTH - 1 downto ADDR_LSB) <= std_logic_vector (unsigned(axi_araddr(C_S_AXI_ADDR_WIDTH - 1 downto ADDR_LSB)) + 1); --araddr aligned to 4 byte boundary
	            axi_araddr(ADDR_LSB-1 downto 0)  <= (others => '0');  ----for awsize = 4 bytes (010)
	          when "10" =>  --Wrapping burst
	            -- The read address wraps when the address reaches wrap boundary 
	            if (ar_wrap_en = '1') then   
	              axi_araddr <= std_logic_vector (unsigned(axi_araddr) - (to_unsigned(ar_wrap_size,C_S_AXI_ADDR_WIDTH)));
	            else 
	              axi_araddr(C_S_AXI_ADDR_WIDTH - 1 downto ADDR_LSB) <= std_logic_vector (unsigned(axi_araddr(C_S_AXI_ADDR_WIDTH - 1 downto ADDR_LSB)) + 1); --araddr aligned to 4 byte boundary
	              axi_araddr(ADDR_LSB-1 downto 0)  <= (others => '0');  ----for awsize = 4 bytes (010)
	            end if;
	          when others => --reserved (incremental burst for example)
	            axi_araddr(C_S_AXI_ADDR_WIDTH - 1 downto ADDR_LSB) <= std_logic_vector (unsigned(axi_araddr(C_S_AXI_ADDR_WIDTH - 1 downto ADDR_LSB)) + 1);--for arsize = 4 bytes (010)
			  axi_araddr(ADDR_LSB-1 downto 0)  <= (others => '0');
	        end case;         
	      elsif((axi_arlen_cntr = axi_arlen) and axi_rlast = '0' and axi_arv_arr_flag = '1') then  
	        axi_rlast <= '1';
	      elsif (S_AXI_RREADY = '1') then  
	        axi_rlast <= '0';
	      end if;
	    end if;
	  end if;
	end process;

	 -- process
	process(S_AXI_ACLK)
	begin
       if rising_edge(S_AXI_ACLK) then
	    if S_AXI_ARESETN = '0' then
	      axi_rvalid <= '0';
	      axi_rresp  <= "00";
	    else
	      if (axi_arv_arr_flag = '1' and axi_rvalid = '0') then
	        axi_rvalid <= '1';
	        if (r_w_r = '1') then
	           axi_rresp  <= "00"; -- 'OKAY' response
	        else 
	           axi_rresp <= "10"; -- "SLVERR" error
	        end if;
	      elsif (axi_rvalid = '1' and S_AXI_RREADY = '1') then
	        axi_rvalid <= '0';
	      end  if;      
	    end if;
	  end if;
	end process;

	slv_reg_rden <= axi_rvalid and S_AXI_RREADY;
	 -- process
	process(slv_reg0,slv_reg1,slv_reg2,slv_reg3,slv_reg4,slv_reg5,slv_reg6,slv_reg7,slv_reg8,slv_reg9,slv_reg10,slv_reg11,slv_reg12,slv_reg13,slv_reg14,slv_reg15,data_out,axi_araddr,S_AXI_ARESETN,slv_reg_rden)
		variable loc_reg0		: std_logic_vector(OPT_MEM_ADDR_BITS+1-1 downto 0);
	begin
       if rising_edge(S_AXI_ACLK) then
	    if S_AXI_ARESETN = '0' then
	      axi_rvalid <= '0';
	      axi_rresp  <= "00";
	    else
	      if (axi_arv_arr_flag = '1' and axi_rvalid = '0') then
	        axi_rvalid <= '1';
	        if (r_w_r = '1') then
	           axi_rresp  <= "00"; -- 'OKAY' response
	        else 
	           axi_rresp <= "10"; -- "SLVERR" error
	        end if;
	      elsif (axi_rvalid = '1' and S_AXI_RREADY = '1') then
	        axi_rvalid <= '0';
	      end  if;      
	    end if;
	  end if;
	end process;

	 -- process
	process(S_AXI_ACLK)
	begin
       if (rising_edge (S_AXI_ACLK)) then
			if (S_AXI_ARESETN = '0') then
				axi_rdata <= (others => '0');
			else
				if (slv_reg_rden = '1' or (axi_arv_arr_flag = '1' and axi_rvalid = '0')) then
					-- When there is a valid read address (S_AXI_ARVALID) with 
					-- acceptance of read address by the slave (axi_arready), 
					-- output the read dada 
					-- Read address mux
					if (r_w_r = '1')then
			           axi_rdata <= reg_data_out; -- register read data
					else
					   axi_rdata <= (OTHERS => '0');
					end if;
				end if;
			end if;
		end if;
	end process;

	data_in <= slv_reg0;

	ctr_i   <= slv_reg1(22 downto 0);
end ASCON_AXI_arch;
