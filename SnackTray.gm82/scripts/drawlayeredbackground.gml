var vx,bw,p,t,name,water,horizon,dy,curr,i,repeats,yv;

curr=argument[1]

with (bgmanager) {

    d3d_set_projection_perspective(view_xview[curr],view_yview[curr]+global.screenheight,global.screenwidth,-global.screenheight,0)
    d3d_set_depth(0)

    horizon=gamemanager.horizon[curr]

    water=gamemanager.water[curr]+4
    dy=view_yview[curr]
    yv=view_yview[curr] //view_yview apparently messes up special stage rendering. Lol
                        //SIDENOTE: would like a Chat with whoever used view_yview instead of view_yview[curr] like 8 times in this script??
    if (instance_exists(moranboll)) {horizon=0 water=0 bgname="specialsky" dy=0 yv=0}
    else bgname=gamemanager.players[curr].region.typebg+"sky"

    if settings("removeassets") maxslot=0
    //if (horizon+316<view_yview[curr]) maxslot=-1 //Commented this out 'cause it keeps making the below bg disappear lol -moster
    
    ky=gamemanager.playesr[view_current].region.ky

    
    
    for (i=0;i<=sky_maxslot;i+=1) {
        name=bgname+string(i)     
        spr=sky_sprite[i]
        if argument[0]==sky_foreground[i]
        if ((horizon+sky_height[i]+sky_offset_y[i])>view_yview[curr])
        if (spr) {
            

            x_view=max(view_xview[curr])
            {  
                //Horizontal Parallaxing, based on our view's position, we parallax.
                if sky_intentedwidth[i]!=0{

                    parx_view=(x_view/(gamemanager.righthand[curr]-global.screenwidth))*(sky_intentedwidth[i]-global.screenwidth)
                }else parx_view=x_view
                draw_x=x_view+(parx_view-gamemanager.origin[curr])*-(sky_par_x[i]/100)

                draw_x+= ((gamemanager.righthand[curr]-sky_width[i])-gamemanager.origin[curr])*(sky_regionedge_x[i]/100)

                draw_x+=sky_offset_x[i]*WackyMultiplier

                if sky_clamp_x[i] {
                    draw_x= median(
                        (x_view-gamemanager.origin[curr])-(sky_width[i]-global.screenwidth),
                        draw_x,
                        (x_view-gamemanager.origin[curr])+(sky_width[i]-global.screenwidth)
                    )

                }

                if sky_scroll_x[i]!=0 {
                    draw_x+=(global.bgscroll*-sky_scroll_x[i]/100) mod sky_width[i]
                }

                if !sky_noloop_x[i]{
                    while draw_x<(x_view-sky_width[i]) draw_x+=sky_width[i]

                }

            }
            y_view=min(view_yview[curr],horizon-global.screenheight)
            {
                if sky_intentedheight[i]!=0{
                    pary_view=(y_view/(horizon-global.screenheight))*(sky_intentedheight[i]-global.screenheight)

                }else pary_view=y_view

                //Vertical Parallaxing, based on our view's position, we parallax.
                draw_y=y_view+(pary_view)*-(sky_par_y[i]/100)
                
                draw_y+= ((horizon-sky_height[i]))*(sky_regionedge_y[i]/100)

                draw_y+=sky_offset_y[i]
                
                if sky_clamp_y[i] {
                    draw_y= median( 
                        y_view-(sky_height[i]-global.screenheight),
                        draw_y,
                        y_view+(sky_height[i]-global.screenheight)
                    )
                    
                }
                
                if sky_scroll_y[i]!=0 {
                    draw_y+=(global.bgscroll*-sky_scroll_y[i]/100) mod sky_height[i]
                }      
                
                          
            } 
        
            
           

            bm=sky_bm[i]
            if (bm=1) draw_set_blend_mode(bm_add)
            if (bm=2) draw_set_blend_mode(bm_subtract)
            
            vrepeats=max((ceil(global.screenheight/sky_height[i])+1 )*(sky_noloop_y[i]==0),1) 
            repeats= max((ceil(global.screenwidth/sky_width[i]) +1)*(sky_noloop_x[i]==0),1)
            used_draw_x=draw_x
            if !(sky_noloop_y[i] && (draw_y+sky_height[i])<y_view) && !(sky_noloop_x[i] && (draw_x+sky_width[i])<x_view)
            repeat (vrepeats){ 
                repeat (repeats) {

                    draw_sprite(spr,0,used_draw_x,draw_y)
                    used_draw_x+=sky_width[i]
                }
                draw_y+=sky_height[i]
                used_draw_x=draw_x
                
            }
            
            if (bm) draw_set_blend_mode(0)
        }
    }  
    draw_below(argument[0],argument[1])
    if (water<(view_yview[view_current]+global.screenheight)) {
    if (instance_exists(moranboll)) {bgname="specialsky" dy=0}
    else bgname=gamemanager.players[curr].region.typebg+"water"                     
        ky=gamemanager.players[curr].region.ky
        for (i=0;i<=water_maxslot;i+=1) {
            name=bgname+string(i)     
            spr=water_sprite[i]
            if argument[0]==water_foreground[i]
            if (spr) {
        
                x_view=max(view_xview[curr])
                {
                    //Horizontal Parallaxing, based on our view's position, we parallax.
                    if water_intentedwidth[i]!=0{

                        parx_view=(x_view/(gamemanager.righthand[curr]-global.screenwidth))*(water_intentedwidth[i]-global.defaultscreenwidth)
                    }else parx_view=x_view
                    draw_x=x_view+(parx_view-gamemanager.origin[curr])*-(water_par_x[i]/100)

                    draw_x+= ((gamemanager.righthand[curr]-water_width[i])-gamemanager.origin[curr])*(water_regionedge_x[i]/100)

                    draw_x+=water_offset_x[i]*WackyMultiplier

                    if water_clamp_x[i] {
                        draw_x= median(
                            (x_view-gamemanager.origin[curr])-(water_width[i]-global.screenwidth),
                            draw_x,
                            (x_view-gamemanager.origin[curr])+(water_width[i]-global.screenwidth)
                        )

                    }

                    if water_scroll_x[i]!=0 {
                        draw_x+=(global.bgscroll*-water_scroll_x[i]/100) mod water_width[i]
                    }

                    if !water_noloop_x[i]{
                        while draw_x<(x_view-water_width[i]) draw_x+=water_width[i]

                    }

                }

                //We want the below bg's vertical parallax point to be horizon-global.screenheight, so all variables relative to 0 have to change to represent this.     
                //horizon= ky-horizon  y_view=y_view-horizon                       
                y_view=max(water,view_yview[curr] )-water                
                {
                    if water_intentedheight[i]!=0{
                        pary_view=(y_view/((ky-water/2)-global.screenheight))*(water_intentedheight[i]-global.screenheight)
                    
                    }else pary_view=y_view
                
                
                    //Vertical Parallaxing, based on our view's position, we parallax.
                    draw_y=y_view+(pary_view)*-(water_par_y[i]/100)

                    draw_y+= (((ky-(water/2))-water_height[i]))*(water_regionedge_y[i]/100)

                    draw_y+=water_offset_y[i]

                    if water_clamp_y[i] {
                        draw_y= median(
                            y_view-(water_height[i]-global.screenheight),
                            draw_y,
                            y_view+(water_height[i]-global.screenheight)
                        )

                    }

                    if water_scroll_y[i]!=0 {
                        draw_y+=(global.bgscroll*-water_scroll_y[i]/100) mod water_height[i]
                    }


                }




                bm=water_bm[i]
                if (bm=1) draw_set_blend_mode(bm_add)
                if (bm=2) draw_set_blend_mode(bm_subtract)

                vrepeats=max((ceil(global.screenheight/water_height[i])+1 )*(water_noloop_y[i]==0),1)
                repeats= max((ceil(global.screenwidth/water_width[i]) +1)*(water_noloop_x[i]==0),1)
                used_draw_x=draw_x
                repeat (vrepeats){
                    repeat (repeats) {
                        if (horizon<y_view)
                        draw_sprite(spr,0,used_draw_x,draw_y)
                        else draw_sprite(spr,0,used_draw_x,draw_y+(horizon-y_view))
                        used_draw_x+=water_width[i]
                    }
                    draw_y+=water_height[i]
                    used_draw_x=draw_x

                }

                if (bm) draw_set_blend_mode(0)
            }
        }
    }
    d3d_set_projection_ortho(view_xview[curr],view_yview[curr],global.screenwidth,global.screenheight,0)
}
