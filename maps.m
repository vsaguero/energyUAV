%% Scenario I

load('plot_data/scenarioI_HE_AP')
load('plot_data/scenarioI_HE_BS')
load('plot_data/scenarioI_Legacy')
load('plot_data/scenarioI_BL')
load('plot_data/scenarioI_OP')
optimalBS = [0.755648 0.93331 1 1 1 1 1];

solutions = [optimalUsers./100',heuristicUsers./100,RP(:,1),LG(:,1)];
h = []; 
for i=1:4
    auxiliar = [];
    for j= 1:4
        auxiliar = (solutions(:,i) - solutions(:,j))./solutions(:,j);
        h(i,j) = sum(auxiliar)./length(optimalUsers);
    end
end
figure
h = (h).*100;
mapa = heatmap(h);
mapa.Colormap = summer;
mapa.XData =  ["Optimal" "Heuristic" "Legacy" "Baseline"];
mapa.YData =  ["Optimal" "Heuristic" "Legacy" "Baseline"];
set(gcf, 'Position',  [100, 100, 300, 180])

solutions = [optimalBS',HE_BS_I,RP(:,2),LG(:,2)];
h = []; 
for i=1:4
    auxiliar = [];
    for j= 1:4
        auxiliar = (solutions(:,i) - solutions(:,j))./solutions(:,j);
        h(i,j) = sum(auxiliar)./length(optimalBS');
    end
end

figure
h = (h).*100;
mapa = heatmap(h);
mapa.Colormap = summer;
mapa.XData =  ["Optimal" "Heuristic" "Legacy" "Baseline"];
mapa.YData =  ["Optimal" "Heuristic" "Legacy" "Baseline"];
set(gcf, 'Position',  [100, 100, 300, 180])

%% Scenario II

load('plot_data/scenarioII_HE_AP')
load('plot_data/scenarioII_Legacy_AP')
load('plot_data/scenarioII_BL_AP')

solutions = [HE(:,1),RP(:,1),LG(:,1)];
h = []; 
for i=1:3
    auxiliar = [];
    for j= 1:3
        auxiliar = (solutions(:,i) - solutions(:,j))./solutions(:,j);
        h(i,j) = sum(auxiliar)./length(HE(:,1));
    end
end
figure
h = (h).*100;
mapa = heatmap(h);
mapa.Colormap = summer;
mapa.XData =  ["Heuristic" "Legacy" "Baseline"];
mapa.YData =  ["Heuristic" "Legacy" "Baseline"];
set(gcf, 'Position',  [100, 100, 300, 180])

load('plot_data/scenarioII_HE_BS')
load('plot_data/scenarioII_Legacy_BS')
load('plot_data/scenarioII_BL_BS')

solutions = [HE(:,2),RP(:,2),LG(:,2)];
h = []; 
for i=1:3
    auxiliar = [];
    for j= 1:3
        auxiliar = (solutions(:,i) - solutions(:,j))./solutions(:,j);
        h(i,j) = sum(auxiliar)./length(HE(:,2));
    end
end
figure
h = (h).*100;
mapa = heatmap(h);
mapa.Colormap = summer;
mapa.XData =  ["Heuristic" "Legacy" "Baseline"];
mapa.YData =  ["Heuristic" "Legacy" "Baseline"];
set(gcf, 'Position',  [100, 100, 300, 180])

%% Scenario III

load('plot_data/scenarioIII_HE_AP')
load('plot_data/scenarioIII_Legacy')
load('plot_data/scenarioIII_BL')

solutions = [HE(:,1),RP(:,1),LG(:,1)];
h = []; 
for i=1:3
    auxiliar = [];
    for j= 1:3
        auxiliar = (solutions(:,i) - solutions(:,j))./solutions(:,j);
        h(i,j) = sum(auxiliar)./length(HE(:,1));
    end
end
figure
h = (h).*100;
mapa = heatmap(h);
mapa.Colormap = summer;
mapa.XData =  ["Heuristic" "Legacy" "Baseline"];
mapa.YData =  ["Heuristic" "Legacy" "Baseline"];
set(gcf, 'Position',  [100, 100, 300, 180])

load('plot_data/scenarioIII_HE_BS')
load('plot_data/scenarioIII_Legacy_BS')
load('plot_data/scenarioIII_BL_BS')

solutions = [HE(:,2),RP(:,2),LG(:,2)];
h = []; 
for i=1:3
    auxiliar = [];
    for j= 1:3
        auxiliar = (solutions(:,i) - solutions(:,j))./solutions(:,j);
        h(i,j) = sum(auxiliar)./length(HE(:,2));
    end
end
figure
h = (h).*100;
mapa = heatmap(h);
mapa.Colormap = summer;
mapa.XData =  ["Heuristic" "Legacy" "Baseline"];
mapa.YData =  ["Heuristic" "Legacy" "Baseline"];
set(gcf, 'Position',  [100, 100, 300, 180])

%% Scenario IV

load('plot_data/scenarioV_HE_AP')
load('plot_data/scenarioV_Legacy')
load('plot_data/scenarioV_BL')

solutions = [HE(:,1),RP(:,1),LG(:,1)];
h = []; 
for i=1:3
    auxiliar = [];
    for j= 1:3
        auxiliar = (solutions(:,i) - solutions(:,j))./solutions(:,j);
        h(i,j) = sum(auxiliar)./length(HE(:,1));
    end
end
figure
h = (h).*100;
mapa = heatmap(h);
mapa.Colormap = summer;
mapa.XData =  ["Heuristic" "Legacy" "Baseline"];
mapa.YData =  ["Heuristic" "Legacy" "Baseline"];
set(gcf, 'Position',  [100, 100, 300, 180])

load('plot_data/scenarioV_HE_BS')
load('plot_data/scenarioV_Legacy')
load('plot_data/scenarioV_BL')

solutions = [HE(:,2),RP(:,2),LG(:,2)];
h = []; 
for i=1:3
    auxiliar = [];
    for j= 1:3
        auxiliar = (solutions(:,i) - solutions(:,j))./solutions(:,j);
        h(i,j) = sum(auxiliar)./length(HE(:,2));
    end
end
figure
h = (h).*100;
mapa = heatmap(h);
mapa.Colormap = summer;
mapa.XData =  ["Heuristic" "Legacy" "Baseline"];
mapa.YData =  ["Heuristic" "Legacy" "Baseline"];
set(gcf, 'Position',  [100, 100, 300, 180])
