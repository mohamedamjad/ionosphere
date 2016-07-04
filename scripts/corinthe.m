function corinthe(station1_filepath, station2_filepath, station3_filepath)
    
    station1_data = dlmread(station1_filepath);
    station2_data = dlmread(station2_filepath);
    station3_data = dlmread(station3_filepath);
    
    % Calculer la ligne de base
    min1 = min(size(station1_data, 1),size(station2_data, 1));
    
    baseline12=[];
    for i=1:min
        baseline12(i,1) = sqrt((station1_data(i,1)-station2_data(i,1))^2+(station1_data(2,1)-station2_data(i,2))^2+(station1_data(i,3)-station2_data(i,3))^2) 
    end
    
    baseline13=[];
    for i=1:min
        baseline13(i,1) = sqrt((station1_data(i,1)-station3_data(i,1))^2+(station1_data(2,1)-station3_data(i,2))^2+(station1_data(i,3)-station3_data(i,3))^2) 
    end
    
    % Les plots
    plot
end