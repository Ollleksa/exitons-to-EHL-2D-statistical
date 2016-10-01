#!/usr/local/bin/WolframScript -script
num  = ToExpression[$ScriptCommandLine[[2]]];

SetDirectory["/home/oleksa/Documents/Science/CircleNew/Dependable"];

n=num;

T =3.;
\[Phi] =35;
\[Alpha] = 63;
\[Tau]ex = 9.5*10.^(-7);
ci = 10.^12;
\[Tau]=4*10.^(-7);
m =0.4;
\[CapitalOmega] =1.13*10^13;
\[CapitalTheta] = 1.518*10^11;

L=2000;
l = Sqrt[300*\[Tau]ex/Sqrt[T]*ci];
reltau =\[Tau]ex/\[Tau];

GCritVal=0.0016569305134914944;

a[G_]:=a[G]= (G BesselI[1,L/l])/(BesselI[1,L/l] BesselK[0,L/l]+BesselI[0,L/l] BesselK[1,L/l]);
b[G_]:=b[G]=-((G BesselK[1,L/l])/(BesselI[1,L/l] BesselK[0,L/l]+BesselI[0,L/l] BesselK[1,L/l]));
Gg[x_,G_]:=Gg[x,G] = reltau*Piecewise[{{G+b[G]*BesselI[0,x/l],x<=L},{a[G]*BesselK[0,x/l],x>L}}];
GIsl[x_,G_]:=GIsl[x,G] = Piecewise[{{G,x<=L},{0,x>L}}];

Wfi=N[Sqrt[\[CapitalTheta]*T/(2*Pi*m)]];
Vfi =Wfi*\[Tau]*ci^0.5;
c0 = m*\[CapitalOmega]*T/(2*Pi*ci); 

Sum0[S_,n_]:=Sum0[S,n]=n*BesselK[0,S/l];
Sum1[S_,n_]:=Sum1[S,n]=Sum[BesselK[0,2*S*Abs[Sin[Pi*i/n]]/l],{i,n-1}];

A[R_,S_,n_]:=l*BesselK[1,R/l]+Vfi *(BesselK[0,R/l]+Sum1[S,n]);
B[S_]:=Vfi *BesselK[0,S/l];
Ll[S_,R_,G_]:=Vfi *(Gg[S,G]-c0*Exp[-\[Phi]/T+\[Alpha]/(R*T)]);
F[S_,n_]:=Vfi *Sum0[S,n];
M[R0_]:=l*BesselK[1,R0/l]+Vfi *BesselK[0,R0/l]
J[R0_,G_]:=Vfi *(Gg[R0,G]-c0*Exp[-\[Phi]/T+\[Alpha]/(R0*T)]);

det[R_,R0_,S_,n_]:=B[S]* F[S,n]-A[R,S,n]* M[R0];
aPlus[R_,R0_,S_,G_,n_]:=-(B[S]* J[R0,G]-Ll[S,R,G]* M[R0])/det[R,R0,S,n];
a0Plus[R_,R0_,S_,G_,n_]:=-(-A[R,S,n]*J[R0,G]+ F[S,n]*Ll[S,R,G])/det[R,R0,S,n];

aiPlus[Ri_,R_,R0_,S_,G_,n_]:=-Vfi*(Gg[S,G]+aPlus[R,R0,S,G,n]*Sum1[S,n]+a0Plus[R,R0,S,G,n]*BesselK[0,S/l]-c0*Exp[-\[Phi]/T+\[Alpha]/(Ri*T)])/(l*BesselK[1,Ri/l]+Vfi*BesselK[0,Ri/l]);

conCirc[Ri_,R_,R0_,S_,G_,n_]:=Gg[S,G]+aiPlus[Ri,R,R0,S,G,n]*BesselK[0,Ri/l]+aPlus[R,R0,S,G,n]*Sum1[S,n] +a0Plus[R,R0,S,G,n]*BesselK[0,S/l];
conS0[R_,R0_,S_,G_,n_]:=Gg[R0,G]+aPlus[R,R0,S,G,n]*Sum0[S,n] +a0Plus[R,R0,S,G,n]*BesselK[0,R0/l];

F1Plus[R_?NumericQ,R0_?NumericQ,S_?NumericQ,G_,n_]:=n*NIntegrate[Log[(2*conCirc[x,R, R0,S,G,n]*Vfi+ x*GIsl[S,G])/(2*Vfi*c0*Exp[-\[Phi]/T+\[Alpha]/(x*T)] + x)]*x, {x, 0,R}]+NIntegrate[Log[(2*conS0[R,x, S,G,n]*Vfi + x*G)/(2*Vfi*c0*Exp[-\[Phi]/T+\[Alpha]/(x*T)] + x)]*x, {x, 0,R0}];

RCircle =200;
R0Circle = 200;
SCircle = 1000;
For[i=0,i < 51, i++,
g=10GCritVal-i*GCritVal/5;
Cirlce = FindMaximum[F1Plus[x,y,z,g,n],{{x,RCircle},{y,R0Circle},{z,SCircle}},Method->"PrincipalAxis"];
RCircle = x/.Cirlce[[2]][[1]];
R0Circle = y/.Cirlce[[2]][[2]];
SCircle = z/.Cirlce[[2]][[3]];
ProbCircle = Cirlce[[1]];
If[RCircle>0,
PutAppend[ProbCircle/10.^4, "Prob"<>ToString[n]<>"CenG"];
PutAppend[g,"g"<>ToString[n]<>"CenG"];
PutAppend[RCircle/100,"R"<>ToString[n]<>"CenG"];
PutAppend[R0Circle/100,"R0"<>ToString[n]<>"CenG"];
PutAppend[SCircle/100,"S"<>ToString[n]<>"CenG"]]
]
