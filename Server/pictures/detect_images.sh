#!/bin/sh
#open /Users/jue/Sites/pictures/activation_test.app






filename="/Users/jue/Sites/pictures/images/flag.txt"

while true
do
if [[ -f $filename ]]; then
echo "Generating model..."
# convert photo
convert /Users/jue/Sites/pictures/output/output_image/temp.png -gravity center -crop 3000x3000+0+0 /Users/jue/Sites/pictures/output/output_image/temp.png

time_curr=$(date "+%Y-%m-%d-%H_%M_%S")
/Users/jue/Library/Developer/Xcode/DerivedData/HelloPhotogrammetry-bjbyvpthwdpdzjfojmcoqzppfhlz/Build/Products/Debug/HelloPhotogrammetry /Users/jue/Sites/pictures/images/ /Users/jue/Sites/pictures/output/output_model/$time_curr.usdz


# detect if model exist
model_name="/Users/jue/Sites/pictures/output/output_model/$time_curr.usdz"
if [[ -f $model_name ]]; then
    echo "Model done"

    mv /Users/jue/Sites/pictures/output/output_image/temp.png "/Users/jue/Sites/pictures/output/output_image/$time_curr.png"
else
    echo "Not enough pictures"
fi

# delete
rm -rf /Users/jue/Sites/pictures/images/*

echo "Done"

fi 

echo "No file"

sleep 10
done

