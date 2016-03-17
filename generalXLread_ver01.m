function generalXLread_ver01(filename)

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
    %reading Excel file
    currentData = xlsread(tline,'Sheet1');
    
    if (j == 1)
        [m,n] = size(currentData);
        totalData = zeros(m,n,numfiles);
    end

    totalData(1:m,1:n,j) = currentData(1:m,1:n);
    
end


filenameOutput = strcat(filename,'.mat');
save(filenameOutput,'totalData','-mat');



disp('END BATCH PROCESS');

fclose(fid);

clear all;
close all;
toc;