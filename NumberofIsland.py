#!/usr/bin/python
from sys import argv

script, Data_File, Graph_Name = argv

import matplotlib.pyplot as plt

DF = open(Data_File)

G_One = list()
Num_One = list()
G_Man = list()
Num_Man = list()
G_Cen = list()
Num_Cen = list()

for line in DF:
    Split_Line = line.split()
    Generation_Rate = float(Split_Line[0])
    Index_Num = int(Split_Line[2])

    if Index_Num == 1:
        G_One.append(Generation_Rate)
        Num_One.append(Index_Num)
    else:
        if Index_Num < 11:
            G_Man.append(Generation_Rate)
            Num_Man.append(Index_Num)
        else:
            G_Cen.append(Generation_Rate)
            Num_Cen.append(Index_Num - 9)

fig = plt.figure()
graph = fig.add_subplot(1, 1, 1)
graph.plot(G_One, Num_One, 'ro')
graph.plot(G_Man, Num_Man, 'bo')
graph.plot(G_Cen, Num_Cen, 'go')

(y1, y2) =graph.get_ylim()
graph.set_ylim(0, y2 + 1)

plt.xlabel('Generation Rate')
plt.ylabel('Number of Islands')

plt.savefig(Graph_Name, dpi=150)