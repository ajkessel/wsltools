#!/bin/bash
if [ "$EUID" -ne 0 ]
then echo "Please run as root (e.g. sudo $0)"
  exit 0
fi
if [ ! -d "/etc/binfmt.d" ] || ( ! grep -iq 'interop' /etc/wsl.conf )
then
  echo 'binfmt_misc and wslinterop do not appear to be enabled'
  echo 'Please see "Interop settings" at https://learn.microsoft.com/en-us/windows/wsl/wsl-config'
  exit 1
fi
script=$(readlink -f "${0}")
scriptPath=$(dirname "${script}")

files=( office.conf office-wrapper powershell.conf powershell-wrapper wsl.conf wslshim wsl-wrapper )
for i in "${files[@]}"
do
  if [ ! -e "${scriptPath}/${i}" ]
  then
    echo "${i} is missing, exiting"
    exit 1
  fi
done

fail() {
  echo copy failed, something went wrong
  exit 1
}

echo -n 'Install wsl-wrapper to enable runnning windows executables with WSL paths? (Y/n) '
read check
if [[ "${check,,}" == "y"* ]] || [ -z "${check}" ]
then
  cp "${scriptPath}/wsl.conf" "/etc/binfmt.d" || fail
  cp "${scriptPath}/wsl-wrapper" "/usr/local/bin" || fail
  chmod a+rx "/usr/local/bin/wsl-wrapper" || fail
fi
unset check
echo -n 'Install powershell-wrapper to enable runnning PowerShell scripts directly (e.g., myscript.ps1)? (Y/n) '
read check
if [[ "${check,,}" == "y"* ]] || [ -z "${check}" ]
then
  cp "${scriptPath}/powershell.conf" "/etc/binfmt.d" || fail
  cp "${scriptPath}/powershell-wrapper" "/usr/local/bin" || fail
  chmod a+rx "/usr/local/bin/powershell-wrapper" || fail
fi
unset check
echo -n 'Install office-wrapper to enable runnning office documents directly (e.g., mydocument.docx)? (Y/n) '
read check
if [[ "${check,,}" == "y"* ]] || [ -z "${check}" ]
then
  cp "${scriptPath}/office.conf" "/etc/binfmt.d" || fail
  cp "${scriptPath}/office-wrapper" "/usr/local/bin" || fail
  chmod a+rx "/usr/local/bin/office-wrapper" || fail
fi
echo Restarting system-binfmt...
systemctl restart systemd-binfmt
