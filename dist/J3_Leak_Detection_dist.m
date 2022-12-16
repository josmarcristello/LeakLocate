% This code expects a pre-trained CNN
% Inputs: Pressure and Velocity time series
% Intermediary Output: CWT of the time series (Optional)
% Output: Leak state (Leak vs No Leak)

clear;close all;clc;
% Change the current folder to the folder of this m-file.
if(~isdeployed)
  cd(fileparts(matlab.desktop.editor.getActiveFilename));
end

%% Import pre-trained CNN
  % import file
  % test image

img_loc =  fullfile('..\Dataset\0. Classify\leak example'); % Location of Image Datastore
images = imageDatastore(img_loc,'IncludeSubfolders',false,'LabelSource','foldernames') % the classfication subject is labelled as the folder name

%% Excute the Training network
%[leak_net,leak_net_info] = trainNetwork(Train,layers,options);
[leak_preds,score] = classify(leak_net,images); % Define if you want to use gpu(Graphics Processing Unit)
                                                                           % Using gpu has faster calculation performance

%idx = randperm(numel(Test.Files),9);
%figure
%for i = 1:9
%    subplot(3,3,i)
%    I = readimage(Test,idx(i));
%    imshow(I)
%    label = leak_preds(idx(i));
%    title(string(label));
%end

%YValidation = Test.Labels;
%accuracy = mean(leak_preds == YValidation) % CNN Model Accuracy

%% Save the CNN Model 
%save('trained_CNN','leak_net') % Comment out to avoid saving
%save('trained_CNN_info','info') % Comment out to avoid saving

%% Confusion Matrix
plotconfusion(YValidation,leak_preds)