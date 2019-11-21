function decodificadorLZW_Sebastian_Lombranna_Alberto(filenameInputCompressed,filenameOutputUncompressed)
%DECODIFICADORLZW_SEBASTIAN_LOMBRANNA_ALBERTO This decoder implements the Lempel-Ziv-Welch algorithm

%% Retrieve information from ASCII input
% The coder ensures that an byte-even number of bits are used; count them.
input_file_id = fopen(filenameInputCompressed, 'r');
[i, count] = fread(input_file_id,'ubit8');
input_size_bits = count * 8;        % Size of the input in bits

%% Other variables
dictionary = containers.Map;        % Dictionary
i_entry = 0;                        % Dictionary index
total_bits = 0;                     % Bits of the file already readed

%% Dictionary inizialization
for i_ascii = 1:256   
   i_entry = i_entry + 1;
   dictionary(num2str((i_ascii - 1))) = i_ascii - 1;    
end

%% Execution
input_file_id = fopen(filenameInputCompressed, 'r');
output_file_id = fopen(filenameOutputUncompressed, 'a');

% First symbol extraction
last_i_entry_retrieved = fread(input_file_id, 1, 'ubit16');
last_entry_found = dictionary(num2str(last_i_entry_retrieved));
fwrite(output_file_id, last_entry_found, 'ubit8');

% For every bit in the file
while 1
    
    % Each codeword is the composite of the dictionary entry index and the
    % next character
    
    % Precision needed to decodify the dictionary next entry; when the
    % codeword is coded, the dictionary have an extra entry there.
    next_i_entry = i_entry + 2;
    next_i_entry_bin = dec2bin(next_i_entry);
    num_bits = 8*ceil(size(next_i_entry_bin,2)/8);
    precision = strcat('ubit',num2str(num_bits));

    % Retrieve the dictionary index
    i_entry_retrieved = fread(input_file_id, 1, precision);
    
    if size(i_entry_retrieved, 2) == 0
        break;
    end
    
    % Get the entry for the retrieved index
    try
        entry_found = dictionary(num2str(i_entry_retrieved));
    catch exception
        % Preventing the symbol-symbol-collision issue
        entry_found = dictionary(num2str(last_i_entry_retrieved));
        entry_found = [entry_found entry_found(1,1)];
    end
    
    % Write the entry
    fwrite(output_file_id, transpose(entry_found),'ubit8');
    
    % Update the dictionary
    i_entry = i_entry + 1; 
    dictionary(num2str(i_entry)) = [last_entry_found entry_found(1,1)];
    last_i_entry_retrieved = i_entry_retrieved;
    last_entry_found = entry_found;
    
     % Count the bits retrieved
    total_bits = total_bits + num_bits;
    
    if total_bits == input_size_bits
        break;
    end

end

%% Close input and output files
fclose(input_file_id);
fclose(output_file_id);

end