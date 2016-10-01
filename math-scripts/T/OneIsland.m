#!/usr/local/bin/WolframScript -script

SetDirectory["/home/oleksa/Documents/Science/CircleNew/Dependable"];
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

aOne[R_,T_]:=-Vfi[T]*(Gg[R,T]-c0[T]*Exp[-\[Phi]/T+\[Alpha]/(R*T)])/(l[T]*BesselK[1,R/l[T]]+Vfi [T]*BesselK[0,R/l[T]]);
conOne[x_,R_,T_]:=Gg[x,T]+aOne[R,T]*BesselK[0,x/l[T]];

F1One[R_?NumericQ,T_]:=NIntegrate[Log[(2*conOne[x, x,T]*Vfi[T] + x*GIsl[x])/(2*Vfi[T]*c0[T]*Exp[-\[Phi]/T+\[Alpha]/(x*T)] + x)]*x, {x, 0,R}];
 
ROne =300;
T0=1.;
dT=0.1;
For[i=0,i < 101, i++,
g=T0-i*dT;
One = FindMaximum[F1One[x,g],{x,ROne},Method->"PrincipalAxis"];
ROne = x/.One[[2]][[1]];
ProbOne = One[[1]];
If[ROne>0,
PutAppend[ProbOne/10.^4, "ProbOneT"];
PutAppend[g,"gOneT"];
PutAppend[ROne/100,"ROneT"];]
]
