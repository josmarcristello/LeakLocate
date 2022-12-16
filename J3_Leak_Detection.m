% This function classifies a single simulated test in leak or no-leak.
% Author: Josmar Cristello
%% Inputs
%    test_path: File path for a test. Should be a matlab object with pressure and velocity time-series sub-objects.
%% Outputs
%    dataset_path: Full path for the dataset folder of the project.
%% TODO
%    Currently, I have to generate a datastore. Figure out a way to classify direct from a variable (i.e. memory)
%    Include a way to test multiple files at once.
%% Main

clear;close all;clc;
% Change the current folder to the folder of this m-file.
if(~isdeployed)
  cd(fileparts(matlab.desktop.editor.getActiveFilename));
end

%% Import test file(s)
file_path = fullfile("F:\Onedrive\OneDrive - University of Calgary\LeakLocate\dataset\2. Simulated\batch sim 2\");
% Gets all test files from a folder that end in .mat
fileList = dir(file_path + "*.mat");

%% Generate CWTs
for i = 1:length(fileList)
    file = strcat(fileList(i).folder, "\", fileList(i).name);
    [~, ~, cwt_folder] = generate_cwt(file, "pressure", "inlet", true, 'amor', 2, 50);
    %figure; imshow(img_test); % Comment out to not display the image
end

%% Import pre-trained CNN
load("trained_CNN.mat");

%% Creating Datastore
image_datastore = imageDatastore(cwt_folder,'IncludeSubfolders',true,'LabelSource','foldernames'); % the classfication subject is labelled as the folder name

%% Classify the image
[leak_preds] = classify(leak_net, image_datastore); 
%[leak_preds] = predict(leak_net, [cwt_inlet]); 
%disp(leak_preds);
%disp(score);

YValidation = image_datastore.Labels;
accuracy = mean(leak_preds == YValidation); % CNN Model Accuracy

%% Confusion Matrix
%plotconfusion(YValidation,leak_preds)
plotconfusion(YValidation, leak_preds);