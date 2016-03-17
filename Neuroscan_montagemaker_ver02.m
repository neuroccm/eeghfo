function Neuroscan_montagemaker_ver02(filename,montagefile)
%The following - is the revised and renamed version of the original
%montagemaker_NMver01.m - this file does the same thing, the filenames have
%an underscore _s.mat output.
%
% Revision Date - 13 June 2006.


%prepares filenames for usage in the rest of the code.
filename1 = strcat(filename,'.cnt');
montagefile = strcat(montagefile,'.asc');


%This loads the montagefile given for a particular patient.  These are the 
%actual montage channel numbers (not the computer interpretation).
%This data will be mapped to different numbers using the computers values
%for the channel.
montagearray_act = (load(montagefile));

%open an event file and store the header information, Number of Channels in
%the event file and the number of channels from the montage.
HDR = sopen(filename1);
NCh = HDR.InChanSelect(end,1);
NCh_Bipolar = length(montagearray_act);
ChannelIndex = (1:1:NCh)';

%getting the actual Channel numbers from the HDR file and putting it into
%an array.
for i=1:NCh
    NActChannel(i,1) = str2num(strcat(HDR.Label(i,1),HDR.Label(i,2)));
end

%create the lookup table to find the actual channel values and convert them
%into the computer-known channels.
LookUpTable = zeros(NCh,2);
LookUpTable(:,1) = ChannelIndex;
LookUpTable(:,2) = NActChannel;
montagearray_index = zeros(NCh_Bipolar,2);

%Actually Create the Montage Table with the Channel values known by the
%computer.
for j=1:2
    for i=1:NCh_Bipolar
       CurrentActualCh = montagearray_act(i,j);
       CurrentIndexCh = find(CurrentActualCh == LookUpTable(:,2));
       montagearray_index(i,j) = CurrentIndexCh;
    end
end

%The segLen is how long (in seconds) of a segment is desired. Change this
%variable To change the number of segments and thus the size of each
%segmented file.
segLen = 500;
%returns the total length of the event in seconds.
TotalDuration = HDR.NRec*HDR.SPR/HDR.SampleRate; 
%returns the number of segments made.
NCalls = floor(TotalDuration / segLen); 
%The remainder is the incomplete segment at the end of each file. It will
%always be smaller as it is what is left over after all the segments are
%created.
Remainder=floor(TotalDuration-(segLen*NCalls));


disp(strcat('Please Wait...', sprintf('Proceeding To Save %g Files', (NCalls+1))));

for k=1:(NCalls+1)%NCalls+1 becuase of the remainder file.
   disp(strcat((strcat('Reading: ', strcat(filename1, ', SEGMENT...'))), sprintf('(%g of %g)', k, (NCalls+1))));      
   if(k==(NCalls+1))
                %when we have reached the last segment (remainder).
               [s,HDR]=sread(HDR,Remainder);
    
   else    
               [s,HDR]=sread(HDR,segLen);
   end        
    SegmentNRows=length(s);
    %Create the bipolar montage, which is the data of each segment with all
    %the corrections required from the montage file given.
    bipolarmontage = zeros(SegmentNRows,NCh_Bipolar);    
    for i=1:NCh_Bipolar 
        
           bipolarmontage(:,i) = (s(:,montagearray_index(i,1)) - s(:,montagearray_index(i,2)));
    end
        
    Data=bipolarmontage;
    clear bipolarmontage;
    clear s;
    
    %Finally, save the segment  and the variable 'Data' and then continue
    %on to the next segment.
    savefilename= sprintf('_s_%g', k);
    completed_fname = strcat(filename,savefilename);
    disp(strcat('Saving: ', strcat(completed_fname, '.mat...')));
    save (completed_fname, 'Data');
    
    clear Data;
       
end


disp('Segment Saving Complete.');