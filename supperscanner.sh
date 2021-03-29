#!/bin/sh
container_name=$1
​
tmp_folder=`dirname "$0"`
tmp_folder=`cd "$tmp_folder" && pwd`
echo "Name of container being scanned: $1"
​
scan_with_os() {
  id="$1"
  os="$2"
  pkg="$3"
  query="$4"
  echo "The OS name is ${os} the package manager is ${pkg}"
  packages="${tmp_folder}/${id}-packages.txt"
  docker run -it --rm ${container_name} ${query} > ${packages}
  cat ${packages}
#  rm ${packages}
}
​
if docker run -it --rm $1 cat /etc/os-release | grep -q 'ID=alpine' -wc; then
    scan_with_os "alpine" "Alpine Linux" "apk" "apk -v info"
fi
​
if docker run -it --rm $1 cat /etc/os-release | grep -q 'ID=debian' -wc; then
    scan_with_os "debian" "Debian" "apt/dpkg" "dpkg-query -W"
fi
​
if docker run -it --rm $1 cat /etc/os-release | grep -q 'ID="rhel"' -wc; then
    scan_with_os "rhel" "Redhat Linux" "yum" "yum list installed"
fi