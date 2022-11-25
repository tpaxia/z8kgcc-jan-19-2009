/* BFD back-end for Zilog Z800n COFF binaries.
   Copyright 1992, 1993, 1994, 1995, 1997, 1999, 2000, 2001, 2002, 2003,
   2004, 2005, 2007, 2008  Free Software Foundation, Inc.
   Contributed by Cygnus Support.
   Written by Steve Chamberlain, <sac@cygnus.com>.

   This file is part of BFD, the Binary File Descriptor library.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street - Fifth Floor, Boston,
   MA 02110-1301, USA.  */

#include "sysdep.h"
#include "bfd.h"
#include "libbfd.h"
#include "bfdlink.h"
#include "coff/z8k.h"
#include "coff/internal.h"
#include "libcoff.h"

#define COFF_DEFAULT_SECTION_ALIGNMENT_POWER (1)

static reloc_howto_type r_imm32 =
HOWTO (R_IMM32, 0, 2, 32, FALSE, 0,
       complain_overflow_bitfield, 0, "r_imm32", TRUE, 0xffffffff,
       0xffffffff, FALSE);

static reloc_howto_type r_imm4l =
HOWTO (R_IMM4L, 0, 0, 4, FALSE, 0,
       complain_overflow_bitfield, 0, "r_imm4l", TRUE, 0xf, 0xf, FALSE);

static reloc_howto_type r_imm16 =
HOWTO (R_IMM16, 0, 1, 16, FALSE, 0,
       complain_overflow_bitfield, 0, "r_imm16", TRUE, 0x0000ffff, 0x0000ffff,
       FALSE);

static reloc_howto_type r_imm8 =
HOWTO (R_IMM8, 0, 0, 8, FALSE, 0,
       complain_overflow_bitfield, 0, "r_imm8", TRUE, 0x000000ff, 0x000000ff,
       FALSE);

static reloc_howto_type r_rel16 =
HOWTO (R_REL16, 0, 1, 16, FALSE, 0,
       complain_overflow_bitfield, 0, "r_rel16", TRUE, 0x0000ffff, 0x0000ffff,
       TRUE);

static reloc_howto_type r_jr =
HOWTO (R_JR, 1, 0, 8, TRUE, 0, complain_overflow_signed, 0,
       "r_jr", TRUE, 0xff, 0xff, TRUE);

static reloc_howto_type r_disp7 =
HOWTO (R_DISP7, 0, 0, 7, TRUE, 0, complain_overflow_bitfield, 0,
       "r_disp7", TRUE, 0x7f, 0x7f, TRUE);

static reloc_howto_type r_callr =
HOWTO (R_CALLR, 1, 1, 12, TRUE, 0, complain_overflow_signed, 0,
       "r_callr", TRUE, 0xfff, 0xfff, TRUE);

#define BADMAG(x) Z8KBADMAG(x)
#define Z8K 1			/* Customize coffcode.h.  */
#define __A_MAGIC_SET__

/* Code to swap in the reloc.  */
#define SWAP_IN_RELOC_OFFSET	H_GET_32
#define SWAP_OUT_RELOC_OFFSET	H_PUT_32
#define SWAP_OUT_RELOC_EXTRA(abfd, src, dst) \
  dst->r_stuff[0] = 'S'; \
  dst->r_stuff[1] = 'C';

/* Code to turn a r_type into a howto ptr, uses the above howto table.  */

static void
rtype2howto (arelent *internal, struct internal_reloc *dst)
{
  switch (dst->r_type)
    {
    default:
      abort ();
      break;
    case R_IMM8:
      internal->howto = &r_imm8;
      break;
     case R_IMM16:
      internal->howto = &r_imm16;
      break;
    case R_JR:
      internal->howto = &r_jr;
      break;
    case R_DISP7:
      internal->howto = &r_disp7;
      break;
    case R_CALLR:
      internal->howto = &r_callr;
      break;
    case R_REL16:
      internal->howto = &r_rel16;
      break;
    case R_IMM32:
      internal->howto = &r_imm32;
      break;
    case R_IMM4L:
      internal->howto = &r_imm4l;
      break;
    }
}

#define RTYPE2HOWTO(internal, relocentry) rtype2howto (internal, relocentry)

static reloc_howto_type *
coff_z8k_reloc_type_lookup (bfd *abfd ATTRIBUTE_UNUSED,
                            bfd_reloc_code_real_type code)
{
  switch (code)
    {
    case BFD_RELOC_8:      	return & r_imm8;
    case BFD_RELOC_16:      	return & r_imm16;
    case BFD_RELOC_32:      	return & r_imm32;
    case BFD_RELOC_8_PCREL:     return & r_jr;
    case BFD_RELOC_16_PCREL:    return & r_rel16;
    case BFD_RELOC_Z8K_DISP7:   return & r_disp7;
    case BFD_RELOC_Z8K_CALLR:   return & r_callr;
    case BFD_RELOC_Z8K_IMM4L:   return & r_imm4l;
    default:			BFD_FAIL ();
      return 0;
    }
}

static reloc_howto_type *
coff_z8k_reloc_name_lookup (bfd *abfd ATTRIBUTE_UNUSED,
			    const char *r_name)
{
  if (strcasecmp (r_imm8.name, r_name) == 0)
    return &r_imm8;
  if (strcasecmp (r_imm16.name, r_name) == 0)
    return &r_imm16;
  if (strcasecmp (r_imm32.name, r_name) == 0)
    return &r_imm32;
  if (strcasecmp (r_jr.name, r_name) == 0)
    return &r_jr;
  if (strcasecmp (r_rel16.name, r_name) == 0)
    return &r_rel16;
  if (strcasecmp (r_disp7.name, r_name) == 0)
    return &r_disp7;
  if (strcasecmp (r_callr.name, r_name) == 0)
    return &r_callr;
  if (strcasecmp (r_imm4l.name, r_name) == 0)
    return &r_imm4l;

  return NULL;
}

/* Perform any necessary magic to the addend in a reloc entry.  */

#define CALC_ADDEND(abfd, symbol, ext_reloc, cache_ptr) \
 cache_ptr->addend =  ext_reloc.r_offset;

#define RELOC_PROCESSING(relent,reloc,symbols,abfd,section) \
 reloc_processing(relent, reloc, symbols, abfd, section)

static void
reloc_processing (arelent *relent,
                  struct internal_reloc *reloc,
                  asymbol **symbols,
                  bfd *abfd,
                  asection *section)
{
  relent->address = reloc->r_vaddr;
  rtype2howto (relent, reloc);

  if (reloc->r_symndx > 0)
    relent->sym_ptr_ptr = symbols + obj_convert (abfd)[reloc->r_symndx];
  else
    relent->sym_ptr_ptr = bfd_abs_section_ptr->symbol_ptr_ptr;

  relent->addend = reloc->r_offset;
  relent->address -= section->vma;
}

#if 0 /* old */

/*
 * CPG add-on
 */
static void
dump_reloc(arelent *reloc,
           struct bfd_link_order *link_order,
           struct bfd_link_info *link_info,
           int reloc_type)
{
  FILE *outfile = link_info->base_file;
  int f;
  struct dumpdata   /* records in the file */
  {
    unsigned int section;
    unsigned int address;
    unsigned int type;
  } dumpdata;
  unsigned int address = reloc->address;
  unsigned int offset = link_order->offset;
  const char *section;  /* Section where the relocation is to happen.  */
  const char *dest_section; /* Section where the referenced symbol lives.  */
  const char *output_section; /* Section in output file where the relocation is to happen.  */
  char *program_name="xxxxx";

  if (! link_info->base_file)
    return;  /* no reloc file selected */

  if (link_order->type != bfd_indirect_link_order)
    abort();

  section = link_order->u.indirect.section->name;
  dest_section = (*reloc->sym_ptr_ptr)->section->name;
  output_section = link_order->u.indirect.section->output_section->name;

#if 0
  printf("dumping reloc: section %s, output section: %s, address %08x, type = %s, offset = 0x%x\n",
         section,
         output_section,
         address,
         reloc_type == R_IMM32 ? "R_IMM32" : reloc_type == R_IMM16 ? "R_IMM16" : "<unknown>",
         offset);
#if 1
  printf("               addend: %ld, link_order->type = %d, dest_section = %s, output dest_section = %s\n",
         reloc->addend, link_order->type, dest_section, (*reloc->sym_ptr_ptr)->section->output_section->name);
  printf("               vma: %ld,  lma: %ld, output_offset: %ld, file_pos: %ld\n",
         link_order->u.indirect.section->vma, link_order->u.indirect.section->lma,
         link_order->u.indirect.section->output_offset,
         (long int)link_order->u.indirect.section->filepos);
#endif
#endif

  /* Sanity check.  */
  if ((f = 0, (strcmp(section, ".text")
               && strcmp(section, ".data")
               && strcmp(section, ".bss")
               && strcmp(section, ".rdata")))
      ||
      (f = 1, (strcmp(dest_section, ".text")
               && strcmp(dest_section, ".data")
               && strcmp(dest_section, ".bss")
               && strcmp(dest_section, "COMMON")
               && strcmp(dest_section, ".rdata"))))
    {
      fprintf(stderr, "bfd: dump_reloc: unknown %s section %s!\n",
              f ? "output" : "input", f ? dest_section : section);
      return;
    }

  memset(&dumpdata, 0, sizeof(dumpdata));
  dumpdata.address = address + offset;

  if (reloc_type == R_IMM32)
    dumpdata.type = 1;
  else if (reloc_type == R_IMM16)
    dumpdata.type = 2;
  else
    {
      fprintf(stderr, "dump_reloc: unknown relocation type %d!\n",reloc_type);
      return;
    }

  if (!strcmp(output_section,".text"))
    dumpdata.section = 1;
  else if (!strcmp(output_section,".data"))
    dumpdata.section = 2;
  else
    {
      fprintf(stderr, "dump_reloc: unknown section type %s!\n",output_section);
      return;
    }

  if (fwrite(&dumpdata, sizeof(dumpdata), 1, outfile) != 1)
    {
      fprintf(stderr, "%s: fwrite 2 error: %s\n", program_name, strerror(errno));
      return;
    }
}

#else /* above old, below new */

/*
 * CPG add-on
 */
static void
dump_reloc(arelent *reloc,
           struct bfd_link_order *link_order,
           struct bfd_link_info *link_info,
           int reloc_type)
{
  FILE *outfile = link_info->base_file;
  int f;
  struct dumpdata   /* records in the file */
  {
    unsigned int section;       /* Section where the relocation is to happen.  */
    unsigned int dest_section;  /* Section where the referenced symbol lives.  */
    unsigned int address;
    unsigned int type;
  } dumpdata;
  unsigned int address = reloc->address;
  unsigned int offset = link_order->offset;
  const char *section;  /* Section where the relocation is to happen.  */
  const char *dest_section; /* Section where the referenced symbol lives.  */
  const char *output_section; /* Section in output file where the relocation is to happen.  */
  const char *output_dest_section; /* Section in output file where the referenced symbol lives.  */
  char *program_name="xxxxx";

  if (! link_info->base_file)
    return;  /* no reloc file selected */

  if (link_order->type != bfd_indirect_link_order)
    abort();

  section = link_order->u.indirect.section->name;
  dest_section = (*reloc->sym_ptr_ptr)->section->name;
  output_section = link_order->u.indirect.section->output_section->name;
  output_dest_section = (*reloc->sym_ptr_ptr)->section->output_section->name;

#if 0
  printf("dumping reloc: section %s, output section: %s, address %08x, type = %s, offset = 0x%x\n",
         section,
         output_section,
         address,
         reloc_type == R_IMM32 ? "R_IMM32" : reloc_type == R_IMM16 ? "R_IMM16" : "<unknown>",
         offset);
#if 1
  printf("               addend: %ld, link_order->type = %d, dest_section = %s, output dest_section = %s\n",
         reloc->addend, link_order->type, dest_section, output_dest_section);
  printf("               vma: %ld,  lma: %ld, output_offset: %ld, file_pos: %ld\n",
         link_order->u.indirect.section->vma, link_order->u.indirect.section->lma,
         link_order->u.indirect.section->output_offset,
         (long int)link_order->u.indirect.section->filepos);
#endif
#endif

  /* Sanity check.  */
  if ((f = 0, (strcmp(section, ".text")
               && strcmp(section, ".data")
               && strcmp(section, ".bss")
               && strcmp(section, ".rdata")))
      ||
      (f = 1, (strcmp(dest_section, ".text")
               && strcmp(dest_section, ".data")
               && strcmp(dest_section, ".bss")
               && strcmp(dest_section, "COMMON")
               && strcmp(dest_section, ".rdata"))))
    {
      fprintf(stderr, "bfd: dump_reloc: unknown %s section %s!\n",
              f ? "output" : "input", f ? dest_section : section);
      return;
    }

  memset(&dumpdata, 0, sizeof(dumpdata));
  dumpdata.address = address + offset;

  if (reloc_type != R_IMM32 && reloc_type != R_IMM16)
    {
      fprintf(stderr, "dump_reloc: unknown relocation type %d!\n",reloc_type);
      return;
    }
  else
    dumpdata.type = reloc_type;

  if (!strcmp(output_section,".text"))
    dumpdata.section = 1;
  else if (!strcmp(output_section,".data"))
    dumpdata.section = 2;
  else
    {
      fprintf(stderr, "dump_reloc: unknown section type %s!\n",output_section);
      return;
    }

  if (!strcmp(output_dest_section,".text"))
    dumpdata.dest_section = 1;
  else if (!strcmp(output_dest_section,".data"))
    dumpdata.dest_section = 2;
  else if (!strcmp(output_dest_section,".bss"))
    dumpdata.dest_section = 3;
  else
    {
      fprintf(stderr, "dump_reloc: unknown dest section type %s!\n",output_dest_section);
      return;
    }

  if (fwrite(&dumpdata, sizeof(dumpdata), 1, outfile) != 1)
    {
      fprintf(stderr, "%s: fwrite 2 error: %s\n", program_name, strerror(errno));
      return;
    }
}

#endif /* not OLD */

static void
extra_case (bfd *in_abfd,
            struct bfd_link_info *link_info,
            struct bfd_link_order *link_order,
            arelent *reloc,
            bfd_byte *data,
            unsigned int *src_ptr,
            unsigned int *dst_ptr)
{
  asection * input_section = link_order->u.indirect.section;

  switch (reloc->howto->type)
    {
    case R_IMM8:
      bfd_put_8 (in_abfd,
		 bfd_coff_reloc16_get_value (reloc, link_info, input_section),
		 data + *dst_ptr);
      (*dst_ptr) += 1;
      (*src_ptr) += 1;
      break;

    case R_IMM32:
      /* If no flags are set, assume immediate value.  */
      if (! (*reloc->sym_ptr_ptr)->section->flags)
	{
	  bfd_put_32 (in_abfd,
		      bfd_coff_reloc16_get_value (reloc, link_info,
						  input_section),
		      data + *dst_ptr);
	}
      else
	{
	  bfd_vma dst = bfd_coff_reloc16_get_value (reloc, link_info,
						    input_section);
	  /* Addresses are 23 bit, and the layout of those in a 32-bit
	     value is as follows:
	       1AAAAAAA xxxxxxxx AAAAAAAA AAAAAAAA
	     (A - address bits,  x - ignore).  */
	  dst = (dst & 0xffff) | ((dst & 0xff0000) << 8) | 0x80000000;
	  bfd_put_32 (in_abfd, dst, data + *dst_ptr);
          dump_reloc (reloc, link_order, link_info, R_IMM32);
	}
      (*dst_ptr) += 4;
      (*src_ptr) += 4;
      break;

    case R_IMM4L:
      bfd_put_8 (in_abfd,
		 ((bfd_get_8 (in_abfd, data + *dst_ptr) & 0xf0)
		  | (0x0f
		     & bfd_coff_reloc16_get_value (reloc, link_info,
						   input_section))),
		 data + *dst_ptr);
      (*dst_ptr) += 1;
      (*src_ptr) += 1;
      break;

    case R_IMM16:
      bfd_put_16 (in_abfd,
		  bfd_coff_reloc16_get_value (reloc, link_info, input_section),
		  data + *dst_ptr);
      /* if flags are set, assume real reloc entry.  */
      if ((*reloc->sym_ptr_ptr)->section->flags)
        {
          dump_reloc (reloc, link_order, link_info, R_IMM16);
        }
      (*dst_ptr) += 2;
      (*src_ptr) += 2;
      break;

    case R_JR:
      {
	bfd_vma dst = bfd_coff_reloc16_get_value (reloc, link_info,
						  input_section);
	bfd_vma dot = (*dst_ptr
		       + input_section->output_offset
		       + input_section->output_section->vma);
	int gap = dst - dot - 1;  /* -1, since we're in the odd byte of the
                                     word and the pc's been incremented.  */

	if (gap & 1)
	  abort ();
	gap /= 2;
	if (gap > 128 || gap < -128)
	  {
	    if (! ((*link_info->callbacks->reloc_overflow)
		   (link_info, NULL,
		    bfd_asymbol_name (*reloc->sym_ptr_ptr),
		    reloc->howto->name, reloc->addend, input_section->owner,
		    input_section, reloc->address)))
	      abort ();
	  }
	bfd_put_8 (in_abfd, gap, data + *dst_ptr);
	(*dst_ptr)++;
	(*src_ptr)++;
	break;
      }

    case R_DISP7:
      {
	bfd_vma dst = bfd_coff_reloc16_get_value (reloc, link_info,
						  input_section);
	bfd_vma dot = (*dst_ptr
		       + input_section->output_offset
		       + input_section->output_section->vma);
	int gap = dst - dot - 1;  /* -1, since we're in the odd byte of the
                                     word and the pc's been incremented.  */

	if (gap & 1)
	  abort ();
	gap /= 2;

	if (gap > 0 || gap < -127)
	  {
	    if (! ((*link_info->callbacks->reloc_overflow)
		   (link_info, NULL,
		    bfd_asymbol_name (*reloc->sym_ptr_ptr),
		    reloc->howto->name, reloc->addend, input_section->owner,
		    input_section, reloc->address)))
	      abort ();
	  }
	bfd_put_8 (in_abfd,
                   (bfd_get_8 ( in_abfd, data + *dst_ptr) & 0x80) + (-gap & 0x7f),
                   data + *dst_ptr);
	(*dst_ptr)++;
	(*src_ptr)++;
	break;
      }

    case R_CALLR:
      {
	bfd_vma dst = bfd_coff_reloc16_get_value (reloc, link_info,
						  input_section);
	bfd_vma dot = (*dst_ptr
		       + input_section->output_offset
		       + input_section->output_section->vma);
	int gap = dst - dot - 2;

	if (gap & 1)
	  abort ();
	if (gap > 4096 || gap < -4095)
	  {
	    if (! ((*link_info->callbacks->reloc_overflow)
		   (link_info, NULL,
		    bfd_asymbol_name (*reloc->sym_ptr_ptr),
		    reloc->howto->name, reloc->addend, input_section->owner,
		    input_section, reloc->address)))
	      abort ();
	  }
	gap /= 2;
	bfd_put_16 (in_abfd,
                    (bfd_get_16 ( in_abfd, data + *dst_ptr) & 0xf000) | (-gap & 0x0fff),
                    data + *dst_ptr);
	(*dst_ptr) += 2;
	(*src_ptr) += 2;
	break;
      }

    case R_REL16:
      {
	bfd_vma dst = bfd_coff_reloc16_get_value (reloc, link_info,
						  input_section);
	bfd_vma dot = (*dst_ptr
		       + input_section->output_offset
		       + input_section->output_section->vma);
	int gap = dst - dot - 2;

	if (gap > 32767 || gap < -32768)
	  {
	    if (! ((*link_info->callbacks->reloc_overflow)
		   (link_info, NULL,
		    bfd_asymbol_name (*reloc->sym_ptr_ptr),
		    reloc->howto->name, reloc->addend, input_section->owner,
		    input_section, reloc->address)))
	      abort ();
	  }
	bfd_put_16 (in_abfd, (bfd_vma) gap, data + *dst_ptr);
	(*dst_ptr) += 2;
	(*src_ptr) += 2;
	break;
      }

    default:
      abort ();
    }
}

#define coff_reloc16_extra_cases    extra_case
#define coff_bfd_reloc_type_lookup  coff_z8k_reloc_type_lookup
#define coff_bfd_reloc_name_lookup coff_z8k_reloc_name_lookup

#ifndef bfd_pe_print_pdata
#define bfd_pe_print_pdata	NULL
#endif

#include "coffcode.h"

#undef  coff_bfd_get_relocated_section_contents
#define coff_bfd_get_relocated_section_contents \
  bfd_coff_reloc16_get_relocated_section_contents

#undef  coff_bfd_relax_section
#define coff_bfd_relax_section bfd_coff_reloc16_relax_section

CREATE_BIG_COFF_TARGET_VEC (z8kcoff_vec, "coff-z8k", 0, 0, '_', NULL, COFF_SWAP_TABLE)
