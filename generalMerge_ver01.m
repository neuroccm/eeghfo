function generalMerge_ver01(filename)


%This is a general merge algorithm where a bunch of files are read in,
%their numbers are means and a mean and SEM file are generated in Excel.
%Note - array dimensions of the files being inputed must be the same.


close all;
%turning off erros
warning off MATLAB:colon:operandsNotRealScalar;
warning off MATLAB:divideByZero;


batchlist = strcat(filename,'.asc');


disp('STARTING BATCH MERGE PROCESS');
tic

%opening the file for reading, not read yet
fid = fopen(batchlist, 'rt');
numfiles = 0;
while (feof(fid) == 0)
   tempstr = fgetl(fid);
   numfiles = numfiles + 1;
end

status = fseek(fid,0,'bof');

totalData = 0;

for j = 1:numfiles;

    disp(sprintf('Currently working in file: %g of %g ...',j, numfiles));

    tline = fgetl(fid);
    currentData = load(tline);
    
    if (j == 1)
        [m,n] = size(currentData);
        totalData = zeros(m,n,numfiles);
    end

    totalData(1:m,1:n,j) = currentData(1:m,1:n);
    
end

%calculating averages from the imported tables


meanTable = zeros(m,n);
stdTable = zeros(m,n);
combinedTable = zeros(m,n*2);

comb_i = 1;
comb_j = 1;

for i=1:m
    for j=1:n
        
        %calculating mean and standard deviations
        meanTable(i,j) = mean(totalData(i,j,1:numfiles));
        stdTable(i,j) = std(totalData(i,j,1:numfiles)) / sqrt(numfiles);        
    end
end

filenameExcel = strcat(filename,'.xls');
xlswrite(filenameExcel,meanTable,'Sheet1');
xlswrite(filenameExcel,stdTable,'Sheet2');

%filenameASCII = strcat(filename,'_output','.asc');
%save(filenameASCII,'combinedTable','-ascii');


disp('END BATCH PROCESS');
toc

fclose(fid);

clear all;
close all;