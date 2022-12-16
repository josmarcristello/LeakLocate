function [dataset_path] = return_dataset_folder()
    file_path = fileparts(mfilename('fullpath'));
    dataset_path = strrep(file_path,'functions','dataset');
end