## Process this file with automake to generate Makefile.in

AUTOMAKE_OPTIONS = cygnus

INCLUDES = -I$(srcdir)/../common $(NEWLIB_CFLAGS) $(CROSS_CFLAGS) $(TARGET_CFLAGS)

src =	e_acosh.c \
e_atanh.c \
e_hypot.c \
e_j0.c \
e_j1.c \
e_remainder.c \
e_scalb.c \
er_gamma.c \
er_lgamma.c \
s_acos.c \
s_asin.c \
s_asine.c \
s_asinh.c \
s_atan.c \
s_atan2.c \
s_atangent.c \
s_ceil.c \
s_cos.c \
s_cosh.c \
s_erf.c \
s_exp.c \
s_exp2.c \
s_fabs.c \
s_floor.c \
s_fmod.c \
s_frexp.c \
s_infconst.c \
s_isinf.c \
s_isnan.c \
s_ispos.c \
s_ldexp.c \
s_log.c \
s_log10.c \
s_logarithm.c \
s_mathcnst.c \
s_numtest.c \
s_pow.c \
s_signif.c \
s_sin.c \
s_sincos.c \
s_sine.c \
s_sineh.c \
s_sinf.c \
s_sinh.c \
s_sqrt.c \
s_tan.c \
s_tanh.c \
s_tgamma.c \
w_cabs.c \
w_drem.c \
w_jn.c


fsrc = ef_acosh.c \
ef_atanh.c \
ef_hypot.c \
ef_j0.c \
ef_j1.c \
ef_remainder.c \
ef_scalb.c \
erf_gamma.c \
erf_lgamma.c \
sf_acos.c \
sf_asin.c \
sf_asine.c \
sf_asinh.c \
sf_atan.c \
sf_atan2.c \
sf_atangent.c \
sf_ceil.c \
sf_cos.c \
sf_cosh.c \
sf_erf.c \
sf_exp.c \
sf_exp2.c \
sf_fabs.c \
sf_floor.c \
sf_fmod.c \
sf_frexp.c \
sf_isinf.c \
sf_isnan.c \
sf_ispos.c \
sf_ldexp.c \
sf_log.c \
sf_log10.c \
sf_logarithm.c \
sf_numtest.c \
sf_pow.c \
sf_signif.c \
sf_sin.c \
sf_sincos.c \
sf_sine.c \
sf_sineh.c \
sf_sinh.c \
sf_sqrt.c \
sf_tan.c \
sf_tanh.c \
sf_tgamma.c \
wf_cabs.c \
wf_drem.c \
wf_jn.c

libmathfp_la_LDFLAGS = -Xcompiler -nostdlib

if USE_LIBTOOL
noinst_LTLIBRARIES = libmathfp.la
libmathfp_la_SOURCES = $(src) $(fsrc)
noinst_DATA = objectlist.awk.in
else
noinst_LIBRARIES = lib.a
lib_a_SOURCES = $(src) $(fsrc)
lib_a_CFLAGS = $(AM_CFLAGS)
noinst_DATA =
endif # USE_LIBTOOL

include $(srcdir)/../../Makefile.shared

chobj = eacosh.def \
	eatanh.def \
	ehypot.def \
	eremainder.def \
	erlgamma.def \
	sacos.def \
	sasine.def \
	sasinh.def \
	satan.def \
	satan2.def \
	satangent.def \
	scosh.def \
	serf.def \
	sexp.def \
	sfabs.def \
	sfloor.def \
	sfmod.def \
	sfrexp.def \
	sldexp.def \
	slog10.def \
	slogarithm.def \
	spow.def \
	ssine.def \
	ssineh.def \
	ssqrt.def \
	stan.def \
	stanh.def \
	wjn.def

SUFFIXES = .def

CHEW = ../../doc/makedoc -f $(srcdir)/../../doc/doc.str

.c.def:
	$(CHEW) < $< > $*.def 2> $*.ref
	touch stmp-def

TARGETDOC = ../tmp.texi

doc: $(chobj)
	cat $(srcdir)/mathfp.tex >> $(TARGETDOC)

CLEANFILES = $(chobj) *.ref

# Texinfo does not appear to support underscores in file names, so we
# name the .def files without underscores.

eacosh.def: e_acosh.c
	$(CHEW) < $(srcdir)/e_acosh.c >$@ 2>/dev/null
	touch stmp-def
eatanh.def: e_atanh.c
	$(CHEW) < $(srcdir)/e_atanh.c >$@ 2>/dev/null
	touch stmp-def
ehypot.def: e_hypot.c
	$(CHEW) < $(srcdir)/e_hypot.c >$@ 2>/dev/null
	touch stmp-def
eremainder.def: e_remainder.c
	$(CHEW) < $(srcdir)/e_remainder.c >$@ 2>/dev/null
	touch stmp-def
erlgamma.def: er_lgamma.c
	$(CHEW) < $(srcdir)/er_lgamma.c >$@ 2>/dev/null
	touch stmp-def
sacos.def: s_acos.c
	$(CHEW) < $(srcdir)/s_acos.c >$@ 2>/dev/null
	touch stmp-def
sasine.def: s_asine.c
	$(CHEW) < $(srcdir)/s_asine.c >$@ 2>/dev/null
	touch stmp-def
sasinh.def: s_asinh.c
	$(CHEW) < $(srcdir)/s_asinh.c >$@ 2>/dev/null
	touch stmp-def
satan.def: s_atan.c
	$(CHEW) < $(srcdir)/s_atan.c >$@ 2>/dev/null
	touch stmp-def
satan2.def: s_atan2.c
	$(CHEW) < $(srcdir)/s_atan2.c >$@ 2>/dev/null
	touch stmp-def
satangent.def: s_atangent.c
	$(CHEW) < $(srcdir)/s_atangent.c >$@ 2>/dev/null
	touch stmp-def
scosh.def: s_cosh.c
	$(CHEW) < $(srcdir)/s_cosh.c >$@ 2>/dev/null
	touch stmp-def
serf.def: s_erf.c
	$(CHEW) < $(srcdir)/s_erf.c >$@ 2>/dev/null
	touch stmp-def
sexp.def: s_exp.c
	$(CHEW) < $(srcdir)/s_exp.c >$@ 2>/dev/null
	touch stmp-def
sfabs.def: s_fabs.c
	$(CHEW) < $(srcdir)/s_fabs.c >$@ 2>/dev/null
	touch stmp-def
sfloor.def: s_floor.c
	$(CHEW) < $(srcdir)/s_floor.c >$@ 2>/dev/null
	touch stmp-def
sfmod.def: s_fmod.c
	$(CHEW) < $(srcdir)/s_fmod.c >$@ 2>/dev/null
	touch stmp-def
sfrexp.def: s_frexp.c
	$(CHEW) < $(srcdir)/s_frexp.c >$@ 2>/dev/null
	touch stmp-def
sldexp.def: s_ldexp.c
	$(CHEW) < $(srcdir)/s_ldexp.c >$@ 2>/dev/null
	touch stmp-def
slog10.def: s_log10.c
	$(CHEW) < $(srcdir)/s_log10.c >$@ 2>/dev/null
	touch stmp-def
slogarithm.def: s_logarithm.c
	$(CHEW) < $(srcdir)/s_logarithm.c >$@ 2>/dev/null
	touch stmp-def
spow.def: s_pow.c
	$(CHEW) < $(srcdir)/s_pow.c >$@ 2>/dev/null
	touch stmp-def
ssine.def: s_sine.c
	$(CHEW) < $(srcdir)/s_sine.c >$@ 2>/dev/null
	touch stmp-def
ssineh.def: s_sineh.c
	$(CHEW) < $(srcdir)/s_sineh.c >$@ 2>/dev/null
	touch stmp-def
ssqrt.def: s_sqrt.c
	$(CHEW) < $(srcdir)/s_sqrt.c >$@ 2>/dev/null
	touch stmp-def
stan.def: s_tan.c
	$(CHEW) < $(srcdir)/s_tan.c >$@ 2>/dev/null
	touch stmp-def
stanh.def: s_tanh.c
	$(CHEW) < $(srcdir)/s_tanh.c >$@ 2>/dev/null
	touch stmp-def
wjn.def: w_jn.c
	$(CHEW) < $(srcdir)/w_jn.c >$@ 2>/dev/null
	touch stmp-def

# A partial dependency list.

$(lib_a_OBJECTS): $(srcdir)/../../libc/include/math.h $(srcdir)/../common/fdlibm.h
