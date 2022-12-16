% Function to Generate a CWT wavelet from time-series data
% Converts a 1D signal to 2D images
% Inputs: matlab object (.mat) with a "Pressure" object and a "Velocity" object.
% Outputs: 2x CWT Images, one for the Outlet, one for the Inlet

%% To-do: Add mode
function [m,s] = generate_cwt(data, wname, fs)
    % data → "Results" object. Should contain a pressure and velocity sub-objects.
    % pressure(x,y) → 
    % velocity(x,y) → 
    % fs → sampling frequency (in Hz). Default value iz 2 Hz
    % wname → mother wavelet name, defaults to Morlet (Gabor)

    if nargin < 2
        wname = 'amor'; % Default value → Morlet (Garbor)
    end

    if nargin < 3
        fs = 2; % Default value → 2 Hz
    end
        
    path = 'dataset\2. Simulated\batch sim 2\';                 % Input Data
    cnn_path = 'dataset\3. WT_Converted\batch sim 2\velocity\'; % Output Data (where to save)
    output_folder = ''
    filename = strcat(path, name, '.mat'); % for leak dataset 
    Results = load(filename);
    Results = Results.Results;
    
    inlet_index = 1;
    outlet_index = size(Results.Pressure,2);

    inlet_data = Results.Pressure(:,inlet_index); % Inlet Pressure
    outlet_data = Results.Pressure(:,outlet_index); % Outlet Pressure
    %inlet_data = Results.Velocity(:,inlet_index); % Inlet Pressure
    %outlet_data = Results.Velocity(:,outlet_index); % Outlet Pressure
    

    % CWT Generation
    % Inlet Pressure
    cfs_p = abs(cwt(inlet_data,wname,fs));
    im_p = ind2rgb(im2uint8(rescale(cfs_p)),jet(110));
    imFileName_p = strcat(name,'_inlet','.jpg');    
    Root_da_p = fullfile(cnn_path);Loc_da_p = fullfile(Root_da_p);
    imwrite(imresize(im_p,[224 224]),fullfile(Loc_da_p,imFileName_p));
    
    % Outlet Pressure
    cfs_p2 = abs(cwt(outlet_data,wname,fs));
    im_p2 = ind2rgb(im2uint8(rescale(cfs_p2)),jet(110));
    imFileName_p2 = strcat(name,'_outlet','.jpg');    
    Root_da_p2 = fullfile(cnn_path);Loc_da_p2 = fullfile(Root_da_p2);
    imwrite(imresize(im_p2,[224 224]),fullfile(Loc_da_p2,imFileName_p2));
end