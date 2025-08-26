#define spritelist
stand,wait,lookup,pose,crouch,hurt,dead,walk,run,brake,jump,bonk,fall,doublejump,wallslide,groundpound,poundfall,slide,standcarry,crouchcarry,walkcarry,jumpcarry,bonkcarry,fallcarry,throw,roll,swim,paddle,swimcarry,spinjump,fire,push,balancing,capeflight,dive,climbing,flagslide,hanging,hangmove,grind,piping,pipingup,sidepiping,doorenter,doorexit


#define soundlist
skid,swim,pound,stomp,smalljump,flip,spin,slide,kick,fireball,wallkick,smallwallkick,dive,spinjump,spinbounce,longjump


#define movelist
Peach
#
[a]: Jump (ground)
[down]: Groundpound (air)
[c]: Dive (air) / Spinjump (ground)
[down][c]: Long Jump (ground)
Jump out of a Groundpound to reach higher places
<fire>
Peach [flwr]
#
[a]: Jump (ground)
[down]: Groundpound (air)
[b]: Fireball
[c]: Dive (air) / Spinjump (ground) 
[down][c]: Long Jump (ground)
Jump out of a Groundpound to reach higher places
<feather>
Peach [fthr]
#
[a]: Jump (ground)
[a]>[a]>[a]: Wing Cap
[down]: Groundpound (air)
[c]: Dive (air) / Spinjump (ground) 
[down][c]: Long Jump (ground)
[fthr] Hold A while mid-air to descend slowly
Jump out of a Groundpound to reach higher places

#define rosterorder
1

#define hud
if !dontdrawhud {
	spr=sheets[size]
	drawdefaulthud()
}

#define effectsbehind
with (carryid) {hspeed=0 event_user(1)}

#define grabflagpole
grabflagpole=1
hsp=0
vsp=0

#define start
mask_set(12,12)
if global.mplay>1 coop_carryable=1

#define stop
if (skidding) {soundstop(name+"skid") skidding=0}
star=0
grow=0
hurt=0
push=0
pound=0


#define itemget
if (type="jumprefresh") {
	spinjump=0
	if (double) double=0
    insted=0
    mc=0
    itemget=1
}
else if (type="1up") {
    sound("item1up")
    itemc+=1
	global.lifes+=1
	deaths=max(0,deaths-1)
	itemget=1
} 
com_item()

#define endofstage
right=1
akey=(push || (jump && akey) || !collision(16,8))

#define projectile
if (event="create") {
if ((owner.hang && owner.vsp>1) || owner.braking) {hspeed*=-1 x-=8*xsc}
image_xscale=3
image_yscale=3
frame_sub=0
frame=0
brickc=0
seqcount=2
kek=8
vspeed=3
hspeed=owner.xsc*4
exploding=0
exploframe=0
visible=1
depth=-1;
playsfx(owner.name+"fireball")
}

if (event="step") {
calcmoving()
if exploding=0{
vspeed=min(2.75,vspeed+0.35)
xsc=esign(hspeed,1)

frame_sub=!frame_sub
if frame_sub frame+=1
if (frame>=3) frame=0

if (!inview()) instance_destroy()

coll=instance_place(x,y,collider)
if (coll) {
if (coll.object_index=lavablock) {instance_destroy() exit}
if (y<coll.y+4 && !instance_place(x,y-8,collider)) {vspeed=-2.75 y-=2 exit}
if coll.object_index=phaser exit
exploding=1
    sound("itemblockbump")
}

image_xscale=5
image_yscale=5
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

coll=instance_place(x,y,enemy)
if coll {
if (coll.object_index!=beetle && coll.object_index!=bulletbill
&& coll.object_index!=bullseyebill && coll.object_index!=banzaibill 
&& coll.object_index!=cannonball && coll.object_index!=drybones 
&& coll.object_index!=bombenemy && coll.object_index!=boo 
&& coll.object_index!=urchin) {
yes=1
if (coll.object_index=shell) if (coll.type="beetle") yes=0
if (yes) {
global.coll=owner.id  
instance_create(x,y,kickpart)  
enemydie(coll,2)
}
}
exploding=1
}
image_xscale=3
image_yscale=3



coll=instance_place(x,y,player)
if (coll) {
if (coll.id!=owner) if (!invincible(coll)) {    
if (!flag.passed[owner.p2] && !flag.passed[coll.p2] && !coll.flash && !coll.piped) { 
if (coll.name="knux" && coll.glide && sign(hspeed)=-sign(coll.hsp) && object_index!=powah_wave) {hspeed=abs(coll.hsp+1)*esign(coll.hsp,1) owner=coll.id with (owner) playsfx("knuxreflect") exit}                                                                   
if (coll.name="robo" && coll.lookup && coll.xsc=sign(hspeed)) {instance_create(x,y,kickpart) exploding=1 exit}
with(coll) fragplayer(other.owner)
}
exploding=1
}
}
}
else if exploding=1
{
exploframe+=0.5
if (exploframe>=3) {visible=0 instance_destroy()}
hspeed=0
vspeed=0
}
}
if (event="draw") {
if exploding=0
{
draw_sprite_part_ext(sheet,0,8+17*frame,111,16,16,round(x-12*xsc),round(y-8),xsc,1,$ffffff,1)
} else
{
draw_sprite_part_ext(sheet,0,8+17*floor(exploframe/1.333333333),94,16,16,round(x-12*xsc),round(y-8),xsc,1,$ffffff,1)
}
}


#define sprmanager
frspd=1
if (grabflagpole) {sprite="flagslide"}
else if (hurt) {sprite="hurt"}
else if (dive) {sprite="dive"}
else if (spin) {sprite="roll"}
else if (fired && !spinjump) {sprite="fire"}
else if (throw) {if !(jump) sprite="throw" else sprite="airthrow"}
else if (pound) {sprite="groundpound" if (pound>12 || vsp>0) sprite="poundfall"}
else if (slipnslide) {sprite="slide"}
else if (crouch) {sprite="crouch"}
else if (jump) {
if (onvine) 
{
sprite="climbing" frspd=sign(left+right+up+down)
}
else if (fall=6) {sprite="hurt"}
else if (flight) {sprite= "capeflight" frspd=0 frame=((vsp+2.5)/6.5)*(global.animdat[p2,(16+128*32)+1+min(4,size)]-1) if frame>=frn frame=frn-1}
else if (spinjump) {sprite="spinjump"}
else if (hang && vsp>=1 && !spinjump) {sprite="wallslide"}
else if ((double || triplejump>=1) && !water) { if carry {sprite="jump" if (vsp>0) sprite="fall"} else sprite="roll" frspd=0.4}
else if (triplejump>=0.5 && !water) {sprite="doublejump"}
else if (water) {sprite="swim" if (swim) sprite="paddle"}
else if (bonk) {sprite="bonk"} 
else {sprite="jump" if (vsp>0) sprite="fall" if (jumpspd=99) sprite="doublejump"}
} else {
if (push!=0) {sprite="push" frspd=1+abs(hsp/3)}
else if (braking && !carry) {sprite="brake" xsc=-brakedir}
else if (hsp=0) {
if (lookup && !carry) {sprite="lookup"}
else if (balancing) {sprite="balancing"}
else if (waittime>maxwait &&!carry) {sprite="wait"}
else if (posed) {sprite="pose"}
else {sprite="stand"}
} else {
if (abs(hsp+hyperspeed)>3 && !carry) {sprite="run"}
else {
sprite="walk"
frspd=median(0.5,1,0.3+abs(hsp/4))
}
}
}
if (carry) sprite=sprite+"carry"

#define controls
com_inputstack()

tempbrick=0
carryoffsetx=10
carryoffsety=5

//situations in which it should skip controls entirely
if (rise!=0 || watrlock || hurt || piped || move_lock) {
    di=0
    h=0
    exit
}

if (up) com_piping()
oup=up

lookup=0
if (up && hsp=0 && !jump && !throw) lookup=1

if (
rise!=0 || 
flight ||
(crouch && !jump) ||
(poundcancel || pound || spin || dive)
) h=0

if (h!=0 && !wallkick) {
    loose=0
    coll=noone
    if (h=sign(hsp) || hsp=0) coll=collision(h,0)
    if (coll) if (object_is_ancestor(coll.object_index,moving)) coll=place_meeting(x+h,y+coll.vsp+sign(coll.vsp),coll)
    if (coll) if (player_climbstep(coll)) coll=noone
    if (x<=minx && left) coll=1
    if (coll) {
        com_hitwall(h)
        if (!jump && !crouch) {
            push=h
            xsc=h
            braking=0
        }
        if (!pound && !water && fall!=6 && !crouch && h=xsc && kicked!=h && !carry) if (knuxcanclimb(collision(8*h,0))) {
            if (jump) hang=4
            if (vsp>1) crouch=0
            xsc=h
        }
    } else {
        if (!jump) {
            if (sign(hsp)!=h) {
                if (abs(hsp)>2 && !carry) {
                    braking=1
                    skidding=1
                    playsfx(name+"skid",1)
                    brakedir=h
                }
                hsp+=(0.44-0.175*!water+0.04*(abs(hsp)<1))*wf*h
                if (abs(hsp)<0.5 || carry && !spin) xsc=h
            } else {
                hsp+=(0.06+0.04*(abs(hsp)<0.5))*wf*h
                xsc=h
                braking=0
            }
        } else {
            if (water) {if (h!=sign(hsp)) hsp+=0.1*h else hsp+=0.0475*h}
            else if (size==5) hsp+=0.085*wf*h
            else hsp+=0.06*wf*h
            if (!hang && !wallkick && !twist && !spin) xsc=h
        }
    }
}

if (push!=h) push=0

com_di()

if ((abut || jumpbufferdo) && !springin) {
    if (!jump || water ||fall=69||grabflagpole) {
        if (water) {
			if (!pound && !carry && !dive ){
				vsp=-1.5-up*0.75 swim=24 crouch=0 playsfx(name+"swim") double=0
				if (sprite="paddle") frame=0
			}
		}
        else {
            if ((abs(hsp)<=2.5 && triplejump) && size!=3) || triplejump>=1 || (triplexsc!=sign(hsp)  && triplexsc!=0) || poundjump && !carry && !crouch {triplejump=0 triplexsc=0}
            else if (jumptiming && ((abs(hsp+hyperspeed)>2.5 || !triplejump) || size==3) && !carry && !crouch && triplejump < 1.5) {triplejump+=0.5 triplexsc=sign(hsp)}
			
			if (size==0 || size==5) jumpsnd=playsfx(name+"smalljump",0,1+triplejump/2+(size==5)/3)
            else jumpsnd=playsfx(name+"jump",0,1+triplejump/2)
            
			if (spin) {vsp=-1 instance_create(x,y+12,smoke)}
            else {vsp=-(4.7+min(1,abs(hsp)/8)+!!poundjump+triplejump) hellothisisajump=1}
			grabflagpole=0
            latchedtoflagpole=0
		   if (water) vsp=-sqrt(sqr(vsp)*wf+2)
        }
		
        if (poundjump) {springsmoke(x,y+8) crouch=0}
        jumptiming=0
        onvine=0
        jump=1
        fall=0
        braking=0
        canstopjump=1
        if (mymoving) hsp+=avgmovingh
        if (!star) fall=1
        else crouch=0
        if (rise && !down) && (!collision(0,-12) || !size || size==5) crouch=0
        jumpspd=min(1,0.5+abs(hsp)/5)
    } else {
        if (hang && !carry && !flying) {
            hang=0 spinjump=0 dive=0 triplejump=0 triplexsc=0
            kicked=xsc
            hsp=esign((right)+(-left),xsc)*-2.5 jumpspd=100 instance_create(x+6*xsc,y+8,kickpart)
            xsc*=-1 vsp=-4
            if (size) playsfx(name+"wallkick") else playsfx(name+"smallwallkick",0,1+(size==5)/3)
            wallkick=12 crouch=0
            run=1
            canstopjump=1
        }
        
        if (super && !crouch && !flying && fall!=6 && !float && ((abs(hsp)>2 && (vsp)<0) || fly)) {
            fly=1
            vsp=-3
            playsfx(name+"flip")
        } else if (super && !flying &&  !crouch && fall!=6 && !fly) {
            float=20
            playsfx(name+"flip")
        }
        jumpbuffer=4*!jumpbufferdo
    }
}

if (!jump) {
    if (jumptiming) jumptiming-=1
    else {triplejump=0 triplexsc=0}
}
jumpbufferdo=0
springin=0

if (akey) {
    if (jumpbuffer) jumpbuffer-=1
} else {
    jumpbuffer=0
    if (canstopjump=1 && jump && vsp<-2 && !sprung && !water) {
        vsp*=0.6
    }
canstopjump=0
}

if (bbut) {
    if (size=2 && count_projectiles()<2 && !crouch && !dive) {
        fire_projectile(x+8*xsc,y+2)
        fired=8
        if (sprite="fire") frame=0
    }
}

if (bkey) {
    if (!jump) run=1.5
} else {
    if (carry) {
        updatecarry()
        if (!down) {throw=16 instance_create(carryid.x,carryid.y,kickpart) sound("enemykick")}
        with (carryid) event_user(0)
        carryid=noone
        carry=0
    }
}

if (cbut) {
    if (!carry) {
		if (!jump && !spin) {	
			jump=1
			fall=0
			spinjump=1
			jumpspd=0
			crouch=0
			playsfx(name+"spinjump")
			vsp=-(4.2+min(1,abs(hsp)/8))
        }
        else if (dive=0 && !up && (pound || spin || !crouch) && !onvine) {
			instance_create(x,y,smoke)
            jump=1
            pound=0
            dive=1
            spin=0
            spinjump=0
            crouch=0
            run=1.5
            runvar=1.5
            playsfx(name+"dive")
            vsp=-2.7
            hsp=3.5*(esign(right-left,xsc))
			xsc=esign(right-left,xsc)
            hellothisisajump=0
        }
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

//crouching
if (down && !up) {
    if (jump) {
        if (!carry && fall!=6 && !dive && !pound && !poundlok && fall!=69) {
            pound=1
			nocratebounce=1
            if (water) seqcount=1
            slidejump=0
            spinjump=0
            playsfx(name+"pound")
        }
    } else if (!braking) {
        if (slobal!=0 && !carry) {
            slipnslide=1
        } else {
            crouch=1           
        }
    }
    poundlok=1
    com_piping()
} else {
    if (pound=-1) pound=0
    if (!jump && (!collision(0,-12) || !size || size==5)) crouch=0
    poundlok=0
}

if (size==5) mask_set(9,8)
else if (size=0 || crouch || pound || spin || dive) mask_set(12,12)
else if (jump) mask_set(12,26)
else mask_set(12,24)


#define movement
if (piped || move_lock) exit

//speed limits
if ((loose && !jump) || (crouch && !jump)) {
if (braking) xsc=brakedir
braking=0
frick=0.06
if (slipnslide) frick=0.01
if !flight hsp=max(0,abs(hsp)-frick)*sign(hsp)
}

maxspd=(1.5+runvar*1.5+water+(size==5)*0.55+slipnslide+!!spin)*(wf+((carry/2)*underwater()))
if (abs(hsp)>maxspd) hsp=(abs(hsp)*2+maxspd)/3*sign(hsp)

if (pound) {
vsp=min(6,vsp)
} else vsp=min(7+downpiped,vsp)

///movement
//hi moster here dont uncomment the yground or easyground stuff because its required for the cool new slope system to work
//for anyone porting a charm from unfinished build or below to this build, delete or comment all of the commented code and add player_nslopforce()
calcmoving()

if (!dead && !grabflagpole) {
if fall!=69
player_horstep()
player_nslopforce()
//yground=easyground()
//if (yground!=verybignumber) yground-=14
if (jump) {
	if (flight) {
		if !frame1flight{
		frame1flight=1
		flightdir=sign(xsc)
		}
		hsp=flightdir*maxspd
		if hsp!=0
		xsc=sign(hsp)
		movevar=xsc

		if movevar>0 { //pulling down, make gravity stronk + give speed
		vsp=min(4,vsp+0.25)
		frame1uppies=0
		} else if movevar=0{ //Neutral, let gravity do it's thing
		vsp=min(4,vsp+0.15)
		frame1uppies=0
		} else if movevar<0{  //pulling up, glide and gain upward force based on how hard you're falling
		if !frame1uppies{
		airtime=vsp*5
		savedvsp=vsp
		frame1uppies=1
		if energy=0 airtime=0
		energy-=1
		}
		if vsp>=1{ //stop falling, transition into gliding/flying
		vsp*=0.9  
		} else {
		if savedvsp<1||airtime<=0{ //No more uppies for you! *vine boom sfx*
		vsp=min(1,vsp+0.05)
		}
		else { //use up airtime 
		vsp-=0.6
		if vsp<-1.25 vsp=-2.25
		airtime-=1
		}
		}

		}
		if pound flight=0

		if sign(hsp)!=flightdir flight=0
	} 
	else if (pound>0) {
		hsp=0
		if (pound<14) {vsp=0}
		else if (underwater() && carry) {vsp=approach_val(vsp,0,0.075)}
		else if (pound>=14 && pound<15) {vsp=6*wf}
		else if (water) {vsp-=0.1*wf if (vsp<1.5) {pound=0}}
		else {vsp+=0.375*wf}
	}
	else if (vsp<-2) vsp+=0.15
	else if (water) vsp=min(1.5,vsp+0.04)
	else if (twist>5) vsp=min(1,vsp+0.1)
	else if fall!=69 && !flight {
		vsp=min(4,vsp+0.25)
		if size==5 && vsp>-0.75 vsp-=0.175
	} 
	vine_climbing() 
	if (onvine) {
		dive=0
		pound=0

		crouch=0
		spinjump=0
		triplejump=0
	}
	if (!flight && akey && size=3) {if vsp>2 vsp=2}
	if (hang>0 && vsp>1 && !spinjump && !water) vsp=1.5

	if (skidding) {soundstop(name+"skid") skidding=0}
	braking=0
	braking=max(0,braking-1)

	if (!fall && !spinjump) fall=1
	if (pound=-1) pound=0
	if (sprung && !fall) fall=1
	if (fall=12) {vsp=6*wf hsp=0}
	if fall=69 {dive=0 flight=0}
	if !flight frame1flight=0

	push=0
	rise=0 risec=0
	coyote=0
	player_vertstep()
}

if (osld<180 && osld>0 && !instance_place(x-16,y+4,ground)) dy=3
else if (osld>180 && osld<320 && !instance_place(x-16,y+4,ground)) dy=3
if (!jump) {
//if (yground!=verybignumber) {y=yground while collision(0,0) && !collision(0,-8) {y-=1 }}
if (finish && ending="retainer" && !jump) coyote=0
if (!collision(0,4) /*&& (y<yground-2)*/) {
coyote+=1
if (down || !run) {y+=1 coyote=3}
if (coyote=3) {
jump=1
fall=1
if (crouch) vsp=1.5
if (spin) {vsp=-1.5}
}
} else coyote=0
if (jumpbuffer=-1) {
jumpbuffer=0
//jump buffering
if (rise=0 && !down) {
jumpbufferdo=1
if (insta) insted=1
}
}
}
}


com_finishmove()


#define actions
com_warping()
com_actions()

weight=0.5+0.5*!!size
bartype=1

if jump && triplejump>=1 && size=3 && vsp>=0 && akey && !carry{
	if hsp=0 hsp=sign(xsc)*0.01
	flight=1
	triplejump=1
}
if !(pound) {
	nocratebounce=0
}

maxe=4

if (abs(hsp)>=2 && !jump) {
	if (mcs>8) {energy+=1 mcs=0}
} else if (!jump) if (mcs>30) {energy-=1 mcs=0}

if (pound<14) && (pound) {if !(is_intangible_timer) is_intangible_timer=10}

is_intangible_timer=max(is_intangible_timer-1,0)

if (is_intangible_timer)
is_intangible=1
else
is_intangible=0

with (flag) if (passed[other.p2]) other.is_intangible=1
if (transform || finish || piped=1 ) is_intangible=1

power_lv=0
if (spin) power_lv=1
if (spinjump) power_lv=1
if (!poundcancel && pound) power_lv=3
if (star) power_lv=5
if (super) power_lv+=1

if (piped) {
updatecarry()
exit
}


//Special interactions
pvp_spin=spin //rolling clash
pvp_avoid=0 //I don't like social interactions
pvp_stomper=!pound //make sure to set for 0 for the Peach bros when pounding
pvp_ignore=(pound || flash || hurt || piped || star || intangible()) //For when you wanna hit the others but not yourself
pvp_knockaway=0 //I won't hurt you, just go away

//waiting animation
if maxwait{
if (sprite="stand")
{waittime+=1}
else if sprite!="wait" waittime=0
}

coll=instance_place(x+(abs(hsp)+2)*xsc,y,cork)
if (coll || carryid.object_index==cork) && (!coll.time) {
	if (bkey && !carry && !spin && !dive && size!=5) {
		coll.carry=id coll.owner=id carryid=coll
		carry=1
		skidding=0
		updatecarry()
	} else if !(bkey) { 
		if (carry) {
			updatecarry()
			if (!down) {throw=16 instance_create(carryid.x,carryid.y,kickpart) sound("enemykick")}
			with (carryid) event_user(0)
			carryid=noone
			carry=0
		}
    }              	
}

coll=instance_place(x+(abs(hsp)+2)*xsc,y,litbobomb)
if (coll || carryid.object_index==litbobomb) && (!coll.time) {
	if (bkey && !carry && !spin && !dive && size!=5) {
		coll.carry=id coll.owner=id carryid=coll
		carry=1
		skidding=0
		updatecarry()
	} else if !(bkey) { 
		if (carry) {
			updatecarry()
			if (!down) {throw=16 instance_create(carryid.x,carryid.y,kickpart) sound("enemykick")}
			with (carryid) event_user(0)
			carryid=noone
			carry=0
		}
    }              	
}

if (!jump) {
	vsp=0
	if (!star) seqcount=0
	
	//ledge hang animation detection
	if ((sprite="stand" && hsp==0) || balancing) {
        image_xscale=1/6
        balancing=(!instance_place(x,y+8,collider) && instance_place(x-7*xsc,y+4,collider))
        image_xscale=1
    } else hang=0
	//check for deathpits
	if (dive) dive+=1
	if (dive=3) dive=0
	if (push=0 && hsp!=0 && braking) {
	if (!skidding) {skidding=1 playsfx(name+"skid",1)}
	} else if (skidding) {soundstop(name+"skid") skidding=0}
	if (abs(hsp)<0.2 && spin) { //stop spinning
		spinc+=1 
		if (spinc==8) {
			spinc=0
			spin=0    
			hsp=0
			soundstop(name+"spin")
			crouch=down
		}
	}
}

//water
if (underwater()) {
	if (!water) {
		if (abs(vsp)>2) water_splash(1)
		watrlock=10 spinjump=0 fall=1 hang=0
		if (!pound) vsp=min(1,vsp/4)
		if (dive) {vsp+=2 hsp=max(0,abs(hsp)-2)*xsc dive=0}
		jumpspd=1
	}
	water=1 wf=0.45 eoll=0 run=0
	if (carry && carryid) {
		if !(jump) jump=1
		
		if (up)
		vsp=min(vsp-0.01,-1)
		else if (down)
		vsp=min(vsp+0.01,1)
		else
		vsp=approach_val(vsp,0,0.075)
	}
} else {
if (water) {
	water=0
	if (vsp<-1) vsp=min(vsp,-3+(-1*up))
	else {vsp=1 y+=1 water=underwater() y-=1}
	if (abs(vsp)>2) water_splash(0)
}
wf=1
}

//smoke generation
if (global.dustframe) {
if (slipnslide) {
i=shoot(x,y+10,psmoke) i.depth=depth+2
}
if (spin) {
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
twist=max(0,twist-1)
runvar=inch(runvar,run,0.05)
stomplok=max(0,stomplok-1)
wallkick=max(0,wallkick-1)
watrlock=max(0,watrlock-1)
throw=max(0,throw-1)
hang=max(0,hang-1)
swim=max(0,swim-1)
poundjump=max(0,poundjump-1)
wsk=(wsk+0.1) mod 4
if (spin) spinframe+=1
else spinframe=0
if (spinframe>=8) spinframe=0
if (sprung) {triplejump=0 triplexsc=0}

if (!jump && run && !bkey) run=0
if (!collpos(xsc*16,0) || !jump) hang=0
if (pound) {
crouch=1
hang=0
if (pound<15) pound+=1
else if (up || (water && vsp>5)) {pound=0 dive=-1 fall=0 insted=1 crouch=0 canstopjump=1}
else fall=4
} else poundcancel=0
if (fall=6 && sign(hsp)=xsc) fall=1
if (rise!=0) {crouch=1 hsp=0 xsc=rise risec+=1 if (risec=10) {risec=0 rise=0 crouch=down}}
sprung=0
if (slipnslide) {
crouch=1
if ((slobal=0 && (hsp=0 || ((left || right) && !down))) || jump) && (!collision(0,-12) || !size || size==5) {slipnslide=0 crouch=0}
}
jumpspd=min(jumpspd,100)

if (spinjump) {
fall=(vsp<0)
spinball+=1 if (spinball=16) {spinball=0
if (count_projectiles()<2 && !poundcancel && size=2 && !pound && !carry) {
ballspin=!ballspin
i=fire_projectile(x+8*ballspin,y+2)
fired=8
i.hspeed=-4+8*ballspin
}
}
}




jesus=(((boost && vsp<4)||(size==5 && !down && abs(hsp)>2.8)) && !water)
// if jeezus==1 {
    // if !plat plat=instance_create(0,0,ground)
    // plat.x=x-6
    // plat.y=y-80
    // plat.image_yscale=0.3
    // with instance_place(x,y+4,waterblock) other.plat.y=y
    // if plat.y=y-80 {
        // if plat with plat instance_destroy() plat=0
    // }
    // else if instance_place(x,y+4,plat) && splashtime<=0 {splashtime=9 water_splash(-1)}
    // splashtime-=1
// } else {splashtime=0 plat.x=verybignumber plat.y=verybignumber if plat with plat instance_destroy() plat=0}

// if (vsp>=0 )
// jesus=jeezus
// else jesus=0

com_endactions()


#define enemycoll
coll=noone extracheck=id inst=0
if (insta) {extracheck=myhitbox inst=1}


with (pswitch) if (phase!=other.id && !lock && !carry) {
    mask_index=spr_cratemask
    if (instance_place(x,y-other.vsp-16*!!other.diggity,other.id) || instance_place(x,y,extracheck)) other.coll=id
    mask_index=spr_mask16x16
}
with (enemy) if (phase!=other.id && !lock && !carry)
    if (instance_place(x,y-other.vsp-16*!!other.diggity,other.id) || instance_place(x,y,extracheck)) other.coll=id

if (coll) {
    if (!coll.damage_player_on_contact) {
    if ((hsp*xsc)>=2 && !carry) {triplejump+=0.5}  
    
        calcfall=fall
        if (fall=5 || fall=12) calcfall=0
        global.coll=id
        type=coll.object_index
            
        seqcount=max(1,seqcount)
        
        if (super) {
            if (water) seqcount=1
            enemyexplode(coll)
            exit
        }
        
       
        if (slipnslide && type!=spinyegg && type!=bulletbill) {
            instance_create(mean(x,coll.x),mean(y,coll.y),kickpart)
            enemydie(coll)                
            exit
        }
        
        if (coll.object_index=lakitu) if (coll.flee) exit
    
        
        if (star  
        || (spin && type!=spinyegg && type!=beetle && type!=shell)
        || (pound>13 && type!=piranha && type!=spinyegg && type!=spiny)) {
            if size==5 && !spin && !star && (hurt || piped || (intangible() && !diggity)) {if vsp<=0 {hurtplayer("enemy") exit} else playsfx(name+"smalljump",0,3.6) vsp=-3-((ckey && spin) || (akey && star))*1.5 canstopjump=akey if !pound exit else pound=0}
            instance_create(mean(x,coll.x),mean(y,coll.y),kickpart)
            if (type=hammerbro) seqcount=max(5,seqcount)
            enemydie(coll)                
            exit
        }
        
        if (spinjump) {
            if (fall && (hurt || piped || (intangible() && !diggity))) {if (y>coll.y && type!=shell && type!=bomb && type!=boo && type!=urchin ) hurtplayer("enemy")}
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
    
    if (hurt || piped || (intangible() && !diggity)) exit
        
        if (type=piranha || coll.damage_player_on_contact)  {
            hurtplayer("enemy")
            exit
        }
        
        if (spin) {
            if (type=shell) {if size==5 {playsfx(name+"smalljump",0,3.6) vsp=-3-ckey*1.5 canstopjump=akey exit} else if (coll.type!="beetle") {enemydie(coll) exit}}
            else if (type=beetle) {if size==5 {playsfx(name+"smalljump",0,3.6) vsp=-3-ckey*1.5 canstopjump=akey exit}}
            else if (type=spinyegg) {hurtplayer("enemy") exit}
            else {if size==5 {playsfx(name+"smalljump",0,3.6) vsp=-3-ckey*1.5 canstopjump=akey exit} else enemydie(coll) exit}
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
                if (bkey && !carry && !spin && !dive) {
                    coll.carry=id coll.owner=id coll.alarm[1]=600 coll.alarm[2]=-1 carryid=coll
                    carry=1
    skidding=0
                } else { 
                    if (coll.stop && !coll.kicked && size!=5) doscore_p(8000)
                    else if size!=5 {seqcount=max(seqcount,2+scorelok1) doscore_p()}
                    if (jump) {
                        if (vsp>0) {
                            vsp=-3-akey*1.5
                            canstopjump=akey
                            if size==5 playsfx(name+"smalljump",0,3.6)
                            if (fall=12) fall=5
                            dive=0
                        }
                    }
                    if size!=5 {
                    kicksound(0)
                    instance_create(mean(x,coll.x),mean(y,coll.y),kickpart)
                    with (coll) {spd=max(3,abs(other.hsp)+1) hspeed=spd*esign(x-other.x,other.xsc) owner=other.id kicked=1 stop=0 phase=owner}}
                }
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
                    if size==5 {playsfx(name+"smalljump",0,3.6) vsp=-3-akey*1.5 canstopjump=akey if fall=12 fall=5 exit}
                    with (coll) {hspeed=0 owner=noone phase=other.id stop=0 kicked=0 time=15}
                    vsp=-3-akey*1.5 canstopjump=akey sound("enemystomp") doscore_p() if (fall=12) fall=5 exit
                }
            }                    
        }
        
        if (type=blooper) {
            if (jump && (!calcfall || !water) && vsp>0) {if (calcfall) enemystomp(coll,5) else enemyexplode(coll)}
            else hurtplayer("enemy") exit
        }
        
        if (type=cheepred || type=cheepwhite) {
            if (jump && !calcfall) {enemyexplode(coll) exit}
            else {hurtplayer("enemy") exit}
        }
        
        if (jump) {
            if (type=koopa || type=beetle || object_is_ancestor(type,koopa)) {
                if (vsp<0) {
                    if (calcfall) hurtplayer("enemy")
                    else if size==5 {playsfx(name+"smalljump",0,3.6) vsp=-3-akey*1.5 canstopjump=akey exit}
                    else enemyexplode(coll) exit
                }
            } else {
                if (!calcfall && size!=5) {enemyexplode(coll) exit}
                if size==5 {playsfx(name+"smalljump",0,3.6) vsp=-3-akey*1.5 canstopjump=akey if fall=12 fall=5 exit}
                if (vsp<0) {hurtplayer("enemy") exit}
            }
            
            if (type=bulletbill)
            {
            if (coll.vspeed<0 && coll.y>y+8) {if size==5 {playsfx(name+"smalljump",0,3.6) vsp=-3-akey*1.5 canstopjump=akey exit} else {jump=1 fall=1 dive=0 vsp=-0.5 enemydie(coll) exit}}
            }
            
            if (type=goomba && seqcount=1 && !scorelok4) {seqcount=0 scorelok4=1}    
            if ((type=koopa || type=redkoopa) && seqcount=1) scorelok1=1    
            if (type=hopkoopa || type=redhover) seqcount=max(seqcount,1)
            if (type=hammerbro) seqcount=max(5,seqcount)
            if (fall=12) fall=5     
            dive=0                   
            if size==5 {if vsp<=0 {hurtplayer("enemy") exit} else playsfx(name+"smalljump",0,3.6) vsp=-3-akey*1.5 canstopjump=akey exit}
            enemystomp(coll) exit      
        } else if (coll.vspeed<0 && coll.y>y+8) {if size==5 {playsfx(name+"smalljump",0,3.6) vsp=-3-akey*1.5 canstopjump=akey exit} else {jump=1 fall=1 dive=0 vsp=-0.5 enemystomp(coll) exit}} //boll team watching me paste this same line 12 times like an idiot:
        
        hurtplayer("enemy")   
    } else if (!star && !flash) hurtplayer("enemy")
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
gk=0
fk=0
punch=0
bounce=0
spinjump=0
dive=0
oldsize=size
jumpbuffer=0
hyperspeed=0
hp=0
star=0
if (super) stopsuper()   


if ((((!size || size==5) && global.rings[p2]==0) || ohgoditslava || name="kid") && !shielded) {
   if (global.mplay>1 || global.debug || global.lemontest) alarm[7]=120
   if (global.gamemode="battle") dropcoins(0)
   die()
} else {
    rise=0
    slide=0
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

        fired=0
        if (shielded) {shielded=0} else if global.rings[p2]>0 {droprings(0)} else {if size>=3 size=2 size-=1}
        flash=1
        jump=1
        fall=6
        hsp=xsc*-2*wf vsp=-3*wf
}

//Block hitting

#define hitblocks
if typeblockhit=0{
with (blockcoll){
if (stonebump || (owner.size=0 || owner.size=5) && insted!=1 && !owner.tempkill && (biggie || cracked=0 || (cracked=1 && owner.size=5))) {
    if (!goinup) {if (insted!=2) owner.vsp=1.5 sound("itemblockbump") tpos=1}
} else if (stonebump || owner.size && owner.size!=5 && insted!=1 && !owner.tempkill && cracked=0 && biggie) { //break spiner
    if (!goinup) {if (insted!=2) owner.vsp=1.5 sound("itemblockbump") tpos=1}
    if (!stonebump){
    owner.vsp=1.5
    cracked=1
    i=instance_create(x,y,crackedbrick)
    i.owner=id
    i.biome=biome
    i.imcrack=1
    i.go=go
    i.tpos=1
    i.biggie=biggie
    }
}   
else { 
    com_breakblocks()
  }
 }
} else if typeblockhit=1{
	if (blockcoll.cc!=0 && !blockcoll.hit)
	hititembox()
	else if !(stoppounding) && place_meeting(x,y+max(4,vsp),blockcoll) {
		if (pound) {
			if (!poundcancel && !piped) {
				playsfx(name+"stomp")         
				shoot(x-8,y+4,psmoke,-2,-1)
				shoot(x+8,y+4,psmoke,2,-1)    
				poundjump=16
			}
		}
	}
}

#define hitwall
skiphsp=0
flight=0
if (object_is_ancestor(coll.object_index,hittable)) {
    if (dive) || (spin && abs(hsp)>0.5){
        s=vsp
        global.coll=id
        with (coll) {
        go=1
        event_user(0)
        }
        if (coll.object_index=brick && coll.hit || !instance_exists(coll)) coll=noone
    }
}
else {
    if (abut && dive && knuxcanclimb(coll)) {
        dive=0
        hsp=-(hsp+1)
        jumpspd=100 
        instance_create(x+6*xsc,y+8,kickpart)
        xsc*=-1 
        vsp=-4
        if (size) playsfx(name+"wallkick") else playsfx(name+"smallwallkick")
        wallkick=12 
        crouch=0
        run=1
        canstopjump=1
        hyperspeed=(abs(hyperspeed)+1)*xsc
        exit
    }
}

if (hurt) {hurt=0 fall=6 flash=1 fk=0}

if (!collpos(sign(hitside)*10,8,1)) {
    //gap running
    if (y<coll.y-12) {y=coll.y-14 coll=noone exit}
}

if (!skiphsp) hsp=0
hyperspeed=0         




#define landing
hang=0   
kicked=0
braking=0
double=0
flight=0
if (hellothisisajump) jumptiming=6
hellothisisajump=0
if spin{spin=0}

spinjump=0
dive=0

if (downpiped) {
    shoot(x-8,y+4,psmoke,-2,-1)
shoot(x+8,y+4,psmoke,2,-1)
    downpiped=0
}
if (hurt) {flash=1 fk=0 hsp=0 hurt=0}
           
playsfx(name+"step")

//jump buffering
if (jumpbuffer) jumpbuffer=-1

hang=0   
kicked=0

if (pound) {
	com_piping()
	if (!poundcancel && !piped) {
        playsfx(name+"stomp")         
        shoot(x-8,y+4,psmoke,-2,-1)
        shoot(x+8,y+4,psmoke,2,-1)    
		poundjump=16
    }
	with (itembox) if (cc!=0 && instance_place(x,y-max(4,other.vsp),other.id)) {
		go=1    
		event_user(0)
		picked=0
		other.stoppounding=!hit
		other.jump=1
		other.vsp=-0.1
	}
	with (crate) if (instance_place(x,y-max(4,other.vsp),other.id)) {
		event_user(0)
		other.stoppounding=1
		other.jump=1
		other.vsp=-0.1
	}
	if (stoppounding=1 && !down) {stoppounding=0}
	if stoppounding=0 {pound=0}     
}
 

#define death
if (event="create"){
alarmmp=60
alarm0=30
alarm1=300
sprite="dead"
didonce=0
frspd=1
fr=0
size=0
spindash=0
alpha=1

//with owner frn=unreal(skindat(name+" dead frames"),9999)
name=owner.name
p2=owner.p2
owner=owner.id
size=owner.size
xsc=owner.xsc
ysc=owner.ysc
water=owner.water
frn=owner.frn


if owner.sprite!=sprite {owner.sprite=sprite with owner set_sprite(sprite)}
} 
else if (event="step"){
if owner.sprite!=sprite {owner.sprite=sprite with owner set_sprite(sprite)}
alarm0=max(0,alarm0-1)
alarm1=max(0,alarm1-1)
if (alarm0=0 && !didonce) {
    vspeed=-3.5 gravity=0.1 didonce=1
}
alarmmp=max(0,alarmmp-1)
if alphadecay &&!alarmmp alpha-=0.1
if alarm1=0 instance_destroy()
} else if (event="draw"){

}

#define enterpipe
if (type="door") {
	//set_sprite("stand")
}
if (type="side") {
	if (carry) {crouch=1 set_sprite("crouch")}
}
if (type="down") {
	if (pound) {set_sprite("pound") frame=frame_number(sprite) vspeed=5 alarm[6]=6 fastpipe=1}
}

if (skidding) {soundstop(name+"skid") skidding=0}
braking=0
crouch=0
push=0
pound=0

#define exitpipe
if (type="door") {}
if (type="side") {}
if (type="up") {}
if (type="down") {}   
