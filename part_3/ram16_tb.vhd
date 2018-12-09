-------------------------------------------------------------------------------
-- Title      : Testbench for design "ram16"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : ram16_tb.vhd
-- Author     : Covert Engineering  <covert@CovertEngineering>
-- Company    : 
-- Created    : 2018-11-23
-- Last update: 2018-11-23
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2018 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2018-11-23  1.0      covert	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library vunit_lib;
context vunit_lib.vunit_context;

-------------------------------------------------------------------------------

entity ram16_tb is
  generic(runner_cfg : string);
end entity ram16_tb;

-------------------------------------------------------------------------------

architecture behav of ram16_tb is

  -- component ports
  signal clk      : std_logic;
  signal we       : std_logic;
  signal addr     : std_logic_vector(15 downto 0);
  signal data_in  : std_logic_vector(15 downto 0);
  signal data_out : std_logic_vector(15 downto 0);

begin  -- architecture behav

  -- component instantiation
  DUT: entity work.ram16
    port map (
      clk      => clk,
      we       => we,
      addr     => addr,
      data_in  => data_in,
      data_out => data_out);

  -- clock generation
  clk <= not clk after 10 ns;

  -- waveform generation
  WaveGen_Proc: process
  begin
    -- insert signal assignments here
    
    wait until clk = '1';
    
    test_runner_setup(runner, runner_cfg);
    report "Hello world!";
    test_runner_cleanup(runner);
  end process WaveGen_Proc;

end architecture behav;

-------------------------------------------------------------------------------

configuration ram16_tb_behav_cfg of ram16_tb is
  for behav
  end for;
end ram16_tb_behav_cfg;

-------------------------------------------------------------------------------
