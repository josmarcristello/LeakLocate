function [output_path] = return_output_folder()
    file_path = fileparts(mfilename('fullpath'));
    output_path = strrep(file_path,'functions','outputs');
end