#!/bin/sh

dict="
math:intergral:∫
math:closed-intergral:∮
math:dot:·
math:divide:÷

euro:a-umlaut:ä:Ä
euro:o-umlaut:ö:Ö
euro:u-umlaut:ü:Ü
euro:o:ø:Ø
euro:ae:æ:Æ
euro:a-accent:á:Á
euro:e-accent:é:É
euro:i-accent:í:Í
euro:o-accent:ó:Ó
euro:u-accent:ú:Ú
euro:nya:ñ:Ñ
euro:!:¡
euro:?:¿
euro:eszett:ß

greek:alpha:α:Α
greek:beta:β:Β
greek:gamma:γ:Γ
greek:delta:δ:Δ
greek:eplison:ε:Ε
greek:zeta:ζ:Ζ
greek:eta:η:Η
greek:theta:θ:Θ
greek:iota:ι:Ι
greek:kappa:κ:Κ
greek:lambda:λ:Λ
greek:mu:μ:Μ
greek:nu:ν:Ν
greek:xi:ξ:Ξ
greek:omicron:ο:Ο
greek:pi:π:Π
greek:rho:ρ:Ρ
greek:sigma:σ:Σ
greek:tau:τ:Τ
greek:upsilon:υ:Υ
greek:phi:φ:Φ
greek:chi:χ:Χ
greek:psi:ψ:Ψ
greek:omega:ω:Ω
"

echo "Character Selector"
step=0
while true; do
    if [ $step == "0" ]; then
        read -p "Enter a group or code: " t
        tLower=$(echo "$t" | tr '[:upper:]' '[:lower:]')
        if [[ $t == "" ]]; then 
            echo "! Please enter a group or code"
        elif [[ $(echo "$dict" | grep "$t" | wc -l) == 1 ]]; then
            char=$(echo "$dict" | grep "$t" | cut -d':' -f 3)
            break
        elif [[ $(echo $"$dict" | grep "$tLower" | wc -l) == 1 ]]; then 
            if [[ $(echo $"$dict" | grep "$tLower" | cut -d':' -f 4) == "" ]]; then 
                char=$(echo $"$dict" | grep "$tLower" | cut -d':' -f 3)
                break
            else 
                char=$(echo $"$dict" | grep "$tLower" | cut -d':' -f 4)
                break
            fi
        elif [[ $(echo "$dict" | grep "$t" | wc -l) == 0 ]] && [[ $(echo $"$dict" | grep "$tLower" | wc -l) == 0 ]]; then
            echo "! That group does not exist"
        else 
            dict=$(echo $"$dict" | grep "$t")
            dictIter="$dict"
            step=1
            while true; do 
                if [[ $(echo $"$dictIter" | head -n 1 | cut -d':' -f 4) == "" ]]; then
                    line="    $(echo $"$dictIter" | head -n 1 | cut -d':' -f 3) : $(echo $"$dictIter" | head -n 1 | cut -d':' -f 2)"
                else 
                    line="$(echo $"$dictIter" | head -n 1 | cut -d':' -f 3) : $(echo $"$dictIter" | head -n 1 | cut -d':' -f 4) : $(echo $"$dictIter" | head -n 1 | cut -d':' -f 2)"
                fi
                echo " $line"
                dictIter=$(echo $"$dictIter" | tail -n +2)
                if [[ $dictIter == "" ]]; then 
                    break
                fi
            done
        fi
    elif [[ $step == 1 ]]; then
        read -p "Enter a code (capitalize for the capital character): " t
        tLower=$(echo "$t" | tr '[:upper:]' '[:lower:]')
        if [[ $(echo $"$dict" | grep "$t" | wc -l) == 1 ]]; then
            char=$(echo $"$dict" | grep "$t" | cut -d':' -f 3)
            break
        elif [[ $(echo $"$dict" | grep "$tLower" | wc -l) == 1 ]]; then 
            if [[ $(echo $"$dict" | grep "$tLower" | cut -d':' -f 4) == "" ]]; then 
                char=$(echo $"$dict" | grep "$tLower" | cut -d':' -f 3)
                break
            else 
                char=$(echo $"$dict" | grep "$tLower" | cut -d':' -f 4)
                break
            fi
        else 
            echo "! That code does not exist"
            #echo $(echo "$dict" | grep "$t")
        fi
    else
        read -p " else : " t 
    fi
    
done 

echo -n $char | xsel -b
echo "Copying $char"
sleep 0.5