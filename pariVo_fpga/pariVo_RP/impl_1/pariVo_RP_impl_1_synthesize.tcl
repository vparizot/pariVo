if {[catch {

# define run engine funtion
source [file join {C:/lscc/radiant/2024.1} scripts tcl flow run_engine.tcl]
# define global variables
global para
set para(gui_mode) "1"
set para(prj_dir) "C:/Users/vparizot/E155/pariVo/pariVo_fpga/pariVo_RP"
# synthesize IPs
# synthesize VMs
# propgate constraints
file delete -force -- pariVo_RP_impl_1_cpe.ldc
::radiant::runengine::run_engine_newmsg cpe -syn lse -f "pariVo_RP_impl_1.cprj" "SB_MAC16.cprj" -a "iCE40UP"  -o pariVo_RP_impl_1_cpe.ldc
# synthesize top design
file delete -force -- pariVo_RP_impl_1.vm pariVo_RP_impl_1.ldc
::radiant::runengine::run_engine_newmsg synthesis -f "pariVo_RP_impl_1_lattice.synproj" -logfile "pariVo_RP_impl_1_lattice.srp"
::radiant::runengine::run_postsyn [list -a iCE40UP -p iCE40UP5K -t SG48 -sp High-Performance_1.2V -oc Industrial -top -w -o pariVo_RP_impl_1_syn.udb pariVo_RP_impl_1.vm] [list C:/Users/vparizot/E155/pariVo/pariVo_fpga/pariVo_RP/impl_1/pariVo_RP_impl_1.ldc]

} out]} {
   ::radiant::runengine::runtime_log $out
   exit 1
}
