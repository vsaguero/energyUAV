%% Scenario I

load('plot_data/scenarioI_HE_AP')
load('plot_data/scenarioI_HE_BS')
load('plot_data/scenarioI_Legacy')
load('plot_data/scenarioI_BL')
load('plot_data/scenarioI_OP')
loyolagreen = 1/255*[0,104,87];

figure
B = [6 7 8 9 10 11 12];
plot(B,optimalUsers./100,'k:','LineWidth',2)
hold on
plot(B,heuristicUsers./100,'b-','LineWidth',1.5)
plot(B,RP(:,1),'--','Color', loyolagreen,'LineWidth',1.5)
plot(B,LG(:,1),'r-.','LineWidth',1.5)
grid on
box on
xlabel('Number of UAVs')
ylabel('Throughput')
set(gcf, 'Position',  [100, 100, 350, 200])
legend('Optimal','BETA','Simple', 'Baseline')
legend('Location','best')

figure
B = [6 7 8 9 10 11 12];
optimalBS = [0.755648 0.93331 1 1 1 1 1]
plot(B,optimalBS,'k:','LineWidth',2)
hold on
plot(B,HE_BS_I,'b-','LineWidth',1.5)
plot(B,RP(:,2),'--','Color', loyolagreen,'LineWidth',1.5)
plot(B,LG(:,2),'r-.','LineWidth',1.5)
grid on
%box on
xlabel('Number of UAVs')
ylabel('Connected users (%)')
set(gcf, 'Position',  [100, 100, 350, 200])
%legend('Heuristic','Legacy', 'Baseline')
legend('Optimal','BETA','Simple', 'Baseline')
legend('Location','best')

%% Scenario II
loyolagreen = 1/255*[0,104,87];
load('plot_data/scenarioII_HE_AP')
load('plot_data/scenarioII_Legacy_AP')
load('plot_data/scenarioII_BL_AP')

figure
B = [25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50];
hold on
plot(B,HE(:,1),'b-','LineWidth',1.5)
plot(B,RP(:,1),'--','Color', loyolagreen,'LineWidth',1.5)
plot(B,LG(:,1),'r-.','LineWidth',1.5)
grid on
box on
xlabel('Number of UAVs')
ylabel('Connected users (%)')
set(gcf, 'Position',  [100, 100, 350, 200])
legend('Legacy', 'Baseline')
legend('BETA','Simple', 'Baseline')
%legend('Location','best')

load('plot_data/scenarioII_HE_BS')
figure
B = [25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50];
hold on
plot(B,HE(:,2),'b-','LineWidth',1.5)
plot(B,RP(:,2),'--','Color', loyolagreen,'LineWidth',1.5)
plot(B,LG(:,2),'r-.','LineWidth',1.5)
grid on
box on
xlabel('Number of UAVs')
ylabel('Connected users (%)')
set(gcf, 'Position',  [100, 100, 350, 200])
legend('BETA','Simple', 'Baseline')
legend('Location','best')


%% Scenario III
loyolagreen = 1/255*[0,104,87];
load('plot_data/scenarioIII_HE_AP')
load('plot_data/scenarioIII_Legacy')
load('plot_data/scenarioIII_BL')

figure
B = [25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50];
hold on
plot(B,HE(:,1),'b-','LineWidth',1.5)
plot(B,RP(:,1),'--','Color', loyolagreen,'LineWidth',1.5)
plot(B,LG(:,1),'r-.','LineWidth',1.5)
grid on
box on
xlabel('Number of UAVs')
ylabel('Connected users (%)')
set(gcf, 'Position',  [100, 100, 350, 200])
legend('BETA','Simple', 'Baseline')
%legend('Heuristic','Legacy', 'Baseline')
legend('Location','best')

load('plot_data/scenarioIII_HE_BS')
load('plot_data/scenarioIII_Legacy_BS')
load('plot_data/scenarioIII_BL_BS')

figure
B = [25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50];
hold on
plot(B,HE(:,2),'b-','LineWidth',1.5)
plot(B,RP(:,2),'--','Color', loyolagreen,'LineWidth',1.5)
plot(B,LG(:,2),'r-.','LineWidth',1.5)
grid on
box on
xlabel('Number of UAVs')
ylabel('Connected users (%)')
set(gcf, 'Position',  [100, 100, 350, 200])
legend('BETA','Simple', 'Baseline')
legend('Location','best')

%% Scenario V
loyolagreen = 1/255*[0,104,87];
load('plot_data/scenarioV_HE_AP')
load('plot_data/scenarioV_Legacy')
load('plot_data/scenarioV_BL')

figure
B = [50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100];
hold on
plot(B,HE(:,1),'b-','LineWidth',1.5)
plot(B,RP(:,1),'--','Color', loyolagreen,'LineWidth',1.5)
plot(B,LG(:,1),'r-.','LineWidth',1.5)
grid on
box on
xlabel('Number of UAVs')
ylabel('Connected users (%)')
set(gcf, 'Position',  [100, 100, 350, 200])
legend('BETA','Simple', 'Baseline')
legend('Location','best')

load('plot_data/scenarioV_HE_BS')
load('plot_data/scenarioV_Legacy')
load('plot_data/scenarioV_BL')

figure
B = [50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100];
hold on
plot(B,HE(:,2),'b-','LineWidth',1.5)
plot(B,RP(:,2),'--','Color', loyolagreen,'LineWidth',1.5)
plot(B,LG(:,2),'r-.','LineWidth',1.5)
grid on
box on
xlabel('Number of UAVs')
ylabel('Connected users (%)')
set(gcf, 'Position',  [100, 100, 350, 200])
legend('BETA','Simple', 'Baseline')
legend('Location','best')

