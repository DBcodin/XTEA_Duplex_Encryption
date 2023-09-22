library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

--CONVERT THE C CODE INTO VHDL, BE AWARE THAT THE C CODE WILL WORK SEQUENTIALLY (ONE AFTER ANOTHER) WHERE VHDL WILL DO ALL COMMAND AT ONCE
-- TO MAKE VHDL SO SOMETHING SEQUENTIALLY WE MUST USE BUFFERS (ASSUMING THESE WORK USING THE CLOCK)

-- This code will need to be able to split the input data into two "key words" (by cutting it in half and assigning each half to a value), maby also quartering instead because input will be 128 bit and
-- i have 4 keys to use


--Psuedo

-- declare entity
-- declare ports


-- architecture function of the simplex (basically means 1 way, better for fast information sending)

-- set up signals:
--   set up with correct number of vector spaces in each to allow to input of 4 encryption keys, 
--    1 128 bit input data word (data word), 
--    4 spaces for cut up input word (32 bit each)... for example V(0), V(1), V(2)......
-- ,    then 4 output spaces for the encrypted data word to go in, 
--      THEN output that will be used to put all ow the flipped encryption data key words back together, 
--      also a signal for delta?
-- (should i have the clock on a sepearate file?)










entity top_xtea_duplex is
  
     PORT(
            --inputs
            clk                 : IN  STD_LOGIC;
            reset_n             : IN  STD_LOGIC;
            data_word_in        : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
            data_valid          : IN  STD_LOGIC; -- this will be used for flags
            ciphertext_word_in  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
            ciphertext_valid    : IN  STD_LOGIC;
            key_word_in         : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
            key_valid           : IN  STD_LOGIC;
            
            
            --outputs
            key_ready           : OUT STD_LOGIC;
            ciphertext_word_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            ciphertext_ready    : OUT STD_LOGIC;
            data_word_out       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            data_ready          : OUT STD_LOGIC
        );end top_xtea_duplex;
        
        
        
        
  architecture func of top_xtea_duplex is
    
-- set up signals:
--      set up with correct number of vector spaces in each to allow to input of 4 encryption keys, 
--      1 128 bit input data word (data word), 
--      4 spaces for cut up input word (32 bit each)... for example V(0), V(1), V(2)......
-- ,    then 4 output spaces for the encrypted data word to go in, 
--      THEN output that will be used to put all ow the flipped encryption data key words back together, 
--      also a signal for delta?
-- (should i have the clock on a sepearate file?)
    
    
  --signals get a new key word? 1
    signal key_word_in_storage : std_logic_vector(127 DOWNTO 0);
    signal key_word_count : std_logic_vector(1 DOWNTO 0); -- this will be in charge of IF information should be passed to the next step
    signal key_accepted : std_logic; --key word set
    
   
    --get a new data word for encryption step 2
    signal enc_data_word_in : std_logic_vector(127 DOWNTO 0);
     signal enc_data_word_count : std_logic_vector(1 DOWNTO 0);
    signal enc_data_word_accepted : std_logic;
  
  
    --signals to show encrytpted word  3
    signal enc_data_out_count : std_logic_vector(1 DOWNTO 0);
    signal enc_data_word_out : std_logic_vector(127 DOWNTO 0);
    signal enc_data_encrypted :std_logic;
     
     
     --decryption part
     
     
    --get encrypted data to be decrypted 4
    signal dec_data_word_in : std_logic_vector(127 DOWNTO 0);
    signal dec_data_count : std_logic_vector(1 DOWNTO 0);
    signal dec_data_word_accepted : std_logic;
    
    
    ----signals to show decrytpted word  5
    signal dec_data_out_count : std_logic_vector(1 DOWNTO 0);
    signal dec_data_word_out : std_logic_vector(127 DOWNTO 0);
    signal dec_data_decrypted :std_logic;

    
    -- send encrypted data to output variable
    
    
    -- input encrypted word to decrypt variable
    
    -- output decrypted word to output variable
    
    
    
    
    
  --call in subkey calc enc
    
  --call in subkey calc dec 
  
  --call in exteral parts:
  component xtea_encrypt port(
      clock_sig :in std_logic;
      data_word :in std_logic_vector(127 DOWNTO 0);
      data_valid :in std_logic;
      key_word :in std_logic_vector(127 DOWNTO 0);
      
      ciphertext_ready :out std_logic; 
      ciphertext_word :out std_logic_vector(127 DOWNTO 0)
      );
  end component;      
          
  --call in xtea dec
  component xtea_decrypt port(
      clock_sig :in std_logic;
      ciphertext_word :in std_logic_vector(127 DOWNTO 0);
      ciphertext_valid :in std_logic;
      key_word :in std_logic_vector(127 DOWNTO 0);
      
      data_ready :out std_logic; 
      data_word :out std_logic_vector(127 DOWNTO 0)
      );
  end component;   
          
  
  
  
  
 begin
   
  --set up external parts       
 
  enc_comp : xtea_encrypt port map(
      clock_sig           => clk,
      data_word           => enc_data_word_in,
      data_valid          => enc_data_word_accepted,
      key_word            => key_word_in_storage,
      ciphertext_ready    => enc_data_encrypted,
      ciphertext_word     => enc_data_word_out);
  
  dec_comp : xtea_decrypt port map(
      clock_sig           => clk,
      ciphertext_word     => dec_data_word_in,
      ciphertext_valid    => dec_data_word_accepted ,
      key_word            => key_word_in_storage,
      data_ready          => dec_data_decrypted,
      data_word           => dec_data_word_out);         
          
          
   --------------------
 
 
   
   ------------------------       
          
  --set up processes
 
 --general plan 
 -- set key word
 -- set encryption word
 -- 
 
  	--set when the key has been expanded
	key_ready <= key_accepted  when key_valid = '0' else
					 '0';
 
            
   moving_information : process (clk)
      begin
     if rising_edge(clk) then
    --add in timeing bit?
    
    
    -- bit for storing in new key -DONE
      if key_valid = '1' then 
                                   case key_word_count is
                                    when "00" =>
                                        key_word_in_storage(127 downto 96) <= key_word_in;
                                        key_accepted <= '0';
                                  	when "01" =>
						                            key_word_in_storage(95 downto 64)	<= key_word_in;
					                         when "10" =>
						                            key_word_in_storage(63 downto 32)	<= key_word_in;
					                         when "11" =>
						                            key_accepted <= '1';
						                            key_word_in_storage(31 downto 0)	<= key_word_in;
					                         when others => 
					                                   key_accepted <= '0';
				                          end case;
        key_word_count <= std_logic_vector(unsigned(key_word_count) +1);
			else
			  
				key_word_count <= "00";
			end if;



  --bit for storing new data word -DONE
			if data_valid = '1' then
			                         	case enc_data_word_count is
				                        	when "00" => -- when enc_data_word_count is 0
					                         	enc_data_word_in(127 downto 96)	<= data_word_in; -- move the first 32 bits of the data word to the first last 32 bits of enc data word in
						                        enc_data_word_accepted <= '0'; -- set the data word accepted to 0
					                       when "01" =>
						                        enc_data_word_in(95 downto 64)	<= data_word_in;
					                       when "10" =>
						                        enc_data_word_in(63 downto 32)	<= data_word_in;
					                       when "11" =>
						                        enc_data_word_in(31 downto 0)		<= data_word_in;
						                        enc_data_word_accepted <= '1';
				                        	when others =>
						                        enc_data_word_accepted <= '0';
				                          end case;
				enc_data_word_count <= std_logic_vector(unsigned(enc_data_word_count) +1);
			else
				enc_data_word_count <= "00";
			end if;
  
  
  
--bit for outputing encrypted data to output word -DONE

      if enc_data_encrypted = '1' then
				                      case enc_data_out_count is
					                       when "00" =>
						                        ciphertext_ready <= '1';
						                        ciphertext_word_out <= enc_data_word_out(127 downto 96);
					                       when "01" =>
					                         	ciphertext_word_out <= enc_data_word_out(95 downto 64);
					                       when "10" =>
					                         	ciphertext_word_out <= enc_data_word_out(63 downto 32);
					                       when "11" =>
					                         	ciphertext_word_out <= enc_data_word_out(31 downto 0);
					                       when others =>
					                         	ciphertext_ready <= '0';
				                          end case;
				enc_data_out_count <= std_logic_vector(unsigned(enc_data_out_count) +1);
			else
				enc_data_out_count <= "00";
				ciphertext_ready <= '0';
			end if;



 	--input encrypted word for decryption -DONE
 	
 			if ciphertext_valid = '1' then
				                        case dec_data_count is
					                         when "00" =>
						                          dec_data_word_in(127 downto 96)	<= ciphertext_word_in;
						                          dec_data_word_accepted <= '0';
					                         when "01" =>
						                          dec_data_word_in(95 downto 64)	<= ciphertext_word_in;
					                         when "10" =>
						                          dec_data_word_in(63 downto 32)	<= ciphertext_word_in;
					                         when "11" =>
						                          dec_data_word_in(31 downto 0)		<= ciphertext_word_in;
						                          dec_data_word_accepted <= '1';
					                         when others =>
						                          dec_data_word_accepted <= '0';
				                            end case;
				dec_data_count <= std_logic_vector(unsigned(dec_data_count) +  1);
			else
				dec_data_count <= "00";
			end if;
 	
 	
 	
 	--output decrypted word
 
			if dec_data_decrypted = '1' then
				                          case dec_data_out_count is
					                           when "00" =>
						                            data_ready <= '1';
						                            data_word_out <= dec_data_word_out(127 downto 96);
					                           when "01" =>
						                            data_word_out <= dec_data_word_out(95 downto 64);
				                            	when "10" =>
						                            data_word_out <= dec_data_word_out(63 downto 32);
					                           when "11" =>
						                            data_word_out <= dec_data_word_out(31 downto 0);
					                           when others =>
						                            data_ready <= '0';
				                              end case;
			     	dec_data_out_count <= std_logic_vector(unsigned(dec_data_out_count) +  1);
		      	else
			     	dec_data_out_count <= "00";
				      data_ready <= '0';
		      	end if;
		      end if;
	     end process;	
    end func;
 