function [xs, xp,xo, controlVec, samplingVec,nroSamples, SamplingDeltas,Kx] = simulateTriggeredSatWithPeriodic(As, Bs, Bsf, Cs, K, L, xs0, xo0, kfin, Qe, Qd,P,satu)
% xs+ = As*x + Bs*u + Bsf*g(u) 
% xo+ = As*xo + Bs*u + Bsf*g(u) - L*(y - yo) 
% ys = Cs*xs
% yo = Cs*xo
% u = K*xo(ni)	

	k = [0];	
	xs = [xs0];
	xo = [xo0];
	xoni = xo0;
	u = K*xo0;
	controlVec = u;
    samplingVec = [1];
	Kx = [u];
    Qe1 = inv(Qe);
	for i=1:kfin
		
		delta = (xoni - xo(:,i));
		ey = Cs*(xs(:,i)-xo(:,i)); 
		triggerfunction = delta'*Qd*delta  - [xo(:,i); ey]' *Qe1* [xo(:,i); ey];
% 		triggerfunction = 1; %% Periodic
		if (triggerfunction > 0) % Sample 
			samplingVec(i+1) = 1;
			xoni = xo(:,i);
			
		else %Do not sample
			samplingVec(i+1) = 0;
		end

		u = K * xoni;
		
        control = sat(u,satu);
        xsNew = As*xs(:,i) + Bs*control;
		xoNew = As*xo(:,i) + Bs*control - L*ey;

		xs = [xs xsNew];
		xo = [xo xoNew];
		controlVec = [controlVec control];
        Kx = [Kx K*xo(:,i)];
    end
    
    %Verifies number of samples and minimum inter-sampling time
	samplingTimes=find(samplingVec');
	nroSamples=size(samplingTimes,1);
	SamplingDeltas = diff(samplingTimes);
	minInterSampleSamples = min(SamplingDeltas);
	if(norm(xs(:,end)) < 2e-1)
		fprintf('#samples = %d & minInterSample = %d ', nroSamples, minInterSampleSamples);
    end
    
    % Remakes with periodic strategy for comparison
	k = [0];	
	xp = [xs0];
	xo2 = [xo0];
	xoni = xo0;
	u = K*xo0;
	controlVecp = u;
	Kx = [u];
    
    	for i=1:kfin
		
		delta = (xoni - xo2(:,i));
		ey = Cs*(xp(:,i)-xo2(:,i)); 

		xoni = xo2(:,i);
    	u = K * xoni;
        control = sat(u,satu);
        xpNew = As*xp(:,i) + Bs*control;
		xoNew = As*xo2(:,i) + Bs*control - L*ey;

		xp = [xp xpNew];
		xo2 = [xo2 xoNew];
		controlVecp = [controlVecp control];

        end
    controlVec = [controlVec;controlVecp];
    
	
end

