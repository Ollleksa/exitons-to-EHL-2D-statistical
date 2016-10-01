#!/usr/local/bin/WolframScript -script
num  = ToExpression[$ScriptCommandLine[[2]]];

SetDirectory["/home/oleksa/Documents/Science/CircleNew/Dependable"];

n=num;

T=3.;
\[Phi] =35;
\[Alpha] = 63;
\[Tau]ex = 9.5*10.^(-7);
ci = 10.^12;
\[Tau]=4*10.^(-7);
m =0.4;
\[CapitalOmega] =1.13*10^13;
\[CapitalTheta] = 1.518*10^11;

reltau =\[Tau]ex/\[Tau];

Wfi=N[Sqrt[\[CapitalTheta]*T/(2*Pi*m)]];
 Vfi =Wfi*\[Tau]*ci^0.5;
c0= m*\[CapitalOmega]*T/(2*Pi*ci); 
l= Sqrt[300*\[Tau]ex/Sqrt[T]*ci];

GCritVal=0.0016569305134914944;
G = 5*GCritVal;

a[L_]:=a[L]= (G BesselI[1,L/l])/(BesselI[1,L/l] BesselK[0,L/l]+BesselI[0,L/l] BesselK[1,L/l]);
b[L_]:=b[L]=-((G BesselK[1,L/l])/(BesselI[1,L/l] BesselK[0,L/l]+BesselI[0,L/l] BesselK[1,L/l]));
Gg[x_,L_]:=Gg[x,L] = reltau* Piecewise[{{G+b[L]*BesselI[0,x/l],x<=L},{a[L]*BesselK[0,x/l],x>L}}];
GIsl[x_,L_]:=GIsl[x,L]=Piecewise[{{G,x<=L},{0,x>L}}];

SumSec[S_,n_]:=SumSec[S,n]=Sum[BesselK[0,2*S*Abs[Sin[Pi*i/n]]/l],{i,n-1}];

aSec[R_,S_,L_,n_]:=-Vfi*(Gg[S,L]-c0*Exp[-\[Phi]/T+\[Alpha]/(R*T)])/(l*BesselK[1,R/l]+Vfi *(BesselK[0,R/l]+SumSec[S,n]));

aiSec[Ri_,R_,S_,L_,n_]:=-Vfi*(Gg[S,L]+aSec[R,S,L,n]*SumSec[S,n]-c0*Exp[-\[Phi]/T+\[Alpha]/(Ri*T)])/(l*BesselK[1,Ri/l]+Vfi*BesselK[0,Ri/l]);

conSec[Ri_,R_,S_,L_,n_]:=Gg[S,L]+aiSec[Ri,R,S,L,n]*BesselK[0,Ri/l]+aSec[R,S,L,n]*SumSec[S,n];

F1Sec[R_?NumericQ,S_?NumericQ,L_,n_]:=n*NIntegrate[Log[(2*conSec[ x,R, S,L,n]*Vfi + x*GIsl[S,L])/(2*Vfi*c0*Exp[-\[Phi]/T+\[Alpha]/(x*T)] + x)]*x, {x, 0,R}];

Rmany =1000;
Smany =10000;
T0=10000;
dT=100;
For[i=0,i < 101, i++,
g=T0-i*dT;
Many = FindMaximum[F1Sec[x,y,g,n],{{x,Rmany},{y,Smany}},Method->"PrincipalAxis"];
Rmany = x/.Many[[2]][[1]];
Smany = y/.Many[[2]][[2]];
ProbMany = Many[[1]];
If[Rmany>0,
PutAppend[ProbMany/10.^4, "Prob"<>ToString[n]<>"ManL"];
PutAppend[g/100,"g"<>ToString[n]<>"ManL"];
PutAppend[Rmany/100,"R"<>ToString[n]<>"ManL"];
PutAppend[Smany/100,"S"<>ToString[n]<>"ManL"]]
]
