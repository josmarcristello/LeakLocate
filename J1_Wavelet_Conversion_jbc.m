% This code is to convert 1D signal to 2D Images by using Wavelet Transform
% This is for the simulated data

clear;clc;close all

% Change the current folder to the folder of this m-file.
if(~isdeployed)
  cd(fileparts(matlab.desktop.editor.getActiveFilename));
end

%% Control Parameter 
%valve = strcat('full');
%valve = strcat('half');

file_path = fullfile('F:\Onedrive\OneDrive - University of Calgary\LeakLocate\dataset\2. Simulated\batch sim 2\loc_0_relSize_1_leakStartTime_30_isLeak_1_gasMixture_CH4_Hyd_90.mat');
%cnn_path = 'dataset\3. WT_Converted\batch sim 2\velocity\'; % Output Data (where to save)

%%
[cwt_inlet, cwt_outlet] = generate_cwt(file_path, "pressure", "inlet");

%%
%addpath(path)

  
for relative_x_leak = 0:0.1:1.0 %Location
    for relative_leak_size = 0.01:0.04:0.20
        for relative_leak_start_time = 0.3:0.05:0.6
            for is_leak = 0:1
                gas_mixture_property = 'CH4_Hyd_90'; % blended gas mixture properties
                name = strcat("loc_", num2str(relative_x_leak*100), "_relSize_", num2str(relative_leak_size*100), "_leakStartTime_", num2str(relative_leak_start_time*100), "_isLeak_", num2str(is_leak), "_gasMixture_", gas_mixture_property);
                filename = strcat(path, name, '.mat'); % for leak dataset 

                Results = load(filename);
                Results = Results.Results;
                
                inlet_index = 1;
                outlet_index = size(Results.Pressure,2);
            
                data1 = Results.Pressure(:,inlet_index); % Inlet Pressure
                data2 = Results.Pressure(:,outlet_index); % Outlet Pressure
                %data1 = Results.Velocity(:,inlet_index); % Inlet Pressure
                %data2 = Results.Velocity(:,outlet_index); % Outlet Pressure
                fs = 2;

                % CWT Save (pressure)
                % Inlet Pressure
                cfs_p = abs(cwt(data1,'amor',fs));
                im_p = ind2rgb(im2uint8(rescale(cfs_p)),jet(110));
                imFileName_p = strcat(name,'_inlet','.jpg');    
                Root_da_p = fullfile(cnn_path);Loc_da_p = fullfile(Root_da_p);
                imwrite(imresize(im_p,[224 224]),fullfile(Loc_da_p,imFileName_p));
                
                % Outlet Pressure
                cfs_p2 = abs(cwt(data2,'amor',fs));
                im_p2 = ind2rgb(im2uint8(rescale(cfs_p2)),jet(110));
                imFileName_p2 = strcat(name,'_outlet','.jpg');    
                Root_da_p2 = fullfile(cnn_path);Loc_da_p2 = fullfile(Root_da_p2);
                imwrite(imresize(im_p2,[224 224]),fullfile(Loc_da_p2,imFileName_p2));
   
            end
        end 
    end 
end


rmpath(path)