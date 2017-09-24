#####################################################################

CFLAGSREL := \
	-m32 -pipe -march=pentium4 -O3 -fomit-frame-pointer -ffast-math \
	-falign-loops=2 -falign-jumps=2 -falign-functions=2 \
	-fno-strict-aliasing -fstrength-reduce -DNDEBUG $(CFLAGSEXT)

%.o : %.nasm
	$(NASM) -f elf -o $@ $<
%.o : %.s
	$(CC) $(CFLAGS) -DELF -x assembler-with-cpp -c -o $@ $<
%.o : %.c
	$(CC) $(CFLAGS) -c -o $@ $<

#####################################################################
	
BOTLIBOBJS := \
	botlib/be_aas_bspq3.o botlib/be_aas_cluster.o \
	botlib/be_aas_debug.o botlib/be_aas_entity.o \
	botlib/be_aas_file.o botlib/be_aas_main.o \
	botlib/be_aas_move.o botlib/be_aas_optimize.o \
	botlib/be_aas_reach.o botlib/be_aas_route.o \
	botlib/be_aas_routealt.o botlib/be_aas_routetable.o \
	botlib/be_aas_sample.o botlib/be_ai_char.o \
	botlib/be_ai_chat.o botlib/be_ai_gen.o \
	botlib/be_ai_goal.o botlib/be_ai_move.o \
	botlib/be_ai_weap.o botlib/be_ai_weight.o botlib/be_ea.o \
	botlib/be_interface.o botlib/l_crc.o botlib/l_libvar.o \
	botlib/l_log.o botlib/l_memory.o botlib/l_precomp.o \
	botlib/l_script.o botlib/l_struct.o
COMMONOBJS := \
	qcommon/cm_load.o qcommon/cm_patch.o qcommon/cm_polylib.o \
	qcommon/cm_test.o qcommon/cm_trace.o qcommon/cmd.o \
	qcommon/common.o qcommon/cvar.o qcommon/files.o \
	qcommon/md4.o qcommon/msg.o qcommon/net_chan.o \
	qcommon/huffman.o qcommon/unzip.o
SERVEROBJS := \
	server/sv_bot.o server/sv_ccmds.o server/sv_client.o \
	server/sv_game.o server/sv_init.o server/sv_main.o \
	server/sv_net_chan.o server/sv_snapshot.o \
	server/sv_world.o server/sv_wallhack.o 
VMOBJS := \
	qcommon/vm.o qcommon/vm_interpreted.o
SHAREDOBJS := \
	game/q_shared.o game/q_math.o
DEDOBJS := \
	null/null_client.o null/null_input.o null/null_snddma.o
UNIXOBJS := \
	unix/linux_common.o unix/unix_main.o unix/unix_net.o \
	unix/unix_shared.o unix/linux_signals.o
ASMOBJS := \
	unix/ftol.o unix/snapvector.o

#####################################################################

SVOBJS := \
	$(BOTLIBOBJS) $(ASMOBJS) $(SERVEROBJS) $(COMMONOBJS) $(DEDOBJS) \
	$(VMOBJS) $(UNIXOBJS) $(SHAREDOBJS)

#####################################################################

server: CC := gcc
server: NASM := nasm
server: CFLAGS := \
	$(CFLAGSREL) -DBOTLIB -DDEDICATED -DC_ONLY -DDLL_ONLY -DFEATURE_ANTICHEAT
server: LDFLAGS := -m32 -ldl -lm
server: $(SVOBJS)
	$(CC) -o wolfded.x86 $(SVOBJS) $(LDFLAGS)
	strip -s wolfded.x86
server-clean:
	rm $(SVOBJS) 2> /dev/null ; exit 0

#####################################################################
