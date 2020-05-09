function [percentageUsersAP, percentageUsersBS, replacements] = replacementHeuristic2 (time, uavs, reserve, uavLocations, users, userLocation, gcs)
    
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

    %
    % STATISTICS
    %
    numberOfReplacements = 0;
    valorUsersAP = 0;
    valorUsersBS = 0;
    
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
    currentEvent = 1;
    
    % Plot debug information (1=yes, 0=no)
    debug = 0;
    
    % Area battery array
    remainingBattery  = batteryCapacity*ones(1,numberOfUAVs);
    % Area replacement state array
    replacementScheduled = zeros(numberOfUAVs,1);
    % Area covering or not
    upDown = ones(1,numberOfUAVs);
    %How many UAVs are in the fleet (areas + reserveUAVs)
    reserveUAVs = numberOfReserveUAVs;
    
    
    adjacencyMatrix = generateMatrix(maximumDistance, UAVpositions, GCSpositions,numberOfUAVs,upDown);
    [rankingIN] = rankingUAVs(numberOfUAVs,adjacencyMatrix, usersAP);
    ranking = flip(rankingIN);
    % First UAV in the ranking (the most important UAV in the network)
    currentIndex = 1;
    %Consumption depending on the area
    consumption = ones(1, numberOfUAVs).*0.083;
  
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
    
    tripTime = [];
    for i=1:numberOfUAVs 
        distance = sqrt((GCSpositions(1,1)-UAVpositions(i,1))^2 + (GCSpositions(1,2)-UAVpositions(i,2))^2);
        tripTime(i) = (distance/uavSpeed);
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
               
                while reserveUAVs > 0 && sum(replacementScheduled) < numberOfUAVs
                    if replacementScheduled(ranking(currentIndex)) == 0
                        totalTime = 2*tripTime(ranking(currentIndex)) + takeOffTime + landingTime + batteryReplacementTime;
                        % Check if the UAVs are in the warning area 
                        warning = [];
                        warning = find(change < totalTime+currentTime);

                        if isempty(warning)
                            if remainingBattery(ranking(currentIndex)) >= batteryThresholds(ranking(currentIndex))
                                reserveUAVs = reserveUAVs - 1;
                                replacementScheduled(ranking(currentIndex)) = 1;
                                % When the UAV enters in the warning area
                                change(ranking(currentIndex)) = currentTime + tripTime(ranking(currentIndex)) + takeOffTime + lifeTime(ranking(currentIndex));
                                insertEvent(currentTime+tripTime(ranking(currentIndex))+takeOffTime, evReplacement, ranking(currentIndex));
                                insertEvent(currentTime+batteryReplacementTime+2*(tripTime(ranking(currentIndex))+landingTime), evReserveUp, ranking(currentIndex));
                            end
                            if remainingBattery(ranking(currentIndex))< batteryThresholds(ranking(currentIndex)) && remainingBattery(ranking(currentIndex)) >= ((batteryThresholds(ranking(currentIndex))/2)+1)
                                reserveUAVs = reserveUAVs - 1;
                                replacementScheduled(ranking(currentIndex)) = 1;
                                % When the UAV enters in the warning area
                                change(ranking(currentIndex)) = currentTime + tripTime(ranking(currentIndex)) + takeOffTime + lifeTime(ranking(currentIndex));
                                insertEvent(currentTime+tripTime(ranking(currentIndex))+takeOffTime, evReplacement, ranking(currentIndex));
                                time = (remainingBattery(ranking(currentIndex)) - (batteryThresholds(ranking(currentIndex))/2))*consumption(ranking(currentIndex));
                                insertEvent(currentTime+batteryReplacementTime+time+tripTime(ranking(currentIndex))+landingTime, evReserveUp, ranking(currentIndex));
                            end
                            if remainingBattery(ranking(currentIndex)) < ((batteryThresholds(ranking(currentIndex))/2)+1)
                               reserveUAVs = reserveUAVs - 1;
                               replacementScheduled(ranking(currentIndex)) = 1;
                               % When the UAV enters in the warning area
                               change(ranking(currentIndex)) = currentTime + tripTime(ranking(currentIndex)) + takeOffTime + lifeTime(ranking(currentIndex));
                               insertEvent(currentTime+tripTime(ranking(currentIndex))+takeOffTime, evReplacement, ranking(currentIndex));
                            end
                        else
                            warningRanking = [];
                            for i=1:length(warning)
                                if replacementScheduled(warning(i)) == 0
                                    warningRanking = [warningRanking, find(ranking==warning(i))];
                                end
                            end
                            if length(find(warningRanking<currentIndex)) < reserveUAVs
                                if remainingBattery(ranking(currentIndex)) >= batteryThresholds(ranking(currentIndex))
                                    reserveUAVs = reserveUAVs - 1;
                                    replacementScheduled(ranking(currentIndex)) = 1;
                                    change(ranking(currentIndex)) = currentTime + tripTime(ranking(currentIndex)) + takeOffTime + lifeTime(ranking(currentIndex));
                                    insertEvent(currentTime+tripTime(ranking(currentIndex))+takeOffTime, evReplacement, ranking(currentIndex));
                                    insertEvent(currentTime+batteryReplacementTime+2*(tripTime(ranking(currentIndex))+landingTime), evReserveUp, ranking(currentIndex));
                                end
                                if remainingBattery(ranking(currentIndex))< batteryThresholds(ranking(currentIndex)) && remainingBattery(ranking(currentIndex)) >= ((batteryThresholds(ranking(currentIndex))/2)+1)
                                    reserveUAVs = reserveUAVs - 1;
                                    replacementScheduled(ranking(currentIndex)) = 1;
                                    change(ranking(currentIndex)) = currentTime + tripTime(ranking(currentIndex)) + takeOffTime + lifeTime(ranking(currentIndex));
                                    insertEvent(currentTime+tripTime(ranking(currentIndex))+takeOffTime, evReplacement, ranking(currentIndex));
                                    time = (remainingBattery(ranking(currentIndex)) - (batteryThresholds(ranking(currentIndex))/2))*consumption(ranking(currentIndex));
                                    insertEvent(currentTime+batteryReplacementTime+time+tripTime(ranking(currentIndex))+landingTime, evReserveUp, ranking(currentIndex));
                                end
                                if remainingBattery(ranking(currentIndex)) < ((batteryThresholds(ranking(currentIndex))/2)+1)
                                   reserveUAVs = reserveUAVs - 1;
                                   replacementScheduled(ranking(currentIndex)) = 1;
                                   change(ranking(currentIndex)) = currentTime + tripTime(ranking(currentIndex)) + takeOffTime + lifeTime(ranking(currentIndex));
                                   insertEvent(currentTime+tripTime(ranking(currentIndex))+takeOffTime, evReplacement, ranking(currentIndex));
                                end
                            else
                                currentIndex = min(warningRanking)-1;
                            end
                        end
                    end
                    currentIndex = currentIndex + 1;
                    if currentIndex > numberOfUAVs
                        currentIndex = 1;
                    end
                end
               
                for i=1:length(remainingBattery)
                    if replacementScheduled(i) == 0 && upDown(i) == 1
                        if remainingBattery(i) < ((batteryThresholds(i)/2)+1)
                            insertEvent(currentTime+batteryReplacementTime+tripTime(i)+landingTime, evReserveUp, i);
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
                    adjacencyMatrix = generateMatrix(maximumDistance, UAVpositions, GCSpositions,numberOfUAVs,upDown);
                    G = graph(adjacencyMatrix);
                    for i=1:numberOfUAVs
                        P = shortestpath(G,1,i+1);
                        if isempty(P)
                            valorUsersAP = valorUsersAP + usersAP(i);
                        end
                    end
                end
                if sum(upDown) < numberOfUAVs
                    for i=1:numberOfUAVs
                        if upDown(i) == 0
                            valorUsersBS = valorUsersBS + usersAP(i);
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
                spend = (tripTime(uav)+takeOffTime)*consumption(uav);   
                remainingBattery(uav) = batteryCapacity-spend;
                upDown(uav) = 1;
                if debug == 1
                    fprintf('UAV #%g has been replaced at second %g\n', uav, currentTime);
                end
                
            otherwise
                fprintf( 'Unkown event -> #%d ??\n' , queue(currentEvent,eventType));

        end
        queue(currentEvent, eventIsFree) = 1;
        currentEvent = queue(currentEvent, eventNext);
        currentTime = queue(currentEvent, 1);
        %waitbar(currentTime/simulationTime)
    end
    
    replacements = numberOfReplacements;
    percentageUsersAP  = 1 - (valorUsersAP/((simulationTime/samplingTime)*numberOfUsers));
    percentageUsersBS  = 1 - (valorUsersBS/((simulationTime/samplingTime)*numberOfUsers));
end
