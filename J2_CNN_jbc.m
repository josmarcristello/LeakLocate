%This code is for CNN modeling
% CNN is mainly for image recognition (Classification)
% CNN process include;
   % 1) Feature Learning Process
          %(1) Multiple Layers 
               % - Convolution Layers 
               % - Relu 
               % - Pooling Layers (Max, Min, Average Pooling)
   % 2) Classification Process
          % (1) Fully Conencted Layer - Linearize teh 2D Data 
          % (2) Softmax - Calculate the probability 
   

clear;close all;clc;
% Change the current folder to the folder of this m-file.
if(~isdeployed)
  cd(fileparts(matlab.desktop.editor.getActiveFilename));
end

%% Define CNN Structure
    layers = [ 
        % First Layer
           imageInputLayer([224 224 3], 'Name', 'input')
           convolution2dLayer(5, 20, 'Name', 'conv_1')   
           reluLayer('Name', 'relu_1')
           maxPooling2dLayer(2,'Stride',2)
        % Second Layer   
       convolution2dLayer(3, 20, 'Padding', 0, 'Name', 'conv_2')
           
           %convolution2dLayer(3, 20, 'Padding', 'same', 'Name', 'conv_2')
           reluLayer('Name', 'relu_2')
           maxPooling2dLayer(2,'Stride',2)
        % Third Layer   
           convolution2dLayer(3, 20, 'Padding', 1, 'Name', 'conv_3')
           reluLayer('Name', 'relu_3')
           maxPooling2dLayer(2,'Stride',2)
        % Classification  
           fullyConnectedLayer(2, 'Name', 'fc'); % Number of Classification
           softmaxLayer('Name', 'softmax')
           classificationLayer('Name', 'classoutput')]; 


%layers=net.Layers;       % whole layer information of networks
inlayer = layers(1);      % first layer information of networks
insz = inlayer.InputSize; % inputsize from first layer

%% Import input images (Should be 2D Images)
img_loc =  fullfile('Dataset\4. CNN\batch sim 2\pressure\'); % Location of Image Datastore

images = imageDatastore(img_loc,'IncludeSubfolders',true,'LabelSource','foldernames') % the classfication subject is labelled as the folder name

%count each label
labelCount = countEachLabel(images);

%% Slit training data & test data

[Train, Test] = splitEachLabel(images,0.5,'randomized') % if 'randomized' is added , it splits train and test at random
                                                        % 70% Train data 30% Test data
                                                        
%% Show input images at random
numTrainImages = numel(Train.Labels);
idx = randperm(numTrainImages,16);
figure
for i = 1:numTrainImages
    %subplot(round(sqrt(numTrainImages)),round(sqrt(numTrainImages)),i)
    %I = readimage(Train,i);
    %imshow(I)
end

%% Define The training option

%training option : Define CNN training options
options = trainingOptions('rmsprop', ...          %sgdm %rmsprop
    'LearnRateSchedule','piecewise', ...
    'InitialLearnRate',0.001, ...   % Smaller value takes longer time
    'LearnRateDropFactor',0.7, ...
    'LearnRateDropPeriod',5, ...
    'MaxEpochs',15, ... % Iteration
    'MiniBatchSize',2, ...
    'Plots','training-progress');
    
    
%% Excute the Training network
[leak_net,info] = trainNetwork(Train,layers,options);
[leak_preds,score] = classify(leak_net,Test); % Define if you want to use gpu(Graphics Processing Unit)
                                                                           % Using gpu has faster calculation performance

idx = randperm(numel(Test.Files),9);
figure
for i = 1:9
    subplot(3,3,i)
    I = readimage(Test,idx(i));
    imshow(I)
    label = leak_preds(idx(i));
    title(string(label));
end

YValidation = Test.Labels;
accuracy = mean(leak_preds == YValidation) % CNN Model Accuracy

%% Save the CNN Model 
save('trained_CNN','leak_net') % Comment out to avoid saving

%% Confusion Matrix
plotconfusion(YValidation,leak_preds)