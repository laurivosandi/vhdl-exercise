use work.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_testbench is
end;

architecture behavioral of alu_testbench is
    signal a, b, q     : std_logic_vector(3 downto 0);
    signal ctrl        : std_logic_vector (1 DOWNTO 0);
    signal cout, cin   : std_logic := '0';

    component alu
        port (
            n          : in  std_logic_vector (3 downto 0);
            m          : in  std_logic_vector (3 downto 0);
            opcode     : in  std_logic_vector (      1 downto 0);
            cout       : out std_logic;
            d          : out std_logic_vector (3 downto 0));

    end component;

    function to_std_logicvector(a: integer; length: natural) return std_logic_vector IS
    begin
        return std_logic_vector(to_signed(a,length));
    end;


    procedure behave_alu(a: integer; b: integer; ctrl: integer; q: out std_logic_vector(3 downto 0); cout: out std_logic) is
        variable ret: std_logic_vector(4 downto 0);
    begin
        case ctrl is
        when 0 => ret := std_logic_vector(to_signed(a+b, 5));
        when 1 => ret := std_logic_vector(to_signed(a-b, 5));
        when 2 => ret := '0' & (std_logic_vector(to_signed(a,4))) nand std_logic_vector(to_signed(b,4));
        when 3 => ret := '0' & (std_logic_vector(to_signed(a,4))) nor std_logic_vector(to_signed(b,4));
        when others =>
            assert false
            report "ctrl out of range, testbench error"
            severity error;
        end case;
        q := ret(3 downto 0);
        cout := ret(4);
    end;

    begin process
        variable res: std_logic_vector ( 3 downto 0);
        variable c: std_logic;
    begin
        ctrl <= "00";
        for i in 0 to 7 loop
            a <= std_logic_vector(to_signed(i,4));
            for j in 0 to 7-i loop
                b <= std_logic_vector(to_signed(j,4));
                wait for 10 ns;
                behave_alu(i,j,0,res,c);
                --assert "0" & q =  "1" & res
                assert q =  res
                report
                   " n=" & integer'image(to_integer(signed(a))) &
                   " m=" & integer'image(to_integer(signed(b))) &
                   " opcode=add" &
                   " wrong result from ALU:" & integer'image(to_integer(signed(q))) & 
                   " expected:" & integer'image(to_integer(signed(res)))
                severity warning;
                assert cout = c
                report
                   " n=" & integer'image(to_integer(signed(a))) &
                   " m=" & integer'image(to_integer(signed(b))) &
                   " opcode=add" &
                   " wrong carry from ALU:"  & std_logic'image(cout) &
                   " expected:" & std_logic'image(c)
                severity warning;
            end loop;
        end loop;
        report "Finished testing addition operation of ALU";


        ctrl <= "01";
        for i in 0 to 7 loop
            a <= std_logic_vector(to_signed(i,4));
            for j in 0 to 7 loop
                b <= std_logic_vector(to_signed(j,4));
                wait for 10 ns;
                behave_alu(i,j,1,res,c);
                --assert "0" & q =  "1" & res
                assert q =  res
                report
                   " n=" & integer'image(to_integer(signed(a))) &
                   " m=" & integer'image(to_integer(signed(b))) &
                   " opcode=sub" &
                   " wrong result from ALU:" & integer'image(to_integer(signed(q))) & 
                   " expected:" & integer'image(to_integer(signed(res)))
                severity warning;
                assert cout = c
                report
                   " n=" & integer'image(to_integer(signed(a))) &
                   " m=" & integer'image(to_integer(signed(b))) &
                   " opcode=sub" &
                   " wrong carry from ALU:"  & std_logic'image(cout) &
                   " expected:" & std_logic'image(c)
                severity warning;
            end loop;
        end loop;
        report "Finished testing subtraction operation of ALU";


        ctrl <= "10";
        for i in 0 to 7 loop
            a <= std_logic_vector(to_signed(i,4));
            for j in 0 to 7 loop
                b <= std_logic_vector(to_signed(j,4));
                wait for 10 ns;
                assert (a nand b) = q
                report
                   " n=" & integer'image(to_integer(signed(a))) &
                   " m=" & integer'image(to_integer(signed(b))) &
                   " opcode=nand " &
                   " wrong result from ALU:" & integer'image(to_integer(signed(q))) & 
                   " expected:" & integer'image(to_integer(signed(a nand b)))
                severity warning;
                
                assert cout = '0'
                report
                   " n=" & integer'image(to_integer(signed(a))) &
                   " m=" & integer'image(to_integer(signed(b))) &
                   " opcode=nand" &
                   " wrong carry from ALU:"  & std_logic'image(cout) &
                   " expected: 0"
                severity warning;

            end loop;
        end loop;
        report "Finished testing NAND operation of ALU";


        ctrl <= "11";
        for i in 0 to 7 loop
            a <= std_logic_vector(to_unsigned(i,4));
            for j in 0 to 7 loop
                b <= std_logic_vector(to_unsigned(j,4));
                wait for 10 ns;
                assert (a nor b) = q
                report
                   " n=" & integer'image(to_integer(signed(a))) &
                   " m=" & integer'image(to_integer(signed(b))) &
                   " opcode=nor " &
                   " wrong result from ALU:" & integer'image(to_integer(signed(q))) & 
                   " expected:" & integer'image(to_integer(signed(a nor b)))
                severity warning;

                assert cout = '0'
                report
                   " n=" & integer'image(to_integer(signed(a))) &
                   " m=" & integer'image(to_integer(signed(b))) &
                   " opcode=nor" &
                   " wrong carry from ALU:"  & std_logic'image(cout) &
                   " expected: 0"
                severity warning;

            end loop;
        end loop;


        report "Finished testing NOR operation of ALU";
        wait;
    end process;

    uut: alu port map (a, b, ctrl, cout, q);
end behavioral;
