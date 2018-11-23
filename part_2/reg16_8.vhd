library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity reg16_8 is

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
end entity reg16_8;

architecture rtl of reg16_8 is

  type store_t is array (0 to 7) of std_logic_vector(15 downto 0);
  signal regs : store_t := (others => X"0000");

begin

  process (clk) is
  begin

    if rising_edge(clk) and en = '1' then
      data_a <= regs(to_integer(unsigned(sel_a)));
      data_b <= regs(to_integer(unsigned(sel_b)));
      if we = '1' then
        regs(to_integer(unsigned(sel_d))) <= data_d;
      end if;
    end if;
  end process;
end architecture rtl;
