library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--DECRYPTION

entity xtea_decrypt is
	port(
		--inputs
		clock_sig				:in std_logic;
		ciphertext_valid			:in std_logic;
		ciphertext_word			:in std_logic_vector(127 downto 0);
		key_word				:in std_logic_vector(127 downto 0);
		
		--outputs
		data_ready	:out std_logic;
		data_word	:out std_logic_vector(127 downto 0));
end xtea_decrypt;

architecture func of xtea_decrypt is	

	component subkey_cal_decrypt port(
	  subkey_clk			:in std_logic;
		subkkey_level			:in std_logic;
		
		subkey_key_valid	:in std_logic;
		subkey_key_word		:in std_logic_vector(127 downto 0);
		-- the two holding areas for the sub key
		subkey_set_1 	:out std_logic_vector(31 downto 0);
		subkey_set_2 	:out std_logic_vector(31 downto 0));
	end component;	
	
	
	component xtea_tean_decrypt port(
		decrypt_clk 					:in std_logic;
		decrypt_data_valid			:in std_logic;
		decrypt_data_word			:in std_logic_vector(63 downto 0);
		decrypt_subkey				:in std_logic_vector(31 downto 0);
		decrypt_ciphertext_word	:out std_logic_vector(63 downto 0));
	end component;
	
	
	
	
	 signal level 	 		 : std_logic_vector(4 downto 0) := "00000";
	
	 signal subkey_1	 	 : std_logic_vector(31 downto 0);
	 signal subkey_2	 	 : std_logic_vector(31 downto 0);
	
	 signal data_to_decrypt_1 	 : std_logic_vector(63 downto 0);
	 signal data_to_decrypt_2 	 : std_logic_vector(63 downto 0);
	
	 signal decrypted_data_1: std_logic_vector(63 downto 0);
	 signal decrypted_data_2: std_logic_vector(63 downto 0);
	
	 signal buff_1 	 : std_logic_vector(63 downto 0);     --data buffers
	 signal buff_2 	 : std_logic_vector(63 downto 0);
	
	 signal half_tean_word_1: std_logic_vector(63 downto 0);
	 signal half_tean_word_2: std_logic_vector(63 downto 0);
	
	
	
	
	
	
begin
	
	
	decrypt_1a : xtea_tean_decrypt port map(
		decrypt_clk					=> clock_sig,
		decrypt_data_valid			=> ciphertext_valid,
		decrypt_data_word			=> data_to_decrypt_1,
		decrypt_subkey				=> subkey_1,	
		decrypt_ciphertext_word	=> half_tean_word_1);
		
	decrypt_1b : xtea_tean_decrypt port map(
		decrypt_clk					=> clock_sig,
		decrypt_data_valid			=> ciphertext_valid,
		decrypt_data_word			=> half_tean_word_1,
		decrypt_subkey				=> subkey_2,	
		decrypt_ciphertext_word	=> decrypted_data_1);
	
	decrypt_2a : xtea_tean_decrypt port map(
		decrypt_clk					=> clock_sig,
		decrypt_data_valid			=> ciphertext_valid,
		decrypt_data_word			=> data_to_decrypt_2,
		decrypt_subkey				=> subkey_1,	
		decrypt_ciphertext_word	=> half_tean_word_2);
		
	decrypt_2b : xtea_tean_decrypt port map(
		decrypt_clk					=> clock_sig,
		decrypt_data_valid			=> ciphertext_valid,
		decrypt_data_word			=> half_tean_word_2,
		decrypt_subkey				=> subkey_2,	
		decrypt_ciphertext_word	=> decrypted_data_2);
	         
	         
	         
	         
	 sk1 : subkey_cal_decrypt port map(
	  subkey_clk 			=>clock_sig,
		subkkey_level		=>level(0),
		subkey_key_valid 	=>ciphertext_valid,
		subkey_key_word		=>key_word,
		subkey_set_1		=>subkey_1,
		subkey_set_2		=>subkey_2);
		
		
				
				
	data_to_decrypt_1 <= ciphertext_word(63 downto 0) 	when level = "00000" else buff_1;
						
	data_to_decrypt_2 <= ciphertext_word(127 downto 64) 	when level = "00000" else buff_2;
	
	data_word(63 downto 0) <= decrypted_data_1 when level = "11111";
	
	data_word(127 downto 64) <= decrypted_data_2 when level = "11111";
	
	data_ready <= '0' when ciphertext_valid = '0' else '1' when level = "11111";
	
	
		
		
		
	process(clock_sig)
	begin
		if rising_edge(clock_sig) then
			     buff_1 <= decrypted_data_1;
			     buff_2 <= decrypted_data_2;
			if ciphertext_valid = '1' then
			  
			  
				    level <= std_logic_vector(unsigned(level) +1);
				    
				    
			else
			  
				level <= "00000";
				
			end if;
		end if;
	end process;
end func;