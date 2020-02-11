% Simulation parameters
simulationTime = 36000;

% Select 1 the desired algorithm
heuristic = 1;
reported = 0;
legacy = 0;

% Select between the scenarios 1, 2, 3 or custom
scenario = 3;

if scenario == 1
    % Target areas
    areas = [50 100; 50 150; 0 150; 50 200; 50 50; 50 0;];
    % Users per area
    users = [10; 40; 100; 80; 50; 20;];
    % GCS location
    GCSpositions = [100 100;];
    
    scenario = 'scenario_1_';
    
    scatter(areas(:,1), areas(:,2), 'bo', 'filled')
    hold on
    scatter(GCSpositions(:,1), GCSpositions(:,2), 'gd', 'filled')
    box
    grid
end
 
if scenario == 2
    % Target areas
    %areas = [0 0; 50 0; 100 0; 150 0; 200 0; 0 50; 50 50; 100 50; 150 50; 200 50; 0 100; 50 100; 100 100; 150 100; 200 100; 0 150; 50 150; 100 150; 150 150; 200 150; 0 200; 50 200; 100 200; 150 200; 200 200];
    % Users per area
    %users = [10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10;];
    users = [10; 30; 50; 10; 30; 50; 10; 30; 50; 10; 30; 50; 10; 30; 50; 10; 30; 50; 10; 30; 50; 10; 30; 50; 10;];

    areas = [200 0;150 0;200 50;100 0;50 0;0 0;200 100;150 50; 100 50;200 150;150 100;50 50;200 200; 0 50; 100 100; 150 150; 50 100; 150 200; 0 100; 100 150; 100 200; 50 150; 0 150; 50 200; 0 200];
    %areas = flip(areas)
    % GCS location
    GCSpositions = [0 250;];
    % numberOfUAVs

    scenario = 'scenario_2_';

%     scatter(areas(:,1), areas(:,2), 'bo', 'filled')
%     hold on
%     scatter(GCSpositions(:,1), GCSpositions(:,2), 'gd', 'filled')
%     box
%     grid
end

if scenario == 3
    % Target areas
    areas = [0 0; 100 0; 50 0; 50 50; 50 100; 50 150; 50 200; 250 50; 200 0; 200 50; 150 50; 150 100; 150 150; 150 200; 100 200; 100 250; 100 300; 50 300; 200 200; 200 250; 200 300; 250 300; 200 350; 0 300; 0 350];
    % Users per area
    users = [10; 10; 10; 10; 10; 10; 10; 200; 500; 200; 50; 50; 50; 10; 10; 10; 10; 10; 10; 20; 50; 20; 100; 100; 100];
    % GCS location
    GCSpositions = [100 350;];
    % numberOfUAVs

    scenario = 'scenario_3_';
    
%     scatter(areas(:,1), areas(:,2), 'bo', 'filled')
%     hold on
%     scatter(GCSpositions(:,1), GCSpositions(:,2), 'gd', 'filled')
%     box
%     grid
end

if scenario == 4
    % Target areas
    areas = areas3
    % Users per area
    users = [10; 30; 50; 10; 30; 50; 10; 30; 50; 10; 30; 50; 10; 30; 50; 10; 30; 50; 10; 30; 50; 10; 30; 50; 10; 30; 50; 10; 30; 50; 10; 30; 50; 10; 30; 50; 10; 30; 50; 10; 30; 50; 10; 30; 50; 10; 30; 50; 10; 30];
    % GCS location
    GCSpositions = [0 250;];
    % numberOfUAVs

    scenario = 'scenario_4_';
    
%     scatter(areas(:,1), areas(:,2), 'bo', 'filled')
%     hold on
%     scatter(GCSpositions(:,1), GCSpositions(:,2), 'gd', 'filled')
%     box
%     grid
end



date = clock;

if heuristic == 1
    numberOfUAVs = 0;
    HE = [];
    for i=0:length(areas)
        numberOfUAVs =   i;
        [connectivityHE, connectivityHEbs, replacementsHE] = replacementHeuristic3AP(simulationTime, length(areas), numberOfUAVs, areas, sum(users), users, GCSpositions)
        HE(i+1,1) = connectivityHE
        HE(i+1,2) = connectivityHEbs
        HE(i+1,3) = replacementsHE
    end
    A = strcat(scenario,'HE','_',int2str(date(1)),'_',int2str(date(2)),'_',int2str(date(3)),'_',int2str(date(4)),'_',int2str(date(5)),'.mat');
    save(A,'HE');
end

if reported == 1
    numberOfUAVs = 0;
    RP = [];
    for i=0:length(areas)
        numberOfUAVs = i;
        [connectivityRP, connectivityRPbs, replacementsRP] = replacementReportedParameters(simulationTime, length(areas), numberOfUAVs, areas, sum(users), users, GCSpositions)
        RP(i+1,1) = connectivityRP
        RP(i+1,2) = connectivityRPbs
        RP(i+1,3) = replacementsRP
    end
    A = strcat(scenario,'RP','_',int2str(date(1)),'_',int2str(date(2)),'_',int2str(date(3)),'_',int2str(date(4)),'_',int2str(date(5)),'.mat');
    save(A,'RP');
end

if legacy == 1
    numberOfUAVs = 0;
    LG = [];
    for i=0:length(areas)
        numberOfUAVs = i;
        [connectivityLG, connectivityLGbs, replacementsLG] = replacementLegacy(simulationTime, length(areas), numberOfUAVs, areas, sum(users), users, GCSpositions)
        LG(i+1,1) = connectivityLG
        LG(i+1,2) = connectivityLGbs
        LG(i+1,3) = replacementsLG
    end
    A = strcat(scenario,'LG','_',int2str(date(1)),'_',int2str(date(2)),'_',int2str(date(3)),'_',int2str(date(4)),'_',int2str(date(5)),'.mat');
    save(A,'LG');
end



