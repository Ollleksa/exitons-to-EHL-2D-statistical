from sys import argv

script, File_Index, File_Max_Prob, File_Destination = argv

FI = open(File_Index)
FD = open(File_Destination, "rw+")

Local_String_Index = FI.read().splitlines()
Global_String_Index = (
'One', '2Ma', '3Ma', '4Ma', '5Ma', '6Ma', '7Ma', '8Ma', '9Ma', '10M', 'Tor', '2Ce', '3Ce', '4Ce', '5Ce', '6Ce', '7Ce', '8Ce', '9Ce', '10C')

Local_Index = len(Local_String_Index)
All_Index = len(Global_String_Index)

with open(File_Max_Prob) as FMP:
    for line in FMP:
        Global_Index = 0
        numbers_str = line.split()
        num_index = int(numbers_str[2])

        for k in range(0, Local_Index):
            if k == int(num_index - 1):
                string_index = Local_String_Index[k]
                print string_index

        for i in range(0, All_Index):
            if Global_String_Index[i] == string_index:
                Global_Index = int(i + 1)

        for j in range(0, 2):
            FD.write("%s\t" % numbers_str[j])

        FD.write("%s\t" % Global_Index)
        FD.write("%s\n" % string_index)

FI.close()
FD.close()
FMP.close()
