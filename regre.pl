#!/usr/bin/perl 
require "ParseExcl.pl";
############################################
# #  this script is used to auto gen ral # #
# #  author : zhangpingping              # #
# #  date   : 2018.04.16                 # #
# #  version: 1.0                        # #
# ##########################################

# # hash declare ##
my $Ral           = {};      # reg_model related
my $sub_reg_block = {};      # reg_block related
my $sub_reg       = {};      # uvm_reg   related
my $sub_reg_field = {};      # reg_field related
                             # below is the cnt declare and init
my $Ral_cnt = 0;             
my $sub_reg_block_cnt = 0;
my $sub_reg_cnt = 0;
my $sub_reg_field_cnt = 0;

## begin parse ral.txt 
open my $txt_file,"< ral.txt" or die "can not open file ral.txt: $!";

## below parse ral.txt and push the corresponding
## info into each hash 
foreach(<$txt_file>){
   if($_=~ m#^Ral\s+(_|\w+)\s+(\w+)\s+(\w+)\s+(UVM.*ENDIAN)\s+(UVM.*COVERAGE)\s+(\w+)#){
      $Ral->{$Ral_cnt}{NAME}         = $1; # reg_model name
      $Ral->{$Ral_cnt}{Bus_Width}    = $2; # Bus_Width/byte
      $Ral->{$Ral_cnt}{Base_Addr}    = $3; # Base_Addr
	  $Ral->{$Ral_cnt}{Endian}       = $4; # Endian
      $Ral->{$Ral_cnt}{Uvm_Coverage} = $5; # Uvm_Coverage
      $Ral->{$Ral_cnt}{Byte_Based}   = $6; # Byte_Based
      $Ral_cnt++;                          # increase Ral_cnt
	  $sub_reg_block_cnt = 0;              # clear sub_reg_block_cnt
   }
   if($_=~m#^sub_reg_block\s+(_|\w+)\s+(\w+)\s+(\w+)\s+(UVM.*ENDIAN)\s+(UVM.*COVERAGE)\s+(\w+)\s+(\w+)\s+(_|\w+)#){
      $sub_reg_block->{$Ral_cnt-1}{$sub_reg_block_cnt}{NAME}          = $1; # reg_block name
      $sub_reg_block->{$Ral_cnt-1}{$sub_reg_block_cnt}{Bus_Width}     = $2; # Bus_Width/byte
	  $sub_reg_block->{$Ral_cnt-1}{$sub_reg_block_cnt}{Base_Addr}     = $3; # Base_Addr
	  $sub_reg_block->{$Ral_cnt-1}{$sub_reg_block_cnt}{Endian}        = $4; # Endian
	  $sub_reg_block->{$Ral_cnt-1}{$sub_reg_block_cnt}{Uvm_Coverage}  = $5; # Uvm_Coverage
	  $sub_reg_block->{$Ral_cnt-1}{$sub_reg_block_cnt}{Byte_Based}    = $6; # Byte_Based
	  $sub_reg_block->{$Ral_cnt-1}{$sub_reg_block_cnt}{Addr_Offset}   = $7; # Addr_Offset
	  $sub_reg_block->{$Ral_cnt-1}{$sub_reg_block_cnt}{Backdoor_Path} = $8; # Backdoor_Path
      $sub_reg_block_cnt++;                                                 # increase sub_reg_block_cnt
      $sub_reg_cnt = 0;                                                     # clear sub_reg_cnt
   }
   if($_=~m#^sub_reg\s+(_|\w+)\s+(\w+)\s+(UVM.*COVERAGE)\s+(\w+)\s+(\w+)#){
      $sub_reg->{$Ral_cnt-1}{$sub_reg_block_cnt-1}{$sub_reg_cnt}{NAME}         = $1;    # uvm_reg name
	  $sub_reg->{$Ral_cnt-1}{$sub_reg_block_cnt-1}{$sub_reg_cnt}{Reg_Width}    = $2;    # Reg_Width/bit
	  $sub_reg->{$Ral_cnt-1}{$sub_reg_block_cnt-1}{$sub_reg_cnt}{Uvm_Coverage} = $3;    # Uvm_Coverage
	  $sub_reg->{$Ral_cnt-1}{$sub_reg_block_cnt-1}{$sub_reg_cnt}{Read_Write}   = $4;    # Read/Write
	  $sub_reg->{$Ral_cnt-1}{$sub_reg_block_cnt-1}{$sub_reg_cnt}{Addr_Offset}  = $5;    # Addr_Offset
	  $sub_reg_cnt++;                                                                   # increase sub_reg_cnt
	  $sub_reg_field_cnt = 0;                                                           # clear sub_reg_field_cnt
   }
   if($_=~m#^sub_reg_field\s+(_|\w+)\s+(\w+)\s+(\w+)\s+(\w+)\s+(\w+)\s+(\w+)\s+(\w+)\s+(\w+)\s+(\w+)\s+(_|\w+)#){
      $sub_reg_field->{$Ral_cnt-1}{$sub_reg_block_cnt-1}{$sub_reg_cnt-1}{$sub_reg_field_cnt}{NAME}           = $1;  # uvm_reg_field name
	  $sub_reg_field->{$Ral_cnt-1}{$sub_reg_block_cnt-1}{$sub_reg_cnt-1}{$sub_reg_field_cnt}{Width}          = $2;  # Width/bit
      $sub_reg_field->{$Ral_cnt-1}{$sub_reg_block_cnt-1}{$sub_reg_cnt-1}{$sub_reg_field_cnt}{Start_Position} = $3;  # Start_Position
	  $sub_reg_field->{$Ral_cnt-1}{$sub_reg_block_cnt-1}{$sub_reg_cnt-1}{$sub_reg_field_cnt}{Store_Method}   = $4;  # Store_Method
	  $sub_reg_field->{$Ral_cnt-1}{$sub_reg_block_cnt-1}{$sub_reg_cnt-1}{$sub_reg_field_cnt}{Volatile}       = $5;  # Volatile
	  $sub_reg_field->{$Ral_cnt-1}{$sub_reg_block_cnt-1}{$sub_reg_cnt-1}{$sub_reg_field_cnt}{Reset_Value}    = $6;  # Reset_Value
	  $sub_reg_field->{$Ral_cnt-1}{$sub_reg_block_cnt-1}{$sub_reg_cnt-1}{$sub_reg_field_cnt}{If_Reset}       = $7;  # If_Reset
	  $sub_reg_field->{$Ral_cnt-1}{$sub_reg_block_cnt-1}{$sub_reg_cnt-1}{$sub_reg_field_cnt}{If_Randomize}   = $8;  # If_Randomize
	  $sub_reg_field->{$Ral_cnt-1}{$sub_reg_block_cnt-1}{$sub_reg_cnt-1}{$sub_reg_field_cnt}{Single_Store}   = $9;  # Single_Store
	  $sub_reg_field->{$Ral_cnt-1}{$sub_reg_block_cnt-1}{$sub_reg_cnt-1}{$sub_reg_field_cnt}{Backdoor_Path}  = $10; # Backdoor_Path
	  $sub_reg_field_cnt++;
   }
}

# reg_model level foreach 
foreach(0..$Ral_cnt-1){
   my $ral_cnt = $_;      
   open my $Ral_handle,"> $Ral->{$ral_cnt}{NAME}.sv" or die "can't open file $Ral->{$Ral_cnt}{NAME}.sv: $!"; #reg_model_name.sv
   
   print $Ral_handle "class $Ral->{$ral_cnt}{NAME} extends uvm_reg_block;\n"; # reg_model_name extends 
   print $Ral_handle "\n";                                                    # uvm_reg_block
   print $Ral_handle "\n";
   print $Ral_handle "   `uvm_object_utils($Ral->{$ral_cnt}{NAME})\n";        # `uvm_object_utils(reg_model_name)
   print $Ral_handle "\n";
   
   # reg_block level foreach
   foreach(keys %{$sub_reg_block->{$ral_cnt}}){
      my $reg_block_cnt = $_;   
	  print $Ral_handle "   rand $sub_reg_block->{$ral_cnt}{$reg_block_cnt}{NAME}  $sub_reg_block->{$ral_cnt}{$reg_block_cnt}{NAME}_ins;\n";                              # rand reg_block_name reg_block_name_ins;
   }
   print $Ral_handle "\n";  # below is the reg_model new function
   print $Ral_handle "   function new(input string name=\"$Ral->{$ral_cnt}{NAME}\");\n";
   print $Ral_handle "      super.new(name,$Ral->{$ral_cnt}{Uvm_Coverage});\n";
   print $Ral_handle "   endfunction\n";
   print $Ral_handle "\n";
 
   print $Ral_handle "   virtual function void build();\n";  # reg_model build() function
   print $Ral_handle "      default_map = create_map(\"default_map\",$Ral->{$ral_cnt}{Base_Addr},$Ral->{$ral_cnt}{Bus_Width},$Ral->{$ral_cnt}{Endian},$Ral->{$ral_cnt}{Byte_Based});\n";
   print $Ral_handle "\n";
   
   # reg_block level foreach
   foreach(keys %{$sub_reg_block->{$ral_cnt}}){
       my $reg_block_cnt = $_;
       print $Ral_handle "      $sub_reg_block->{$ral_cnt}{$reg_block_cnt}{NAME}_ins = $sub_reg_block->{$ral_cnt}{$reg_block_cnt}{NAME}::type_id::create(\"$sub_reg_block->{$ral_cnt}{$reg_block_cnt}{NAME}_ins\");\n";  # type_id::create
	   print $Ral_handle "      $sub_reg_block->{$ral_cnt}{$reg_block_cnt}{NAME}_ins.configure(this,\"\");\n";  # configure()
	   print $Ral_handle "      $sub_reg_block->{$ral_cnt}{$reg_block_cnt}{NAME}_ins.build();\n";               # build()
	   print $Ral_handle "      $sub_reg_block->{$ral_cnt}{$reg_block_cnt}{NAME}_ins.lock_model();\n";          # lock_model()
	   print $Ral_handle "      default_map.add_submap($sub_reg_block->{$ral_cnt}{$reg_block_cnt}{NAME}_ins.default_map,16'h$sub_reg_block->{$ral_cnt}{$reg_block_cnt}{Addr_Offset});\n";                                                                     # add_submap()
	   print $Ral_handle "      $sub_reg_block->{$ral_cnt}{$reg_block_cnt}{NAME}_ins.set_hdl_root_path(\"$sub_reg_block->{$ral_cnt}{$reg_block_cnt}{Backdoor_Path}\");\n";
	   print $Ral_handle "\n";

	   open my $block_handle,"> $sub_reg_block->{$ral_cnt}{$reg_block_cnt}{NAME}.sv" or die "can't open file $sub_reg_block->{$ral_cnt}{$reg_block_cnt}{NAME}.sv: $!";  # begin to write reg_block_name.sv

	   # uvm_reg level foreach 
	   foreach(keys %{$sub_reg->{$ral_cnt}{$reg_block_cnt}}){
	      my $reg_cnt = $_;

		  # uvm_reg_name extends uvm_reg
	      print $block_handle "class $sub_reg->{$ral_cnt}{$reg_block_cnt}{$reg_cnt}{NAME} extends uvm_reg;\n";
		  print $block_handle "\n";
		  # `uvm_object_utils(uvm_reg_name)
		  print $block_handle "   `uvm_object_utils($sub_reg->{$ral_cnt}{$reg_block_cnt}{$reg_cnt}{NAME})\n";
		  print $block_handle "\n";
		  # uvm_reg_name new function
		  print $block_handle "   function new(input string name=\"$sub_reg->{$ral_cnt}{$reg_block_cnt}{$reg_cnt}{NAME}\");\n";
		  print $block_handle "      super.new(name,$sub_reg->{$ral_cnt}{$reg_block_cnt}{$reg_cnt}{Reg_Width},$sub_reg->{$ral_cnt}{$reg_block_cnt}{$reg_cnt}{Uvm_Coverage});\n";
		  print $block_handle "   endfunction\n";
		  print $block_handle "\n";
          
		  #uvm_reg_field level foreach 
		  foreach(keys %{$sub_reg_field->{$ral_cnt}{$reg_block_cnt}{$reg_cnt}}){
		     my $reg_field_cnt = $_;
			 # rand uvm_reg_field rand reg_field_name
		     print $block_handle "   rand uvm_reg_field $sub_reg_field->{$ral_cnt}{$reg_block_cnt}{$reg_cnt}{$reg_field_cnt}{NAME};\n";
		  }
		  print $block_handle "\n";  # below is the uvm_reg_name build() function
		  print $block_handle "   virtual function void build();\n";
		  print $block_handle "\n";

          #uvm_reg_field level foreach
          foreach(keys %{$sub_reg_field->{$ral_cnt}{$reg_block_cnt}{$reg_cnt}}){

		     my $reg_field_cnt = $_;
			 print $block_handle "      $sub_reg_field->{$ral_cnt}{$reg_block_cnt}{$reg_cnt}{$reg_field_cnt}{NAME} = uvm_reg_field::type_id::create(\"$sub_reg_field->{$ral_cnt}{$reg_block_cnt}{$reg_cnt}{$reg_field_cnt}{NAME}\");\n";         # type_id::create
			 print $block_handle "      $sub_reg_field->{$ral_cnt}{$reg_block_cnt}{$reg_cnt}{$reg_field_cnt}{NAME}.configure(this,$sub_reg_field->{$ral_cnt}{$reg_block_cnt}{$reg_cnt}{$reg_field_cnt}{Width},$sub_reg_field->{$ral_cnt}{$reg_block_cnt}{$reg_cnt}{$reg_field_cnt}{Start_Position},$sub_reg_field->{$ral_cnt}{$reg_block_cnt}{$reg_cnt}{$reg_field_cnt}{Store_Method},$sub_reg_field->{$ral_cnt}{$reg_block_cnt}{$reg_cnt}{$reg_field_cnt}{Volatile},$sub_reg_field->{$ral_cnt}{$reg_block_cnt}{$reg_cnt}{$reg_field_cnt}{Reset_Value},$sub_reg_field->{$ral_cnt}{$reg_block_cnt}{$reg_cnt}{$reg_field_cnt}{If_Reset},$sub_reg_field->{$ral_cnt}{$reg_block_cnt}{$reg_cnt}{$reg_field_cnt}{If_Randomize},$sub_reg_field->{$ral_cnt}{$reg_block_cnt}{$reg_cnt}{$reg_field_cnt}{Single_Store});\n";                        # configure
			 print $block_handle "      $sub_reg_field->{$ral_cnt}{$reg_block_cnt}{$reg_cnt}{$reg_field_cnt}{NAME}.add_hdl_path_slice(\"$sub_reg_field->{$ral_cnt}{$reg_block_cnt}{$reg_cnt}{$reg_field_cnt}{Backdoor_Path}\",$sub_reg_field->{$ral_cnt}{$reg_block_cnt}{$reg_cnt}{$reg_field_cnt}{Start_Position},$sub_reg_field->{$ral_cnt}{$reg_block_cnt}{$reg_cnt}{$reg_field_cnt}{Width});\n";  # add_hdl_path_slice
			 print $block_handle "\n";
	      }
		  print $block_handle "   endfunction\n";
		  print $block_handle "\n";
		  print $block_handle "endclass\n";
		  print $block_handle "\n";
	   }

	   print $block_handle "\n";
	   # class reg_block_name extends uvm_reg_block
	   print $block_handle "class $sub_reg_block->{$ral_cnt}{$reg_block_cnt}{NAME} extends uvm_reg_block;\n";
	   print $block_handle "\n";
	   print $block_handle "   `uvm_object_utils($sub_reg_block->{$ral_cnt}{$reg_block_cnt}{NAME})\n";
	   print $block_handle "\n";
	   print $block_handle "   function new(string name=\"$sub_reg_block->{$ral_cnt}{$reg_block_cnt}{NAME}\");\n";
	   print $block_handle "      super.new(name,$sub_reg_block->{$ral_cnt}{$reg_block_cnt}{Uvm_Coverage});\n";
	   print $block_handle "   endfunction\n";
	   print $block_handle "\n";

	   # uvm_reg level foreach
	   foreach(keys %{$sub_reg->{$ral_cnt}{$reg_block_cnt}}){
		  my $reg_cnt = $_;
		  # rand uvm_reg_name uvm_reg_name_ins
          print $block_handle "   rand $sub_reg->{$ral_cnt}{$reg_block_cnt}{$reg_cnt}{NAME} $sub_reg->{$ral_cnt}{$reg_block_cnt}{$reg_cnt}{NAME}_ins;\n";
	   }
	   print $block_handle "\n";
	   # reg_block_name build function
	   print $block_handle "   virtual function void build();\n";
	   print $block_handle "      default_map = create_map(\"default_map\",$sub_reg_block->{$ral_cnt}{$reg_block_cnt}{Base_Addr},$sub_reg_block->{$ral_cnt}{$reg_block_cnt}{Bus_Width},$sub_reg_block->{$ral_cnt}{$reg_block_cnt}{Uvm_Coverage},$sub_reg_block->{$ral_cnt}{$reg_block_cnt}{Byte_Based});\n";
       print $block_handle "\n";
       
       #  uvm_reg level foreach
	   foreach(keys %{$sub_reg->{$ral_cnt}{$reg_block_cnt}}){
          my $reg_cnt = $_;
	      print $block_handle "      $sub_reg->{$ral_cnt}{$reg_block_cnt}{$reg_cnt}{NAME}_ins = $sub_reg->{$ral_cnt}{$reg_block_cnt}{$reg_cnt}{NAME}::type_id::create(\"$sub_reg->{$ral_cnt}{$reg_block_cnt}{$reg_cnt}{NAME}_ins\");\n";    # type_id::create
		  print $block_handle "      $sub_reg->{$ral_cnt}{$reg_block_cnt}{$reg_cnt}{NAME}_ins.configure(this,null,\"\");\n";  # configure
		  print $block_handle "      $sub_reg->{$ral_cnt}{$reg_block_cnt}{$reg_cnt}{NAME}_ins.build();\n"; # build
		  print $block_handle "      default_map.add_reg($sub_reg->{$ral_cnt}{$reg_block_cnt}{$reg_cnt}{NAME}_ins,'h$sub_reg->{$ral_cnt}{$reg_block_cnt}{$reg_cnt}{Addr_Offset},\"$sub_reg->{$ral_cnt}{$reg_block_cnt}{$reg_cnt}{Read_Write}\");\n";     #add_reg
		  print $block_handle "\n";
		  }
	   print $block_handle "   endfunction\n";
	   print $block_handle "\n";
	   print $block_handle "endclass";
	   close $block_handle;
   }
   print $Ral_handle "   endfunction\n"; 
   print $Ral_handle "\n";
   print $Ral_handle "endclass";
   close $Ral_handle;
}
