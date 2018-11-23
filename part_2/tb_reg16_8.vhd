library IEEE;
use IEEE.std_logic_1164.all;

entity tb_reg16_8 is
end entity tb_reg16_8;

architecture behav of tb_reg16_8 is

  component reg16_8 is
    port (
      clk    : in  std_logic;
      en     : in  std_logic;
      data_d : in  std_logic_vector(15 downto 0);
      data_a : out std_logic_vector(15 downto 0);
      data_b : out std_logic_vector(15 downto 0);
      sel_a  : in  std_logic_vector(2 downto 0);
      sel_b  : in  std_logic_vector(2 downto 0);
      sel_d  : in  std_logic_vector(2 downto 0);
      we     : in  std_logic);
  end component reg16_8;

  signal clk    : std_logic                     := '0';
  signal en     : std_logic                     := '0';
  signal data_d : std_logic_vector(15 downto 0) := (others => '0');
  signal sel_a  : std_logic_vector(2 downto 0)  := (others => '0');
  signal sel_b  : std_logic_vector(2 downto 0)  := (others => '0');
  signal sel_d  : std_logic_vector(2 downto 0)  := (others => '0');
  signal we     : std_logic                     := '0';

  signal data_a : std_logic_vector(15 downto 0);
  signal data_b : std_logic_vector(15 downto 0);

  constant CLK_PERIOD : time := 10 ns;

begin

  uut : reg16_8 port map (
    clk    => clk,
    en     => en,
    data_d => data_d,
    data_a => data_a,
    data_b => data_b,
    sel_a  => sel_a,
    sel_b  => sel_b,
    sel_d  => sel_d,
    we     => we
    );

  clk_process : process
  begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process;

  stimulate : process
  begin
    wait for 100 ns;
    wait for clk_period*10;

    en <= '1';

    -- test for writing.
    -- r0 = 0xfab5
    sel_a  <= "000";
    sel_b  <= "001";
    sel_d  <= "000";
    data_d <= X"FAB5";
    we     <= '1';
    wait for clk_period;

    -- r2 = 0x2222
    sel_a  <= "000";
    sel_b  <= "001";
    sel_d  <= "010";
    data_d <= X"2222";
    we     <= '1';
    wait for clk_period;

    -- r3 = 0x3333
    sel_a  <= "000";
    sel_b  <= "001";
    sel_d  <= "010";
    data_d <= X"3333";
    we     <= '1';
    wait for clk_period;

    --test just reading, with no write
    sel_a  <= "000";
    sel_b  <= "001";
    sel_d  <= "000";
    data_d <= X"FEED";
    we     <= '0';
    wait for clk_period;

    --at this point dataA should not be 'feed'

    sel_a <= "001";
    sel_b <= "010";
    wait for clk_period;

    sel_a <= "011";
    sel_b <= "100";
    wait for clk_period;

    sel_a  <= "000";
    sel_b  <= "001";
    sel_d  <= "100";
    data_d <= X"4444";
    we     <= '1';
    wait for clk_period;

    we <= '0';
    wait for clk_period;

    -- nop
    wait for clk_period;

    sel_a <= "100";
    sel_b <= "100";
    wait for clk_period;

    assert false report "Sim Finished" severity failure;
  end process;
end architecture behav;
