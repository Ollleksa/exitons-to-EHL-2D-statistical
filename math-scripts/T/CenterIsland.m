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

Sum0[S_,T_,n_]:=Sum0[S,T,n]=n*BesselK[0,S/l[T]];
Sum1[S_,T_,n_]:=Sum1[S,T,n]=Sum[BesselK[0,2*S*Abs[Sin[Pi*i/n]]/l[T]],{i,n-1}];

A[R_,S_,T_,n_]:=l[T]*BesselK[1,R/l[T]]+Vfi[T] *(BesselK[0,R/l[T]]+Sum1[S,T,n]);
B[S_,T_]:=Vfi[T] *BesselK[0,S/l[T]];
Ll[S_,R_,T_]:=Vfi[T] *(Gg[S,T]-c0[T]*Exp[-\[Phi]/T+\[Alpha]/(R*T)]);
F[S_,T_,n_]:=Vfi[T] *Sum0[S,T,n];
M[R0_,T_]:=l[T]*BesselK[1,R0/l[T]]+Vfi[T] *BesselK[0,R0/l[T]]
J[R0_,T_]:=Vfi[T] *(Gg[R0,T]-c0[T]*Exp[-\[Phi]/T+\[Alpha]/(R0*T)]);

det[R_,R0_,S_,T_,n_]:=B[S,T]* F[S,T,n]-A[R,S,T,n]* M[R0,T];
aPlus[R_,R0_,S_,T_,n_]:=-(B[S,T]* J[R0,T]-Ll[S,R,T]* M[R0,T])/det[R,R0,S,T,n];
a0Plus[R_,R0_,S_,T_,n_]:=-(-A[R,S,T,n]*J[R0,T]+ F[S,T,n]*Ll[S,R,T])/det[R,R0,S,T,n];

aiPlus[Ri_,R_,R0_,S_,T_,n_]:=-Vfi[T]*(Gg[S,T]+aPlus[R,R0,S,T,n]*Sum1[S,T,n]+a0Plus[R,R0,S,T,n]*BesselK[0,S/l[T]]-c0[T]*Exp[-\[Phi]/T+\[Alpha]/(Ri*T)])/(l[T]*BesselK[1,Ri/l[T]]+Vfi[T]*BesselK[0,Ri/l[T]]);

conCirc[Ri_,R_,R0_,S_,T_,n_]:=Gg[S,T]+aiPlus[Ri,R,R0,S,T,n]*BesselK[0,Ri/l[T]]+aPlus[R,R0,S,T,n]*Sum1[S,T,n] +a0Plus[R,R0,S,T,n]*BesselK[0,S/l[T]];
conS0[R_,R0_,S_,T_,n_]:=Gg[R0,T]+aPlus[R,R0,S,T,n]*Sum0[S,T,n] +a0Plus[R,R0,S,T,n]*BesselK[0,R0/l[T]];

F1Plus[R_?NumericQ,R0_?NumericQ,S_?NumericQ,T_,n_]:=n*NIntegrate[Log[(2*conCirc[ x,R, R0,S,T,n]*Vfi[T]+ x*GIsl[S])/(2*Vfi[T]*c0[T]*Exp[-\[Phi]/T+\[Alpha]/(x*T)] + x)]*x, {x, 0,R}]+NIntegrate[Log[(2*conS0[R,x, S,T,n]*Vfi[T] + x*G)/(2*Vfi[T]*c0[T]*Exp[-\[Phi]/T+\[Alpha]/(x*T)] + x)]*x, {x, 0,R0}];

RCircle =100;
R0Circle = 100;
SCircle = 1000;
T0=1.;
dT=0.1;
For[i=0,i < 101, i++,
g=T0-i*dT;
Cirlce = FindMaximum[F1Plus[x,y,z,g,n],{{x,RCircle},{y,R0Circle},{z,SCircle}},Method->"PrincipalAxis"];
RCircle = x/.Cirlce[[2]][[1]];
R0Circle = y/.Cirlce[[2]][[2]];
SCircle = z/.Cirlce[[2]][[3]];
ProbCircle = Cirlce[[1]];
If[RCircle>0,
PutAppend[ProbCircle/10.^4, "Prob"<>ToString[n]<>"CenT"];
PutAppend[g,"g"<>ToString[n]<>"CenT"];
PutAppend[RCircle/100,"R"<>ToString[n]<>"CenT"];
PutAppend[R0Circle/100,"R0"<>ToString[n]<>"CenT"];
PutAppend[SCircle/100,"S"<>ToString[n]<>"CenT"]]
]
