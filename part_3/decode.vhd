library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity decode is

  port (
    clk       : in  std_logic;
    data_inst : in  std_logic_vector(15 downto 0);
    en        : in  std_logic;
    sel_a     : out std_logic_vector(2 downto 0);
    sel_b     : out std_logic_vector(2 downto 0);
    sel_d     : out std_logic_vector(2 downto 0);
    data_imm  : out std_logic_vector(15 downto 0);
    reg_dwe   : out std_logic;
    alu_op    : out std_logic_vector(4 downto 0));

end entity decode;

architecture rtl of decode is

begin  -- architecture rtl

  process(clk)
    if rising_edge(clk) and en = '1' then

      sel_a     <= data_inst(7 downto 5);
      sel_b     <= data_inst(4 downto 2);
      sel_d     <= data_inst(11 downto 9);
      daata_imm <= data_inst(7 downto 0) & data_inst(7 downto 0);
      alu_op    <= data_inst(15 downto 12) & data_inst(8);

      case data_inst(15 downto 12) is
        when "0111" =>
          reg_dwe <= '0';
        when "1100" =>
          reg_dwe <= '0';
        when "1101" =>
          reg_dwe <= '0';
        when others =>
          reg_dwe <= '1';
      end case;

    end if;
  end process;
end architecture rtl;
