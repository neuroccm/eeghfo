function UniversalCubeMaker_ver02(patientName)

switch patientName
    case 'SA'
        
            merge_results_STFTver09('mergelist1', 'SA', 1);
            merge_results_STFTver10preictal('mergelist1', 'SA', 1);
            merge_results_STFTver09('mergelist2', 'SA', 2);
            merge_results_STFTver10preictal('mergelist2', 'SA', 2);
            merge_results_STFTver09('mergelist3', 'SA', 3);
            merge_results_STFTver10preictal('mergelist3', 'SA', 3);
            merge_results_STFTver09('mergelist4', 'SA', 4);
            merge_results_STFTver10preictal('mergelist4', 'SA', 4);

    case 'DO'
            merge_results_STFTver09('mergelist1', 'DO', 1);
            merge_results_STFTver10preictal('mergelist2', 'DO', 1);            
            merge_results_STFTver09('mergelist2', 'DO', 2);
            merge_results_STFTver10preictal('mergelist3', 'DO', 2);  
            merge_results_STFTver09('mergelist3', 'DO', 3);
            merge_results_STFTver10preictal('mergelist3', 'DO', 3);  

    case 'MM'
            merge_results_STFTver09('mergelist1', 'MM', 1);
            merge_results_STFTver10preictal('mergelist1', 'MM', 1);
     
    case 'DB'
            merge_results_STFTver09('mergelist1', 'DB', 1);
            merge_results_STFTver10preictal('mergelist1', 'DB', 1);
            merge_results_STFTver09('mergelist2', 'DB', 2);
            merge_results_STFTver10preictal('mergelist2', 'DB', 2);
            merge_results_STFTver09('mergelist3', 'DB', 3);
            merge_results_STFTver10preictal('mergelist3', 'DB', 3);
            merge_results_STFTver09('mergelist4', 'DB', 4);
            merge_results_STFTver10preictal('mergelist4', 'DB', 4);
    case 'MC'
            merge_results_STFTver09('mergelist1', 'MC', 1);
            merge_results_STFTver10preictal('mergelist1', 'MC', 1);
            merge_results_STFTver09('mergelist2', 'MC', 2);
            merge_results_STFTver10preictal('mergelist2', 'MC', 2);
%             merge_results_STFTver09('mergelist3', 'MC', 3);
%             merge_results_STFTver10preictal('mergelist3', 'MC', 3);

    case 'PB'
            merge_results_STFTver10preictal('mergelist1', 'PB', 1);
            merge_results_STFTver10preictal('mergelist3', 'PB', 3);
            merge_results_STFTver10preictal('mergelist4', 'PB', 4);
            merge_results_STFTver10preictal('mergelist5', 'PB', 5);
            merge_results_STFTver10preictal('mergelist6', 'PB', 6);
    case 'EF'
            merge_results_STFTver09('mergelist1', 'EF', 1);
            merge_results_STFTver10preictal('mergelist1', 'EF', 1);
            merge_results_STFTver09('mergelist2', 'EF', 2);
            merge_results_STFTver10preictal('mergelist2', 'EF', 2);
            merge_results_STFTver09('mergelist3', 'EF', 3);
            merge_results_STFTver10preictal('mergelist3', 'EF', 3);
            merge_results_STFTver09('mergelist4', 'EF', 4);
            merge_results_STFTver10preictal('mergelist4', 'EF', 4);
    otherwise
           disp('Patient Not Found');
            return;
end