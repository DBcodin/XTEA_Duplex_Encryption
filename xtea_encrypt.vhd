library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity xtea_encrypt is
	port(
	   	--enc inputs
		      clock_sig				:in std_logic;
		      data_valid			:in std_logic;
		      data_word			:in std_logic_vector(127 downto 0);
		      key_word				:in std_logic_vector(127 downto 0);
		      
		      
		
		  --outputs
		      ciphertext_ready	:out std_logic;
		      ciphertext_word	:out std_logic_vector(127 downto 0));
end xtea_encrypt;




architecture func of xtea_encrypt is	

	component subkey_cal_encrypt port(
		subkey_clk			:in std_logic;
		subkkey_level			:in std_logic;
		
		subkey_key_valid	:in std_logic;
		subkey_key_word		:in std_logic_vector(127 downto 0);
		subkey_set_1 	:out std_logic_vector(31 downto 0);
		subkey_set_2 	:out std_logic_vector(31 downto 0));
	end component;	
	
	component xtea_tean_encrypt port(
		encrypt_clk 					:in std_logic;
		encrypt_data_valid			:in std_logic;
		encrypt_data_word			:in std_logic_vector(63 downto 0);
		encrypt_subkey				:in std_logic_vector(31 downto 0);
		encrypt_ciphertext_word	:out std_logic_vector(63 downto 0));
	end component;
	
	
	
	
	
	
	
	 signal level 	 		 : std_logic_vector(4 downto 0) := "00000";
	
	 signal subkey_1	 	 : std_logic_vector(31 downto 0);
	 signal subkey_2	 	 : std_logic_vector(31 downto 0);
	
	 signal data_to_encrypt_1 	 : std_logic_vector(63 downto 0);
	 signal data_to_encrypt_2 	 : std_logic_vector(63 downto 0);
	
	 signal encrypted_data_1: std_logic_vector(63 downto 0);
	 signal encrypted_data_2: std_logic_vector(63 downto 0);
	
	 signal data_buffer_1 	 : std_logic_vector(63 downto 0);
	 signal data_buffer_2 	 : std_logic_vector(63 downto 0);
	
	 signal half_tean_word_1: std_logic_vector(63 downto 0);
	 signal half_tean_word_2: std_logic_vector(63 downto 0);
	
	
	
	

	-- set up port maps to link everything together
	
begin --done
   	subk1 : subkey_cal_encrypt port map(
	  
		subkey_clk 			=>clock_sig,
		
		subkkey_level		=>level(0),
		subkey_key_valid 	=>data_valid,
		subkey_key_word		=>key_word,
		subkey_set_1		=>subkey_1,
		subkey_set_2		=>subkey_2);
	
	
	
   	encrypt_1a : xtea_tean_encrypt port map( --done
	  
	  encrypt_clk					=>clock_sig,
	  
		encrypt_data_valid			=>data_valid,
		encrypt_data_word			=>data_to_encrypt_1,
		encrypt_subkey				=>subkey_1,	
		encrypt_ciphertext_word	=>half_tean_word_1);
		
		
		
	  encrypt_1b : xtea_tean_encrypt port map( --done
	  
		encrypt_clk				=>clock_sig,
		
		encrypt_data_valid				=>data_valid,
		encrypt_data_word				=>half_tean_word_1,
		encrypt_subkey				=>subkey_2,	
		encrypt_ciphertext_word		=>encrypted_data_1);
		
		
		
	encrypt_2a : xtea_tean_encrypt port map( --done
	  
	encrypt_clk				=>clock_sig,
	
		encrypt_data_valid				=>data_valid,
		encrypt_data_word				=>data_to_encrypt_2,
		encrypt_subkey				=>subkey_1,	
	encrypt_ciphertext_word	=>half_tean_word_2);
		
		
		
	encrypt_2b : xtea_tean_encrypt port map(  --done
	  
		encrypt_clk				=>clock_sig,
		
		encrypt_data_valid			=>data_valid,
		encrypt_data_word				=>half_tean_word_2,
		encrypt_subkey			=>subkey_2,	
		encrypt_ciphertext_word	=>encrypted_data_2);
	
	
	
	
	-- move both halves of the 128 bit string to data enc 1/2 when level is at 0 
	data_to_encrypt_1<= data_word(63 downto 0) when level= "00000" else  data_buffer_1;
	
	data_to_encrypt_2<= data_word(127 downto 64) 	when level= "00000" else data_buffer_2;
	
	
	-- then move the encrypted halves into their outputs when level is 1
	ciphertext_word(63 downto 0) <= encrypted_data_1 when level = "11111";
	
	ciphertext_word(127 downto 64) <= encrypted_data_2 when level = "11111";
	
	ciphertext_ready <= '0' when data_valid = '0' else '1' when level = "11111";
	
	
	
	process(clock_sig)
	           begin
		            if rising_edge(clock_sig) then
		              
		              	data_buffer_1<= encrypted_data_1;
			             data_buffer_2<= encrypted_data_2;
			         
			          if data_valid = '1' then
			            
			             	level<= std_logic_vector(unsigned(level) + 1);
			          else
				            level<= "00000";
			          end if;
		          end if;
	   end process;
end func;