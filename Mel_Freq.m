function Melcoeff = Mel_Freq( in_speech ) % function to calc MFCC % uses 63 samples
    hanning_window = floor(hann(512)'.*(2^16));
    frame = [];
    fftFrame = [];
    frameEnergy = [];
    DCT_result = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Constructing % Mel Filter Banks two
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% different ways
%     filter = [];
%     filter(1,:) = [zeros(1,5) linspace(0,1,8) linspace(1,0,8)  zeros(1,235)];       
%     filter(2,:) = [zeros(1,13) linspace(0,1,13) linspace(1,0,13)  zeros(1,217)];    
%     filter(3,:) = [zeros(1,26) linspace(0,1,18) linspace(1,0,18)  zeros(1,194)];    
%     filter(4,:) = [zeros(1,44) linspace(0,1,23) linspace(1,0,23)  zeros(1,166)];    
%     filter(5,:) = [zeros(1,67) linspace(0,1,28) linspace(1,0,28)  zeros(1,133)];    
%     filter(6,:) = [zeros(1,95) linspace(0,1,33) linspace(1,0,33)  zeros(1,95)];     
%     filter(7,:) = [zeros(1,128) linspace(0,1,38) linspace(1,0,38)  zeros(1,52)]; 

    freq_band = [300 4000];   
    nSample = 256;
    nFilter= 30; 

    bandwidth = freq_band(2) - freq_band(1);

    melfreq = @(f) 1127*log(1 + f/700);
    invmel = @(m) 700*(exp(m/1127) - 1);

    melf_centers = linspace(melfreq(freq_band(1)), melfreq(freq_band(2)), nFilter + 2); %Mel filter centers in Mel domain
    f_centers = invmel(melf_centers); %Filter centers in freq domain

    nCenters = round(((f_centers-freq_band(1))/bandwidth)*256);

    nCenters(1) = 1;
    melFiltersMatrix = zeros(nFilter,nSample);

    for i=1:nFilter
        melFiltersMatrix(i,(nCenters(i):nCenters(i+1))) = 0:1/(nCenters(i+1)-nCenters(i)):1;
        melFiltersMatrix(i,(nCenters(i+1):nCenters(i+2))) = 1:-1/(nCenters(i+2)-nCenters(i+1)):0;
    end
    filter = melFiltersMatrix;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%% Frames with 50% overlap
    index = 1;
    for i=1:63
        frame(i,:) =in_speech(index:index+511);
        index = index + 256; % for 50 percent overlap
    end

    %%% taking the fft
    for i=1:63
        fftFrame(i,:) = abs(floor(fft((frame(i,:).*hanning_window))./2^16));
    end

    %%% Calculating Energy
    for i=1:63
        frameEnergy = [];
        for t=1:7 % 7 Mel filter banks % summing energies for each filter bank
        temp = sum(floor(fftFrame(i,1:256).*(filter(t,:).^2))); %% power calculation done here
        frameEnergy = [frameEnergy temp];
        end
        energy_of_frame_tot(i,:) = frameEnergy; % total energy for a single frame
    end

    %%% DCT
    for i=1:63
        tempdata = energy_of_frame_tot(i,:);
        tempdata = floor(log10(tempdata+1).*128);
        tempdata = dct(tempdata); % taking DCT here
        tempdata(1) = 0;
        tempdata = floor(tempdata);
        DCT_result = [DCT_result tempdata];
    end

    Melcoeff =DCT_result; % MFCC calculated here finally
end

