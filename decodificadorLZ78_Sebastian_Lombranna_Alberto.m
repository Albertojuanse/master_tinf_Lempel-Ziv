function decodificadorLZ78_Sebastian_Lombranna_Alberto(filenameInputCompressed,filenameOutputUncompressed)
%DECODIFICADORLZ78_SEBASTIAN_LOMBRANNA_ALBERTO This decoder implements the Lempel-Ziv 78 algorithm

%% Retrieve information from ASCII input
% The coder ensures that an byte-even number of bits are used; count them.
input_file_id = fopen(filenameInputCompressed, 'r');
[i, count] = fread(input_file_id,'ubit8');
input_size_bits = count * 8;        % Size of the input in bits

%% Other variables
dictionary = cell(count,1);     % Dictionary
i_entry = 0;                    % For size and last entry
total_bits = 0;                 % Bits of the file already readed

%% 

%input_file_id = fopen(filenameInputCompressed, 'r');
%input = [];
%input = [input fread(input_file_id, 1, 'ubit1')];
%input = [input fread(input_file_id, 1, 'ubit8')];
%input = [input fread(input_file_id, 1, 'ubit2')];
%input = [input fread(input_file_id, 1, 'ubit8')];
%input = [input fread(input_file_id, 1, 'ubit2')];
%input = [input fread(input_file_id, 1, 'ubit8')];
%input = [input fread(input_file_id, 1, 'ubit3')];
%input = [input fread(input_file_id, 1, 'ubit8')];
%input = [input fread(input_file_id, 1, 'ubit3')];
%input = [input fread(input_file_id, 1, 'ubit8')];
%input = [input fread(input_file_id, 1, 'ubit3')];
%input = [input fread(input_file_id, 1, 'ubit8')];
%input = [input fread(input_file_id, 1, 'ubit3')];
%input = [input fread(input_file_id, 1, 'ubit8')];
%input = [input fread(input_file_id, 1, 'ubit8')]
%input = [1 116 2 117 1 117 4 118 3 118 6 119 7 120 3];

%% Execution
input_file_id = fopen(filenameInputCompressed, 'r');
output_file_id = fopen(filenameOutputUncompressed, 'a');

% For every bit in the file
while 1
    
    % Each codeword is the composite of the dictionary entry index and the
    % next character
    
    % Precision needed to decodify the dictionary next entry; when the
    % codeword is coded, the dictionary have an extra entry there.
    next_i_entry = i_entry + 1;
    next_i_entry_bin = dec2bin(next_i_entry);
    num_bits = size(next_i_entry_bin,2);
    precision = strcat('ubit',num2str(num_bits));

    % Retrieve the dictionary index
    i_entry_retrieved = fread(input_file_id, 1, precision);
    
    % The character is always saved with precision 'ubit8'
    entry_retrieved = fread(input_file_id, 1, 'ubit8');
    if size(entry_retrieved, 2) == 0
        break;
    end
    
    % If the entry exists in the dictionary, use it; if not, create it
    % before use it.
    if i_entry_retrieved > i_entry
        i_entry = i_entry + 1;
        dictionary{i_entry,1} = [entry_retrieved];
        fwrite(output_file_id, [entry_retrieved],'ubit8');        
    else
        entry_found = dictionary{i_entry_retrieved};
        i_entry = i_entry + 1;
        dictionary{i_entry,1} = [entry_found entry_retrieved];
        fwrite(output_file_id, [transpose(entry_found); entry_retrieved],'ubit8');
    end
    
    % Count the bits retrieved
    total_bits = total_bits + num_bits + 8;

    % Verify if the file is reaching its end.
    % If the file is reaching its end, the codification was different; the
    % number of bits needed for the real dictionary index and the rest
    % until reach even-byte file.
    % This following lines calculates the bits saved in the file when the 
    % last codeword was generated by the coder; break the while loop if the
    % number of bits is equals to the ones left in the file.
    next_i_entry = i_entry + 1;
    next_i_entry_bin = dec2bin(next_i_entry)
    next_num_bits = size(next_i_entry_bin,2)
    next_total_bits = total_bits + next_num_bits + 8
    next_odd_bits = mod(next_total_bits,8)
    if next_odd_bits == 0
        % Just 8 bits
    else
        next_bits_left = 8 - next_odd_bits;
        next_total_bits = next_total_bits + next_bits_left;
    end
    
    if next_total_bits == input_size_bits
        
        % Last execution
        
        if next_odd_bits == 0
            % Just 8 bits
            precision = strcat('ubit',num2str(next_num_bits));    
        else
            next_bits_left = 8 - next_odd_bits;            
            precision = strcat('ubit',num2str(next_num_bits + next_bits_left));
        end
        
        % Retrieve the dictionary index
        i_entry_retrieved = fread(input_file_id, 1, precision);
        entry_retrieved = fread(input_file_id, 1, 'ubit8');

        % If the entry exists in the dictionary, use it; if not, create it
        % before use it.
        if i_entry_retrieved > next_i_entry
            % ERROR; CAN'T HAPPEN
            i_entry = i_entry + 1;
            dictionary{i_entry,1} = [entry_retrieved];
            fwrite(output_file_id, [entry_retrieved],'ubit8');    
            fwrite(output_file_id, [69; 82; 82; 79; 82],'ubit8');
        else    
            entry_found = dictionary{i_entry_retrieved};
            i_entry = i_entry + 1;
            dictionary{i_entry,1} = [entry_found entry_retrieved];
            fwrite(output_file_id, [transpose(entry_found); entry_retrieved],'ubit8');
        end

        % End of execution
        next_total_bits
        break;
    end

end



%% Close input and output files
fclose(input_file_id);
fclose(output_file_id);

end