function R = ComputeBandComparison_ver02(Data, Time, startA, endA, startB, endB, patientName, eventNumber)
% LAST REVISED: 16 June 06
% This file computes the "R" values, which compare a segment of background
% EEG to a segment during seizure activity.
% (resultfile,startA, endA, startB, endB) - montage file, channelnamefile


DataCube=Data;
DataCubeTime=Time;
%assume user enters startA in sec. find the index of those seconds.

startA_index = find(DataCubeTime >= startA);
startA_index = startA_index(1);

endA_index = find(DataCubeTime <= endA);
endA_index = endA_index(end);


startB_index = find(DataCubeTime >= startB);
startB_index = startB_index(1);

endB_index = find(DataCubeTime <= endB);
endB_index = endB_index(end);


[NRows,NBands,NChannels] = size(DataCube);

bkgndSlice=zeros(1,NBands,NChannels);
seizureSlice=zeros(1,NBands,NChannels);

bkgndSlice = sum(DataCube(startA_index:endA_index,:,:));
seizureSlice = sum(DataCube(startB_index:endB_index,:,:));

R=zeros(NBands,NChannels);
 
for nbands=1:NBands
       for nchannels=1:NChannels
           
           numerator = seizureSlice(1,nbands, nchannels) - bkgndSlice(1,nbands,nchannels);
           denominator = bkgndSlice(1,nbands,nchannels);
           R(nbands,nchannels) = numerator/denominator;
           
       end
end


