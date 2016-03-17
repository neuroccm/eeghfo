function temporalRanalysis_ver06(DataCube,backgroundtimeslist, eventNumber, windowSize, MoneyChannelNum)
% ___________                                       .__   
% \__    ___/___   _____ ______   ________________  |  |  
%   |    |_/ __ \ /     \\____ \ /  _ \_  __ \__  \ |  |  
%   |    |\  ___/|  Y Y  \  |_> >  <_> )  | \// __ \|  |__
%   |____| \___  >__|_|  /   __/ \____/|__|  (____  /____/
%              \/      \/|__|                     \/      
%    _____                .__               .__        
%   /  _  \   ____ _____  |  | ___.__. _____|__| ______
%  /  /_\  \ /    \\__  \ |  |<   |  |/  ___/  |/  ___/
% /    |    \   |  \/ __ \|  |_\___  |\___ \|  |\___ \ 
% \____|__  /___|  (____  /____/ ____/____  >__/____  >
%         \/     \/     \/     \/         \/        \/ 
%
%**************************************************************************
%                         VER 06 - 3 JAN. 2007
%**************************************************************************
%I am modifying this function - Dated: 3 Jan. 2007 - to make sure that it
%outputs only 30s of data back from the seizure start time and also for it
%to accept an array of channel numbers for the field "MoneyChannelNum" -
%this way several channel's outputs over time and for each band can be
%requested at the same time.
%
% USAGE ASSUMPTION:
% MoneyChannelNum - FIRST channel should be number of seizureonset
% channel!
%DataCube - DataCube name, from merge_results_STFTver10preictal.m
%backgroundtimeslist - ascii filenames for background times
%eventnumber - event number
%window size in seconds - 5 sec. was used for HFO human study 01
%MoenyChannelNum - a vector quantity, a list of channel numbers- it is
%assumed that the first channel listed is the ictal onset channel, the next
%channel listed is the next to/neighbouring channel, and the third channel
%is the distant/noninvolved channel. Other channels that may be in the
%vector will be analyzed as well but will not have any assumptions attached
%to them.
%
%This function takes any DataCube (created from a specific event of a
%patient) and the backgroundtimeslist where all the background time
%segments are located.
warning off;
close all;


load (DataCube);
Data = Cube.Data;

disp('Proceeding with Temporal Analysis...');

seizureStartTime = Cube.bandComparison.szstart;

%Assumung first number in vector is the "money" channel - i.e. the channel
%of ictal onset.
CTA.MoneyChannelName = Cube.montageBipolarName{MoneyChannelNum(1),1};

[NRow,NBands,NChannels] = size(Data);
Time=Cube.TimeLine;
timelist=load(backgroundtimeslist); 



%the following is used to make a 'fake' RCube to put into the createRCube
%function.  None of this data matters, it is only used to get the corrected
%indices for the RCube.  This RCube is replaced by another one made in
%createRCube anyways.

bgstart=timelist(1,1);


bgstart_index = find(Time >= bgstart);
bgstart_index = bgstart_index(1);

bgend_index = find(Time <=( bgstart+windowSize));
bgend_index = bgend_index(end);

analysis_startindex = 1;

window=bgend_index - bgstart_index; %window of analysis

analysisLength = length(Time);

delta = fix(0.5*window);

%NOTE - CAUTION
%we are throwing away the last 2 delta-duration windows of the analysis -
%the same is being done when "n" is being computed.
N_R_Cube_Rows = fix(analysisLength/delta)-4;


%now we get the average R values over all the times during the seizure.
%This is done by creating an RCube for each background time segment.  Once
%all RCubes are received, all values in the summed RCube are divided by the
%number of background segments there were to give an AverageRCube -
%containing the average R Values for each segment of time in the Seizure
%compared to each given background segment.

numberOfBackgrounds=length(timelist);
PreDeclaredCube=zeros(N_R_Cube_Rows,NBands,NChannels);
       
[RCubeTimeValues,RCube] = createRCube(PreDeclaredCube,Data,Time,timelist,analysis_startindex,numberOfBackgrounds,windowSize);
AverageRCube = RCube ./ numberOfBackgrounds;

CTA.RValues = AverageRCube;
[NRow,NBands,NChannels] = size(CTA.RValues);
CTA.TimeValues = RCubeTimeValues;

%Right at this point the R-temporal cube is ready and computed for all
%times, across all bands, and for all the channels. At this point. I will
%introduce a loop of sorts to export a select region of time (say 30s back
%from seizure onset) and then also for a set number of channels that can be
%given as a vector in the parameter MoneyChannel

%we will leave this as is - it will export the CTA.MoneyChannel for the
%entire time series, assuming the first channel is always specified as the
%seizure onset channel.
CTA.MoneyChannel = CTA.RValues(1:NRow,1:NBands,MoneyChannelNum);

numberofChannelsofInterest = length(MoneyChannelNum);


%finding the index when the seizure start time corresponds to
seizurestart_index = find(RCubeTimeValues >= seizureStartTime);
seizurestart_index = seizurestart_index(1);
nIndeciesBackFromSeizureOnset = 15; %*****CAUTION - NOW STATIC *****
seizurePreictalBack = seizurestart_index - nIndeciesBackFromSeizureOnset;


TextMoneyChannelR_values = zeros(nIndeciesBackFromSeizureOnset+1,NBands+1);
TextMoneyChannelR_values_WO_time = zeros(nIndeciesBackFromSeizureOnset+1,NBands);

[NRows,NBands,NChannels] = size(CTA.MoneyChannel);
All_TextMoneyChannelR_values = zeros(NRows,NBands+1);
All_TextMoneyChannelR_values(1:NRows,1) = CTA.TimeValues(1:NRows,1);
All_TextMoneyChannelR_values(1:NRows,2:NBands+1) = CTA.MoneyChannel(1:NRows,1:NBands);
All_RMoneyChannelFilename=strcat((sprintf('MCTA-FULL-TemporalAnalysis_E%g_Onset_CH%g' , eventNumber, MoneyChannelNum(1))), '.asc');
save(All_RMoneyChannelFilename,'All_TextMoneyChannelR_values','-ascii');



for i = 1:numberofChannelsofInterest

    %this will get the channels that have been specified in the
    %MoneyChannelNum variable as a vector quantity.
    CurrentChannel = MoneyChannelNum(i);
    TextMoneyChannelR_values(1:nIndeciesBackFromSeizureOnset+1,1) = RCubeTimeValues(seizurePreictalBack:seizurestart_index,1);
    TextMoneyChannelR_values(1:nIndeciesBackFromSeizureOnset+1,2:NBands+1) = CTA.RValues(seizurePreictalBack:seizurestart_index,1:NBands,CurrentChannel);    
    TextMoneyChannelR_values_WO_time(1:nIndeciesBackFromSeizureOnset+1,1:NBands) = CTA.RValues(seizurePreictalBack:seizurestart_index,1:NBands,CurrentChannel);
    
    %renaming the file output for the first three vector channel numbers   
    switch i;
        
        % MCTA - multi-channel temporal analysis.
        
        case 1;
                RMoneyChannelFilename=strcat((sprintf('MCTA01-TemporalAnalysis_E%g_Onset_CH%g' , eventNumber, CurrentChannel)), '.asc');
        case 2;
                RMoneyChannelFilename=strcat((sprintf('MCTA02-TemporalAnalysis_E%g_Near_CH%g' , eventNumber, CurrentChannel)), '.asc');
        case 3
                RMoneyChannelFilename=strcat((sprintf('MCTA03-TemporalAnalysis_E%g_Distant_CH%g' , eventNumber, CurrentChannel)), '.asc');
        otherwise
                RMoneyChannelFilename=strcat((sprintf('MCTA-TemporalAnalysis_E%g_CH%g' , eventNumber, CurrentChannel)), '.asc');
    end

    %saving data w/o the time column.
    save(RMoneyChannelFilename,'TextMoneyChannelR_values_WO_time','-ascii');
    disp(strcat('Saving...',RMoneyChannelFilename));

end


savefilename=(sprintf('CubeTemporalAnalysis_E%g_CH%g' , eventNumber, MoneyChannelNum(1)));
imagefilename=strcat(savefilename, '.jpg');
savefilename=strcat(savefilename,  '.mat');
%Saving R values in cube
save(savefilename, 'CTA', '-mat');
disp(strcat('Saving...',savefilename));

fig1 = figure(1);

%plot(CTA.TimeValues,CTA.RValues(:,:,MoneyChannelNum)); %this used to plot
%the entire R analysis - now restricting to what is being saved
plot(CTA.TimeValues(seizurePreictalBack:seizurestart_index,1),CTA.RValues(seizurePreictalBack:seizurestart_index,1:NBands,MoneyChannelNum(1)));
axis tight;
ylabel('R (Analysis:BKGND)');xlabel('Time (sec)');colormap(jet);
legend('0-100Hz','100-200Hz','200-300Hz','300-400Hz','400-500Hz','Location','EastOutside');

%Saving plot
saveas(fig1, imagefilename, 'jpg');

close all;




%**************************************************************************
%                       Recursive Function - for calculation
%**************************************************************************
function [RCubeTimeValues ,RCubeMeanValues] = createRCube(RCube,Data,Time,timelist,analysis_startindex,numberOfBackgrounds,windowSize)



[NRow,NBands,NChannels] = size(Data);

Static_numberOfBackgrounds=length(timelist);

if(numberOfBackgrounds==0)

   [x,y,z]=size(RCube);
            
   RCubeMeanValues =zeros(x,y,z);
   RCubeTimeValues=zeros(10,1);
   
   return;

    
end

if(numberOfBackgrounds>0)

    bgstart=timelist(numberOfBackgrounds,1);
    bgend=bgstart+windowSize;
    bgstart_index = find(Time >= bgstart);
    bgstart_index = bgstart_index(1);

    bgend_index = find(Time <= (bgstart+windowSize));
    bgend_index = bgend_index(end);

    window = bgend_index - bgstart_index;

    %startindex is coming in as a function parameter in the units of index
    %- see "analysis_startindex"
    StartIndex=analysis_startindex;
    EndIndex=(analysis_startindex+window)-1;
    
  
    %now that we have the times represented as indices, we first create the
    %background R slice.

    background_slice=sum(Data(bgstart_index:bgend_index,1:NBands,1:NChannels));

    %now we create the RCube... a 3d matrix containing rvalues (from comparing
    %to the background slice) for each delta unit of time for each
    %band/channel... thus n=lengthofseizure/delta and thus, n x NBands x
    %NChannels.

    
    analysisLength = length(Time);


    delta = fix(0.5*window); %OVERLAP FRACTION - during computation of R in NRows direction, this is in point number
    
    n = fix(analysisLength/delta)-4;
    RCubeTimeLine=zeros(n,1);

    %NOTE - as we window through in the NRows direction with index values
    %and Delta overlap, we are excluding the last "remainder" of indecies
    %that are present in the entire record
   

   
    for h=1:n

        seizureslice1=sum(Data(StartIndex:EndIndex,1:NBands,1:NChannels));
        numerator=seizureslice1(1,1:NBands,1:NChannels)-background_slice(1,1:NBands,1:NChannels);
        denominator=background_slice(1,1:NBands,1:NChannels);
        RCube(h,1:NBands,1:NChannels)= numerator ./ denominator;
        
        RCubeTimeLine(h,1)=(Time(StartIndex)+Time(EndIndex))/2;
        
        StartIndex=StartIndex+delta;
        EndIndex=EndIndex+delta;



    end

    %Recursive Call:
    [RCubeTimeValues, RCube1]=createRCube(RCube,Data,Time,timelist,analysis_startindex,numberOfBackgrounds-1, windowSize);
    RCube = RCube + RCube1;
    RCubeTimeValues=RCubeTimeLine;
    RCubeMeanValues = RCube;
    
end