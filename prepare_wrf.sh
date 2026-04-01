#!/bin/bash

echo "======================================================"
echo "  WRF Preparation Script for NCAR Derecho (Intel)     "
echo "======================================================"

echo "[1/7] Purging and loading required modules..."
module purge
module load ncarenv/23.09
module load intel
module load cray-mpich
module load netcdf

echo "[2/7] Setting up unified NetCDF directory for WRF..."
mkdir -p ~/netcdf_wrf/include ~/netcdf_wrf/lib ~/netcdf_wrf/bin

# Link C library
ln -sf $(nc-config --prefix)/include/* ~/netcdf_wrf/include/
ln -sf $(nc-config --prefix)/lib/* ~/netcdf_wrf/lib/
ln -sf $(nc-config --prefix)/bin/* ~/netcdf_wrf/bin/

# Link Fortran library
ln -sf $(nf-config --prefix)/include/* ~/netcdf_wrf/include/
ln -sf $(nf-config --prefix)/lib/* ~/netcdf_wrf/lib/
ln -sf $(nf-config --prefix)/bin/* ~/netcdf_wrf/bin/

export NETCDF=~/netcdf_wrf
echo "      -> NETCDF path set to $NETCDF"

echo "[3/7] Cleaning WRF directory completely..."
./clean -a

echo "[4/7] Applying the landread.c (RPC) system fix..."
cp share/landread.c.dist share/landread.c

echo "[5/7] Running WRF configure..."
echo "------------------------------------------------------"
echo " *** CRITICAL: When the menu appears, type the number "
echo " *** for  INTEL (ifort/icc) ... dmpar                 "
echo " *** (This is usually option 15 or 16).               "
echo "------------------------------------------------------"
./configure

export J="-j 4"

echo "======================================================"
echo " Preparation Complete! "
echo " You can now start the compilation by running: "
echo ""
echo "    ./compile em_real >& compile.log"
echo "    tail -f compile.log"
echo "======================================================"