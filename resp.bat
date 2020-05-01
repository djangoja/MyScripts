@echo off&setlocal enabledelayedexpansion
echo ## The script is based on Windows OS
echo ## You must install amber16 (including acpype.exe) and gaussian09W and setting correct environment variable
echo ## Prepare molecules structure as PDB formats with "0" net charge
echo ## Using "opt" keyword in gaussian to optimize structure, so will produce two "gesp" file including before and after of optimization
echo.

del /q esout punch qout *.gesp *.log *.gjf *.mol2 *.chk *.inpcrd *.frcmod *.prmtop *.in *.gro *.top *.mdp *.txt
dir /b *.pdb > list.txt
set m=1

for /f  "delims="  %%i in (list.txt) do (
echo Molecule %m% is Running..
md %%~ni
copy %%i %%~ni >nul
cd %%~ni
antechamber -i %%i -fi pdb -o lig.gjf -fo gcrt -pf y -gm "%mem=1400MB" -gn "%nproc=4" -nc 0 -gk "# opt B3LYP/6-311G** em=GD3BJ scrf(solvent=water) pop=CHELPG  iop(6/33=2,6/42=6,6/50=1)" >nul 2>nul

rem delete the last blank line in order to match gaussian input format
for /f "tokens=1* delims=[]" %%a in ('find /n /v "" ^< lig.gjf') do (
echo.%%b
) >> temp.gjf
move temp.gjf lig.gjf >nul

rem add somethings for resp
echo lig_ini.gesp >> lig.gjf
echo.>> lig.gjf
echo lig.gesp >> lig.gjf
echo.>> lig.gjf
echo.>> lig.gjf

rem calculation by gaussian09W
echo Starting time: %time%
echo Calculation by gaussian09W...
g09 lig.gjf lig.log
echo Finished time: %time%

rem fit resp by antechamber
echo.
echo Fitting RESP by antechamber...
antechamber -i lig.gesp -fi gesp -o lig.mol2 -fo mol2 -rn LIG -pf y -c resp >nul
echo RESP have been calculated in lig.mol2 file

rem check parameter for GAFF force field
parmchk2 -i lig.mol2 -f mol2 -o lig.frcmod

rem generate AMBER parameters 
echo.
echo Generate AMBER parameters...
echo  source leaprc.gaff >> leap.in
echo  loadamberparams lig.frcmod >> leap.in
echo  lig=loadmol2 lig.mol2 >> leap.in
echo  check lig >> leap.in
echo  saveamberparm lig lig.prmtop lig.inpcrd >> leap.in 
echo  quit >> leap.in
teLeap -f leap.in 

rem trans AMBER into GROMACS file
echo.
echo Transform AMBER into GROMACS file...
acpype -p lig.prmtop -x lig.inpcrd -d 
set /a m+=1
cd ..
)
pause
