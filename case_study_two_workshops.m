% remember to run case_study_one_workshop first and save cm1,cm2,cm3 as one
% workshop datafile

clear all
clc

%Gamma distribution for decision 2 and 3
a=2;
b=2;
x=[0:0.0001:30];
gc = gamcdf(x,a,b);
gp= gampdf(x,a,b);
%gamma distribution ofr decision 1
a1=5;
b1=2;
gc1 = gamcdf(x,a1,b1);
gp1= gampdf(x,a1,b1);

%% paramiterization
dh=300;dw=20;dc=20;% distance km
v=80;v1=80;v2=30; v3=40; % velocity km/h
t1=0.5;% time of scheduling tow truck (h)
t2=4;t3=2;%time of maintenance (h)
c1=1000;c2=500;% maintenance cost(kr)
ct_fix= 75; %kr, fix cost of tow truck service(hook-up fee)
ct_km= 2.5; % 25kr per km
da=[0:1:dh];% location of alarm

%%
%decision 1
for i=1:dh/2   
    % time from alarm location to workshop if the vehicle goes back immediately
    tw1(i)=(da(i)+dw)/v3; 
    tw1_(i)=round(tw1(i)/0.0001);

    %expected uptime utility 
    uc1_e1_nf(i)=(1-gc1(tw1_(i)))* ut(tw1(i)); % e1 refer to events, from alarm location to the workshop
    uc1_e1_f(i)=0;
    for j=1:1:tw1_(i)
        dt=0.0001;
        tt2=(da(i)+dw-v3*j*dt)/v1;% tow truck come
        tt3=(da(i)+dw-v3*j*dt)/v2;% tow truck back
        uc1_e1_f(i) = uc1_e1_f(i) + gp1(j)*ut((j*dt+t1+tt2+tt3))*dt;
    end
    uc1_e1(i) = uc1_e1_nf(i)+ uc1_e1_f(i);
    uc1_e2(i) = (gc1(tw1_(i))- gc1(1))*ut(t2) + (1-gc1(tw1_(i)))*ut(t3);
    uc1_e3(i) = ut(tw1(i));
    uc1(i)= uc1_e1(i) + uc1_e2(i) + uc1_e3(i);
    
    %expected economic loss 
    mc1_e1(i)=(gc1(tw1_(i))- gc1(1))*c1 +(1-gc1(tw1_(i)))*c2 ;
    mc1_e2(i)=0;
    for j=1:1:tw1_(i)
        dt=0.0001;
        mc1_e2_dt= gp1(j)*(ct_fix + 2*ct_km*(dw+da(i)-v3*j*dt))*dt;
        mc1_e2(i)= mc1_e2(i) + mc1_e2_dt;
    end
   mc1(i)=mc1_e1(i)+mc1_e2(i);
    
end 

for i= (dh/2 +1):(dh+1) 
    % time from alarm location to workshop if the vehicle goes to the workshop immediately
    tw1(i)=(dh-da(i)+dw)/v3; 
    tw1_(i)=round(tw1(i)/0.0001);

    %expected uptime utility 
    uc1_e1_nf(i)=(1-gc1(tw1_(i)))* ut(tw1(i)); % e1 refer to events, from alarm location to the workshop
    uc1_e1_f(i)=0;
    for j=1:1:tw1_(i)
        dt=0.0001;
        tt2=(dh-da(i)+dw-v3*j*dt)/v1;% tow truck come
        tt3=(dh-da(i)+dw-v3*j*dt)/v2;% tow truck back
        uc1_e1_f(i) = uc1_e1_f(i) + gp1(j)*ut((j*dt+t1+tt2+tt3))*dt;
    end
    uc1_e1(i) = uc1_e1_nf(i)+ uc1_e1_f(i);
    uc1_e2(i) = (gc1(tw1_(i))- gc1(1))*ut(t2) + (1-gc1(tw1_(i)))*ut(t3);
    uc1_e3(i) = ut((dw+dc)/v3);
    uc1(i)= uc1_e1(i) + uc1_e2(i) + uc1_e3(i)-ut((dh-da(i)+dc)/v3);
    
    %expected economic loss 
    mc1_e1(i)=(gc1(tw1_(i))- gc1(1))*c1 +(1-gc1(tw1_(i)))*c2 ;
    mc1_e2(i)=0;
    for j=1:1:tw1_(i)
        dt=0.0001;
        mc1_e2_dt= gp1(j)*(ct_fix + 2*ct_km*(dw+dh-da(i)-v3*j*dt))*dt;
        mc1_e2(i)= mc1_e2(i) + mc1_e2_dt;
    end
   mc1(i)=mc1_e1(i)+mc1_e2(i);
end
%% 
%decision 2
for i=1:dh/2   
    % time from alarm location to workshop if the vehicle goes back immediately
    tw2(i)=(da(i)+dw)/v; 
    tw2_(i)=round(tw2(i)/0.0001);

    %expected uptime utility 
    uc2_e1_nf(i)=(1-gc(tw2_(i)))* ut(tw2(i)); % e1 refer to events, from alarm location to the workshop
    uc2_e1_f(i)=0;
    for j=1:1:tw2_(i)
        dt=0.0001;
        tt2=(da(i)+dw-v*j*dt)/v1;% tow truck come
        tt3=(da(i)+dw-v*j*dt)/v2;% tow truck back
        uc2_e1_f(i) = uc2_e1_f(i) + gp(j)*ut((j*dt+t1+tt2+tt3))*dt;
    end
    uc2_e1(i) = uc2_e1_nf(i)+ uc2_e1_f(i);
    uc2_e2(i) = (gc(tw2_(i))- gc(1))*ut(t2) + (1-gc(tw2_(i)))*ut(t3);
    uc2_e3(i) = ut(tw2(i));
    uc2(i)= uc2_e1(i) + uc2_e2(i) + uc2_e3(i);
    
    %expected economic loss 
    mc2_e1(i)=(gc(tw2_(i))- gc(1))*c1 +(1-gc(tw2_(i)))*c2 ;
    mc2_e2(i)=0;
    for j=1:1:tw2_(i)
        dt=0.0001;
        mc2_e2_dt(j)= gp(j)*(ct_fix + 2*ct_km*(dw+da(i)-v*j*dt))*dt;
        mc2_e2(i)= mc2_e2(i) + mc2_e2_dt(j);
    end
   mc2(i)=mc2_e1(i)+mc2_e2(i);
    
end 

for i= (dh/2 +1):(dh+1) 
    % time from alarm location to workshop if the vehicle goes to the workshop immediately
    tw2(i)=(dh-da(i)+dw)/v; 
    tw2_(i)=round(tw2(i)/0.0001);

    %expected uptime utility 
    uc2_e1_nf(i)=(1-gc(tw2_(i)))* ut(tw2(i)); % e1 refer to events, from alarm location to the workshop
    uc2_e1_f(i)=0;
    for j=1:1:tw2_(i)
        dt=0.0001;
        tt2=(dh-da(i)+dw-v*j*dt)/v1;% tow truck come
        tt3=(dh-da(i)+dw-v*j*dt)/v2;% tow truck back
        uc2_e1_f(i) = uc2_e1_f(i) + gp(j)*ut((j*dt+t1+tt2+tt3))*dt;
    end
    uc2_e1(i) = uc2_e1_nf(i)+ uc2_e1_f(i);
    uc2_e2(i) = (gc(tw2_(i))- gc(1))*ut(t2) + (1-gc(tw2_(i)))*ut(t3);
    uc2_e3(i) = ut((dw+dc)/v);
    uc2(i)= uc2_e1(i) + uc2_e2(i) + uc2_e3(i)-ut((dh-da(i)+dc)/v);
    
    %expected economic loss 
    mc2_e1(i)=(gc(tw2_(i))- gc(1))*c1 +(1-gc(tw2_(i)))*c2 ;
    mc2_e2(i)=0;
    for j=1:1:tw2_(i)
        dt=0.0001;
        mc2_e2_dt(j)= gp(j)*(ct_fix + 2*ct_km*(dw+dh-da(i)-v*j*dt))*dt;
        mc2_e2(i)= mc2_e2(i) + mc2_e2_dt(j);
    end
   mc2(i)=mc2_e1(i)+mc2_e2(i);
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
        tt2(j)=(da(i)+dw+v*j*dt)/v1;
        tt3(j)=(da(i)+dw+v*j*dt)/v2;
        uc3_e3(i)= (da(i)+dw+v*j*dt)/v;
        uc3_dt(j) = gp(j)* ut((t1+ tt2(j) + tt3(j)+ t2 + uc3_e3(i)))*dt;
        uc3(i)=uc3(i)+ uc3_dt(j);
    end
    for j=(th3_(i)+1):1:tc_(i)
        dt=0.0001;
        tt2(j)=(dh-(da(i)+v*j*dt)+dw)/v1;
        tt3(j)=(dh-(da(i)+v*j*dt)+dw)/v2;
        uc3_e3(i)= (dw+dc)/v;
        uc3_dt(j) = gp(j)* ut((t1+ tt2(j) + tt3(j)+ t2 + uc3_e3(i)-(dh-(da(i)+v*j*dt)+dc)/v))*dt;
        uc3(i)=uc3(i)+ uc3_dt(j);
    end 
end

for i=dh/2+1:dh+1
    %expected uptime utility 
    uc3(i)=0;
    for j=1:1:tc_(i)
        dt=0.0001;
        tt2(j)=(dh-da(i)-v*j*dt+dw)/v1;
        tt3(j)=(dh-da(i)-v*j*dt+dw)/v2;
        uc3_e3(i)= (dw+dc)/v;
        uc3_dt(j) = gp(j)* ut(t1+ tt2(j) + tt3(j)+ t2 + uc3_e3(i)-(dh-da(i)-v*j*dt+dc)/v)*dt;
        uc3(i)=uc3(i)+ uc3_dt(j);
    end
end
%% 
%economic loss of decision 3
%workhsop maintenance
for i=1:dh+1  
    mc3_e1(i)= (gc(tw3_(i))- gc(1))*c1+(1-gc(tw3_(i)))*c2;
end
%tow truck service
for i=1:dh/2 
    % time from alarm to halfway of the highway if the vehicle continue task and doesn't fail
    th3(i)=(dh/2-da(i))/v; 
    th3_(i)=round(th3(i)/0.0001);
    % time from alarm to end of the highway if the vehicle continue task and doesn't fail
    te3(i)=(dh-da(i))/v; 
    te3_(i)=round(te3(i)/0.0001);
    
    mc3_e2(i)=0;
    for j=1:1:th3_(i)
        dt=0.0001;
        mc3_e2_dt(j) = gp(j)* (ct_fix + 2*ct_km*(da(i)+dw+v*j*dt))*dt;
        mc3_e2(i)=mc3_e2(i) + mc3_e2_dt(j);
    end
    for j=th3_(i)+1:te3_(i)
        dt=0.0001;
        mc3_e2_dt(j) = gp(j)* (ct_fix + 2*ct_km*(dh-da(i)-v*j*dt+dw))*dt;
        mc3_e2(i)=mc3_e2(i) + mc3_e2_dt(j);
    end
    for j=te3_(i)+1:tc_(i)
        dt=0.0001;
        mc3_e2_dt(j) = gp(j)* (ct_fix + 2*ct_km*(da(i)+v*j*dt-dh+dw))*dt;
        mc3_e2(i)=mc3_e2(i) + mc3_e2_dt(j);
    end
    for j=tc_(i)+1:1:tw3_(i)
        dt=0.0001;
        mc3_e2_dt(j) = gp(j)* (ct_fix + 2*ct_km*(dh+2*dc+dw-da(i)-v*j*dt))*dt;
        mc3_e2(i)=mc3_e2(i) + mc3_e2_dt(j);
    end
    mc3(i)=mc3_e1(i)+mc3_e2(i);
end

for i=dh/2+1: dh+1   
     % time from alarm to end of the highway if the vehicle continue task and doesn't fail
    te3(i)=(dh-da(i))/v; 
    te3_(i)=round(te3(i)/0.0001);
    mc3_e2(i)=0;
    for j=1:te3_(i)
        dt=0.0001;
        mc3_e2_dt(j) = gp(j)* (ct_fix + 2*ct_km*(dh-da(i)-v*j*dt+dw))*dt;
        mc3_e2(i)=mc3_e2(i) + mc3_e2_dt(j);
    end
    for j=te3_(i)+1:1:tc_(i)
        dt=0.0001;
        mc3_e2_dt(j) = gp(j)* (ct_fix + 2*ct_km*(da(i)+v*j*dt-dh+dw))*dt;
        mc3_e2(i)=mc3_e2(i) + mc3_e2_dt(j);
    end
    for j=tc_(i)+1:1:tw3_(i)
        dt=0.0001;
        mc3_e2_dt(j) = gp(j)* (ct_fix + 2*ct_km*(dh+2*dc+dw-da(i)-v*j*dt))*dt;
        mc3_e2(i)=mc3_e2(i) + mc3_e2_dt(j);
    end
    mc3(i)=mc3_e1(i)+mc3_e2(i);
end
%%
c1= uc1 + mc1;
c2= uc2 + mc2;
c3= uc3 + mc3;

load('one workshop.mat')
YMatrix1= [cm1;cm2;cm3;c1;c2;c3 ];

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

%%
% xx= mean(c1)
% yy= mean(c2)
% zz= mean(c3)
% c_min1=min([c1;c2;c3]);
% xyz1= mean(c_min)
% (xx-xyz)/xx
% (yy-xyz)/yy
% (zz-xyz)/zz
