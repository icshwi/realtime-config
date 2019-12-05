# License : http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en
# Author:   Jeong Han Lee
# email :   jeonghan 'dot' lee 'at' gmail 'dot' com
# Date:     Thursday, August 19 10:39:49 EDT 2010
# Version:  0.0.1
#
#          This script can calculate a running mean, a sample deviation
#          , and a standard deviation from xterm output.
#
# History:
# 0.0.1     Thursday, August 19 10:41:44 EDT 2010  
#          
#


# How to use.....
# $4 is what interests me.
# For example,
# ps aux | grep jhlee | awk '{print $2} '
# 20488
# 20490
# 20528
# 20544
# 20674
# 20805
# 20806
# 20807
# 23841

# then $4 is replaced by $2, then
# ps aux | grep jhlee | awk -f average.awk
# Total count        : 52
# mean               : 10966.7
# Sample Deviation   : 8159.65
# Standard Deviation : 8080.81

# Tuesday, August 17 11:17:02 EDT 2010, jhlee
#awk ' {print "  CPU " $2 " "$3 " " $4 " " $5 " " $6 " s per event)" }'


BEGIN {
    count_sys = 0
    mean0_sys = 0
    sd0_sys   = 0
    sample_deviation_sys = 0
    standard_deviation_sys = 0
}

{
    x = $4
    count_sys += 1
    #    totalsize += x
    indexI1_sys = x
    mean1_sys   = mean0_sys +1/count_sys * ( x - mean0_sys )
    sd1_sys     = sd0_sys + ( x - mean0_sys )*( x - mean1_sys )
    mean0_sys   = mean1_sys
    sd0_sys     = sd1_sys
    if (count_sys !=0 && sd0_sys != 0) {
    sample_deviation_sys   = sqrt(1/(count_sys-1)*sd0_sys)
    standard_deviation_sys = sqrt(1/count_sys*sd0_sys)
    }
    mean_user_sys = (mean0_user + mean0_sys)*0.5
    SD_user_sys = sqrt(((sample_deviation_user)^2)+((sample_deviation_sys)^2))

    printf "Count/x/Mean/SaD/STD : %8d %12.2lf %12.2lf %12.2lf %12.2lf \n", count_sys, x, mean0_sys, sample_deviation_sys,  standard_deviation_sys;
 
}

END {
    printf "-----------------------------------------------"
    printf "\n<sys>\n"
    printf "\n"
    printf "Total count        : %10d\n", count_sys
    #   print "average size = " totalsize/count_sys
    printf "Mean               : %8.8lf\n", mean0_sys
    printf "Sample Deviation   : %8.8lf\n", sample_deviation_sys
    printf "Standard Deviation : %8.8lf\n", standard_deviation_sys
    printf "\n"

}
