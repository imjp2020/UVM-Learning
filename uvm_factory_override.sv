//===============================================================
//   UVM Factory override methods
//===============================================================

`include "uvm_macros.svh"
import uvm_pkg::*;

//---------------------------------
//    Define base_agent 
//---------------------------------

class base_agent  extends uvm_agent;
  
  string m_name;
  
  `uvm_component_utils(base_agent)
  
  function new(string name= "base_agent",uvm_component parent=null);
    super.new(name,parent);
    name=m_name;
  endfunction 
    
endclass  

//---------------------------------
//    Define child_agent 
//---------------------------------

class child_agent  extends base_agent;
  
  string m_name;
  
  `uvm_component_utils(child_agent)
  
  function new(string name= "child_agent",uvm_component parent=null);
    super.new(name,parent);
    name=m_name;
  endfunction 
    
endclass 


//---------------------------------
//    Define base_env
//---------------------------------

class base_env  extends uvm_env;
  
  base_agent m_agent;
 
  
  `uvm_component_utils(base_env)
  
  function new(string name= "base_env",uvm_component parent=null);
    super.new(name,parent);
  //  name=m_name;
  endfunction 
   
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    
    m_agent =base_agent::type_id::create("m_agent",this);
    
    `uvm_info(get_type_name,"[base_env build ] ",UVM_LOW)
    `uvm_info("AGENT",$sformatf("Factory retured of agent type type=%s path=%s",m_agent.get_type_name(),m_agent.get_full_name()),UVM_MEDIUM)
  endfunction
  
//  virtual task run_phase(uvm_phase phase);
//    #100 global_stop_request();
//  endfunction
  
  
    
endclass  

//---------------------------------
//    Define base_test
//---------------------------------

class base_test extends uvm_test;
  
 `uvm_component_utils(base_test)
  
  base_env m_env;
  
  function new(string name ,uvm_component parent);
    super.new(name,parent);
  endfunction 
    

  
  virtual function void build_phase (uvm_phase phase);
    
    uvm_factory factory =uvm_factory::get();
    super.build_phase(phase);
    
    
    //Enable one of Method USE 'ifdefs to make more feasible to do
    //1.   
    //set_type_override_by_type(base_agent::get_type(), child_agent::get_type());
    
    //2 .using inst_overide observe path of tb_hiee in logs
    // set_inst_override_by_type("m_env.*",base_agent::get_type(), child_agent::get_type());  
    
    //3.
    //actory.set_type_override_by_name("base_agent","child_agent",{get_full_name(),".m_env.*"});
    
    // 4. Override a particular instance by its name
    //factory.set_inst_override_by_name("base_agent", "child_agent", {get_full_name(), ".m_env.*"});
    
    factory.print();
    
    m_env =base_env::type_id::create("m_env",this);
    
    //`uvm_info(get_type_name,"[base test build ] ",UVM_LOW)
    //`uvm_info("AGENT",$sformatf("Factory retured of agent type type=%s path=%s",m_agent.get_type_name(),m_agent.get_full_name()),UVM_MEDIUM)
  endfunction
    
  
   virtual function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction
  

endclass  

//---------------------------------------------------
//   run_test();
//----------------------------------------------------

module tb;
  initial 
    run_test("base_test");
endmodule
