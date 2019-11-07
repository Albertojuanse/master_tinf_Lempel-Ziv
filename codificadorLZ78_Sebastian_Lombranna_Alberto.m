function codificadorLZ78_Sebastian_Lombranna_Alberto(filenameInputUncompressed,filenameOutputCompressed)
%CODIFICADORLZ78_SEBASTIAN_LOMBRANNA_ALBERTO This coder implements the Lempel-Ziv 78 algorithm

%% Retrieve ASCII characters from input

input_file_id = fopen(filenameInputUncompressed);
input = fread(input_file_id);
fclose(input_file_id);

%% Algorithm

input_size = size(input, 1);        % Total number of characters
input_pointer = 1;                  % Points the current character analized
dictionary = {};                    % Dictionary
output = [];                        % Output

% The algorithm will analyze each character one by one; a pointer will be
% uploaded while codification is done.
while  input_pointer < input_size + 1
    
    % The next while loop executes until a codeword is generated
    flag_next_codeword = false;
    
    % Search the current inputuntil a codeword can be generated; upload
    % the dictionary when done
    while flag_next_codeword
        
        % Get the current dictionay size for search in it
        size_dictionary = size(dictionary, 1);
        
        % Search in the dictionary for the most similar entry
        % Sictionary schematic:
        %   { [1]
        %     [1 2]
        %     [2]
        %     [2 3]
        %   }
        %
        % the most similar entry to [ABC] is [AB], but if it not exists is [A]
        i_most_similar_entry = 0;
        for i_entry = 1:size_dictionary
    
            current_entry = dictionary{i_entry}
            size_current_entry = size(current_entry, 2);

        end
        
        % If no entry was found
        if i_most_similar_entry == 0
            
        else
            
        end
        
        % Compose the codeword
        
        flag_next_codeword = true;
        
    end
    
end

%% Save ASCII characters to output
output_file_id = fopen(filenameOutputCompressed);
fwrite(output_file_id, [], 'uint8');
fclose(output_file_id);

end

