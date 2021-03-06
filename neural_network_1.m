%Sandra Ng Yi Ling 2017 EE4305
%--------------------------------------------------------------------------
%initialisations
%--------------------------------------------------------------------------
clear;
clc;
filename='fer2013.xls';
number_of_data=input('Input the number of data pts to be analysed.\n');
training_cell=cell(number_of_data+1,2);
training_cell{number_of_data+1,2}=[];
%--------------------------------------------------------------------------
%Section 0: user-defined inputs
%--------------------------------------------------------------------------
number_of_neurons=input('Input the number of hidden neurons for this neural network.\n');
train_ratio=input('Input the proportion of training data. (decimal)\n');
val_ratio=input('Input the proportion of validation data. (decimal)\n');
test_ratio=1-train_ratio-val_ratio;
training_fn_brief=fprintf('List of training functions\n');
help nntrain;
training_function=input('Input the training function method from the list above.\n','s');
perf_fn_brief=fprintf('List of performance functions\n');
help nnperformance
performance_function=input('Input the performance function method from the list above.\n','s');
control_msg_string=sprintf('User settings recorded. Analysing %d data sets...\n',number_of_data);
disp(control_msg_string);
%--------------------------------------------------------------------------
%Section 1 - reading excel file and storing it into cell arrays
%--------------------------------------------------------------------------
image_location=strcat('B','2',':','B',int2str(number_of_data+1));
[num,txt,raw]=xlsread(filename,'fer2013',image_location);
emotion_location=strcat('A','2',':','A',int2str(number_of_data+1));
[num1,txt1,raw1]=xlsread(filename,'fer2013',emotion_location);
%--------------------------------------------------------------------------
%Section 2 - encodes relevant emotion number by reading from various cell
%arrays, encodes all data in accessible format in one cell array
%--------------------------------------------------------------------------
for sample_no=1:number_of_data
    data=raw(sample_no);
    data1=data{1};
    image_data=str2num(data1);
    emotion_data=num1(sample_no);
    training_cell{1,1}='emotion';
    training_cell{1,2}='image';
    training_cell{sample_no+1,1}=emotion_data;
    training_cell{sample_no+1,2}=image_data; %only works with 1D array
end
[row,column]=size(training_cell);
%--------------------------------------------------------------------------
%Uncomment the function below to convert to image and
%save the pictures into folder
%--------------------------------------------------------------------------
%current_directory=pwd;
%directory_name=input('Name of folder?\n','s');
%mkdir(directory_name);
%cd(directory_name);
%for z=2:row
%    write_to_file(training_cell{z,2},z-1);
%end
%cd(current_directory);
%--------------------------------------------------------------------------
%Section 3 - separate training cell into emotion row array and image row 
%cell array for input into the neural network pattern recognition toolbox
%--------------------------------------------------------------------------
emotion1=cell2mat(training_cell(2:row,1));
image=cell2mat(training_cell(2:row,2));
%need to convert emotion grading to 1 or 0 using linearly independent
%vectors to represent the 7 classes (just going to use identity)
emotion_class=[1 0 0 0 0 0 0; 0 1 0 0 0 0 0; 0 0 1 0 0 0 0; 0 0 0 1 0 0 0;
    0 0 0 0 1 0 0; 0 0 0 0 0 1 0; 0 0 0 0 0 0 1];
emotion_target=zeros(row-1,7);
for m=1:row-1
    if emotion1(m,1)==0
        emotion_target(m,1:7)=emotion_class(1,1:7);
        continue
    end
    if emotion1(m,1)==1
        emotion_target(m,1:7)=emotion_class(2,1:7);
        continue
    end
    if emotion1(m,1)==2
        emotion_target(m,1:7)=emotion_class(3,1:7);
        continue
    end
    if emotion1(m,1)==3
        emotion_target(m,1:7)=emotion_class(4,1:7);
        continue
    end
    if emotion1(m,1)==4
        emotion_target(m,1:7)=emotion_class(5,1:7);
        continue
    end
    if emotion1(m,1)==5
        emotion_target(m,1:7)=emotion_class(6,1:7);
        continue
    end
    if emotion1(m,1)==6
        emotion_target(m,1:7)=emotion_class(7,1:7);
        continue
    end
end
control_msg0=fprintf('Images processed into readable format and desired emotion outputs generated.\n');
control_msg1=fprintf('Starting neural network training...\n');
%-------------------------------------------------------------------------
%Section 4 - 
% Solve a Pattern Recognition Problem with a Neural Network
% Script generated by NPRTOOL
% This script assumes these variables are defined:
%   image - input data.
%   emotion_target - target data.
%-------------------------------------------------------------------------
inputs = image';
targets = emotion_target';

% Create a Pattern Recognition Network
hiddenLayerSize = number_of_neurons;
net = patternnet(hiddenLayerSize);

% Choose Input and Output Pre/Post-Processing Functions
% For a list of all processing functions type: help nnprocess
net.inputs{1}.processFcns = {'removeconstantrows','mapminmax'};
net.outputs{2}.processFcns = {'removeconstantrows','mapminmax'};


% Setup Division of Data for Training, Validation, Testing
% For a list of all data division functions type: help nndivide
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = train_ratio;
net.divideParam.valRatio = val_ratio;
net.divideParam.testRatio = test_ratio;

% For help on training function 'trainlm' type: help trainlm
% For a list of all training functions type: help nntrain
net.trainFcn = training_function;  % Levenberg-Marquardt

% Choose a Performance Function
% For a list of all performance functions type: help nnperformance
net.performFcn = performance_function;  % Mean squared error

% Choose Plot Functions
% For a list of all plot functions type: help nnplot
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
  'plotregression','plotconfusion'};


% Train the Network
[net,tr] = train(net,inputs,targets);

% Test the Network
outputs = net(inputs);
errors = gsubtract(targets,outputs);
performance = perform(net,targets,outputs)

% Recalculate Training, Validation and Test Performance
trainTargets = targets .* tr.trainMask{1};
valTargets = targets  .* tr.valMask{1};
testTargets = targets  .* tr.testMask{1};
trainPerformance = perform(net,trainTargets,outputs)
valPerformance = perform(net,valTargets,outputs)
testPerformance = perform(net,testTargets,outputs)

% View the Network
view(net)

% Plots
% Uncomment these lines to enable various plots.
figure, plotperform(tr)
figure, plottrainstate(tr)
figure, plotconfusion(targets,outputs)
figure, ploterrhist(errors)

%Write performance data to a .dat file
file_id=fopen('performance_data.dat','wt');
fprintf(file_id,'performance = %0.5f\n',performance);
fprintf(file_id,'trainPerformance=%0.5f\n',trainPerformance);
fprintf(file_id,'valPerformance=%0.5f\n',valPerformance);
fprintf(file_id,'testPerformance = %0.5f\n',testPerformance);
fclose(file_id);
%-------------------------------------------------------------------------
control_msg_end=fprintf('Script completed.\n');