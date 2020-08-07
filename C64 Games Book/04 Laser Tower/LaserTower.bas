5 poke55,255:poke56,47
10 v=53248:co=54272:poke54296,15
12 fori=12*1024+256to12*1024+263:pokei,0:next
15 fori=0to47:reada:poke12*1024+i,a:next:pokev+22,peek(v+22)or16
20 pokev+24,28:pokev+34,2:pokev+35,7:pokev+33,0:pokev+32,0
25 fori=12352to12478:reada:pokei,a:next:pokev+37,2:pokev+38,7
30 pokev,75:pokev+16,0:pokev+1,100:pokev+28,0:pokev+39,4:pokev+21,1
35 gr=.4:vv=0:hv=0:fr=.5:poke2040,193
50 print"{clear}{right}{down*15}{red}a{down}{right*6}";:fori=1to7:print"{red}{down}{left}";:next:tw=1625
51 print"{green}cccccccccccccccccccccccccc{space*4}cccccccc{right*2}";
52 print"ddddddddddddddddddddddddddeeeedddddddd";
53 for t=1945 to tw+40 step-40:poke t,0:poke t+co,10:next
54 a=peek(v+31)
55 r=int(rnd(1)*3+1):on r goto85,60,70
60 iftw<=1065then100
65 poketw+co,10:poketw,0:tw=tw-40:goto80
70 iftw>=1945then100
75 poketw,32:tw=tw+40
80 poketw+co,2:poketw,1:goto100
85 poke54276,0:ifrnd(1)<.95then100
90 j=tw+1:en=tw+38:poke54273,72:poke54272,169:poke54277,44:poke54275,7:pw=0
91 poke54274,0:poke54276,65
93 ifpeek(v+31)then1000
94 pokej+co,7:pokej,2:j=j+1:poke54274,pw:pw=pw+6:ifj<=enthen93
95 foren=tw+1toj:poke54274,pw:pw=pw-6:pokeen,32:next
100 k=peek(197):hv=hv-fr-(k=2)
101 ifk<>2andk<>7then105
102 poke54273,2:poke54272,37:poke54277,47:poke54276,0:poke54276,129
105 ifhv<-4thenhv=-4
110 ifhv>4thenhv=4
115 vv=vv+gr+(k=7):ifvv<-4thenvv=-4
120 ifvv>4thenvv=4
125 pokev+1,peek(v+1)+vv:a=peek(v+1):ifa<48thenpokev+1,40
130 ifa>234then2000
135 a=peek(v)+hv:b=peek(v+16)and1:ifa>255thena=0:b=1
140 ifa<0andbthenb=0:a=255
142 ifa>55andbthena=55
145 ifa<32andb=0then1000
150 pokev,a:pokev+16,peek(v+16)orb
155 ifb=0andpeek(v+16)and1thenpokev+16,peek(v+16)-1
160 ifpeek(v+31)and1then1000
165 goto55
1000 poke2040,194:pokev+28,1:poke54273,34:poke54272,75:poke54277,143
1005 poke54276,129:fori=1to500:next:poke54273,0:poke54273,0:pokev+24,20
1010 print"{clear}{down*4}{right*6}{purple}hard lines":goto2010
2000 fori=1to5000:next:poke54273,0:poke54272,0:pokev+24,20
2005 print"{clear}{down*4}"spc(15)"well done!":print"{down*3}{right*9}you escaped alive"
2010 print"{down*3}another game?":pokev+21,0:poke54276,0
2015 geta$:ifa$="y"thenpokev+24,28:goto30
2020 ifa$="n"thenend
2025 goto2015
10000 data 220,236,220,236,220,236,220,236,0,0,0,48,127,120,252,252
10005 data 0,0,0,0,255,0,0,0,0,0,0,8,157,255,255,255,255,255,255,255,255,255
10010 data 255,255,0,0,0,0,0,0,0,255
10015 data 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12,32,0,14,48,128,31,121
10055 data 240,63,135,160,31,121,240,14,48,128,12,32,0,0,0,0,0,0,0,0,0,0,0,0,0,0
10060 data 0,0,0,0,0,0,0,0,99,0,0,0,0,12,0,0,63,0,0,55,0,0,55,0,252,55,0
10065 data 55,247,240,53,87,112,13,85,255,3,85,87,0,245,95,0,213,240,0,55,0
10070 data 0,55,0,0,221,192,3,93,192,13,125,192,13,205,192,55,3,0,0,0,0,0,0,0
