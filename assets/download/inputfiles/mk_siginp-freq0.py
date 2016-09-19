#!/usr/bin/python 
from scipy.interpolate import UnivariateSpline

print ''
fin=open('Sig.out.brd','r') ; lines=fin.readlines() ; fin.close()
first_points=[]
omega=[]

deg=2 ; 
print '# Extrapolating with UnivariateSpline degree =',deg

# extract some points
for line in lines[:deg+3] :
    if line[0]=='#' : continue
    omega.append(float(line.split()[0]))
    first_points.append(map(float,line.split()[1:]))
print '# Using',len(first_points),' points'
first_points=zip(*first_points)

omeganew=[0.0]+omega
print '# new omega = ',omeganew

sigextrap=[]
for i in range(len(first_points)):
    extrapolator = UnivariateSpline(omega,first_points[i],k=deg)  # quadratic extrapolation 
    sigextrap.append(extrapolator( omeganew ))
sigextrap=zip(*sigextrap)

fout=open('Sig.out.brd.extrap','w')
fout2=open('sig.inp.f0','w')
for i in range(len(omeganew)) :
    prt2=[ format(s,'14.8') for s in sigextrap[i] ]
    prt1=[format(omeganew[i],'14.8f')]+prt2 ;
    print>>fout, ''.join(prt1)
    if i==0 : print>>fout2, ' '.join(prt2)
fout.close ; fout2.close()

print ''

