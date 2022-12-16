function verify_folder(full_path)
%CREATE_FOLDER_IF Summary of this function goes here
%   Detailed explanation goes here
if not(isfolder(full_path))
    mkdir(full_path)
end
end

