from sys import argv

script, File_Source, File_Destination, File_Max_Prob = argv

FD = open(File_Destination, "rw+")
FMP = open(File_Max_Prob, "rw+")

with open(File_Source) as FS:
    for line in FS:
        MaxProb = -100.0
        j = 0

        numbers_str = line.split("\t")
        #		print numbers_str
        len_line = len(numbers_str)
        #		print len_line

        post_list = list()
        numbers_pre0 = float(numbers_str[0])

        for i in range(0, len_line):
            if i == 0:
                post_list.append(numbers_pre0)
            else:
                if numbers_str[i] == '':
                    post_list.append('')
                else:
                    numbers_pre = float(numbers_str[i])
                    post_list.append(numbers_pre / numbers_pre0)
                    if numbers_pre > MaxProb:
                        MaxProb = numbers_pre
                        j = i

        for item in post_list:
            FD.write("%s\t" % item)

        FD.write("\n")
        FMP.write("%s\t" % numbers_pre0)
        FMP.write("%s\t" % MaxProb)
        FMP.write("%s\n" % j)

FS.close()
FD.close()
FMP.close()
