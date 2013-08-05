REM REM For 4kX32 Memory config
REM set FinalName=Logic_Sniffer_4k32bit
REM xst -ise "Logic_Sniffer.ise" -intstyle silent -ifn "Logic_Sniffer4.xst" -ofn "Logic_Sniffer4.syr" 
REM ngdbuild -ise "Logic_Sniffer.ise" -intstyle ise -dd _ngo -sd ipcore_dir -nt timestamp -i -p xc3s250e-vq100-4 Logic_Sniffer.ngc Logic_Sniffer.ngd  
REM map -ise "Logic_Sniffer.ise" -intstyle ise -p xc3s250e-vq100-4 -cm area -ir off -pr b -c 100 -o Logic_Sniffer_map.ncd Logic_Sniffer.ngd Logic_Sniffer.pcf 
REM par -ise "Logic_Sniffer.ise" -w -intstyle ise -ol std -t 1 Logic_Sniffer_map.ncd Logic_Sniffer.ncd Logic_Sniffer.pcf 
REM trce -ise "Logic_Sniffer.ise" -intstyle ise -e 3 -s 4 -xml Logic_Sniffer.twx Logic_Sniffer.ncd -o Logic_Sniffer.twr Logic_Sniffer.pcf -ucf Logic_Sniffer.ucf 
REM bitgen -ise "Logic_Sniffer.ise" -intstyle ise -f Logic_Sniffer.ut Logic_Sniffer.ncd 
REM promgen -spi -w -p mcs -o logic_sniffer.mcs -s 256 -u 0 logic_sniffer.bit
REM copy logic_sniffer.bit %FinalName%.bit
REM copy logic_sniffer.mcs %FinalName%.mcs

REM For 6kX32 Memory config
set FinalName=Logic_Sniffer_6k32bit
del logic_sniffer.bit
del logic_sniffer.mcs
xst -ise "Logic_Sniffer.ise" -intstyle silent -ifn "Logic_Sniffer6.xst" -ofn "Logic_Sniffer6.syr" 
ngdbuild -ise "Logic_Sniffer.ise" -intstyle ise -dd _ngo -sd ipcore_dir -nt timestamp -i -p xc3s250e-vq100-4 Logic_Sniffer.ngc Logic_Sniffer.ngd  
map -ise "Logic_Sniffer.ise" -intstyle ise -p xc3s250e-vq100-4 -cm area -ir off -pr b -c 100 -o Logic_Sniffer_map.ncd Logic_Sniffer.ngd Logic_Sniffer.pcf 
par -ise "Logic_Sniffer.ise" -w -intstyle ise -ol std -t 1 Logic_Sniffer_map.ncd Logic_Sniffer.ncd Logic_Sniffer.pcf 
trce -ise "Logic_Sniffer.ise" -intstyle ise -e 3 -s 4 -xml Logic_Sniffer.twx Logic_Sniffer.ncd -o Logic_Sniffer.twr Logic_Sniffer.pcf -ucf Logic_Sniffer.ucf 
bitgen -ise "Logic_Sniffer.ise" -intstyle ise -f Logic_Sniffer.ut Logic_Sniffer.ncd 
promgen -spi -w -p mcs -o logic_sniffer.mcs -s 256 -u 0 logic_sniffer.bit
copy logic_sniffer.bit %FinalName%.bit
copy logic_sniffer.mcs %FinalName%.mcs

REM REM For 8kX16 Memory config
REM set FinalName=Logic_Sniffer_8k16bit
REM xst -ise "Logic_Sniffer.ise" -intstyle silent -ifn "Logic_Sniffer8.xst" -ofn "Logic_Sniffer8.syr" 
REM ngdbuild -ise "Logic_Sniffer.ise" -intstyle ise -dd _ngo -sd ipcore_dir -nt timestamp -i -p xc3s250e-vq100-4 Logic_Sniffer.ngc Logic_Sniffer.ngd  
REM map -ise "Logic_Sniffer.ise" -intstyle ise -p xc3s250e-vq100-4 -cm area -ir off -pr b -c 100 -o Logic_Sniffer_map.ncd Logic_Sniffer.ngd Logic_Sniffer.pcf 
REM par -ise "Logic_Sniffer.ise" -w -intstyle ise -ol std -t 1 Logic_Sniffer_map.ncd Logic_Sniffer.ncd Logic_Sniffer.pcf 
REM trce -ise "Logic_Sniffer.ise" -intstyle ise -e 3 -s 4 -xml Logic_Sniffer.twx Logic_Sniffer.ncd -o Logic_Sniffer.twr Logic_Sniffer.pcf -ucf Logic_Sniffer.ucf 
REM bitgen -ise "Logic_Sniffer.ise" -intstyle ise -f Logic_Sniffer.ut Logic_Sniffer.ncd 
REM promgen -spi -w -p mcs -o logic_sniffer.mcs -s 256 -u 0 logic_sniffer.bit
REM copy logic_sniffer.bit %FinalName%.bit
REM copy logic_sniffer.mcs %FinalName%.mcs

REM For 12kX16 Memory config
set FinalName=Logic_Sniffer_12k16bit
del logic_sniffer.bit
del logic_sniffer.mcs
xst -ise "Logic_Sniffer.ise" -intstyle silent -ifn "Logic_Sniffer12.xst" -ofn "Logic_Sniffer12.syr" 
ngdbuild -ise "Logic_Sniffer.ise" -intstyle ise -dd _ngo -sd ipcore_dir -nt timestamp -i -p xc3s250e-vq100-4 Logic_Sniffer.ngc Logic_Sniffer.ngd  
map -ise "Logic_Sniffer.ise" -intstyle ise -p xc3s250e-vq100-4 -cm area -ir off -pr b -c 100 -o Logic_Sniffer_map.ncd Logic_Sniffer.ngd Logic_Sniffer.pcf 
par -ise "Logic_Sniffer.ise" -w -intstyle ise -ol std -t 1 Logic_Sniffer_map.ncd Logic_Sniffer.ncd Logic_Sniffer.pcf 
trce -ise "Logic_Sniffer.ise" -intstyle ise -e 3 -s 4 -xml Logic_Sniffer.twx Logic_Sniffer.ncd -o Logic_Sniffer.twr Logic_Sniffer.pcf -ucf Logic_Sniffer.ucf 
bitgen -ise "Logic_Sniffer.ise" -intstyle ise -f Logic_Sniffer.ut Logic_Sniffer.ncd 
promgen -spi -w -p mcs -o logic_sniffer.mcs -s 256 -u 0 logic_sniffer.bit
copy logic_sniffer.bit %FinalName%.bit
copy logic_sniffer.mcs %FinalName%.mcs

REM REM For 16kX8 Memory config
REM set FinalName=Logic_Sniffer_16k8bit
REM xst -ise "Logic_Sniffer.ise" -intstyle silent -ifn "Logic_Sniffer16.xst" -ofn "Logic_Sniffer16.syr" 
REM ngdbuild -ise "Logic_Sniffer.ise" -intstyle ise -dd _ngo -sd ipcore_dir -nt timestamp -i -p xc3s250e-vq100-4 Logic_Sniffer.ngc Logic_Sniffer.ngd  
REM map -ise "Logic_Sniffer.ise" -intstyle ise -p xc3s250e-vq100-4 -cm area -ir off -pr b -c 100 -o Logic_Sniffer_map.ncd Logic_Sniffer.ngd Logic_Sniffer.pcf 
REM par -ise "Logic_Sniffer.ise" -w -intstyle ise -ol std -t 1 Logic_Sniffer_map.ncd Logic_Sniffer.ncd Logic_Sniffer.pcf 
REM trce -ise "Logic_Sniffer.ise" -intstyle ise -e 3 -s 4 -xml Logic_Sniffer.twx Logic_Sniffer.ncd -o Logic_Sniffer.twr Logic_Sniffer.pcf -ucf Logic_Sniffer.ucf 
REM bitgen -ise "Logic_Sniffer.ise" -intstyle ise -f Logic_Sniffer.ut Logic_Sniffer.ncd 
REM promgen -spi -w -p mcs -o logic_sniffer.mcs -s 256 -u 0 logic_sniffer.bit
REM copy logic_sniffer.bit %FinalName%.bit
REM copy logic_sniffer.mcs %FinalName%.mcs

REM For 24kX8 Memory config
set FinalName=Logic_Sniffer_24k8bit
del logic_sniffer.bit
del logic_sniffer.mcs
xst -ise "Logic_Sniffer.ise" -intstyle silent -ifn "Logic_Sniffer24.xst" -ofn "Logic_Sniffer24.syr" 
ngdbuild -ise "Logic_Sniffer.ise" -intstyle ise -dd _ngo -sd ipcore_dir -nt timestamp -i -p xc3s250e-vq100-4 Logic_Sniffer.ngc Logic_Sniffer.ngd  
map -ise "Logic_Sniffer.ise" -intstyle ise -p xc3s250e-vq100-4 -cm area -ir off -pr b -c 100 -o Logic_Sniffer_map.ncd Logic_Sniffer.ngd Logic_Sniffer.pcf 
par -ise "Logic_Sniffer.ise" -w -intstyle ise -ol std -t 1 Logic_Sniffer_map.ncd Logic_Sniffer.ncd Logic_Sniffer.pcf 
trce -ise "Logic_Sniffer.ise" -intstyle ise -e 3 -s 4 -xml Logic_Sniffer.twx Logic_Sniffer.ncd -o Logic_Sniffer.twr Logic_Sniffer.pcf -ucf Logic_Sniffer.ucf 
bitgen -ise "Logic_Sniffer.ise" -intstyle ise -f Logic_Sniffer.ut Logic_Sniffer.ncd 
promgen -spi -w -p mcs -o logic_sniffer.mcs -s 256 -u 0 logic_sniffer.bit
copy logic_sniffer.bit %FinalName%.bit
copy logic_sniffer.mcs %FinalName%.mcs
pause