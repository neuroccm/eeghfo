function eeggenbatch_ver02(filename)
%Human EEG general analysis batch routine.
%
%LAST REVISED - 31 Dec. 2006


close all;
%turning off erros
warning off MATLAB:colon:operandsNotRealScalar;
warning off MATLAB:divideByZero;


batchlist = strcat(filename,'.asc');

disp('STARTING BATCH PROCESS');
tic

%opening the file for reading, not read yet
fid = fopen(batchlist, 'rt');
numfiles = 0;
while (feof(fid) == 0)
   tempstr = fgetl(fid);
   numfiles = numfiles + 1;
end

status = fseek(fid,0,'bof');

for j = 1:numfiles;
    

    tline = fgetl(fid); 
    disp(sprintf('Currently On Seizure Event %g of %g ...',j, numfiles));
    
    
    
%******* NEUROSCAN MONTAGE MAKER *****************************************
    %Neuroscan_montagemaker_ver02(tline,'Ostlund-bipolar-montage');
%**************************************************************************    




%******* XLTEK MONTAGE MAKER *****************************************
    %xltek_reader_montagemaker_ver01(tline,'Avanashi-montage');
%**************************************************************************

%******* START- PINNEGAR TIME-FREQUENCY AMPLITUDE COMPUTATION **********
    
%     SampleFreq = 5000;
%     SegmentLength = 2;
%     ReportFreq = 5000;
%     GammaParam = 5;
%     OverLap = 0.5;
% 
%     load(tline);
%     
%     [ST_results.Data,ST_results.FreqAxis,ST_results.TimeLine]=steeg_ver01(Data,'s',SegmentLength,'fs',SampleFreq,'d', ... 
%         ReportFreq,'fr',{[1:4:100] [101:5:200] [201:10:300] [301:12.5:400] [401:20:500]},'g',GammaParam,'o',OverLap);
%     
%     
%     %Converting the Variables to Strings
%     SampleFreq_str = num2str(SampleFreq);
%     SegmentLength_str = num2str(SegmentLength);
%     ReportFreq_str = num2str(ReportFreq);
%     GammaParam_str = num2str(GammaParam);
%     OverLap_str = num2str(OverLap);
%     
%     outputfilename = strcat(tline,'_results_Morlet_',SampleFreq_str,'_',SegmentLength_str,'_',ReportFreq_str,'_',GammaParam_str,'_',OverLap_str,'.mat');
%     
%     save(outputfilename,'ST_results','-mat');

%******* END - PINNEGAR TIME-FREQUENCY AMPLITUDE COMPUTATION **********


%******* STFT Time-Frequency ANALYSIS - FOURIER ***************************
    % The 'NS' is a type, for Neuroscan, which translates to a specific set
    % of static variables (selected by a case statement) in the
    % hbatcheeg_HKNeuroscan_ver03 function.

    hbatcheeg_ver04(tline,'NS');
%**************************************************************************    
    
end

disp('END BATCH PROCESS');
toc

fclose(fid);

clear all;
close all;