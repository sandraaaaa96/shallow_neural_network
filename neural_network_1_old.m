%Sandra Ng Yi Ling 2017
clear;
clc;
filename='fer2013.xls';
formatspec= 'pictures\\figure%d.png';
number_of_data=input('Input the number of data you want to analyse.\n');
for sample_no=2:number_of_data
    %----------------------------------------------------------------------
    %Section 1 - reads excel file for image data, converts it to 48x48
    %array and grayscale image, possible to write to a png file
    %(uncomment relevant section to save to file)
    %----------------------------------------------------------------------
    sample_location=strcat('B',int2str(sample_no),':','B',int2str(sample_no));
    [num,txt,raw]=xlsread(filename,'fer2013',sample_location);
    data=raw{1:1};
    image_data=str2num(data);
    %Uncomment the section below to convert to image and
    %save the pictures into folder
    %---------------------------------------------------------------------
    %image_template=zeros(48);
    %for k=1:48
    %    for j=1:48
    %        image_template(k,j)=image_data(1,j+(k-1)*48);
    %    end
    %end
    %image_array=mat2gray(image_template);
    %samplenominus1=sample_no-1;
    %picname=sprintf(formatspec,samplenominus1);
    %imwrite(C,picname);
    %---------------------------------------------------------------------
    %Section 2 - encodes relevant emotion number by reading from excel
    %file, encodes all data in accessible format in a cell array
    %---------------------------------------------------------------------
    emotion_location=strcat('A',int2str(sample_no),':','A',int2str(sample_no));
    [num1,txt1,raw1]=xlsread(filename,'fer2013',emotion_location);
    emotion_data=num1;
    training_cell{number_of_data,2}=[];
    training_cell{1,1}='emotion';
    training_cell{1,2}='image';
    training_cell{sample_no,1}=emotion_data;
    training_cell{sample_no,2}=image_data; %only works with 1D array
end
disp(training_cell);
%--------------------------------------------------------------------------
%Section 3 - separate training cell into emotion row array and image row cell array
%for input into the neural network pattern recognition toolbox
%--------------------------------------------------------------------------
[row,column]=size(training_cell);
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
%-------------------------------------------------------------------------
control_msg=fprintf('Script completed.\n');
%-------------------------------------------------------------------------
%Section 4 - right now I'm using the GUI version and just clicking, 
%going to change this to code format as what the supp doc recommends