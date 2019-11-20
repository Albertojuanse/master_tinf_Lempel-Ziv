function decodificadorLZ78_Sebastian_Lombranna_Alberto(filenameInputCompressed,filenameOutputUncompressed)
%DECODIFICADORLZ78_SEBASTIAN_LOMBRANNA_ALBERTO This decoder implements the Lempel-Ziv 78 algorithm

%% Retrieve information from ASCII input
% The coder ensures that an byte-even number of bits are used; count them.
input_file_id = fopen(filenameInputCompressed, 'r');
[i, count] = fread(input_file_id,'ubit8');
input_size_bits = count * 8;        % Size of the input in bits

%% Other variables
dictionary = containers.Map;        % Dictionary
i_entry = 0;                        % Dictionary index
total_bits = 0;                     % Bits of the file already readed

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
    num_bits = 8*ceil(size(next_i_entry_bin,2)/8);
    precision = strcat('ubit',num2str(num_bits));

    % Retrieve the dictionary index
    i_entry_retrieved = fread(input_file_id, 1, precision);
    
    % The character is always saved with precision 'ubit8'
    entry_retrieved = fread(input_file_id, 1, 'ubit8');
    if size(entry_retrieved, 2) == 0
        break;
    end
    % If finds a NULL character, is the last one (in this scenario)
    if entry_retrieved== 0
        if i_entry_retrieved > i_entry
            i_entry = i_entry + 1;
            dictionary(num2str(i_entry)) = entry_retrieved;
            fwrite(output_file_id, entry_retrieved,'ubit8');        
        else
            entry_found = dictionary(num2str(i_entry_retrieved));
            i_entry = i_entry + 1;
            dictionary(num2str(i_entry)) = [entry_found entry_retrieved];
            fwrite(output_file_id, [transpose(entry_found); entry_retrieved],'ubit8');
        end
        break;
    end
    
    % If the entry exists in the dictionary, use it; if not, create it
    % before use it.
    if i_entry_retrieved > i_entry
        i_entry = i_entry + 1;
        dictionary(num2str(i_entry)) = entry_retrieved;
        fwrite(output_file_id, entry_retrieved,'ubit8');        
    else
        entry_found = dictionary(num2str(i_entry_retrieved));
        i_entry = i_entry + 1;
        dictionary(num2str(i_entry)) = [entry_found entry_retrieved];
        fwrite(output_file_id, [transpose(entry_found); entry_retrieved],'ubit8');
    end
    
    % Count the bits retrieved
    total_bits = total_bits + num_bits + 8;
    
    if total_bits == input_size_bits
        break;
    end

end



%% Close input and output files
fclose(input_file_id);
fclose(output_file_id);

end