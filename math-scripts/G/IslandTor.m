#!/usr/local/bin/WolframScript -script

SetDirectory["/home/oleksa/Documents/Science/CircleNew/Dependable"];

T =4.;
\[Phi] =35;
\[Alpha] = 63;
tauEx = 9.5*10.^(-7);
ci = 10.^12;
\[Tau]=4*10.^(-7);
m =0.4;
\[CapitalOmega] =1.13*10^13;
\[CapitalTheta] = 1.518*10^11;
L = 2000;

reltau=\[Tau]ex/\[Tau];

l = Sqrt[300*\[Tau]ex/Sqrt[T]*ci];

Wfi[T_]:=Wfi[T] =N[Sqrt[\[CapitalTheta]*T/(2*Pi*m)]];
Vfi [T_,\[Tau]_,ci_]:= Vfi [T,\[Tau],ci]=Wfi[T]*\[Tau]*ci^0.5;
c0[T_,ci_]:= c0[T,ci] = m*\[CapitalOmega]*T/(2*Pi*ci); 

GCritVal=0.00033709449951758183;
Gcr= GCritVal/(1-BesselK[1,L/l]/(BesselI[1,L/l] BesselK[0,L/l]+BesselI[0,L/l] BesselK[1,L/l]));

a[G_,L_]:=a[G,L]= (G BesselI[1,L/l])/(BesselI[1,L/l] BesselK[0,L/l]+BesselI[0,L/l] BesselK[1,L/l]);
b[G_,L_]:=b[G,L]=-((G BesselK[1,L/l])/(BesselI[1,L/l] BesselK[0,L/l]+BesselI[0,L/l] BesselK[1,L/l]));
Gg[x_,G_,L_]:=Gg[x,G,L] = reltau*Piecewise[{{G+b[G,L]*BesselI[0,x/l],x<=L},{a[G,L]*BesselK[0,x/l],x>L}}];
GIsl[x_,G_,L_]:=GIsl[x,G,L] = Piecewise[{{G,x<=L},{0,x>L}}];

a0[r_,R_,G_,L_]:=-Vfi [T,\[Tau],ci]*(Gg[R+r/2,G,L]-c0[T,ci]*Exp[-\[Phi]/T+\[Alpha]/((R+r/2)*T)])/(l*BesselK[1,(R+r/2)/l]+Vfi [T,\[Tau],ci]*BesselK[0,(R+r/2)/l]);
conOut[x_,r_,R_,G_,L_]:=Gg[x,G,L]+a0[r,R,G,L]*BesselK[0,x/l];

b0[r_,R_,G_,L_]:=-Vfi [T,\[Tau],ci]*(Gg[R-r/2,G,L]-c0[T,ci]*Exp[-\[Phi]/T-\[Alpha]/((R-r/2)*T)])/(l*BesselI[1,(R-r/2)/l]+Vfi [T,\[Tau],ci]*BesselI[0,(R-r/2)/l]);
conIn[x_,r_,R_,G_,L_]:=Gg[x,G,L]+b0[r,R,G,L]*BesselI[0,x/l];

F1[r_?NumericQ,R_?NumericQ,G_,L_]:=NIntegrate[Log[((R+x/2)*conOut[(R+x/2), x,R,G,L]*Vfi[T, \[Tau], ci] +(R-x/2)*conIn[(R+x/2), x,R,G,L]*Vfi[T, \[Tau], ci] + x*R*GIsl[x,G,L])/((R+x/2)*Vfi[T, \[Tau], ci]*c0[T, ci]*Exp[-\[Phi]/T+\[Alpha]/((R+x/2)*T)] +(R-x/2)*Vfi[T, \[Tau], ci]*c0[T,ci]*Exp[-\[Phi]/T-\[Alpha]/((R-x/2)*T)]+x*R)]*R, {x, 0, r}];

For[i=0,i < 101, i++,
g=20*Gcr-i*Gcr/5;
Tor = NMaximize[{F1[x,y,g,L],x>0,y>0},{x,y}];
dRTor = x/.Tor[[2]][[1]];
RTor = y/.Tor[[2]][[2]];
ProbTor = Tor[[1]];
If[RTor>0,
PutAppend[ProbTor/10.^4, "ProbTorG"];
PutAppend[g,"gTorG"];
PutAppend[RTor/100.,"RTorG"];
PutAppend[dRTor/100.,"rTorG"]]
]
