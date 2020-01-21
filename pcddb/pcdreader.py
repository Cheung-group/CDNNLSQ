#!/usr/bin/env python
import sys

mylines = []
CDfile = sys.argv[1]
print(CDfile)
pre = CDfile.split('.')[0]
with open (CDfile, 'rt') as myfile:
    for myline in myfile:
        mylines.append(myline.rstrip('\n'))

ss=['alpha helix', '3-10 helix', 'pi helix', 'beta strand', 'beta bridge', 'bonded turn', 'bend', 'loop or irregular']

def is_number(s):
    try:
        float(s)
        return True
    except ValueError:
        return False

struct=dict()
for line in mylines:
    for sstr in ss:
        if sstr in line:
            struct[sstr] = line.split()[-1]
            if not is_number(struct[sstr]):
                exit()

helix=float(struct['3-10 helix'])+float(struct['alpha helix'])
strand=float(struct['beta strand'])
turn=float(struct['bonded turn'])+float(struct['bend'])
others=float(struct['beta bridge'])+float(struct['loop or irregular'])+float(struct['pi helix'])

for line in mylines:
    if 'Sequence' in line:
        line=line.strip().split()[1:]
        line="".join(line)
        length=len(line)

cddata=[]
i=99
while i < len(mylines):
    line=mylines[i].strip().split()
    if len(line) == 6 and is_number(line[0]):   # Data portion
        for wvlen in range(240,189,-1):
            if abs(float(line[0])-wvlen)<0.1:
                cddata.append(line[1])
    i=i+1


with open(pre+'.cd', 'w') as cdfilehandle:
    for listitem in cddata:
        cdfilehandle.write('%s\n' % listitem)

with open(pre+'.dssp', 'w') as dssp:
        dssp.write('helix %s\n' % helix)
        dssp.write('strand %s\n' % strand)
        dssp.write('turn %s\n' % turn)
        dssp.write('others %s\n' % others)
        dssp.write('length %d\n' % length)




