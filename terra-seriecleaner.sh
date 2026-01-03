#!/bin/bash
##################################################
## TeRRaDuDe wiper vers 1.2                     ##
## Wipes diectory that contains tvmaze tags :   ##
## e.g., 'Reality,Game Show'                    ##
##################################################
#
# chmod +x terra-seriecleaner.sh
#
## To Move some Series
# ./terra-serieclearner.sh /path/to/source move /site/tmp "Reality,Game Show"
#
## To Wipe some unwanted series
# ./terra-seriecleaner.sh /path/to/source wipe "Reality,Game Show"
#
########### Changelog ##########################
#
# 1.x Beta idea
# 1.1 First setup Wipe/Move useing tmp dir
# 1.2 Updated Script to Handle Optional Target Directory for wipe Action
#     NOTE: This script will now require the target directory only when the action is move.
#     When the action is wipe, you can omit the target directory, 
#     and the script will process the keywords accordingly.
#
# Note:
#  Please take note that these scripts come without instructions on how to set
#  them up, it is sole responsibility of the end user to understand the scripts
#  function before executing them. If you do not know how to execute them, then
#  please don't use them. They come with no warranty should any damage happen due
#  to the improper settings and execution of these scripts (missing data, etc).
#
#################################################
#     Keep in mind: There is NO undo.           #
#################################################
######## DONT EDIT BELOW THIS LINE ##############
#################################################

# Check if the correct number of arguments are provided
if [ "$#" -lt 3 ] || { [ "$3" == "move" ] && [ "$#" -ne 4 ]; }; then
  echo "Usage: $0 <source_directory> <action> [<target_directory>] <keywords>"
  echo "Action must be 'move' or 'wipe'."
  echo "For 'move' action, you must provide a target directory."
  echo "Keywords should be separated by commas (e.g., 'Reality,Game Show')."
  exit 1
fi

SOURCE_DIR=$1
ACTION=$2
TARGET_DIR=""
KEYWORDS=""

if [ "$ACTION" == "move" ]; then
  TARGET_DIR=$3
  KEYWORDS=$4
else
  KEYWORDS=$3
fi

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
  echo "Source directory does not exist: $SOURCE_DIR"
  exit 1
fi

# Check if action is valid
if [ "$ACTION" != "move" ] && [ "$ACTION" != "wipe" ]; then
  echo "Invalid action: $ACTION"
  echo "Action must be 'move' or 'wipe'."
  exit 1
fi

# Check if target directory exists if action is move, if not create it
if [ "$ACTION" == "move" ] && [ ! -d "$TARGET_DIR" ]; then
  mkdir -p "$TARGET_DIR"
fi

# Convert keywords to array (split by comma)
IFS=',' read -r -a keyword_array <<< "$KEYWORDS"

# Find and process directories containing files with any of the keywords in their names
for keyword in "${keyword_array[@]}"; do
  find "$SOURCE_DIR" -type f -name "*$keyword*" | while read -r file; do
    PARENT_DIR=$(dirname "$file")
    if [ "$ACTION" == "move" ]; then
      echo "Moving directory: $PARENT_DIR"
      mv "$PARENT_DIR" "$TARGET_DIR"
    elif [ "$ACTION" == "wipe" ]; then
      echo "Wiping directory: $PARENT_DIR"
      rm -rf "$PARENT_DIR"
    fi
  done
done

echo "Operation completed."
#eof
