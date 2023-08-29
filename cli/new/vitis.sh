#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="$(dirname "$(dirname "$0")")"
MY_PROJECTS_PATH=$($CLI_PATH/common/get_constant $CLI_PATH MY_PROJECTS_PATH)
WORKFLOW="vitis"
TEMPLATE_NAME="hello_world_xrt"

# create my_projects directory
DIR="$MY_PROJECTS_PATH"
if ! [ -d "$DIR" ]; then
    mkdir ${DIR}
fi

# create vitis directory
VITIS_DIR="$MY_PROJECTS_PATH/$WORKFLOW"
if ! [ -d "$VITIS_DIR" ]; then
    mkdir ${VITIS_DIR}
fi

# create project
echo ""
echo "${bold}sgutil new vitis${normal}"
echo ""
echo "${bold}Please, insert a non-existing name for your Vitis project:${normal}"
echo ""
while true; do
    read -p "" project_name
    #project_name cannot start with validate_
    if  [[ $project_name == validate_* ]] || [[ $project_name == "test" ]]; then
        project_name=""
    fi
    DIR="$MY_PROJECTS_PATH/$WORKFLOW/$project_name"
    if ! [ -d "$DIR" ]; then
        break
    fi
done
#echo ""

#add to GitHub if gh is installed
commit="0"
if [[ $(which gh) ]]; then
    echo ""
    echo "${bold}Would you like to add the repository to your GitHub account (y/n)?${normal}"
    while true; do
        read -p "" yn
        case $yn in
            "y") 
                echo ""
                #create GitHub repository and clone directory
                gh repo create $project_name --public --clone
                commit="1"
                break
                ;;
            "n") 
                #create plain directory
                mkdir $DIR
                break
                ;;
        esac
    done
    echo ""
fi

#catch gh repo create error (DIR has not been created)
if ! [ -d "$DIR" ]; then
    echo "Please, start GitHub CLI first using sgutil set gh"
    echo ""
    exit
fi

#prepare for wget (1)
if [ -d "$VITIS_DIR/common" ]; then
    rm -rf "$VITIS_DIR/common"
fi

#prepare for wget (2)
if [ -d "$VITIS_DIR/tmp" ]; then
    rm -rf "$VITIS_DIR/tmp"
fi

#copy files
#echo ""
echo "${bold}Checking out Vitis_Accel_Examples/common:${normal}"
echo ""
wget https://github.com/Xilinx/Vitis_Accel_Examples/archive/master.zip -O $VITIS_DIR/master.zip
mkdir $VITIS_DIR/tmp
unzip -q $VITIS_DIR/master.zip -d $VITIS_DIR/tmp
mv -f $VITIS_DIR/tmp/Vitis_Accel_Examples-master/common $VITIS_DIR
rm -rf $VITIS_DIR/tmp
rm $VITIS_DIR/master.zip
#copy
cp -rf $CLI_PATH/templates/$WORKFLOW/$TEMPLATE_NAME/* $DIR
# we only need makefile_us_alveo.mk (for alveos) and makefile_versal_alveo.mk (for versal)
rm $DIR/makefile_versal_ps.mk
#rm $DIR/makefile_zynq7000.mk
rm $DIR/makefile_zynqmp.mk
# adjust Makefile
sed -i "s/$TEMPLATE_NAME/$project_name/" $DIR/Makefile
sed -i "s/$TEMPLATE_NAME/$project_name/" $DIR/makefile_us_alveo.mk
sed -i "s/$TEMPLATE_NAME/$project_name/" $DIR/makefile_versal_alveo.mk
#delete README
rm $DIR/README.rst
#echo "# $project_name" >> README.md
#compile src
cd $DIR/src
g++ -std=c++17 create_config.cpp -o ../create_config >&/dev/null

#commit files
if [ "$commit" = "1" ]; then 
    cd $DIR
    #update README.md 
    echo "# "$project_name >> README.md
    #add gitignore
    echo ".DS_Store" >> .gitignore
    #add, commit, push
    git add .
    git commit -m "First commit"
    git push --set-upstream origin master
    echo ""
fi

echo "The project ${bold}$VITIS_DIR/$project_name${normal} has been created!"
echo ""