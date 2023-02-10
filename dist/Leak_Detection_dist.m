% This function classifies a single simulated test in leak or no-leak.
% Author: Josmar Cristello
%% Inputs
%    test_path: File path for a test. Should be a matlab object with pressure and velocity time-series sub-objects.
%    trained_cnn: File with a pre-trained CNN.
%% Outputs
%    dataset_path: Full path for the dataset folder of the project.
%% TODO
%    Currently, I have to generate a datastore. Figure out a way to classify direct from a variable (i.e. memory)
%% Main

clear; close all; clc; format longG;
% Change the current folder to the folder of this m-file.
if(~isdeployed)
  cd(fileparts(matlab.desktop.editor.getActiveFilename));
end

%% Import pre-trained CNN
load("trained_CNN.mat");

%% Import test file
file_path = fullfile('F:\Onedrive\OneDrive - University of Calgary\LeakLocate\dataset\2. Simulated\batch sim 2\loc_0_relSize_1_leakStartTime_50_isLeak_0_gasMixture_CH4_Hyd_90.mat');

%% Generate CWT
[cwt_inlet, cwt_outlet, cwt_folder] = generate_cwt(file_path, "pressure", "inlet", true, 'amor', 2, 70);
img_test = cwt_inlet;
figure; imshow(img_test); % Comment out to not display the image


%% Creating Datastore
image_datastore = imageDatastore(cwt_folder,'IncludeSubfolders',true); % the classfication subject is labelled as the folder name

%% Classify the image
[leak_preds] = classify(leak_net, image_datastore); 
%[leak_preds] = predict(leak_net, [cwt_inlet]); 
disp(leak_preds);
%disp(score);

%% Confusion Matrix
%plotconfusion(YValidation,leak_preds)