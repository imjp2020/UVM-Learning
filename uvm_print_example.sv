//-------------------------------------------------------------- 
//    UVM Print Methods 
//--------------------------------------------------------------

//  Use of MACROS and variable printing differnt methods 
typedef enum {EN,DIS}  mode;

import uvm_pkg::*;
 `include "uvm_macros.svh"

class my_item  extends uvm_object ;
  
  rand bit [31:0]  m_addr;
  rand bit [31:0]  m_data;
  rand byte        m_data[3];
  rand int         m_que[$];
  rand  mode       m_mode;
  string           m_tb;

  constraint addr_c {m_addr < 15;}
 
//--------------------------------------------------------
//`uvm_object_utils_begin `uvm_object_utils_end  Method-1
//--------------------------------------------------------
/*`uvm_object_utils_begin(my_item)
     `uvm_field_int		(m_addr, UVM_ALL_ON)
     `uvm_field_int		(m_data, UVM_ALL_ON)
     `uvm_field_string	(m_tb,UVM_ALL_ON)
 	 `uvm_field_sarray_int(m_data,UVM_ALL_ON)
     `uvm_field_enum (mode,m_mode, UVM_ALL_ON)
  	 `uvm_field_queue_int(m_que,UVM_ALL_ON)
 `uvm_object_utils_end  */
  
//---------------------------------------------------------
//   `uvm_object_utils(obj)  Method -2 with do_print()
//--------------------------------------------------------- 

  `uvm_object_utils(my_item)  
 
  function new (string name = "my_item");
		super.new(name);
        m_tb=name;
	endfunction: new
  
//---------------------------------------------------
//  do_print method  add more vars and do prints 
//---------------------------------------------------
  
  virtual function void do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_field_int("m_data\n",m_data,$bits(m_data),UVM_HEX) ;
    printer.print_field_int("m_addr\n",m_addr,$bits(m_addr),UVM_HEX) ;
    printer.print_field_int("m_mode\n",m_mode,$bits(m_mode),UVM_HEX) ;
    printer.print_field_int("m_tb\n",m_tb,$bits(m_tb),UVM_HEX) ;
  
  endfunction
  
//-----------------------------------------------------
//   convert2string method  
//-----------------------------------------------------  
   
  virtual function string convert2string();    
    string info = "";    
      $sformat(info,"%s info m_addr=%h\n",info,m_addr); 
      foreach(m_data[i])begin
      $sformat(info,"%s m_data=%h\n",info,m_data); 
    end  
    return info;
  endfunction  
  
endclass  

//-------------------------------------------------------
//     class test
//-------------------------------------------------------
class test extends uvm_test;

   `uvm_component_utils(test)
  
 function new (string name = "test", uvm_component parent=null);
		super.new (name, parent);
 endfunction : new	
    
 function void build_phase (uvm_phase phase);
     //super.build_phase (phase);
   my_item item_h  = my_item::type_id::create ("item_h");
   my_item item1 = my_item::type_id::create ("item1");
   my_item item2  = my_item::type_id::create ("item2");
   
   uvm_top.print_topology;
   
   item_h.randomize();   
   item2.randomize();  
   item1.randomize();  
   
//-------------------------------------
     //item_h.print();   
     //item1.print();
     //item2.print();
//------------------------------------- 
   
   item1.copy(item2);
   `uvm_info("In TEST"," item1.copy(item2)",UVM_LOW)
   //item2.print();
   
//-------------------------------------
// use of sprint()  2
//-------------------------------------
   
   `uvm_info(get_type_name(),$sformatf("Data Members %s",item_h.sprint()),UVM_LOW)
   
//----------------------------------------
//   convert2string called    3
//----------------------------------------
   
   `uvm_info(get_type_name(),$sformatf(" convert2string=%s ",item_h.convert2string()),UVM_LOW)
   
endfunction: build_phase
endclass

module tb_top;
  
  initial
    begin
      run_test("test");
    end
  
endmodule
