function [percentageUsersAP, percentageUsersBS,replacements] = replacementReportedParameters (time, uavs, reserve, uavLocations, users, userLocation, gcs)
    
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

    
    % Consumption depending on the area
    consumption = ones(1, numberOfUAVs).*0.083;
    
    if length(UAVpositions(:,1)) ~= length(usersAP)
        fprintf('UAVpositions and usersAP must have the same dimensions \n')
        return
    end
       
    %Battery thresholds
    batteryThresholds = zeros(1,numberOfUAVs);
    for i=1:length(UAVpositions) 
        distance = sqrt((GCSpositions(1,1)-UAVpositions(i,1))^2 + (GCSpositions(1,2)-UAVpositions(i,2))^2);
        batteryThresholds(i) = ((distance/uavSpeed)+takeOffTime)*2*consumption(i);   
    end
    
    remainingBattery = remainingBattery - (batteryThresholds/2);
    %batteryThresholds
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
                remainingBattery = remainingBattery - consumption*samplingTime;
                % check if the battery is 0
                remainingBattery(remainingBattery < 0) = 0;
                %remainingBattery
                for i=1:length(remainingBattery)
                    if replacementScheduled(i) == 0
                        if remainingBattery(i) <= (batteryThresholds(i)+5) && remainingBattery(i) >= (batteryThresholds(i)) && reserveUAVs > 0
                            %fprintf( 'Entramos en el uno \n' );
                            reserveUAVs = reserveUAVs - 1;
                            replacementScheduled(i) = 1;
                            distance = sqrt((GCSpositions(1,1)-UAVpositions(i,1))^2 + (GCSpositions(1,2)-UAVpositions(i,2))^2);
                            tripTime = (distance/uavSpeed);
                            insertEvent(currentTime+tripTime+takeOffTime, evReplacement,i);
                            insertEvent(currentTime+batteryReplacementTime+2*(tripTime+landingTime), evReserveUp, i);
                        elseif remainingBattery(i) < (batteryThresholds(i)) && remainingBattery(i) >= ((batteryThresholds(i)/2)+1) && reserveUAVs > 0
                            %fprintf( 'Entramos en el UAV %g \n',i  );
                            reserveUAVs = reserveUAVs - 1;
                            replacementScheduled(i) = 1;
                            distance = sqrt((GCSpositions(1,1)-UAVpositions(i,1))^2 + (GCSpositions(1,2)-UAVpositions(i,2))^2);
                            tripTime = (distance/uavSpeed);
                            insertEvent(currentTime+tripTime+takeOffTime, evReplacement,i);
                            % /2 no idiota???
                            lifeTime = (remainingBattery(i) - batteryThresholds(i)/2)*consumption(i);
                            insertEvent(currentTime+batteryReplacementTime+lifeTime+tripTime+landingTime, evReserveUp, i);
                        elseif remainingBattery(i) < ((batteryThresholds(i)/2)+1)
                            if upDown(i) == 1
                                %fprintf( 'Par luego entrar aqui con el UAV %g \n',i  );
                                %fprintf( 'Entramos en el tres A con UAV %g \n',i);
                                %remainingBattery(i) = 0;
                                upDown(i) = 0;
                                distance = sqrt((GCSpositions(1,1)-UAVpositions(i,1))^2 + (GCSpositions(1,2)-UAVpositions(i,2))^2);
                                tripTime = (distance/uavSpeed);
                                insertEvent(currentTime+batteryReplacementTime+tripTime+landingTime, evReserveUp, i);
                            elseif upDown(i) == 0
                                %fprintf( 'Entramos en el tres B con UAV %g \n',i);
                                if reserveUAVs > 0
                                    %fprintf( 'Entramos en el tres \n' );
                                    reserveUAVs = reserveUAVs - 1;
                                    replacementScheduled(i) = 1;
                                    distance = sqrt((GCSpositions(1,1)-UAVpositions(i,1))^2 + (GCSpositions(1,2)-UAVpositions(i,2))^2);
                                    tripTime = (distance/uavSpeed);
                                    insertEvent(currentTime+tripTime+takeOffTime, evReplacement,i)
                                end
                            end
                        end
                    end
                end
                
                %Monitor which one is up or down
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
                %Time calculation to reduce the battery
                distance = sqrt((GCSpositions(1,1)-UAVpositions(uav,1))^2 + (GCSpositions(1,2)-UAVpositions(uav,2))^2);
                tripTime = (distance/uavSpeed);
                spend = (tripTime+takeOffTime)*consumption(uav);   
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
    end
    
    replacements = numberOfReplacements;
    percentageUsersAP  = 1 - (valorUsersAP/((simulationTime/samplingTime)*numberOfUsers));
    percentageUsersBS  = 1 - (valorUsersBS/((simulationTime/samplingTime)*numberOfUsers));
end
