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


%Rul distribution 
% time discretization
x=[0:0.0001:20];
%gamma distribution, decision 1
gc1 = gamcdf(x,a1,b1);
gp1= gampdf(x,a1,b1);
%gamma distribution, decision 2 and 3
gc = gamcdf(x,a,b);
gp= gampdf(x,a,b);
% location of alarm, every 1 km on the highway
da=[0:1:dh];


%% calculation
%decision 1
for i=1:dh/2   
    % time from alarm location to workshop if the vehicle goes back immediately
    tw1(i)=(da(i)+dw)/v3; 
    tw1_(i)=round(tw1(i)/0.0001);

    %expected uptime utility 
    uc1_nf(i)=(1-gc1(tw1_(i)))* ut((tw1(i)+t3+0.5*tw1(i)),pe_max, t_max); % no fault
    uc1_f(i)=0;
    for j=1:1:tw1_(i)
        dt=0.0001;
        tt2=(da(i)+dw-v3*j*dt)/v1;% tow truck come
        tt3=(da(i)+dw-v3*j*dt)/v2;% tow truck back
        uc1_f(i) = uc1_f(i) + gp1(j)*ut((j*dt+t1+tt2+tt3+t2+0.5*tw1(i)),pe_max, t_max)*dt;
    end
    uc1(i)= uc1_nf(i) + uc1_f(i);
    
    %expected economic loss 
    mc1_nf(i)=(1-gc1(tw1_(i)))*c2 ;
    mc1_f(i)=0;
    for j=1:1:tw1_(i)
        dt=0.0001;
        mc1_f(i)= mc1_f(i) + gp1(j)*(c1+ ct_fix + 2*ct_km*(dw+da(i)-v3*j*dt))*dt;
    end
    mc1(i)=mc1_nf(i)+mc1_f(i);
    
end 

for i= (dh/2 +1):(dh+1) 
    % time from alarm location to workshop if the vehicle goes to the workshop immediately
    tw1(i)=(dh-da(i)+dw)/v3; 
    tw1_(i)=round(tw1(i)/0.0001);
    
    %expected uptime utility 
    uc1_nf(i)=(1-gc1(tw1_(i)))* ut((tw1(i)+t3+ (dw+dc)/v - (dh-da(i)+dc)/v),pe_max, t_max); % no fault
    uc1_f(i)=0;
    for j=1:1:tw1_(i)
        dt=0.0001;
        tt2=(dh-da(i)+dw-v3*j*dt)/v1;% tow truck come
        tt3=(dh-da(i)+dw-v3*j*dt)/v2;% tow truck back
        uc1_f(i) = uc1_f(i) + gp1(j)*ut((j*dt + t1+tt2+tt3 + t2+ (dw+dc)/v - (dh-da(i)+dc)/v ),pe_max, t_max)*dt;
    end
    uc1(i)= uc1_nf(i) + uc1_f(i);
    
    %expected economic loss 
    mc1_nf(i)=(1-gc1(tw1_(i)))*c2 ;
    mc1_f(i)=0;
    for j=1:1:tw1_(i)
        dt=0.0001;
        mc1_f(i)= mc1_f(i) + gp1(j)*(c1+ ct_fix + 2*ct_km*(dh-da(i)-v3*j*dt+dw))*dt;
    end
    mc1(i)=mc1_nf(i)+mc1_f(i);
end
%% 
%decision 2
for i=1:dh/2   
    % time from alarm location to workshop if the vehicle goes back immediately
    tw2(i)=(da(i)+dw)/v; 
    tw2_(i)=round(tw2(i)/0.0001);

    %expected uptime utility 
    uc2_nf(i)=(1-gc(tw2_(i)))* ut((tw2(i)+t3+tw2(i)),pe_max, t_max); % no fault
    uc2_f(i)=0;
    for j=1:1:tw2_(i)
        dt=0.0001;
        tt2=(da(i)+dw-v*j*dt)/v1;% tow truck come
        tt3=(da(i)+dw-v*j*dt)/v2;% tow truck back
        uc2_f(i) = uc2_f(i) + gp(j)*ut((j*dt+t1+tt2+tt3+t2+tw2(i)),pe_max, t_max)*dt;
    end
    uc2(i)= uc2_nf(i) + uc2_f(i);
    
    %expected economic loss 
    mc2_nf(i)=(1-gc(tw2_(i)))*c2 ;
    mc2_f(i)=0;
    for j=1:1:tw2_(i)
        dt=0.0001;
        mc2_f(i)= mc2_f(i) + gp(j)*(c1+ ct_fix + 2*ct_km*(dw+da(i)-v*j*dt))*dt;
    end
    mc2(i)=mc2_nf(i)+mc2_f(i);
    
end 

for i= (dh/2 +1):(dh+1) 
    % time from alarm location to workshop if the vehicle goes to the workshop immediately
    tw2(i)=(dh-da(i)+dw)/v; 
    tw2_(i)=round(tw2(i)/0.0001);

    %expected uptime utility 
    uc2_nf(i)=(1-gc(tw2_(i)))* ut((tw2(i)+t3+(dw+dc)/v - (dh-da(i)+dc)/v),pe_max, t_max); % no fault
    uc2_f(i)=0;
    for j=1:1:tw2_(i)
        dt=0.0001;
        tt2=(dh-da(i)+dw-v*j*dt)/v1;% tow truck come
        tt3=(dh-da(i)+dw-v*j*dt)/v2;% tow truck back
        uc2_f(i) = uc2_f(i) + gp(j)*ut((j*dt+t1+tt2+tt3+t2+ (dw+dc)/v - (dh-da(i)+dc)/v),pe_max, t_max)*dt;
    end
    uc2(i)= uc2_nf(i) + uc2_f(i);
    
    %expected economic loss 
    mc2_nf(i)=(1-gc(tw2_(i)))*c2 ;
    mc2_f(i)=0;
    for j=1:1:tw2_(i)
        dt=0.0001;
        mc2_f(i)= mc2_f(i) + gp(j)*(c1+ ct_fix + 2*ct_km*(dh-da(i)-v*j*dt+dw))*dt;
    end
    mc2(i)=mc2_nf(i)+mc2_f(i);
end
%% 
%decision 3 uptime loss
% time from alarm to customer if the vehicle continue task and doesn't fail
tc=(dh-da+dc)/v; 
tc_=round(tc/0.0001);
% time from alarm to workshop if the vehicle continue task and doesn't fail
tw3=(dh+2*dc+dw-da)/v; 
tw3_=round(tw3/0.0001);
    
for i=1:dh/2 
    % time from alarm to halfway of the highway if the vehicle continue task and doesn't fail
    th3(i)=(dh/2-da(i))/v; 
    th3_(i)=round(th3(i)/0.0001);
    %expected uptime utility 
    uc3(i)=0;
    for j=1:1:th3_(i)
        dt=0.0001;
        tt2=(da(i)+dw+v*j*dt)/v1;
        tt3=(da(i)+dw+v*j*dt)/v2;
        uc3(i)=uc3(i)+ gp(j)* ut((t1+ tt2 + tt3+ t2 + (da(i)+dw+v*j*dt)/v),pe_max, t_max)*dt;
    end
    for j=(th3_(i)+1):1:tc_(i)
        dt=0.0001;
        tt2 =(dh-(da(i)+v*j*dt)+dw)/v1;
        tt3 =(dh-(da(i)+v*j*dt)+dw)/v2;
        uc3(i)=uc3(i)+ gp(j)* ut((t1+tt2+tt3 + t2 + (dw+dc)/v -(dh-(da(i)+v*j*dt)+dc)/v),pe_max, t_max)*dt;
    end 
end

for i=dh/2+1:dh+1
    %expected uptime utility 
    uc3(i)=0;
    for j=1:1:tc_(i)
        dt=0.0001;
        tt2=(dh-da(i)-v*j*dt+dw)/v1;
        tt3=(dh-da(i)-v*j*dt+dw)/v2;
        uc3(i)=uc3(i)+  gp(j)* ut((t1+ tt2 + tt3+ t2 + (dw+dc)/v -(dh-da(i)-v*j*dt+dc)/v),pe_max, t_max)*dt;
    end
end
%% 
%economic loss of decision 3
mc3_nf(i)=(1-gc(tw3_(i)))*c2;

%tow truck service
for i=1:dh/2 
    % time from alarm to halfway of the highway if the vehicle continue task and doesn't fail
    th3(i)=(dh/2-da(i))/v; 
    th3_(i)=round(th3(i)/0.0001);
    % time from alarm to end of the highway if the vehicle continue task and doesn't fail
    te3(i)=(dh-da(i))/v; 
    te3_(i)=round(te3(i)/0.0001);
    
    mc3_f(i)=0;
    for j=1:1:th3_(i)
        dt=0.0001;
        mc3_f(i)=mc3_f(i) + gp(j)* (c1+ct_fix + 2*ct_km*(dw+da(i)+v*j*dt))*dt;
    end
    for j=th3_(i)+1:te3_(i)
        dt=0.0001;
        mc3_f(i)=mc3_f(i) + gp(j)* (c1+ct_fix + 2*ct_km*(dh-da(i)-v*j*dt+dw))*dt;
    end
    for j=te3_(i)+1:tc_(i)
        dt=0.0001;
        mc3_f(i)=mc3_f(i) + gp(j)* (c1+ct_fix + 2*ct_km*(da(i)+v*j*dt-dh+dw))*dt;
    end
    for j=tc_(i)+1:1:tw3_(i)
        dt=0.0001;
        mc3_f(i)=mc3_f(i) + gp(j)* (c1+ct_fix + 2*ct_km*(dw+dc-(da(i)+v*j*dt-dh-dc)))*dt;
    end
    mc3(i)=mc3_nf(i)+mc3_f(i);
end

for i=dh/2+1:dh+1   
    % time from alarm to end of the highway if the vehicle continue task and doesn't fail
    te3(i)=(dh-da(i))/v; 
    te3_(i)=round(te3(i)/0.0001);
    mc3_f(i)=0;
    for j=1:te3_(i)
        dt=0.0001;
        mc3_f(i)=mc3_f(i) + gp(j)* (c1+ct_fix + 2*ct_km*(dh-da(i)-v*j*dt+dw))*dt;
    end
    for j=te3_(i)+1:1:tc_(i)
        dt=0.0001;
        mc3_f(i)=mc3_f(i) + gp(j)* (c1+ct_fix + 2*ct_km*(da(i)+v*j*dt-dh+dw))*dt;
    end
    for j=tc_(i)+1:1:tw3_(i)
        dt=0.0001;
        mc3_f(i)=mc3_f(i) + gp(j)* (c1+ct_fix + 2*ct_km*(dw+dc-(da(i)+v*j*dt-dh-dc)))*dt;
    end
    mc3(i)=mc3_nf(i)+mc3_f(i);
end
%%
cm1_2= uc1 + mc1;
cm2_2= uc2 + mc2;
cm3_2= uc3 + mc3;

load('cm.mat')
YMatrix1= [cm1;cm1_2;cm2;cm2_2;cm3;cm3_2 ];



%% plotting 
axes1 = axes;
hold(axes1,'on');

% Create multiple lines using matrix input to plot
plot1 = plot(da,YMatrix1,'LineWidth',3);
set(plot1(1),'DisplayName',' m_1, two workshops');
set(plot1(2),'DisplayName',' m_2, two workshops','Color',[1 0 0]);
set(plot1(3),'DisplayName',' m_3, two workshops',...
    'Color',[0.929411768913269 0.694117665290833 0.125490203499794]);
set(plot1(4),'DisplayName',' m_1, one workshop','LineStyle','--',...
    'Color',[0 0.447058826684952 0.74117648601532]);
set(plot1(5),'DisplayName',' m_2, one workshop','LineStyle','--',...
    'Color',[1 0 0]);
set(plot1(6),'DisplayName',' m_3, one workshop','LineStyle','--',...
    'Color',[0.929411768913269 0.694117665290833 0.125490203499794]);

% Create ylabel
ylabel('total economic risk (kr)');

% Create xlabel
xlabel('Alarm location on the highway (km)');

% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[0 30000]);
box(axes1,'on');
% Set the remaining axes properties
set(axes1,'FontSize',50,'LineWidth',3);
% Create legend
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.582243883995281 0.758910015981004 0.323070599172992 0.166144195792256],...
    'NumColumns',2,...
    'FontSize',50,...
    'EdgeColor',[0.501960813999176 0.501960813999176 0.501960813999176]);


%%
c_min_2=min([cm1_2;cm2_2;cm3_2]);
eer_pm= mean(c_min);
eer_pm_2= mean(c_min_2);
eer_reduce= (eer_pm_2-eer_pm)/eer_pm

