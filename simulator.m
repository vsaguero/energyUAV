% Simulation parameters
simulationTime = 3600;

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
    load('areas3')
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

if scenario == 5
    areas = [300 500; 300 450; 300 400; 300 350; 350 350; 350 300; 350 250; 350 200; 350 150; 300 150; 400 150; 400 250; 450 250; 450 300; 450 350; 500 350; 450 400; 500 400; 550 400; 600 400; 400 100; 450 100; 400 50; 350 50; 400 0; 250 350; 200 350; 200 300; 200 250; 200 200; 250 250; 150 200; 100 200; 100 250; 100 150; 100 100;  150 100; 50 100; 100 50; 100 0; 150 350; 150 400; 100 400; 100 350; 100 450; 50 400; 50 450; 0 450; 0 500; 0 550];
    % Users per area
    users = [1; 5; 10; 10; 10; 10; 10; 10; 0 ; 5; 10; 0; 30; 100; 50; 100; 50; 200; 100; 100; 10; 10; 10; 10; 10; 5; 5; 5; 10; 10; 5; 10; 0; 10; 0; 0; 5; 10; 10; 10; 10; 5; 10; 10; 4; 4; 4; 4; 4; 4];
    % GCS location
    GCSpositions = [300 550;];
    % numberOfUAVs

    scenario = 'scenario_4_';
    
    scatter(areas(:,1), areas(:,2), 'bo', 'filled')
    hold on
    scatter(GCSpositions(:,1), GCSpositions(:,2), 'gd', 'filled')
    box
    grid
end


date = clock;

if heuristic == 1
    numberOfUAVs = 0;
    HE = [];
    for i=0:length(areas)
        numberOfUAVs =   i;
        [connectivityHE, connectivityHEbs, replacementsHE] = replacementHeuristic3BS(simulationTime, length(areas), numberOfUAVs, areas, sum(users), users, GCSpositions)
        HE(i+1,1) = connectivityHE
        HE(i+1,2) = connectivityHEbs
        HE(i+1,3) = replacementsHE
    end
    A = strcat(scenario,'HErepl','_',int2str(date(1)),'_',int2str(date(2)),'_',int2str(date(3)),'_',int2str(date(4)),'_',int2str(date(5)),'.mat');
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



