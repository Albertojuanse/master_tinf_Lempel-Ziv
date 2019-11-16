function codificadorLZ78_Sebastian_Lombranna_Alberto(filenameInputUncompressed,filenameOutputCompressed)
%CODIFICADORLZ78_SEBASTIAN_LOMBRANNA_ALBERTO This coder implements the Lempel-Ziv 78 algorithm

%% Retrieve ASCII characters from input

input_file_id = fopen(filenameInputUncompressed);
input = fread(input_file_id);
fclose(input_file_id);

%% Variables

input_size = size(input, 1);        % Total number of characters
input_pointer = 1;                  % Points the current character analized
pointer_offset = 0;                 % Offset for point the dictionaries
dictionary = {};                    % Dictionary
output = [];                        % Output

%% Algorithm description
% coge la entrada i
% coge la entrada j del diccionario
%   si coincide la entrada i con el caracter 1 de la entrada j
%       ¿hay más caracteres en la entrada?
%       coge la entrada i + 1
%       si coincide la entrada i + 1 con el caracter 2 de la entrada j
%           ¿hay más caracteres en la entrada? -> SI
%           coge la entrada i + 2
%           (···)
%
%       si coincide la entrada i + 1 con el caracter 2 de la entrada j
%           ¿hay más caracteres en la entrada? -> NO
%               cadena válida; guardarla, no habrá otra igual
%
%       si no coincide la entrada i + 1 con el caracter 2 de la entrada j
%           descartar; hay otra que es la buscada pero no esta
%
%   si no coincide la entrada i con el caracter 1 de la entrada j
%   	descartar; la buscada no es esta
%
% OJO: break en el momento que se encuentre una cadena del tamaño
% máximo almacenado
%
% OJO: break en el momento que se finalice el diccionario
% preinicializado; llevar un conteo

% -> str_cmp
% -> dec2bin(,8) <- 8 bits ; uint8() lo satura
% -> ojo con parseing a más 
% -> dec2bin( id_entrada , ceil(log2(id_entrada)))

% Sictionary schematic:
%   { [1]   ;
%     [1 2] ;
%     [2]   ;
%     [2 3]
%   }

%% Execution

% The algorithm will analyze each character one by one, using a pointers
% for the entries analyzed
while  input_pointer <= input_size
    
    % Search the current input and following until a codeword can be
    % generated
    % Sictionary schematic:
    %   { [1]   ;
    %     [1 2] ;
    %     [2]   ;
    %     [2 3]
    %   }

    % For each entry of the dictionary
    candidate_entry_found = false;
    i_entry_found = -1;
    size_dictionary = size(dictionary, 1);
    
    for i_entry = 1:size_dictionary
        entry = dictionary{i_entry};
        entry_size = size(entry, 2);

        % Inspec the entry for searching if the first character is the
        % searched one;
        % then, if so, verify the second character and so on.
        for i_entry_character = 1:entry_size

            character = entry(1, i_entry_character);

            % The input character analyzed is the current if is the first
            % entry, the current+1 if its the second...                
            pointer_offset = (i_entry_character -1);

            if character == input(input_pointer + pointer_offset)
                % This character is equals to the entry one.
                candidate_entry_found = yes;
            else                    
                % This character is not equals to th
                candidate_entry_found = false;
                break;

            end
        end

        % Refresh the entry found if this one is longer than the
        % previous one
        if  candidate_entry_found
            if i_entry_found < 0
                i_entry_found = i_entry;
            else
                last_entry_found_size = size(dictionary{i_entry_found}, 2);
                new_candidate_entry_size = size(dictionary{i_entry}, 2);

                if new_candidate_entry_size > last_entry_found_size
                    i_entry_found = i_entry;
                end
            end
        end
        % OJO: break en el momento que se encuentre una cadena del tamaño
        % máximo almacenado
        %
        % OJO: break en el momento que se finalice el diccionario
        % preinicializado; llevar un conteo
    end
    
    % First execution special
    if input_pointer == 1
        
        % Upload the dictionary
        dictionary = {[input(1)]};
        input_pointer = 2;
        
        % Compose the codeword        
        output = [output 1 [input(1)]
    else
        
        % Upload the dictionary
        entry_found = dictionary{i_entry_found};
        i_next_input_after_entry = input_pointer + size(entry_found) + 1;
        next_input_after_entry = input(i_next_input_after_entry);
        dictionary{end + 1,1} = [entry_found next_input_after_entry];
        
        % Compose the codeword        
        output = [output i_entry_found input_pointer(i_next_input_after_entry)]
        
        % Depending of the value of pointer_offset alue, if the entry is
        % found and a new codeword is compose, the input_pointer must be
        % uploaded
        input_pointer =+ size(dictionary{i_entry_found}) + 2;
    end
end

%% Save ASCII characters to output
output_file_id = fopen(filenameOutputCompressed);
fwrite(output_file_id, output, 'uint8');
fclose(output_file_id);

end

