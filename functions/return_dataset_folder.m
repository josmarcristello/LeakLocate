% This function returns the full path for the dataset folder of the project.
% Author: Josmar Cristello
%% Inputs
%    N/A
%% Outputs
%    dataset_path: Full path for the dataset folder of the project.
%% Main
function [dataset_path] = return_dataset_folder()
    file_path = fileparts(mfilename('fullpath'));
    dataset_path = strrep(file_path,'functions','dataset') + "\";
end