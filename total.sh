#!/bin/bash
CREATE_FILE=18501006_ksm.txt

result=()

echo > $CREATE_FILE 2>&1
echo "-------------------------------------------------------------" >> $CREATE_FILE 2>&1
echo "|================ 01.Default ID Check Start ================|" >> $CREATE_FILE 2>&1
echo "|                                                           |" >> $CREATE_FILE 2>&1
if [ `cat /etc/passwd | egrep "lp:|uucp:|nuucp:" | wc -l` -eq 0 ]
	then
        echo "|====================== RESULT : GOOD =====================|" >> $CREATE_FILE 2>&1
		echo "|                  lp, uucp, nuucp not found               |" >> $CREATE_FILE 2>&1
        result+=("[1].GOOD")
	else
        echo "|======================= RESULT : BAD ======================|" >> $CREATE_FILE 2>&1
        echo "|                Unnecessary Default ID Founded!            |" >> $CREATE_FILE 2>&1
        echo " " >> $CREATE_FILE 2>&1
		cat /etc/passwd | egrep "lp:|uucp:|nuucp:" >> $CREATE_FILE 2>&1
        echo " " >> $CREATE_FILE 2>&1
        result+=("[1].BAD")
fi
echo "|================= 01.Default ID Check END =================|" >> $CREATE_FILE 2>&1
echo "-------------------------------------------------------------" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

echo "*************************************************************" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1
echo "-------------------------------------------------------------" >> $CREATE_FILE 2>&1
echo "|================= 02.Root MGM Check Start =================|" >> $CREATE_FILE 2>&1
echo "|                                                           |" >> $CREATE_FILE 2>&1
if [ `awk -F: '$3==0' /etc/passwd | wc -l` -eq 1 ]
then
	echo "|======================= RESULT : GOOD =====================|" >> $CREATE_FILE 2>&1
    echo " " >> $CREATE_FILE 2>&1
	awk -F: '$3==0 { print $1 " -> UID= "$3 }' /etc/passwd >> $CREATE_FILE 2>&1
    echo " " >> $CREATE_FILE 2>&1
    result+=("[2].GOOD")
else 
	echo "|======================= RESULT : BAD ======================|" >> $CREATE_FILE 2>&1
    echo " " >> $CREATE_FILE 2>&1
	awk -F: '$3==0 { print $1 " -> UID= "$3 }' /etc/passwd >> $CREATE_FILE 2>&1
    echo " " >> $CREATE_FILE 2>&1
    result+=("[2].BAD")
fi
echo "|================== 02.Root MGM Check END ==================|" >> $CREATE_FILE 2>&1
echo "-------------------------------------------------------------" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

echo "*************************************************************" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1
echo "-------------------------------------------------------------" >> $CREATE_FILE 2>&1
echo "|========== 03.Passwd File Permission Check Start ==========|" >> $CREATE_FILE 2>&1
echo "|                                                           |" >> $CREATE_FILE 2>&1
if [ -f /etc/passwd ]
then
    if [ $(ls -alL "/etc/passwd" | awk '{print $1}' | grep '^-rw-r--r--' | wc -l) -eq 1 ]
        then
            echo "|======================= RESULT : GOOD =====================|" >> $CREATE_FILE 2>&1
            echo " " >> $CREATE_FILE 2>&1
            ls -alL /etc/passwd >> $CREATE_FILE 2>&1
            echo " " >> $CREATE_FILE 2>&1
            result+=("[3].GOOD")
        else
            echo "|======================= RESULT : BAD =====================|" >> $CREATE_FILE 2>&1
            echo " " >> $CREATE_FILE 2>&1
            ls -alL /etc/passwd >> $CREATE_FILE 2>&1
            echo " " >> $CREATE_FILE 2>&1
            result+=("[3].BAD")
    fi
else
    echo "passwd file not found" >> $CREATE_FILE 2>&1
fi
echo "|=========== 03.Passwd File Permission Check END ===========|" >> $CREATE_FILE 2>&1
echo "-------------------------------------------------------------" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1


echo "*************************************************************" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1
echo "-------------------------------------------------------------" >> $CREATE_FILE 2>&1
echo "|========== 04.Group File Permission Check Start ===========|" >> $CREATE_FILE 2>&1
echo "|                                                           |" >> $CREATE_FILE 2>&1
if [ -f /etc/group ]
then
    if [ $(ls -alL "/etc/group" | awk '{print $1}' | grep '^-rw-r--r--' | wc -l) -eq 1 ]
        then
            echo "|======================= RESULT : GOOD =====================|" >> $CREATE_FILE 2>&1
            echo " " >> $CREATE_FILE 2>&1
            ls -alL /etc/group >> $CREATE_FILE 2>&1
            echo " " >> $CREATE_FILE 2>&1
            result+=("[4].GOOD")
        else
            echo "|======================= RESULT : BAD ======================|" >> $CREATE_FILE 2>&1
            echo " " >> $CREATE_FILE 2>&1
            ls -alL /etc/group >> $CREATE_FILE 2>&1
            echo " " >> $CREATE_FILE 2>&1
            result+=("[4].BAD")
    fi
else
    echo "Group file not found" >> $CREATE_FILE 2>&1
fi
echo "|=========== 04.Group File Permission Check END ============|" >> $CREATE_FILE 2>&1
echo "-------------------------------------------------------------" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1


echo "*************************************************************" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1
echo "-------------------------------------------------------------" >> $CREATE_FILE 2>&1
echo "|=============== 05.Passwd Rule Check Start ================|" >> $CREATE_FILE 2>&1
echo "|                                                           |" >> $CREATE_FILE 2>&1
if [ -f /etc/login.defs ]
then
    grep -v '#' /etc/login.defs | grep -i "PASS_MIN_LEN" >> $CREATE_FILE 2>&1
    grep -v '#' /etc/login.defs | grep -i "PASS_MAX_DAYS" >> $CREATE_FILE 2>&1
    grep -v '#' /etc/login.defs | grep -i "PASS_MIN_DAYS" >> $CREATE_FILE 2>&1
else
    echo "/etc/login.defs file not found" >> $CREATE_FILE 2>&1

fi

if [ `cat /etc/login.defs | grep -i "PASS_MIN_LEN" | grep -v "#" | awk '{print $2}'` -gt 7 ]
then
    echo "PASS_MIN_LEN : GOOD" >> password.txt 2>&1
else
    echo "PASS_MIN_LEN : BAD" >> password.txt 2>&1
fi

if [ `cat /etc/login.defs | grep -i "PASS_MAX_DAYS" | grep -v "#" | awk '{print $2}'` -gt 70 ]
then
    echo "PASS_MAX_DAY : GOOD" >> password.txt 2>&1
else
    echo "PASS_MAX_DAY : BAD" >> password.txt 2>&1
fi

if [ `cat /etc/login.defs | grep -i "PASS_MIN_DAYS" | grep -v "#" | awk '{print $2}'` -gt 0 ]
then
    echo "PASS_MAX_DAY : GOOD" >> password.txt 2>&1
else
    echo "PASS_MAX_DAY : BAD" >> password.txt 2>&1
fi
if [ `cat password.txt | grep -i "BAD" | wc -l` -eq 0 ]
then 
    echo "|======================= RESULT : GOOD =====================|" >> $CREATE_FILE 2>&1
    echo " " >> $CREATE_FILE 2>&1
    cat password.txt >> $CREATE_FILE 2>&1
    echo " " >> $CREATE_FILE 2>&1
    result+=("[5].GOOD")
else
    echo "|======================== RESULT : BAD =====================|" >> $CREATE_FILE 2>&1
    echo " " >> $CREATE_FILE 2>&1
    cat password.txt >> $CREATE_FILE 2>&1
    echo " " >> $CREATE_FILE 2>&1
    result+=("[5].BAD")
fi
rm -rf password.txt

echo "|================ 05.Passwd Rule Check END =================|" >> $CREATE_FILE 2>&1
echo "-------------------------------------------------------------" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1


echo "*************************************************************" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1
echo "-------------------------------------------------------------" >> $CREATE_FILE 2>&1
echo "|================== 06.Shell Check Start ===================|" >> $CREATE_FILE 2>&1
echo "|                                                           |" >> $CREATE_FILE 2>&1
if [ -f /etc/passwd ]
then
    cat /etc/passwd | egrep "^daemon|^bin|^sys|^adm|^listen|^nobody|^nobody4|^noaccess|^diag|^operator|^games|^gopher" | grep -v "admin" >> $CREATE_FILE 2>&1
else
    echo "/etc/passwd file not found" >> $CREATE_FILE 2>&1
fi

echo " " >> $CREATE_FILE 2>&1
if [ `cat /etc/passwd | egrep "^daemon|^bin|^sys|^adm|^listen|^nobody|^nobody4|^noaccess|^diag|^operator|^games|^gopher" | grep -v "admin" | egrep -v "false|nologin" | wc -l` -eq 0 ]
then
    echo "|======================= RESULT : GOOD =====================|" >> $CREATE_FILE 2>&1
    echo " " >> $CREATE_FILE 2>&1
    result+=("[6].GOOD")
else
    echo "|======================== RESULT : BAD =====================|" >> $CREATE_FILE 2>&1
    echo " " >> $CREATE_FILE 2>&1
    result+=("[6].BAD")
fi
echo "|=================== 06.Shell Check END ====================|" >> $CREATE_FILE 2>&1
echo "-------------------------------------------------------------" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1


echo "*************************************************************" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1
echo "-------------------------------------------------------------" >> $CREATE_FILE 2>&1
echo "|============== 07.SU Permission Check Start ===============|" >> $CREATE_FILE 2>&1
echo "|                                                           |" >> $CREATE_FILE 2>&1

echo "|================== /etc/pam.d/su Check ====================|" >> $CREATE_FILE 2>&1
if [ `cat /etc/pam.d/su | grep 'pam_wheel.so' | grep -v 'trust' | grep 'use_uid' | grep -v '^#' | wc -l` -eq 0 ]
then
    echo "|======================= RESULT : BAD ======================|" >> $CREATE_FILE 2>&1
    cat /etc/pam.d/su | grep 'pam_wheel.so' | grep -v 'trust' | grep 'use_uid' >> $CREATE_FILE 2>&1
    echo " " >> $CREATE_FILE 2>&1
    result+=("[7-1].BAD")
else
    echo "|======================= RESULT : GOOD =====================|" >> $CREATE_FILE 2>&1
    cat /etc/pam.d/su | grep 'pam_wheel.so' | grep -v 'trust' | grep 'use_uid' >> $CREATE_FILE 2>&1
    echo " " >> $CREATE_FILE 2>&1
    result+=("[7-1].GOOD")
fi
echo "|==================== /etc/group Check =====================|" >> $CREATE_FILE 2>&1
if [ `cat /etc/group | grep "wheel" | awk --field-separator=":" '{print $4}' | egrep '.' | wc -l` -eq 0 ]
then
    echo "|======================= RESULT : GOOD =====================|" >> $CREATE_FILE 2>&1
    cat /etc/group | grep "wheel" | awk --field-separator=":" '{print $4}' >> $CREATE_FILE 2>&1
    echo " " >> $CREATE_FILE 2>&1
    result+=("[7-2].GOOD")
else
    echo "|======================= RESULT : BAD ======================|" >> $CREATE_FILE 2>&1
    cat /etc/group | grep "wheel" | awk --field-separator=":" '{print $4}' >> $CREATE_FILE 2>&1
    echo " " >> $CREATE_FILE 2>&1
    result+=("[7-2].BAD")
fi
echo "|=============== 07.SU Permission Check END ================|" >> $CREATE_FILE 2>&1
echo "-------------------------------------------------------------" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

echo "*************************************************************" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1
echo "-------------------------------------------------------------" >> $CREATE_FILE 2>&1
echo "|========= 08./etc/shadow Permission Check Start ===========|" >> $CREATE_FILE 2>&1
echo "|                                                           |" >> $CREATE_FILE 2>&1

if [ -f /etc/shadow ]
then 
    ls -alL /etc/shadow >> $CREATE_FILE 2>&1
else
    echo "/etc/shadow file not found" >> $CREATE_FILE 2>&1
fi

echo " " >> $CREATE_FILE 2>&1
if [ `ls -alL /etc/shadow | awk '{print $1}' | grep "..--------" | wc -l` -eq 1 ]
then
    echo "|======================= RESULT : GOOD =====================|" >> $CREATE_FILE 2>&1
    echo " " >> $CREATE_FILE 2>&1
    result+=("[8].GOOD")
else
    echo "|======================= RESULT : BAD ======================|" >> $CREATE_FILE 2>&1
    echo " " >> $CREATE_FILE 2>&1
    result+=("[8].BAD")
fi
echo "|========== 08./etc/shadow Permission Check END ============|" >> $CREATE_FILE 2>&1
echo "-------------------------------------------------------------" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

cat ./$CREATE_FILE
for i in "${result[@]}"
do
    echo $i
done