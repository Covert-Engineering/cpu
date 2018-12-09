library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library work;
use work.tpu_constants.all;

entity alu is port (
  clk            : in  std_logic;
  en             : in  std_logic;
  data_a         : in  std_logic_vector (15 downto 0);
  data_b         : in  std_logic_vector (15 downto 0);
  data_d_we      : in  std_logic;
  aluop          : in  std_logic_vector (4 downto 0);
  pc             : in  std_logic_vector (15 downto 0);
  data_imm       : in  std_logic_vector (15 downto 0);
  data_result    : out std_logic_vector (15 downto 0);
  data_write_reg : out std_logic;
  should_branch  : out std_logic
  );
end alu;

architecture Behavioral of alu is

  -- The internal register for results of operations.
  -- 16 bit + carry/overflow
  signal s_result       : std_logic_vector(17 downto 0) := (others => '0');
  signal s_shouldBranch : std_logic                     := '0';

begin
  process (clk, en)
  begin
    if rising_edge(clk) and en = '1' then
      data_write_reg <= data_d_we;
      case aluop(4 downto 1) is

        when OPCODE_ADD =>
          if aluop(0) = '0' then
            s_result(16 downto 0) <= std_logic_vector(unsigned('0' & data_a) + unsigned('0' & data_b));
          else
            s_result(16 downto 0) <= std_logic_vector(signed(data_a(15) & data_a) + signed(data_b(15) & I_dataB));
          end if;
          s_shouldBranch <= '0';

        when OPCODE_OR =>
          s_result(15 downto 0) <= data_a or data_b;
          s_shouldBranch        <= '0';

        when OPCODE_LOAD =>
          if aluop(0) = '0' then
            s_result(15 downto 0) <= data_imm(7 downto 0) & X"00";
          else
            s_result(15 downto 0) <= X"00" & data_imm(7 downto 0);
          end if;
          s_shouldBranch <= '0';

        when OPCODE_CMP =>
          if data_a = data_b then
            s_result(CMP_BIT_EQ) <= '1';
          else
            s_result(CMP_BIT_EQ) <= '0';
          end if;

          if data_a = X"0000" then
            s_result(CMP_BIT_AZ) <= '1';
          else
            s_result(CMP_BIT_AZ) <= '0';
          end if;

          if data_b = X"0000" then
            s_result(CMP_BIT_BZ) <= '1';
          else
            s_result(CMP_BIT_BZ) <= '0';
          end if;

          if aluop(0) = '0' then
            if unsigned(data_a) > unsigned(data_b) then
              s_result(CMP_BIT_AGB) <= '1';
            else
              s_result(CMP_BIT_AGB) <= '0';
            end if;
            if unsigned(data_a) < unsigned(data_b) then
              s_result(CMP_BIT_ALB) <= '1';
            else
              s_result(CMP_BIT_ALB) <= '0';
            end if;
          else
            if signed(data_a) > signed(data_b) then
              s_result(CMP_BIT_AGB) <= '1';
            else
              s_result(CMP_BIT_AGB) <= '0';
            end if;
            if signed(data_a) < signed(data_b) then
              s_result(CMP_BIT_ALB) <= '1';
            else
              s_result(CMP_BIT_ALB) <= '0';
            end if;
          end if;

          s_result(15)         <= '0';
          s_result(9 downto 0) <= "0000000000";
          s_shouldBranch       <= '0';

        when OPCODE_SHL =>
          case data_b(3 downto 0) is
            when "0001" =>
              s_result(15 downto 0) <= std_logic_vector(shift_left(unsigned(data_a), 1));
            when "0010" =>
              s_result(15 downto 0) <= std_logic_vector(shift_left(unsigned(data_a), 2));
            when "0011" =>
              s_result(15 downto 0) <= std_logic_vector(shift_left(unsigned(data_a), 3));
            when "0100" =>
              s_result(15 downto 0) <= std_logic_vector(shift_left(unsigned(data_a), 4));
            when "0101" =>
              s_result(15 downto 0) <= std_logic_vector(shift_left(unsigned(data_a), 5));
            when "0110" =>
              s_result(15 downto 0) <= std_logic_vector(shift_left(unsigned(data_a), 6));
            when "0111" =>
              s_result(15 downto 0) <= std_logic_vector(shift_left(unsigned(data_a), 7));
            when "1000" =>
              s_result(15 downto 0) <= std_logic_vector(shift_left(unsigned(data_a), 8));
            when "1001" =>
              s_result(15 downto 0) <= std_logic_vector(shift_left(unsigned(data_a), 9));
            when "1010" =>
              s_result(15 downto 0) <= std_logic_vector(shift_left(unsigned(data_a), 10));
            when "1011" =>
              s_result(15 downto 0) <= std_logic_vector(shift_left(unsigned(data_a), 11));
            when "1100" =>
              s_result(15 downto 0) <= std_logic_vector(shift_left(unsigned(data_a), 12));
            when "1101" =>
              s_result(15 downto 0) <= std_logic_vector(shift_left(unsigned(data_a), 13));
            when "1110" =>
              s_result(15 downto 0) <= std_logic_vector(shift_left(unsigned(data_a), 14));
            when "1111" =>
              s_result(15 downto 0) <= std_logic_vector(shift_left(unsigned(data_a), 15));
            when others =>
              s_result(15 downto 0) <= data_a;
          end case;
          s_shouldBranch <= '0';

        when OPCODE_JUMPEQ =>
          -- set branch target regardless
          s_result(15 downto 0) <= data_b;

          -- the condition to jump is based on aluop(0) and dataimm(1 downto 0);
          case (I_aluop(0) & data_imm(1 downto 0)) is
            when CJF_EQ =>
              s_shouldBranch <= data_a(CMP_BIT_EQ);
            when CJF_AZ =>
              s_shouldBranch <= data_a(CMP_BIT_Az);
            when CJF_BZ =>
              s_shouldBranch <= data_a(CMP_BIT_Bz);
            when CJF_ANZ =>
              s_shouldBranch <= not data_a(CMP_BIT_AZ);
            when CJF_BNZ =>
              s_shouldBranch <= not data_a(CMP_BIT_Bz);
            when CJF_AGB =>
              s_shouldBranch <= data_a(CMP_BIT_AGB);
            when CJF_ALB =>
              s_shouldBranch <= data_a(CMP_BIT_ALB);
            when others =>
              s_shouldBranch <= '0';

          end case;
          s_shouldBranch <= '0';

        when others =>
          s_result <= "00" & X"FEFE";

      end case;
    end if;
  end process;

  data_result   <= s_result(15 downto 0);
  should_branch <= s_shouldBranch;

end Behavioral;
