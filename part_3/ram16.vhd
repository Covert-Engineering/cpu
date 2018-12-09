library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity ram16 is

  port (
    clk      : in  std_logic;
    we       : in  std_logic;
    addr     : in  std_logic_vector(15 downto 0);
    data_in  : in  std_logic_vector(15 downto 0);
    data_out : out std_logic_vector(15 downto 0)
    );
end entity ram16;

architecture rtl of ram16 is

  type store_t is array (0 to 31) of std_logic_vector(15 downto 0);
  signal ram_16 : store_t := (others => X"0000");

begin  -- architecture rtl

  -- purpose: temperary ram block before using external ram
  -- type   : sequential
  -- inputs : clk, rst
  -- outputs: data_out
  ram_i : process (clk) is
  begin  -- process ram_i
    if (rising_edge(clk)) then          -- rising clock edge
      if (we = '1') then
        ram_16(to_integer(unsigned(addr(5 downto 0)))) <= data_in;
      else
        data_out <= ram_16(to_integer(unsigned(addr(5 downto 0))));
      end if;
    end if;
  end process ram_i;
end architecture rtl;
