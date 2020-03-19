clc;
clear all

% Constants as the article
alpha = 1;
Omega = 1;
satu = 5;

Asc = [-1 , 2; -2 , 0];
Bsc = [0 ; 1];
Csc = [1 , 0];
T = 0.1;

% Discretization
[As,Bs,Cs]=ssdata(c2d(ss(Asc, Bsc, Csc, 0), T, 'zoh'));
Bsf = -Bs;
% One way to find observer gain is by place method (then it is necessary to check if stable) 
polesL = [exp(-10*T) exp(-11*T)];
L = -place(As',Cs',polesL).';
% Projected gain
K = [0.3328 -1.9991];

% Simulation variables
xs0=[-12;5];
xo0=[0;0];
kfin=7/T;

%tax = 1;
%alpha = exp(-tax*T); % If necessary comparisons between different sampling rates 
alpha = 0.95;

% Re-design, firstly co-design problem the emulation method.
[Qd, Qe,P, U, objective] = OtimizaEmulationGlobal(As,Bs,Cs,Bsf,K,L,Omega,alpha);

% Simulation
[xs, xp,xo, controlVec, samplingVec, nroSamples, SamplingDeltas,Kx] = simulateTriggeredSatWithPeriodic(As, Bs, Bsf, Cs, K, L, xs0, xo0, kfin, Qe, Qd, P, satu);

plotSimulation
 


% Checking the decay rate
xs2 = [xo.*xo ;(xs-xo).*(xs-xo)];
xsconf=xs2(1,1:end)+xs2(2,1:end)+xs2(3,1:end)+xs2(4,1:end);
xsconf = xsconf.^(1/2);
RealDecay=[];
Decay=[];
Decay(1)=xsconf(1);
RealDecay(1)=xsconf(1);
for k = 1:(size(xsconf,2)-1)
    RealDecay(k+1) = xsconf(k+1)/xsconf(k)-1;
end

for k = 1:(size(xsconf,2)-1)
    Decay(k+1) = Decay(k)*alpha^2;
end
figure;
j1=plot(0:kfin, RealDecay','Color',[0 0.5 0.8]); hold on;
j2=plot(0:kfin, Decay','Color',[0.85,0.325,0.098],'LineStyle','--');

ylabel('State');
xlabel('k')
legend([j1(1), j2(1)],'Real','DecayProjected','Location', 'northeast');