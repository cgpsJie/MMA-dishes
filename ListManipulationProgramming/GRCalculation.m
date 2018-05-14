(* ::Package:: *)

Christoffel[g_,x_]:=Module[{gu,n,PreChris,a,b,c,d,k},
n=Length@x;
gu=Inverse@g;
PreChris=Table[D[g[[c,k]],x[[b]]]+D[g[[b,k]],x[[c]]]-D[g[[b,c]],x[[k]]],{k,n},{b,n},{c,n}];
gu.PreChris/2//Simplify
]

R13[g_,x_]:=Module[{Ch,p1,p2,n,a,b,c,d,k},
n=Length@x;
Ch=Christoffel[g,x];
p1=Table[D[Ch[[a,d,b]],x[[c]]]-D[Ch[[a,c,b]],x[[d]]],{a,n},{b,n},{c,n},{d,n}];
p2=Ch.Ch;
p1+Transpose[p2,{1,3,4,2}]-Transpose[p2,{1,4,3,2}]//Simplify
]

R04[g_,x_]:=g.R13[g,x]//Simplify

R4[g_,x_]:=Module[{r04,gu,n},
gu=Inverse@g;
r04=R04[g,x];
n=Length@x;
Sum[gu[[i,a]]gu[[j,b]]gu[[k,c]]gu[[l,d]]r04[[i,j,k,l]]r04[[a,b,c,d]],{i,n},{j,n},{k,n},{l,n},{a,n},{b,n},{c,n},{d,n}]
]

RicciT[g_,x_]:=Module[{r13,n,a,b,c,d,k},
r13=R13[g,x];
n=Length@x;
Table[Sum[r13[[k,a,k,b]],{k,n}],{a,n},{b,n}]//Simplify
]

R2[g_,x_]:=Module[{ri,gu,n},
ri=RicciT[g,x];
gu=Inverse@g;
n=Length@x;
Sum[gu[[i,a]]gu[[j,b]]ri[[i,j]]ri[[a,b]],{i,n},{j,n},{a,n},{b,n}]//Simplify
]

RicciS[g_,x_]:=Module[{gu,riccit,n,a,b},
riccit=RicciT[g,x];
gu=Inverse@g;
n=Length@x;
Sum[gu[[a,b]]riccit[[a,b]],{a,n},{b,n}]//Simplify
]

EinsteinT[g_,x_]:=RicciT[g,x]-RicciS[g,x]g/2//Simplify
