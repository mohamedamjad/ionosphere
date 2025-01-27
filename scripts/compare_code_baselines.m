% Author: Amjad
% Comparaison entre les lignes de base calculées à partir 
% des positions naviguées et à partir du SPP (single point positioning)
% avec correction des SBAS.

function [residuals_navpos,residuals_spp_sbas] = compare_code_baselines(cube1_navposfile, cube2_navposfile, cube1_sppsbasposfile, cube2_sppsbasposfile, exact_solution)
    residuals_navpos=[];
    residuals_spp_sbas=[];
    % Ouverture des fichiers et lecture des données des positions naviguées
    cube1_navpos = dlmread(cube1_navposfile);
    cube2_navpos = dlmread(cube2_navposfile);
    
    min_tmp = min(size(cube1_navpos,1),size(cube2_navpos,1));% minimum des sizes entre deux vectors
    
    % calcul des diffèrences de ligne de base
    for i = 1:min_tmp
        baseline_tmp = sqrt((cube1_navpos(i,1)-cube2_navpos(i,1))^2+(cube1_navpos(i,2)-cube2_navpos(i,2))^2+(cube1_navpos(i,3)-cube2_navpos(i,3))^2);
        residuals_navpos = [residuals_navpos ; baseline_tmp];
    end
    
    % Ouverture des fichiers et lecture des données des positions SPP et
    % SBAS
    cube1_sppsbaspos = dlmread(cube1_sppsbasposfile);
    cube2_sppsbaspos = dlmread(cube2_sppsbasposfile);
    
    min_tmp = min(size(cube1_sppsbaspos,1), size(cube2_sppsbaspos,1));
    
    % Calcul des diffèrences des lignes de bases
    for i = 1:min_tmp
        baseline_tmp = sqrt((cube1_sppsbaspos(i,3)-cube2_sppsbaspos(i,3))^2+(cube1_sppsbaspos(i,4)-cube2_sppsbaspos(i,4))^2+(cube1_sppsbaspos(i,5)-cube2_sppsbaspos(i,5))^2);
        residuals_spp_sbas = [residuals_spp_sbas ; baseline_tmp-exact_solution];
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  P O N D E R A T I O N  D E  L A  P O S I T I O N  N A V I G U E E  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%% pour le geocube fixe %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cube1_corrected_navpos = [];
    
    cube1_navpos_s2(:) = (cube1_navpos(:,4).^2 + cube1_navpos(:,5).^2)/1000000;
    
    
    cube1_corrected_navpos(1,1) = cube1_navpos(1,1); % X tilde
    cube1_corrected_navpos(1,2) = cube1_navpos(1,2); % Y tilde
    cube1_corrected_navpos(1,3) = cube1_navpos(1,3); % Z tilde
    cube1_corrected_navpos(1,4) = cube1_navpos(1,4)+cube1_navpos(1,5); % sigma tilde
    
    
    for i = 2 : size(cube1_navpos,1)
        if cube1_navpos_s2(i) < 100
            cube1_corrected_navpos(i, 4) = 1/(1/cube1_corrected_navpos(i-1,4) + 1/cube1_navpos_s2(i));
            k = cube1_corrected_navpos(i, 4);
            cube1_corrected_navpos(i, 1) = (cube1_corrected_navpos(i-1, 1)*1/cube1_corrected_navpos(i-1, 4) + cube1_navpos(i,1)*1/cube1_navpos_s2(i)) * k;
            cube1_corrected_navpos(i, 2) = (cube1_corrected_navpos(i-1, 2)*1/cube1_corrected_navpos(i-1, 4) + cube1_navpos(i,2)*1/cube1_navpos_s2(i)) * k;
            cube1_corrected_navpos(i, 3) = (cube1_corrected_navpos(i-1, 3)*1/cube1_corrected_navpos(i-1, 4) + cube1_navpos(i,3)*1/cube1_navpos_s2(i)) * k;
        else
            cube1_corrected_navpos(i, 1) = cube1_corrected_navpos(i-1, 1);
            cube1_corrected_navpos(i, 2) = cube1_corrected_navpos(i-1, 2);
            cube1_corrected_navpos(i, 3) = cube1_corrected_navpos(i-1, 3);
            cube1_corrected_navpos(i, 4) = cube1_corrected_navpos(i-1, 4);
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%% pour le geocube mobile %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cube2_corrected_navpos = [];

    cube2_navpos_s2(:) = (cube2_navpos(:,4).^2 + cube2_navpos(:,5).^2)/1000000;


    cube2_corrected_navpos(1,1) = cube2_navpos(1,1); % X tilde
    cube2_corrected_navpos(1,2) = cube2_navpos(1,2); % Y tilde
    cube2_corrected_navpos(1,3) = cube2_navpos(1,3); % Z tilde
    cube2_corrected_navpos(1,4) = cube1_navpos(1,4)+cube1_navpos(1,5); % sigma tilde


    for i = 2 : size(cube2_navpos,1)
        if cube2_navpos_s2(i) < 100
            cube2_corrected_navpos(i, 4) = 1/(1/cube2_corrected_navpos(i-1,4) + 1/cube2_navpos_s2(i));
            k = cube2_corrected_navpos(i, 4);
            cube2_corrected_navpos(i, 1) = (cube2_corrected_navpos(i-1, 1)*1/cube2_corrected_navpos(i-1, 4) + cube2_navpos(i,1)*1/cube2_navpos_s2(i)) * k;
            cube2_corrected_navpos(i, 2) = (cube2_corrected_navpos(i-1, 2)*1/cube2_corrected_navpos(i-1, 4) + cube2_navpos(i,2)*1/cube2_navpos_s2(i)) * k;
            cube2_corrected_navpos(i, 3) = (cube2_corrected_navpos(i-1, 3)*1/cube2_corrected_navpos(i-1, 4) + cube2_navpos(i,3)*1/cube2_navpos_s2(i)) * k;
        else
            cube2_corrected_navpos(i, 1) = cube2_corrected_navpos(i-1, 1);
            cube2_corrected_navpos(i, 2) = cube2_corrected_navpos(i-1, 2);
            cube2_corrected_navpos(i, 3) = cube2_corrected_navpos(i-1, 3);
            cube2_corrected_navpos(i, 4) = cube2_corrected_navpos(i-1, 4);
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                          L E S  P L O T S                           %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    figure
    plot(residuals_spp_sbas,'b')
    
    title('Différence entre la ligne de base calculée à partir des DD et celles calculées à partir des positions naviguées et positions SPP avec correction SBAS')
    xlabel('epochs')
    ylabel('diffèrence entre les lignes de base')
    
    figure
    plot(residuals_navpos,'r')
    
    figure
    title('précision horizontale')
    plot(cube1_navpos(:,4),'g')
    xlabel('epochs')
    ylabel('précision horizontale en mm')
    
    figure
    title('précision verticale')
    plot(cube1_navpos(:,5),'g')
    xlabel('epochs')
    ylabel('précision verticale en mm')
    
    % Plot X Y Z pour la position naviguée
    figure
    title('X Y Z pour la position naviguee KYLIA-12')
    subplot(3,1,1)
    plot(cube1_navpos(:,1),'b')
    
    subplot(3,1,2)
    plot(cube1_navpos(:,2),'b')
    
    subplot(3,1,3)
    plot(cube1_navpos(:,3),'b')
    
    % Plot X Y Z pour la position naviguée
    figure
    title('X Y Z pour la position naviguee KYLIA-12')
    subplot(3,1,1)
    plot(cube2_navpos(:,1),'r')
    
    subplot(3,1,2)
    plot(cube2_navpos(:,2),'r')
    
    subplot(3,1,3)
    plot(cube2_navpos(:,3),'r')
    
    % Plots des positions naviguées pondérées pour le cube fixe
    figure
    title('X Y Z pour la position naviguee KYLIA-12')
    subplot(3,1,1)
    plot(cube1_corrected_navpos(:,1)-4212927.32,'p')
    
    subplot(3,1,2)
    plot(cube1_corrected_navpos(:,2)-173609.92,'p')
    
    subplot(3,1,3)
    plot(cube1_corrected_navpos(:,3)-4769705.36,'p')
    
    % Plot des sigmas de la pondération des positions naviguées
    figure
    plot(sqrt(cube1_corrected_navpos(:,4)),'r')
    
    % Plot des positions naviguées pondérées pour le cube fixe
    figure
    title('X Y Z pour la position naviguee KYLIA-18')
    subplot(3,1,1)
    plot(cube2_corrected_navpos(:,1)-4201797.0472,'b')

    subplot(3,1,2)
    plot(cube2_corrected_navpos(:,2)-177941.0756,'b')

    subplot(3,1,3)
    plot(cube2_corrected_navpos(:,3)-4779282.1306,'b')

    % plot des sigmas de la pondération des positions naviguées
    figure
    plot(sqrt(cube2_corrected_navpos(:,4)),'b')
    
end
% position du KYLIA_12 4212927.3242    173609.9235   4769705.3600
% position du KYLIA_18 4201797.0472    177941.0756   4779282.1306
% remarque du chef: pondéré avec la précision de la position naviguée

% Ce que je peux rajouter: passer un coup de moindres carrés sur la
% position trouvée avec le SPP et sbas

% Execution et appel à la fonction pour le cas des cubes KYLIA_12,
% KYLIA_21 et KYLIA_18
%[residuals_navpos,residuals_spp_sbas] = compare_code_baselines('/home/anonyme/ionosphere/data/KYLIA_12/20160608_ubx.pos', '/home/anonyme/ionosphere/data/KYLIA_21/20160608_ubx.pos', '/home/anonyme/ionosphere/data/KYLIA_12/20160608_sbs_SPP.pos', '/home/anonyme/ionosphere/data/KYLIA_21/20160608_sbs_SPP.pos', 1.9880)
