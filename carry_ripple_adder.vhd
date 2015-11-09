library ieee;
use ieee.std_logic_1164.all;

-- This file corresponds to 4-bit carry ripple adder

entity carry_ripple_adder is
    port (
        a  : in  std_logic_vector (3 downto 0);  -- First operand
        b  : in  std_logic_vector (3 downto 0);  -- Second operand
        ci : in  std_logic;                      -- Carry in
        s  : out std_logic_vector (3 downto 0);  -- Result
        co : out std_logic                       -- Carry out
    );
end;

architecture behavioral of carry_ripple_adder is
    signal c : std_logic_vector(2 downto 0);
    component full_adder
        port ( ci, a, b : in std_logic; s, co : out std_logic);
    end component;
begin
    stage0: full_adder port map (  ci, a(0), b(0), s(0), c(0));
    stage1: full_adder port map (c(0), a(1), b(1), s(1), c(1));
    stage2: full_adder port map (c(1), a(2), b(2), s(2), c(2));
    stage3: full_adder port map (c(2), a(3), b(3), s(3), co  );
end behavioral;
