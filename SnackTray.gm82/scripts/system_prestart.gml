//set up game directories
global.workdir=working_directory+"\"
global.tempdir=temp_directory+"\"

readme_modding()

i=0
repeat (parameter_count()) {
    switch (parameter_string(i)) {
        case "-datadir":
            j=0
            repeat (parameter_count()) {
                moddatastore=global.moddata
                global.moddata=unreal(parameter_string(i+1),moddatastore)
                j+=1
            }

            break

        case "-savedir":
            j=0
            repeat (parameter_count()) {
                savedirstore=global.savedir
                global.savedir=global.workdir+unreal(parameter_string(i+1),savedirstore)
                j+=1
            }

            break

        case "-crashdir":
            j=0
            repeat (parameter_count()) {
                crashdirstore=global.crashdir
                global.crashdir=unreal(parameter_string(i+1),crashdirstore)
                j+=1
            }

            break

        case "-skindir":
            j=0
            repeat (parameter_count()) {
                skindirstore=global.skindir
                global.skindir=global.workdir+unreal(parameter_string(i+1),skindirstore)
                j+=1
            }

            break

        case "-moddir":
            j=0
            repeat (parameter_count()) {
                moddirstore=global.moddir
                global.moddir=global.workdir+unreal(parameter_string(i+1),moddirstore)
                j+=1
            }

            break

        default:
            break
    }
    i+=1
}

sureface_init()

skin_messagebox()
set_caption(gametitle)

//runner version check
if (!version_check()) {
    show_message("This game requires GameMaker 8.1.141 Standard or newer (8.2 is recommended).##You cannot use GameMaker 8.1 Lite or older versions like 8.1.91.##If you're having trouble, hit the official discord and ask for help. You can find a link to it on the main menu.")
    game_end()
    global.kill=1
    exit
}

missing=findfiles("sbfmd.dll","sb39d.dll","sbsnd.dll","sbjoy.dll","sbsdl.dll","sbpow.dll","sbfoc.dll")
if (missing!="") {
    show_message("The following files cannot be found:##"+missing+"##Please reinstall the game.")
    game_end()
    global.kill=1
    return 0
}

//game is go
return 1
