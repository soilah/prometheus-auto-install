source ./env.sh

#### Check if current user is root. If not exits the program.

check_root() {
	if [ $(whoami) != "root" ]; then
		error "Installer must be run as root. Exiting"
		exit
	else
		ok "Running as root user..."
	fi
}

#### Check if user exists. If not it is created.

check_user() {
	USER=$1
	id $USER &> /dev/null

	if [ $? -eq 0 ]; then
		info "prometheus user already exists. Continuing."
	else
		info "Creating prometheus user..."
		adduser --no-create-home --disabled-login --shell /bin/false --comment "Prometheus" prometheus &> /dev/null
		ok "User created sucessfully"
	fi
}


#### Checks if a package is installed. If not it is installed.

check_package() {
	PACKAGE=$1
	dpkg -s $PACKAGE &> /dev/null

	if [ $? -eq 0 ]; then
		ok "$PACKAGE is installed..."
	else
		info "$PACKAGE not found. Installing..."
		apt-get install $PACKAGE -y &> /dev/null
		if [ $? -eq 0 ]; then
			ok "Done"
		else
			error "Failed to install package."
			exit
		fi
	fi
}


#### Runs a command and checks if it run without error.
#### Eval is used in order to think $1 string as a command with arguments.

run_notify() {
	PROGRAM=$1
	eval $PROGRAM &> /dev/null
	if [ $? -ne 0 ]; then
		error "$PROGRAM did not run sucessfully. Exiting."
		exit
	fi
}
