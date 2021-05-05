%the sensitivity of a2
clear all
clc

%% configuration
dh=300;
dw=20;
dc=20;
v0=80;
v1=80;
v2=30;
v3=40; 
t1=0.5;
t3=2;
t2=2*t3;
c2=500;
c1=2*c2;
ct_fix= 75;
ct_km= 2.5;
pe_max=2000;
t_max=10;

%% calculation
syms u v
exp=4; % expectation of the RUL of the faulty component with decision wn

for q=1:45
    a2=1+q*0.2;
    b2= exp/a2;
    eqns = [u*v^2 == a2*b2^2, u * v == 2*exp*v0/v2];
    S = solve(eqns,[u v]);
    a1= double(S.u(find(double (S.v)>0)));
    b1= double(S.v(find(double (S.v)>0)));
    [uc1, mc1, uc2, mc2, uc3, mc3] = func(a1,b1,a2,b2,dh,dw,dc,v0,v1,v2,v3, t1,t3,t2,c1,c2,ct_fix,ct_km,pe_max, t_max); %remember to see if it is 'c_min' in 'funtion_for_sa'
    cm1= uc1 + mc1;
    cm2= uc2 + mc2;
    cm3= uc3 + mc3;
    c_min=min([cm1;cm2;cm3]);
    alpha_tc_min(q,:)= c_min;
    alpha_me(q)=mean(alpha_tc_min(q,:));
end

da=[0:1:dh];

for q=1:45
    a2(q)=1+q*0.2;
    %a2(q)=a2(q)';
    var2(q)= 16/a2(q);
end 


%% plotting 
figure (1)

axes1 = axes;
hold(axes1,'on');

% Create multiple lines using matrix input to plot
plot1 = plot(da, alpha_tc_min,'LineWidth',1,...
    'Color',[0 0.447058826684952 0.74117648601532]);
set(plot1(1),'LineWidth',3,'Color',[0 0 0]);
set(plot1(45),'LineWidth',3,'Color',[1 0 0]);

% Create ylabel
ylabel('       minimal economic risk (EUR)');

% Create xlabel
xlabel('distance from the alarm location to the highway entrance(km) ');

% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[500 3000]);
box(axes1,'on');
% Set the remaining axes properties
set(axes1,'FontSize',40,'LineWidth',2,'XGrid','on','YGrid','on');
% Create textarrow
annotation(figure (1),'textarrow',[0.694712905059693 0.701534963047186],...
    [0.777292576419214 0.692139737991266],'String',{'\alpha_2=1.2'},...
    'LineWidth',3,...
    'FontSize',45);

% Create textarrow
annotation(figure (1),'textarrow',[0.676520750426379 0.656623081296191],...
    [0.441048034934498 0.5382096069869],'String',{'\alpha_2=10'},'LineWidth',3,...
    'FontSize',45);



figure (2)

axes1 = axes('Position',...
    [0.160729166666667 0.186055307879371 0.775000000000001 0.738944692120629]);
hold(axes1,'on');

% Create plot
plot(var2,alpha_me,'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0],...
    'MarkerSize',10,...
    'Marker','o',...
    'LineWidth',4);

% Create ylabel
ylabel({'expected minimal ','economic risk (EUR)'});

% Create xlabel
xlabel('variance of f_{wn}(t) (Var_{wn})');

% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[0 14]);
box(axes1,'on');
% Set the remaining axes properties
set(axes1,'FontSize',40,'LineWidth',3,'XGrid','on','YGrid','on');

