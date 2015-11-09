library ieee;
use ieee.std_logic_1164.all;

entity alu is
    port (
        n          : in  std_logic_vector (3 downto 0);
        m          : in  std_logic_vector (3 downto 0);
        opcode     : in  std_logic_vector (1 downto 0);
        d          : out std_logic_vector (3 downto 0);
        cout       : out std_logic
    );
end alu;

architecture behavioral of alu is
    component carry_ripple_adder
        port (
            a    : in  std_logic_vector (3 downto 0);
            b    : in  std_logic_vector (3 downto 0);
            ci   : in  std_logic;
            s    : out std_logic_vector (3 downto 0);
            co   : out std_logic
        );
    end component;

    signal m_inverted        : std_logic_vector (3 downto 0);
    signal nand_result       : std_logic_vector (3 downto 0);
    signal nor_result        : std_logic_vector (3 downto 0);
    signal adder_result      : std_logic_vector (3 downto 0);
    signal adder_carry_out   : std_logic;
    signal operation_type    : std_logic; 
    signal sub               : std_logic;

begin
    -- Make sense from control bits
    operation_type   <=   opcode(1);   -- Are we doing logical or arithmetic operation?
    sub              <=   opcode(0);   -- Are we doing addition/NAND or subtraction/NOR?


    -- Here we calculate inverted bits for subtraction if necessary
    m_inverted(0) <= not m(0);
    m_inverted(1) <= not m(1);
    m_inverted(2) <= not m(2);
    m_inverted(3) <= not m(3);

    -- Addition
    adder_instance: carry_ripple_adder
        port map(
            a => n,
            b => m_inverted,
            ci => '1',
            s => adder_result,
            co => adder_carry_out
        );
        
    -- Logical NAND operation
    nand_result(0) <= not m(0) and n(0);
    nand_result(1) <= not m(1) and n(1);
    nand_result(2) <= not m(2) and n(2);
    nand_result(3) <= not m(3) and n(3);

    -- Logical NOR operation
    nor_result(0) <= not m(0) or n(0);
    nor_result(1) <= not m(1) or n(1);
    nor_result(2) <= not m(2) or n(2);
    nor_result(3) <= not m(3) or n(3);

    -- Select output based on which operation was requested
    d <=   nand_result when opcode ="10" else
           nor_result when opcode ="11" else
           adder_result;

    -- Carry out bit
    cout <= (adder_carry_out xor sub) when operation_type = '0' else
           '0';
end;

