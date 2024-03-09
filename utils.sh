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
		info "$USER user already exists. Continuing."
	else
		info "Creating $USER user..."
		adduser --no-create-home --disabled-login --shell /bin/false --comment "$USER user" $USER &> /dev/null
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

#### This function checks if PACKAGE binary exists on PATH if MODE 
#### is 'exists' and if PACKAGE is absent on PATH if MODE is
#### 'absent'.

check_local_package() {
	PACKAGE=$1
	MODE=$2
	which $PACKAGE &> /dev/null
	STATUS=$?
	if [ $STATUS -ne 0 ] && [ ${MODE} = 'absent' ] ; then
		error "Package $PACKAGE is not installed or not in PATH"
		exit
	elif [ $STATUS -eq 0 ] && [ ${MODE} = 'exists' ]; then
		error "Package $PACKAGE is already installed on: $(which $PACKAGE)"  
		exit
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
