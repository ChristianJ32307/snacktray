#define spritelist
stand,wait,lookup,pose,crouch,knock,dead,walk,run,brake,spring,springfall,jump,bonk,ball,spindash,push,hang,dash,mariojump,mariobonk,mariofall,wall,pound,slide,twirl,fire,flagslide,climbing


#define soundlist
release,skid,spin,spindash,dash,boom,firedash,jump2,spinjump,spinbounce,hadoken,pound,wallkick,swim


#define movelist
Somari
#
[a]: Double Jump (air)
[down]: Groundpound
[b]: Dash (air)
[c]: Spinjump
<fire>
Somari [flwr]
#
[a]: Double Jump (air)
[down]: Groundpound
[b]: Dash (air) / Hadouken (ground)
[c]: Spinjump
<feather>
Somari [fthr]
#
[a]: Double Jump (air)
[down]: Groundpound
[b]: Feather Dash (air)
[c]: Spinjump



#define rosterorder
1

#define start
mask_set(12,12)
highcoinmax=1
spinjsmallless=1

//i had to replace somarispeen since spinjump is used in the gm81 file itself including in the code that makes it break bricks

#define stop
if (skidding) {soundstop(name+"skid") skidding=0}
star=0
grow=0
hurt=0
braking=0
spindash=0
spin=0
push=0
super=0
boost=0
hspeed=0
vspeed=0


#define itemget
if (type="jumprefresh") {insted=0 spinjump=0
mc=0
}
if (type="mushroom") {
if (!piped && !hurt && !(global.mplay>1 && flash)) {
coll=other.id
if (p2!=other.p2) {
itemc+=1
doscore_p(1000,1)
}
playgrowsfx("")
if (skidding) {soundstop(name+"skid") skidding=0}
if (!super && size!=2) grow=1
oldsize=size
size=2
itemget=1
}    
}
if (type="fflower") {
if (!piped && !hurt && !(global.mplay>1 && flash)) {
coll=other.id
if (p2!=other.p2) {
itemc+=1
doscore_p(1000,1)
}
playgrowsfx("2")
if (skidding) {soundstop(name+"skid") skidding=0}
if (!super && size!=2) grow=1
oldsize=size
size=2
itemget=1
}                
}
if (type="bfeather") {
if (!piped && !hurt && !(global.mplay>1 && flash)) {
coll=other.id
if (p2!=other.p2) {
itemc+=1
doscore_p(1000,1)
}
playgrowsfx("3")
if (skidding) {soundstop(name+"skid") skidding=0}
if (!super && size!=3) grow=1
oldsize=size
size=3
itemget=1
}                
}


if (type="star") {
if (!piped && !hurt && !(global.mplay>1 && flash)) {
coll=other.id
doscore_p(1000)
sound("itemstar")
itemc+=1
if (!super) {
star=1
alarm[2]+=other.fuel+2
alarm[3]=-1
kek=0 with (player) if (super) other.kek=1
if (!kek) {
mus_play("starman",1)
global.music="star"
}                      
}
if (skindat("growsfx3"+string(p2))) playsfx("growsfx3") 
else playgrowsfx("3")
itemget=1
}            
} 
if (type="1up") {
    sound("item1up")
    itemc+=1
global.lifes+=1
deaths=max(0,deaths-1)
if (super) superpower=6000
else energy=maxe
itemget=1
}
if (type="shield") {
    if (!piped && !hurt && !(global.mplay>1 && flash)) {
        coll=other.id
        if (p2!=other.p2) {
            itemc+=1
            doscore_p(1000,1)
        }
        sound("itemshield")
        shielded=1
        itemget=1
    }   
}
if (type="poison") {
    if ((!piped && !hurt && !(global.mplay>1 && flash))) {
        coll=other.id
         if !invincible() hurtplayer("enemy")
 if (insta && insta<14 &&!star) hurtplayer("enemy")
        itemget=1
    }   
}
if (type="coin") {
sound("itemcoin")
if (other.fresh) global.scor[p2]+=100
global.coins[p2]+=1
if global.coins[p2]=100{
sound("item1up")
            players[i].coinc+=1
if !global.mplay global.lifes+=1
}
coint+=1
hit=1

itemget=1
}
if (type="ring") {
sound("itemring")
if (other.fresh) global.scor[p2]+=100
global.rings[p2]+=1
if (name="robo") energy+=1
hit=1
itemget=1
}

#define effectsfront
if (firedash && !piped) {
    draw_sprite_part_ext(sheets[2],0,227+40*(firedash mod 8<4),46,39,39,round(x-19.5*xsc),round(y-19.5+dy)+4,xsc,1,$ffffff,alpha)
}


#define endofstage
right=1
grabbedflagpole=0
if (hsp>=3 || push) {
	akey=1
}

#define grabflagpole
grabflagpole=1
hsp=0
vsp=0

#define damager
//None

#define projectile
if (event="create") {
	image_xscale=8
	image_yscale=4

	frame_sub=0
	frame=0
	brickc=0
	seqcount=2
	getregion(x) 
	timer0=3
	timer1=128
	
	hspeed=xsc*3+owner.hsp*(xsc=sign(owner.hsp))
	speed=median(2,speed,5)
	playsfx("sonicboom")	
}
if (event="step") {
	timer0-=1 if (timer0=0) visible=1
	timer1-=1 if (timer1=0) instance_destroy()
	calcmoving()

	frame_sub=!frame_sub
	if frame_sub frame+=1
	if (frame>=3) frame=0

	if (!inview()) instance_destroy()
	xsc=sign(hspeed)
	ignoreoncount=1
	if (!waterdust && !feathdash){
	ignoreoncount=0
	coll=instance_place(x,y,collider)
	if (coll) {
		if (object_is_ancestor(coll.object_index,hittable)) {
			if (coll.object_index=brick) brickc+=1 else brickc=4
			hitblock(coll,owner,1,-1,0)
		} else brickc=4
		instance_create(x,y,kickpart)     
		if (brickc=4) {sound("itemblockbump") instance_destroy()}
	}

	coll=instance_place(x,y,enemy)
	if (coll) {
		if (coll.object_index!=beetle) {
			yes=1
			if (coll.object_index=shell) if (coll.type="beetle") yes=0
			if (yes) {
				global.coll=owner.id  
				instance_create(x,y,kickpart)  
				enemydie(coll,2)
			}
		}
		instance_destroy()
	}

coll=instance_place(x,y,bowserboss)
if (coll) {
    if (!coll.flash) {
        coll.hp-=1
        coll.flash=64
        coll.owner=owner
        sound("enemybowserhurt")
        instance_create(x,y,kickpart)
        instance_destroy()
    }
}

	coll=instance_place(x,y,player)
	if (coll) {
		if (coll.id!=owner) if (!invincible(coll)) {    
			if (!flag.passed[owner.p2] && !flag.passed[coll.p2] && !coll.flash && !coll.piped) { 
				if (coll.name="knux" && coll.glide && sign(hspeed)=-sign(coll.hsp) && object_index!=powah_wave) {hspeed=abs(coll.hsp+1)*esign(coll.hsp,1) owner=coll.id with (owner) playsfx("knuxreflect") exit}                                                                   
				if (coll.name="robo" && coll.lookup && coll.xsc=sign(hspeed)) {instance_create(x,y,kickpart) instance_destroy() exit}
				with(coll) fragplayer(other.owner)
			}
			instance_create(x,y,kickpart) instance_destroy()
		}
	}
	} else{
	timer0=0
	visible=1
	if timer1>14 timer1=14 
	if timer1=14 setxsc=owner.xsc
	efxfr=efxfr+0.25 
	if waterdust{
	hspeed=(sign(setxsc)*(-3/efxfr*2))
	xsc=sign(hspeed)
	}
	else {xsc=setxsc hspeed=-setxsc}
	
	
	}
}
if (event="draw") {
if !waterdust && !feathdash{
	draw_sprite_part_ext(sheet,0,10+25*frame,88,24,16,round(x-12*xsc),round(y-8),xsc,1,$ffffff,1)
	}
else if !feathdash{
	draw_sprite_general(global.effectssheet[biome],0,8+25*floor(efxfr),158,24,24,x,round(y-8)-13,-1,-xsc,90,$ffffff,$ffffff,$ffffff,$ffffff,1)
	draw_sprite_general(global.effectssheet[biome],0,8+25*floor(efxfr),158,24,24,x,round(y-8)+15,1,-xsc,90,$ffffff,$ffffff,$ffffff,$ffffff,1)
	if efxfr<3{draw_sprite_general(global.effectssheet[biome],0,8+25*floor(efxfr*2),183,24,24,x,round(y-8)+18,1,-xsc,90,$ffffff,$ffffff,$ffffff,$ffffff,1)}
	} 
else {
	draw_sprite_part_ext(owner.sheets[3],0,227+40*floor(efxfr),46,39,39,round(x-19.5*xsc),round(y-19.5)+4,xsc,1,$ffffff,owner.alpha)
	savedepth=depth
	depth=owner.depth+1
	draw_sprite_part_ext(owner.sheets[3],0,227+40*floor(efxfr),86,39,39,round(x-19.5*xsc),round(y-19.5)+4,xsc,1,$ffffff,owner.alpha)
	depth=savedepth
	}
}


#define sprmanager
frspd=1
if (grabflagpole) {sprite="flagslide"}
else if (transform) {sprite="transform"}
else if (hurt) {sprite="knock"}
else if (spindash) {sprite="spindash"}
else if (pound) sprite="pound"
else if (crouch||slipnslide) {if abs(hsp)<0.1 sprite="crouch" else sprite="slide"}
else if (jump) {
if (onvine) 
{
sprite="climbing" frspd=sign(left+right+up+down)
}
else if (sprung) {sprite="spring" fallspr="mariofall" if (vsp>=0) {sprung=0 fall=1}}
else if (spinjump) {sprite="twirl"}
else if (wall) sprite="wall"
else if (fall=10) sprite="dash"
    else if (bonk) if mariojump sprite="mariobonk" else sprite="bonk"
    else {if (fall||mariojump) {if (mariojump){ if vsp<0 sprite="mariojump" else sprite="mariofall" } else{ sprite=fallspr if sprite="walk" or sprite="run" sprite="springfall"}} else sprite="jump"  frspd=fallspd}
} else {
    if (spin) {sprite="ball" frspd=0.5+abs(hsp/3)}
else if (fired) {sprite="fire"}
    else if (push!=0) {sprite="push" frspd=1+abs(hsp/3)}
    else if (hsp=0) {
        if (hang) {sprite="hang"}
        else if (pose) sprite="pose"
        else if (lookup) {sprite="lookup"}
        else if (waittime>maxwait) {sprite="wait"}
        else {sprite="stand"}
    } else {
        if (braking) sprite="brake"
        else if (abs(hsp)>maxspd*0.9 && !water && !finish) {sprite="run" frspd=abs(hsp/3)}
        else {sprite="walk" frspd=0.2+abs(hsp/4)}
    }
}


#define controls
com_inputstack()

tempbrick=0

//situations in which it should skip controls entirely
if (hurt || piped || grabbedflagpole) {
    di=0
    exit
}

if (up) com_piping()
oup=up

if (up) {
    if (hsp=0 && !jump) lookup=1
    else lookup=0
} else lookup=0

//list of things that prevent you from moving
if (spindash || (crouch && !jump) ||vinegrab) h=0

//movement
if (h!=0 && !wallkick) {
    loose=0
    coll=noone
    if (h=sign(hsp) || hsp=0) coll=collision(h,0)
    if (coll) if (object_is_ancestor(coll.object_index,moving)) coll=place_meeting(x+h,y+coll.vsp+sign(coll.vsp),coll)
    if (coll) if (player_climbstep(coll)) coll=noone
    if (x<=minx && left) coll=1
    if (coll) {
        com_hitwall(h)
        if (!jump && !spin && !crouch && !firedash) {
            push=h
            xsc=h
            braking=0
        }
if (!pound && fall!=6 && !crouch && h=xsc && kicked!=h && !carry) if (knuxcanclimb(collision(8*h,0))) {
if (jump) wall=4
if (vsp>1) crouch=0
xsc=h
}
    } else {
        if (spin) {
            if (sign(hsp)!=h) hsp+=h*0.05*wf
        } else {
            if (!jump) {
                if (sign(hsp)!=h) {
                    if (abs(hsp)>maxspd*0.8) {
                        braking=1
skidding=1
playsfx(name+"skid")
                        brakedir=h
                    }
                    hsp+=0.33*wf*h
                    if (abs(hsp)<0.5) if (!firedash) xsc=h
                } else {
                    hsp+=0.06*wf*h
                    braking=0
                    if (!wall && !firedash) xsc=h
                }
            } else {
                hsp+=0.08*wf*h
//Shitty Jump turning
if (!super && !hurt && !wallkick && !dash){
if hsp>0 &&left {hsp=0 prejumphsp=1}
if hsp<0 &&right {hsp=0 prejumphsp=1}
}
                if (!firedash) xsc=h
else collwin=instance_place(x+hsp,0,goalblock)
if collwin {hsp=0 fallsprite="dash" collwin.owner=id with collwin{ event_user(4)}}
            }
        }
    }
}

if (push!=h) push=0

com_di()

//code for specifically the a button
if ((abut || jumpbufferdo) && (!springin)) {
    if (!jump||fall=69) { //jump
        if (hsp==0 && crouch && push==0 &&!vinegrab) {
            playsfx(name+"spindash",0,1+(median(0,spindash-1,3)/3)*skindat("pitchdash"+string(p2)))
            spindash=min(4,spindash+1)
            tempbrick=1
        } else {
if (poundjump) {springsmoke(x,y+8) crouch=0 mariojump=1}
            jumpsnd=playsfx(name+"jump")
vinegrab=0
            vsp=-5.2-!!poundjump
prejumphsp=abs(hsp)
            if (water) vsp=-sqrt(sqr(vsp)*wf+2)
onvine=0
            //change jump angle in steep slopes
            vd=point_direction(0,0,hsp,vsp)+point_direction(0,0,1,slobal/2)
            vm=point_distance(0,0,hsp,vsp)
            hsp=lengthdir_x(vm,vd)
            vsp=lengthdir_y(vm,vd)

if abs(hsp)=maxspd vsp=-6.2

sprite_angle=0

            jump=1
            fall=0
            braking=0
            spin=0
            canstopjump=1
            if (mymoving) hsp+=avgmovingh
            crouch=0
            if (spin && !star) seqcount=0
            fallspd=min(1,0.5+abs(hsp)/5)
        }
    } else if fall !=66{ //air jumps
        jumpbuffer=4*!jumpbufferdo
if (wall && !pound) {
wall=0 spinjump=0
firedash=0
mariojump=1
kicked=xsc
hsp=xsc*-2.5 jumpspd=100 instance_create(x+6*xsc,y+8,kickpart)
xsc*=-1 vsp=-4
playsfx("somariwallkick")
wallkick=12 crouch=0
run=1 runvar=1
canstopjump=1
} else if (!crouch && !pound && !double && !spinjump && !carry && !mariojump) {jumpspd=0 playsfx('somarijump2') firedash=0 if size<3 hsp=hsp/2 prejumphsp=abs(hsp) vsp=-3 double=1 mariojump=1 shoot(x,y+8,psmoke,0,-1)}
else if mariojump && water {playsfx('somariswim') vsp=-2}
    }
}
jumpbufferdo=0
springin=0

if (akey) {
    if (jumpbuffer) jumpbuffer-=1

if jump && size=3 && vsp>3 {vsp=3}
} else jumpbuffer=0

if (!akey) {
    if (canstopjump=1 && jump && vsp<-2 && !sprung) {
        vsp*=0.5
    }
    canstopjump=0
}

//code for specifically the b button
//code for specifically the b button
if (bbut) {
    if (spindash || (hsp=0 && crouch && push=0 && size)) {
        playsfx(name+"spindash",0,1+(median(0,spindash-1,3)/3)*skindat("pitchdash"+string(p2)))
        spindash=min(4,spindash+1)
        tempbrick=1
    } else {
        if (size=2 && (!count_projectiles()) && !crouch && !spin && !jump) {
            if (!airdash) fall=0
            fire_projectile(x+8*xsc,y+2)
            fired=16
        }
        if (jump && (fall=0 || fall=2 || fall=5) && !airdash && !firedash) {
            airdash=1
            if (abs(hsp)>2.5) boost=1
            t=esign(right-left,xsc)
            xsc=t
            fall=10
if size=3{
vsp=-3
hsp=maxspd*sign(xsc)
i=fire_projectile(x,y)
i.feathdash=1
} else if (size=2) {
hsp=4.5*h
                vsp=0
                firedash=24
                boost=1
                playsfx("somarifiredash")
            } else {
if !underwater(){
shoot(x-4*t,y+4,psmoke,-2*t,-1)
shoot(x-4*t,y+4,psmoke,-2*t,1)} else{
wds=fire_projectile(x,y+((sign(xsc)=-1)*16))
wds.waterdust=1
}
                playsfx("somarirelease")
            }
        }
    }
}

if (cbut) {
    if (spindash || (crouch && down)) {
        playsfx(name+"spindash",0,1+(median(0,spindash-1,3)/3)*skindat("pitchdash"+string(p2)))
        spindash=min(4,spindash+1)
        tempbrick=1
    } else if (!jump && !carry) {
jump=1
mariojump=1
spinjump=1
fallspr="twirl"
playsfx("somarispinjump")
vsp=-(4.2+min(1,abs(hsp)/8))
}
}
if (ckey) {
if (spinjump && vsp>0) spinjump=1
} else {
if (spinjump=1 && vsp<-2) {
vsp*=0.6
spinjump=2
}
}

//crouching and spinning
if (down && !up && fall!=66) {
    if (!jump && !braking && !spin) {
        if (abs(hsp)<0.25) {
            crouch=1
if (slobal!=0) {
slipnslide=1
hsp+=slobal/12
hsp+=slobal/16
                hyperspeed=median(-3,hyperspeed+slobal/16,3)
}
        } else if (!spin && !crouch && !slipnslide) {
            spin=1
            playsfx(name+"spin")
        } else if slipnslide{
slipnslide=1
hsp+=slobal/12
hsp+=slobal/16
        hyperspeed=median(-3,hyperspeed+slobal/16,3)
}
    } else if (!pound && !poundlok && jump && fall!=69) {
pound=1
if (water) seqcount=1
spinjump=0
playsfx("somaripound")
}
poundlok=1
com_piping()
} else {
if (pound=-1) {pound=0 mariojump=1}
crouch=0
slipnslide=0
poundlok=0
}

if (spin || spindash || crouch || fall=5) mask_set(12,12)
else if (mariojump) mask_set(12,26)
else if (jump && (!fall || fly || fall=10)) mask_set(12,15)
else mask_set(12,24)


#define movement
if (piped) exit

//speed limits
if (!jump) if (loose || spin || crouch) {
    braking=0
    frick=0.06
    if (spin) frick=0.005
    hsp=max(0,abs(hsp)-frick)*sign(hsp)
}


if !jump prejumphsp=abs(hsp)

//speed cap rubberband formula
maxspd=(3.75 + spin + (fall==10)*0.5 + firedash/24)*wf
if (abs(hsp)>maxspd) hsp=(abs(hsp)*2+maxspd)/3*sign(hsp)

if (pound) {
vsp=min(6,vsp)
} else vsp=min(7+downpiped,vsp)

///movement
//hi moster here dont uncomment the yground or easyground stuff because its required for the cool new slope system to work
//for anyone porting a charm from unfinished build or below to this build, delete or comment all of the comments with "yground" or "easyground()" and add player_nslopforce()
calcmoving()

if (!dead && !grabflagpole) {
    /*
player_horstep()
    */
player_nslopforce()
if fall!=69{
calc=hsp/point_distance(0,0,1,slobal)+di+hyperspeed

s=sign(calc)
if !super{
if abs(calc)<0.1 {calc=0 s=0}
else if abs(calc)<1.5 calc=1.25*s
else if abs(calc)<2.75 calc=2.25*s
else if abs(calc)<=maxspd calc=maxspd*s
}
x+=calc

if !jump player_magnetslope(calc)

if (s!=0) {
coll=collision(calc,0)
if (coll) if (!player_climbstep(coll)) {
com_hitwall(calc)
coll=collision(calc,0)
if (coll) {
dix=0
dio=0
x=floor(x-abs(calc)*s)
repeat (ceil(abs(calc))) {
x+=s
if (collision(0,0)) {
x-=s
break
}
}
}
}
}
}

    //yground=easyground()
//if (yground!=verybignumber) yground-=14
    if (jump) {
        //gravity
        hang=0
if (pound>0) {
hsp=0
if (pound<14) vsp=0
else if (pound>=14 && pound<15) vsp=6*wf
else if (water) {vsp-=0.1*wf if (vsp<1.5) pound=0}
else vsp+=0.375*wf
} else 
if (wall>0 && vsp>1 && !spinjump && !water) vsp=1.5 else if fall!=69 && fall!=66 {
            vsp+=0.15*wf
        } vine_climbing()
if fall=66{
hsp=0
vsp=0
xsc=1
gravity=0
if savefriction=0 savefriction=friction
set_sprite("flight")
rot=direction
if speed>3 speed=3
if hspeed<1||hspeed>-1 {vspeed=0.05 }

if direction<maxdir direction+=1
if direction>maxdir direction-=1
maxdir=direction
if left {maxdir=180 speed+=0.1}
if right {maxdir=0 speed+=0.1}
if up {if speed>1.5 {maxdir=90 speed+=0.06}}
if down {maxdir=270  speed+=0.2}
friction=0.02
speed*=0.9
}
        crouch=0
        spindash=0
        braking=max(0,braking-1)
if (pound=-1) pound=0
        if (sprung && !fall) fall=1
        push=0 spin=0
        coyote=0
osld=0
player_vertstep()
if (!jump) sld=point_direction(0,0,1,slobal)
    }

sprite_angle=0
if (osld<180 && osld>0 && !instance_place(x-16,y+4,ground)) dy=3
else if (osld>180 && osld<320 && !instance_place(x-16,y+4,ground)) dy=3

    if (!jump) {
//if (yground!=verybignumber) {y=yground while collision(0,0) && !collision(0,-8) {y-=1 }}
osld=sld
sld=point_direction(0,0,1,slobal)
if (!jump && abs(hsp)>1.5) {
diff=anglediff(sld,osld)
if (sign(diff)=sign(hsp) && diff*sign(hsp)>20 && sld=0) {
jump=1 fall=1 fallspr=sprite fallspd=frspd
y=min(y,yp)
hsp=lengthdir_x(hsp,osld) vsp=-abs(lengthdir_y(hsp,osld))*1.5 // coolness factor
}
}

        if (finish && ending="retainer" && !jump) coyote=0
        if (!collision(0,4) /*&& (y<yground-2)*/) {
            coyote+=1
            if (coyote=3) {
jump=1
fall=1
fallspr=sprite
if (spin || spindash) fall=5
fallspd=frspd
spin=0
crouch=0
}
        } else coyote=0
        if (jumpbuffer=-1) {
            jumpbuffer=0
            //jump buffering
            if (rise=0 && !down) {
                jumpbufferdo=1
            }
        }
    }
}
com_finishmove()


#define actions
com_warping()
com_actions()

if super && size=0 size=1

weight=0.4+0.4
bartype=0

if size=1 size=2


is_intangible=0
with (flag) if (passed[other.p2]) other.is_intangible=1
if (transform || finish || piped=1 ) is_intangible=1

power_lv=0
is_coinexplosive=0
if (spindash || spin || (jump && (!fall || fall=5))) power_lv=1
if (spinjump) power_lv=1
if (!poundcancel && pound) power_lv=3
if (star) power_lv=5
if (firedash) power_lv=4
if (firedash) is_coinexplosive=1

if (piped) exit

//waiting animation
if maxwait{
if (sprite="stand")
{waittime+=1}
else if sprite!="wait" waittime=0
}

//grounded state
if (!jump) {
    vsp=0
    if (!star && !spin && !spindash) seqcount=0
    //ledge hang animation detection
    if ((sprite="stand" && hsp=0) || hang) {
        image_xscale=1/6
        hang=(!instance_place(x,y+4,collider) && instance_place(x-7*xsc,y+4,collider))
        image_xscale=1
    } else hang=0

    //skidding
    if (push=0 && hsp!=0 && braking) {
        playsfx(name+"skid")
skidding=1
    } else if (skidding) {soundstop(name+"skid") skidding=0}
}

//water
if (underwater()) {
    if (!water) {
        if (abs(vsp)>2) water_splash(1)
        vsp=min(1,vsp/2)
    }
    water=1 wf=0.45
} else {
    if (water) {
        water=0
        vsp=max(-4,vsp*2)
        if (abs(vsp)>2) water_splash(0)
    }
    wf=1
}

//smoke generation
if (global.dustframe) {
    if (braking || fall=3) {
        i=shoot(x,y+10,psmoke) i.depth=depth+2
    }
    if (vsp<-5-2*!sprung) {
        shoot(x,y+8,psmoke,0,-1)
    }
    if (vsp>7) {
        speedwagon+=1
        if (speedwagon>60) shoot(x,y,psmoke,0,1)
    } else speedwagon=0
}


poundjump=max(0,poundjump-1)
stomplok=max(0,stomplok-1)
wall=max(0,wall-1)
stomplok=max(0,stomplok-1)
wallkick=max(0,wallkick-1)

if (pound) {
crouch=1
hang=0
if (pound<15) pound+=1
else if (up || (water && vsp>5)) {pound=0 mariojump=1 fall=0 insted=1 crouch=0 canstopjump=1}
else fall=4
} else poundcancel=0

if (boost) {
    if (hurt) boost=0
    if (point_distance(0,0,hsp,vsp)<2.5) boost=0
}
if (firedash) {firedash-=1 boost=1}
if (slipnslide) {
crouch=1
spin=0
if ((slobal=0 && (hsp=0 || ((left || right) && !down))) || jump) {slipnslide=0 crouch=0}
}
//spindash/spin
global.coll=id
if ((spindash || spin)&& !slipnslide) {
    coll=instance_position(x-10*sign(hsp),y+22,hittable)
    coll2=instance_position(x,y+22,hittable)
    

collmon=instance_position(x,y+22,monitor)
    if (collmon) {
        jump=1 spindash=0 spin=0 vsp=-2
        with (collmon) event_user(6)
    }

    if (spindash) coll=coll2
    else if (coll2) if (coll2.object_index!=brick) coll=coll2
    if (coll) if (coll.hit) coll=0
    if (coll=spinblacklist) coll=0
    if (!coll)
        with (hittable)
            if (id!=other.spinblacklist && (object_index!=brick || other.spindash) && !hit)
                if (instance_place(x,y-4,other.id)) other.coll=id
    
    if (coll) if (!coll.goinup || tempbrick) {
        i=coll.object_index
        hitblock(coll,id,0,1,0)
        if (i=brick) {spinblacklist=coll if (spindash) {jump=1 spindash=0 crouch=0 vsp=-2*wf}}
    }
    
    if (spindash) {
        spindash=max(1,spindash-0.025)
        if (!crouch) {
            if (spindash>3) boost=1
            spin=1
            hsp=xsc*6*(0.75+0.25*median(0,spindash-1,2)/2)
            spindash=0
           
                playsfx(name+"release")
            
        }
        if (hsp!=0) spindash=0
    }
    
    //stop spinning
    if (abs(hsp)<0.2 && spin) { 
        spinc+=1 if (spinc=8) {spinc=0
            spin=0    
            hsp=0
            soundstop(name+"spin")
            if (name!="mario") crouch=down            
        }
    }
} else spinblacklist=noone

if (spinjump) {
fall=(vsp<0)
spinballer+=1 if (spinballer=16) {spinballer=0
if (count_projectiles()<2 && !poundcancel && size=2 && !pound && !carry) {
ballspiner=!ballspiner
i=fire_projectile(x+8*ballspiner,y+2)
fired=8
i.hspeed=-4+8*ballspiner
}
}
}


jesus=(boost && vsp<4 && !water)



com_endactions()


#define enemycoll
//Code that defines collision with enemies
if (hurt || piped || (intangible() && !diggity)) exit

coll=noone extracheck=id inst=0


with (pswitch) if (phase!=other.id && !lock) {
    mask_index=spr_cratemask
    if (instance_place(x,y-other.vsp-16*!!other.diggity,other.id)) other.coll=id
    mask_index=spr_mask16x16
}
with (enemy) if (phase!=other.id && !lock)
    if (instance_place(x,y-other.vsp-16*!!other.diggity,other.id)) other.coll=id

if (coll) {
    calcfall=fall
    if (fall=5 || fall=12) calcfall=0
    global.coll=id
    type=coll.object_index
        
    seqcount=max(1,seqcount)
            
    if (coll.object_index=lakitu) if (coll.flee) exit
    
    if (star  
    || (spin && type!=spinyegg && type!=beetle && !object_is_ancestor(type,koopa) && type!=shell)
    || (pound>13 && type!=piranha && type!=spinyegg && type!=spiny)) {
        instance_create(mean(x,coll.x),mean(y,coll.y),kickpart)
        if (type=hammerbro) seqcount=max(5,seqcount)
if spin {vsp=-2 goroll=1} 
        enemydie(coll)                
        exit
    }
    
    if (spinjump) {
        if (fall) {if (y>coll.y && type!=shell) hurtplayer("enemy")}
        else if (type=spinyegg || type=spiny || type=piranha) {
            instance_create(mean(x,coll.x),mean(y,coll.y),kickpart)
            playsfx(name+"spinbounce",0,1+(size==5)/3)
            vsp=-3-ckey*1.5
            canstopjump=akey
            pound=0
            coll.phase=id
        } else if size==5 {vsp=-3-ckey*1.5 playsfx(name+"spinbounce",0,1+(size==5)/3) canstopjump=akey exit} else enemyexplode(coll)
        exit
    }
    
    if (spindash || inst || firedash) {if (diggity=32) exit enemyexplode(coll) exit}
    
    if (type=piranha || coll.damage_player_on_contact)  {
        hurtplayer("enemy")
        exit
    }
    
    if (spin) {
        if (type=shell) {if (coll.type!="beetle") {enemydie(coll) exit}}
        else if (type=beetle || object_is_ancestor(type,koopa)) {hsp=0 jump=1 jumpspd=0.5 spin=0 enemystomp(coll) exit}
        else if (type=spinyegg) {hurtplayer("enemy") exit}
        else {enemydie(coll) jump=1 vsp=-3 goroll=1 exit}
    }
                     
    if (type=spiny) {
        if (!fall && vsp<0) enemyexplode(coll)
        else hurtplayer("enemy") exit
    }
    if (type=spinyegg) {
        if (punch && punch<=10) enemydie(coll) else hurtplayer("enemy") exit
    }                
            
    if (type=shell && !coll.time) {          
        if (coll.type="spiny" && (coll.vspeed-vsp)*coll.ysc<0) {
            hurtplayer("enemy") exit
        } else if (!coll.kicked || (coll.stop && (coll.owner=id || coll.vspeed>=0))) {
                if (coll.stop && !coll.kicked) doscore_p(8000)
                else {seqcount=max(seqcount,2+scorelok1) doscore_p()}
                if (jump) {
                    if (vsp>0) {
                        vsp=-3-akey*1.5
                        canstopjump=akey
                        if (fall=12) fall=5
                    }
                }
                kicksound(0)
                instance_create(mean(x,coll.x),mean(y,coll.y),kickpart)
                with (coll) {spd=max(3,abs(other.hsp)+1) hspeed=spd*esign(x-other.x,other.xsc) owner=other.id kicked=1 stop=0 phase=owner}
            
            exit
        } else {
            if (coll.kicked && !coll.stop && sign(hsp)=sign(coll.hspeed) && abs(hsp)>abs(coll.hspeed)) {
                kicksound(0)
                instance_create(mean(x,coll.x),mean(y,coll.y),kickpart)
                coll.spd=max(3,abs(hsp)+1)
                coll.owner=id
                coll.phase=id
                exit
            } else if (coll.kicked && (!coll.stop || (coll.owner!=id && coll.vspeed<0)) && (vsp<0 || !jump)) {hurtplayer("enemy") exit}
            else {
                with (coll) {hspeed=0 owner=noone phase=other.id stop=0 kicked=0 time=15}
                vsp=-3-akey*1.5 canstopjump=akey sound("enemystomp") doscore_p() if (fall=12) fall=5 exit
            }
        }                    
    }
    
    if (type=blooper) {
        if (jump && (vsp>0||!mariojump) ) {if (calcfall) enemystomp(coll,5) else enemyexplode(coll)}
        else hurtplayer("enemy") exit
    }
    
    if (type=cheepred || type=cheepwhite) {
        if (jump && (vsp>0||!mariojump)) {enemyexplode(coll) exit}
        else {hurtplayer("enemy") exit}
    }
    
    if (jump) {
        if (type=koopa || type=beetle || type=rexbig || object_is_ancestor(type,koopa)) {
            if (vsp<0) {
                if (calcfall) hurtplayer("enemy")
                else {if (mariojump) enemystomp(coll,5) else enemyexplode(coll)} exit
            }
        } else {
            if (!calcfall) {if (mariojump) enemystomp(coll,5) else enemyexplode(coll) exit}
            if (vsp<0) {hurtplayer("enemy") exit}
        }
        
        if (type=goomba && seqcount=1 && !scorelok4) {seqcount=0 scorelok4=1}    
        if ((type=koopa || type=redkoopa) && seqcount=1) scorelok1=1    
        if (type=hopkoopa || type=redhover) seqcount=max(seqcount,1)
        if (type=hammerbro) seqcount=max(5,seqcount)
        if (fall=12) fall=5                        
        enemystomp(coll) exit      
    } else if (coll.vspeed<0 && coll.y>y+8) {jump=1 fall=1 vsp=-0.5 enemystomp(coll) exit}
    
    hurtplayer("enemy")   
}    

#define hurt
pipe=0
sprongin=0
speed=0
if (skidding) {soundstop(name+"skid") skidding=0}
if (carry && carryid) {with (carryid) event_user(0) carryid=noone carry=0}
onvine=0
energy=0
braking=0
sprung=0
diggity=0
grow=0
fairdash=0
gianadash=0
gk=0
fk=0
punch=0
bounce=0
twirl=0
oldsize=size
jumpbuffer=0
hyperspeed=0
hp=0
star=0  

if ((global.coins[p2]=0) && !shielded && global.rings[p2]=0) {
   if (global.mplay>1 || global.debug || global.lemontest) alarm[7]=120
   die()
} else {
    fly=0
    jet=0
    climb=0 
    rise=0
    slide=0
    glide=0
    sprung=0
    fall=0
    pound=0  
    braking=0
    boost=0
    upper=0
    hyperspeed=0
    if (shielded) playsfx(name+"shielddamage")
    else playsfx(name+"damage")

    starhit=0
	
	if (global.rings[p2]>0 && !shielded) {
		if global.rings[p2]>3  ///set that drop cap
			global.ringss[p2]=3
		droprings()
	}
	else if (global.coins[p2]>0 && !shielded) {
		if global.coins[p2]>3 { ///set that drop cap
			global.coins[p2]=3
		}
		integer=global.coins[p2] 
		global.coins[p2]=0 
		for (i=0;i<integer;i+=1) with (instance_create(x,y,itemdrop)) {
		heavened=other.heavened
		p2=other.p2
		type="coinup"
		fresh=0
		dissapear=31+myrand(15)
		if i>10 coinfalloff=1
		speed=4+myrand(2)
		direction=54+myrand(2)*8
	}
}
	
	
    
	jump=1 hurt=1+starhit if (!starhit) if (shielded) {shielded=0} else {size=0} hsp=xsc*-2*wf vsp=-3*wf
    
}


//Block hitting
#define hitblocks
if typeblockhit=0{
with (blockcoll){
if (stonebump) {
    if (!goinup) {if (insted!=2) owner.vsp=1.5 sound("itemblockbump") tpos=1}
} else { 
    if (!insted) {owner.vsp=1.5}
    owner.blockc+=1
    global.scor[owner.p2]+=10
    sound("itemblockbreak")
    hit=1
    if (skindat("bricd")) {
        i=instance_create(x,y,bricd)
        i.biome=biome
        i.depth=depth
    }
    if (stoned="1") with (instance_create(x,y+8,stone)) phase=1
    i=instance_create(x+4,y+12,part) i.hspeed=-1 i.vspeed=-1+2*go
    i=instance_create(x+12,y+12,part) i.hspeed=1 i.vspeed=-1+2*go 
    i=instance_create(x+4,y+4,part) i.hspeed=-1 i.vspeed=-3+2*go
    i=instance_create(x+12,y+4,part) i.hspeed=1 i.vspeed=-3+2*go
    
    with (turing) event_user(4)
    instance_destroy()
  }
 }
} else if typeblockhit=1{
	hititembox()
}


#define hitwall
//hit blocks sideways
if (firedash || (spin && abs(hsp)>0.5)) {
    global.coll=id
    with (hittable) if (instance_place(x-other.hitside,y,other.id)) {	
		if global.coll.firedash go=sign(global.coll.vsp) else go=-1
        insted=1
        event_user(0)
		insted=0
    }
    coll=collision(hitside,0)
    if (firedash && jump) {canpipejump=1 com_piping() fall=5 vsp=0} else canpipejump=0
}

if (coll=noone) exit

if (!collpos(sign(hitside)*10,8,1)) {        
    //gap running
    if (y<coll.y-12) {y=coll.y-14 coll=noone exit}
}

hsp=0
hyperspeed=0        


#define landing
mariojump=0
wall=0   
prejumpspd=50
kicked=0
braking=0
insted=0
airdash=0
double=0
spinjump=0

if (downpiped) {
shoot(x-8,y+4,psmoke,-2,-1)
shoot(x+8,y+4,psmoke,2,-1)    
    downpiped=0
}
if (hurt) {flash=1 fk=0 hsp=0 hurt=0}

playsfx(name+"step")

//jump buffering
if (jumpbuffer) jumpbuffer=-1


if (pound) {
com_piping()
with (itembox) if (instance_place(x,y-max(4,other.vsp),other.id)) {
go=1    
event_user(0)
picked=0
other.stoppounding=!hit
other.jump=1
other.vsp=-0.1
} 
if (stoppounding=1 && !down) {stoppounding=0}
if stoppounding=0 {pound=0} 

    
    if (!poundcancel && !piped) {
        playsfx(name+"stomp")         
        shoot(x-8,y+4,psmoke,-2,-1)
        shoot(x+8,y+4,psmoke,2,-1)    
poundjump=10
    }
}

//fall into spin
if (!spin && rise=0 && !hurt && down && abs(hsp)>=0.5) {
    spin=1
    playsfx(name+"spin")
seqcount=1
}

//jump into tiny space
if (insted!=2 && !spin) {
mask_temp(12,12)
coll=collision(0,0)
mask_reset()
if (!coll && collision(0,0)) {
spin=1
mask_set(12,12) 
playsfx(name+"spin")
hsp=max(abs(hsp),2)*esign(hsp,xsc)
}
}

if goroll {goroll=0 spin=1}

#define death
if (event="create"){

alarm0=30
alarm1=300
sprite="dead"
frame=0
frspd=0
size=0
spindash=0
alpha=1

global.coins[owner.p2]=0
name=owner.name
p2=owner.p2
owner=owner.id
size=owner.size
xsc=owner.xsc
ysc=owner.ysc
water=owner.water
vspeed=-3.5 gravity=0.1

} 
else if (event="step"){
alarm0=max(0,alarm0-1)
alarm1=max(0,alarm1-1)

if alarm1=0 instance_destroy()
} else if (event="draw"){

}


#define enterpipe
if (type="side") {
	if (firedash) {fastpipe=1 hspeed=xsc*3 set_sprite("run") frspd=1}
	if (spin||crouch) {
		set_sprite("ball")
		frspd=min(1,0.1+abs(hsp/4))
		if (abs(hsp)>=(maxspd-1) && !underwater()) {fastpipe=1 playsfx(name+"spin")}
	}
	if (boost) {fastpipe=1}
}
if (type="up") {
	set_sprite("fly")	
}
if (type="down") {
	if (pound) {set_sprite("pound") frame=frame_number(sprite) vspeed=5 alarm[6]=6 fastpipe=1}
}


if (skidding) {soundstop("sonicskid") skidding=0}
braking=0
crouch=0
push=0          
firedash=0
dash=0


#define exitpipe
if (type="door") {}
if (type="side") {}
if (type="up") {}
if (type="down") {}
