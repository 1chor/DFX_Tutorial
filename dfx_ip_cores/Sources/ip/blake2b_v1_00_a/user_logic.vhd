------------------------------------------------------------------------------
-- Filename:          user_logic.vhd
-- Version:           1.00.a
-- Description:       User logic.
-- Date:              Thu Feb  7 09:24:34 2019 (by Create and Import Peripheral Wizard)
-- VHDL Standard:     VHDL'93
------------------------------------------------------------------------------
-- Naming Conventions:
--   active low signals:                    "*_n"
--   clock signals:                         "clk", "clk_div#", "clk_#x"
--   reset signals:                         "rst", "rst_n"
--   generics:                              "C_*"
--   user defined types:                    "*_TYPE"
--   state machine next state:              "*_ns"
--   state machine current state:           "*_cs"
--   combinatorial signals:                 "*_com"
--   pipelined or register delay signals:   "*_d#"
--   counter signals:                       "*cnt*"
--   clock enable signals:                  "*_ce"
--   internal version of output port:       "*_i"
--   device pins:                           "*_pin"
--   ports:                                 "- Names begin with Uppercase"
--   processes:                             "*_PROCESS"
--   component instantiations:              "<ENTITY_>I_<#|FUNC>"
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_NUM_REG                    -- Number of software accessible registers
--   C_SLV_DWIDTH                 -- Slave interface data bus width
--
-- Definition of Ports:
--   Interrupt                    -- High-active interrupt to PS
--   Bus2IP_Clk                   -- Bus to IP clock
--   Bus2IP_Resetn                -- Bus to IP reset
--   Bus2IP_Data                  -- Bus to IP data bus
--   Bus2IP_BE                    -- Bus to IP byte enables
--   Bus2IP_RdCE                  -- Bus to IP read chip enable
--   Bus2IP_WrCE                  -- Bus to IP write chip enable
--   IP2Bus_Data                  -- IP to Bus data bus
--   IP2Bus_RdAck                 -- IP to Bus read transfer acknowledgement
--   IP2Bus_WrAck                 -- IP to Bus write transfer acknowledgement
--   IP2Bus_Error                 -- IP to Bus error response
------------------------------------------------------------------------------

entity user_logic is
  generic
  (
    -- Bus protocol parameters, do not add to or delete
    C_NUM_REG                      : integer              := 4;
    C_SLV_DWIDTH                   : integer              := 32
  );
  port
  (
	 Interrupt : out std_logic;
    Bus2IP_Clk                     : in  std_logic;
    Bus2IP_Resetn                  : in  std_logic;
    Bus2IP_Data                    : in  std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    Bus2IP_BE                      : in  std_logic_vector(C_SLV_DWIDTH/8-1 downto 0);
    Bus2IP_RdCE                    : in  std_logic_vector(C_NUM_REG-1 downto 0);
    Bus2IP_WrCE                    : in  std_logic_vector(C_NUM_REG-1 downto 0);
    IP2Bus_Data                    : out std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    IP2Bus_RdAck                   : out std_logic;
    IP2Bus_WrAck                   : out std_logic;
    IP2Bus_Error                   : out std_logic
  );

  attribute MAX_FANOUT : string;
  attribute SIGIS : string;

  attribute SIGIS of Bus2IP_Clk    : signal is "CLK";
  attribute SIGIS of Bus2IP_Resetn : signal is "RST";

end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is

  --USER signal declarations added here, as needed for user logic
  
  signal interrupt_s : std_logic;

  ------------------------------------------
  -- Signals for user logic slave model s/w accessible register example
  ------------------------------------------
  signal task_reg                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal message_reg                    : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal status_reg                     : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal hash_reg                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg_write_sel              : std_logic_vector(3 downto 0);
  signal slv_reg_read_sel               : std_logic_vector(3 downto 0);
  signal slv_ip2bus_data                : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_read_ack                   : std_logic;
  signal slv_write_ack                  : std_logic;
  
  signal task_reg_changed               : std_logic;
  signal message_reg_changed            : std_logic;
  signal next_chunk                     : std_logic_vector(128 * 8 - 1 downto 0);
  signal hash_out                       : std_logic_vector(64 * 8 - 1 downto 0);
  signal bytes_left                     : integer range 0 to 2147483647;
  signal subchunk_index                 : integer range 0 to 32;
  signal hash_out_index                 : integer range 0 to 15;
  signal reset_hash_out_index           : std_logic;
  
  signal status_waiting_for_data        : std_logic;
  signal status_hash_ready              : std_logic;
  signal status_ready                   : std_logic;
  
  --connections to blake2b_wrapper instance
  signal message                        : std_logic_vector(128 * 8 - 1 downto 0);
  signal message_valid                  : std_logic;
  signal message_len                    : integer range 0 to 2147483647;
  signal compress_ready                 : std_logic;
  signal last_chunk                     : std_logic;
  signal hash_valid                     : std_logic;
  signal hash                           : std_logic_vector(64 * 8 - 1 downto 0);
  
  signal Bus2IP_Reset                   : std_logic;
  
  --
  -- States for the state machine
  --
  type state_type is (
    STATE_READY,                        --Ready to start hashing
	 STATE_PREPARE_KEY,                  --message_len received, start hashing by passing the key
	 STATE_WAIT_SUBCHUNK,                --Wait for the software to send a subchunk
	 STATE_WAIT_COMPRESS_READY,          --Wait until the entity is ready to receive the new chunk
	 STATE_HASH_CHUNK,                   --Hash that chunk
	 STATE_WAIT_DONE                     --Wait until the hash is ready
  );
  signal state: state_type;
  
  constant KEY : std_logic_vector(128*8-1 downto 0) :=
    X"54686973206973207468652067726561" &
	 X"74657374204b657920657665722e2049" &
	 X"7427732066616e7461737469632e204c" &
	 X"45542773204d414b45204b4559532043" &
	 X"41505320414741494e212049206e6565" &
	 X"64203132382063686172616374657273" &
	 X"20666f722074686973206b65792e204e" &
	 X"6f77204920616d20646f6f6f6f6e652e";
  
  component blake2b_wrapper is
    port (
      reset          : in  std_logic;
      clk            : in  std_logic;
      message        : in  std_logic_vector(128 * 8 - 1 downto 0);
      hash_len       : in  integer range 1 to 64;
      key_len        : in integer range 0 to 128*8;
      valid_in       : in  std_logic;
      message_len    : in  integer range 0 to 2147483647;
      compress_ready : out std_logic;
      last_chunk     : in  std_logic;
      valid_out      : out std_logic;
      hash           : out std_logic_vector(64 * 8 - 1 downto 0)
    );
  end component;

begin

  --USER logic implementation added here
  
  Interrupt <= interrupt_s;
  Bus2IP_Reset <= not Bus2IP_Resetn;
  
  status_reg <= status_waiting_for_data & status_hash_ready & status_ready & "0" & X"00000" & std_logic_vector(to_unsigned(state_type'POS(state), 8));
  
  blake2_inst : blake2b_wrapper
  port map (
    reset          => Bus2IP_Reset,
    clk            => Bus2IP_Clk,
    message        => message,
    valid_in       => message_valid,
    message_len    => message_len,
    hash_len       => 64,
    key_len        => 128,
    compress_ready => compress_ready,
    last_chunk     => last_chunk,
    valid_out      => hash_valid,
    hash           => hash
  );

  ------------------------------------------
  -- Example code to read/write user logic slave model s/w accessible registers
  -- 
  -- Note:
  -- The example code presented here is to show you one way of reading/writing
  -- software accessible registers implemented in the user logic slave model.
  -- Each bit of the Bus2IP_WrCE/Bus2IP_RdCE signals is configured to correspond
  -- to one software accessible register by the top level template. For example,
  -- if you have four 32 bit software accessible registers in the user logic,
  -- you are basically operating on the following memory mapped registers:
  -- 
  --    Bus2IP_WrCE/Bus2IP_RdCE   Memory Mapped Register
  --                     "1000"   C_BASEADDR + 0x0
  --                     "0100"   C_BASEADDR + 0x4
  --                     "0010"   C_BASEADDR + 0x8
  --                     "0001"   C_BASEADDR + 0xC
  -- 
  ------------------------------------------
  slv_reg_write_sel <= Bus2IP_WrCE(3 downto 0);
  slv_reg_read_sel  <= Bus2IP_RdCE(3 downto 0);
  slv_write_ack     <= Bus2IP_WrCE(0) or Bus2IP_WrCE(1) or Bus2IP_WrCE(2) or Bus2IP_WrCE(3);
  slv_read_ack      <= Bus2IP_RdCE(0) or Bus2IP_RdCE(1) or Bus2IP_RdCE(2) or Bus2IP_RdCE(3);

  -- implement slave model software accessible register(s)
  SLAVE_REG_WRITE_PROC : process( Bus2IP_Clk ) is
  begin
  
    if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
      if Bus2IP_Resetn = '0' then
        task_reg <= (others => '0');
        message_reg <= (others => '0');
        --status_reg <= (others => '0');
        hash_reg <= (others => '0');
		  
		  next_chunk <= (others => '0');
		  hash_out <= (others => '0');
		  bytes_left <= 0;
		  subchunk_index <= 0;
		  
		  message <= (others => '0');
		  message_valid <= '0';
		  message_len <= 0;
		  last_chunk <= '0';
		  
		  interrupt_s <= '0';
		  task_reg_changed <= '0';
		  message_reg_changed <= '0';
		  
		  status_waiting_for_data <= '0';
		  status_hash_ready <= '0';
		  status_ready <= '1';
		  
		  state <= STATE_READY;
		  
      else
		  --
		  -- State Machine
		  --
		  case state is
		    when STATE_READY =>
				status_ready <= '1';
				subchunk_index <= 0;
				interrupt_s <= '0';
				if task_reg_changed = '1' then
					message_len <= to_integer(unsigned(task_reg));
					bytes_left <=  to_integer(unsigned(task_reg));
					state <= STATE_PREPARE_KEY;
				end if;
		    when STATE_PREPARE_KEY =>
			   message <= KEY;
				message_valid <= '1';
				message_len <= bytes_left + 128;
				status_ready <= '0';
				if bytes_left > 0 then
					last_chunk <= '0';
					interrupt_s <= '1';
					status_waiting_for_data <= '1';
					state <= STATE_WAIT_SUBCHUNK;
				else
					last_chunk <= '1';
					interrupt_s <= '0';
					state <= STATE_WAIT_DONE;
				end if;
		    when STATE_WAIT_SUBCHUNK =>
				message_valid <= '0';
				if message_reg_changed = '1' then
				
					for i in 0 to 3 loop
						for j in 0 to 7 loop
							next_chunk(subchunk_index*32+i*8+j) <= message_reg((3 - i)*8 + j);
						end loop;
					end loop;
					
					if bytes_left <= 4 then
						bytes_left <= 0;
						subchunk_index <= 0;
						status_waiting_for_data <= '0';
						interrupt_s <= '0';
						state <= STATE_WAIT_COMPRESS_READY;
					else
						bytes_left <= bytes_left - 4;
						if subchunk_index = 31 then
							subchunk_index <= 0;
							status_waiting_for_data <= '0';
							interrupt_s <= '0';
							state <= STATE_WAIT_COMPRESS_READY;
						else
							status_waiting_for_data <= '1';
							interrupt_s <= '1';
							subchunk_index <= subchunk_index + 1;
						end if;
					end if;
				else
					interrupt_s <= '0';
				end if;
		    when STATE_WAIT_COMPRESS_READY =>
			   if compress_ready = '1' then
					state <= STATE_HASH_CHUNK;
				end if;
		    when STATE_HASH_CHUNK =>
				message <= next_chunk;
				next_chunk <= (others => '0');
				message_valid <= '1';
				if bytes_left > 0 then
					last_chunk <= '0';
					interrupt_s <= '1';
					status_waiting_for_data <= '1';
					state <= STATE_WAIT_SUBCHUNK;
				else
					last_chunk <= '1';
					interrupt_s <= '0';
					state <= STATE_WAIT_DONE;
				end if;
		    when STATE_WAIT_DONE =>
				status_waiting_for_data <= '0';
				message_valid <= '0';
				if hash_valid = '1' then
					interrupt_s <= '1';
					status_hash_ready <= '1';
					hash_out <= hash;
					state <= STATE_READY;
				end if;
		    when others =>
			   message <= (others => '0');
				message_valid <= '0';
				message_len <= 0;
				last_chunk <= '0';
				interrupt_s <= '0';
				status_waiting_for_data <= '0';
				status_hash_ready <= '0';
				status_ready <= '1';
				hash_out <= (others => '0');
				state <= STATE_READY;
		  end case;
		  
        --
        -- Writes from Software to Logic
        --
        case slv_reg_write_sel is
          when "1000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                task_reg(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
		      task_reg_changed <= '1';
		      message_reg_changed <= '0';
          when "0100" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                message_reg(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
		      task_reg_changed <= '0';
		      message_reg_changed <= '1';
          --Register 0010 is not writable from software!
          --when "0010" =>
          --  for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
          --    if ( Bus2IP_BE(byte_index) = '1' ) then
          --      status_reg(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
          --    end if;
          --  end loop;
          --  interrupt_s <= '0';
          when "0001" =>
				if ( Bus2IP_BE(0) = '1' ) then
					hash_reg <= hash_out((to_integer(unsigned(Bus2IP_Data(7 downto 0)))+1)*32-1 downto to_integer(unsigned(Bus2IP_Data(7 downto 0)))*32);
				end if;
            interrupt_s <= '0';
          when others =>
		      task_reg_changed <= '0';
		      message_reg_changed <= '0';
        end case;
      end if;
    end if;

  end process SLAVE_REG_WRITE_PROC;

  -- implement slave model software accessible register(s) read mux
  SLAVE_REG_READ_PROC : process( slv_reg_read_sel, task_reg, message_reg, status_reg, hash_reg ) is
  begin

    --
    -- Software reads Logic registers
    --
    case slv_reg_read_sel is
      when "1000" => slv_ip2bus_data <= task_reg;
      when "0100" => slv_ip2bus_data <= message_reg;
      when "0010" => slv_ip2bus_data <= status_reg;
      when "0001" => slv_ip2bus_data <= hash_reg;
      when others => slv_ip2bus_data <= (others => '0');
    end case;

  end process SLAVE_REG_READ_PROC;

  ------------------------------------------
  -- Example code to drive IP to Bus signals
  ------------------------------------------
  IP2Bus_Data  <= slv_ip2bus_data when slv_read_ack = '1' else
                  (others => '0');

  IP2Bus_WrAck <= slv_write_ack;
  IP2Bus_RdAck <= slv_read_ack;
  IP2Bus_Error <= '0';

end IMP;
