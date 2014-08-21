
function rpmqa() {
  rpm -qa --queryformat '%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH}\n' $@ | sort
}

