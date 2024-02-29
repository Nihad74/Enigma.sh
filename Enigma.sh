#!/usr/bin/env bash

main(){
	if [ $# -gt 0 ] && [ "$1" -eq 0 ]
	then
		echo  "Welcome to the Enigma!"
	fi
	printMenu
	read -r input
	case $input in
	1 )
		option1;;
	2 )
		option2;;
	3 )
		option3;;
	4 )
		option4;;
	0 )
		echo "See you later!";;
	* )
		echo -e "Invalid option!\n"
		main
	esac
}

printMenu(){
	echo -e "0. Exit\n1. Create a file\n2. Read a file\n3. Encrypt a file\n4. Decrypt a file\nEnter an option:"
}

option1(){
	echo "Enter the filename:"
	read -r fileName
	pattern="^[a-zA-Z.]+$"
	if [[ "$fileName" =~ $pattern ]]
	then
		echo "Enter a message:"
		read -r message
		messagePattern="^[A-Z ]+$"
		if [[ "$message" =~ $messagePattern ]]
		then
			touch "$fileName"
			echo "$message" > "$fileName"
			echo -e  "The file was created successfully!\n"
			main
		else
			echo -e "This is not a valid message!\n"
			main
		fi
	else
		echo -e "File name can contain letters and dots only!\n"
		main
	fi

}

option2(){
	echo "Enter the filename:"
	read -r fileName
	if [ -f "$fileName" ]
	then
		echo "File content:"
		cat "$fileName"
		main
	else
		echo -e "File not found!\n"
		main
	fi

}

option3(){
	echo  "Enter the filename:"
	read -r filename
	if [ -f "$filename" ]
	then
		tempFile=$(mktemp)
		echo "Enter password:"
		read -r password
		openssl enc -aes-256-cbc -e -pbkdf2 -nosalt -in "$filename" -out "$tempFile" -pass pass:"$password"
		exit_code=$?
		if [[ $exit_code -eq 0 ]]; then
			mv "$tempFile" "${filename}.enc"
			rm "$filename"
			echo "Success"
		else
			echo "Fail"
		fi
	else
		echo "File not found!"
	fi
	main
}

option4(){
	echo  "Enter the filename:"
	read -r filename
	if [ -f "$filename" ]
	then
		tempFile=$(mktemp)
		echo "Enter password"
		read -r password
		new_FileName="${filename/%'.enc'}"
		openssl enc -aes-256-cbc -d -pbkdf2 -nosalt -in "$filename" -out "$tempFile" -pass pass:"$password" &>/dev/null
		exit_code=$?
		if [[ $exit_code -eq 0 ]]
		then
               		mv "$tempFile" "$new_FileName"
			rm "$filename"
			echo "Success"
		else
			echo "Fail"
		fi
	else
		echo "File not found!"
	fi
	main
}


main 0

