% Generates a CWT wavelet from time-series data (Converts a 1D signal to 2D images)
% Author: Josmar Cristello
%% Inputs
%    data: Full path for "Results" object. Should contain a pressure and velocity sub-objects.
%    mode: Accepts "Pressure" or "Velocity", and transforms the
%    corresponding property. Defaults to pressure.
%    fs: Sampling frequency (in Hz). Default value iz 2 Hz.
%    wname: Mother wavelet name, defaults to Morlet (Gabor).
%% Outputs
%    N/A: 2x Image files (CWT), corresponding to the Outlet and Inlet transformation.
%    Image name is based on 'data' name.
%% Notes
%    The DC value obtained from Matlab is twice the actual DC value of the
%    signal.
%% To-do

%% Main

% path = 'dataset\2. Simulated\batch sim 2\';                 % Input Data
% cnn_path = 'dataset\3. WT_Converted\batch sim 2\velocity\'; % Output Data (where to save)
%filename = strcat(path, name, '.mat'); % for leak dataset 
  
function generate_cwt(data, mode, wname, fs)    
    % Default value → pressure
    if nargin < 2
        mode = "pressure";
    end
    % Default value → Morlet (Garbor)    
    if nargin < 3
        wname = "amor"; 
    end
    % Default value → 2 Hz
    if nargin < 4
        fs = 2; 
    end

    % Load the results object.
    Results = load(data);
    Results = Results.Results;

    % Generates output folder and file name (based on input name)
    [fPath, fName, ~] = fileparts(data);
    output_folder = return_output_folder();
    cwt_folder = "1. CWT";
    output_subfolder = strsplit(fPath,filesep); % Gets the last folder for the input file (mimics it in the output)
    output_folder  = fullfile(output_folder, cwt_folder, output_subfolder(end));
    mkdir(output_folder);
    %output_folder = output_folder + cwt_folder + "/" + output_subfolder + "/";
    disp(output_folder);

    % Assumptions that depend on the Results object.
    inlet_index = 1;
    outlet_index = size(Results.Pressure,2);
  
    if lower(mode) == "pressure"
        inlet_data = Results.Pressure(:,inlet_index);   % Inlet Pressure
        outlet_data = Results.Pressure(:,outlet_index); % Outlet Pressure
    elseif lower(mode) == "velocity"
        inlet_data = Results.Velocity(:,inlet_index);   % Inlet Velocity
        outlet_data = Results.Velocity(:,outlet_index); % Outlet Velocity
    else 
        error("Mode not recognized. Supported modes are pressure and velocity.");
    end
    
    %% CWT Generation
    % Inlet
    cfs_p = abs(cwt(inlet_data,wname,fs));
    im_p = ind2rgb(im2uint8(rescale(cfs_p)),jet(110));
    imwrite(imresize(im_p,[224 224]),fullfile(output_folder,fName + "_inlet" + ".jpg"));
    
    % Outlet
    cfs_p = abs(cwt(outlet_data,wname,fs));
    im_p = ind2rgb(im2uint8(rescale(cfs_p)),jet(110));
    imwrite(imresize(im_p,[224 224]),fullfile(output_folder, fName + "_outlet" + ".jpg"));
end