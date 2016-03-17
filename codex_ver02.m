function res = codex_ver02(numList,nameList,Value)
% takes the number list, takes the name list, takes the value (i.e. channel
% number) and then returns the name of that channel.


numrows=length(numList);
if(numrows~=length(nameList))
    disp('Error in Montage Input Arrays');
end
res='null';
for a=1:numrows  
                  
        if(numList(a)==Value)
           ind=a;
           
           res=nameList(ind);
           break;
        end 
        
end

