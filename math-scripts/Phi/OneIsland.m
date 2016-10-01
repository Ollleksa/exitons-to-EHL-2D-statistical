#!/usr/local/bin/WolframScript -script
SetDirectory["/home/oleksa/Documents/Science/CircleNew/Dependable"];
T=3.;
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

L = 2000;
GCritVal=0.0016569305134914944;
G = 5*GCritVal;

a= (G BesselI[1,L/l])/(BesselI[1,L/l] BesselK[0,L/l]+BesselI[0,L/l] BesselK[1,L/l]);
b=-((G BesselK[1,L/l])/(BesselI[1,L/l] BesselK[0,L/l]+BesselI[0,L/l] BesselK[1,L/l]));
Gg[x_]:=Gg[x] = reltau* Piecewise[{{G+b*BesselI[0,x/l],x<=L},{a*BesselK[0,x/l],x>L}}];
GIsl[x_]:=GIsl[x]=Piecewise[{{G,x<=L},{0,x>L}}];

aOne[R_,\[Phi]_]:=-Vfi*(Gg[R]-c0*Exp[-\[Phi]/T+\[Alpha]/(R*T)])/(l*BesselK[1,R/l]+Vfi*BesselK[0,R/l]);
conOne[R_,\[Phi]_]:=Gg[R]+aOne[R,\[Phi]]*BesselK[0,R/l];

F1One[R_?NumericQ,\[Phi]_]:=NIntegrate[Log[(2*conOne[x,\[Phi]]*Vfi+ x*GIsl[x])/(2*Vfi*c0*Exp[-\[Phi]/T+\[Alpha]/(x*T)] + x)]*x, {x, 0,R}];

ROne =450;
T0=35;
dT=1;
For[i=0,i < 101, i++,
g=T0-i*dT;
One = FindMaximum[F1One[x,g],{x,ROne},Method->"PrincipalAxis"];
ROne = x/.One[[2]][[1]];
ProbOne = One[[1]];
If[ROne>0,
PutAppend[ProbOne/10.^4, "ProbOnePhi"];
PutAppend[g,"gOnePhi"];
PutAppend[ROne/100,"ROnePhi"];]
]
