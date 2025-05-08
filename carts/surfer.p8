pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
 scroll = {0,0}
 p = {}--preserveObject
 p.x = 0
 p.y = 0
 p.sx = 0
 p.sy = 0
 p.g = 0.1
 p.cd = 0
 ptoward = false
 pangle = 0
 pal(13,128+12,1)
 pal(14,128+1,1)
 clouds = {}
 for i = 0,16 do
  add(clouds,{rnd(256),rnd(256)})
 end
 particles = {}
 bullets = {}
 enemies = {{0,0,0,0,100,0,4}}
 t=0
 p.fuel = 100
end
function _draw()
 cls(12)
 fills = {-1,-2,-1026,-1030,-1286,-1318,31450,31322,23130,23114,6730,6666,2570,2568,520,512,0}
 l = p.y
 if p.y < -100 then
  l -= ceil(l/15000)*15000
 end
 fillp(fills[max(flr(l/600)+20,1)])
 color(0b0000000011011100)
 if p.y < -15000 then
  color(0b0000000000011101)
 end
 rectfill(0,0,128,128)
 fillp()
 h = -p.y/800-5
 h = max(h,0)
 for i = 1,#clouds do
  xx = clouds[i][1] - scroll[1]/3
  yy = clouds[i][2] - scroll[2]/3
  circfill(xx-flr(xx/256)*256-64,yy-flr(yy/256)*256-64,15-h,6)
  --circfill(xx-flr(xx/256)*256-64,yy-flr(yy/256)*256-67,12,7)
 end
 for i = 1,#clouds do
  xx = clouds[i][1] - scroll[1]/3
  yy = clouds[i][2] - scroll[2]/3
  --circfill(xx-flr(xx/256)*256-64,yy-flr(yy/256)*256-64,15,6)
  circfill(xx-flr(xx/256)*256-64,yy-flr(yy/256)*256-67,12-h,7)
 end
 for i = 0,127 do
  --rectfill(0,128-scroll[2],128,128,13)
  h = (i+scroll[1]+t/10)
  line(i,128,i,128-scroll[2]+cos(h/47+t/45.25)*2+sin(h/64)*sin(t/100)+2,13)
  line(i,128,i,512-scroll[2]+cos(h/47+t/45.25)*2+sin(h/64)*sin(t/100)+2,1)
  line(i,128,i,1024-scroll[2]+cos(h/47+t/45.25)*2+sin(h/64)*sin(t/100)+2,14)
  line(i,128,i,2048-scroll[2]+cos(h/47+t/45.25)*2+sin(h/64)*sin(t/100)+2,0)
 end
 for x = 0,15 do
  for y = 0,15 do
   xx = x - scroll[1]/16
   yy = y - scroll[2]/16
   xx *=16
   yy *=16
   xx = xx-flr(xx/128)*128
   yy = yy-flr(yy/128)*128
   c = 0b0000000000011101
   if yy > 128-scroll[2] then
    c = 1
   end
   fillp(fills[max(flr(l/600)+20,1)])
   
   pset(xx,yy,c)
  end
 end
 fillp()
 --spr(1,p.x+64-scroll[1],p.y+64-scroll[2])
 if ptoward then
  xx = 0
  if btn(0) then xx = -1 
  elseif btn(1) then xx = 1 end
  yy = 0
    if btn(2) then yy = -1 
  elseif btn(3) then yy = 1 end
  if abs(xx)+abs(yy) > 0 then
   r = atan2(yy,xx)
   pfa = r
  end
 else
  r = atan2(p.sy,p.sx)
 end
 jj=0
 hx = p.sx*jj
 hy = p.sy*jj
 for i = -10,10 do
  circfill(p.x+64-scroll[1]-hx+sin(r)*i,p.y+64-scroll[2]-hy+cos(r)*i,sin(-i/20-0.2)*2+3,1)
 end

 i = 5
 circfill(p.x+64-scroll[1]-hx+sin(r)*i,p.y+64-scroll[2]-hy+cos(r)*i,sin(-i/20-0.2)*2+1,0)
 if p.y < 64 then
 circfill(p.x+64-scroll[1]-hx+sin(r)*i,p.y+64-scroll[2]-hy+cos(r)*i-1,sin(-i/20-0.2)*2,7)
 for i = -10,10 do
  h = (sin(-i/20-0.2)*2+3)
  if rnd(10)>9.9 then
  circfill(p.x+64-scroll[1]-hx+sin(r)*i,p.y+64-scroll[2]-hy+cos(r)*i-h+rnd(2),0.2,12)
  end
 end
 else
  if p.y > 1024 then
   circfill(p.x+64-scroll[1]-hx+sin(r)*i,p.y+64-scroll[2]-hy+cos(r)*i-1,sin(-i/20-0.2)*2,0)
  else
   circfill(p.x+64-scroll[1]-hx+sin(r)*i,p.y+64-scroll[2]-hy+cos(r)*i-1,sin(-i/20-0.2)*2,13)
  end
 end
 i = -1
 ---circfill(p.x+sin(r)*i-scroll[1]+64,p.y+cos(r)*i-scroll[2]+64,(10-i)*0.3+1)
-- circfill(p.x+sin(r+0.25)*i-scroll[1]+64,p.y+cos(r+0.25)*i-scroll[2]+64,5,1)
-- circfill(p.x+sin(r-0.25)*i-scroll[1]+64,p.y+cos(r-0.25)*i-scroll[2]+64,5,1)

 for i = 1,128 do
  h = (i+scroll[1]+t/10)
  pset(i,128-scroll[2]+cos(h/47+t/45.25)*2+sin(h/64)*sin(t/100),7)
 end
 for i = 1,#enemies do
  for h = -5,5 do
   circfill(enemies[i][1]-scroll[1]+64,enemies[i][2]-scroll[2]+64,8,8)
  end
 end
	for i = 1,#particles do
	 circfill(particles[i][1]-scroll[1]+64,particles[i][2]-scroll[2]+64,particles[i][5],7)
	end
	for i = 1,#bullets do
	 x1 = bullets[i][1]-scroll[1]+64
	 y1 = bullets[i][2]-scroll[2]+64
	 x2 = x1 + sin(bullets[i][6])*10
	 y2 = y1 + cos(bullets[i][6])*10
	 line(x1,y1,x2,y2,9)
	 x3 = x1 + sin(bullets[i][6])*5
	 y3 = y1 + cos(bullets[i][6])*5
	 line(x3,y3,x2,y2,10)
	 x4 = x1 + sin(bullets[i][6])*8
	 y4 = y1 + cos(bullets[i][6])*8
	 line(x4,y4,x2,y2,7)
--	 circfill(,,2,7)
	
	end
	if p.fuel < 100 then
		for i = 1,p.fuel*2 do
		 pset(p.x+64-scroll[1]+sin(i/200)*16,p.y+64-scroll[2]+cos(i/200)*16,8)		end
	end
	
	ddx = 2048-p.x
	ddy = -64-p.y
	if abs(2048-scroll[1]) > 64 or abs(-64-scroll[2]) > 64 then
	 llh = atan2(ddy,ddx)
	 xx = sin(llh)*48+64
	 yy = cos(llh)*48+64
		circfill(xx,yy,3,8)
		line(xx-sin(llh)*4,yy-cos(llh)*4,xx+sin(llh)*4,yy+cos(llh)*4,2)
  line(xx-sin(llh+0.25)*4,yy-cos(llh+0.25)*3,xx+sin(llh)*4,yy+cos(llh)*4,2)
	 line(xx-sin(llh-0.25)*4,yy-cos(llh-0.25)*3,xx+sin(llh)*4,yy+cos(llh)*4,2)
	else
	 circfill(2048+64-scroll[1],-scroll[2],4,8)
	end
end


function _update60()
 for i = 1,#enemies do
  enemies[i][4] += 0.1
  enemies[i][1] += enemies[i][3]
  enemies[i][2] += enemies[i][4]
  if enemies[i][2] > 64 then
   enemies[i][4] -=0.2
  end
 end


 if p.y < -30000 then
  p.sy = -1000
 end
 if btn(4) and p.fuel > 0 then
  agg = atan2(p.sy,p.sx)
  if ptoward then
   agg = pfa
  end
  if btn(0) or btn(1) or btn(2) or btn(3) then
   ptoward = true
  end
  hhh = 0.2
  p.fuel -=0.3
  p.sx += sin(agg)*hhh
  p.sy += cos(agg)*hhh
  add(particles,{p.x-sin(r)*10+rnd(2)-1,p.y-cos(r)*10+rnd(2)-1,rnd(2)-1-sin(agg)*hhh*2+p.sx,rnd(2)-1-cos(agg)*hhh*2+p.sy,rnd(2),10})
 end
 p.cd -=1
 ggg = {}
 for i = 1,#particles do
  particles[i][1] += particles[i][3]
  particles[i][2] += particles[i][4]
  particles[i][4] += 0.1
  if particles[i][2] < 64 or particles[i][4] < 0 then
   add(ggg,particles[i])
  end
 end
 particles = ggg
 ggg = {}
 for i = 1,#bullets do
  bullets[i][1] += bullets[i][3]
  bullets[i][2] += bullets[i][4]
  bullets[i][4] += 0.1
  if bullets[i][2] < 64 and bullets[i][5] > 0 then
   h = true
   for i = 1,#enemies do
    if abs(enemies[i][1]-bullets[i][1]) < 16 then
	    if abs(enemies[i][2]-bullets[i][2]) < 16 then
	     h = false
	    end
    end
   end
   if h then
    add(ggg,bullets[i])
   end
  end
 end
 bullets = ggg
 t+=1
 scroll[1] = p.x
 scroll[2] = p.y
 p.sy += p.g
 if p.y > 64 then
  p.fuel +=1
  p.fuel = min(p.fuel,100)
  ptoward = false
  p.sy -= p.g*3
  p.sx *= 0.99
  if abs(p.sx) > 2 and p.y < 67 and p.sy > 0 and not btn(3) then
   p.sy *=-0.5
   p.sy -=0.5
    p.sx *=0.99
   for i = 0,120 do
    y = rnd(abs(p.sx))*(p.sx/abs(p.sx))
    add(particles,{p.x,p.y,y+rnd(4)-2,-0.25*y+rnd(4)-2,rnd(3)})
   end
  end
  p.sy *=0.99
  if p.y < 70 and p.sy > 1 then
   for i = 0,20 do
    add(particles,{p.x,p.y,-rnd(1)*(p.sx/2)+rnd(2)-1,-rnd(1)*(p.sy/2)+rnd(2)-1,rnd(3)})
   end
  end
  
  if btn(0) then
	  p.sx -= 0.15
	 end
	 if btn(1) then
	  p.sx += 0.15
	 end
else
 if btn(5) then
  --if pfa == nil then pfa = 0 end
  for i = 1,#enemies do
   --hhhhh = atan2(enemies[i][2]-p.y,enemies[i][1]-p.x)
   --if abs(pfa - hhhhh)<0.2 then
    --pfa = hhhhh
   --end
  end
  if p.cd < 0 then
   ptoward = true
	  j = 0.2
      h=0
      if btn(0) then h = -1 
      elseif btn(1) then h = 1 end
      h2=0
      if btn(2) then h2 = -1 
      elseif btn(3) then h2 = 1 end
	  if abs(h)+abs(h2) > 0 then
		  p.sx -= h*j
		  p.sy -= h2*j
		  add(bullets,{p.x+sin(r)*10+p.sx,p.y+cos(r)*10+p.sy,h*5+p.sx,h2*5+p.sy,10,atan2(h2,h)})
	
		  p.cd = 2
	  end
  end
 end
end
 if btn(3) then
  p.sy += 0.1
 end
 p.x += p.sx
 p.y += p.sy
end
__gfx__
00000000000000000007770000011100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000007770000177710000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000700000117110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000077777701777771000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000700000117110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000007700000171710000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000077070001710171000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000070007000100010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
