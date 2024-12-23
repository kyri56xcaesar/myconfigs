#!/bin/bash


# Regular Colors
declare -A colors=(
  ["Black"]='\033[0;30m' ["Red"]='\033[0;31m' ["Green"]='\033[0;32m' ["Yellow"]='\033[0;33m'
  ["Blue"]='\033[0;34m' ["Purple"]='\033[0;35m' ["Cyan"]='\033[0;36m' ["White"]='\033[0;37m'
  ["BBlack"]='\033[1;30m' ["BRed"]='\033[1;31m' ["BGreen"]='\033[1;32m' ["BYellow"]='\033[1;33m'
  ["BBlue"]='\033[1;34m' ["BPurple"]='\033[1;35m' ["BCyan"]='\033[1;36m' ["BWhite"]='\033[1;37m'
  ["UBlack"]='\033[4;30m' ["URed"]='\033[4;31m' ["UGreen"]='\033[4;32m' ["UYellow"]='\033[4;33m'
  ["UBlue"]='\033[4;34m' ["UPurple"]='\033[4;35m' ["UCyan"]='\033[4;36m' ["UWhite"]='\033[4;37m'
  ["On_Black"]='\033[40m' ["On_Red"]='\033[41m' ["On_Green"]='\033[42m' ["On_Yellow"]='\033[43m'
  ["On_Blue"]='\033[44m' ["On_Purple"]='\033[45m' ["On_Cyan"]='\033[46m' ["On_White"]='\033[47m'
  ["IBlack"]='\033[0;90m' ["IRed"]='\033[0;91m' ["IGreen"]='\033[0;92m' ["IYellow"]='\033[0;93m'
  ["IBlue"]='\033[0;94m' ["IPurple"]='\033[0;95m' ["ICyan"]='\033[0;96m' ["IWhite"]='\033[0;97m'
  ["BIBlack"]='\033[1;90m' ["BIRed"]='\033[1;91m' ["BIGreen"]='\033[1;92m' ["BIYellow"]='\033[1;93m'
  ["BIBlue"]='\033[1;94m' ["BIPurple"]='\033[1;95m' ["BICyan"]='\033[1;96m' ["BIWhite"]='\033[1;97m'
  ["On_IBlack"]='\033[0;100m' ["On_IRed"]='\033[0;101m' ["On_IGreen"]='\033[0;102m' ["On_IYellow"]='\033[0;103m'
  ["On_IBlue"]='\033[0;104m' ["On_IPurple"]='\033[0;105m' ["On_ICyan"]='\033[0;106m' ["On_IWhite"]='\033[0;107m' ["UBBlue"]='\033[1;4;34m'
)

color_text() {
  local text="$1"
  local color="$2"
  local Color_Off='\033[0m'

  # Check if the color exists in the colors array
  if [[ -n "${colors[$color]}" ]]; then
    echo -en "${colors[$color]}$text${Color_Off}"
  else
    echo "Color '$color' not recognized. Available colors are: ${!colors[@]}"
  fi
}







 










echo "--------------------------"
color_text "Hello " "White" 
color_text "$USER" "Red" 
echo " !"
echo $(date) 
echo "--------------------------"

echo ""
echo ""


host=$(hostname)
directory="$1"

declare -A confPaths=(
	["hypr"]=~/.config/hypr ["kitty"]=~/.config/kitty ["nvim"]=~/.config/nvim ["waybar"]=~/.config/waybar [".bashrc"]=~/.bashrc [".zshrc"]=~/.zshrc
)

function transferConfigs() {
	
	if test -d $directory; then

		for config in "${!confPaths[@]}"; do
      
      if [ -f ${confPaths[$config]} ]; then
  			color_text "$config" "UGreen"
	 		echo ""
		 	cp -r "${confPaths[$config]}" "$directory/$config"
      elif [ -d ${confPaths[$config]} ]; then
        color_text "$config" "BGreen"
        echo ""
        cp -r "${confPaths[$config]}" "$directory/$config"
      else
        color_text "$config" "Red"
        echo ""
      fi
		done
	fi 
}

function promptDirectory() {

	for dir in $(ls -d */ --color=auto); do 
		dir_name="${dir%/}"

		if [[ "$dir_name" == "$host" ]]; then
			color_text "$dir_name" "UBBlue"
		else 
			color_text "$dir_name" "BBlue"
		fi 

		echo -n " "
	done

	echo -en "\nWhich directory to update?\n-> "
	read directory

	if [ "$directory" = "" ] || [ "$directory" = "\n" ]; then
		directory=$host
	fi

	echo -n "Dir is: "
	color_text "$directory" "Blue"
	echo ""

	if test -d $directory; then
		echo "Exists... Transferring data..."
		echo ""

	else 
		echo "Directory does not exist..."
		exit
	fi

}

if [[ -z "$1" ]]; then
	promptDirectory
fi


transferConfigs



function gitAddCommitPush() {

  	local answer=""
  	echo -e "\n"
  	color_text "Want to commit and push on git repo?[y/N] " "BCyan"

  	read answer

	if [[ $answer =~ "y" ]]; then
		

    	git add "$directory"/
		git add "./update.sh"
   	git commit -m "updated configs"
    	git push origin master
    	echo -e "\n"
  	else
    	color_text "OK. Finished." "Red"
	 	echo ""
  	fi

}


gitAddCommitPush





