clear all;
clc;

recObj = audiorecorder(32000, 16, 1);  
disp('Speak')
recordblocking(recObj, 3); 
dataRaw = getaudiodata(recObj, 'double'); 
dataRaw = filtering(dataRaw); 
data = floor((dataRaw.*(2^13))+2^13);
disp('Done');

dataFinal = newSound(data,100);
soundsc(dataFinal,32000);    %% listen for confirmation
figure(1)
plot(dataFinal);             %% Plot for confirmation

load('samplesounds.mat');


vectors = [];
MeanSquareError = [];
featureVector = Mel_Freq(dataFinal); % Melcoefficients

for i=1:50
    vectors(i,:) = Mel_Freq(samplesound(i,:));
end

%%% Euclidian Norm
for i=1:50
    MeanSquareError(i) = sum((vectors(i,:)-featureVector).^2); 
end


figure(2)
plot(MeanSquareError)

[k,index] = min(MeanSquareError);

figure(3)

fprintf('The Digit is => %d \n',ceil(index/5)- 1);

    


