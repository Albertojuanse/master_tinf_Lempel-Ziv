function codificadorLZ78_Sebastian_Lombranna_Alberto(filenameInputUncompressed,filenameOutputCompressed)
%CODIFICADORLZ78_SEBASTIAN_LOMBRANNA_ALBERTO This coder implements the Lempel-Ziv 78 algorithm

%% Retrieve ASCII characters from input

input_file_id = fopen(filenameInputUncompressed);
input = fread(input_file_id);
fclose(input_file_id);

%% Algorithm

input_size = size(input, 1);        % Total number of characters
input_pointer = 1;                  % Points the current character analized
pointer_offset = 0;                 % Offset for point the dictionaries
dictionary = {};                    % Dictionary
output = [];                        % Output

% The algorithm will analyze each character one by one; a pointer will be
% uploaded while codification is done.
while  input_pointer < input_size + 1
    
    % The next while loop executes until a codeword is generated
    flag_next_codeword = false;
    
    % Search the current input until a codeword can be generated; upload
    % the dictionary when done
    while flag_next_codeword == false
        
        % Get the current dictionay size for search in it
        size_dictionary = size(dictionary, 1);
        
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
        
        % Search in the dictionary for the most similar entry
        % Sictionary schematic:
        %   { [1]   ;
        %     [1 2] ;
        %     [2]   ;
        %     [2 3]
        %   }

        % the most similar entry to [ABC] is [AB], but if it not exists is [A]
        i_most_similar_entry = 0;
        for i_entry = 1:size_dictionary
    
            current_entry = dictionary{i_entry};
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

