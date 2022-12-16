% Generates a CWT wavelet from time-series data (Converts a 1D signal to 2D images)
% Author: Josmar Cristello
%% Inputs
%    data: Full path for "Results" object. Should contain a pressure and velocity sub-objects.
%    mode: "Pressure" or "Velocity", and transforms the corresponding property. Defaults to pressure.
%    location: "inlet", "outlet", or "both".
%    saveResults: if "true" saves the images. if "false", doesn't.
%    fs: Sampling frequency (in Hz). Default value iz 2 Hz.
%    wname: Mother wavelet name, defaults to Morlet (Gabor).
%% Outputs
%    N/A: 2x Image files (CWT), corresponding to the Outlet and Inlet transformation.
%    Image name is based on 'data' name. Subfolder created is also based on
%    'data' subfolder.
%% Notes
%    The DC value obtained from Matlab is twice the actual DC value of the
%    signal.
%% TODO
%% Main
  
function [cwt_inlet, cwt_outlet] = generate_cwt(data, mode, location, saveResults, wname, fs)    
    %% Function defaults    
    % Default value → pressure
    if nargin < 2
        mode = "pressure";
    end
    % Default value → true ('inlet' and 'outlet')
    if nargin < 3
        location = "both";
    end
    % Default value → true (Save Results)
    if nargin < 4
        saveResults = true;
    end
    % Default value → Morlet (Garbor)    
    if nargin < 5
        wname = "amor"; 
    end
    % Default value → 2 Hz
    if nargin < 6
        fs = 2; 
    end

    % Load the results object.
    Results = load(data);
    Results = Results.Results;

    %% Generating filename and output folder
    %  Output Filename is based on Input filename.
    %  Output subfolder is based on Input subfolder.
    [fPath, fName, ~] = fileparts(data);
    output_folder = return_output_folder();
    cwt_folder = "1. CWT";
    output_subfolder = strsplit(fPath,filesep); % Gets the last folder for the input file (mimics it in the output)
    output_folder  = fullfile(output_folder, cwt_folder, output_subfolder(end));
    verify_folder(output_folder);
    %output_folder = output_folder + cwt_folder + "/" + output_subfolder + "/";
    disp(output_folder);

    %% Assumptions that depend on the Results object.
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
    if lower(location) == "inlet" || lower(location) == "both"
        cfs_p = abs(cwt(inlet_data,wname,fs));
        im_p = ind2rgb(im2uint8(rescale(cfs_p)),jet(110));
        im_p = imresize(im_p,[224 224]);
        cwt_inlet = im_p;
        cwt_outlet = "";
    end
    
    % Outlet
    if lower(location) == "outlet" || lower(location) == "both"
        cfs_p = abs(cwt(outlet_data,wname,fs));
        im_p = ind2rgb(im2uint8(rescale(cfs_p)),jet(110));
        im_p = imresize(im_p,[224 224]);
        cwt_outlet = im_p;
        cwt_inlet = "";
    end

    if saveResults
        if lower(location) == "inlet" || lower(location) == "both"
            imwrite(cwt_inlet , fullfile(output_folder, fName + "_" + lower(mode) + "_inlet" + ".jpg"));
        end
        if lower(location) == "outlet" || lower(location) == "both"
            imwrite(cwt_outlet, fullfile(output_folder, fName + "_" + lower(mode) + "_outlet" + ".jpg"));
        end        
    end
end