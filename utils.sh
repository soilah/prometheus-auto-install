source ./env.sh

check_root() {
	if [ $(whoami) != "root" ]; then
		error "Installer must be run as root. Exiting"
		exit
	else
		ok "Running as root user..."
	fi
}

check_user() {
	USER=$1
	id $USER &> /dev/null

	if [ $? -eq 0 ]; then
		info "prometheus user already exists. Continuing."
	else
		info "Creating prometheus user..."
		adduser --no-create-home --disabled-login --shell /bin/false --comment "Prometheus" prometheus
		ok "User created sucessfully"
	fi
}

check_package() {
	PACKAGE=$1
	dpkg -s $PACKAGE &> /dev/null

	if [ $? -eq 0 ]; then
		ok "$PACKAGE is installed..."
	else
		info "$PACKAGE not found. Installing..."
		apt-get install $PACKAGE -y
		ok "Done"
	fi
}
