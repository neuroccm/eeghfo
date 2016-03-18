function UniversalTemporalAnalysis_ver03(patientName)

switch patientName
    case 'SA'
            
            temporalRanalysis_ver06('Avanashi_DataCube_E1.mat','backgroundTimesList-Avanashi_E1.asc', 1, 5,[3,2,9]');
            temporalRanalysis_ver06('Avanashi_DataCube_E2.mat','backgroundTimesList-Avanashi_E1.asc', 2, 5,[3,2,9]');
            temporalRanalysis_ver06('Avanashi_DataCube_E3.mat','backgroundTimesList-Avanashi_E2.asc', 3, 5,[3,2,9]');
            temporalRanalysis_ver06('Avanashi_DataCube_E4.mat','backgroundTimesList-Avanashi_E2.asc', 4, 5,[3,2,9]');
            
    case 'DB'
            temporalRanalysis_ver06('Backlun_DataCube_E1.mat','backgroundTimesList-Backlund_E1.asc', 1, 5, [2,1,6]');
            temporalRanalysis_ver06('Backlun_DataCube_E2.mat','backgroundTimesList-Backlund_E2.asc', 2, 5, [2,1,6]');
            temporalRanalysis_ver06('Backlun_DataCube_E3.mat','backgroundTimesList-Backlund_E3.asc', 3, 5, 6);
            temporalRanalysis_ver06('Backlun_DataCube_E4.mat','backgroundTimesList-Backlund_E4.asc', 4, 5, 6);            
            
    case 'PB'
            temporalRanalysis_ver06('Baker_DataCube_E1.mat','backgroundTimesList-Baker_E1.asc', 1, 5, [5,4,9]'); 
            temporalRanalysis_ver06('Baker_DataCube_E3.mat','backgroundTimesList-Baker_E3.asc', 3, 5, [5,4,9]'); 
            temporalRanalysis_ver06('Baker_DataCube_E4.mat','backgroundTimesList-Baker_E4.asc', 4, 5, [5,4,9]'); 
            temporalRanalysis_ver06('Baker_DataCube_E5.mat','backgroundTimesList-Baker_E5.asc', 5, 5, 6); 
            temporalRanalysis_ver06('Baker_DataCube_E6.mat','backgroundTimesList-Baker_E6.asc', 6, 5, 6); 
            
            
            
    case 'DO'
            
            temporalRanalysis_ver06('Ostlund_DataCube_E1.mat','backgroundTimesList-Ostlund_E1.asc', 1, 5, [4,5,9]');
            temporalRanalysis_ver06('Ostlund_DataCube_E2.mat','backgroundTimesList-Ostlund_E2.asc', 2, 5, [4,5,9]');
            temporalRanalysis_ver06('Ostlund_DataCube_E3.mat','backgroundTimesList-Ostlund_E3.asc', 3, 5, [4,5,9]');
            
            
    case 'EF'
            temporalRanalysis_ver06('Fraser_DataCube_E1.mat','backgroundTimesList-Fraser_E1.asc', 1, 5, [6,5,3]');
            temporalRanalysis_ver06('Fraser_DataCube_E2.mat','backgroundTimesList-Fraser_E2.asc', 2, 5, [6,5,3]');
            temporalRanalysis_ver06('Fraser_DataCube_E3.mat','backgroundTimesList-Fraser_E3.asc', 3, 5, [6,5,3]');
            temporalRanalysis_ver06('Fraser_DataCube_E4.mat','backgroundTimesList-Fraser_E4.asc', 4, 5, [6,5,3]');            
            
    case 'MC'
            temporalRanalysis_ver06('Christienson_DataCube_E1.mat','backgroundTimesList-Christienson_E1.asc', 1, 5, [1,2,4]'); 
            temporalRanalysis_ver06('Christienson_DataCube_E2.mat','backgroundTimesList-Christienson_E2.asc', 2, 5, [1,2,4]');
                      
            
    case 'MM'
            temporalRanalysis_ver06('Mcclellan_DataCube_E1.mat','backgroundTimesList-mcclellan_E1.asc', 1, 5, [1,4,3]');
              




          

          

           
    otherwise
           disp('Patient Not Found');
            return;
end