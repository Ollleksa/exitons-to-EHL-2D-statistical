#!/usr/local/bin/WolframScript -script
SetDirectory["/home/oleksa/Documents/Science/CircleNew/Dependable"];
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

aOne[R_,L_]:=-Vfi*(Gg[R,L]-c0*Exp[-\[Phi]/T+\[Alpha]/(R*T)])/(l*BesselK[1,R/l]+Vfi*BesselK[0,R/l]);
conOne[x_,R_,L_]:=Gg[x,L]+aOne[R,L]*BesselK[0,x/l];

F1One[R_?NumericQ,L_]:=NIntegrate[Log[(2*conOne[x, x,L]*Vfi+ x*GIsl[x,L])/(2*Vfi*c0*Exp[-\[Phi]/T+\[Alpha]/(x*T)] + x)]*x, {x, 0,R}];

ROne =1000;
T0=10000;
dT=100;
For[i=0,i < 101, i++,
g=T0-i*dT;
One = FindMaximum[F1One[x,g],{x,ROne},Method->"PrincipalAxis"];
ROne = x/.One[[2]][[1]];
ProbOne = One[[1]];
If[ROne>0,
PutAppend[ProbOne/10.^4, "ProbOneL"];
PutAppend[g/100,"gOneL"];
PutAppend[ROne/100,"ROneL"];]
]
