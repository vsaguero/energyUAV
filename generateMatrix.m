function [adjacencyMatrix] = generateMatrix(maximumDistance, UAVpositions, GCSpositions, numberOfUAVs, remainingBattery)
    % to include the GCS 
    adjacencyMatrix = zeros(numberOfUAVs+1,numberOfUAVs+1);
    battery = [100, remainingBattery];
    % to concatenate the UAVs and the GCS in the matrix
    auxiliar = cat(1,GCSpositions,UAVpositions);
    for i=1:length(auxiliar)
        for j=i:length(auxiliar)
            if (i~=j)
                pos1 = [auxiliar(i,1), auxiliar(i,2)];
                pos2 =[auxiliar(j,1), auxiliar(j,2)];
                if(sqrt(sum((pos1 - pos2) .^ 2)) <= maximumDistance) 
                    if battery(i) > 0 && battery(j) > 0
                        adjacencyMatrix (i,j)=1;
                        adjacencyMatrix (j,i)=1;
                    end
                end
            end    
        end
    end
end