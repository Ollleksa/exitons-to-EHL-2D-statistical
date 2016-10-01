#!/usr/local/bin/WolframScript -script

SetDirectory["/home/oleksa/Documents/Science/CircleNew/Dependable"];

T =3.;
\[Phi] =35;
\[Alpha] = 63;
tauEx = 9.5*10.^(-7);
ci = 10.^12;
\[Tau]=4*10.^(-7);
m =0.4;
\[CapitalOmega] =1.13*10^13;
\[CapitalTheta] = 1.518*10^11;
L = 2000;

reltau=tauEx/\[Tau];

l = Sqrt[300*tauEx*ci/Sqrt[T]];

Wfi =N[Sqrt[\[CapitalTheta]*T/(2*Pi*m)]];
Vfi =Wfi*\[Tau]*ci^0.5;
c0 = m*\[CapitalOmega]*T/(2*Pi*ci); 

GCritVal=0.0016569305134914944;

a[G_]:=a[G]= (G*BesselI[1,L/l])/(BesselI[1,L/l] BesselK[0,L/l]+BesselI[0,L/l] BesselK[1,L/l]);
b[G_]:=b[G]=-((G*BesselK[1,L/l])/(BesselI[1,L/l] BesselK[0,L/l]+BesselI[0,L/l] BesselK[1,L/l]));
Gg[x_,G_]:=Gg[x,G] = Piecewise[{{G+b[G]*BesselI[0,x/l],x<=L},{a[G]*BesselK[0,x/l],x>L}}];
GIsl[x_,G_]:=GIsl[x,G] = Piecewise[{{G,x<=L},{0,x>L}}];

aOne[R_,G_]:=-Vfi*(reltau*Gg[R,G]-c0*Exp[-\[Phi]/T+\[Alpha]/(R*T)])/(l*BesselK[1,R/l]+Vfi*BesselK[0,R/l]);
conOne[R_,G_]:=reltau*Gg[x,G]+aOne[R,G]*BesselK[0,R/l];

F1One[R_?NumericQ,G_]:=NIntegrate[Log[(2*conOne[x,G]*Vfi + x*GIsl[x,G])/(2*Vfi*c0*Exp[-\[Phi]/T+\[Alpha]/(x*T)] + x)]*x, {x,0,R}];

ROne = 100.;
For[i=0,i < 51, i++,
g=10*GCritVal-i*GCritVal/5;
One = FindMaximum[F1One[x,g],{x,ROne},Method->"PrincipalAxis"];
ROne = x/.One[[2]][[1]];
ProbOne = One[[1]];
If[ROne>0,
PutAppend[ProbOne/10.^4, "ProbOneG"];
PutAppend[g,"gOneG"];
PutAppend[ROne/100.,"ROneG"];]
]
