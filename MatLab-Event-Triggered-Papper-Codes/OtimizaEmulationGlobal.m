function [Qd, Qe, P, U, objective] = OtimizaEmulationGlobal(As,Bs,Cs,Bsf,K,L,Omega,alpha)

addpath(genpath('C:\Program Files\MATLAB\R2018a\bin\YALMIP-master'));
addpath(genpath('C:\Program Files\MATLAB\R2018a\bin\SDPT3-master'));
addpath(genpath('C:\Program Files\MATLAB\R2018a\bin\sedumi-master'));
warning('off','YALMIP:strict')
fprintf('\n>>> Problem parameters:\n')

[n,p] = size(Bs); % Dim x e u
m = size(Cs,1); % Dim y

% As in the papper notation
W = sdpvar(2*n,2*n);
Qe = sdpvar(n+m,n+m);
Qd = sdpvar(n,n);
U = diag(sdpvar(1,p)); % U = S^-1
Beta = sdpvar(1,1);

A = [As + Bs*K, -L*Cs;
    zeros(n,n), As+L*Cs]; 
B = [Bs ;
    zeros(n,p)];
Bf = [Bsf ;
     zeros(n,p)];
C = [eye(n), zeros(n,n) ;
     zeros(m,n), Cs]; 

LMIs = [(W > 0) : 'W>0' ; (Qe > 0) : 'Qe > 0' ; (Qd > 0) : 'Qd >0' ; (U > 0) : 'U>0'  ];


cond1 = [-W*alpha^2                 ,           zeros(2*n,n)   ,          -((Omega*[K zeros(p,n)])*W)'     ,     (A*W)'     ,    (C*W)'          ;
        zeros(n,2*n)           ,             -Qd        ,                 (-Omega*K)'                 ,      (B*K)'        ,  zeros(n,n+m)    ;
        -(Omega*[K zeros(p,n)])*W ,           -Omega*K    ,                   -2*U                   ,      (Bf*U)'       , zeros(p,n+m)       ;
            A*W                 ,              (B*K)         ,                    Bf*U                    ,     -W         ,     zeros(2*n,n+m)   ; 
         C*W                  ,   zeros(n+m,n)         ,           zeros(n+m,p)                   ,    zeros(n+m,2*n)   ,   -Qe           ];

  
LMIs = [LMIs ; (cond1<0) : 'LMIStab' ] ; 


ops = sdpsettings('verbose',0, 'solver', 'SDPT3');
res = optimize(LMIs, trace(Qd)+trace(Qe), ops) % Optimization function
checkset(LMIs)

if (res.problem ~= 0)
	error('LMI Error! Is it unfeasible?')
	fprintf('unfeasible')
end

if(min(checkset(LMIs)) < 0)
    min(checkset(LMIs))
	checkset(LMIs)
	error('LMI checkset Error! Is it unfeasible?')
	fprintf('unfeasible? Checkset Error!')
end


% Return from yalmip parser to numerical values.
Qd = value(Qd);
Qe = value(Qe);
P  = inv(value(W));
U  = inv(value(U));
objective = trace(Qd)+trace(Qe);
fprintf('\n %0.6f ', objective);
