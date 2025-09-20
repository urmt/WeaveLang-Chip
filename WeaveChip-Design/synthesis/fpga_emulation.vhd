library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity weavechip_emulation is
    generic (
        ROWS : integer := 16;  -- 16x16 cores (256 total)
        COLS : integer := 16;
        SENSOR_BITS : integer := 8;
        SYNC_BITS : integer := 4
    );
    port (
        clk : in std_logic;  -- System clock (100 MHz)
        rst : in std_logic;  -- Active-high reset
        sensor_in : in std_logic_vector(ROWS*COLS*SENSOR_BITS-1 downto 0);
        spikes_out : out std_logic_vector(ROWS*COLS-1 downto 0)
    );
end weavechip_emulation;

architecture Behavioral of weavechip_emulation is
    -- Component declaration for core
    component weave_core
        port (
            clk : in std_logic;
            rst : in std_logic;
            sensor_in : in std_logic_vector(SENSOR_BITS-1 downto 0);
            spike_out : out std_logic;
            sync_in : in std_logic_vector(SYNC_BITS-1 downto 0);
            sync_out : out std_logic_vector(SYNC_BITS-1 downto 0)
        );
    end component;

    -- Signals
    type sensor_array is array (0 to ROWS-1, 0 to COLS-1) of std_logic_vector(SENSOR_BITS-1 downto 0);
    type spike_array is array (0 to ROWS-1, 0 to COLS-1) of std_logic;
    type sync_array is array (0 to ROWS-1, 0 to COLS-1) of std_logic_vector(SYNC_BITS-1 downto 0);
    signal sensors : sensor_array;
    signal spikes : spike_array;
    signal sync_in, sync_out : sync_array;

begin
    -- Map sensor inputs
    process (sensor_in)
        variable idx : integer;
    begin
        for i in 0 to ROWS-1 loop
            for j in 0 to COLS-1 loop
                idx := (i*COLS + j)*SENSOR_BITS;
                sensors(i,j) <= sensor_in(idx + SENSOR_BITS-1 downto idx);
            end loop;
        end loop;
    end process;

    -- Instantiate 16x16 core array
    gen_row: for i in 0 to ROWS-1 generate
        gen_col: for j in 0 to COLS-1 generate
            core_inst : weave_core
            port map (
                clk => clk,
                rst => rst,
                sensor_in => sensors(i,j),
                spike_out => spikes(i,j),
                sync_in => sync_in(i,j),
                sync_out => sync_out(i,j)
            );
        end generate;
    end generate;

    -- NoC: 4-connected grid
    process (clk, rst)
    begin
        if rst = '1' then
            sync_in <= (others => (others => (others => '0')));
        elsif rising_edge(clk) then
            for i in 0 to ROWS-1 loop
                for j in 0 to COLS-1 loop
                    if i > 0 then sync_in(i,j)(0) <= sync_out(i-1,j)(1);
                    if i < ROWS-1 then sync_in(i,j)(1) <= sync_out(i+1,j)(0);
                    if j > 0 then sync_in(i,j)(2) <= sync_out(i,j-1)(3);
                    if j < COLS-1 then sync_in(i,j)(3) <= sync_out(i,j+1)(2);
                end loop;
            end loop;
        end if;
    end process;

    -- Map spike outputs
    process (spikes)
        variable idx : integer;
    begin
        for i in 0 to ROWS-1 loop
            for j in 0 to COLS-1 loop
                idx := i*COLS + j;
                spikes_out(idx) <= spikes(i,j);
            end loop;
        end loop;
    end process;

end Behavioral;