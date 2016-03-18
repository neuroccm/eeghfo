function temporalRanalysis_ver05(DataCube,backgroundtimeslist, eventNumber, windowSize, MoneyChannelNum)
%This function takes any DataCube (created from a specific event of a
%patient) and the backgroundtimeslist where all the background time
%segments are located.
warning off;
close all;


load (DataCube);
Data = Cube.Data;

disp('Proceeding with Temporal Analysis...using a single "money channel"...');

seizureStartTime = Cube.bandComparison.szstart;

%other things to consider
CTA.MoneyChannelName = Cube.montageBipolarName{MoneyChannelNum,1};

[NRow,NBands,NChannels] = size(Data);
Time=Cube.TimeLine;
timelist=load(backgroundtimeslist); 

%****************************
%analysisStart=AnStart;
%****************************


%the following is used to make a 'fake' RCube to put into the createRCube
%function.  None of this data matters, it is only used to get the corrected
%indices for the RCube.  This RCube is replaced by another one made in
%createRCube anyways.

bgstart=timelist(1,1);


bgstart_index = find(Time >= bgstart);
bgstart_index = bgstart_index(1);


bgend_index = find(Time <=( bgstart+windowSize));
bgend_index = bgend_index(end);

% analysis_startindex = find(Time >=analysisStart);
% analysis_startindex = analysis_startindex(1);
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
CTA.MoneyChannel = CTA.RValues(1:NRow,1:NBands,MoneyChannelNum);

[NRows,NBands,NChannels] = size(CTA.MoneyChannel);
TextMoneyChannelR_values = zeros(NRows,NBands+1);
TextMoneyChannelR_values(1:NRows,1) = CTA.TimeValues(1:NRows,1);
TextMoneyChannelR_values(1:NRows,2:NBands+1) = CTA.MoneyChannel(1:NRows,1:NBands);

RMoneyChannelFilename=strcat((sprintf('MoneyChannelTemporalAnalysis_E%g_CH%g' , eventNumber, MoneyChannelNum)), '.asc');
save(RMoneyChannelFilename,'TextMoneyChannelR_values','-ascii');

savefilename=(sprintf('CubeTemporalAnalysis_E%g_CH%g' , eventNumber, MoneyChannelNum));

imagefilename=strcat(savefilename, '.jpg');

savefilename=strcat(savefilename,  '.mat');

%Saving R values in cube
save(savefilename, 'CTA', '-mat');
disp(savefilename);

fig1 = figure(1);
plot(CTA.TimeValues,CTA.RValues(:,:,MoneyChannelNum));
axis tight;
ylabel('R (Analysis:BKGND)');xlabel('Time (sec)');colormap(jet);
legend('0-100Hz','100-200Hz','200-300Hz','300-400Hz','400-500Hz','Location','EastOutside');

%Saving plot
saveas(fig1, imagefilename, 'jpg');



%*************************************************************************
%Recursive Function
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