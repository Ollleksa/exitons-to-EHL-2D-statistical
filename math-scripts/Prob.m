#!/usr/local/bin/WolframScript -script

SetDirectory["/home/oleksa/Documents/Science/Circle/Dependable"];

T =2.;
\[Phi] =34.8;
\[Alpha] = 34.8;
tauEx = 9.5*10.^(-7);
ci = 10.^12;
\[Tau]=4*10.^(-7);
m =0.4;
\[CapitalOmega] =1.13*10^13;
\[CapitalTheta] = 1.518*10^11;

l = Sqrt[300*tauEx/Sqrt[T]*ci];
reltau =tauEx/\[Tau];

Wfi[T_]:=Wfi[T] =N[Sqrt[\[CapitalTheta]*T/(2*Pi*m)]];

Vfi [T_,\[Tau]_,ci_]:= Vfi [T,\[Tau],ci]=Wfi[T]*\[Tau]*ci^0.5;
c0[T_,ci_]:= c0[T,ci] = m*\[CapitalOmega]*T/(2*Pi*ci); 

L=1000.;
GCritVal=7.49268437784501`*^-6;
Gcr= GCritVal/(1-BesselK[1,L/l]/(BesselI[1,L/l] BesselK[0,L/l]+BesselI[0,L/l] BesselK[1,L/l]));

a[G_,L_]:=a[G,L]= (G BesselI[1,L/l])/(BesselI[1,L/l] BesselK[0,L/l]+BesselI[0,L/l] BesselK[1,L/l]);
b[G_,L_]:=b[G,L]=-((G BesselK[1,L/l])/(BesselI[1,L/l] BesselK[0,L/l]+BesselI[0,L/l] BesselK[1,L/l]));
Gg[x_,G_,L_]:=Gg[x,G,L] = reltau* Piecewise[{{G+b[G,L]*BesselI[0,x/l],x<=L},{a[G,L]*BesselK[0,x/l],x>L}}];
GIsl[x_,G_,L_]:=GIsl[x,G,L]=Piecewise[{{G,x<=L},{0,x>L}}];

aOne[R_,G_,L_]:=-Vfi [T,\[Tau],ci]*(Gg[R,G,L]-c0[T,ci]*Exp[-\[Phi]/T+\[Alpha]/(R*T)])/(l*BesselK[1,R/l]+Vfi[T,\[Tau],ci]*BesselK[0,R/l]);
conOne[x_,R_,G_,L_]:=Gg[x,G,L]+aOne[R,G,L]*BesselK[0,x/l];

F1One[R_?NumericQ,G_,L_]:=NIntegrate[Log[(2*conOne[x, x,G,L]*Vfi[T, \[Tau], ci] + x*GIsl[x,G,L])/(2*Vfi[T, \[Tau], ci]*c0[T, ci]*Exp[-\[Phi]/T+\[Alpha]/(x*T)] + x)]*x, {x,0,R}];

FindMaximum[F1One[x,100*Gcr,L],{x,100},Method->"PrincipalAxis"]
Print[FindMaximum[F1One[x,100*Gcr,L],{x,100},Method->"PrincipalAxis"]];
