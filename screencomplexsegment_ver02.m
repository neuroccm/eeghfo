function res = screencomplexsegment_ver02(Data)
%This version takes the array and "fixes" it for complex number,
%that is, it sets them to zero.

[NRows,NBands,NChannels]=size(Data);
for i=1:NRows
     for j=1:NBands
         for k=1:NChannels
             
             if(isnan(Data(i,j,k)))
                 Data(i,j,k)=0.0000;
             end
                 
             
         end
     end
end

res = Data;