% This function returns the full path for the output folder of the project.
% Author: Josmar Cristello
%% Inputs
%    N/A
%% Outputs
%    dataset_path: Full path for the output folder of the project.
%% Main

function [output_path] = return_output_folder()
    file_path = fileparts(mfilename('fullpath'));
    output_path = strrep(file_path,'functions','outputs') + "\";
end