library ieee;
	use	ieee.std_logic_1164.all;
	use	ieee.numeric_std.all;

library work;
	use work.cnn_types.all;

entity sumFeatures is

    generic(
        PIXEL_SIZE      :   integer;
        IMAGE_WIDTH     :   integer;
        NB_CONVED       :   integer
    );

    port(
        in_data         :   pixel_array (0 to NB_CONVED - 1);
        clk	            :	in 	std_logic;
        reset_n	        :	in	std_logic;
        enable          :	in	std_logic;
        out_data        :   out std_logic_vector (PIXEL_SIZE - 1 downto 0)
    );
end entity;
--
architecture bhv of sumFeatures is

    -- Gestion de l'overflow de manière très approximative ...
    type pixel_array_signed is array (0 to NB_CONVED - 1) of signed (PIXEL_SIZE -1 downto 0)
    signal	data_s	    :	pixel_array_signed ;
    signal  sum_s       :   signed (PIXEL_SIZE - 1 downto 0)

    begin
    CAST : for i in 0 to (NB_CONVED - 1) generate
        data_s(i)      <=  signed(data_in(i));
    end generate;

    process(clk)
    -- Gestion de l'overflow de manière très approximative ...
        variable sum    :   signed (PIXEL_SIZE - 1  downto 0);
        begin
            if (reset_n ='0') then
                sum := (others=>'0');
            elsif (RISING_EDGE(clk)) then
                if (enable='1') then

                    SUM : for i in 0 to (NB_CONVED - 1) loop
                        sum := sum + data_s(i);
                    end loop;

                    if (sum(sum'left) = '1')	then
                        sum := (others => '0');
                    end if;
                    
                    sum_s	<=	sum;
                end if;
            end if;
        end process;

        data_out <= std_logic_vector (sum_s);
end bhv;
