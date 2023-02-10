% This function determines the leak location, if it exists.
% Method: Gradient Intersection
% Author: Josmar Cristello
%% Inputs
%    test_path_leak: File path for a test (With a leak)
%    test_path_no_leak: File path for a test (Without a leak)
%    Requirement: Boundary conditions of pressure-pressure 
%       i.e. bc_two_type = 5, bc_one_type = 1.
%    File Structure:   
%       Results.x → distance Vector [m]
%       Results.t_step → time Vector [s]
%       Results.Pressure → Pressure Vector(i,j) [Pa]
%           i → time dimension
%           j → distance dimension
%       Results.Velocity → Velocity Vector(i,j) [m/s*]
%% Outputs
%    dataset_path: Full path for the dataset folder of the project.
%% TODO
%    Currently, I have to generate a datastore. Figure out a way to classify direct from a variable (i.e. memory)
%% Main

clear; close all; clc; format longG;

test_names=[""];
real_leak = [""];
estimated_leak = [""];

%%
data_folder_leak = "F:\Onedrive\OneDrive - University of Calgary\LeakLocate\dataset\2. Simulated\batch sim 3\leak\";
data_folder_no_leak = "F:\Onedrive\OneDrive - University of Calgary\LeakLocate\dataset\2. Simulated\batch sim 3\no leak\";

cd(data_folder_leak);
test_files = get_files('*.mat');
for j = 1:length(test_files)
    % Leak Test Filename
    cd(data_folder_leak);
    file_path_leak = test_files{j};
    %disp(file_path_leak)
    Results_leak = load(file_path_leak); Results_leak = Results_leak.Results;
    real_leak_loc_rel = Results_leak.relative_x_leak; % Needed to calculate error in estimative

    % Leak Test Filename
    cd(data_folder_no_leak)
    file_path_no_leak = strrep(file_path_leak,'isLeak_1','isLeak_0');
    %disp(file_path_no_leak)
    Results_no_leak = load(file_path_no_leak); Results_no_leak = Results_no_leak.Results;

    %Apply the Gradient Intersection Method
    v_no_leak_inlet = Results_no_leak.Velocity(end, 1);
    v_no_leak_outlet = Results_no_leak.Velocity(end, end);
    
    v_leak_inlet = Results_leak.Velocity(end, 1);
    v_leak_outlet = Results_leak.Velocity(end, end);
    
    dist = Results_leak.Length/1000;
    
    x0 = (v_no_leak_inlet^2 - v_leak_outlet^2)/(v_leak_inlet^2-v_leak_outlet^2);
    % Calculate the error
    leak_loc_rel = x0;
    leak_loc_abs = x0*max(Results_leak.Length);
    disp(['Leak detected in ', num2str(round(leak_loc_abs)), 'm', ' (', num2str(round(100*leak_loc_rel,1)), '%).']);
    
    
    leak_loc_error_rel = leak_loc_rel - real_leak_loc_rel;
    leak_loc_error_rel_abs = leak_loc_error_rel*max(Results_leak.Length);
    
    disp(['The error in this measurement was ', num2str(round(leak_loc_error_rel_abs)), 'm', ' (', num2str(round(leak_loc_error_rel*100,1)), '%).']);
    
    %% Compile Results error to array
    test_names(end+1) = file_path_leak;
    real_leak (end+1) = real_leak_loc_rel;
    estimated_leak(end+1) = leak_loc_rel;    
end 


%% Save Results to a File
%header = ["Test Name", "Leak Position (Real)", "Leak Position (Estimated)"]
accuracy_results = [test_names; real_leak; estimated_leak];
%save('accuracy_results','csv');
writematrix(accuracy_results ,'leak_localization_batch.csv') 


