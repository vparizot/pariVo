if {[catch {

# define run engine funtion
source [file join {C:/lscc/radiant/2024.1} scripts tcl flow run_engine.tcl]
# define global variables
global para
set para(gui_mode) "1"
set para(prj_dir) "C:/Users/vparizot/E155/pariVo/pariVo_fpga/ProjectPariVo"
# synthesize IPs
# synthesize VMs
# propgate constraints
file delete -force -- ProjectPariVo_impl_1_cpe.ldc
::radiant::runengine::run_engine_newmsg cpe -syn lse -f "ProjectPariVo_impl_1.cprj" "SB_MAC16.cprj" -a "iCE40UP"  -o ProjectPariVo_impl_1_cpe.ldc
# synthesize top design
file delete -force -- ProjectPariVo_impl_1.vm ProjectPariVo_impl_1.ldc
::radiant::runengine::run_engine_newmsg synthesis -f "ProjectPariVo_impl_1_lattice.synproj" -logfile "ProjectPariVo_impl_1_lattice.srp"
::radiant::runengine::run_postsyn [list -a iCE40UP -p iCE40UP5K -t SG48 -sp High-Performance_1.2V -oc Industrial -top -w -o ProjectPariVo_impl_1_syn.udb ProjectPariVo_impl_1.vm] [list C:/Users/vparizot/E155/pariVo/pariVo_fpga/ProjectPariVo/impl_1/ProjectPariVo_impl_1.ldc]

} out]} {
   ::radiant::runengine::runtime_log $out
   exit 1
}
