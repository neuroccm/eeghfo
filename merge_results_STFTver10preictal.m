function merge_results_STFTver10preictal(mergelist, patientName, eventNumber)
%This function is designed to merge the analysis MAT files produced by STFT
%analysis of segmented EEG files. This function merges the analysis
%results, computes a difference between a seizure epoch of EEG in
%comparison to a background segment of EEG and report the so-called "R"
%values. There are two versions of this function, the first version simply
%uses an analysis window (e.g. 5 sec.) to look ahead and back from the
%seizure start time (ID'ed via Neurologist) for comparision. The other
%version can intake an actual background start time that is used to compute
%the background segment.
%
% 16 Dec. 2006
% savename=strcat(patientName, '_DataCube_E'); - I got rid of
% "_DataCube_Preictal_E' - this was causing problems when the temporal
% analysis was being done. It was not necessary since we setteled on using
% the immediate time before seizure as the background rather than some
% specified background time for when calculating the spatial values.
% Therefore, it is better to use this.
%
%
% LAST REVISION 25 June 2006
%



close all;
%turning off erros
warning off MATLAB:colon:operandsNotRealScalar;
warning off MATLAB:divideByZero;
PreIctalComparison = 1;






deltaWindow = 5; %time in seconds for size of bkgnd and sz slices/epochs in cube


switch patientName
    
%**************************************************************************   
    case 'DO'
        
        patientName = 'Ostlund';
        montageNumberFile = 'Ostlund-bipolar-montage.asc';
        montageChannelNameRow = 'electrodeNameLookUpTable_ostlund.asc';
        montageChannelNumberRow = 'electrodeNumLookUpTable_ostlund.asc';
        
        %10s back and start of seizure
        if(eventNumber==1)
            seizurestarttime = 1821;


        elseif(eventNumber==2)
            seizurestarttime = 1849;


        elseif(eventNumber==3)
            seizurestarttime = 1766;


        else
            disp('No Such Event Exists for Ostlund');
            return;
        end
 %**************************************************************************               
     case 'SA'

        patientName = 'Avanashi';
        montageNumberFile = 'Avanashi-bipolar-montage.asc';
        montageChannelNameRow = 'electrodeNameLookUpTable_avanashi.asc';
        montageChannelNumberRow = 'electrodeNumLookUpTable_avanashi.asc';
        
        %10s back and start of seizure
        if(eventNumber==1)
            seizurestarttime = 1863;


        elseif(eventNumber==2)
            seizurestarttime = 1821;


        elseif(eventNumber==3)
            seizurestarttime = 1988;


        elseif(eventNumber==4)
            seizurestarttime = 1929;


        else
            disp(sprintf('No Such Event Exists for %s',patientName));
            return;
        end
%**************************************************************************      
    case 'EF'
        patientName = 'Fraser';
        montageNumberFile = 'Fraser-bipolar-montage.asc';
        montageChannelNameRow= 'electrodeNameLookUpTable_elizabeth.asc';
        montageChannelNumberRow = 'electrodeNumLookUpTable_elizabeth.asc';
        
        if(eventNumber==1)
            seizurestarttime = 1871;   


        elseif(eventNumber==2)
            seizurestarttime = 1812;


        elseif(eventNumber==3)
            seizurestarttime = 1788;


        elseif(eventNumber==4)
            seizurestarttime = 1876;


        else
            disp(sprintf('No Such Event Exists for %s',patientName));
            return;
        end
%**************************************************************************        
         case 'MC'
        patientName = 'Christienson';
        montageNumberFile = 'Christienson-Bipolar-montage-file.asc';
        montageChannelNameRow= 'electrodeNameLookUpTable_christiensen.asc';
        montageChannelNumberRow = 'electrodeNumLookUpTable_christiensen.asc';
        
        if(eventNumber==1)
            seizurestarttime = 1762;

        elseif(eventNumber==2)
            seizurestarttime = 1776;

        elseif(eventNumber==3)
            seizurestarttime = 1487;

        else
            disp(sprintf('No Such Event Exists for %s',patientName));
            return;
        end
%**************************************************************************    
    case 'MM'
        patientName = 'Mcclellan';
        montageNumberFile = 'McClellan-bipolar-montage.asc';
        montageChannelNameRow= 'electrodeNameLookUpTable_mcclellan.asc';
        montageChannelNumberRow = 'electrodeNumLookUpTable_mcclellan.asc';
        
         if(eventNumber==1)
            seizurestarttime = 1801;


         else
             disp(sprintf('No Such Event Exists for %s',patientName));
             return;
         end
%**************************************************************************

    case 'PB'
            
        patientName='Baker';
        if(eventNumber<5)

            montageNumberFile = 'Baker-bipolar-montage-PRE-25mar06.asc';
            montageChannelNameRow = 'electrodeNameLookUpTable_PREbaker.asc';
            montageChannelNumberRow = 'electrodeNumLookUpTable_PREbaker.asc';
            
                    if(eventNumber==1)
                            seizurestarttime = 1856;


                    elseif(eventNumber==2)
                            seizurestarttime = 1837;


                    elseif(eventNumber==3)
                            seizurestarttime = 1866;

                    elseif(eventNumber==4)
                            seizurestarttime = 1818;

                    end

        elseif((eventNumber==5)||(eventNumber==6))
                    montageNumberFile = 'Baker-bipolar-montage-POST-25mar06.asc';
                    montageChannelNameRow = 'electrodeNameLookUpTable_POSTbaker.asc';
                    montageChannelNumberRow = 'electrodeNumLookUpTable_POSTbaker.asc';


                     if(eventNumber==5)
                        seizurestarttime = 1815;


                    elseif(eventNumber==6)
                        seizurestarttime = 1738;
                        
                    end
        else
            disp(sprintf('No Such Event Exists for %s',patientName));
            return;
        end
%**************************************************************************   
    case 'DB'
        
        patientName = 'Backlun';
        montageNumberFile = 'Backlun-bipolar-montage.asc';
        montageChannelNameRow = 'electrodeNameLookUpTable_backlun.asc';
        montageChannelNumberRow = 'electrodeNumLookUpTable_backlun.asc';
        
        %10s back and start of seizure
        if(eventNumber==1)
            seizurestarttime = 1814;

        elseif(eventNumber==2)
            seizurestarttime = 1804;

        elseif(eventNumber==3)
            seizurestarttime = 1800;
       
        elseif(eventNumber==4)
            seizurestarttime = 1804;

        else
            disp(sprintf('No Such Event Exists for %s',patientName));
            return;
        end
        
 %**************************************************************************   
    otherwise
        
        disp(' **** Patient not found in static declarations ****');
        return;
       
end


%defining the background start and stop segments in relation to the seizure
%start time - this is immediately preictal to the start of the seizure
%bgstart=(seizurestarttime-deltaWindow)-1; %subtracting an additional second for good measure!
%bgend=(bgstart+deltaWindow)-1;

%********* Houman Change - 16 Dec. 2006 *******
%The above are not indecies, they are actual times in seconds and in the
%function CombputeBandComparision_ver02, this time number is being
%converted to an actual index number used to computer "R" - therefore, I
%have removed the "play" with 1s in the previous equation.

bgstart=(seizurestarttime-deltaWindow)-1; %subtracting an additional second for good measure!
bgend=(bgstart+deltaWindow)-1;

%defining the epoch for the seizure, using the defined seizure start time
%and the duration of the analysis window - "deltaWindow"
%szstart=seizurestarttime;
%szend=(seizurestarttime+deltaWindow)-1;
szstart=seizurestarttime;
szend = seizurestarttime + deltaWindow;



mergelist = strcat(mergelist,'.asc');

disp('STARTING BATCH PROCESS - MERGING RESULTS');
tic

%opening the file for reading, not read yet
fid = fopen(mergelist, 'rt');
numfiles = 0;
while (feof(fid) == 0);
   tempstr = fgetl(fid);
   numfiles = numfiles + 1;
end

status = fseek(fid,0,'bof');


for j = 1:numfiles;
    
    tline = fgetl(fid);
    load(tline);
    tData_Power = ST_results.Data;
    tData_Time = ST_results.TimeLine;
    clear ST_results;
       
    if (j == 1)
        Data_Power = tData_Power;
        Data_Time =  tData_Time;
    elseif (j > 1)   
        Data_Power = [Data_Power;tData_Power];
        Data_Time = [Data_Time;(tData_Time+Data_Time(end,1))];
    end

end

%fixing the presence of complex numbers from the frequency analysis,
%probably caused by the presence of artifact in the signal - those array
%elements are set to zero.
Data_Power = screencomplexsegment_ver02(Data_Power);


% Algorithm for spatial comparison of channels for complete STFT analysis


Cube.Data=Data_Power;
Cube.TimeLine=Data_Time;

%seizurestarttime is in seconds.
Cube.szStartTime=seizurestarttime;


%read in the montage name lookup file.
channelNumArray=load(montageChannelNumberRow);
channelNameArray=textread(montageChannelNameRow, '%s');

[NRows,NBands,NChannels] = size(Data_Power);


%create the montage name information. Store it into the Cube.
montageArray=load(montageNumberFile);
if(size(montageArray)~=NChannels)    
    disp('Error in MontageFile');
else
    
    Cube.montageNumberArray=montageArray;
    %montageNameArray=zeros(size(montageArray));
    for i=1:NChannels
        for j=1:2
            montageNameArray(i,j)=codex_ver02(channelNumArray,channelNameArray,montageArray(i,j));
        end
    end

    Cube.montageNameArray=montageNameArray;  
        
end


%Making an array of string that has the bipolar channel names.
for i=1:NChannels
    tempStr = strcat(Cube.montageNameArray{i,1},'-',Cube.montageNameArray{i,2});
    Cube.montageBipolarName{i} = tempStr;
end

Cube.montageBipolarName = Cube.montageBipolarName';
montageBipolarNames = Cube.montageBipolarName;


Data_Power_Total = zeros(NRows,NChannels);

%the below loop sums the total power in each band for every time-point
for i=1:NChannels
    for j=1:NRows
        Data_Power_Total(j,i) = sum(Data_Power(j,1:NBands,i));
    end
end


Data_Power_Norm = zeros(NRows,NBands,NChannels);

%Normalizes each channel, for each band, to the total power at each point
%in time across all bands - this is a unitless ratio.
for i=1:NChannels
    for j=1:NBands
        Data_Power_Norm(1:NRows,j,i) = (Data_Power(1:NRows,j,i) ./ Data_Power_Total(1:NRows,i));
    end
end

Cube.DataPowerNormal=Data_Power_Norm;


%Same as the normalized results but smoothed by "SmoothWindow" points.
Data_Power_Norm_SM = zeros(NRows,NBands,NChannels);
SmoothWindow = 2;

for i=1:NChannels
    for j=1:NBands
        Data_Power_Norm_SM(1:NRows,j,i) = filter(ones(1,SmoothWindow)/SmoothWindow,1,Data_Power_Norm(1:NRows,j,i));
    end
end

Cube.DataPowerNormSM=Data_Power_Norm_SM;


%Computing and saving the R values for Sz vs. BKGND comparison
R = ComputeBandComparison_ver02(Cube.Data,Cube.TimeLine,bgstart,bgend,szstart,szend, patientName, eventNumber);

Cube.Rvalues=R;
Cube.bandComparison.bgstart=bgstart;
Cube.bandComparison.bgend=bgend;
Cube.bandComparison.szstart=szstart;
Cube.bandComparison.szend=szend;


rvaluesavename=strcat(patientName, strcat('_Preictal_R_Values_For_E', sprintf('%g',eventNumber)));
rvaluesavename=strcat(rvaluesavename, '.asc');
disp(strcat('Saving R-Values as: ', sprintf('%s',rvaluesavename)));
RTrans = R'; %transposing just for the save;
save(rvaluesavename, 'RTrans', '-ascii');

% HOUMAN - COMMENTING OUT PLOTTING ON 18 DEC. 2006
%
%Plotting results
%
% PlotBandComparison_ver03(patientName,eventNumber,R,montageBipolarNames,PreIctalComparison)
% fig1 = figure(1);
% disp('Graph Completed, Now Saving');
% savejpgname=strcat(patientName, '_Preictal_Rvalue_Band_Graph_E');
% savejpgname=strcat(savejpgname, sprintf('%g', eventNumber));
% %savejpgname=strcat(savejpgname, '.jpg');
% disp(savejpgname);
% sprintf('Saving As %g', savejpgname);
% saveas(fig1, savejpgname, 'emf');


disp('Now Saving Data Cube');
savename=strcat(patientName, '_DataCube_E');
savename=strcat(savename, sprintf('%g' ,eventNumber));
savename=strcat(savename, '.mat');
sprintf('Cube Creation Successful for %g' , patientName);
sprintf('Saving Cube As %g', savename);
save(savename, 'Cube', '-mat');



clear ST_results;
clear R;
clear Data_Power_Total;
clear Data_Power_Norm_SM;
clear Data_Power_Norm;
clear Data_Power;
clear Data_Time;

disp('END BATCH PROCESS - RESULTS MERGED');

toc