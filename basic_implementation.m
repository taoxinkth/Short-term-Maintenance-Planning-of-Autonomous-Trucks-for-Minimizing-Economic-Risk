clear all
clc

%% configuration
a1=5;
b1=2;
a=2;
b=2;
dh=300;
dw=20;
dc=20;
v=80;
v1=80;
v2=30;
v3=40;
t1=0.5;
t3=2; 
t2=2*t3;
c1=1000;
c2=500;
ct_fix= 75; 
ct_km= 2.5; 
pe_max=2000; 
t_max=10;

%% calculation
[uc1, mc1, uc2, mc2, uc3, mc3] = func(a1,b1,a,b,dh,dw,dc,v,v1,v2,v3, t1,t3,t2,c1,c2,ct_fix,ct_km,pe_max, t_max);
cm1= uc1 + mc1;
cm2= uc2 + mc2;
cm3= uc3 + mc3;
c_min=min([cm1;cm2;cm3]);

% save the total economic risk of every decision 
% later compare this with two-workshop scenario
cm=[cm1;cm2;cm3;c_min];
save cm

% expected economic risk of baseline methods and the proposed method
eer_bm1 = mean(cm1)
eer_bm2 = mean(cm2)
eer_bm3 = mean(cm3)
eer_pm = mean(c_min)
% redution ratio Ri
R1 = (eer_bm1-eer_pm )/eer_bm1
R2 = (eer_bm2-eer_pm )/eer_bm2
R3 = (eer_bm3-eer_pm )/eer_bm3

%% plotting 
%figure 7 in the paper
figure (1)
da=[0:1:dh];
X1=da;
YMatrix1=[uc1;uc2;uc3;mc1;mc2;mc3];

axes1 = axes('Position',[0.13 0.164847161572052 0.775 0.747052404382082]);
hold(axes1,'on');

% Create multiple lines using matrix input to plot
plot1 = plot(X1,YMatrix1,'LineWidth',3);
set(plot1(1),'DisplayName','wr, al');
set(plot1(2),'DisplayName','wn, al','Color',[1 0 0]);
set(plot1(3),'DisplayName','cn, al',...
    'Color',[0.466666668653488 0.674509823322296 0.18823529779911]);
set(plot1(4),'DisplayName','wr,mc','LineStyle','--',...
    'Color',[0 0.447058826684952 0.74117648601532]);
set(plot1(5),'DisplayName','wn,mc','LineStyle','--','Color',[1 0 0]);
set(plot1(6),'DisplayName','cn,mc','LineStyle','--',...
    'Color',[0.466666668653488 0.674509823322296 0.18823529779911]);

% Create ylabel
ylabel('ecomonic risk (EUR)   ');

% Create xlabel
xlabel('distance from the alarm location to the highway entrance(km)    ');

% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[0 25000]);
box(axes1,'on');
% Set the remaining axes properties
set(axes1,'FontSize',40,'LineWidth',2,'XGrid','on','YGrid','on');
% Create legend
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.354340289248565 0.840222581767015 0.551041654994091 0.0698689936810706],...
    'NumColumns',6);


% figure 8 in the paper
figure (2)

X1=da;
YMatrix1=[cm1;cm2;cm3];
% Create axes
axes1 = axes;
hold(axes1,'on');

% Create multiple lines using matrix input to plot
plot1 = plot(X1,YMatrix1,'LineWidth',3);
set(plot1(1),'DisplayName','wr',...
    'Color',[0 0.447058826684952 0.74117648601532]);
set(plot1(2),'DisplayName','wn',...
    'Color',[0.929411768913269 0.694117665290833 0.125490203499794]);
set(plot1(3),'DisplayName','cn','Color',[0 0.498039215803146 0]);

% Create ylabel
ylabel('total economic risk (EUR)');

% Create xlabel
xlabel('distance from the alarm location to the highway entrance(km)');

box(axes1,'on');
% Set the remaining axes properties
set(axes1,'FontSize',34,'LineWidth',2,'XColor',[0 0 0],'YColor',[0 0 0],...
    'ZColor',[0 0 0]);
% Create legend
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.797366994996347 0.753056889626649 0.107899020204521 0.171451350671062]);
grid on;