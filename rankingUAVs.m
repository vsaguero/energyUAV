function [ranking, auxiliar] = rankingUAVs (numberOfUAVs,adjacencyMatrix, usersAP)

    auxiliar = usersAP;
    G = graph(adjacencyMatrix);
    plot(G)
    for i=1:numberOfUAVs
        P = shortestpath(G,1,i+1);
        for j=1:length(P)
            if j~=1 && j<length(P)
                auxiliar(P(j)-1) = auxiliar(P(j)-1) + usersAP(P(length(P))-1);
            end
        end
    end
    [B ranking] = sort(auxiliar,'descend');
end