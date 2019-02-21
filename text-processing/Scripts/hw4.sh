DATA="/group/staclassgrp/transaction.zip"

# 1.1
unzip -p ${DATA} |
    head --lines=1 | 
    tr "," "\n" |
    nl |
    tail -n 3 > last_columns.txt

# 1.2
unzip -p ${DATA} | 
    wc --max-line-length | 
    cat > maxchars.txt

# 1.3
unzip -p ${DATA} |
    grep --ignore-case 'bicycle' |
    cat > bicycle.csv

wc --lines bicycle.csv

# 1.4
FUNDING_AGENCY_ID=18

unzip -p ${DATA} |
    cut --delimiter=',' --fields=${FUNDING_AGENCY_ID} |
    cat | 
    sort | 
    uniq |
    cat > funding_agency_set.txt

wc --words funding_agency_set.txt # note: includes header

# 1.5
TOTAL_OBLIGATION=8
TRANSACTION_DESCRIPTION=25

unzip -p ${DATA} |
    cut --delimiter=',' --fields=${TOTAL_OBLIGATION},${TRANSACTION_DESCRIPTION} |
    sort --reverse --numeric-sort --key=1,1 --field_seperator=',' | 
    uniq | 
    head --lines=30 > largest.csv

head -n 5 largest.csv

# 2.4
POP_ZIP5=32
unzip -p ${DATA} |
    cut --delimiter=',' --fields={POP_ZIP5} |
    cat |
    sort |
    uniq |
    cat > zip_set.txt

wc --words zip_set.txt # note: includes 2 headers