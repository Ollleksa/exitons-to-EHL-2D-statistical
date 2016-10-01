#!/usr/local/bin/WolframScript -script
num  = ToExpression[$ScriptCommandLine[[2]]];
SetDirectory["/home/oleksa/Documents/Science/CircleNew/Dependable"];

n=num;

\[Phi] =35;
\[Alpha] = 63;
\[Tau]ex = 9.5*10.^(-7);
ci = 10.^12;
\[Tau]=4*10.^(-7);
m =0.4;
\[CapitalOmega] =1.13*10^13;
\[CapitalTheta] = 1.518*10^11;

reltau =\[Tau]ex/\[Tau];

Wfi[T_]:=Wfi[T] =N[Sqrt[\[CapitalTheta]*T/(2*Pi*m)]];
Vfi [T_]:= Vfi [T]=Wfi[T]*\[Tau]*ci^0.5;
c0[T_]:= c0[T] = m*\[CapitalOmega]*T/(2*Pi*ci); 
l[T_]:=l[T]= Sqrt[300*\[Tau]ex/Sqrt[T]*ci];

L=2000.;
GCritVal=0.0016569305134914944;
G = 5*GCritVal;

a[T_]:=a[T]= (G BesselI[1,L/l[T]])/(BesselI[1,L/l[T]] BesselK[0,L/l[T]]+BesselI[0,L/l[T]] BesselK[1,L/l[T]]);
b[T_]:=b[T]=-((G BesselK[1,L/l[T]])/(BesselI[1,L/l[T]] BesselK[0,L/l[T]]+BesselI[0,L/l[T]] BesselK[1,L/l[T]]));
Gg[x_,T_]:=Gg[x,T] = reltau* Piecewise[{{G+b[T]*BesselI[0,x/l[T]],x<=L},{a[T]*BesselK[0,x/l[T]],x>L}}];
GIsl[x_]:=GIsl[x]=Piecewise[{{G,x<=L},{0,x>L}}];

SumSec[S_,T_,n_]:=SumSec[S,T,n]=Sum[BesselK[0,2*S*Abs[Sin[Pi*i/n]]/l[T]],{i,n-1}];

aSec[R_,S_,T_,n_]:=-Vfi [T]*(Gg[S,T]-c0[T]*Exp[-\[Phi]/T+\[Alpha]/(R*T)])/(l[T]*BesselK[1,R/l[T]]+Vfi [T]*(BesselK[0,R/l[T]]+SumSec[S,T,n]));

aiSec[Ri_,R_,S_,T_,n_]:=-Vfi [T]*(Gg[S,T]+aSec[R,S,T,n]*SumSec[S,T,n]-c0[T]*Exp[-\[Phi]/T+\[Alpha]/(Ri*T)])/(l[T]*BesselK[1,Ri/l[T]]+Vfi [T]*BesselK[0,Ri/l[T]]);

conSec[Ri_,R_,S_,T_,n_]:=Gg[S,T]+aiSec[Ri,R,S,T,n]*BesselK[0,Ri/l[T]]+aSec[R,S,T,n]*SumSec[S,T,n];

F1Sec[R_?NumericQ,S_?NumericQ,T_,n_]:=n*NIntegrate[Log[(2*conSec[ x,R, S,T,n]*Vfi[T] + x*GIsl[S])/(2*Vfi[T]*c0[T]*Exp[-\[Phi]/T+\[Alpha]/(x*T)] + x)]*x, {x, 0,R}];

Rmany =100;
Smany =1000;
T0=1.;
dT=0.1;
For[i=0,i < 101, i++,
g=T0-i*dT;
Many = FindMaximum[F1Sec[x,y,g,n],{{x,Rmany},{y,Smany}},Method->"PrincipalAxis"];
Rmany = x/.Many[[2]][[1]];
Smany = y/.Many[[2]][[2]];
ProbMany = Many[[1]];
If[Rmany>0,
PutAppend[ProbMany/10.^4, "Prob"<>ToString[n]<>"ManT"];
PutAppend[g,"g"<>ToString[n]<>"ManT"];
PutAppend[Rmany/100,"R"<>ToString[n]<>"ManT"];
PutAppend[Smany/100,"S"<>ToString[n]<>"ManT"]]
]
