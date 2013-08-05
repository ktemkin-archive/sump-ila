<?xml version="1.0" encoding="UTF-8"?>
<drawing version="7">
    <attr value="spartan3e" name="DeviceFamilyName">
        <trait delete="all:0" />
        <trait editname="all:0" />
        <trait edittrait="all:0" />
    </attr>
    <netlist>
        <signal name="XLXN_8" />
        <signal name="XLXN_31" />
        <signal name="XLXN_44" />
        <signal name="XLXN_46" />
        <signal name="XLXN_47" />
        <signal name="XLXN_53" />
        <signal name="XLXN_55" />
        <signal name="XLXN_56" />
        <signal name="XLXN_57" />
        <signal name="XLXN_64" />
        <signal name="XLXN_65" />
        <signal name="XLXN_83" />
        <signal name="XLXN_84" />
        <signal name="XLXN_85" />
        <signal name="XLXN_86" />
        <signal name="XLXN_94" />
        <signal name="COUNT(15:0)" />
        <signal name="tx" />
        <signal name="rx" />
        <signal name="clk" />
        <signal name="XLXN_103" />
        <signal name="XLXN_75" />
        <signal name="COUNT(5)" />
        <signal name="COUNT(7)" />
        <signal name="XLXN_88" />
        <signal name="XLXN_89" />
        <port polarity="Output" name="tx" />
        <port polarity="Input" name="rx" />
        <port polarity="Input" name="clk" />
        <blockdef name="gnd">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-64" y2="-96" x1="64" />
            <line x2="52" y1="-48" y2="-48" x1="76" />
            <line x2="60" y1="-32" y2="-32" x1="68" />
            <line x2="40" y1="-64" y2="-64" x1="88" />
            <line x2="64" y1="-64" y2="-80" x1="64" />
            <line x2="64" y1="-128" y2="-96" x1="64" />
        </blockdef>
        <blockdef name="cb16re">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="320" y1="-128" y2="-128" x1="384" />
            <line x2="64" y1="-192" y2="-192" x1="0" />
            <line x2="64" y1="-32" y2="-32" x1="192" />
            <line x2="192" y1="-64" y2="-32" x1="192" />
            <line x2="64" y1="-32" y2="-32" x1="0" />
            <line x2="64" y1="-128" y2="-144" x1="80" />
            <line x2="80" y1="-112" y2="-128" x1="64" />
            <line x2="64" y1="-128" y2="-128" x1="0" />
            <line x2="320" y1="-256" y2="-256" x1="384" />
            <rect width="64" x="320" y="-268" height="24" />
            <line x2="320" y1="-192" y2="-192" x1="384" />
            <rect width="256" x="64" y="-320" height="256" />
        </blockdef>
        <blockdef name="vcc">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-32" y2="-64" x1="64" />
            <line x2="64" y1="0" y2="-32" x1="64" />
            <line x2="32" y1="-64" y2="-64" x1="96" />
        </blockdef>
        <blockdef name="simple_logic_analyzer">
            <timestamp>2013-8-5T1:3:14</timestamp>
            <line x2="0" y1="-608" y2="-608" x1="64" />
            <line x2="0" y1="-544" y2="-544" x1="64" />
            <line x2="384" y1="-608" y2="-608" x1="320" />
            <line x2="320" y1="-508" y2="-508" style="linewidth:W" x1="64" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <rect width="256" x="64" y="-640" height="640" />
            <line x2="0" y1="-480" y2="-480" x1="64" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <line x2="0" y1="-224" y2="-224" x1="64" />
            <line x2="0" y1="-288" y2="-288" x1="64" />
            <line x2="0" y1="-352" y2="-352" x1="64" />
            <line x2="0" y1="-416" y2="-416" x1="64" />
            <line x2="148" y1="-28" y2="-28" x1="112" />
            <line x2="148" y1="-28" y2="-484" x1="148" />
            <line x2="112" y1="-484" y2="-484" x1="148" />
        </blockdef>
        <blockdef name="and2">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-64" y2="-64" x1="0" />
            <line x2="64" y1="-128" y2="-128" x1="0" />
            <line x2="192" y1="-96" y2="-96" x1="256" />
            <arc ex="144" ey="-144" sx="144" sy="-48" r="48" cx="144" cy="-96" />
            <line x2="64" y1="-48" y2="-48" x1="144" />
            <line x2="144" y1="-144" y2="-144" x1="64" />
            <line x2="64" y1="-48" y2="-144" x1="64" />
        </blockdef>
        <block symbolname="cb16re" name="XLXI_30">
            <blockpin signalname="clk" name="C" />
            <blockpin signalname="XLXN_88" name="CE" />
            <blockpin signalname="XLXN_89" name="R" />
            <blockpin name="CEO" />
            <blockpin signalname="COUNT(15:0)" name="Q(15:0)" />
            <blockpin name="TC" />
        </block>
        <block symbolname="simple_logic_analyzer" name="XLXI_28">
            <blockpin signalname="clk" name="clk" />
            <blockpin signalname="rx" name="from_pc" />
            <blockpin signalname="tx" name="to_pc" />
            <blockpin name="c7" />
            <blockpin signalname="COUNT(5)" name="c0" />
            <blockpin name="c6" />
            <blockpin name="c5" />
            <blockpin name="c4" />
            <blockpin name="c3" />
            <blockpin signalname="XLXN_75" name="c2" />
            <blockpin signalname="COUNT(7)" name="c1" />
        </block>
        <block symbolname="and2" name="XLXI_32">
            <blockpin signalname="COUNT(7)" name="I0" />
            <blockpin signalname="COUNT(5)" name="I1" />
            <blockpin signalname="XLXN_75" name="O" />
        </block>
        <block symbolname="vcc" name="XLXI_33">
            <blockpin signalname="XLXN_88" name="P" />
        </block>
        <block symbolname="gnd" name="XLXI_34">
            <blockpin signalname="XLXN_89" name="G" />
        </block>
    </netlist>
    <sheet sheetnum="1" width="2720" height="1760">
        <instance x="480" y="640" name="XLXI_30" orien="R0" />
        <branch name="COUNT(15:0)">
            <wire x2="1024" y1="384" y2="384" x1="864" />
            <wire x2="1024" y1="384" y2="544" x1="1024" />
            <wire x2="1024" y1="544" y2="608" x1="1024" />
            <wire x2="1024" y1="608" y2="688" x1="1024" />
            <wire x2="1024" y1="688" y2="1088" x1="1024" />
        </branch>
        <bustap x2="1120" y1="544" y2="544" x1="1024" />
        <bustap x2="1120" y1="608" y2="608" x1="1024" />
        <branch name="tx">
            <wire x2="2304" y1="416" y2="416" x1="2288" />
        </branch>
        <branch name="rx">
            <wire x2="1888" y1="480" y2="480" x1="1872" />
            <wire x2="1904" y1="480" y2="480" x1="1888" />
        </branch>
        <branch name="clk">
            <wire x2="1888" y1="416" y2="416" x1="1872" />
            <wire x2="1904" y1="416" y2="416" x1="1888" />
        </branch>
        <instance x="1904" y="1024" name="XLXI_28" orien="R0">
        </instance>
        <branch name="XLXN_75">
            <wire x2="1888" y1="704" y2="704" x1="1600" />
            <wire x2="1904" y1="672" y2="672" x1="1888" />
            <wire x2="1888" y1="672" y2="704" x1="1888" />
        </branch>
        <branch name="COUNT(5)">
            <wire x2="1216" y1="544" y2="544" x1="1120" />
            <wire x2="1904" y1="544" y2="544" x1="1216" />
            <wire x2="1216" y1="544" y2="672" x1="1216" />
            <wire x2="1344" y1="672" y2="672" x1="1216" />
        </branch>
        <branch name="COUNT(7)">
            <wire x2="1136" y1="608" y2="608" x1="1120" />
            <wire x2="1904" y1="608" y2="608" x1="1136" />
            <wire x2="1136" y1="608" y2="736" x1="1136" />
            <wire x2="1344" y1="736" y2="736" x1="1136" />
        </branch>
        <instance x="1344" y="800" name="XLXI_32" orien="R0" />
        <branch name="clk">
            <wire x2="480" y1="512" y2="512" x1="448" />
        </branch>
        <branch name="XLXN_88">
            <wire x2="480" y1="448" y2="448" x1="448" />
        </branch>
        <instance x="448" y="512" name="XLXI_33" orien="R270" />
        <branch name="XLXN_89">
            <wire x2="480" y1="608" y2="608" x1="448" />
        </branch>
        <instance x="320" y="544" name="XLXI_34" orien="R90" />
        <iomarker fontsize="28" x="1872" y="416" name="clk" orien="R180" />
        <iomarker fontsize="28" x="1872" y="480" name="rx" orien="R180" />
        <iomarker fontsize="28" x="2304" y="416" name="tx" orien="R0" />
        <iomarker fontsize="28" x="448" y="512" name="clk" orien="R180" />
        <text style="fontsize:64;fontname:Arial" x="1536" y="1564">Internal Logic Analyzer Demonstration</text>
        <text style="fontsize:32;fontname:Arial" x="1512" y="1624">Open-Source Logic Analysis for the Papilio One from the Xilinx Schematic Tools</text>
    </sheet>
</drawing>