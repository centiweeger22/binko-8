pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
 particles = {}
 dev = 0.2
 dev2 = 0.1
 t =0
 ra = 0.6
 x = 64
 y = 64
 sx = 4
 sy = 5
 gr = 0.1
end
function _update60()
 x += sx
 y += sy
 sy += gr
 if x > 128-8 and sx > 0 then
  sx *=-1
 end
 if y > 128-8 and sy > 0 then
  sy *=-1
 end
 if x <8 and sx < 0 then
  sx *=-1
 end
 if y <8 and sy < 0 then
  sy *=-1
 end
 add(particles,{x,y,rnd(1),rnd(5),5,128,128})
 add(particles,{x,y,rnd(1),rnd(15),5,0,128})
 add(particles,{x,y,rnd(1),rnd(25),5,128,0})
 add(particles,{x,y,rnd(1),rnd(35),5,0,0})

 cls()
 while #particles > 0 do
  g = {}
	 for i = 1,#particles do
	  me = particles[i]
	  xx = sin(me[3])*me[5]
	  yy = cos(me[3])*me[5]
	  line(me[1],me[2],me[1]+xx,me[2]+yy,7)
	  me[1] += xx
	  me[2] += yy
	  me[3] += rnd(ra)-ra*0.5
	  targetangle = atan2(me[7]-me[2],me[6]-me[1])
	  if abs(targetangle-me[3]) > dev then
	   me[3] = targetangle+rnd(dev2)
	  end
	  me[4] -=1
	  if rnd(1) > 0.8 then
	   add(g,{me[1],me[2],me[3] + rnd(0.5)-0.25,me[4]*0.5,me[5] * 0.8,me[6],me[7]})
	  end
	  if me[4] > 0 then
	   add(g,me)
	  end
	 end
	 particles = g
 end
end
function _draw()
-- cls()

 for i = 1,#particles do
  circfill(particles[i][1],particles[i][2],10)
 end
 circfill(x,y,rnd(12)+4)
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
