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

.data ${BIG+ ${RELOCATING+ 0x3000000}} :
	{
	   *(.data)
	}

.bss ${BIG+ ${RELOCATING+ 0x4000000}} : 
	{
	  ${RELOCATING+ __start_bss = . ; }
	  *(.bss);
	  *(COMMON);
	  ${RELOCATING+ __end_bss = . ; }
	}

}
EOF




