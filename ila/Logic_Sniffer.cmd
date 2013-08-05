xst -ise "C:/dbdev/My Dropbox/GadgetFactory/Sump_Pump/trunk/VHDL_Core/Logic_Sniffer.ise" -intstyle ise -ifn "C:/dbdev/My Dropbox/GadgetFactory/Sump_Pump/trunk/VHDL_Core/Logic_Sniffer.xst" -ofn "C:/dbdev/My Dropbox/GadgetFactory/Sump_Pump/trunk/VHDL_Core/Logic_Sniffer.syr" 
ngdbuild -ise "Logic_Sniffer.ise" -intstyle ise -dd _ngo -sd ipcore_dir -nt timestamp -i -p xc3s250e-vq100-4 Logic_Sniffer.ngc Logic_Sniffer.ngd  
map -ise "Logic_Sniffer.ise" -intstyle ise -p xc3s250e-vq100-4 -cm area -ir off -pr b -c 100 -o Logic_Sniffer_map.ncd Logic_Sniffer.ngd Logic_Sniffer.pcf 
par -ise "Logic_Sniffer.ise" -w -intstyle ise -ol std -t 1 Logic_Sniffer_map.ncd Logic_Sniffer.ncd Logic_Sniffer.pcf 
trce -ise "C:/dbdev/My Dropbox/GadgetFactory/Sump_Pump/trunk/VHDL_Core/Logic_Sniffer.ise" -intstyle ise -e 3 -s 4 -xml Logic_Sniffer.twx Logic_Sniffer.ncd -o Logic_Sniffer.twr Logic_Sniffer.pcf -ucf Logic_Sniffer.ucf 
bitgen -ise "Logic_Sniffer.ise" -intstyle ise -f Logic_Sniffer.ut Logic_Sniffer.ncd 
copy_files.bat