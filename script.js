input = document.getElementById("input")
btnDis = document.getElementById("buttons")
output = document.getElementById("output")
canvas = document.getElementById("canvas")
ctx = canvas.getContext("2d")
spriteCanvas = document.getElementById("canvas2")
ctx2 = spriteCanvas.getContext("2d")
drawOffset = {x:0,y:0}
playerButtons = [-1,-1,-1,-1,-1,-1,-1,-1]
resolutionMultiplier = Number(canvas.width)/128
//resolutionMultiplier = 1\1
colors = [[0,0,0],[0,0,100],[100,0,0],[0,100,0],[100,50,50],[100,100,100],[150,150,150],[255,255,255],[255,0,0],[255,100,0],[255,255,0],[0,255,0],[100,100,255],[200,200,255],[255,100,200],[255,205,200],[100,100,100]]
colors2 = [[0,0,0],[0,0,50],[50,0,20],[0,50,50],[50,30,0],[20,20,20],[80,80,80],[255,255,255],[255,0,0],[255,100,0],[255,255,0],[0,255,0],[100,100,255],[200,200,255],[255,100,200],[255,255,200]]
palmap = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
//colors[2] = colors2[2]
r=0
validChars = "qwertyuiopasdfghjklzxcvbnm1234567890_"
fetch("./carts/surfer.p8")
.then(x => x.text())
.then(y => translateCode(y));
function translateCode(inputCode){
    alert(inputCode)
    alert("Splitting: starting")
    inputcode+="\n//{}"
    code = inputCode


    code = code.split("__lua__")[1]
    
    hhh = code.split("__gfx__")
    
    code = hhh[0]
    
    gfxtext = hhh[1]

    hhh2 = inputCode.split("__map__")

    doMap = true
    gfxtext = gfxtext.split("__")[0]
    try{
        maptext = hhh2[1].split("__")[0]
        alert("This is the map"+maptext)
    }
    catch{
        doMap=false
    }

    
    //alert(code)
    alert("Splitting: done")
    alert("Replacements: starting")
    newCode = code
    newCode = newCode.replaceAll("^","**")
    newCode = newCode.replaceAll("]","-1]")
    newCode = newCode.replaceAll(" and ","&&")
    newCode = newCode.replaceAll("while","while (")
    newCode = newCode.replaceAll("elseif ","greequequequeque")
    newCode = newCode.replaceAll("\nif ","\nif (l ")
    newCode = newCode.replaceAll(" if ","if(")
    newCode = newCode.replaceAll("if ","if (")
    newCode = newCode.replaceAll("~=","!= (")
    newCode = newCode.replaceAll("--","//")
    newCode = newCode.replaceAll("{","[")
    newCode = newCode.replaceAll("}","]")
    newCode = newCode.replaceAll("[]//preserveObject","{}")
    newCode = newCode.replaceAll("else","}else{")
    newCode = newCode.replaceAll("greequequequeque","}else if(")
    newCode = newCode.replaceAll("\nend","}")
    newCode = newCode.replaceAll(" end","}")
    newCode = newCode.replaceAll(" then","){")
    newCode = newCode.replaceAll(" or ","||")
    newCode = newCode.replaceAll("not ","!")
    newCode = newCode.replaceAll("end","}")
    newCode = newCode.replaceAll("}_","end_")
    newCode = newCode.replaceAll("⬅️","0")
    newCode = newCode.replaceAll("➡️","1")
    newCode = newCode.replaceAll("⬆️","2")
    newCode = newCode.replaceAll("⬇️","3")
    newCode = newCode.replaceAll("❎","5")
    newCode = newCode.replaceAll("local ","")
    alert("Replacements: done")

    alert("Stray ends: starting")
    newerCode = ""
    newList = newCode.split("\n")
    for (let i = 0;i<newList.length;i++){
        if (newList[i]=="end\n"){
            newList[i]="}"
        }
        newerCode += newList[i]
    }
    //newCode = newerCode
    alert("Stray ends: done")

    //alert(newCode)
    alert("Function defs: starting")
    delimiter = "function";
    newList = newCode.split(new RegExp(`(${delimiter})`));
    newerCode = ""
    for (let i = 0;i<newList.length;i++){
        newList[i] = newList[i].replace(")","){")
        newerCode += newList[i]
    }
    alert("Function defs: done")
    alert("for loops: starting")
    delimiter = "for";
    newList = newCode.split(new RegExp(`(${delimiter})`));
    newerCode = ""
    let term = ""
    for (let i = 0;i<newList.length;i++){
        if (newList[i]!="for"&&i>0){
            //alert(newList[i])
            //alert(newList[i][1])
            term = ""
            term2 = ""
            ending = ""
            g = false;
            g2 = true;
            for (let d = 1;d<100;d++){
                if (newList[i][d] == "="){
                    g2 = false
                }
                if (newList[i][d] == ","){
                    g=true
                    d++
                }
                if (d < 100&!g){
                    term += newList[i][d]
                }
                if (g2){
                    term2 += newList[i][d]
                }
                if (g){
                    ending += newList[i][d]
                    if (newList[i][d] == " "&&newList[i][d+1] == "d"&&newList[i][d+2] == "o"){
                        d = 1000
                    }
                }
    
            }
            forloop= "(let "+term+"; "+term2+"<="+ending+"; "+term2+"++){"
            glist = newList[i].split("do")
            glist[0]=forloop
            newList[i] = glist[0]+glist[1]
        }
        newerCode += newList[i]
    }
    alert("for loops: starting")

    //alert(newerCode)
    
    delimiter = "function";
    newList = newerCode.split(new RegExp(`(${delimiter})`));
    newerCode = ""
    //alert(newList.length)
    term = ""
    for (let i = 0;i<newList.length;i++){
        if (newList[i]!="function"&&i>0){
            newList[i] = newList[i].replace(")","){")
        }
        newerCode += newList[i]
    }
    
    alert("list length: starting")
    delimiter = "#";
    newList = newerCode.split(new RegExp(`(${delimiter})`));
    newerCode = ""
    //alert(newList.length)
    term = ""
    for (let i = 0;i<newList.length;i++){
        if (newList[i]!="#"&&i>0){
            list = ""
            smallLoop: for (let g = 0;g<newList[i].length;g++){
                if (validChars.indexOf(newList[i][g])>=0){
                    list+= newList[i][g]
                }
                else{
                    break smallLoop
                }
            }
            newList[i] = newList[i].replace(list,list+".length")
        }
        else if (i>0){
         newList[i] = ""       
        }
        newerCode += newList[i]
    }
    alert("list length: done!!!!!")

    alert("object items: starting")
    // delimiter = ".";
    // alert(newerCode)
    // newList = newerCode.split(".");
    // newerCode = ""
    // alert(newList)
    // //alert(newList.length)
    // for (let i = 0;i<newList.length;i++){
    //     if (newList[i]!="."&&i>0){
    //         if (Number.isNaN(Number(newList[i][0]))){
    //             item = ""
    //             smallLoop: for (let g = 0;g<newList[i].length;g++){
    //                 if (validChars.indexOf(newList[i][g])>=0){
    //                     item+= newList[i][g]
    //                 }
    //                 else{
    //                     break smallLoop
    //                 }
    //             }
    //             //alert(item+"hey")
    //             if (item != "length")
    //             newList[i] = newList[i].replace(item,"['"+item+"']")
    //             else{
    //                 newList[i] = "."+newList[i]
    //             }
    //         }
    //         else{
    //             newList[i] = "."+newList[i]
    //         }
    //     }
    //     else if (i>0){
    //         newList[i] = "."       
    //     }
    //     newerCode += newList[i]
    // }
    alert("object items: done!!!!!")
    alert("keep object: starting")

    newerList = newerCode.split("//keepObject")
    newnewcode = ""
    for (let i = 0;i<newerList.length;i++){
        newerList[i] = newerList[i].split("").reverse();
        layer = 0
        done = false
        for (let g= 0;g<newerList[i].length;g++){
            if (!done){
                if (newerList[i][g] == "="){
                    newerList[i][g] = ":"
                }
                if (newerList[i][g] == "]") {
                    layer++
                    if (layer==1){
                        newerList[i][g] = "}"
                    }
                    alert((layer==1)+", "+newerList[i][g])
                }
                if (newerList[i][g] == "[") {
                    layer--
                    if (layer==0){
                        newerList[i][g] = "{"
                        done=true;
                    }
                }
            }
        }
        newerList[i] = newerList[i].reverse().join("");
        newnewcode+=newerList[i]
    }
    newerCode = newnewcode;

    alert("keep object: done!!!!!")

    newerCode = newerCode.replaceAll(" do\n","){")
    running = true
    newerCode+="\nalert('starting!!!')\n_init()\nalert('success!')\nwindow.setInterval(tick,16)\nfunction tick(){if (running){try{\nupdateSpriteView(false)\n_update60()\n_draw()\ndoExternals()}\ncatch(err){\noutput.innerText +=err;output.innerText+=err.stack;alert(err.stack);running=false}}\n}"
    alert("it compiled!")
    gfx = []
    gfxlist = gfxtext.split("\n")
    for (let y = 1;y<129;y++){
        h = []
        for (let x = 0;x<128;x++){
            //ctx2.beginPath()
            //alert(x+","+y)
            if (gfxlist.length>y){
                c = gfxlist[y][x]
                c = fixColor(c)
                if (c!=undefined){
                    h.push(c)
                    gc = getColor(c)
                    //ctx2.fillStyle = rgbToHex(gc[0],gc[1],gc[2])
                }
                else{
                    h.push(0)
                    gc = getColor(0)
                    ctx2.fillStyle = "#000000"
                }

            }
            else{
                h.push(0)
                ctx2.fillStyle = "#000000"
            }
            ctx2.fillRect(x*4,y*4-4,4,4)
        }
        gfx.push(h)
    }
    alert("the graphics were extracted!")
    if (doMap){
    mapT = []
    maplist = maptext.split("\n")
    for (let y = 1;y<129;y++){
        h = []
        for (let x = 0;x<128;x++){
            //ctx2.beginPath()
            //alert(x+","+y)
            if (maplist.length>y){
                c = maplist[y][x*2]+""+maplist[y][x*2+1]
                c = parseInt(c, 16);
                if (c!=undefined){
                    h.push(c)
                }
                else{
                    h.push(0)
                }

            }
            else{
                h.push(0)
            }
        }
        mapT.push(h)
    }
    }
    alert("the map was extracted!")




    output.innerText = newerCode
    eval(newerCode)
}










//builtin pico-8 functions
//alert(gfx)
function cls(n){
    if (n == undefined){
        n = 0
    }
    ctx.beginPath();
    ctx.fillStyle = rgbToHex(colors[n][0],colors[n][1],colors[n][2])
    ctx.fillRect(0,0,128*resolutionMultiplier,128*resolutionMultiplier)
}
function rnd(n){
    return Math.random()*n
}
function add(a,n){
    a.push(n)
}
function flr(n){
    return Math.floor(n)
}
function ceil(n){
    return Math.ceil(n)
}
function sin(n){
    return Math.sin(-n*Math.PI*2)
}
function cos(n){
    return Math.cos(-n*Math.PI*2)
}
function mget(){
    return 0
}
function mset(){

}
function pset(x,y,c){
    try{
        x = (x-drawOffset.x)
        y = (y-drawOffset.y)
        if (-3<x<130&&-3<y<130){
        gr = rgbToHex(colors[c][0],colors[c][1],colors[c][2])
        ctx.fillStyle = gr
        ctx.fillRect(x*resolutionMultiplier,y*resolutionMultiplier,resolutionMultiplier+0.5,resolutionMultiplier+0.5)
        }
    }
    catch{
        //alert("the color "+c+" is broken")
    }
}
function max(x,y){
    if (x>y){
        return x
    }
    else{
        return y
    }
}
function min(x,y){
    if (x<y){
        return x
    }
    else{
        return y
    }
}
function fillp(){

}
function color(){

}
function line(x1,y1,x2,y2,c){
    x1 -=drawOffset.x
    x2 -=drawOffset.x
    y1 -=drawOffset.y
    y2 -=drawOffset.y
    c = fixColor(c)
    ctx.beginPath()
    ctx.lineWidth = ceil(resolutionMultiplier/2)*2
    ctx.strokeStyle = rgbToHex(colors[c][0],colors[c][1],colors[c][2])
    ctx.moveTo(x1*resolutionMultiplier, y1*resolutionMultiplier);
    ctx.lineTo(x2*resolutionMultiplier, y2*resolutionMultiplier);
    ctx.stroke()
}
function abs(n){
    return Math.abs(n)
}
function atan2(y,x){
    return -Math.atan2(x,y)/(Math.PI*2)
}
function rectfill(x1,y1,x2,y2){
    ctx.beginPath()
    ctx.fillRect((x1-drawOffset.x)*resolutionMultiplier,(y1-drawOffset.y)*resolutionMultiplier,(x2-x1+1)*resolutionMultiplier,(y2-y1+1)*resolutionMultiplier)
}
function sqrt(d){
    return Math.sqrt(d)
}
function oval(){

}
function circfill(x,y,r,c){
    if (r>0){
    x-=drawOffset.x
    y-=drawOffset.y
    cn = c
    c -= flr(c/16)*16
    c = getColor(c)
    ctx.beginPath()
    if (typeof c != "object") {alert(c+"f"+cn);c = [0,0,0]}
    ctx.fillStyle = rgbToHex(c[0],c[1],c[2])
    ctx.arc(x*resolutionMultiplier, y*resolutionMultiplier, r*resolutionMultiplier, 0, 2 * Math.PI);
    ctx.fill()
    }
}
function pal(n,n1,n2){
    if (n == undefined&&n1==undefined&&n2==undefined){
        palmap = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
    }
    else{
        //alert("heyheyhey")
        if (n<128){
            palmap[n] = n1
        }
        else{
            palmap[n] = n1
        }
        //alert(palmap)
    }
    
}
function btnp(d,p){

}
function spr(s,xp,yp,w,h,fh,fv){
    if (w==undefined){w=1}
    if (h==undefined){h=1}
    for (let x1 = 0;x1<8*w;x1++){
        for (let y1 = 0;y1<8*h;y1++){
            //alert(gfx)
            //alert()
            c = gfx[y1+flr(s/16)*8][x1+8*(s-flr(s/16)*16)]
            if (c>0)
            pset(xp+x1,yp+y1,c)
        }
    }
}
function sspr(){
    
}

function rgbToHex(r, g, b) {
    const toHex = (c) => {
      const hex = c.toString(16);
      return hex.length === 1 ? "0" + hex : hex;
    };
  
    return "#" + toHex(r) + toHex(g) + toHex(b);
  }
  
  function fixColor(c){
    switch (c) {
        case "a":
            c = 10
        break;
        case "b":
            c = 11
        break;
        case "c":
            c = 12
        break;
        case "d":
            c = 13
        break;
        case "e":
            c = 14
        break;
        case "f":
            c = 15
        break;
      }
      return c
  }
  function count(n){
    return n.length
  }
function getColor(n){
    n = palmap[n]
    if (n>=0&&n<=15){
        return colors[n]
    }
    if (n>=128){
        return colors2[n-128]
    }
}
let timeSince = 0;
function updateSpriteView(grx){
    if (grx){
        timeSince = 100
    }
    timeSince ++
    if (timeSince>60){
        for (let x = 0;x<128;x++){
            for (let y = 0;y<128;y++){
                ctx2.beginPath()
                ggfx = gfx[y][x]
                if (ggfx > 0)
                {
                ggx = getColor(ggfx)
                }
                else{
                ggx = [0,0,0]
                }
                //alert(ggx)
                if (typeof ggx == "object"){
                    ctx2.fillStyle = rgbToHex(ggx[0],ggx[1],ggx[2])
                    ctx2.fillRect(x*4,y*4,4,4)
                }
            }
        }
        timeSince = 0
    }

}
function doExternals(evt){
    //var mousePos = getMousePos(spriteCanvas,evt)
    txt = ""
    for (let i = 0;i<7;i++){
        if (playerButtons[i]>=0){
            playerButtons[i]++
        }
        if (btn(i)){
            txt+=playerButtons[i]
        }
        else{
            txt+="."
        }
    }
    btnDis.innerText = txt
}
spriteCanvas.addEventListener('click', event =>
    {
        let bound = spriteCanvas.getBoundingClientRect();

        let x = event.clientX - bound.left - spriteCanvas.clientLeft;
        let y = event.clientY - bound.top - spriteCanvas.clientTop;
    
        gx = flr(y/4)
        gy = flr(x/4)
        //alert(gx+","+gy)
        gfx[gx][gy] = 7
        updateSpriteView(true)
    });
    function btn(i,p){
        if (playerButtons[i]>=0){
            return true
        }
        else{
            return false
        }
    }

    document.addEventListener('keydown', function(event) {
        if (event.key === 'ArrowLeft') {
          playerButtons[0] = 0
        } 
        else if (event.key === 'ArrowLeft') {
            playerButtons[0] = 0
          } 
          else if (event.key === 'ArrowRight') {
            playerButtons[1] = 0
          } 
          else if (event.key === 'ArrowUp') {
            playerButtons[2] = 0
          } 
          else if (event.key === 'ArrowDown') {
            playerButtons[3] = 0
          } 
          else if (event.key === 'z') {
            playerButtons[4] = 0
          } 
          else if (event.key === 'x') {
            playerButtons[5] = 0
          } 
      });
      
      document.addEventListener('keyup', function(event) {
        if (event.key === 'ArrowLeft') {
            playerButtons[0] = -1
          } 
          else if (event.key === 'ArrowLeft') {
              playerButtons[0] = -1
            } 
            else if (event.key === 'ArrowRight') {
              playerButtons[1] = -1
            } 
            else if (event.key === 'ArrowUp') {
              playerButtons[2] = -1
            } 
            else if (event.key === 'ArrowDown') {
              playerButtons[3] = -1
            } 
            else if (event.key === 'z') {
              playerButtons[4] = -1
            } 
            else if (event.key === 'x') {
              playerButtons[5] = -1
            } 
          });          
          window.addEventListener("keydown", function(e) {
              if(["Space","ArrowUp","ArrowDown","ArrowLeft","ArrowRight"].indexOf(e.code) > -1) {
                  e.preventDefault();
              }
          }, false);
    function print(){

    }
function map(){
    for (let i = 0;i<32;i++){
        for (let d = 0;d<32;d++){
            if (0<i*8-drawOffset.x<128){
                if (0<d*8-drawOffset.y<128){
            mt = mapT[d][i]
            spr(mt,(i*8),(d*8))
                }
            }

        }
    }
}
function camera(x1,y1){
    drawOffset.x = x1
    drawOffset.y = y1
}
function time(){

}
function ovalfill(){

}
function deli(l,id){
    l = l.splice(id-1,1)
}