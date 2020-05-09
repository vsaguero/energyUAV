h = [0.99;0.98;0.85]
h=h';
figure
mapa = heatmap(h);
mapa.Colormap = summer;
mapa.XData =  ["BETA" "Simple" "Baseline"];
mapa.YData = ["6-12"]
ylabel('Fleet size')
%xlabel('Fleet size')
set(gcf, 'Position',  [100, 100, 350, 80])

h = [0.99;0.99;0.92]
h=h';
figure
mapa = heatmap(h);
mapa.Colormap = summer;
mapa.XData =  ["BETA" "Simple" "Baseline"];
mapa.YData = ["6-12"]
ylabel('Fleet size')
%xlabel('Fleet size')
set(gcf, 'Position',  [100, 100, 350, 80])

%% Scenario II

load('plot_data/scenarioII_HE_AP')
load('plot_data/scenarioII_Legacy_AP')
load('plot_data/scenarioII_BL_AP')

h20 = []; 
solutions_0_20 = [];
for i=1:6
   auxiliar =  [HE(i,1),RP(i,1),LG(i,1)];
   solutions_0_20 = [solutions_0_20; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_20(:,i)./solutions_0_20(:,1)
    h20(1,i-1) = sum(auxiliar)./6;
end
h20


h40 = []; 
solutions_0_40 = [];
for i=7:11
   auxiliar =  [HE(i,1),RP(i,1),LG(i,1)];
   solutions_0_40 = [solutions_0_40; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_40(:,i)./solutions_0_40(:,1);
    h40(1,i-1) = sum(auxiliar)./5;
end

h60 = [];
solutions_0_60 = [];
for i=12:16
   auxiliar =  [HE(i,1),RP(i,1),LG(i,1)];
   solutions_0_60 = [solutions_0_60; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_60(:,i)./solutions_0_60(:,1);
    h60(1,i-1) = sum(auxiliar)./5;
end

h80 = [];
solutions_0_80 = [];
for i=17:21
   auxiliar =  [HE(i,1),RP(i,1),LG(i,1)];
   solutions_0_80 = [solutions_0_80; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_80(:,i)./solutions_0_80(:,1);
    h80(1,i-1) = sum(auxiliar)./5;
end

h100 = [];
solutions_0_100 = [];
for i=22:26
   auxiliar =  [HE(i,1),RP(i,1),LG(i,1)];
   solutions_0_100 = [solutions_0_100; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_100(:,i)./solutions_0_100(:,1);
    h100(1,i-1) = sum(auxiliar)./5;
end

hT = [];
solutions_0_100 = [];
for i=1:26
   auxiliar =  [HE(i,1),RP(i,1),LG(i,1)];
   solutions_0_100 = [solutions_0_100; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_100(:,i)./solutions_0_100(:,1);
    hT(1,i-1) = sum(auxiliar)./26;
end

h = [h20;h40;h60;h80;h100; hT];
h = fix(h*100);
h = h/100;
figure
h = h';
mapa = heatmap(h);
mapa.Colormap = summer;
mapa.YData =  ["Simple" "Baseline"];
mapa.XData =  ["25-30" "31-35" "36-40" "41-45" "45-50" "25-50"];
%ylabel('Strategies')
xlabel('Fleet size')
set(gcf, 'Position',  [100, 100, 350, 120])

load('plot_data/scenarioII_HE_BS')
load('plot_data/scenarioII_Legacy_BS')
load('plot_data/scenarioII_BL_BS')

h20 = []; 
solutions_0_20 = [];
for i=1:6
   auxiliar =  [HE(i,2),RP(i,2),LG(i,2)];
   solutions_0_20 = [solutions_0_20; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_20(:,i)./solutions_0_20(:,1);
    h20(1,i-1) = sum(auxiliar)./6;
end

h40 = []; 
solutions_0_40 = [];
for i=7:11
   auxiliar =  [HE(i,2),RP(i,2),LG(i,2)];
   solutions_0_40 = [solutions_0_40; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_40(:,i)./solutions_0_40(:,1);
    h40(1,i-1) = sum(auxiliar)./5;
end

h60 = [];
solutions_0_60 = [];
for i=12:16
   auxiliar =  [HE(i,2),RP(i,2),LG(i,2)];
   solutions_0_60 = [solutions_0_60; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_60(:,i)./solutions_0_60(:,1);
    h60(1,i-1) = sum(auxiliar)./5;
end

h80 = [];
solutions_0_80 = [];
for i=17:21
   auxiliar =  [HE(i,2),RP(i,2),LG(i,2)];
   solutions_0_80 = [solutions_0_80; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_80(:,i)./solutions_0_80(:,1);
    h80(1,i-1) = sum(auxiliar)./5;
end

h100 = [];
solutions_0_100 = [];
for i=22:26
   auxiliar =  [HE(i,2),RP(i,2),LG(i,2)];
   solutions_0_100 = [solutions_0_100; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_100(:,i)./solutions_0_100(:,1);
    h100(1,i-1) = sum(auxiliar)./5;
end

hT = [];
solutions_0_100 = [];
for i=1:26
   auxiliar =  [HE(i,2),RP(i,2),LG(i,2)];
   solutions_0_100 = [solutions_0_100; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_100(:,i)./solutions_0_100(:,1);
    hT(1,i-1) = sum(auxiliar)./26;
end

h = [h20;h40;h60;h80;h100;hT];
h = fix(h*100);
h = h/100;
figure
h = h';
mapa = heatmap(h);
mapa.Colormap = summer;
mapa.YData =  ["Simple" "Baseline"];
mapa.XData =  ["25-30" "31-35" "36-40" "41-45" "45-50" "25-50"];
xlabel('Fleet size')
set(gcf, 'Position',  [100, 100, 350, 120])

%% Scenario III

load('plot_data/scenarioIII_HE_AP')
load('plot_data/scenarioIII_Legacy')
load('plot_data/scenarioIII_BL')

h20 = []; 
solutions_0_20 = [];
for i=1:6
   auxiliar =  [HE(i,1),RP(i,1),LG(i,1)];
   solutions_0_20 = [solutions_0_20; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_20(:,i)./solutions_0_20(:,1);
    h20(1,i-1) = sum(auxiliar)./6;
end

h40 = []; 
solutions_0_40 = [];
for i=7:11
   auxiliar =  [HE(i,1),RP(i,1),LG(i,1)];
   solutions_0_40 = [solutions_0_40; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_40(:,i)./solutions_0_40(:,1);
    h40(1,i-1) = sum(auxiliar)./5;
end

h60 = [];
solutions_0_60 = [];
for i=12:16
   auxiliar =  [HE(i,1),RP(i,1),LG(i,1)];
   solutions_0_60 = [solutions_0_60; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_60(:,i)./solutions_0_60(:,1);
    h60(1,i-1) = sum(auxiliar)./5;
end

h80 = [];
solutions_0_80 = [];
for i=17:21
   auxiliar =  [HE(i,1),RP(i,1),LG(i,1)];
   solutions_0_80 = [solutions_0_80; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_80(:,i)./solutions_0_80(:,1)
    h80(1,i-1) = sum(auxiliar)./5;
end

h100 = [];
solutions_0_100 = [];
for i=22:26
   auxiliar =  [HE(i,1),RP(i,1),LG(i,1)];
   solutions_0_100 = [solutions_0_100; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_100(:,i)./solutions_0_100(:,1);
    h100(1,i-1) = sum(auxiliar)./5;
end

hT = [];
solutions_0_100 = [];
for i=1:26
   auxiliar =  [HE(i,1),RP(i,1),LG(i,1)];
   solutions_0_100 = [solutions_0_100; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_100(:,i)./solutions_0_100(:,1)
    hT(1,i-1) = sum(auxiliar)./26;
end

h = [h20;h40;h60;h80;h100;hT];
h = fix(h*100);
h = h/100;
figure
h=h';
mapa = heatmap(h);
mapa.Colormap = summer;
mapa.YData =  ["Simple" "Baseline"];
mapa.XData =  ["25-30" "31-35" "36-40" "41-45" "45-50" "25-50"];
set(gcf, 'Position',  [100, 100, 350, 120])
xlabel('Fleet size')
load('plot_data/scenarioIII_HE_BS')
load('plot_data/scenarioIII_Legacy_BS')
load('plot_data/scenarioIII_BL_BS')

h20 = []; 
solutions_0_20 = [];
for i=1:6
   auxiliar =  [HE(i,2),RP(i,2),LG(i,2)];
   solutions_0_20 = [solutions_0_20; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_20(:,i)./solutions_0_20(:,1)
    h20(1,i-1) = sum(auxiliar)./6;
end

h40 = []; 
solutions_0_40 = [];
for i=7:11
   auxiliar =  [HE(i,2),RP(i,2),LG(i,2)];
   solutions_0_40 = [solutions_0_40; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_40(:,i)./solutions_0_40(:,1)
    h40(1,i-1) = sum(auxiliar)./5;
end

h60 = [];
solutions_0_60 = [];
for i=12:16
   auxiliar =  [HE(i,2),RP(i,2),LG(i,2)];
   solutions_0_60 = [solutions_0_60; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_60(:,i)./solutions_0_60(:,1)
    h60(1,i-1) = sum(auxiliar)./5;
end

h80 = [];
solutions_0_80 = [];
for i=17:21
   auxiliar =  [HE(i,2),RP(i,2),LG(i,2)];
   solutions_0_80 = [solutions_0_80; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_80(:,i)./solutions_0_80(:,1)
    h80(1,i-1) = sum(auxiliar)./5;
end

h100 = [];
solutions_0_100 = [];
for i=22:26
   auxiliar =  [HE(i,2),RP(i,2),LG(i,2)];
   solutions_0_100 = [solutions_0_100; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_100(:,i)./solutions_0_100(:,1)
    h100(1,i-1) = sum(auxiliar)./5;
end

hT = [];
solutions_0_100 = [];
for i=1:26
   auxiliar =  [HE(i,2),RP(i,2),LG(i,2)];
   solutions_0_100 = [solutions_0_100; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_100(:,i)./solutions_0_100(:,1)
    hT(1,i-1) = sum(auxiliar)./26;
end


h = [h20;h40;h60;h80;h100;hT];
h = fix(h*100);
h = h/100;
h = h';
figure
mapa = heatmap(h);
mapa.Colormap = summer;
mapa.YData =  ["Simple" "Baseline"];
mapa.XData =  ["25-30" "31-35" "36-40" "41-45" "45-50" "25-50"];
xlabel('Fleet size')
set(gcf, 'Position',  [100, 100, 350, 120])

%% Scenario IV

load('plot_data/scenarioV_HE_AP')
load('plot_data/scenarioV_Legacy')
load('plot_data/scenarioV_BL')

h20 = []; 
solutions_0_20 = [];
for i=1:11
   auxiliar =  [HE(i,1),RP(i,1),LG(i,1)];
   solutions_0_20 = [solutions_0_20; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_20(:,i)./solutions_0_20(:,1);
    h20(1,i-1) = sum(auxiliar)./11;
end

h40 = []; 
solutions_0_40 = [];
for i=12:21
   auxiliar =  [HE(i,1),RP(i,1),LG(i,1)];
   solutions_0_40 = [solutions_0_40; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_40(:,i)./solutions_0_40(:,1);
    h40(1,i-1) = sum(auxiliar)./10;
end

h60 = [];
solutions_0_60 = [];
for i=22:31
   auxiliar =  [HE(i,1),RP(i,1),LG(i,1)];
   solutions_0_60 = [solutions_0_60; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_60(:,i)./solutions_0_60(:,1);
    h60(1,i-1) = sum(auxiliar)./10;
end

h80 = [];
solutions_0_80 = [];
for i=32:41
   auxiliar =  [HE(i,1),RP(i,1),LG(i,1)];
   solutions_0_80 = [solutions_0_80; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_80(:,i)./solutions_0_80(:,1);
    h80(1,i-1) = sum(auxiliar)./10;
end

h100 = [];
solutions_0_100 = [];
for i=42:51
   auxiliar =  [HE(i,1),RP(i,1),LG(i,1)];
   solutions_0_100 = [solutions_0_100; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_100(:,i)./solutions_0_100(:,1);
    h100(1,i-1) = sum(auxiliar)./10;
end

hT = [];
solutions_0_100 = [];
for i=1:51
   auxiliar =  [HE(i,1),RP(i,1),LG(i,1)];
   solutions_0_100 = [solutions_0_100; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_100(:,i)./solutions_0_100(:,1);
    hT(1,i-1) = sum(auxiliar)./51;
end


h = [h20;h40;h60;h80;h100;hT];
h = fix(h*100);
h = h/100;
h = h';
figure
mapa = heatmap(h);
mapa.Colormap = summer;
mapa.YData =  ["Simple" "Baseline"];
mapa.XData =  ["50-60" "61-70" "71-80" "81-90" "91-100" "50-100"];
xlabel('Fleet size')
set(gcf, 'Position',  [100, 100, 350, 120])

load('plot_data/scenarioV_HE_BS')
load('plot_data/scenarioV_Legacy')
load('plot_data/scenarioV_BL')

h20 = []; 
solutions_0_20 = [];
for i=1:11
   auxiliar =  [HE(i,2),RP(i,2),LG(i,2)];
   solutions_0_20 = [solutions_0_20; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_20(:,i)./solutions_0_20(:,1)
    h20(1,i-1) = sum(auxiliar)./11;
end

h40 = []; 
solutions_0_40 = [];
for i=12:21
   auxiliar =  [HE(i,2),RP(i,2),LG(i,2)];
   solutions_0_40 = [solutions_0_40; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_40(:,i)./solutions_0_40(:,1)
    h40(1,i-1) = sum(auxiliar)./10;
end

h60 = [];
solutions_0_60 = [];
for i=22:31
   auxiliar =  [HE(i,2),RP(i,2),LG(i,2)];
   solutions_0_60 = [solutions_0_60; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_60(:,i)./solutions_0_60(:,1)
    h60(1,i-1) = sum(auxiliar)./10;
end

h80 = [];
solutions_0_80 = [];
for i=32:41
   auxiliar =  [HE(i,2),RP(i,2),LG(i,2)];
   solutions_0_80 = [solutions_0_80; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_80(:,i)./solutions_0_80(:,1)
    h80(1,i-1) = sum(auxiliar)./10;
end

h100 = [];
solutions_0_100 = [];
for i=42:51
   auxiliar =  [HE(i,2),RP(i,2),LG(i,2)];
   solutions_0_100 = [solutions_0_100; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_100(:,i)./solutions_0_100(:,1)
    h100(1,i-1) = sum(auxiliar)./10;
end

hT = [];
solutions_0_100 = [];
for i=1:51
   auxiliar =  [HE(i,2),RP(i,2),LG(i,2)];
   solutions_0_100 = [solutions_0_100; auxiliar];
end

auxiliar = [];
for i= 2:3
    auxiliar = solutions_0_100(:,i)./solutions_0_100(:,1)
    hT(1,i-1) = sum(auxiliar)./51;
end

h = [h20;h40;h60;h80;h100;hT];
h = fix(h*100);
h = h/100;
h = h';
figure
mapa = heatmap(h);
mapa.Colormap = summer;
mapa.YData =  ["Simple" "Baseline"];
mapa.XData =  ["50-60" "61-70" "71-80" "81-90" "91-100" "50-100"];
xlabel('Fleet size')
set(gcf, 'Position',  [100, 100, 350, 120])


