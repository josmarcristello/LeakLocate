% This function checks if the folder(s) already exists. Creates if it
% (they) don't, and does nothing if it (they) do.
% Author: Josmar Cristello
%% Inputs
%    full_path: Full folder path.
%% Outputs
%    N/A: Creates folder(s)
%% Main
function verify_folder(full_path)
    if not(isfolder(full_path))
        mkdir(full_path)
    end
end

