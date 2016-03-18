function generalMatrixTTest_ver01(filename1,filename2)

%This is a general t-test algorithm that is able to compare for Ntimes
%point vs. NBands vs. Npatients (x,y,z - cube) across patients if there is
%a difference betweeen data cube 1 in filename 1 to data cube 2 in
%filename 2 for different bands and different time points.
% Last revised = 5 Jan. 2007

close all;
%turning off erros
warning off MATLAB:colon:operandsNotRealScalar;
warning off MATLAB:divideByZero;

dataCube1 = load(filename1);
dataCube2 = load(filename2);

%assuming the files have each an array called "totalData"
dataSeries1 = dataCube1.totalData;
dataSeries2 = dataCube2.totalData;

[x1,y1,z1] = size(dataSeries1);
[x2,y2,z2] = size(dataSeries2);

%checking and making sure all array dimensions are the same
if (x1 == x2) & (y1 == y2) & (z1 == z2)
    NTimes = x1;
    NBands = y1;
    NPatients = z1;
else
    disp('Problem - array dimensions do not match!');
end


compMatrix_Hyp = zeros(NTimes,NBands); %hypothesis, 1 = different (i.e. reject null), 0 = no difference between means
compMatrix_P = zeros(NTimes,NBands); %p-values for each t-test

for i = 1:NTimes
    
    for j = 1:NBands
    
        [compMatrix_Hyp(i,j),compMatrix_P(i,j)] = ttest2(dataSeries1(i,j,1:NPatients),dataSeries2(i,j,1:NPatients));
        
    end
    
end

filenameHypothesis = strcat(filename1,'_',filename2,'_Hyp.asc');
save(filenameHypothesis,'compMatrix_Hyp','-ascii');
% fid = fopen(filenameHypothesis, 'w');
% fprintf(fid, '%4.5', compMatrix_Hyp);
% fclose(fid);
% 
filenamePValues = strcat(filename1,'_',filename2,'_Pvalues.asc');
save(filenamePValues,'compMatrix_P','-ascii');
% fid = fopen(filenamePValues, 'w');
% fprintf(fid, '%4.3', compMatrix_P);
% fclose(fid);

clear all;
close all
end


