clear all;
clc;

%%%% To listen to a specific index use this
% index = 16; load('samplesounds.mat'); soundsc(samplesound(index,:),32000);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

index = 50; 
recObj = audiorecorder(32000, 16, 1); %32k sampling rate and 16 bit
disp('Speak')
recordblocking(recObj, 3);% 3 seconds recording
dataRaw = getaudiodata(recObj, 'double');% Getting the data

%%% Filter
dataRaw = dataRaw(1:end-1)-dataRaw(2:end);

%%% for 8k data,we need it to 14 bit
data = floor((dataRaw.*(2^13))+2^13); 

%%% Getting the relevant part from the audio clip
dataFinal = newSound(data,100);% Threshold = 100

%%% listen to the final form of the data
disp('Listen')
soundsc(dataFinal,32000); %% listen scaled data

%%% Plots
figure(1)
plot(dataRaw)
figure(2)
plot(data)
figure(3)
plot(dataFinal)

%%%% Saving to the samples
% load('samplesounds.mat');
% samplesound(index,:) = data_new;
% save('samplesounds.mat','samplesound');

