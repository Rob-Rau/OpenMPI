/*
 * Author: John Colvin.
 * This is some of the worst code I have written in years.
 * Seriously, don't look, it's SO bad.
 *
 * It does, however, work, for now...
 */
import std.stdio, std.algorithm, std.typecons;
import std.string, std.conv, std.array, std.utf;
import std.file : readText;

void main(string[] args)
{
    auto mpi = args[1].readText();

    Nullable!(int)[string] intEntries;
    foreach(m; ints)
        intEntries[m] = Nullable!int.init;

    string[string] typeEntries;
    foreach(m; types)
        typeEntries[m] = null;

    foreach(line; mpi.splitLines())
    {
        line = line.byChar.map!(c => c == '\t' ? ' ' : c).to!string;
        auto r = line.findSplitAfter("#define")[1].stripLeft.findSplit(" ");
        r[0] = r[0].stripRight;
        //consolidate whitespace
        r[2] = r[2].split.join(" ");
        if(r[0].empty)
        {
            auto rTD = line.findSplitAfter("typedef")[1];
            if(rTD.empty) continue;
            //TODO yeah that's not how you do tokenisation...
            auto tokens = rTD.split;
            auto name = tokens[$-1];
            auto type = tokens[0 .. $-1].join(" ");
            auto pT = type in rTD;
            if(pT)
            {
                if(type == "long long") type = "long";
                else if(type == "long") type = "c_long";
                *pT = type;
            }
        }
        
        auto pI = r[0] in intEntries;
        if(pI)
        {
            *pI = r[2].to!int;
            continue;
        }
        
        auto pT = r[0] in typeEntries;
        if(pT)
        {
            if(r[2] == "long long") r[2] = "long";
            else if(r[2] == "long") r[2] = "c_long";
            *pT = r[2];
            continue;
        }

        auto pS = r[0] in stringEntries;
        if(pS)
        {
            *pS = r[2];
            continue;
        }
    }

    foreach(key, val; intEntries)
    {
        if(val.isNull)
            stderr.writeln("no entry found for " ~ key);
        else
            writeln("enum " ~ key ~ " = " ~ val.to!string ~ ';');
    }
    foreach(key, val; typeEntries)
    {
        if(val is null)
            stderr.writeln("no entry found for " ~ key);
        else
            writeln("alias " ~ key ~ " = " ~ val ~ ';');
    }
    foreach(key, val; stringEntries)
    {
        if(val is null)
            stderr.writeln("no entry found for " ~ key);
        else
            writeln("enum " ~ key ~ " = " ~ val ~ ';');
    }
}

immutable OMPI_ints = [
    "OPAL_BUILD_PLATFORM_COMPILER_FAMILYID",
    "OPAL_BUILD_PLATFORM_COMPILER_VERSION",
    "OPAL_STDC_HEADERS",
    "OPAL_HAVE_ATTRIBUTE_DEPRECATED",
    "OPAL_HAVE_ATTRIBUTE_DEPRECATED_ARGUMENT",
    "OPAL_HAVE_SYS_TIME_H",
    "OPAL_HAVE_SYS_SYNCH_H",
    "OPAL_HAVE_LONG_LONG",
    "OPAL_SIZEOF_BOOL",
    "OPAL_SIZEOF_INT",
    "OPAL_MAX_DATAREP_STRING",
    "OPAL_MAX_ERROR_STRING",
    "OPAL_MAX_INFO_KEY",
    "OPAL_MAX_INFO_VAL",
    "OPAL_MAX_OBJECT_NAME",
    "OPAL_MAX_PORT_NAME",
    "OPAL_MAX_PROCESSOR_NAME",
    "OMPI_HAVE_FORTRAN_LOGICAL1",
    "OMPI_HAVE_FORTRAN_LOGICAL2",
    "OMPI_HAVE_FORTRAN_LOGICAL4",
    "OMPI_HAVE_FORTRAN_LOGICAL8",
    "OMPI_HAVE_FORTRAN_INTEGER1",
    "OMPI_HAVE_FORTRAN_INTEGER16",
    "OMPI_HAVE_FORTRAN_INTEGER2",
    "OMPI_HAVE_FORTRAN_INTEGER4",
    "OMPI_HAVE_FORTRAN_INTEGER8",
    "OMPI_HAVE_FORTRAN_REAL16",
    "OMPI_HAVE_FORTRAN_REAL2",
    "OMPI_HAVE_FORTRAN_REAL4",
    "OMPI_HAVE_FORTRAN_REAL8",
    "HAVE_FLOAT__COMPLEX",
    "HAVE_DOUBLE__COMPLEX",
    "HAVE_LONG_DOUBLE__COMPLEX",
    "OMPI_MPI_OFFSET_SIZE",
    "OMPI_BUILD_CXX_BINDINGS",
    "OMPI_CXX_SUPPORTS_2D_CONST_CAST",
    "OMPI_PARAM_CHECK",
    "OMPI_HAVE_CXX_EXCEPTION_SUPPORT",
    "OMPI_MAJOR_VERSION",
    "OMPI_MINOR_VERSION",
    "OMPI_RELEASE_VERSION",
    "OPAL_C_HAVE_VISIBILITY",
    "OMPI_PROVIDE_MPI_FILE_INTERFACE",
    "MPI_VERSION",
    "MPI_SUBVERSION",
    //OPENMPI version 1.6.5 :
    "OMPI_WANT_CXX_BINDINGS",
    "OMPI_WANT_F77_BINDINGS",
    "OMPI_WANT_F90_BINDINGS",
    //OPENMPI version 1.4.3
    "OMPI_STDC_HEADERS",
    "OMPI_HAVE_SYSTIME_H",
    "OMPI_HAVE_SYS_SYNCH_H",
    "OMPI_HAVE_LONG_LONG",
    "OMPI_SIZEOF_BOOL",
    "OMPI_SIZEOF_INT"
    ];

immutable OMPI_types = [
    "OMPI_MPI_OFFSET_TYPE",
    "OMPI_OFFSET_DATATYPE",
    "OMPI_MPI_COUNT_TYPE",
    "OPAL_PTRDIFF_TYPE",
    "ompi_fortran_bogus_type_t",
    "ompi_fortran_integer_t",
    "MPI_Fint",
    //OPENMPI version 1.4.3
    "OMPI_PTRDIFF_TYPE"];

immutable MPICH_ints = [
    "MPI_CHAR",
    "MPI_SIGNED_CHAR",
    "MPI_UNSIGNED_CHAR",
    "MPI_BYTE",
    "MPI_WCHAR",
    "MPI_SHORT",
    "MPI_UNSIGNED_SHORT",
    "MPI_INT",
    "MPI_UNSIGNED",
    "MPI_LONG",
    "MPI_UNSIGNED_LONG",
    "MPI_FLOAT",
    "MPI_DOUBLE",
    "MPI_LONG_DOUBLE",
    "MPI_LONG_LONG",
    "MPI_UNSIGNED_LONG_LONG",
    "MPI_LONG_DOUBLE",
    "MPI_PACKED",
    "MPI_LB",
    "MPI_UB",
    "MPI_FLOAT_INT",
    "MPI_DOUBLE_INT",
    "MPI_LONG_INT",
    "MPI_SHORT_INT",
    "MPI_2INT",
    "MPI_LONG_DOUBLE_INT",
    "MPI_LONG_DOUBLE_INT",
    "MPI_LONG_DOUBLE_INT",
    "MPI_COMPLEX",
    "MPI_DOUBLE_COMPLEX",
    "MPI_LOGICAL",
    "MPI_REAL",
    "MPI_DOUBLE_PRECISION",
    "MPI_INTEGER",
    "MPI_2INTEGER",
    "MPI_2REAL",
    "MPI_2DOUBLE_PRECISION",
    "MPI_CHARACTER",
    "MPI_REAL4",
    "MPI_REAL8",
    "MPI_REAL16",
    "MPI_COMPLEX8",
    "MPI_COMPLEX16",
    "MPI_COMPLEX32",
    "MPI_INTEGER1",
    "MPI_INTEGER2",
    "MPI_INTEGER4",
    "MPI_INTEGER8",
    "MPI_INTEGER16",
    "MPI_INT8_T",
    "MPI_INT16_T",
    "MPI_INT32_T",
    "MPI_INT64_T",
    "MPI_UINT8_T",
    "MPI_UINT16_T",
    "MPI_UINT32_T",
    "MPI_UINT64_T",
    "MPI_C_BOOL",
    "MPI_C_FLOAT_COMPLEX",
    "MPI_C_DOUBLE_COMPLEX",
    "MPI_C_LONG_DOUBLE_COMPLEX",
    "MPI_C_LONG_DOUBLE_COMPLEX",
    "MPI_AINT",
    "MPI_OFFSET",
    "MPI_COUNT",
    "MPI_CXX_BOOL",
    "MPI_CXX_FLOAT_COMPLEX",
    "MPI_CXX_DOUBLE_COMPLEX",
    "MPI_CXX_LONG_DOUBLE_COMPLEX",
    "MPI_MAX_PROCESSOR_NAME",
    "MPI_MAX_LIBRARY_VERSION_STRING",
    "MPI_MAX_ERROR_STRING",
    "MPI_BSEND_OVERHEAD",
    "MPICH_NUMVERSION",
    ];

immutable MPICC_typedefs = [
    "MPI_Aint",
    "MPI_Fint",
    "MPI_Count",
    "MPI_Offset"
];

immutable MPICC_strings = [
    "MPICH_VERSION",
    "MPI_AINT_FMT_DEC_SPEC",
    "MPI_AINT_FMT_HEX_SPEC"];

immutable MPICC_other = [
    "MPIU_DLL_SPEC_DEF", //can ignore
    "HAVE_ROMIO", //if it's an include, provide MPIO
    "INCLUDE_MPICXX_H" //can ignore
    ];
