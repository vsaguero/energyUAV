function [percentageUsersAP, numberOfReplacements] = replacementHeuristic (time, uavs, reserve, uavLocations, users, userLocation, gcs)
    
    %
    % FUNCTION PARAMETERS
    %
    % number of active UAVs
    numberOfUAVs = uavs;
    % number of reserve UAVs
    numberOfReserveUAVs = reserve;
    % number of users connected to any UAV
    numberOfUsers = users;
    % simulation time [s]
    simulationTime = time;
    % target areas
    UAVpositions = uavLocations;
    % users per area
    usersAP = userLocation;
    % GCS location
    GCSpositions = gcs;
    
    %
    % FIXED PARAMETERS
    %
    % the time needed to replace a battery
    batteryReplacementTime = 180;
    % the battery capacity [%]
    batteryCapacity = 100;
    % sampling time [s]
    samplingTime = 5;
    % maximum distance to consider a link
    maximumDistance = 50;
    % UAV speed [m/s]
    uavSpeed = 5;
    % takeoff time [s]
    takeOffTime = 60;
    % landing time [s]
    landingTime = 60;
    % valueTH
    THvalues = [40 50 60 70 80 90];
    % quarantine
    quarantineValue = 300;

    %
    % STATISTICS
    %
    numberOfReplacements = 0;
    valorUsersAP = 0;
    
    % Discrete event simulator stuff
    global queue maxQueue eventTime eventType eventNext eventIsFree eventNodeInvolved slotFreeFlag slotBusyFlag;

    maxQueue = 1000;
    eventTime = 1;
    eventType = 2;
    eventNext = 3;
    eventIsFree = 4;
    eventNodeInvolved = 5;
    slotBusyFlag = 0;
    slotFreeFlag = 1;

    queue = [ Inf*ones(maxQueue,1), zeros(maxQueue, 2) , slotFreeFlag*ones(maxQueue, 1), zeros(maxQueue,1)];

    evFirst = 1;
    evStopSim = 2;
    evSampling = 4;
    evReserveUp = 5;
    evReplacement = 6;
    evQuarantine = 7;
    currentEvent = 1;
    
    % Plot debug information (1=yes, 0=no)
    debug = 1;
    % Plot graphical interface (1=yes, 0=no)
    plot = 0;
    
    % Area battery array
    remainingBattery  = batteryCapacity*ones(1,numberOfUAVs);
    % Area replacement state array
    replacementScheduled = zeros(numberOfUAVs,1);
    % Quarantine
    quarantine = zeros(numberOfUAVs,1);
    % Area covering or not
    upDown = ones(1,numberOfUAVs);
    %How many UAVs are in the fleet (areas + reserveUAVs)
    reserveUAVs = numberOfReserveUAVs;
    
    
    adjacencyMatrix = generateMatrix(maximumDistance, UAVpositions, GCSpositions,numberOfUAVs,remainingBattery);
    [rankingIN] = rankingUAVs(numberOfUAVs,adjacencyMatrix, usersAP);
    %Comupute this ranking automatically in the next future
    %rankingIN = [6;2;5;4;3;1]
    %Consumption depending on the area
    consumption = ones(1, numberOfUAVs).*0.083;
    rankingIN
    %To check everything is correct
    if length(UAVpositions(:,1)) ~= length(usersAP)
        fprintf('UAVpositions and usersAP must have the same dimensions \n')
        return
    end
    
    % Battery thresholds per UAV to schedule a replacement
    batteryThresholds = zeros(1, numberOfUAVs);
    for i=1:length(UAVpositions) 
        distance = sqrt((GCSpositions(1,1)-UAVpositions(i,1))^2 + (GCSpositions(1,2)-UAVpositions(i,2))^2);
        batteryThresholds(i) = ((distance/uavSpeed)+takeOffTime)*2*consumption(i);
    end
    
    % Initial state of UAVs battery, without the battery of going to the target area
    remainingBattery = remainingBattery - (batteryThresholds/2);
   
    % Calculation of the maximum time over an area
    lifeTime = [];
    for i=1:length(remainingBattery)
        lifeTime(i) = (remainingBattery(i) - batteryThresholds(i)/2)/consumption(i);
    end
    
    % Array to modify values during the simulation
    change = lifeTime; 
 
    %First event
    queue(1, :)= [ 0 , evFirst , 2 , 0, 0 ];
    queue(2, :)= [ simulationTime , evStopSim , 0 , 0, 0 ];

    while true
        switch queue(currentEvent, eventType)

            case evStopSim
                fprintf( '--------------- \n Simulation ends \n');
                break;

            case evFirst
                fprintf( 'Simulation starts \n --------------- \n' );
                insertEvent(samplingTime, evSampling, 0);

            case evSampling
                % insert the next sampling event
                insertEvent(samplingTime+currentTime,evSampling,0);
                % decrease the battery corresponding to the samplingTime period
                %fprintf('Debug 2')
                remainingBattery = remainingBattery - consumption*samplingTime;
                % check if the battery is 0
                remainingBattery(remainingBattery < 0) = 0;
                %remainingBattery
                if reserveUAVs > 0
                    for k=1:length(THvalues)
                        for i=1:length(rankingIN)
                            if remainingBattery(rankingIN(i)) < THvalues(k) && replacementScheduled(rankingIN(i)) == 0 && quarantine(rankingIN(i)) == 0
                                distance = sqrt((GCSpositions(1,1)-UAVpositions(rankingIN(i),1))^2 + (GCSpositions(1,2)-UAVpositions(rankingIN(i),2))^2);
                                tripTime = (distance/uavSpeed);
                                totalTime = 2*tripTime + takeOffTime + landingTime + batteryReplacementTime;
                                aux = [];
                                aux = find(change < totalTime+currentTime);
                                aux2 = [];
                                for j=1:length(aux)
                                    if replacementScheduled(j) == 0
                                        aux2 = [aux2, find(rankingIN==aux(j))];
                                    end
                                end
                                if (sum(aux2 > i)) < reserveUAVs 
                                    if remainingBattery(rankingIN(i)) >= batteryThresholds(rankingIN(i))
                                        reserveUAVs = reserveUAVs - 1;
                                        replacementScheduled(rankingIN(i)) = 1;
                                        change(rankingIN(i)) = currentTime + tripTime + takeOffTime + lifeTime(rankingIN(i));
                                        insertEvent(currentTime+tripTime+takeOffTime, evReplacement, rankingIN(i));
                                        insertEvent(currentTime+quarantineValue, evQuarantine, rankingIN(i));
                                        quarantine(rankingIN(i)) = 1;
                                        insertEvent(currentTime+batteryReplacementTime+2*(tripTime+landingTime), evReserveUp, rankingIN(i));
                                    end
                                    if remainingBattery(rankingIN(i))< batteryThresholds(rankingIN(i)) && remainingBattery(rankingIN(i)) >= ((batteryThresholds(rankingIN(i))/2)+1)
                                        reserveUAVs = reserveUAVs - 1;
                                        replacementScheduled(rankingIN(i)) = 1;
                                        change(rankingIN(i)) = currentTime + tripTime + takeOffTime + lifeTime(rankingIN(i));
                                        insertEvent(currentTime+tripTime+takeOffTime, evReplacement, rankingIN(i));
                                        insertEvent(currentTime+quarantineValue, evQuarantine, rankingIN(i));
                                        quarantine(rankingIN(i)) = 1;
                                        time = (remainingBattery(rankingIN(i)) - (batteryThresholds(rankingIN(i))/2))*consumption(rankingIN(i));
                                        insertEvent(currentTime+batteryReplacementTime+time+tripTime+landingTime, evReserveUp, rankingIN(i));
                                    end
                                    if remainingBattery(rankingIN(i)) < ((batteryThresholds(rankingIN(i))/2)+1)
                                       reserveUAVs = reserveUAVs - 1;
                                       replacementScheduled(rankingIN(i)) = 1;
                                       change(rankingIN(i)) = currentTime + tripTime + takeOffTime + lifeTime(rankingIN(i));
                                       insertEvent(currentTime+tripTime+takeOffTime, evReplacement, rankingIN(i));
                                       insertEvent(currentTime+quarantineValue, evQuarantine, rankingIN(i));
                                       quarantine(rankingIN(i)) = 1;
                                    end
                                end
                            end
                        end
                    end
                end
                
                for i=1:length(remainingBattery)
                    if replacementScheduled(i) == 0 && upDown(i) == 1
                        if remainingBattery(i) < ((batteryThresholds(i)/2)+1)
                                distance = sqrt((GCSpositions(1,1)-UAVpositions(i,1))^2 + (GCSpositions(1,2)-UAVpositions(i,2))^2);
                                tripTime = (distance/uavSpeed);
                                insertEvent(currentTime+batteryReplacementTime+tripTime+landingTime, evReserveUp, i);
                        end
                    end
                end
         
                for i=1:length(remainingBattery)
                    
                     if remainingBattery(i) <= ((batteryThresholds(i)/2)+1)
                         remainingBattery(i) = 0;
                         upDown(i) = 0;
                     end
                end

                if sum(upDown) < numberOfUAVs
                    adjacencyMatrix = generateMatrix(maximumDistance, UAVpositions, GCSpositions,numberOfUAVs,remainingBattery);
                    G = graph(adjacencyMatrix);
                    for i=1:numberOfUAVs
                        P = shortestpath(G,1,i+1);
                        if isempty(P)
                            valorUsersAP = valorUsersAP + usersAP(i);
                        end
                    end
                end
                
            case evReserveUp
                reserveUAVs = reserveUAVs + 1;
                if debug == 1
                    fprintf( 'UAVs in reserve %g \n', reserveUAVs);
                end

            case evReplacement
                numberOfReplacements = numberOfReplacements + 1;
                uav = queue(currentEvent,eventNodeInvolved);
                replacementScheduled(uav) = 0;
                distance = sqrt((GCSpositions(1,1)-UAVpositions(uav,1))^2 + (GCSpositions(1,2)-UAVpositions(uav,2))^2);
                tripTime = (distance/uavSpeed);
                spend = (tripTime+takeOffTime)*consumption(uav);   
                remainingBattery(uav) = batteryCapacity-spend;
                upDown(uav) = 1;
                if debug == 1
                    fprintf('UAV #%g has been replaced at second %g\n', uav, currentTime);
                end
                
            case evQuarantine
                uav = queue(currentEvent,eventNodeInvolved);
                quarantine(uav) = 0;

            otherwise
                fprintf( 'Unkown event -> #%d ??\n' , queue(currentEvent,eventType));

        end
        queue(currentEvent, eventIsFree) = 1;
        currentEvent = queue(currentEvent, eventNext);
        currentTime = queue(currentEvent, 1);
        waitbar(currentTime/simulationTime)
    end
    
    replacements = numberOfReplacements;
    percentageUsersAP  = 1 - (valorUsersAP/((simulationTime/samplingTime)*numberOfUsers));
end
