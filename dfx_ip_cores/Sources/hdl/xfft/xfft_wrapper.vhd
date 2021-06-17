----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/11/2021 11:09:04 PM
-- Design Name: 
-- Module Name: ft_wrapper - arch
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ft_wrapper is
    generic (
        SIZE : positive := 128; -- default 128
        C_S_AXI_DATA_WIDTH : positive := 64
    );
    port (
        clk : in std_logic;
        reset : in std_logic;
        
        -- streaming sink (input)
        stin_data : in std_logic_vector(C_S_AXI_DATA_WIDTH -1 downto 0);
        stin_valid : in std_logic;
        stin_ready : out std_logic;
        
        -- streaming source (ouput)
        stout_data : out std_logic_vector(C_S_AXI_DATA_WIDTH -1 downto 0);
        stout_valid : out std_logic;
        stout_ready : in std_logic        
    );
begin
    -- check if SIZE is valid    
    check :
    assert ((SIZE = 8) or (SIZE = 16) or (SIZE = 32) or (SIZE = 64) or (SIZE = 128) or (SIZE = 256) or (SIZE = 512) or (SIZE = 1024) 
                or (SIZE = 2048) or (SIZE = 4096) or (SIZE = 8192) or (SIZE = 16384) or (SIZE = 32768) or (SIZE = 65536))
    report ("The selected transform size (" & integer'image(SIZE) & ") is not supported!") severity failure;
end ft_wrapper;

architecture arch of ft_wrapper is

    -- constant declaration
    constant PADDING_NFFT : std_logic_vector(2 downto 0) := (others => '0'); -- padding bits for FFT size
    constant FWD : std_logic := '1'; -- use forward transformation
    constant SCALE_SCH : std_logic_vector(7 downto 0) := (others => '0'); -- scaling schedule, not required for floating point processing
    constant PADDING_SCALE : std_logic_vector(6 downto 0) := (others => '0'); -- padding for scaling schedule
    
    -- signal declaration
    -- FFT signals
    signal aresetn : std_logic;
    -- configuration signals
    -- format:
    -- 23 downto 17: PADDING_SCALE
    -- 16 downto  9: SCALE_SCH
    --  8 downto  8: FWD
    --  7 downto  5: PADDING_NFFT
    --  4 downto  0: NFFT
    signal config_data  : std_logic_vector(23 DOWNTO 0);
    signal config_valid : std_logic;
    signal config_ready : std_logic;
    -- data input channel signals
    signal in_valid : std_logic;
    signal in_ready : std_logic;
    signal in_last  : std_logic;
    -- data output channel signals
    signal out_valid : std_logic;
    signal out_ready : std_logic;
    signal out_last  : std_logic;
    -- event signals (not used)
    signal event_frame_started        : std_logic;                                   
   signal event_tlast_unexpected      : std_logic;                                 
   signal event_tlast_missing         : std_logic;                                    
   signal event_status_channel_halt   : std_logic;                            
   signal event_data_in_channel_halt  : std_logic;                             
   signal event_data_out_channel_halt : std_logic;  
    
    signal size_s             : positive := SIZE;
    signal fft_size           : std_logic_vector(4 downto 0);

    signal index              :natural range 0 to SIZE := 0;
    signal index_next         : natural range 0 to SIZE := 0;
    
    signal receive_index      : natural range 0 to SIZE := 0;
    signal receive_index_next : natural range 0 to SIZE := 0;
    
    -- type declaration
    type state_type is (
        TRANSFER_TO_FFT,
        OUTPUT_DATA
    );
    signal state, state_next : state_type := TRANSFER_TO_FFT;
    
    type input_state_type is (
        INPUT_INIT,
        INPUT_IDLE_TRANSFORM
    );
    signal input_state, input_state_next : input_state_type := INPUT_INIT;
    
    -- component for FFT IP core
    component fft_0 is
        port (
        -- Global signals
        aclk : in std_logic;                                                    -- clock
        aresetn : in std_logic;                                                 -- Active-Low syncronous clear (reset)
        -- AXI4-Stream slave configuration channel
        s_axis_config_tdata : in std_logic_vector(23 DOWNTO 0);                 -- configuration data
        s_axis_config_tvalid : in std_logic;                                    -- configuration data valid
        s_axis_config_tready : out std_logic;                                   -- configuration data ready
        -- AXI4-Stream slave data input channel
        s_axis_data_tdata : in std_logic_vector(C_S_AXI_DATA_WIDTH -1 DOWNTO 0);   -- input data (imaginary, real)
        s_axis_data_tvalid : in std_logic;                                      -- input data valid
        s_axis_data_tready : out std_logic;                                     -- input data ready        
        s_axis_data_tlast : in std_logic;                                       -- last data in
        -- AXI4-Stream master data output channel
        m_axis_data_tdata : out std_logic_vector(C_S_AXI_DATA_WIDTH -1 DOWNTO 0);  -- output data (imaginary, real)
        m_axis_data_tvalid : out std_logic;                                     -- output data valid
        m_axis_data_tready : in std_logic;                                      -- output data ready
        m_axis_data_tlast : out std_logic;                                      -- last data out
        -- Event signals
        event_frame_started : out std_logic;                                    -- event: new frame
        event_tlast_unexpected : out std_logic;                                 -- event: unexpected last data in
        event_tlast_missing : out std_logic;                                    -- event: missing last data in
        event_status_channel_halt : out std_logic;                              -- event: cannot write status
        event_data_in_channel_halt : out std_logic;                             -- event: no data input available
        event_data_out_channel_halt : out std_logic                             -- event: cannot write data output
      );
  end component fft_0;

begin

    -- set Active-Low syncronous clear (reset)
    aresetn <= not reset;
    
    -- implement FFT unit
    fft_inst : component fft_0
    port map (
        -- Global signals
        aclk => clk,                                                   
        aresetn => aresetn,                                                 
        -- AXI4-Stream slave configuration channel
        s_axis_config_tdata => config_data,           
        s_axis_config_tvalid => config_valid,                                    
        s_axis_config_tready => config_ready,                                   
        -- AXI4-Stream slave data input channel
        s_axis_data_tdata => stin_data,
        s_axis_data_tvalid => in_valid,
        s_axis_data_tready => in_ready,
        s_axis_data_tlast => in_last,                                       
        -- AXI4-Stream master data output channel
        m_axis_data_tdata => stout_data,
        m_axis_data_tvalid => out_valid,                                     
        m_axis_data_tready => out_ready,                                      
        m_axis_data_tlast => out_last,                                     
        -- Event signals
        event_frame_started => event_frame_started,
        event_tlast_unexpected => event_tlast_unexpected,
        event_tlast_missing => event_tlast_missing,
        event_status_channel_halt => event_status_channel_halt,
        event_data_in_channel_halt => event_data_in_channel_halt,
        event_data_out_channel_halt => event_data_out_channel_halt
      );
    
    -----------------------------------------------------------------------
        
    -- process to get the binary encoding for the transform size
    get_size_proc: process (size_s)
    begin
        case size_s is
            when      8  => fft_size <= "00011";
            when     16  => fft_size <= "00100";
            when     32  => fft_size <= "00101";
            when     64  => fft_size <= "00110";
            when    128  => fft_size <= "00111";
            when    256  => fft_size <= "01000";
            when    512  => fft_size <= "01001";
            when   1024  => fft_size <= "01010";
            when   2048  => fft_size <= "01011";
            when   4096  => fft_size <= "01100";
            when   8192  => fft_size <= "01101";
            when  16384  => fft_size <= "01110";
            when  32768  => fft_size <= "01111";
            when  65536  => fft_size <= "10000";            
            when others  => fft_size <= "00111"; -- default 128
        end case;
    end process get_size_proc;
    
    -----------------------------------------------------------------------
    
    --syncronous process
    sync_state_proc: process (reset, clk)
    begin
        if reset = '1' then --Reset signals
            state <= TRANSFER_TO_FFT;
            input_state <= INPUT_INIT;
            index <= 0;
            receive_index <= 0;
            
        elsif rising_edge(clk) then
            state <= state_next;
            input_state <= input_state_next;
            index <= index_next;
            receive_index <= receive_index_next;
        end if;
        
    end process sync_state_proc;
    
    -----------------------------------------------------------------------

    --process to feed the FFT
    input_proc: process (input_state, index, state, in_ready, config_ready, fft_size, stin_valid)
    begin
        --default values to prevent latches
        input_state_next <= input_state;
        index_next <= index;
        config_valid <= '0';
        in_valid <= '0';
        in_last <= '0';
        config_data <= (others => '0');
        
        if (state = TRANSFER_TO_FFT) and (in_ready = '1') and (input_state = INPUT_IDLE_TRANSFORM) then -- forward back pressure
            stin_ready <= '1';
        else
            stin_ready <= '0';
        end if;
        
        case input_state is
        
            when INPUT_INIT =>
                
                if (state = TRANSFER_TO_FFT) and (config_ready = '1') then --check if FFT is ready for configuration
                    --set configuration data
                    config_data(23 downto 17) <= PADDING_SCALE; -- padding for scaling schedule
                    config_data(16 downto  9) <= SCALE_SCH;     -- scaling schedule, not required for floating point processing
                    config_data(8)            <= FWD;           -- use forward transformation
                    config_data(7 downto 5)   <= PADDING_NFFT;  -- padding bits for FFT size
                    config_data(4 downto 0)   <= fft_size;
                    
                    --configuration valid
                    config_valid <= '1';
                    
                    input_state_next <= INPUT_IDLE_TRANSFORM;                    
                end if;          

            when INPUT_IDLE_TRANSFORM =>
                
                if index = SIZE then --independent of valid signals
                    index_next <= 0; --reset counter
                    
                elsif (state = TRANSFER_TO_FFT) and (in_ready = '1') and (stin_valid = '1') then --check if ready and input data is available
                    --set input data valid
                    in_valid <= '1';
                    
                    if (index = SIZE-1) then
                        in_last <= '1'; --set flag for last input frame
                    end if;
                    
                    --increase index
                    index_next <= index + 1;
                end if;

            when others =>
                input_state_next <= INPUT_IDLE_TRANSFORM; 
        end case;
    
    end process input_proc;

    -----------------------------------------------------------------------
    
    --FFT status process
    fft_proc: process (state, index, receive_index, stout_ready)
    begin
        --default values to prevent latches
        state_next <= state;
        
        case state is
        
            when TRANSFER_TO_FFT =>
                out_ready <= '0';
                
                if index = SIZE then
                    state_next <= OUTPUT_DATA;
               end if;
               
            when OUTPUT_DATA =>
                out_ready <= stout_ready; --ready for output
                
                if receive_index = SIZE then                    
                    state_next <= TRANSFER_TO_FFT;
                end if;
                
            when others =>
                state_next <= TRANSFER_TO_FFT;
        end case;
                
    end process fft_proc;
        
    -----------------------------------------------------------------------
    
    --process to get output of the FFT
    output_proc: process (receive_index, state, stout_ready, out_valid)
    begin
        --default values to prevent latches
        receive_index_next <= receive_index;
        stout_valid <= '0';
        
        if (receive_index = SIZE) then --independent of valid signals
            receive_index_next <= 0; --reset counter
        
        elsif (stout_ready = '1') and (state = OUTPUT_DATA) and (out_valid = '1') then --check if the output data of the FFT is valid
            --set output data valid
            stout_valid <= '1';
            
            --increase index
            receive_index_next <= receive_index + 1; 
        end if;
                
    end process output_proc;
        
end arch;
