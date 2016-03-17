function hbatcheeg_ver04(filename,type)
%The following function - hbatcheeg_Neuroscan - provides analysis of multi-channel EEG
%data. It goes through every channel at a specific window with a window
%overlap and passes this data to the STFT function, which then computes the
%total spectral power across specific bands for that segment of data.
%
% LAST REVISED - 12 JUNE 2006 - @ 12:00

disp('Executing Program - hbatcheeg_HKNeuroscan_ver04 ...');

%----- start - static declarations -----
warning off all;

ST_results.Method = 'STFT';
ST_results.Algorithm = 'hbatcheeg_ver04';


%putting in a case statement for switiching between Xltek and Neuroscan
%data, which will change some of the static declerations.
switch type

    case 'NS'
    
        SampFreq = 5e3; %sampling frequency (Hz)
        SampPeriod = 1/SampFreq; %sampling period (s)

        AnalStep = fix(10e3); %Analysis step through data - the time segment passed to STFT
        delta = fix(0.5*AnalStep); %Analysis window overlap, time segment passed to STFT

        Anal_Window = fix(0.25 * AnalStep); %analysis window in pts for the STFT
        Anal_overlap = fix(0.5 * Anal_Window); %analysis window overlap for STFT
        N_Bands = 5; %number of bands
        Band_Type = '0-500Hz'; %the range of the bands
        
        F_Start = 0.5; %Start frequency for STFT (Hz)
        F_Step = 0.5; %Increment frequency for STFT (Hz)
        F_End = 500; %End frequency for STFT (Hz)
        F_BandFactor = 1/F_Step; %the correction factor for row number for STFT output in light of F_Step
        Freq =(F_Start:F_Step:F_End)'; %vector of frequencies to be computed by STFT

        %Vectors corresponding to row numbers for the output of the STFT, used for
        %banding power amplitudes upon band summation. Explicit index values (e.g.
        %100 or 200) relate to the frequencies at the edge of the bands in (Hz).
        Band_1 = (1:1:(100*F_BandFactor))';
        Band_2 = (((100*F_BandFactor)+1):1:(200*F_BandFactor))';
        Band_3 = (((200*F_BandFactor)+1):1:(300*F_BandFactor))';
        Band_4 = (((300*F_BandFactor)+1):1:(400*F_BandFactor))';
        Band_5 = (((400*F_BandFactor)+1):1:(500*F_BandFactor))';
        
        
        
    
    case 'XL'
    
        SampFreq = 500; %sampling frequency (Hz)
        SampPeriod = 1/SampFreq; %sampling period (s)

        AnalStep = 1e3; %Analysis step through data - the time segment passed to STFT
        delta = 0.5*AnalStep; %Analysis window overlap, time segment passed to STFT

        Anal_Window = fix(0.25 * AnalStep); %analysis window in pts for the STFT
        Anal_overlap = fix(0.5 * Anal_Window); %analysis window overlap for STFT
        N_Bands = 5; %number of bands
        Band_Type = '0-250Hz'; %the range of the bands
    
        F_Start = 0.5; %Start frequency for STFT (Hz)
        F_Step = 0.5; %Increment frequency for STFT (Hz)
        F_End = 250; %End frequency for STFT (Hz)
        F_BandFactor = 1/F_Step; %the correction factor for row number for STFT output in light of F_Step
        Freq =(F_Start:F_Step:F_End)'; %vector of frequencies to be computed by STFT

        %Vectors corresponding to row numbers for the output of the STFT, used for
        %banding power amplitudes upon band summation. Explicit index values (e.g.
        %100 or 200) relate to the frequencies at the edge of the bands in (Hz).
        Band_1 = (1:1:(50*F_BandFactor))';
        Band_2 = (((50*F_BandFactor)+1):1:(100*F_BandFactor))';
        Band_3 = (((100*F_BandFactor)+1):1:(150*F_BandFactor))';
        Band_4 = (((150*F_BandFactor)+1):1:(200*F_BandFactor))';
        Band_5 = (((200*F_BandFactor)+1):1:(250*F_BandFactor))';

end


%----- end - static declarations -----


filename_full = strcat(filename,'.mat');

load(filename_full);

Data = detrend(Data); %detrending the data - important for subsequent STFT

[DataLength,NChannels] = size(Data);

NCalls = fix(DataLength ./ delta);

%allocating space for the Matrix (volume of data) and the band sums.
ST_results.Data = zeros(NCalls,N_Bands,NChannels);
BandSums = zeros(N_Bands,1);
TimeLine = zeros(NCalls,1);


Start_Point = 1;
End_Point = AnalStep;

%computing the time-point, this is the middle point between the start and
%end points of each window. This is the best representation of a time-axis
%for each of the power points, per band, per channel, as computed by the
%STFT.
TimeLine(1) = fix((Start_Point+End_Point)/2) * SampPeriod;


waiter=waitbar(0,'Processing Data - Time Segment');

for i=1:NCalls
        waitbar(i/NCalls,waiter);
        if(i==NCalls)

                Start_Point=Start_Point-delta;
                End_Point=DataLength;
                
                TimeLine(i) = fix((Start_Point+End_Point)/2) * SampPeriod;

                for j = 1:NChannels

                    dataSection = Data(Start_Point:End_Point,j);

                    [S,F,T,P] = spectrogram(dataSection,Anal_Window,Anal_overlap,Freq,SampFreq);

                    BandSums(1) = sum(sum(P(Band_1,:)));
                    BandSums(2) = sum(sum(P(Band_2,:)));
                    BandSums(3) = sum(sum(P(Band_3,:)));
                    BandSums(4) = sum(sum(P(Band_4,:)));
                    BandSums(5) = sum(sum(P(Band_5,:)));                

                    ST_results.Data(i,1:N_Bands,j) = BandSums;

                end


        else
                for j = 1:NChannels

                    dataSection = Data(Start_Point:End_Point,j);

                    [S,F,T,P] = spectrogram(dataSection,Anal_Window,Anal_overlap,Freq,SampFreq);

                    BandSums(1) = sum(sum(P(Band_1,:)));
                    BandSums(2) = sum(sum(P(Band_2,:)));
                    BandSums(3) = sum(sum(P(Band_3,:)));
                    BandSums(4) = sum(sum(P(Band_4,:)));
                    BandSums(5) = sum(sum(P(Band_5,:)));                

                    ST_results.Data(i,1:N_Bands,j) = BandSums;


                end

                    Start_Point = Start_Point + delta;
                    End_Point = End_Point + delta;
                    
                    TimeLine(i) = fix((Start_Point+End_Point)/2) * SampPeriod;
        end

end
 
close(waiter) 

%getting rid of the raw data that was used for the STFT computation.
clear Data;

%constructing the "structured" array of data for the ST_results
ST_results.SampFreq = SampFreq; %sampling freq.
ST_results.AnalStep = AnalStep; %Analysis step through data - the time segment passed to STFT
ST_results.delta = delta; %Analysis window overlap, time segment passed to STFT
ST_results.Anal_Window = Anal_Window; %analysis window in pts for the STFT
ST_results.Anal_overlap = Anal_overlap; %analysis window overlap for STFT
ST_results.N_Bands = N_Bands; %number of bands
ST_results.Band_Type = Band_Type; %the range of the bands
ST_results.Freq = Freq; %vector of frequencies to be computed by STFT
ST_results.Duration = (SampPeriod * DataLength); %duration of the file (seconds)
ST_results.TimeLine = TimeLine; %the mean time point, relative to recording duration, for each timepoint


% SAVING OUTPUT
outputfilename = strcat(filename,'_results.mat');
save(outputfilename,'ST_results','-mat');

return;