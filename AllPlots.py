#!/usr/bin/python
from sys import argv

script, Data_File, index, Plot_Destination = argv

import matplotlib.pyplot as plt

DF = open(Data_File)

Generation = list()
Probability = list()
Radii= list()
Radii0 = list()
S_lenght = list()

Directory = str(Plot_Destination)

Data_File_Str = str(Data_File)[:-4]
Index_Divided = Data_File_Str.split("/")
String_Index = str(Index_Divided[-1])[:3]

if int(index) == 1:
    for line in DF:
        Split_Line = line.split()
        Generation.append(float(Split_Line[0]))
        Probability.append(float(Split_Line[1]))
        Radii.append(float(Split_Line[2]))

    fig = plt.figure()
    graph = fig.add_subplot(1, 1, 1)
    graph.plot(Generation, Probability)
    plt.xlabel('Generation Rate')
    plt.ylabel('Probability')
    plt.savefig(Directory+'Prob'+String_Index, dpi=150)

    fig = plt.figure()
    graph = fig.add_subplot(1, 1, 1)
    graph.plot(Generation, Radii)
    plt.xlabel('Generation Rate')
    plt.ylabel('Radii')
    plt.savefig(Directory+'R'+String_Index, dpi=150)

elif int(index) == 2:
    for line in DF:
         Split_Line = line.split()
         Generation.append(float(Split_Line[0]))
         Probability.append(float(Split_Line[1]))
         Radii.append(float(Split_Line[2]))
         S_lenght.append(float(Split_Line[3]))

    fig = plt.figure()
    graph = fig.add_subplot(1, 1, 1)
    graph.plot(Generation, Probability)
    plt.xlabel('Generation Rate')
    plt.ylabel('Probability')
    plt.savefig(Directory+'Prob'+String_Index, dpi=150)

    fig = plt.figure()
    graph = fig.add_subplot(1, 1, 1)
    graph.plot(Generation, Radii)
    plt.xlabel('Generation Rate')
    plt.ylabel('Radii')
    plt.savefig(Directory+'R'+String_Index, dpi=150)

    fig = plt.figure()
    graph = fig.add_subplot(1, 1, 1)
    graph.plot(Generation, S_lenght)
    plt.xlabel('Generation Rate')
    plt.ylabel('Lenght')
    plt.savefig(Directory+'S'+String_Index, dpi=150)

else:
    for line in DF:
         Split_Line = line.split()
         Generation.append(float(Split_Line[0]))
         Probability.append(float(Split_Line[1]))
         Radii.append(float(Split_Line[2]))
         Radii0.append(float(Split_Line[3]))
         S_lenght.append(float(Split_Line[4]))

    fig = plt.figure()
    graph = fig.add_subplot(1, 1, 1)
    graph.plot(Generation, Probability)
    plt.xlabel('Generation Rate')
    plt.ylabel('Probability')
    plt.savefig(Directory+'Prob'+String_Index, dpi=150)

    fig = plt.figure()
    graph = fig.add_subplot(1, 1, 1)
    graph.plot(Generation, Radii)
    plt.xlabel('Generation Rate')
    plt.ylabel('Radii')
    plt.savefig(Directory+'R'+String_Index, dpi=150)

    fig = plt.figure()
    graph = fig.add_subplot(1, 1, 1)
    graph.plot(Generation, S_lenght)
    plt.xlabel('Generation Rate')
    plt.ylabel('Lenght')
    plt.savefig(Directory+'S'+String_Index, dpi=150)

    fig = plt.figure()
    graph = fig.add_subplot(1, 1, 1)
    graph.plot(Generation, Radii0)
    plt.xlabel('Generation Rate')
    plt.ylabel('Radii of central island')
    plt.savefig(Directory+'R0'+String_Index, dpi=150)