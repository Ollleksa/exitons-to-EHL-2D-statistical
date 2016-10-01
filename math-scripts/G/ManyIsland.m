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

Wfi =N[Sqrt[\[CapitalTheta]*T/(2*Pi*m)]];
Vfi =Wfi*\[Tau]*ci^0.5;
c0 = m*\[CapitalOmega]*T/(2*Pi*ci); 

GCritVal=0.0016569305134914944;

a[G_]:=a[G]= (G BesselI[1,L/l])/(BesselI[1,L/l] BesselK[0,L/l]+BesselI[0,L/l] BesselK[1,L/l]);
b[G_]:=b[G]=-((G BesselK[1,L/l])/(BesselI[1,L/l] BesselK[0,L/l]+BesselI[0,L/l] BesselK[1,L/l]));
Gg[x_,G_]:=Gg[x,G] = reltau*Piecewise[{{G+b[G]*BesselI[0,x/l],x<=L},{a[G]*BesselK[0,x/l],x>L}}];
GIsl[x_,G_]:=GIsl[x,G]=Piecewise[{{G,x<=L},{0,x>L}}];

SumSec[S_,n_]:=SumSec[S,n]=Sum[BesselK[0,2*S*Abs[Sin[Pi*i/n]]/l],{i,n-1}];

aSec[R_,S_,G_,n_]:=-Vfi*(Gg[S,G]-c0*Exp[-\[Phi]/T+\[Alpha]/(R*T)])/(l*BesselK[1,R/l]+Vfi*(BesselK[0,R/l]+SumSec[S,n]));

aiSec[Ri_,R_,S_,G_,n_]:=-Vfi*(Gg[S,G]+aSec[R,S,G,n]*SumSec[S,n]-c0*Exp[-\[Phi]/T+\[Alpha]/(Ri*T)])/(l*BesselK[1,Ri/l]+Vfi*BesselK[0,Ri/l]);

conSec[Ri_,R_,S_,G_,n_]:=Gg[S,G]+aiSec[Ri,R,S,G,n]*BesselK[0,Ri/l]+aSec[R,S,G,n]*SumSec[S,n];

F1Sec[R_?NumericQ,S_?NumericQ,G_,n_]:=n*NIntegrate[Log[(2*conSec[x, R, S,G,n]*Vfi + x*GIsl[S,G])/(2*Vfi*c0*Exp[-\[Phi]/T+\[Alpha]/(x*T)] + x)]*x, {x,0,R}];

Rmany =500.;
Smany =2000.;
For[i=0,i < 51, i++,
g=10*GCritVal-i*GCritVal/5;
Many = FindMaximum[F1Sec[x,y,g,n],{{x,Rmany},{y,Smany}},Method->"PrincipalAxis"];
Rmany = x/.Many[[2]][[1]];
Smany = y/.Many[[2]][[2]];
ProbMany = Many[[1]];
If[Rmany>0,
PutAppend[ProbMany/10.^4, "Prob"<>ToString[n]<>"ManG"];
PutAppend[g,"g"<>ToString[n]<>"ManG"];
PutAppend[Rmany/100.,"R"<>ToString[n]<>"ManG"];
PutAppend[Smany/100.,"S"<>ToString[n]<>"ManG"]]
]
