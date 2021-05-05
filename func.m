function [uc1, mc1, uc2, mc2, uc3, mc3] = func(a1,b1,a,b,dh,dw,dc,v,v1,v2,v3, t1,t3,t2,c1,c2,ct_fix, ct_km,pe_max, t_max)

% This function computes the economic riks of different decisions with one workshop scenario, 
% with 20 inputes and 6 outputs
% Inputs: 
% a1- shape parameter of gamma distribution of decision 1
% b1- scale parameter of gamma distribution of decision 1
% a- shape parameter of gamma distribution of decision 2 and 3 
% b- scale parameter of gamma distribution of decision 2 and 3 
% dh-length of the highway (km)
% dw- distance from the highway entrance to the workshop (km)
% dc- distance from the highway exit to the customer (km)
% v -  normal speed of the truck (km/hour) 
% v1- speed of an unloaded truck (km/hour) 
% v2- speed of a loaded truck (km/hour) 
% v3-  reduced speed to the workshop (km/hour) 
% t1- time of scheduling tow truck (hour)
% t3- time of maintenance of truck that does not break down (hour)
% t2- time of maintenance of truck that breaks down(hour)
% c1- maintenance cost of truck that breaks down (EUR)
% c2-  maintenance cost of truck that does not break down(EUR)
% ct_fix- fix cost of tow truck service(hook-up fee) (EUR)
% ct_km- cost of tow truck per kilometer (EUR/km) 
% pe_max- penalty of order cancellation (EUR)
% t_max- maximal time of delivery delay before order cancellation (hour)
% 
% Output:
% uc1- economic risk of availability loss of decision wr (EUR)
% mc1- economic risk of maintenance cost of decision wr (EUR)
% uc2- economic risk of availability loss of decision wn (EUR)
% mc2- economic risk of maintenance cost of decision wn (EUR)
% uc3- economic risk of availability loss of decision cn (EUR)
% mc3- economic risk of maintenance cost of decision cn (EUR)

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

% decision 1, time from alarm location to workshop if the vehicle stops and wait for a tow truck
tw1=(da+dw)/v3;
tw1_=round(tw1/0.0001);

% decision 2, time from alarm location to workshop if the vehicle goes back immediately
tw2=(da+dw)/v; 
tw2_=round(tw2/0.0001);

% decision 3
% time from alarm to customer if the vehicle continue task and doesn't fail
tc=(dh-da+dc)/v; 
tc_=round(tc/0.0001);
% time from alarm to workshop if the vehicle continue task and doesn't fail
tw3=(2*dh+2*dc+dw-da)/v; 
tw3_=round(tw3/0.0001);

%% decision wr

for i=1:dh+1   
    %expected economic risk of availability loss, uc1
    %without failure
    uc1_nf(i)=(1-gc1(tw1_(i)))* ut((tw1(i)+t3+0.5*tw1(i)),pe_max, t_max); 
    %with failure 
    uc1_f(i)=0;
    for j=1:1:tw1_(i)
        dt=0.0001;
        tt2=(da(i)+dw-v3*j*dt)/v1;% tow truck come to the site
        tt3=(da(i)+dw-v3*j*dt)/v2;% tow truck back to the workshop
        uc1_f(i) = uc1_f(i) + gp1(j)*ut((j*dt+t1+tt2+tt3+t2+0.5*tw1(i)),pe_max, t_max)*dt;
    end
    uc1(i)= uc1_nf(i) + uc1_f(i);
    
    %expected maintenance cost, mc1
    %without failure
    mc1_nf(i)=(1-gc1(tw1_(i)))*c2 ;
    %with failure
    mc1_f(i)=0;
    for j=1:1:tw1_(i)
        dt=0.0001;
        mc1_f(i)= mc1_f(i) + gp1(j)*(c1+ ct_fix + 2*ct_km*(dw+da(i)-v3*j*dt))*dt;
    end
    mc1(i)=mc1_nf(i)+mc1_f(i);
end 

%% decision wn

for i=1:dh+1   
    %expected economic risk of availability loss, uc2
    %without failure
    uc2_nf(i)=(1-gc(tw2_(i)))* ut((tw2(i)+t3+tw2(i)),pe_max, t_max); 
    %with failure
    uc2_f(i)=0;
    for j=1:1:tw2_(i)
        dt=0.0001;
        tt2=(da(i)+dw-v*j*dt)/v1;% tow truck come to the site
        tt3=(da(i)+dw-v*j*dt)/v2;% tow truck back to the workshop
        uc2_f(i) = uc2_f(i) + gp(j)*ut((j*dt+t1+tt2+tt3+t2+tw2(i)),pe_max, t_max)*dt;
    end
    uc2(i)= uc2_nf(i) + uc2_f(i);
    
    %expected  maintenance cost, mc2
    %without failure
    mc2_nf(i)=(1-gc(tw2_(i)))*c2 ;
    %with failure
    mc2_f(i)=0;
    for j=1:1:tw2_(i)
        dt=0.0001;
        mc2_f(i)= mc2_f(i) + gp(j)*(c1+ ct_fix + 2*ct_km*(dw+da(i)-v*j*dt))*dt;
    end
    mc2(i)=mc2_nf(i)+mc2_f(i);
    
end 
%% decision cn

for i=1:dh+1   
    %expected economic risk of availability loss, uc3
    %with failure
    uc3(i)=0;
    for j=1:1:tc_(i)
        dt=0.0001;
        tt2=(da(i)+dw+v*j*dt)/v1;
        tt3=(da(i)+dw+v*j*dt)/v2;
        uc3(i)=uc3(i)+ gp(j)* ut((t1+ tt2 + tt3+ t2 + (da(i)+dw+v*j*dt)/v),pe_max, t_max)*dt;
    end
    
    %expected  maintenance cost, mc3
    %without failure
    mc3_nb(i)=(1-gc(tw3_(i)))*c2;
    %with failure
    mc3_b(i)=0;
    for j=1:1:tc_(i)
        dt=0.0001;
        mc3_b(i)=mc3_b(i) + gp(j)* (c1+ct_fix + 2*ct_km*(dw+da(i)+v*j*dt))*dt;
    end
    for j=tc_(i)+1:1:tw3_(i)
        dt=0.0001;
        mc3_b(i)=mc3_b(i) + gp(j)* (c1+ct_fix + 2*ct_km*(2*dh+2*dc+dw-da(i)-v*j*dt))*dt;
    end
    mc3(i)=mc3_nb(i)+mc3_b(i);
    
end

end
