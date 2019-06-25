0 poke 55,255:poke 56,47:co=54272:a1=10:s=0:poke 54296,15:poke 54278,240:poke 54276,3
1 print"{clear}":poke 53281,0:poke 53280,0:v=53248:poke v+21,63:poke 2040,192:poke 2041,193
2 for i=1 to 4:poke 2041+i,194:poke v+40+i,2+i:next:poke v+39,8:poke v+40,1:poke v+29,1
3 for i=0 to 254:read q:poke 12288+i,q:next
4 p=120:x=132:y=217:poke v,120:poke v+1,220:poke v+2,x:poke v+3,y:for i=0 to 3
5 x(i+1)=(i+1)*40:y(i+1)=90:poke v+4+i*2,x(i+1):poke v+5+i*2,y(i+1):next
6 i=peek(v+30):for i=55376 to 56256 step 40:poke i,4:poke i-co,160:poke i+32,4
7 poke i-co+32,160:next:for i=55336 to 55368:poke i,4:poke i-co,160:next
8 ti$="000000":print"{home}{red}******************{green}quack{red}**************"
9 print"{home}{down*4}{left*5}{white}time{down*5}{left*5}score"
10 pe=peek(197)
11 print"{home}{down*6}{left*5}{yellow}";right$(ti$,2):print"{home}{down*12}{left*5}";s;
12 print"{down*3}{left*2}{space*2}{left*3}";a1:if ti$="000100" then 200
13 if pe=12 and p>35 then p=p-4:if ar=0 then x=x-4
14 if pe=20 and p<237 then p=p+4:if ar=0 then x=x+4
15 if pe=36 and ar=0 and a1>0 then a1=a1-1:ar=5:gosub 300
18 y=y-ar:z=peek(v+30):if z>3 and y>90 then gosub 100
19 if y<60 then y=217:ar=0:x=p+12:poke v+3,y
20 poke v,p:poke v+2,x:if ar>0 then poke v+3,y
30 for i=0 to 3:x(i+1)=x(i+1)+3:if x(i+1)>241 then x(i+1)=35:poke 2042+i,194
40 poke v+4+i*2,x(i+1):poke v+5+i*2,y(i+1):next
50 goto 10
100 s=s+10:z=peek(v+30):a=5:if z and 8 then a=1
105 if z and 16 then a=2
110 if z and 32 then a=3
113 if z and 4 then a=4
115 poke 2042+a,195:ar=0:y=218:x=p+12:poke v+3,y
120 poke 54276,0:poke 54276,33
125 for i=15 to 1 step -.5:poke 54273,i*2:poke 54296,i:next:poke 54296,15:poke 54273,0
130 z=peek(v+30):return
200 poke 54276,0:poke 54276,17:for i=240 to 1step-3:poke 54273,i:next:poke 54273,0
210 for i=1 to 11:poke v+i,0:next
220 print"{clear}{green}your time is up!"
230 print"{down*2}{red}you shot";s/10;"birds."
240 if s>50 then print"{white}well done!!!"
250 print"{down*3}{purple}do you want another go?"
260 get a$:if a$="y" then run
270 if a$<>"n" then 260
280 end
300 poke 54276,0:poke 54276,129:for i=1 to 80 step 2:poke 54273,i:next:poke 54273,0
310 return
9000 data 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,56,0,0,238,0,1,199,0
9010 data 3,1,192,6,0,192,12,0,96,24,0,48,48,0,24,110,0,236,1,199,0,0,56,0
9020 data 0,0,0,0,0,0,0,0,0,99
9030 data 0,0,0,0,0,0,0,16,0,0,56,0,0,56,0,0,124,0,0,16,0,0,16,0,0,16,0,0,16
9040 data 0,0,16,0,0,16,0,0,16,0,0,16,0,0,16,0,0,16,0,0,16,0,0,16,0,0,16,0,0,16
9050 data 0,0,16,0,99
9060 data 0,0,0,0,0,0,0,0,0,0,0,6,0,7,232,120,7,176,252,7,232,126,3,134,63,255,0
9070 data 63,255,0,31,255,0,15,255,0,15,255,0,15,255,0,3,248,0,0,128,0,1,0,0
9080 data 2,0,0,4,0,0,6,0,0,5,0,0,99
9090 data 0,0,0,5,0,0,6,0,0,4,0,0,4,0,0,2,128,0,1,248,0,0,255,0,3,255,0,15
9100 data 255,0,15,255,0,15,255,0,31,255,0,63,3,134,63,7,232,126,7,176,252,7,232
9110 data 120,0,6,0,0,0,0,0,0,0,0,0,0,0,0