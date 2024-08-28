library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ASCON is
	generic(
			C_AXI_WORLD_ID		: integer,
			C_AXI_WORLD_ID_WIDTH		: integer := 2,
			C_AXI_USER_ID		: integer := 3,
			C_AXI_USER_ID_WIDTH		: integer := 3,
			nb_id_system		: integer := 2,
			vector_perm_width		: integer := 8,
			C_S00_AXI_ID_WIDTH		: integer := 1,
			C_S00_AXI_DATA_WIDTH		: integer := 32,
			C_S00_AXI_ADDR_WIDTH		: integer := 6,
			C_S00_AXI_AWUSER_WIDTH		: integer := 0,
			C_S00_AXI_ARUSER_WIDTH		: integer := 0,
			C_S00_AXI_WUSER_WIDTH		: integer := 0,
			C_S00_AXI_RUSER_WIDTH		: integer := 0,
			C_S00_AXI_BUSER_WIDTH		: integer := 0
		);
	port(
			configure_enable		: in std_logic;
			configure_vector_permissions		: in std_logic_vector(vector_perm_width-1 downto 0);
			s00_axi_aclk		: in std_logic;
			s00_axi_aresetn		: in std_logic;
			s00_axi_awid		: in std_logic_vector(C_S00_AXI_ID_WIDTH-1 downto 0);
			s00_axi_awaddr		: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
			s00_axi_awlen		: in std_logic_vector(7 downto 0);
			s00_axi_awsize		: in std_logic_vector(2 downto 0);
			s00_axi_awburst		: in std_logic_vector(1 downto 0);
			s00_axi_awlock		: in std_logic;
			s00_axi_awcache		: in std_logic_vector(3 downto 0);
			s00_axi_awprot		: in std_logic_vector(2 downto 0);
			s00_axi_awqos		: in std_logic_vector(3 downto 0);
			s00_axi_awregion		: in std_logic_vector(3 downto 0);
			s00_axi_awuser		: in std_logic_vector(C_S00_AXI_AWUSER_WIDTH-1 downto 0);
			s00_axi_awvalid		: in std_logic;
			s00_axi_wdata		: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
			s00_axi_wstrb		: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
			s00_axi_wlast		: in std_logic;
			s00_axi_wuser		: in std_logic_vector(C_S00_AXI_WUSER_WIDTH-1 downto 0);
			s00_axi_wvalid		: in std_logic;
			s00_axi_bready		: in std_logic;
			s00_axi_arid		: in std_logic_vector(C_S00_AXI_ID_WIDTH-1 downto 0);
			s00_axi_araddr		: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
			s00_axi_arlen		: in std_logic_vector(7 downto 0);
			s00_axi_arsize		: in std_logic_vector(2 downto 0);
			s00_axi_arburst		: in std_logic_vector(1 downto 0);
			s00_axi_arlock		: in std_logic;
			s00_axi_arcache		: in std_logic_vector(3 downto 0);
			s00_axi_arprot		: in std_logic_vector(2 downto 0);
			s00_axi_arqos		: in std_logic_vector(3 downto 0);
			s00_axi_arregion		: in std_logic_vector(3 downto 0);
			s00_axi_aruser		: in std_logic_vector(C_S00_AXI_ARUSER_WIDTH-1 downto 0);
			s00_axi_arvalid		: in std_logic;
			s00_axi_rready		: in std_logic;
			s00_axi_awready		: out std_logic;
			s00_axi_wready		: out std_logic;
			s00_axi_bid		: out std_logic_vector(C_S00_AXI_ID_WIDTH-1 downto 0);
			s00_axi_bresp		: out std_logic_vector(1 downto 0);
			s00_axi_buser		: out std_logic_vector(C_S00_AXI_BUSER_WIDTH-1 downto 0);
			s00_axi_bvalid		: out std_logic;
			s00_axi_arready		: out std_logic;
			s00_axi_rid		: out std_logic_vector(C_S00_AXI_ID_WIDTH-1 downto 0);
			s00_axi_rdata		: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
			s00_axi_rresp		: out std_logic_vector(1 downto 0);
			s00_axi_rlast		: out std_logic;
			s00_axi_ruser		: out std_logic_vector(C_S00_AXI_RUSER_WIDTH-1 downto 0);
			s00_axi_rvalid		: out std_logic
		);
end ASCON;

architecture ASCON_arch of ASCON is
	component ASCON_AXI is
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
	end component;
begin
	ASCON_inst : ASCON_AXI
		generic map (
			C_AXI_WORLD_ID => C_AXI_WORLD_ID,
			C_AXI_WORLD_ID_WIDTH => C_AXI_WORLD_ID_WIDTH,
			C_AXI_USER_ID => C_AXI_USER_ID,
			C_AXI_USER_ID_WIDTH => C_AXI_USER_ID_WIDTH,
			nb_id_system => nb_id_system,
			vector_perm_width => vector_perm_width,
			C_S_AXI_ID_WIDTH => C_S00_AXI_ID_WIDTH,
			C_S_AXI_DATA_WIDTH => C_S00_AXI_DATA_WIDTH,
			C_S_AXI_ADDR_WIDTH => C_S00_AXI_ADDR_WIDTH,
			C_S_AXI_AWUSER_WIDTH => C_S00_AXI_AWUSER_WIDTH,
			C_S_AXI_ARUSER_WIDTH => C_S00_AXI_ARUSER_WIDTH,
			C_S_AXI_WUSER_WIDTH => C_S00_AXI_WUSER_WIDTH,
			C_S_AXI_RUSER_WIDTH => C_S00_AXI_RUSER_WIDTH,
			C_S_AXI_BUSER_WIDTH => C_S00_AXI_BUSER_WIDTH
		)
		port map (
			configure_enable => configure_enable,
			configure_vector_permissions => configure_vector_permissions,
			S_AXI_ACLK => s00_axi_aclk,
			S_AXI_ARESETN => s00_axi_aresetn,
			S_AXI_AWID => s00_axi_awid,
			S_AXI_AWADDR => s00_axi_awaddr,
			S_AXI_AWLEN => s00_axi_awlen,
			S_AXI_AWSIZE => s00_axi_awsize,
			S_AXI_AWBURST => s00_axi_awburst,
			S_AXI_AWLOCK => s00_axi_awlock,
			S_AXI_AWCACHE => s00_axi_awcache,
			S_AXI_AWPROT => s00_axi_awprot,
			S_AXI_AWQOS => s00_axi_awqos,
			S_AXI_AWREGION => s00_axi_awregion,
			S_AXI_AWUSER => s00_axi_awuser,
			S_AXI_AWVALID => s00_axi_awvalid,
			S_AXI_WDATA => s00_axi_wdata,
			S_AXI_WSTRB => s00_axi_wstrb,
			S_AXI_WLAST => s00_axi_wlast,
			S_AXI_WUSER => s00_axi_wuser,
			S_AXI_WVALID => s00_axi_wvalid,
			S_AXI_BREADY => s00_axi_bready,
			S_AXI_ARID => s00_axi_arid,
			S_AXI_ARADDR => s00_axi_araddr,
			S_AXI_ARLEN => s00_axi_arlen,
			S_AXI_ARSIZE => s00_axi_arsize,
			S_AXI_ARBURST => s00_axi_arburst,
			S_AXI_ARLOCK => s00_axi_arlock,
			S_AXI_ARCACHE => s00_axi_arcache,
			S_AXI_ARPROT => s00_axi_arprot,
			S_AXI_ARQOS => s00_axi_arqos,
			S_AXI_ARREGION => s00_axi_arregion,
			S_AXI_ARUSER => s00_axi_aruser,
			S_AXI_ARVALID => s00_axi_arvalid,
			S_AXI_RREADY => s00_axi_rready,
			S_AXI_AWREADY => s00_axi_awready,
			S_AXI_WREADY => s00_axi_wready,
			S_AXI_BID => s00_axi_bid,
			S_AXI_BRESP => s00_axi_bresp,
			S_AXI_BUSER => s00_axi_buser,
			S_AXI_BVALID => s00_axi_bvalid,
			S_AXI_ARREADY => s00_axi_arready,
			S_AXI_RID => s00_axi_rid,
			S_AXI_RDATA => s00_axi_rdata,
			S_AXI_RRESP => s00_axi_rresp,
			S_AXI_RLAST => s00_axi_rlast,
			S_AXI_RUSER => s00_axi_ruser,
			S_AXI_RVALID => s00_axi_rvalid
		);
end ASCON_arch;
