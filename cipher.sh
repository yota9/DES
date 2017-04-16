#!/bin/bash

wordlength=8     #length of m and k
mword="NOTEBOOK" #Text
kword="FRIZZLER" #Key

RAUNDS=1

PC1=(57 49 41 33 25 17 9 1 58 50 42 34 26 18 10 2 59 51 43 35 27 19 11 3 60 52 44 36 63 55 47 39 31 23 15 7 62 54 46 38 30 22 14 6 61 53 45 37 29 21 13 5 28 20 12 4)

PC2=(14 17 11 24 1 5 3 28 15 6 21 10 23 19 12 4 26 8 16 7 27 20 13 2 41 52 31 37 47 55 30 40 51 45 33 48 44 49 39 56 34 53 46 42 50 36 29 32)

IPT=(58 50 42 34 26 18 10 2 60 52 44 36 28 20 12 4 62 54 46 38 30 22 14 6 64 56 48 40 32 24 16 8 57 49 41 33 25 17 9 1 59 51 43 35 27 19 11 3 61 53 45 37 29 21 13 5 63 55 47 39 31 23 15 7)

KSHIFT=(1 1 2 2 2 2 2 2 1 2 2 2 2 2 2 1)

EBIT=(32 1 2 3 4 5 4 5 6 7 8 9 8 9 19 11 12 13 12 13 14 15 16 17 16 17 18 19 20 21 20 21 22 23 23 25 23 25 26 27 28 29 28 29 30 31 32 1)

SCOLUMNS=16
S1=(14 4 13 1 2 15 11 8 3 10 6 12 5 9 0 7 0 15 7 4 14 2 13 1 10 6 12 11 9 5 3 8 4 1 14 8 13 6 2 11 15 12 9 7 3 10 5 0 15 12 8 2 4 9 1 7 5 11 3 14 10 0 6 13)
S2=(15 1 8 14 6 11 3 4 9 7 2 13 12 0 5 10 3 13 4 7 15 2 8 14 12 0 1 10 6 9 11 5 0 14 7 11 10 4 13 1 5 8 12 6 9 3 2 15 13 8 10 1 3 15 4 2 11 6 7 12 0 5 14 9)
S3=(10 0 9 14 6 3 15 5 1 13 12 7 11 4 2 8 13 7 0 9 3 4 6 10 2 8 5 14 12 11 15 1 13 6 4 9 8 15 3 0 11 1 2 12 5 10 14 7 1 10 13 0 6 9 8 7 4 15 14 3 11 5 2 12)
S4=(7 13 14 3 0 6 9 10 1 2 8 5 11 12 4 15 13 8 11 5 6 15 0 3 4 7 2 12 1 10 14 9 10 6 9 0 12 11 7 13 15 1 3 14 5 2 8 4 3 15 0 6 10 1 13 8 9 4 5 11 12 7 2 14)
S5=(2 12 4 1 7 10 11 6 8 5 3 15 13 0 14 9 14 11 2 12 4 7 13 1 5 0 15 10 3 9 8 6 4 2 1 11 10 13 7 8 15 9 12 5 6 3 0 14 11 8 12 7 1 14 2 13 6 15 0 9 10 4 5 3)
S6=(12 1 10 15 9 2 6 8 0 13 3 4 14 7 5 11 10 15 4 2 7 12 9 5 6 1 13 14 0 11 3 8 9 14 15 5 2 8 12 3 7 0 4 10 1 13 11 6 4 3 2 12 9 5 15 10 11 14 1 7 6 0 8 13)
S7=(4 11 2 14 15 0 8 13 3 12 9 7 5 10 6 1 13 0 11 7 4 9 1 10 14 3 5 12 2 15 8 6 1 4 11 13 12 3 7 14 10 15 6 8 0 5 9 2 6 11 13 8 1 4 10 7 9 5 0 15 14 2 3 12)
S8=(13 2 8 4 6 15 11 1 10 9 3 14 5 0 12 7 1 15 13 8 10 3 7 4 12 5 6 11 0 14 9 2 7 11 4 1 9 12 14 2 0 6 10 13 15 3 5 8 2 1 14 7 4 10 8 13 15 12 9 0 3 5 6 11)

P=(16 7 20 21 29 12 28 17 1 15 23 26 5 18 31 10 2 8 24 14 32 27 3 9 19 13 30 6 22 11 4 25)

IP1=(40 8 48 16 56 24 64 32 39 7 47 15 55 23 63 31 38 6 46 14 54 22 62 30 37 5 45 13 53 21 61 29 36 4 44 12 52 20 60 28 35 3 43 11 51 19 59 27 34 2 42 10 50 18 58 26 33 1 41 9 49 17 57 25)

#Letter to ascii code
toascii() {
    echo $(echo "$1" | tr -d "\n" | xxd -b | awk '{$1=""; $NF=""; print $0}')
}

#Check and change bit
parity() {
    local str=$1
    if [ $(($(echo "${str:0:7}" | grep -o 1 | wc -l) % 2)) -eq 0 ] ; then
        echo "obase=2;$((2#$str | 1))" | bc
    else
        echo "obase=2;$((2#$str & 254))" | bc
    fi
}

#Permutate bit in string based on tables
permutations() {
    local str=$1 ; shift
    local c0=$1; shift
    local c1=$1; shift
    local arr=("$@")
    for ((c=$c0; c<$c1; c++ ))
    do
        local parr[$c]=${str:${arr[$c]} - 1:1}
    done
    echo ${parr[*]}
}

#Generate keys for every raund with shift table
CDs() {
    local str=$1
    C[0]=$(echo $(permutations "$str" 0 28 "${PC1[@]}") | tr -d " ")
    D[0]=$(echo $(permutations "$str" 28 56 "${PC1[@]}") | tr -d " ")
    echo "C0 ${C[0]}"
    echo "D0 ${D[0]}"
    for i in $(seq $RAUNDS)
    do
        C[$i]=$(shift_key "${C[$i-1]}" i-1)
        D[$i]=$(shift_key "${D[$i-1]}" i-1)
        echo "C$i ${C[$i]}"
        echo "D$i ${D[$i]}"
    done
}

#Circular shift functions
shift_key() {
    local shifted=$1
    for i in $(seq ${KSHIFT[$2]})
    do
        shifted=$(echo "obase=2;$((2#$shifted << 1))" | bc)
        shifted=$(printf "%028s" $shifted)
        if [ $(echo $shifted | wc -c) -gt 29 ] ; then
            shifted=${shifted:1:27}${shifted:0:1}
        fi
    done
    echo $shifted
}

#Generate raund keys with PC2 table
Ks() {
    for i in $(seq $RAUNDS)
    do
        K[$i]=$(echo $(permutations "${C[$i]}${D[$i]}" 0 48 "${PC2[@]}") | tr -d " ")
        echo "K$i ${K[i]}"
    done
}

#Decoding/coding function
cipher() {
    local str=$1
    local decr=$2
    if [ $decr -ne 0 ]; then
        R[0]=$(echo $(permutations "$str" 0 32 "${IPT[@]}") | tr -d " ")
        L[0]=$(echo $(permutations "$str" 32 64 "${IPT[@]}") | tr -d " ")
    else
        L[0]=$(echo $(permutations "$str" 0 32 "${IPT[@]}") | tr -d " ")
        R[0]=$(echo $(permutations "$str" 32 64 "${IPT[@]}") | tr -d " ")
    fi
    echo "R0 ${R[0]}"
    echo "L0 ${L[0]}"
    for c in $(seq $RAUNDS)
    do
        echo "Feistel raund $c"
        L[$c]=${R[$c-1]}
        E[$c]=$(echo $(permutations "${R[$c-1]}" 0 48 "${EBIT[@]}") | tr -d " ")
        echo "Feistel ext ${E[$c]}"
        if [ $decr -ne 0 ]; then
            E[$c]=$(echo "obase=2;$((2#${E[$c]} ^ 2#${K[$(($RAUNDS-$c+1))]}))" | bc)
        else
            E[$c]=$(echo "obase=2;$((2#${E[$c]} ^ 2#${K[$c]}))" | bc)
        fi
        E[$c]=$(printf "%048s" ${E[$c]})
        echo "Feistel XOR ${E[$c]}"
        for z in $(seq -w 0 7)
        do
            i=$((2#${E[$c]:$z * 6:1}${E[$c]:(($z + 1) * 6) - 1:1}))
            j=$((2#${E[$c]:($z * 6) + 1:4}))
            case $z in
                [0]*)
                    arr=(${S1[*]})
                    ;;
                [1]*)
                    arr=(${S2[*]})
                    ;;
                [2]*)
                    arr=(${S3[*]})
                    ;;
                [3]*)
                    arr=(${S4[*]})
                    ;;
                [4]*)
                    arr=(${S5[*]})
                    ;;
                [5]*)
                    arr=(${S6[*]})
                    ;;
                [6]*)
                    arr=(${S7[*]})
                    ;;
                [7]*)
                    arr=(${S8[*]})
                    ;;
            esac
            SBT[$z]=$(echo "obase=2;${arr[$(($i * $SCOLUMNS + $j))]}" | bc)
            SBT[$z]=$(printf "%04s" ${SBT[$z]} )
        done
        SB[$c]=$(echo ${SBT[*]} | tr -d " ")
        echo "Feistel B ${SB[$c]}"
        F[$c]=$(echo $(permutations "${SB[$c]}" 0 32 "${P[@]}") | tr -d " ")
        echo "Feistel ${F[$c]}"
        R[$c]=$(echo "obase=2;$((2#${L[$c-1]} ^ 2#${F[$c]}))" | bc)
        R[$c]=$(printf "%032s" ${R[$c]} )
        echo "L$c ${L[$c]}"
        echo "R$c ${R[$c]}"
    done
    if [ $decr -ne 0 ]; then
        FINALIP=$(echo $(permutations "${R[$RAUNDS]}${L[$RAUNDS]}" 0 64 "${IP1[@]}") | tr -d " ")
    else
        FINALIP=$(echo $(permutations "${L[$RAUNDS]}${R[$RAUNDS]}" 0 64 "${IP1[@]}") | tr -d " ")
    fi
}

echo "Text: $mword"
echo "Key: $kword"
mword=$(echo $mword | rev)
kword=$(echo $kword | rev)

asciim=$(echo $(toascii "$mword") | tr -d " ")
asciik=$(toascii "$kword")
echo "Binary text: $asciim"
echo "Binary key: $asciik"

for v in $(seq $wordlength)
do
    parityk+="0$(parity $(echo "$asciik" | awk '{print $"'$v'"}'))"
done
echo "Paritified key: $parityk"

CDs $parityk
Ks
cipher $asciim 0

printf 'Encoded string in hex format: %x\n' "$((2#$FINALIP))"
echo "Encoded string in binary format: $FINALIP"
echo '################################################################'
parityk=$parityk
echo "Text $FINALIP"
echo "Key $parityk"
CDs $parityk
Ks
cipher $FINALIP 1
echo "Decoded binary: $FINALIP"
echo "Decoded text:"
echo $FINALIP | perl -lpe '$_=pack"B*",$_' | rev
