#!/usr/bin/bash

# Q1. How many requests failed?

cut -d ' ' access.log -f 4 | sort | uniq -c | grep FAIL | cut -d ' ' -f5

#> 100

# Q2. How many different pages were requested, and which?

pages=$(cut -d ' ' access.log -f 5 | sort | uniq | tr '\n' ' ') && echo "$(wc -w <<< "$pages")" "$pages" 

#> 4 /page0 /page1 /page2 /page3

# Q3. How many requests did each page get?

cut -d ' ' access.log -f 5 | sort | uniq -c

#> 125 /page0
#> 125 /page1
#> 125 /page2
#> 125 /page3

# Q4. Which user or users have the most failed requests, and how many?

cut -d ' ' access.log -f3,4 | sort | uniq -c | grep FAIL | sort -rn | head -n 2

#> 15 user5 FAIL
#> 15 user3 FAIL

# Q5. How many requests did user3 make, and how many of them failed?

cut -d ' ' access.log -f3,4 | sort | grep user3 | uniq -c

#> 15 user3 FAIL
#> 57 user3 OK

# Q6. Print the last 3 failed requests, showing only time and user.

cut -d ' ' access.log -f2,3,4 | grep FAIL | sort -r | head -n 3 | cut -d ' ' -f1,2

#> 10:55 user6
#> 10:55 user6
#> 10:55 user5

# Q7. Which login shells appear in /etc/passwd, and how many accounts use each? (field7, separator :)

cat /etc/passwd | cut -d ':' -f7 | sort | uniq -c | sort -rn

# Q8. PREDICT, then explain: why do ls /etc | wc -l and ls -l /etc | wc -l differ by exactly one?

# It differs by one because it prints one additional line on top to show additional information (number of kb used in the dir)
