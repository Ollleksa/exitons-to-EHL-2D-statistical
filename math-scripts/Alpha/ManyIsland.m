#!/usr/local/bin/WolframScript -script
num  = ToExpression[$ScriptCommandLine[[2]]];
SetDirectory["/home/oleksa/Documents/Science/CircleNew/Dependable"];
n =num;
T=3.;
\[Phi]=35;
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

L = 2000;
GCritVal=0.0016569305134914944;
G = 5*GCritVal;

a= (G BesselI[1,L/l])/(BesselI[1,L/l] BesselK[0,L/l]+BesselI[0,L/l] BesselK[1,L/l]);
b=-((G BesselK[1,L/l])/(BesselI[1,L/l] BesselK[0,L/l]+BesselI[0,L/l] BesselK[1,L/l]));
Gg[x_]:=Gg[x] = reltau* Piecewise[{{G+b*BesselI[0,x/l],x<=L},{a*BesselK[0,x/l],x>L}}];
GIsl[x_]:=GIsl[x]=Piecewise[{{G,x<=L},{0,x>L}}];

SumSec[S_,n_]:=SumSec[S,n]=Sum[BesselK[0,2*S*Abs[Sin[Pi*i/n]]/l],{i,n-1}];

aSec[R_,S_,\[Alpha]_,n_]:=-Vfi*(Gg[S]-c0*Exp[-\[Phi]/T+\[Alpha]/(R*T)])/(l*BesselK[1,R/l]+Vfi *(BesselK[0,R/l]+SumSec[S,n]));

aiSec[Ri_,R_,S_,\[Alpha]_,n_]:=-Vfi*(Gg[S]+aSec[R,S,\[Alpha],n]*SumSec[S,n]-c0*Exp[-\[Phi]/T+\[Alpha]/(Ri*T)])/(l*BesselK[1,Ri/l]+Vfi*BesselK[0,Ri/l]);

conSec[Ri_,R_,S_,\[Alpha]_,n_]:=Gg[S]+aiSec[Ri,R,S,\[Alpha],n]*BesselK[0,Ri/l]+aSec[R,S,\[Alpha],n]*SumSec[S,n];

F1Sec[R_?NumericQ,S_?NumericQ,\[Alpha]_,n_]:=n*NIntegrate[Log[(2*conSec[ x,R, S,\[Alpha],n]*Vfi + x*GIsl[S])/(2*Vfi*c0*Exp[-\[Phi]/T+\[Alpha]/(x*T)] + x)]*x, {x, 0,R}];

Rmany =200;
Smany =2000;
T0=63;
dT=10;
For[i=0,i < 101, i++,
g=T0-i*dT;
Many = FindMaximum[F1Sec[x,y,g,n],{{x,Rmany},{y,Smany}},Method->"PrincipalAxis"];
Rmany = x/.Many[[2]][[1]];
Smany = y/.Many[[2]][[2]];
ProbMany = Many[[1]];
If[Rmany>0,
PutAppend[ProbMany/10.^4, "Prob"<>ToString[n]<>"ManAlpha"];
PutAppend[g,"g"<>ToString[n]<>"ManAlpha"];
PutAppend[Rmany/100,"R"<>ToString[n]<>"ManAlpha"];
PutAppend[Smany/100,"S"<>ToString[n]<>"ManAlpha"]]
]
