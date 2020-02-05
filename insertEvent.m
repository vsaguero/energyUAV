function [] = insertEvent(insEvent_time, insEvent_type, insEvent_Node)
    %fprintf('Introducimos un evento en el convento \n')
    %Check if the queue has an empty slot
    global queue eventTime eventIsFree eventNext;
    if find(queue(:,eventIsFree)==1, 1,'first') == 0 
        fprintf('Error:no free slot\n');
        return;
    end
    
    % To find the first free slot
    index = find(queue(:,eventIsFree)== 1, 1, 'first');
    % iEarlierN is an array with all the lines with event time less than
    % current event time
    iEarlierN = find(queue(:,eventTime)<=insEvent_time);
    currentmaxTime = 0;
    iEarlier = 1;
    
    % Loop to look for the previous value
    for i = 1:length(iEarlierN)
        if queue(iEarlierN(i), eventTime) >= currentmaxTime
            currentmaxTime = queue(iEarlierN(i), eventTime);
            iEarlier = iEarlierN(i);
        end
    end
    
    % Is there more than one line with the same previous value?
    iMaxN = find(queue(:,eventTime)==currentmaxTime);  
    if length(iMaxN)>1
        A = [];
        for i = 1:length(iMaxN)
            A = [A,queue(iMaxN(i),eventNext)];
        end
        for i = 1:length(A)
            if ismember(A(i),iMaxN)
            else
                auxiliar = find(queue(:,eventNext)==A(i));
                %fprintf('Auxiliar size is #%g \n',length(auxiliar));
                for j = 1:length(auxiliar)
                    if(queue(auxiliar(j),eventIsFree)==0)
                        iEarlier = find(queue(:,eventNext)==A(i));
                        for k = 1:length(iEarlier)
                            if(queue(auxiliar(k),eventIsFree)==0)
                                iEarlier = iEarlier(k);
                            end
                        end
                        
                    end
                end            
            end
        end
    end
    
    queue(index, 1) = insEvent_time;
    queue(index, 2) = insEvent_type;
    queue(index, 3) = queue(iEarlier, 3);
    queue(index, 4) = 0; %The slot is not free
    queue(index, 5) = insEvent_Node;
    queue(iEarlier, 3) = index;

end