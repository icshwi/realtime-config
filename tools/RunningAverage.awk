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



BEGIN {
    FS = "," 
    count = 0
    mean0 = 0
    sd0   = 0
    sample_deviation = 0
    standard_deviation = 0
}

{
    x       = $3
    count  += 1
    indexI1 = x
    mean1   = mean0 +1/count * ( x - mean0 )
    sd1     = sd0 + ( x - mean0 )*( x - mean1 )
    mean0   = mean1
    sd0     = sd1

    if (count !=0 && sd0 != 0) {
    sample_deviation   = sqrt(1/(count-1)*sd0)
    standard_deviation = sqrt(1/count*sd0)
    }
    mean_user = (mean0_user + mean0)*0.5
    SD_user   = sqrt(((sample_deviation_user)^2)+((sample_deviation)^2))

    printf "Count/x/Mean/SaD/STD : %8d %12.2lf %12.2lf %12.2lf %12.2lf \n", count, x, mean0, sample_deviation,  standard_deviation;
 
}

END {
    printf "-----------------------------------------------"
    printf "\nLatenency Max\n"
    printf "\n"
    printf "Total count        : %16d\n",    count
    printf "Mean               : %16.4lf\n", mean0
    printf "Sample Deviation   : %16.4lf\n", sample_deviation
    printf "Standard Deviation : %16.4lf\n", standard_deviation
    printf "\n"

}
