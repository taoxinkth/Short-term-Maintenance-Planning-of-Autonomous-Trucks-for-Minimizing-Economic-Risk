%the sensitivity of a2
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
v=80
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

%% calculation

for q=1:9
    pe_max=800+400*(q-1);
    t_max=10;
    [uc1, mc1, uc2, mc2, uc3, mc3] = func(a1,b1,a,b,dh,dw,dc,v,v1,v2,v3, t1,t3,t2,c1,c2,ct_fix,ct_km,pe_max, t_max);
    cm1= uc1 + mc1;
    cm2= uc2 + mc2;
    cm3= uc3 + mc3;
    c_min=min([cm1;cm2;cm3]);
    ut_min_10(q,:)= c_min;
    [maxi_10(q),I_10(q)]=max(ut_min_10(q,:));
end

for q=1:9
    pe_max=800+400*(q-1);
    t_max=6;
    [uc1, mc1, uc2, mc2, uc3, mc3] = func(a1,b1,a,b,dh,dw,dc,v,v1,v2,v3, t1,t3,t2,c1,c2,ct_fix,ct_km,pe_max, t_max);
    cm1= uc1 + mc1;
    cm2= uc2 + mc2;
    cm3= uc3 + mc3;
    c_min=min([cm1;cm2;cm3]);
    ut_min_6(q,:)= c_min;
    [maxi_6(q),I_6(q)]=max(ut_min_6(q,:));
end



%% plotting 
da=[0:1:dh];
figure(2)
plot(da, ut_min_10)
hold on
plot(I_10-1,maxi_10)
hold on
plot(da, ut_min_6)
hold on
plot(I_6-1,maxi_6)