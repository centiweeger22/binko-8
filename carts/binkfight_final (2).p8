pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--misc
--this code is a MESS
function _init()
 dos = rnd(10)>8
 dg = cartdata("binkfight")
 --stop(dget(0))
tm=0--
 timer = 64

 selektend=0
 mbuttons = {{128,10,"2pLAYER"},{128,6+64,"vS. cPU"}}
 difficulties={"easy","hard"}
 mbuttons = mbset()
 letters={{0,32},{16,32},{32,32},{48,32},{64,32},{80,32},{96,32},{112,32},{0,48}}
 rules = {}
 rules.amplifier = 1--
 rules.lives = 5
 rules.handicap={0,0,0}
 rules.cpudifficulty=1
 --pal(11,5)
 stageselect=false
 players = {{},{}}--,{}}
 cpu = true
 scale = 0.75
 tscale = 0.2
 tscroll={-64,0}
 scroll={-64,0}
  set_players()
 medals={}
 --if dg then
 --for i = 1,10 do
  --medals[i] = false
 --end
 --else
 for i = 1,10 do
  medals[i] = dget(64-i)==1
 end 
 --end
 sprs = {0,0,{16,0},{24,0}}
 t=0
 maxscale = 4
 hitboxes = {{},{}}
 particles = {}
 scene=3
 glassbreak=0
 winner=0
 stage=1
 wincolors = {8,13}
 wintexts = {"p1 win","p2 win"}
 levels = {}--
 medalsdet = {{"bot destroyer","BEAT THE HARD CPU",0},{"handicap destroyer","WIN WITH 10+ HANDICAP",0},{"boredom ender","WIN WITH 0X AMPLIFIER",0},{"glass demolisher","OBLITERATE 250 GLASS",1}}
 menuitem(1,"quit",gomenu)
 --s={{0,0},{32,0},{0,32},{32,32}}
 for j = 1,4 do
 l={}
 for i = 0,32 do
  o={}
  for d = 0,32 do
   add(o,mget(i+j*32-32,d))
   mset(i+j*32-32,d,0)
  end
  add(l,o)	
 end
 add(levels,l)
 end
 for i = 1,128 do--
  for d=1,64 do
   --mset(i,d,0)
  end
 end
 make(1)
-- for i=0,3 do
-- end
 vt = 0
end
function _update60()
 vt += 1/60
 if scene == 5 then
  scale = 0.8
 end
	 for i = 1,10 do
		 if medals[i] then
		 	dset(64-i,1)
		 end
	 end
 if glassbreak > 250 and medals[4] == false then
  medals[4] = true
  
 end
-- for igny = 0,0 do
 for i = 0,5 do
  players[1].bt[i+1] = btn(i,0)
  players[1].btp[i+1] = btnp(i,0)
 end
 for i = 0,5 do
  players[2].bt[i+1] = btn(i,1)
  players[2].btp[i+1] = btnp(i,1)
 end
 --cpup(1,2)
 if cpu and scene==0 then
  cpup(2,1,(1-rules.cpudifficulty)*3)
 end
 --cpubeasy(1,2)
 --cpup(3,1)
 --cpup(3,1)
 --cpup(4,1)
 for i = 0,0 do
 scenes()
 end

end
function _draw()
 pal()
 pal(14,128+2,1)
 pal(12,12)
 pal(13,128+12,1)
 pal(11,128+3,1)
 pal(15,128+1,1)
 pal(10,128,1)
 if not false then
 if scene==0 then
  drawgame()
 elseif scene ==1 then
  for i=0,1024 do
   posx=flr(rnd(64))*2
   posy=flr(rnd(64))*2
   rectfill(posx,posy,posx+1,posy+1,wincolors[winner])
  end
 elseif scene==2 then
	 if ttimer == nil then--
	  ttimer = 3
	 end
  cls(wincolors[winner])
  k = print(string,wincolors[winner])
  print(string,64-k/2,32,7)
  ttimer -=1
  if medalget > 0 and winner==1 then
  txt = "mEDAL GET!"
  print(txt,64-#txt*2,96,7)
  spr(63,60,101)
  end
  if ttimer <=0 then
  if wintexts[winner][#string+1] != nil then
  string = string..wintexts[winner][#string+1]
  ttimer=4
  end
  end
 elseif scene == 3 then
  if not scenetimer then
   scenetimer = 32767
  end
  if scenetimer > 80 and scenetimer < 820 then
   scenetimer = 32767
  end
  if scenetimer > 80 then
  tm+=1
  bg1()
    --plo = sin(tm/1023.235)*16+16
  for i = 1,9 do
   sspr(letters[i][1],letters[i][2],16,16,i*12-3,16+sin(i/4+tm/64)*3)
  end
  rectfill(64-24,64+32,64+24,64+48,0)
  rect(64-24,64+32,64+24,64+48,2)
  print("pRESS ❎",64-15,96+6,7)
  else
    pal(14,128,1)
	  for i=0,800 do
	   posx=flr(rnd(64))*2
	   posy=flr(rnd(64))*2
	   rectfill(posx,posy,posx+1,posy+1,14)
	  end
  end
 elseif scene == 4 then 
  pal(14,128,1)
  cls(14)
  color(0)
  t+=1--
   doffset=0
   if scenetimer <=60 then
    doffset = ((-scenetimer+60)/10)^2*10-90
   end  
  print("- sELECT A MODE -",64-#"- sELECT A MODE -"*2,4-doffset/10,7)
  --stop(mbuttons[1])
  if not mbuttons then mbuttons = mbset() end
  for i = 1,#mbuttons do--
   doffset=0
   if scenetimer <=60 then
    doffset = ((-scenetimer+60)/10)^2*10-90
   end
   if mbuttons[i][4] == 1 then
   if selektend+1 == i then kl=8  goffset=sin(t/80)*3 doffset *=-1 else kl=5 goffset=0 end
   mbuttons[i][1] += (mbuttons[i][2]-mbuttons[i][1])/10
   rectfill(mbuttons[i][1],32+goffset+doffset,mbuttons[i][1]+48,96+goffset+doffset,9)
   for zed = 0,48 do
   line(mbuttons[i][1]+zed,16+zed/3+goffset+doffset,mbuttons[i][1]+zed,96+zed/3+goffset+doffset)
   end
   if i==1 then
    pal(11,1)
    pal(12,5)
    pal(13,13)
    sspr(21,69,19,12,mbuttons[i][1]+8+12,48+goffset*1.4+doffset+3,19,12)
    sspr(0,75,21,20,mbuttons[i][1]+8,48+goffset*1.8+doffset+8,21,20)
   end
   if i==2 then
    --pal(11,0)
    --pal(13,0)
    --pal(12,0)
    sspr(64,65,32,32,mbuttons[i][1]+8-4,48+goffset*1.4+doffset,32,32)
    sspr(40,72,23,32,mbuttons[i][1]+8+13,48+goffset*1.8+doffset+7,23,32)
    --rectfill(mbuttons[i][1]+3+32,48+goffset+5+doffset,mbuttons[i][1]+32-5,48+goffset+9+doffset,0)
   end
   for zed=0,48 do
   if zed <2 or zed > 46 then
    line(mbuttons[i][1]+zed,16+zed/3+goffset+doffset,mbuttons[i][1]+zed,96+zed/3+goffset+doffset,kl)
   end
   pal(9,128+5,1)
   line(mbuttons[i][1]+zed,96-16+zed/3+goffset+doffset,mbuttons[i][1]+zed,96+zed/3+goffset+doffset,kl)   
   line(mbuttons[i][1]+zed,16+zed/3+goffset+doffset,mbuttons[i][1]+zed,32+zed/3+goffset+doffset,kl)   
   end
   for jh = 1,#mbuttons[i][3] do
   print(mbuttons[i][3][jh],mbuttons[i][1]+jh*6-1,88+jh*1.8-5+goffset+doffset,7)   
   end
   elseif mbuttons[i][4] == 2 then
    if selektend+1 == i and not medalscreen then kl=8  goffset=sin(t/80)*3 doffset *=-1 else kl=5 goffset=0 end
    mbuttons[i][1] += (mbuttons[i][2]-mbuttons[i][1])/10
    circfill(mbuttons[i][1],128-20,5,kl)
    spr(62,mbuttons[i][1]-4,128-16-8)
   end
   if medalscreen then
    rectfill(16,16,128-16,128-16,5)
    rect(16,16,128-16,128-16,0)
    for i = 1,#medalsdet do
     if medals[i] then
     spr(63,17,i*14+2)
     else
     spr(62,17,i*14+2) 
     end
     if medalsdet[i][3] == 0 or medals[i] then
     print(medalsdet[i][1],26,4+i*14,7)
     print(medalsdet[i][2],26,10+i*14,7)
     else
     print("???",26,4+i*14,7)
     end
    end
   end
  end
  --print(doffset,0,0)
 elseif scene== 5 then
  drawgame()
  if scenetimer/60 <=3 then
   spr(48+ceil(scenetimer/60),60,60)
  end
 elseif scene==6 then
  pal(14,128,1)
  cls(14)
  --print(selektor)
  klr=5
  if selektor == -1 then klr=8 end
  rectfill(64-12,8,64+12,24,klr)  
  sspr(64,48,48,20,64-11,10,28,16)
  klr=5
  if selektor == 0 then klr=7 end
  strk = "dAMAGE mULTIPLIER:"..tostr(round(rules.amplifier*10)/10).."X"
  print(strk,64-#strk*2,32,klr)
  klr=5
  if selektor == 1 then klr=7 end
  strk = "lIVES:"..tostr(rules.lives).."X"
  print(strk,64-#strk*2,38,klr)
  klr=5
  if selektor == 2 then klr=7 end
  strk = "p1 HANDICAP:"..tostr(rules.handicap[1])
  print(strk,64-#strk*2,44,klr)
  klr=5
  if selektor == 3 then klr=7 end
  strk = "p2 HANDICAP:"..tostr(rules.handicap[2])
  print(strk,64-#strk*2,50,klr)
  klr=5
  if not cpu then
   klr = 0
  end
  if selektor == 4 then klr=7 end
  if not cpu and klr > 0 then
   klr = 1
  end
  strk = "cPU dIFFICULTY:"..difficulties[rules.cpudifficulty+1]
  print(strk,64-#strk*2,56,klr)
  --cls(11)
  klr=5
  if selektor == 5 then klr=7 end
  strk = "sTAGE:"
  print(strk,64-#strk*2,62,klr)
  rect(48,64+4,64+16,64+32+4,klr)
  for i = 1,32 do
   for d = 1,32 do
    if fget(levels[stage][i][d],0) or fget(levels[stage][i][d],1) then
     pset(48+i,68+d,klr)
     --print(levels[1][i][d],0,i*8,7)
    end
   end
  end
  if medalget and medalget >0 then
   if medals[medalget] then
   spr(63,0,120)
   --print("mEDAL OBTAINED!",8,122,7)
   else
   spr(62,0,120)
   end
   print(medalsdet[medalget][1],8,122,7)  
  end
 end
 --print(medalget,0,0,7)

 else
  cls(0)
 end
 --for i = 0,10 do
  --print(dget(64-i),0,i*8-6,7)
 --end
-- for i = 1,2 do
--  print(players[i].btp[1],0,i*6-6)
-- end
 --print(groundcheck(round(players[2].x/8)-1,round(players[2].y/8)+1))
 --print(players[2].grounded,0,0)
 --print(players[1].y<me.y)
 --print(groundcheck(round((me.x+me.sx*10)/8)+me.side,flr(me.y/8)))
 plek=0
 plekhs = 0
 for i = 1,2 do
  if players[i].lives > plekhs then
   plekhs = players[i].lives
   plek=i
  end
 end
 --print(glassbreak,0,0,7)
 --print("pLAYER "..tostr(plek).." IS WINNING!",32,0)
 --for i = 1,4 do
 -- print(players[i].lives,0,8*i-8)
 --end
 --print(rules.cpudifficulty,0,0,7)
--print(scene,0,0,7)
end
function round(n)
 return flr(n+0.5)
end
function distance(x1,y1,x2,y2)
 return sqrt((x1-x2)^2+(y1-y2)^2)
end
function xtran(hx)

 return (hx-64+scroll[1])*scale+64
end
function ytran(hy)
 return (hy-64+scroll[2])*scale+64
end
function rese(me,j)
 for i=0,32 do
  --add(particles,{me.x,me.y,1,30,me.sx*-1+rnd(16)-8,me.sy*-1+rnd(16)-8,0})
 end
 me.x = 128
 me.y = 32
 me.sx=0
 me.sy=0
 me.kb=rules.handicap[j]
 me.hit=0
 me.lives -=1
 sfx(13)
end
function groundcheck(yx,yy)
 j=false
 for i = 0,1 do
  j=(j or fget(mget(yx,yy),i))
 end
 return j
 
end
function scenes()
--mbuttons= ombuttons
 if scene==0 then--or scene==3 then
  game()
 elseif scene==1 then
  scene1()
 elseif scene==2 then
  scene2()
 elseif scene==3 then
  scene3()
 elseif scene==4 then
  scene4()
 elseif scene==5 then
  scene5()
 elseif scene==6 then
  scene6()
 else
 if not scene==4 then
  mbuttons = mbset()
 end
--  cls()
--  print("invalid scene number! "..tostr(scene))
 end
end
function scene1()
   timer -=1
  if timer <=0 then
   scene=2
   string=""
  end
end
function scene2()
	if btnp(5) then
	 scene=4
	 mbuttons=mbset()
	 scenetimer = 180

	end
 if winner == 1 then
	medals[medalget]=true
	end
end
function scene3()
	 if scenetimer then scenetimer -=1 end
  if btnp(5) and scenetimer > 600 then
   scenetimer = 80
   sfx(28)
  end
  if scenetimer and scenetimer < 0 then
   scene=4
   scenetimer=120
  end
end
function scene4()
	  if not selektend then selektend = 0 end

  scenetimer -=1
  if selektend < 0 then selektend = 2 end
  if selektend > 2 then selektend=0 end
  if scenetimer > 100 then
   scenetimer = 110
   if btnp(0) and not medalscreen then
	   selektend -=1
	   t=0
	   sfx(31)
	  end
	  if btnp(1) and not medalscreen then
	   selektend +=1
	   t=0
	   sfx(31)
	  end
  end
  if btnp(5) then
   if selektend == 2 then
    medalscreen = true
   else
    scenetimer=30
    sfx(29)
   end
  end
  if scenetimer < 0 then
   scene=6
   --scenetimer=180
   cpu = selektend==1  
  end
  if btnp(4) then
   if medalscreen then
    medalscreen=false
   else
   scene=3
   scenetimer=180
   mbuttons = mbset()
   end
  end
end
function scene5()
 tscroll[1] = -(players[1].x+players[2].x)/2+64
 tscroll[2] = -(players[1].y+players[2].y)/2+64
 scroll[1] = -(players[1].x+players[2].x)/2+60
 scroll[2] = -(players[1].y+players[2].y)/2+64
  
 if scenetimer/60 == flr(scenetimer/60) and scenetimer/60 <=3 then
  sfx(26)
 end
 scenetimer-=1
 if scenetimer <=0 then
  scene = 0
  gotimer = 10
  sfx(27)
 end
 for i = 1,#players do
  if players[i].btp[5] or players[i].btp[6] then
   scenetimer -=10--
  end
 end

end
function set_players()
  for i=1,#players do
 players[i].x=64+8
 players[i].y=64
 players[i].sx=0
 players[i].sy=0
 players[i].dropdown = 0
 players[i].hit = 0
 players[i].kb=rules.handicap[i]
 players[i].side=1
 players[i].volley=0
 players[i].lives= rules.lives
 players[i].falling=false
 players[i].grounded=false
 players[i].airmove=false
 players[i].bt = {0,0,0,0,0,0}
 players[i].btp = {0,0,0,0,0,0}
 players[i].spmove = 0
 players[i].sjtimer = 0
 players[i].ljtimer = 0
 players[i].punchcooldown = 0

 end
 players[2].x = 128+64--
 players[2].side = -1
 tscroll[1] = players[1].x+players[2].x
 tscroll[1]/=2
end
function gomenu()
 scene=3
 mbuttons=ombuttons
end
function scene6()
 --cls(9)
 if not selektor then selektor = 0 end
 if not stageselect then
 if btnp(4) then
 sfx(34)
  scene=4
  scenetimer=150
 end
 if btnp(2) then
 sfx(33)
  selektor -=1
 end
 if btnp(3) then
 sfx(33)
  selektor +=1
 end
 if btnp(0) then
 sfx(33)
  if selektor == 0 then
   rules.amplifier-=0.5
  elseif selektor==1 then
   rules.lives-=1
  elseif selektor==2 then
   rules.handicap[1] -=0.5
  elseif selektor == 3 then
   rules.handicap[2] -=0.5  
  elseif selektor == 4 then
   rules.cpudifficulty -=1
  elseif selektor==5 then
   stage-=1
  end
 end
 if btnp(1) then
  sfx(33)
  if selektor == 0 then
   rules.amplifier+=0.5
  elseif selektor==1 then
   rules.lives +=1
  elseif selektor==2 then
   rules.handicap[1] +=0.5
  elseif selektor == 3 then
   rules.handicap[2] +=0.5  
  elseif selektor==4 then
   rules.cpudifficulty +=1
  elseif selektor==5 then
   stage+=1
  end
 end
 end
 rules.amplifier = round(mid(rules.amplifier,0,20)*10)/10
 rules.lives = mid(rules.lives,1,99)
 rules.handicap[1] = mid(rules.handicap[1],0,100)
 rules.handicap[2] = mid(rules.handicap[2],0,100)
 rules.cpudifficulty = mid(rules.cpudifficulty,0,1)
 stage=mid(stage,1,4)
  medalget=0
 if cpu and rules.lives == 5 and rules.amplifier == 1 and rules.handicap[2] == 0 then
  medalget=1
 end
 if cpu and rules.lives >3 and rules.amplifier < 2 and rules.handicap[1] >= 10 and rules.handicap[2] < 10 then
  medalget=2
 end
 if cpu and rules.amplifier == 0 and rules.handicap[1] == 0 and rules.handicap[2] == 0 then
  medalget=3
 end
 if selektor < -1 then
  selektor = 5
 end
 if selektor > 5 then
  selektor=-1
 end
 --if selektor == 5 and btnp(5) then
 -- stageselect=true
 --end
 if btnp(5) and selektor ==-1 then
  scene=5
  set_players()
  scenetimer=300
  sfx(30)
  make(stage)
 end
end
function mbset()
 return {{128,2,"2pLAYER",1},{128,64-6,"vS. cPU",1},{128,128-12,"",2}}
end
function bg4()
 cls(15)
 for i = 0,128 do
 --line(i,128,i,48+sin(i/283.54)*7+sin(i/3.34)*2,15)
 gx = sin(i/127)*7+sin(i/30)*2+78
 line(i,gx,i,64+sin(i/283.54)*7+sin(i/3.34)*2,11)
 line(i,128,i,gx,6)
 end
end
-->8
--main game
function game()
 
 t+=1
 timer -=1
 --if timer <= 0 then
 -- tscale *=2
 -- timer = 128
 --end
 tscroll[1] = -(players[1].x+players[2].x)/2+64
 tscroll[2] = -(players[1].y+players[2].y)/2+64
 
-- tscroll[1] = -(players[1].x+players[2].x+players[3].x+players[4].x)/4+64
-- tscroll[2] = -(players[1].y+players[2].y+players[3].y+players[4].y)/4+64
 
 tscroll[2] = mid(-16-tscale*70,32,tscroll[2])
 
 scroll[1] += (tscroll[1]-scroll[1])/3
 scroll[2] += (tscroll[2]-scroll[2])/3
 dist = distance(players[1].x,players[1].y,players[2].x,players[2].y)
-- distf = dist<8
-- if distf then
--  tscale = 100
-- else
  tscale = 75/distance(players[1].x,players[1].y,players[2].x,players[2].y)
  if dist < 8 then
   if abs(players[1].x-players[2].x)<16 and abs(players[1].y-players[2].y)<16 then
   	tscale = maxscale
   else
   tscale = 0.45
   end
  end
  if tscale <0.4 then
   tscale = 0.4
  else
   tscale = mid(2,tscale,0.4)
  end
-- end
-- if tscale > 10 then
--  tscale = 0.5
-- end
 scale += (tscale-scale)/5
 --scale = tscale
 --scale*=1.001
 for i =1,#players do
 players[i].punchcooldown -=1
 me = players[i]
 me.sjtimer = max(me.sjtimer-1,-10)
 me.ljtimer = max(me.ljtimer-1,-10)
 if me.sjtimer >= 0 then
  hgf=20
  jjj=2
  add(particles,{me.x,me.y,0,rnd(4)+2,sin(me.sjtimer/hgf)*jjj,cos(me.sjtimer/hgf)*jjj/2,0})
  add(particles,{me.x,me.y,0,rnd(4)+2,sin(me.sjtimer/hgf+0.5)*jjj,cos(me.sjtimer/hgf+0.5)*jjj/2,0})
 end
 if me.ljtimer <=0 and me.ljtimer >=-5 and me.bt[5] then
  me.sy = -3+min(me.kb,10)/20
  me.hit=15
  me.sjtimer=10
  sfx(35)
  me.ljtimer = -10
  if me.bt[1] then
   me.sx = -3
  elseif me.bt[2] then
   me.sx = 3
  end
 end
 
 if fget(mget(round(me.x/8),round(me.y/8)),6) then
  me.sx +=0.5
 end
 if fget(mget(round(me.x/8),round(me.y/8)),7) then
  me.sx -=0.5
 end
 me.spmove +=1
 me.hit -=1
 me.grounded=false
 me.dropdown-=1
 l=0.3
 if me.hit>0 then
 l=0.05
 end
 if me.bt[1] then
  players[i].sx -=l
  me.side = -1
 end
 if me.bt[2] then
  players[i].sx +=l
  me.side = 1
 end

 d=0
 if me.sx > 0 then
  d = 1
 else
  d=0
 end
 if fget(mget(round(me.x/8),round(me.y/8)),0) then
  me.y -=8
 end
 if fget(mget(flr(me.x/8+d),round(me.y/8)),0) then
  me.sx = 0
 end
 if me.btp[6] and not (me.bt[4] or me.bt[3]) and me.punchcooldown < 0 then
  sfx(0)
  me.punchcooldown = 8
  add(hitboxes[i],{players[i].x+4+players[i].side*5,players[i].y+4,9,5,me.side})
 end
 for p= 1,#hitboxes do
  if p !=i and #hitboxes[p]>0 then 
	  for d=1, #hitboxes[p] do
	   if abs(hitboxes[p][d][1]-me.x)<64 and abs(hitboxes[p][d][2]-me.y) < 64 and distance(hitboxes[p][d][1],hitboxes[p][d][2],me.x+4,me.y+3) < hitboxes[p][d][3] then
	    me.sy =-1*(me.kb+8)/8
	    gy = (me.x-hitboxes[p][d][1])
	    me.sx = (gy/abs(gy))*(me.kb+10)/10
	    me.sx = hitboxes[p][d][5]*(me.kb+10)/10
	    me.kb +=0.1*rules.amplifier
	    if me.hit < 0 then
	     sfx(14)
		    if me.kb > 6 then
		    me.kb +=3*rules.amplifier
		    --sfx(5)
		    sfx(6)
		    else
		    me.kb+=1*rules.amplifier
		    end
	    end
	    me.hit = 40+me.kb
	    me.grounded=false
	   end
	  end
  end
 end
 if me.y > 256 then
		rese(me,i)
 end
 if me.y < -96 then
		rese(me,i)
 end
 if me.x < -96 then
		rese(me,i)
 end
 if me.x > 256+96 then
		rese(me,i)
 end
 grounded = false
 me.x += me.sx
 if me.hit > 0 then
 me.sy += 0.08
 else
 me.sy += 0.2
 end
 if me.sy > 4 and not me.falling then
  me.falling=true
  --sfx(5)
 end
 if me.x < 256 then
 if fget(mget(round(me.x/8),(me.y+4)/8-1),0) and me.sy <0 then
  me.sy = 0
  sfx(3)
 end
 if fget(mget(round(me.x/8),me.y/8+1),0) and me.sy > 0 then
  me.sy = 0
  grounded = true
  me.y = flr(me.y/8)*8
  if me.bt[5] then
  me.sy = -3.5
  sfx(3)
  end
  
 elseif fget(mget(round(me.x/8),me.y/8+1),1) and me.sy >= 0 and me.dropdown<0 then
  me.sy = 0
  grounded = true
  me.y = flr(me.y/8)*8
  if me.bt[5] then
  me.sy = -3.5
  sfx(4)
  end
 end
 if grounded then
 me.airmove = false

 end
 if grounded or me.airmove then
  me.grounded=true
  if me.bt[3] and me.btp[6] then
   me.sx += me.side*2.5
   me.sy = -1
   me.hit=40
   me.ljtimer = 40
   sfx(0)
   add(hitboxes[i],{players[i].x+4+players[i].side*5,players[i].y+4,5.5,35,me.side})
   grounded=false
   sfx(17)
   me.airmove=false
   
  end
 if (me.bt[4] and me.btp[6]) or me.performmove == 2 then
   me.sy = -4
   me.spmove=0
   me.hit=40
   me.sjtimer = 40
   sfx(0)
   add(hitboxes[i],{players[i].x+4,players[i].y+2,5.1415 ,35,me.sx/8})
   add(hitboxes[i],{players[i].x+4,players[i].y-7,7,35,me.sx/8})
   grounded=false
   sfx(18)
   me.airmove=false
  end
 end
 end
  if me.btp[4] and me.spmove > 20 then--and then--not (me.hit>0) then
   me.sy = max(3,me.sy)
   --grounded=false
   me.dropdown=5
  end
  if me.hit < 0 then
  if grounded then
  me.sx *=0.875
  else
  me.sx *=0.925
  end
 else
  lx = flr((me.x+me.sx*4)/8)
  ly = flr((me.y+me.sy*4)/8) 
  rx=flr(rnd(3)-1)
  ry=flr(rnd(3)-1)
  if fget(mget(round(lx+rx/4),flr(ly+ry/2)),2) then
   mset(round(lx+rx/4),flr(ly+ry/2),38)
   sfx(16)
   for i = 0,8 do
   add(particles,{lx*8+rnd(8),ly*8+rnd(8),0,rnd(16)+16,rnd(2)-1,rnd(2)-1,1})
   end
   glassbreak+=1
  end
  me.sx *=0.99
  if rnd(5) > 4 then
   add(particles,{me.x,me.y,0,rnd(16)+16,rnd(0.5)-.25,rnd(0.5)-0.25,0})
  end
 end
 me.y += me.sy
 if not grounded then
  if not me.bt[5] and me.hit<=0 then
   players[i].sy = max(0.4,players[i].sy)
  end
 else
  if me.hit>=0 then
   sfx(5,-2)
   me.hit=0
  end
  me.grounded = grounded
 end
 if me.lives<=0 then
  scene=1
  --music(3)
  winner = i+1
  if winner==3 then
   winner=1
  end
  timer=40
 end
 end
 for p= 1,#hitboxes do
  if p !=i and #hitboxes[p]>0 then 
	  lest = {}
	  for d=1, #hitboxes[p] do
				hitboxes[p][d][1] += players[p].sx*0.95
				hitboxes[p][d][2] += players[p].sy*0.95
				hitboxes[p][d][4] -=1
				if hitboxes[p][d][4] >0 then
				 add(lest,hitboxes[p][d])
				end
	  end
	  hitboxes[p]=lest
  end
 end
 lest = {}
 for p= 1,#particles do
	  --if particles[p][4] != nil then
			particles[p][4] -=1
			particles[p][1]+=particles[p][5]
			particles[p][2]+=particles[p][6]
			if particles[p][7] == 1 then
			 particles[p][6] += 0.04
			end
			if particles[p][4] >0 then
			 add(lest,particles[p])
	  end
  --end
 end
 particles = lest
end
-->8
--main game draw
function drawgame()
 --bg1()
 colomap = {4,2,}
 if stage==1 then
 bg1()
 elseif stage==2 then
 cls(10)
 elseif stage==4 then
 bg4()
 else
  if dos then
   cls(1)
   circfill(64,30,16,7)
  else
   cls(12)
  end
  line(0,64+48,128,64+48,13)
   for i=0,1 do
  pset(rnd(8)+64-4,rnd(16)+128-16,7)
 end
 for i=0,12 do
  pset(rnd(48)+64-24,rnd(10)+128-11,7)
 end
 for i=0,10 do
  pset(rnd(96)+64-96/2,rnd(8)+128-10,7)
 end
 for i=0,5 do
  pset(rnd(128),rnd(6)+128-9,7)
 end
 end
 --cls(10)
 --rectfill(0,96,128,128,14)
 --if true then
 for x=0,48 do
  for y=0,32 do
   --xb=(x*8-64+scroll[1])*scale+64
   --xb = flr(xb)
   --yb=(x*8-64+scroll[1])*scale+64
   --xb = flr(xb)
--   yb=
   --if  xb> -8*scale and xb < 128 then
	   height=0
	   tilegot = mget(x,y)
	   if tilegot != 0 then
	   colo=4
	   height=8
	   if tilegot == 3 then
	   colo=2
	   height=1
	   elseif tilegot == 7 then
	   colo=3
	   elseif tilegot == 23 then
	   colo=2
	   elseif tilegot == 22 then
	   colo=14
	   elseif tilegot == 21 then
	   colo=14
	   rectfill(xtran(x*8),(y*8-64+scroll[2])*scale+64,xtran(x*8)+8*scale,(y*8-64+scroll[2]+height)*scale+64,colo)
	   colo=2
	   height=1
	   elseif tilegot == 4 then
	    colo=7
	    height=7
	    rect(xtran(x*8),(y*8-64+scroll[2])*scale+64,xtran(x*8)+scale*7.5,(y*8-64+scroll[2]+height)*scale+64,colo)
  
     height=0
	   elseif tilegot == 38 then
	    height=0
	   elseif tilegot == 42 then
	   colo=5
	   rectfill(xtran(x*8),(y*8-64+scroll[2])*scale+64,xtran(x*8)+scale*8,(y*8-64+scroll[2]+height)*scale+64,colo)
	   colo=2
	   height=1--
	   elseif tilegot == 47 then
	   colo=5
	   rectfill(xtran(x*8),(y*8-64+scroll[2])*scale+64,xtran(x*8)+scale*8,(y*8-64+scroll[2]+height)*scale+64,colo)
	   colo=7
	   height=1
	   elseif tilegot == 41 then
    colo=6
    elseif tilegot == 40 then
    colo=5
    elseif tilegot == 46 then
    colo=7
    elseif tilegot == 16 or mget(x,y) == 32 then
	    height=0
	   end
	   if height>0 then
	   drx = (x*8-64+scroll[1])*scale+64
	   dry = (y*8-64+scroll[2])*scale+64
	   dodraw = (drx + 8*scale > 0) and (drx < 128)
	   dodraw = dodraw and (dry + height*scale > 0) and (dry < 128)
	    if dodraw then
	    rectfill(drx,dry,drx+8*scale,dry+height*scale,colo)
     end
    end
   -- sspr(16,0,8,8,(x*8-64+scroll[1])*scale+64,(y*8-64+scroll[2])*scale+64,(x*8-64+scroll[1]+8)*scale+64,(y*8-64+scroll[2]+8)*scale+64)
	  end 
	  --end 
  end
 end
 --end
 
 for i= 1,#particles do
   --circfill(xtran(particles[i][1]),ytran(particles[i][2]),particles[i][3]*scale,7)
   --color(0)
   if particles[i] != nil then
   if particles[i][7] == 1 then
    sspr(56,16,8,8,(particles[i][1]-64+scroll[1])*scale+64,(particles[i][2]-64+scroll[2])*scale+64,8*scale/2,8*scale/2)
    --pset((particles[i][1]-64+scroll[1])*scale+64,(particles[i][2]-64+scroll[2])*scale+64,7)
   else
   sspr(24,8,8,8,(particles[i][1]-64+scroll[1])*scale+64,(particles[i][2]-64+scroll[2])*scale+64,8*scale,8*scale)
   end
   end
 end
 if rnd(3)>2 then
 --rect(xtran(-48),ytran(-48),xtran(256+48),ytran(256-16),8)
 --rect(xtran(-64),ytran(-64),xtran(256+64),ytran(256),8)
 end
 --map()
 sspr(8,0,8,8,(players[1].x-64+scroll[1]+4.5)*scale+64-(4*scale*players[1].side),(players[1].y-64+scroll[2])*scale+64,8*scale*players[1].side,8*scale)
 sspr(8,16,8,8,(players[2].x-64+scroll[1]+4.5)*scale+64-(4*scale*players[2].side),(players[2].y-64+scroll[2])*scale+64,8*scale*players[2].side,8*scale)
-- sspr(8,16,8,8,(players[3].x-64+scroll[1]+4.5)*scale+64-(4*scale*players[3].side),(players[3].y-64+scroll[2])*scale+64,8*scale*players[3].side,8*scale)

-- sspr(8,16,8,8,(players[3].x-64+scroll[1]+4.5)*scale+64-(4*scale*players[3].side),(players[3].y-64+scroll[2])*scale+64,8*scale*players[3].side,8*scale)
-- sspr(8,16,8,8,(players[4].x-64+scroll[1]+4.5)*scale+64-(4*scale*players[4].side),(players[4].y-64+scroll[2])*scale+64,8*scale*players[4].side,8*scale)

 for i= 1,#hitboxes do
  for d=1, #hitboxes[i] do
   if hitboxes[i][d][3] != 5.1415 then
    circfill(xtran(hitboxes[i][d][1]),ytran(hitboxes[i][d][2]),hitboxes[i][d][3]*scale,7)
   end
  end
 end

 spr(5,(players[1].x-64+scroll[1]+4)*scale+64-4,(players[1].y-64-1+scroll[2])*scale+64-8)
 spr(6,(players[2].x-64+scroll[1]+4)*scale+64-4,(players[2].y-64-1+scroll[2])*scale+64-8)
 for i=0,9 do
  line(32,128-16+i,48,128-20+i,2)
 end
 
 for i=0,9 do
  line(128-48,128-16+i,128-32,128-20+i,13)
 end
 o=0
 for i=1,#tostr(flr(players[1].kb)) do
  spr(48+tostr(flr(players[1].kb))[i],26+8*i,128-16)
  o+=8
 end
 spr(58,34+o,128-16)
 o=0
 for i=1,#tostr(flr(players[2].kb)) do
  spr(48+tostr(flr(players[2].kb))[i],74+8*i,128-16)
  o+=8
 end
 spr(58,82+o,128-16)
 print(players[1].lives,36,128-6,7)
 print(players[2].lives,84,128-6,7)

 if gotimer and gotimer < 60 then
  sspr(64,48,48,16,64-24,64-8)
  gotimer +=1
 end
 if stage == 4 then
 for i = 0,30 do
 
  ggx = i*12.34234
  if sin(i*324.134) > 0.342 then
   ggx *= ggx
  end
  ggy = flr(ggx/128)*128
  ggx -= ggy
  ggy *= (1/128)*14.34234
  ggx -=t*0.5
  ggy += t * 1.617
  ggx -= flr(ggx/128)*128
  ggy -= flr(ggy/128)*128
  ggx += rnd(6)-3
  ggy += rnd(6)-3
  pset(ggx,ggy)
 end
 end
end
function bg1()
 pal(12)
  cls(12)
  glx = 7
 if dos then
 glx = 6
  pal(12,128+12,1)
  cls(1)
  color(0x21)
  fillp(-24155)
  circfill(64,90,90+sin(vt/4-0.25)*1.25)
  fillp()
  circfill(64,90,80+sin(vt/4-0.2)*1.25,2)
  color(0x92)
  fillp(-24160)  
  circfill(64,100,74+sin(vt/4-0.15)*1.25)
  fillp()
  circfill(64,100,64+sin(vt/4-0.1)*1.25,9)
  color(0x79)
  fillp(-24160)   
  circfill(64,90,40+sin(vt/4-0.05)*1.25)
  fillp()
  circfill(64,90,32+sin(vt/4)*1.25,7)
 end
 klr7 = 5
 for i = 0,127 do
  line(i,128,i,64+8+sin(i/60)*3+sin(((i+70)/120))*15,klr7)
 end
 for i = 0,127 do
  if sin(((i+70)/120)) <-0.6 then
   j = 64+8+sin(i/60)*3+sin(((i+70)/120))*15
   line(i,max(64+sin(i/30)*3,j),i,j,glx)
  end
 end
 klr7 = dos and 1 or 11
 for i = 0,127 do
  line(i,128,i,64+16+sin(i/2.3)+sin(i/50)*3+sin(((i+0.54)/90))*3,klr7)
 end
 klr7 = dos and 11 or 3
 for i = 0,127 do
  line(i,128,i,64+32+sin(i/3.545)*1+sin(-i/45)*4+sin((i/100))*5,klr7)
 end
 for i = 0,127 do
  line(i,128,i,64+32+16+sin(i/150)*3,12)
 end
 if dos then
  for i= 0,160 do
   if rnd(8)>7 then
    pset(64+sin(i/80+vt/5)*i*0.2,128-i/10,7+flr(rnd(2))*2)
   end
  end
  for i= 0,160 do
   if rnd(10)>9 then
    pset(64+sin(i/80+vt/5+0.3)*i*0.4,128-i/10,7+flr(rnd(2))*2)
   end
  end
 else
	 for i=0,1 do
	  pset(rnd(8)+64-4,rnd(16)+128-16,7)
	 end
	 for i=0,12 do
	  pset(rnd(48)+64-24,rnd(10)+128-11,7)
	 end
	 for i=0,10 do
	  pset(rnd(96)+64-96/2,rnd(8)+128-10,7)
	 end
	 for i=0,5 do
	  pset(rnd(128),rnd(6)+128-9,7)
	 end
 end
 --pal(6)
 if dos then
  //pal(7,13,1)
 end
 sspr(96,0,32,16,t/10-flr(t/(200*10))*200-32,0)
 sspr(64,0,32,16,t/17-flr(t/(200*17))*200-32,32)
 sspr(96,0,32,16,t/13-flr(t/(200*13))*200-32,64)
 --pal(6)
end
function bg3()
 cls(12)
end
-->8
--make level
function make(pop)
 --print(levels[pop])
 for i = 1,#levels[pop] do
  for d = 1,#levels[pop][i] do
   mset(i,d,levels[pop][i][d])
  end
 end
end
-->8
--cpu
function goleft()
 me.bt[1] = true
 me.bt[2] = false
end
function goright()
 me.bt[2] = true
 me.bt[1] = false
end
function cpup(a,b,d)
 if rnd(10)>d then
	 me=players[a]
	 it=players[b]
	 me.performmove = 0
	 if (me.obst == nil) then
	  me.obst=false
	 end
	 me.bt={false,false,false,false,false,false}
	 me.btp={false,false,false,false,false,false} 
  if me.y < 32 then
   me.btp[4] = true
  end	
	 if me.grounded and d == 0 and it.y < me.y-40 and me.y > -20 and rnd(3)>2 then
	  me.btp[6] = true
	  me.bt[4] = true
	  me.performmove = 2
	  me.airmove = true
	  return
	 end
	   pl=1
	  if not me.grounded then
	   pl *=2
	  end
	 if it.x>me.x+4 then
	  m=false
	
	  for ji = 1,10 do --
	   m= m or groundcheck(round((me.x+me.sx*10*pl)/8)+1,round(me.y/8)+ji)
	  end
	  if m then
	   goright()
	  else
	   goleft()
	  end
	 elseif it.x<me.x-4 then
	  m=false
	  for ji = 1,10 do
	   m= m or groundcheck(round((me.x+me.sx*10*pl)/8)-1,round(me.y/8)+ji)
	  end
	  if m then
	   goleft()
	  else
	   goright()
	  end
	 end
	 if me.grounded then
	  if fget(mget(round(me.x/8)+me.side,round(me.y/8)),2) then
	   me.btp[6] = true
	   me.bt[3] = true
	   me.bt[5] = false
	  end
	  
	  if (abs(me.x-it.x)< 16 and it.y>me.y ) or (rnd(20)>18) then
	   me.btp[4] = (rnd(2)>1)
	   if me.x > 0 then
	    goleft()
	   else
	    goright()
	   end
	   --me.bt[4
	  end
	  --if me.obst then
	  me.obst=false
	  --end
	  if groundcheck(round((me.x+me.sx*10)/8)+me.side,flr(me.y/8)) then
	   me.bt[5] = true
	   me.obst=true
	  end
		 if it.y+10<me.y  then
		  if rnd(4)>3 then
		  me.btp[5] = true
		  end
		  --if abs(me.x-it.x)<10 then
		  --me.btp[6]=true	  
		  --end
		  --me.btp[6] = true
		 --elseif it.y<me.y then
		 
		  me.btp[6]=true
		 -- me.bt[4] = true
		  --me.btp()
		 end
		 
	 else
		 if it.y==me.y or me.obst then
		 
		  me.bt[5] = true
		 end  
		 if me.y>it.y then
		  me.bt[5] = true
		 end
	 end
	 if me.hit>0 then
	  if me.x>128 then
	   goleft()
	  else
	   goright()
	  end
	 end
	 if abs(me.x-it.x) < 6 and abs(me.y-it.y) < 6 then
	  if me.hit>0 then
	  if rnd(6)>5 then
	  me.btp[6] = true
	  end
	
	  else
	  if me.x > 128 then
	   me.bt[1] = true
	  else
	   me.bt[2] = true
	  end
	  me.btp[6] = true  
	  end
	 end
	 if me.grounded then hf = -256 else hf = -64 end
	 if me.x < hf then
	  goright()
	 end
	 if me.x >256-hf then
	  goleft()
	 end
	 if me.y<32 then
	  if me.x>128 then
	   goleft()
	  elseif me.x<128 then 
	   goright()
	  end
	 end
	 --if me.hit then
	  --if me.y < 32 then
	  --me.bt[1] = false
	  --me.bt[2] = false
	  --if- me.x > 128 then
	  -- me.bt[1] = true
	  --else
	  -- me.bt[2] = true
	  --end
	  --end
	 --end
	 if me.x > 128+32 and me.sx > 3 then
	  goleft()
	 end
	 if me.x < 128-32 and me.sx < -3 then
	  goright()
	 end 
	 for i=1,#me.bt do
	  me.bt[i] = me.bt[i] or me.btp[i]
	 end
	 if it.y < me.y then
	  me.bt[5] = true--
	 end
 end
end
__gfx__
0000000000222220444444444444444406666660008880800ddd0dd0333333330000000000000000000000000000000000000000000000000000000000000000
0000000002888880455555540000000060007706008080800d0d000d355555530000000000000000000000000000000000000000000000000000000000000000
0070070002616610454444540000000060077006008880800ddd00d0353333530000000000000000000000000000000000000000000000000000677600000000
0007700002666660454444540000000060770006008000800d000ddd353333530000000000000000000000700000000000000760760000006777700777760000
00077000026611604544445400000000677000060000000000000000353333530000000000000000060000777777700000000077677777777006777777670060
00700700552222254544445400000000670000060080008000d000d0353333530000000000000060007777776777700000000006776007700677600606770000
000000005222222545555554000000006000000600080800000d0d00355555530000000006000000077777676777770000600060067777777760060000067000
0000000002200220444444440000000006666660000080000000d000333333330000006000777067766677777777770000060000060660600006066666600060
00000000055555501111111100505050000090004444444422222222222222220000006666777777777767776666777000000000666700077776600000066000
0000000005b55b5015555551005f5500000999000000000021111112255555520000006666777666777776677777777000000006000666666060000000000000
00009000055555501555555105f5f5050099a9902122221221222212252222520000067667777766667777776776677000000000000000000000000000000000
0000090005bbbb50155555515f5fff55099aaa992122221221222212252222520000000766766677777766666666670000000000006000600000000000000000
00999990055555501555555105f555500099a9902122221221222212252222520000000066667677666666070066670000000000000600000000000000000000
0000090005bbbb5015555551555f5f50000999002122221221222212252222520000000000666666676660000006660000000000060060000000000000000000
0000900005b5bb501555555105055550000090002111111221111112255555520000000006000066000007000000060000000000000000000000000000000000
0000000005b5bb501111111100005000000000002222222222222222222222220000000000000000000000000000000000000000000000000000000000000000
00000000001111100000000000000000000000007777770005555550770000005555555566666666444444440111000001110000011100007777777777777777
0000000001ddddd0000000000000000000000000777777005007700576700000511111156555555600000000188710001dd71000111110007555555700000000
0009000001626620000000000005550000000000770000005070007570670000515555156566665651555515188810001ddd1000111110007577775751555515
0090000001666660000000000555f55000000000777770005700070570067000515555156566665651555515188810001ddd1000111110007577775751555515
099999000166226000000000005ff500000000000777770050000075760777005155551565666656515555150111000001110000011100007577775751555515
009000005511111500000000055f5550000000000000770050700005777000005155551565666656515555150000000000000000000000007577775751555515
00090000511111150000000000555500000000007777700057007005000000005111111565555556511111150000000000000000000000007555555751111115
00000000011001100000000000000000000000000000000005555550000000005555555566666666555555550000000000000000000000007777777755555555
07777000007700000777700007777000000770007777770007777000777777000777700007777000707000000333033300000000000000000000000000000000
77777700077700007777770077777700007770007777770077777700777777007777770077777700007000000303000300000000000000000707070007070700
77007700777700000007770070077700077770007770000077000000000077007700770077007700070000000333033300000000000000000770707007777770
77007700077700000077770000777700770770007777700077777700000077000777700077777700700000000300000300000000000000000700007007777770
77007700077700000777000070077000777770000007770077007700000770007700770000007700707000000000033000000000000000000700007007777770
77777700077700007777770077777700000770007777770077777700007700007777770077777700000000000030003000000000000000000700007007777770
07777000777770007777770007777000077777007777700007777000077000000777700007777000000000000003030000000000000000000777777007777770
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000300000000000000000000000000000000000
00000000000000000000077777000000000000000000000000000000000000000000000000000000000007770000000000000000000000000000000000000000
00077777700000000000777777000000000000000000000000770000000000000000000000000000000077770000000000000000000000000007700000000000
00777777777700000000777777000000000000000000000000777000000000000000777777700000000777777000000000007777777000000007770000000000
00777777777770000000077777000000000000000000000000777000000000000007777777700000000077777000000000777777777700000077770000000000
00777000777770000000000000000000077700000000000000777077770000000077777777700000000000000000000000777700777700000077770000000000
00770007777770000000777000000000077700000000000000777077777000000077777777700000000000000000000000777007777700000077770000000000
00777777777700000000777777000000077777777770000000777777777000000077777770000000000777700000000000777777777700000077777777000000
00777777770000000000077777000000077777777770000000777777770000000777777000000000000777777000000000077777777700000077777777000000
00777777777000000000777777000000077777777777000000777777700000000777777000000000000777777000000000000000777700000077777777700000
00777777777770000000777770000000077777777777000000777777770000000777777777700000000777770000000000000000777700000077777777700000
00777707777770000000777770000000077777077777000000777777777000000777777777700000000777770000000000000000777700000077777777700000
00777000777770000000777770000000077777007777000000777777777000000077777777700000000777770000000007000077777700000777770077770000
00077777777700000000777770000000077777007777700000777777777000000077770000000000000777770000000007777777777700000777770007770000
00077777770000000000077770000000077777007777000000777707777000000077770000000000000077700000000007777777777000000777770007770000
00077777000000000000077770000000077777000770000000777000770000000077770000000000000000000000000000777777700000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000770000000000000000000000000000000000000000000000000000000000000000000000000000007777700000000007000000000000000000000000000
00000770000000000000000000000000000000000000000000000000000000000000007777777000000077777777000000777000000000000000000000000000
00007770000000000000000000000000000000000000000000000000000000000000777777777700000077777777700000777000000000000000000000000000
07777777770000000007777777700000077770000000000000000000000000000000777700777700000777777777770000777000000000000000000000000000
07777777770000000007777777770000077770000000000000000000000000000000777007777700007777777777777000777000000000000000000000000000
07777777770000000007700007770000077777770777700000000000000000000000777777777700007777700077777000777000000000000000000000000000
07777777000000000000000000777000777777777777770000000000000000000000077777777700007777700077777000077000000000000000000000000000
00007777000000000007777777777700777777777777770000000000000000000000000000777700007777707777770000000000000000000000000000000000
00007777000000000077777777777700777777777777777000000000000000000000000000777700007777777777770000000000000000000000000000000000
00007777707700000077777777777700777777777777777000000000000000000000000000777700007777777777700000000000000000000000000000000000
00007777777770000077770007777700777700777700777000000000000000000007000077777700000777777777700000777000000000000000000000000000
00007777777770000077777777777770777700077000077000000000000000000007777777777700000077777777000000777000000000000000000000000000
00000777777700000077777777777770777000077000077000000000000000000007777777777000000007777770000000770000000000000000000000000000
00000077777700000007777777777770777000007000077000000000000000000000777777700000000000000000000000000000000000000000000000000000
00000000000000000000000000007770000000000000077000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000aaaaa0000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000aaaaaaa000000000000000000000000000000000000
000000000000000000000000000000bbbbb000000000000000000000000000000000000000aaaaaa000aaaaaaaaa000000000000000000000000000000000000
0000000000000000000000000000bbddddbb000000000000000000000000000000000000aaaaaa7aaaaaaaaaaaaa000000000000000000000000000000000000
00000000000000000000000000cbb61ddddbb0000000000000000000000000000000000aaaaaa7777aaaaaaaaaaa000000000000000000000000000000000000
000000000000000000000000cccb66616616b000000000000000000000000000000000aaaaaa777776aaaaaaaaaa000000000000000000000000000000000000
000000000000000000000000cccbb6666166bbc0000000000000200000000000000000aaaa777776166aaaaaaaa0000000000000000000000000000000000000
000000000000000000000000ccbcbbbb66bbbbcc000000000002222220000000000000aaa77777661667aaaaaaa0000000000000000000000000000000000000
000000222200000000000000cbcbcbcbbbbbbbcc000000000002822222000000000000a7777766666776aa77aa00000000000000000000000000000000000000
000002222222000000000000bbbcbcbcbcbcbccc000000555522882222200000000000aa7761116616777577aa00000000000000000000000000000000000000
00002222222220055550000bbbbbcbcbcbcbcbc000055555552688282220000000000aaa7666666176a7777aaa00000000000000000000000000000000000000
0002282828885255555200bbbbbbbcbbbcbccbb0005555555221688882220000000aaaaa666666667a7777777aa0000000000000000000000000000000000000
000288888885662555255bbbbbbbbbbbbcccbbbb055555555261666666220000000aaaaa6666667777777777a5aa000000000000000000000000000000000000
002555555551165552555bbbbbbbb000bbbbbbbb05555555526661116662200000aaaaaa6666aaa577777777555a000000000000000000000000000000000000
002661111611665005555000000000000bbbbbbb05555555226166666662200000aaaaaaaaaa57777777a757555aa00000000000000000000000000000000000
00266666166616200055500000000000000000000555555025221666666220000aaaaaaaa5a577a5a777777775aaa00000000000000000000000000000000000
05566616666666620000000000000000000000000000000022522222222220000aaaaa0a5a5a5a5a777777a77aaaa00000000000000000000000000000000000
55526666611662220000000000000000000000000000000225252522255555000aaaaa0aa5a5a5a775a7575577aa000000000000000000000000000000000000
5552222616662222200000000000000000000000000000225252522255555550aaaaa000aa5a5a5a5aa7577aaaa0000000000000000000000000000000000000
5225252222222525200000000000000000000000000000252225252555555550aaaaa000a5a5a5a5a557557aaaa0000000000000000000000000000000000000
2555225252525252520000000000000000000000000022255222222255555550aaaaa0000aaa5a5aa55555aaaaa0000000000000000000000000000000000000
55552225252525252522200000000000000000000002255555222222225555000aaaa00000aaa5a5555555aaaaa0000000000000000000000000000000000000
555525522222225555222000000000000000000000022555222202255222200000aaa000000aaaa5555555aaaaa0000000000000000000000000000000000000
052255552200225522220000000000000000000000002222222000225555200000000000000000aaaa5555aaaaa0000000000000000000000000000000000000
002225552000022222000000000000000000000000000222222200022222200000000000000000000aaaaaaaaa00000000000000000000000000000000000000
00222225200000220000000000000000000000000000002222220000222222000000000000000000000000000000000000000000000000000000000000000000
00222222000000000000000000000000000000000000000222220000000222000000000000000000000000000000000000000000000000000000000000000000
00222000000000000000000000000000000000000000000022000000000002000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000010205000001000000000000000040000100000200010000000000000000800000000000000000010200000001020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000404000000000000000000000000000000000000040400000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000404000000000000000000000000000000000000040400000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000404000000000000000000000000000000000000040400000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000404000000000000000000000000000000000000040400000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000404000000000000000000000000000000000000040400000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000003030307070703030303030707070303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040400000000000000000000000000000000000004040000000000000000000000000000000000002f2f29292f2f00000000000000000000000000
0000000000000000000000070207000000000007020700000000000000000000000000000000000000000000000000161616161616000000000000000000000000000000000404000000000000000000000000000000000000040400000000000000000000000000000000000000282929280000000000000000000000000000
0000000000000000000000070707000000000007070700000000000000000000000000000000000000000000161616161616161616160000000000000000000000000000000404000000000000000000000000000000000000040400000000000000000000000000000000000000282929280000000000000000000000000000
000000000000000000000000000003030303030000000000000000000000000000000000000000000016161616161616161616161616161616000000000000000000000000040400000000000000152a2a1500000000000000040400000000000000000000000000000000000000282929280000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000001616161616161616161616161616161616161616000000000000000000000404000000000000001628281600000000000000040400000000000000000000000000000000000000282929280000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000016161616161616161616161616161616161616161616000000000000000000040400000000000000162828160000000000000004040000000000000000000000000000002f2f2f2f2f2f2f2f2f2f2f2f00000000000000000000
0000000000000000030303070707030303030307070703030300000000000000000000001616161616161616161616161616161616161616161616160000000000000000000404000000000000001517171500000000000000040400000000000000040400000000000000282828282828282828280000000000000004040000
0000000000000000000000070207000000000007020700000000000000000000000016161616161616161616161616161616161616161616161617171717000000000000000404000000000000001617171600000000000000040400000000000000040400000000000000002828282828282828000000000000000004040000
0000000000000000000000070207000000000007020700000000000000000000000016161616161616161717171715151515171717171515151517171717000000000000000404000000000000001617171600000000000000040400000000000000040400000000000000000028282828282800000000000000000004040000
00000007070707070707070702070707070707070207070707070707070707070016171717171515151517171717161600001717171700000016171717171600000000000004040000000000000015040415000000000000000404000000000000000404000000002f2f2f2f2f2f2f29292f2f2f2f2f2f2f0000000004040000
0000000002020202020202020202020202020202020202020202020202020000001617171717161616001717171700000000171717170000000017171717160000000000000404000000000000001604041600000000000000040400000000000000040428000000002828282828282929282828282828000000002804040000
0000000000000020020202020202020202020202020202020202020202000000001617171717161600001717171703030303171717170303030317171717160000000000002904000000000000001604041600000000000000042900000000000028292928282828282828282828282929282828282828282828282829290000
0000000000000020020200000202020202020202020202020202020000000000001617171717030303031717171700000000171717170016161617171717160000001515152929292929292929292929292929292929292929292915151500000028292929282828282828282828282929282828282828282828282929292800
0000000000002020020200000000020202020202020202020200000000000000001617171717000000001717171716161616171717171616161617171717161600000016162917171717171717171717171717171717171717172916160000000028292929292929292929292929292929292929292929292929292929292828
0000000000002020020200000000020202020202020202020000000000000000001617171717000016161717171716161616161616161515151517171717161600000016162917171717171717171717171717171717171717172916160000000028292929292929292929292929292929292929292929292929292929292800
0000000000002020020202000000000202020202020202000000000000000000001617171717151515151616161616161616161616161616161617171717161600001515151717171717171717171717171717171717171717171715151500000028292929292929292929292929292929292929292929292929292929292800
0000000000002002020202020000000202020202020202000000000000000000001617171717161616161616161616161616161616161616161617171717161600000016161717171717171717171717171717171717171717171716160000000028292929292929292929292929292929292929292929292929292929292800
0000000000002002020202020200000202020202020200000000000000000000001617171717161616161616161616161616161616161616161617171717161600000016161717171717171717171717171717171717171717171716160000000028282929292929292929292929292929292929292929292929292929282800
0000000000002002020202020202000202020202020200000000000000000000001617171717161616161616161616161616171717171515151517171717161600000015151717171717171717171717171717171717171717171715150000000000282829292929292929292929292929292929292929292929292928282800
0000000000002002020202020202020202020202021000000000000000000000000017171717171717171717171717171717171717171717171717171717160000000016161717171717171717171717171717171717171717171716160000000000002829292929292929292929292929292929292929292929292928000000
0000000000002002020202020202020202020202021000000000000000000000000017171717171717171717171717000017171717171717171717171717160000000016161717171717171717171717171717171717171717171716160000000000000029292929292929292929292929292929292929292929292900000000
0000000000000202020202020202020202020202021000000000000000000000000017171717000000001717171700000000171717170000001617171717000000000017171717171717171717171717171717171717171717171717170000000000000029292929292929292929292929292929292929292929292900000000
0000000000000202020202020202020202020202021000000000000000000000000017171717000000001717171700000000171717170000000017171717000000000016171717171717171717171717171717171717171717171717160000000000000029292929292929292929292929292929292929292929292900000000
0000000000000202020202020202020202020202021000000000000000000000000017171717000000001717171700000000171717170000000017171717000000000000161717171717171717171717171717171717171717171716000000000000000029292929292929292929292929292929292929292929292900000000
0000000000000002020202020202020202020202020200000000000000000000000017171717000000001717171700000000171717170000000017171717000000000000000017171717171717171717171717171717171717170000000000000000000029292929292929292929292929292929292929292929292900000000
0000000000000002020202020202020202020202020200000000000000000000000017171717000000001717171700000000171717170000000017171717000000000000000000171717171717171717171717171717171717000000000000000000000029292929292929292929292929292929292929292929292900000000
0000000000000002020202020202020202020202020200000000000000000000000017171717000000001717171700000000171717170000000017171717000000000000000000001717171717171717171717171717171700000000000000000000000029292929292929292929292929292929292929292929292900000000
__sfx__
000100003e620006203e6201962013620106200e6200c620096200762005610056100361002610016100161000610006100000000000000000000000000000000000000000000000000000000000000000000000
000200003f670006603f660006602a6602765024650226501f6501d6501b65019650176501565013650116500f6500e6500d6500b6500a6500965008650076500665005650046400464003630036300262001600
0001000023650216501e6501965013650106500e6500c650096500765005620056200362002620016100161000610006100000000000000000000000000000000000000000000000000000000000000000000000
0001000033620106200a6100a61000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100000265003650046200a61000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a00000463004620076200b620066200c62006630036200a6100761004620026100461009610096300862008610086100a61008620086100261007620076200762007620076300763006630076300862003620
4001000027650046503c650046503f650066503e650036503e640046303d6303e6303f6203f6103f61039610316102b6102661023610206101e6101d6101b610196101661014610116100e6100c6100961009610
001000000505005000050500000005050000000505000000060500000006050060000605000000060500f000000500e0000005027600216500000000050020000205000000020500300003050000000305000000
4310000002650026100260000000236503c60000000000000e650000000e65000000266500000000000000000c6500000000000000001d6500000000000000000c650000000c6500000017650000000000000000
000a00000435004100043500410004350041000435004100043500410004350041000435004100043500410002350021000235002100023500210002350021000235002100023500210002350021000235002100
000a0000306500162000610006000b600096000060000000000000000000000000000000000000000002e6002e670046500065000000000000000000000006002d65004650006500000010650106001065000000
000a000010550000001055000000000000000000000000000000000000000000000000000000000e500000000e550000000e5500000000000000000f5000f5000e5500f5000e5500000000000000000000000000
000a000010550000001055000000000000000000000000000000000000000000000000000000000e500000000e550000000e5500000000000000000f5000f500155500f500155500000000000000000000000000
000400003a6500645034650306502f6502d6502d6402b640296402763025630216301e6201c620196201762016610136100f6100c6100a6100761004610026100161000610006100061000000000000000000000
00010000066701f170101600915001140001400f13008130041300012000120006200b62000620086200061009600006000560000600016000060000000000000000000000000000000000000000000000000000
000100000066002620026200061000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200003e7100b61030660056603065007650316503a6403d6302b630296202762025610206101d6101b6100020001200022000220006600056003e10003600000003510000000000003c100000000000000000
000200003f6703550035660345002c6603350025650315001f6502f500186502e500146402c5000f6402b500096302a500056301d700036200260003620016000262000000026200000001610006000061000000
000200003c6200166032650036500c6500025009650012500e650032500b650052501165008250176500a250136500c250176500f250146501125019650132301e640152201b63017220206201c2102661000000
000200003c6200165032640036500c6500025009650012500e650032500b650052501165008250176500a250136500c250176500f250146501125019650132301e640152201b63017220206201c2102661000000
000200003c6200165032640036500c6500025009650042500e650072500b650022501165005250176500825013650052501765007250146500a25019650062301e640092201b6300c220206200e2102661000000
d01000001f2541a2541f2542125424254262541a25426254232541f2541a2541f254232541a2541f25424254232541a2541c2541e2541a254262541a2541c2541a244172441a2341c2341a224172241521412214
d11000001f2541a2541f2542125424254262541a25426254232541f2541a2541f254232541a2541f25424254232542324423234232242321423214232141c2041a204172041a2041c2041a204172041520412204
011000000c0530c00500000000000c0530000000000000000c0530000000000000000c0530000000000000000c0530c0430c0330c0230c0130c0130c013000000000000000000000000000000000000000000000
0110000013054130541305413054130541305413054130540c0540c0540c0540c0540c0540c0540c0540c0540e0540e0540e05400000000000e054000000e0541305513055130550000000000000000000000000
011000001f7541f7541f7441f7441f7341f7341f7241f724187541875418744187441873418734187241872413754137541374413744137341373413724137211f7511f7541f7540000000000000000000000000
000400001a050120001a020130001a000110001a000110001a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00060000260501a050260501a040260501a030260501a020260401a01026030000002602000000260100000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400000c55010550135501855013550185501c550185501c5501f5501c5501f550235501f55023550265501f54023550265501f52023530265401f50023510265201f50023500265101f500235002650000500
000500001d550215502455021550245502955024550295502d550295502d550305503a500305303a500305103a5003a5003a5003a5003a500265001f50023500265001f50023500265001f500235002650000500
000600000c55010050135501805013550180501c550180501c5501f0501c5501f050235501f05023550260501f54023050265501f02023530260401f50023010265201f50023500265101f500235002650000500
000200000e05010050100500f01000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000f00002f050280502f05028050320502805030050280502f050280502f050280502f05028050270502805000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100001c05305630016200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00030000300202f0212d021290211c021040110000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200003f6501b0503563024050036201e05004650280500465022050046502b0500464025040046402e04005630280400563032030036202c03003620310300262022020026202e02001610260200061000000
__music__
01 090a0b44
00 090a0c44
00 41024344
00 17161819

