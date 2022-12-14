cat <<EOF
OUTPUT_FORMAT("${OUTPUT_FORMAT}")
OUTPUT_ARCH("${OUTPUT_ARCH}")
ENTRY(_start)

SECTIONS 				
{ 					
.text ${BIG+ ${RELOCATING+ 0x0000000}} :
	{ 
	  *(.text) 				
	  *(.strings)
	  *(.rdata)
	}

.ctors ${BIG+ ${RELOCATING+ 0x20000}}  : 
	{
	  ${CONSTRUCTING+ ___ctors = . ;  }
	  *(.ctors);
	  ${CONSTRUCTING+ ___ctors_end = . ; }
	  ___dtors = . ;
	  *(.dtors);
	  ${CONSTRUCTING+ ___dtors_end = . ; }
	} 

.data ${BIG+ ${RELOCATING+ 0x30000}} :
	{
	   *(.data)
	}

.bss ${BIG+ ${RELOCATING+ 0x40000}} : 
	{
	  ${RELOCATING+ __start_bss = . ; }
	  *(.bss);
	  *(COMMON);
	  ${RELOCATING+ __end_bss = . ; }
	}

.heap ${BIG+ ${RELOCATING+ 0x50000}} :
	{
	  ${RELOCATING+ __start_heap = . ; }
	  ${RELOCATING+ . = . + 20k  ; }
	  ${RELOCATING+ __end_heap = . ; }
	} 

.stack ${RELOCATING+ 0xf000 }  : 
	{
	  ${RELOCATING+ _stack = . ; }
	  *(.stack)
	  ${RELOCATING+ __stack_top = . ; }
	}

}
EOF




