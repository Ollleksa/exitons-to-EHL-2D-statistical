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

Sum0[S_,n_]:=Sum0[S,n]=n*BesselK[0,S/l];
Sum1[S_,n_]:=Sum1[S,n]=Sum[BesselK[0,2*S*Abs[Sin[Pi*i/n]]/l],{i,n-1}];

A[R_,S_,n_]:=l*BesselK[1,R/l]+Vfi*(BesselK[0,R/l]+Sum1[S,n]);
B[S_]:=Vfi *BesselK[0,S/l];
Ll[S_,R_,L_]:=Vfi*(Gg[S,L]-c0*Exp[-\[Phi]/T+\[Alpha]/(R*T)]);
F[S_,n_]:=Vfi*Sum0[S,n];
M[R0_]:=l*BesselK[1,R0/l]+Vfi *BesselK[0,R0/l]
J[R0_,L_]:=Vfi *(Gg[R0,L]-c0*Exp[-\[Phi]/T+\[Alpha]/(R0*T)]);

det[R_,R0_,S_,n_]:=B[S]* F[S,n]-A[R,S,n]* M[R0];
aPlus[R_,R0_,S_,L_,n_]:=-(B[S]* J[R0,L]-Ll[S,R,L]* M[R0])/det[R,R0,S,n];
a0Plus[R_,R0_,S_,L_,n_]:=-(-A[R,S,n]*J[R0,L]+ F[S,n]*Ll[S,R,L])/det[R,R0,S,n];

aiPlus[Ri_,R_,R0_,S_,L_,n_]:=-Vfi*(Gg[S,L]+aPlus[R,R0,S,L,n]*Sum1[S,n]+a0Plus[R,R0,S,L,n]*BesselK[0,S/l]-c0*Exp[-\[Phi]/T+\[Alpha]/(Ri*T)])/(l*BesselK[1,Ri/l]+Vfi*BesselK[0,Ri/l]);

conCirc[Ri_,R_,R0_,S_,L_,n_]:=Gg[S,L]+aiPlus[Ri,R,R0,S,L,n]*BesselK[0,Ri/l]+aPlus[R,R0,S,L,n]*Sum1[S,n] +a0Plus[R,R0,S,L,n]*BesselK[0,S/l];
conS0[R_,R0_,S_,L_,n_]:=Gg[R0,L]+aPlus[R,R0,S,L,n]*Sum0[S,n] +a0Plus[R,R0,S,L,n]*BesselK[0,R0/l];

F1Plus[R_?NumericQ,R0_?NumericQ,S_?NumericQ,L_,n_]:=n*NIntegrate[Log[(2*conCirc[ x,R, R0,S,L,n]*Vfi+ x*GIsl[S,L])/(2*Vfi*c0*Exp[-\[Phi]/T+\[Alpha]/(x*T)] + x)]*x, {x, 0,R}]+NIntegrate[Log[(2*conS0[R,x, S,L,n]*Vfi + x*G)/(2*Vfi*c0*Exp[-\[Phi]/T+\[Alpha]/(x*T)] + x)]*x, {x, 0,R0}];

RCircle =1000;
R0Circle = 1000;
SCircle = 10000;
T0=10000;
dT=100;
For[i=0,i < 101, i++,
g=T0-i*dT;
Cirlce = FindMaximum[F1Plus[x,y,z,g,n],{{x,RCircle},{y,R0Circle},{z,SCircle}},Method->"PrincipalAxis"];
RCircle = x/.Cirlce[[2]][[1]];
R0Circle = y/.Cirlce[[2]][[2]];
SCircle = z/.Cirlce[[2]][[3]];
ProbCircle = Cirlce[[1]];
If[RCircle>0,
PutAppend[ProbCircle/10.^4, "Prob"<>ToString[n]<>"CenL"];
PutAppend[g/100,"g"<>ToString[n]<>"CenL"];
PutAppend[RCircle/100,"R"<>ToString[n]<>"CenL"];
PutAppend[R0Circle/100,"R0"<>ToString[n]<>"CenL"];
PutAppend[SCircle/100,"S"<>ToString[n]<>"CenL"]]
]
